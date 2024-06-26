#!/bin/bash

pushd "$(git rev-parse --show-toplevel)" > /dev/null || exit

role="${1}"
command="${2:-test}"
distro="${3:-ubuntu2404}"

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

DISTRO=${distro} ANSIBLE_VAULT_PASSWORD_FILE="$(pwd)/vars/vault.test.pw" molecule "${command}" --scenario-name "${role}"

