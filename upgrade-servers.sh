#!/bin/sh

ansible-playbook -K -i hosts playbooks/upgrade-servers.yml
