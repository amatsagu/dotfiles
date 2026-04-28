#!/usr/bin/env bash

# Detect UTF-8 support
if [ "$(locale charmap 2>/dev/null)" = "UTF-8" ]; then
    # Unicode characters
    SYM_INFO="➜"
    SYM_WARN="⚠"
    SYM_ERR="✗"
    SYM_SUCC="✓"
    SYM_QUEST="?"
    SPINNER_SEQ=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    BORDER_TOP="."
    BORDER_MID="|"
    BORDER_BOT="'"
    BORDER_HORZ="-"
else
    # ASCII fallbacks
    SYM_INFO=">"
    SYM_WARN="!"
    SYM_ERR="x"
    SYM_SUCC="v"
    SYM_QUEST="?"
    SPINNER_SEQ=("-" "\\" "|" "/")
    BORDER_TOP="."
    BORDER_MID="|"
    BORDER_BOT="'"
    BORDER_HORZ="-"
fi

# Colors (using tput for maximum compatibility)
if command -v tput >/dev/null; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    CYAN=$(tput setaf 6)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    RESET='\033[0m'
fi

SYM_INFO="${BOLD}${BLUE}${SYM_INFO}${RESET}"
SYM_WARN="${BOLD}${YELLOW}${SYM_WARN}${RESET}"
SYM_ERR="${BOLD}${RED}${SYM_ERR}${RESET}"
SYM_SUCC="${BOLD}${GREEN}${SYM_SUCC}${RESET}"
SYM_QUEST="${BOLD}${BLUE}${SYM_QUEST}${RESET}"

__log() {
    printf " %s %s\n" "$1" "$2"
}

info() { __log "$SYM_INFO" "$1"; }
warning() { __log "$SYM_WARN" "$1"; }
error() { __log "$SYM_ERR" "$1"; }
success() { __log "$SYM_SUCC" "$1"; }
question() { __log "$SYM_QUEST" "$1"; }

banner() {
    local msg="$1"
    local color="${2:-CYAN}"
    local color_code="${!color}"
    local msg_length=${#msg}
    local border_length=$((msg_length + 8))
    
    # Build borders
    local border_top="${BORDER_TOP}$(printf "%${border_length}s" "" | tr ' ' "${BORDER_HORZ}")${BORDER_TOP}"
    local border_mid="${BORDER_MID}    ${msg}    ${BORDER_MID}"
    local border_bot="${BORDER_BOT}$(printf "%${border_length}s" "" | tr ' ' "${BORDER_HORZ}")${BORDER_BOT}"
    
    # Apply color
    echo -e "${color_code}${BOLD}${border_top}${RESET}"
    echo -e "${color_code}${BOLD}${border_mid}${RESET}"
    echo -e "${color_code}${BOLD}${border_bot}${RESET}"
}

__spinner() {
    local pid=$!
    local delay=0.15
    local spin_idx=0
    local text="$1"
    
    tput civis 2>/dev/null
    echo ""
    
    while kill -0 "$pid" 2>/dev/null; do
        printf "\033[1A\033[K"
        printf " %s %s\n" "${SPINNER_SEQ[$spin_idx]}" "$text"
        spin_idx=$(( (spin_idx + 1) % ${#SPINNER_SEQ[@]} ))
        sleep "$delay"
    done
    
    # Clean up and show cursor
    printf "\033[1A\033[K"
    tput cnorm 2>/dev/null
    
    # Return command's exit code
    wait "$pid"
    return $?
}

confirm() {
    local prompt="$1"
    local default="${2:-false}"
    local options="[y/N]"
    
    [ "$default" = true ] && options="[Y/n]"
    
    while true; do
        echo -n " ${SYM_QUEST} ${prompt} ${options} "
        read -r response
        
        case "${response,,}" in
            y|yes) return 0 ;;
            n|no)  return 1 ;;
            "")
                [ "$default" = true ] && return 0 || return 1 ;;
            *) 
                error "Please answer y or n." ;;
        esac
    done
}

# Global cleanup trap
LOG_FILE=$(mktemp)

__cleanup() {
    tput cnorm 2>/dev/null
    [ -f "$LOG_FILE" ] && rm -f "$LOG_FILE"
}
trap __cleanup EXIT SIGINT SIGTERM

run_command() {
    local cmd="$1"
    local desc="$2"
    local hint="$3"
    local output_file=$(mktemp)
    local exit_code=0

    # Capture output for logging/debugging
    ($cmd > "$output_file" 2>&1) & __spinner "$desc"
    exit_code=$?

    if [ $exit_code -ne 0 ]; then
        echo
        error "Failure: $desc"
        
        if [ -n "$hint" ]; then
            info "Mitigation Hint: $hint"
        fi

        if [ -s "$output_file" ]; then
            warning "Relevant output from the failed command:"
            sed 's/^/   /' "$output_file"
        fi

        if [ "$IGNORE_ERRORS" = "false" ]; then
            if ! confirm "Continue despite this failure?"; then
                rm -f "$output_file"
                error "Installation aborted by user."
                exit $exit_code
            fi
        fi
    fi

    rm -f "$output_file"
    return $exit_code
}