#!/bin/sh

sudo apt install ansible

ansible-playbook -K -i hosts ./work.yml
