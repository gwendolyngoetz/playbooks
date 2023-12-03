#!/bin/bash

pushd "$(git rev-parse --show-toplevel)" > /dev/null || exit

role="${1}"
verbose="${2}"
rollback_snapshot="${3:-true}"

ansible_installed=$(which ansible-playbook > /dev/null; echo $?)

if [ "${ansible_installed}" != 0 ]; then
  echo "ansible-playbook is not installed or on the path"
  exit 1
fi

if [[ -z "${role}" ]]; then
    echo "Available roles"
    echo "-------------------"
    for entry in roles/*; do 
        filename="${entry##*/}"
        echo "- ${filename%.*}"
    done    
    exit 1
fi

# ------------------------------------
# Rollback VM State
# ------------------------------------
if [[ "${rollback_snapshot}" == "true" ]]; then
  node="nyx"
  vmid="200"
  snapshot="before-running-playbooks"
  auth_header="Authorization: PVEAPIToken=${PROXMOX_API_TOKEN_ID}=${PROXMOX_API_SECRET}"
  base_uri="https://${node}.goetz.casa:8006/api2/json"
  vm_hostname="ansible-target"
  
  echo "Rolling back ${vm_hostname} to "${snapshot}
  rollback_uri="${base_uri}/nodes/${node}/qemu/${vmid}/snapshot/${snapshot}/rollback?start=1"
  curl -s --header "${auth_header}" -X POST "${rollback_uri}" > /dev/null
  
  status_uri="${base_uri}/nodes/${node}/qemu/${vmid}/status/current"
  
  sleep 1
  
  echo -n "vm booting"
  while [[ "$(curl -s --header "${auth_header}" "${status_uri}" | jq -r '.data.status')" != "running" ]]; do
      echo -n "."
      sleep 0.5
  done
  
  while [[ "$(ssh -o ConnectTimeout=1 "${vm_hostname}" "runlevel" > /dev/null 2> /dev/null; echo $?)" != "0" ]]; do
      echo -n "."
      sleep 0.5
  done
  
  echo
  echo "vm running"
fi

# ------------------------------------
# Make temp playbook for role
# ------------------------------------
temp_playbook_file="$(mktemp playbooks/.playbook_temp.XXXXXXXXXX.yml)"
echo "---
- name: Temp Playbook For ${role}
  hosts: new
  become_user: root
  vars_files:
    - ../vars/vault.yml
  roles:
    - ${role}" > "${temp_playbook_file}"


echo "Temp playbook create: ${temp_playbook_file}"
echo "------------------------------------"
cat "${temp_playbook_file}"
echo "------------------------------------"
echo

# ------------------------------------
# Run role
# ------------------------------------

cmds=()

if [[ "${verbose}" == "verbose" ]]; then
    cmds=(-vvv)
fi

ansible-playbook \
    -i hosts.test.vm \
    --vault-password-file ./vars/vault.pw \
    --become-password-file ./vars/vault.pw \
    "${cmds[@]}" \
    "${temp_playbook_file}"


# ------------------------------------
# Clean up temp file
# ------------------------------------
rm "${temp_playbook_file}"

