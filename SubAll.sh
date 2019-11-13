#!/bin/bash
if [ $# -ne 1 ]; then
echo " [*] Usage : $0 domain "
exit 0
fi

DOMAIN=$1
red=`tput setaf 1`
green=`tput setaf 2`

banner(){
  echo "${red}
   ____        _       _    _ _ 
  / ___| _   _| |__   / \  | | |
  \___ \| | | | '_ \ / _ \ | | |
   ___) | |_| | |_) / ___ \| | |
  |____/ \__,_|_.__/_/   \_\_|_|  "
                                
}

sublister(){

  echo "[*]Starting Sublister...."
  rm -rf ~/recon/${DOMAIN} && mkdir ~/recon/${DOMAIN}
  cd ~/extra_tools/Sublist3r/
  python sublist3r.py -d ${DOMAIN} -t 10 -v -o ~/recon/${DOMAIN}/domains.txt > /dev/null
}

crtsh(){
  echo "[*]Checking crtsh and appending to domains.txt."
  curl -s https://crt.sh/?q=%.${DOMAIN}  | sed 's/<\/\?[^>]\+>//g' | grep ${DOMAIN} >> ~/recon/${DOMAIN}/domains.txt
}

certspotter(){
 echo "[*]Checking certspotter and appending to domains.txt."
 curl -s https://certspotter.com/api/v0/certs\?domain\=${DOMAIN} | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep ${DOMAIN} >> ~/recon/${DOMAIN}/domains.txt
 }

banner
echo "${green}Starting to collect all subdomins using Sublist3r, crtsh and certspotter."
sublister
crtsh
certspotter


echo "Output saved in ~/recon/${DOMAIN}/"

if [ sublister != 0 ];
then
  exit 1
fi


