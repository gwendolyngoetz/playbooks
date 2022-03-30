#!/bin/sh

ansible-playbook -K -i hosts ./site.yml

#ansible-playbook -v -K -i hosts ./site.yml
