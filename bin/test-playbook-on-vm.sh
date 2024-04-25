#!/bin/bash

pushd "$(git rev-parse --show-toplevel)" > /dev/null || exit

playbook="${1}"
verbose="${2}"
rollback_snapshot="${3:-true}"

ansible_installed=$(which ansible-playbook > /dev/null; echo $?)

if [ "${ansible_installed}" != 0 ]; then
  echo "ansible-playbook is not installed or on the path"
  exit 1
fi

if [[ -z "${playbook}" ]]; then
    echo "Available playbooks"
    echo "-------------------"
    for entry in playbooks/*; do 
        filename="${entry##*/}"
        playbook_name="${filename%.*}"

        if [[ "${playbook_name}" == "macos" || "${playbook_name}" == "windows" ]]; then
           continue 
        fi
    
        echo "- ${playbook_name}"
    done    
    exit 1
fi


# ------------------------------------
# Rollback VM State
# ------------------------------------
if [[ "${rollback_snapshot}" == "true" ]]; then
  node="nyx"
  vmid="201"
  snapshot="before-running-playbooks"
  auth_header="Authorization: PVEAPIToken=${PROXMOX_API_TOKEN_ID}=${PROXMOX_API_SECRET}"
  base_uri="https://${node}.goetz.casa:8006/api2/json"
  vm_hostname="ansible-target-2404"
  
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
# Run playbook
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
    "./playbooks/${playbook}.yml"
