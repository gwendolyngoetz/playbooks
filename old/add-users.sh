#!/bin/sh

ansible-playbook --extra-vars @vars/vault.yml --ask-vault-pass -K -i hosts playbooks/add-users.yml
