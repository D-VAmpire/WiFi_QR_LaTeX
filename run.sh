#!/bin/bash

# CLI colours
BOLD=$'\e[1m'
GREEN=$'\e[0;32m'
CYAN=$'\e[36m'
RESET=$'\e[0m'

check_requirement(){
if ! command -v "$1" &> /dev/null
then
    echo "$1 needs to be installed! See README.md!"
    exit
fi
}

# Some tools need to be installed in advance
check_requirement wifi-qrcode-generator
check_requirement pdflatex
check_requirement cat


# Parse CLI arguments
# Thanks to https://stackoverflow.com/questions/192249 including all answers
while (( "$#" )); do
    if (( $(($# % 2)) )); then echo "Error: Uneven number of arguments given: does not fit \"--key value\" syntax."; exit 1; fi
    case "$1" in
        -s|--ssid|--name) ssid="${2:-}"; shift 2;;
        -p|--pw|--password|--pass|--psk) pw="${2:-}"; shift 2;;
        -o|--output|--output-file|--outfile) outfile="${2:-}"; shift 2;;
        *) echo "unknown option: $1" >&2; exit 1;;
    esac
done

# If we found ssid and pw as CLI arguments (or env vars), then we can just use them (updating credentials.txt).
if [ -n "$ssid" ] && [ -n "$pw" ]
then
    rm -f ./credentials.txt
    echo "$ssid" > ./credentials.txt
    echo "$pw" >> ./credentials.txt
# Otherwise check if credentials already given in credentials.txt file. If not, ask the user for them and update credentials.txt accordingly.
elif [ -f ./credentials.txt ] && [ -s ./credentials.txt ]
then
    output=$(cat ./credentials.txt) 
    { read -r ssid ; read -r pw ; } <<< "$output" 
else
    # echo "credentials.txt is not there or empty"
    read -rp "${CYAN}What is your network name (SSID)? ${RESET}" ssid
    read -rp "${CYAN}What is this network's password? ${RESET}" pw
    echo "$ssid" > ./credentials.txt
    echo "$pw" >> ./credentials.txt
fi

# Generating the QR code
wifi-qrcode-generator -s "${ssid}" -p "${pw}" -a WPA -o "${ssid}.png"

# Stripping ".pdf" if user submitted it to their outfile name
outfile="${outfile%.pdf}"

# Let pdflatex compile our document
mkdir -p out
pdflatex -output-directory out -jobname "${outfile:-$ssid}" wifi-qr.tex &> /dev/null
# Uncomment if you need pdflatex output (e.g. for debugging):
# pdflatex wifi-qr.tex

# Clean up
mv "out/${outfile:-$ssid}.pdf" "${outfile:-$ssid}.pdf"
rm -rf out
rm "${ssid}.png"

echo -e "${GREEN}${BOLD}\n📜 Generated \"${outfile:-$ssid}.pdf\" printout :) 📜${RESET}"


