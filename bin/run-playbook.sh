#!/bin/bash

pushd "$(git rev-parse --show-toplevel)" > /dev/null || exit

playbook="${1}"
verbose="${2}"

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
        echo "- ${filename%.*}"
    done    
    exit 1
fi

cmds=()

if [[ "${verbose}" == "verbose" ]]; then
    cmds=(-vvv)
fi

ansible-playbook "${cmds[@]}" -K -i hosts "./playbooks/${playbook}.yml" --vault-password-file ./vars/vault.pw

