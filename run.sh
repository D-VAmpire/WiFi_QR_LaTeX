#!/bin/bash

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
check_requirement python3
check_requirement pdflatex
check_requirement cat

# Check if credentials already given in .txt. If not, ask the user for them and update credentials.txt accordingly.
if [ -f ./credentials.txt ] && [ -s ./credentials.txt ]
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

# call wifi-qrcode-generator in python with this data
python3 <<HEREDOC
import wifi_qrcode_generator
code = wifi_qrcode_generator.wifi_qrcode( r'${ssid}', False, 'WPA', r'${pw}')
code.save(r'${ssid}'+'.png')
HEREDOC

# Let pdflatex compile our document
pdflatex wifi-qr.tex &> /dev/null
# Uncomment if you need pdflatex output (e.g. for debugging):
# pdflatex wifi-qr.tex
echo -e "${GREEN}${BOLD}\n📜 Generated wifi-qr.pdf printout :) 📜${RESET}"


