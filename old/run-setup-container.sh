#!/bin/sh

ansible-playbook -K -i hosts playbooks/setup-container.yml
