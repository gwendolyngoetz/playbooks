#!/bin/sh

ansible-playbook -K -i hosts playbooks/setup-server.yml
