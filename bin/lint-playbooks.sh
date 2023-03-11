#!/bin/bash

pushd "$(git rev-parse --show-toplevel)" >> /dev/null || exit

find ./playbooks \
    -type f \
    -name '*.yml' \
    ! -name 'windows.yml' \
    -exec ansible-lint {} \+
