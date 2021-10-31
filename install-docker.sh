#!/bin/sh

ansible-playbook -K -i hosts playbooks/install-docker.yml
