#!/usr/bin/env bash

# shellcheck disable=SC1091
set -e

script_file_path="$(realpath "${0}")"
script_dir_path="$(dirname "${script_file_path}")"

pushd "${script_dir_path}" > /dev/null

source ../_libs/lib_base.sh

check_root

status_echo "---- Installing Ansible ----"
pkg_install ansible cowsay
sed -i "s/^#log_path/log_path/" /etc/ansible/ansible.cfg

status_echo "---- Ansible Setup COMPLETE ----"
