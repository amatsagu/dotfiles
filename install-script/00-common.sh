#!/bin/bash

purple=$(tput setaf 5)
cyan=$(tput setaf 6)
gold=$(tput setaf 3)
green=$(tput setaf 2)
red=$(tput setaf 1)
color_reset=$(tput sgr0)

# Order: <question> <callback variable>
choice() {
    local response
    while true; do
        read -p " PROMPT: $1 (y/n): " -r response
        echo
        case "$response" in
            [Yy]* ) eval "$2=y"; return 1;;
            [Nn]* ) eval "$2=n"; return 0;;
            * ) echo "$red ERROR:$color_reset Please answer with Y/y or N/n."; echo;;
        esac
    done
}

# Order: <question> <options (for example: "js, ts, py, rs, go")> <callback variable>
multi_choice() {
    while true; do
        read -p " PROMPT: $1 ($2): " choice
        echo
        if [[ " $2 " == *" $choice, "* ]]; then
            eval "$3='$choice'"
            return 0
        else
            echo "$red ERROR:$color_reset Please choose one of the provided options: $2"
            echo
        fi
    done
}

is_laptop() {
    if [ -f /sys/module/battery/initstate ] || [ -d /proc/acpi/battery/BAT0 ]; then
        eval "$1=y"
        return 1
    fi

    eval "$1=f"
    return 0
}

is_laptop using_laptop