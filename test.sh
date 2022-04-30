#!/bin/sh

ansible-playbook -K -i hosts ./playbooks/test.yml
