#!/usr/bin/env bash

# shellcheck disable=SC1091
set -e

# verify not running as root
if (( "${EUID}" == 0 )); then
    echo "[X] Must NOT run as root."
    exit 1
fi

# allow the script to be called from anywhere, and still work by pushd'ing into the script directory first
script_file_path="$(realpath "${0}")"
script_dir_path="$(dirname "${script_file_path}")"
pushd "${script_dir_path}" > /dev/null

source ./_libs/lib_base.sh

status_echo "==== Post-Install Setup ===="
# setup ansible
pushd ./scripts
sudo ./setup_ansible.sh
sudo ./setup_snap.sh
popd

# run ansible playbooks
sudo ansible-playbook -i "localhost," -c local ./ansible/playbooks/install_all_apps.yml
popd

# tilix configuration
status_echo "==== Configuring tilix ===="
tilix_config_path="${HOME}/.config/tilix/schemes"
mkdir -p "${tilix_config_path}"
cp ./configs/elemental.json "${tilix_config_path}"

# done
status_echo "==== Post-Install Setup COMPLETE ===="
