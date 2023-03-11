[![Lint](https://github.com/gwendolyngoetz/playbooks/actions/workflows/lint.yml/badge.svg)](https://github.com/gwendolyngoetz/playbooks/actions/workflows/lint.yml)

# Playbooks

Ansible playbooks

## Run Script

`bin/run-playbook.sh [playbook-name]`

- Without parameters list available playbooks
- With parameters run playbook

## Playbooks

| Name             | Description |
| ---------------- | ----------- |
| basic-server     |             |
| hello-world      |             |
| linux-i3-desktop |             |
| mac              |             |
| upgrade-server   |             |

## Roles

| Name            | Description                                     |
| --------------- | ----------------------------------------------- |
| add-users       | Add my user account                             |
| applications    | Installs desktop applications                   |
| base-desktop    | Installs desktop applications                   |
| base-os         | Setup and installs common terminal applications |
| basic-server    | Configure common server settings                |
| desktop-i3wm    | Installs i3wm and related tools                 |
| docker          | Installs docker                                 |
| docker-rootless | Configures docker for rootless mode             |
| hello-world     | Hello World for testing                         |
| hestia          | Specific settings for specific pc               |
| macos           | Setup and Install for Mac OS                    |
| neovim          | Installs Neovim                                 |
| sdks            | Installs SDKs                                   |
| upgrade-server  | Perform OS Software Upgrades                    |
| windows         | Setup and Install for Windows PC                |

## Tags

- apps
- desktop
- dev
- hestia
- system

## Testing

Using [molecule](https://molecule.readthedocs.io) to test roles

`bin/test-role.sh [role-name]`

- Without parameters list available roles
- With parameters run role

### Example

`ANSIBLE_VAULT_PASSWORD_FILE=./vars/vault.pw molecule test --scenario-name add-users`
