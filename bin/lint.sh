#!/bin/bash

pushd "$(git rev-parse --show-toplevel)" > /dev/null || exit

fix_lint_errors="${1:-none}"
cmds=()

if [[ -n "${fix_lint_errors}" ]]; then
    cmds=(--fix "${fix_lint_errors}")
fi

ansible-lint "${cmds[@]}" ./roles/*

