#!/bin/bash

red='\e[0;31m'
green='\e[0;32m'
NC='\e[0m'

echo -e "\n\033[1mRemplacement du cron en cours\n Saisissez vos identifiants GitHub\033[0m"
cd autoslave
git pull -q
scp -q docs/general/crontab suppack.auto:/opt/packaging/debian/autoslave-app/cron.d
RETVAL=$?
cd ..

if [[ $RETVAL = 0 ]]; then
echo -e "\n\033[1mDone\033[0m"
else
echo -e "\033[0m${red}\033[1m Erreur dans la copie du cron${NC}\033[1m"
fi
