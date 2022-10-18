#!/bin/bash

role="${1}"

molecule_installed=$(which molecule > /dev/null; echo $?)

if [ "${molecule_installed}" != 0 ]; then
  echo "molecule_installed is not installed or on the path"
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

ANSIBLE_VAULT_PASSWORD_FILE=./vars/vault.pw molecule test --scenario-name ${role}
