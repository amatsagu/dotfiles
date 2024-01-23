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
        read -p "PROMPT: $1 (y/n): " -r response
        case "$response" in
            [Yy]* ) eval "$2=1"; return 1;;
            [Nn]* ) eval "$2=0"; return 0;;
            * ) echo "Please answer with Y/y or N/n.";;
        esac
    done
}

# Order: <question> <options (for example: "js, ts, py, rs, go")> <callback variable>
multi_choice() {
    while true; do
        read -p "PROMPT: $1 ($2): " choice
        if [[ " $2 " == *" $choice, "* ]]; then
            eval "$3='$choice'"
            return 0
        else
            echo "Please choose one of the provided options: $2"
        fi
    done
}