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

  echo "${green}[+]Starting Sublister...."
  rm -rf ~/recon/${DOMAIN} && mkdir ~/recon/${DOMAIN}
  cd ~/extra_tools/Sublist3r/
  python sublist3r.py -d ${DOMAIN} -t 10 -v -o ~/recon/${DOMAIN}/domains.txt > /dev/null
  echo "sublister done. Output saved in ~/recon/${DOMAIN}/"
}

crtsh(){
  echo "${green}starting crtsh and appending all the domain into the domains.txt file."
  curl -s https://crt.sh/?q=%.${DOMAIN}  | sed 's/<\/\?[^>]\+>//g' | grep ${DOMAIN} >> ~/recon/${DOMAIN}/domains.txt
}

banner
sublister
crtsh

if [ sublister != 0 ];
then
  exit 1
fi

