#!/bin/bash

# Define ASCI colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Define a temporary file to store command output
temp_output=$(mktemp)

packages=(
    "golang"
    "rust-all"
    ""
)

print_message() {
    local log_type="$1"
    local message="$2"

    case "$log_type" in
        ok)
            echo -e "${GREEN}[OK] $message${NC}"
            ;;
        warn)
            echo -e "${YELLOW}[WARN] $message${NC}"
            ;;
        error)
            echo -e "${RED}[ERROR] $message${NC}"
            ;;
        *)
            echo -e "${NC}[INFO] $message"
            ;;
    esac
}

print_error_output() {
    while IFS= read -r line; do
        echo -e "${RED}${line}${NC}"
    done < "$temp_output"
}

# Function to execute a command and handle errors
exec() {
    local command="$1"
    eval "$command" 2>> "$temp_output"

    if [ $? -ne 0 ]; then
        print_message error "Failed to execute '$command' command:"
        print_error_output
        rm "$temp_output"
        exit 1
    fi
}