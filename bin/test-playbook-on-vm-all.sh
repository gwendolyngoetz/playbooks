#!/bin/bash

pushd "$(git rev-parse --show-toplevel)" > /dev/null || exit

for entry in playbooks/*; do 
    filename="${entry##*/}"
    playbook_name="${filename%.*}"
    if [[ "${playbook_name}" == "macos" || "${playbook_name}" == "windows" ]]; then
       continue 
    fi
    
    bin/test-playbook-on-vm.sh "${playbook_name}"
done    
