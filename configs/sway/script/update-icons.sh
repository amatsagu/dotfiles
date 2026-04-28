#!/usr/bin/env bash

# Get hex color from argument (e.g. #ff0000)
HEX="${1#\#}"
BEST_COLOR="magenta"

# Fallback to yellow if no color provided
if [ -z "$HEX" ]; then
    papirus-folders -u -C "$BEST_COLOR" --theme Papirus-Dark &> /dev/null
    exit 0
fi

# Convert hex to RGB
read -r R G B <<< "$(printf "%d %d %d" "0x${HEX:0:2}" "0x${HEX:2:2}" "0x${HEX:4:2}")"

# Define Papirus colors and their representative RGB values
declare -A PAPIRUS_COLORS
PAPIRUS_COLORS=(
    ["adwaita"]="93 163 218"
    ["black"]="74 74 74"
    ["blue"]="82 148 226"
    ["bluegrey"]="96 125 139"
    ["breeze"]="61 174 233"
    ["brown"]="152 118 84"
    ["carmine"]="165 42 42"
    ["cyan"]="0 188 212"
    ["darkcyan"]="0 139 139"
    ["deeporange"]="255 87 34"
    ["green"]="76 175 80"
    ["grey"]="158 158 158"
    ["indigo"]="63 81 181"
    ["magenta"]="233 30 99"
    ["nordic"]="129 161 193"
    ["orange"]="255 152 0"
    ["palebrown"]="215 204 200"
    ["paleorange"]="255 204 128"
    ["pink"]="240 98 146"
    ["red"]="244 67 54"
    ["teal"]="0 150 136"
    ["violet"]="103 58 183"
    ["white"]="255 255 255"
    ["yaru"]="233 84 32"
    ["yellow"]="255 235 59"
)

MIN_DIST=999999

for COLOR in "${!PAPIRUS_COLORS[@]}"; do
    read -r PR PG PB <<< "${PAPIRUS_COLORS[$COLOR]}"
    
    # Calculate Euclidean distance squared
    DIST=$(( (R - PR)**2 + (G - PG)**2 + (B - PB)**2 ))
    
    if [ $DIST -lt $MIN_DIST ]; then
        MIN_DIST=$DIST
        BEST_COLOR=$COLOR
    fi
done

# Apply the best matching color
papirus-folders -u -C "$BEST_COLOR" --theme Papirus-Dark &> /dev/null
