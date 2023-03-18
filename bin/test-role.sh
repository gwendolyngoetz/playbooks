#!/bin/bash

pushd "$(git rev-parse --show-toplevel)" > /dev/null || exit

role="${1}"
distro="${2}"


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

MOLECULE_DISTRO=${distro} ANSIBLE_VAULT_PASSWORD_FILE=./vars/vault.test.pw molecule test --scenario-name "${role}"


