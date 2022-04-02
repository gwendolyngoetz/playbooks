#!/bin/sh

ansible-playbook -K -i hosts ./desktop.yml

#ansible-playbook -v -K -i hosts ./desktop.yml
