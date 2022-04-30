#!/bin/sh

sudo apt install ansible

ansible-playbook -K -i hosts ./plays/work.yml
