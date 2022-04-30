#!/bin/sh

playbook="${1}"

if [[ -z "${playbook}" ]]; then
    echo "Available playbooks"
    echo "-------------------"
    for entry in playbooks/*; do 
        filename="${entry##*/}"
        echo "- ${filename%.*}"
    done    
    exit 1
fi


ansible-playbook -K -i hosts ./playbooks/${playbook}.yml

