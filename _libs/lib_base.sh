#!/usr/bin/env bash

set -e

timestamp="$(date +%Y%m%d-%H%M%S)"
export timestamp

function pushd {
    command pushd "$@" > /dev/null
}

function popd {
    command popd > /dev/null
}

function check_root {
    # ensure commands are being executed as root.
    if (( ${EUID} != 0 )); then
        echo "[X] Must run as root"
        exit 1
    fi
}

function echo_blanks {
    # echos number of blank lines indicated by input
    local num_lines

    # strip non-numbers from input
    num_lines="${1//[^0-9]/}"

    if [[ -z "${num_lines}" ]]; then
        num_lines=0
    fi

    if [[ "${num_lines}" -ne 0 ]]; then
        for ((i=0; i<${num_lines}; i++)); do
            echo ""
        done
    fi
}

function status_echo {
    # echos in inverted colors
    echo_blanks "${2}"
    echo -e "\e[7m${1} \e[0m"
    echo_blanks "${3}"
}

function warn_echo {
    # echos text as white on a red background
    echo_blanks "${2}"
    echo -e "\e[97m\e[41m${1} \e[0m"
    echo_blanks "${3}"
}

function cyan_echo {
    # echos text in cyan to stand out
    echo_blanks "${2}"
    echo -e "\e[96m\e[40m${1} \e[0m"
    echo_blanks "${3}"
}

function press_any {
    # press any key prompt
    local press_any_text="${1-"Press any key 
    to continue..."}"
    echo -ne "\e[96m"
    read -n 1 -s -r -p "${press_any_text}"
    echo -e "\e[0m"
}

function pkg_install {
    check_root

    apt-get update || {
        warn_echo "Error updating apt."
        warn_echo "Exiting..."
        exit 1
    }

    DEBIAN_FRONTEND=noninteractive apt-get install -y "${@}" || {
        warn_echo "Error installing requested package(s)"
        warn_echo "Exiting..."
        exit 1
    }
}

function pkg_remove {
    check_root
    apt-get autoremove -y "${@}" || {
        WarningEcho "Error removing requested package(s). 'apt-get install' error code: ${?}"
        WarningEcho "Exiting..."
        exit 1
    }
}
