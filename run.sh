#!/bin/bash

playbook="${1}"
verbose="${2}"

if [[ -z "${playbook}" ]]; then
    echo "Available playbooks"
    echo "-------------------"
    for entry in playbooks/*; do 
        filename="${entry##*/}"
        echo "- ${filename%.*}"
    done    
    exit 1
fi

if [[ "${verbose}" == "verbose" ]]; then
    ansible-playbook -vvv -K -i hosts ./playbooks/${playbook}.yml
else
    ansible-playbook -K -i hosts ./playbooks/${playbook}.yml
fi
