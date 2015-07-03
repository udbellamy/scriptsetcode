#!/bin/bash

# Retreive the memory percentage used

mem=$(free -m | head -n 2 | awk 'NR>1{ print $3*100/$2 }')

# Retreive the top two memory eager uwsgi processes

proc1=$(ps u -u www-data | grep uwsgi | sort -rk4 | head -n 1 | awk '{ print $2 }')
proc2=$(ps u -u www-data | grep uwsgi | sort -rk4 | head -n 2 | awk 'NR>1{ print $2 }')

# Kill and flag those processes, then restart uSWGI

while 1

if [[ $mem -ge 80 ]]; then

    kill -SIGUSR2 $proc1
    kill -SIGUSR2 $proc2
    /etc/init.d/uwsgi restart
    grep SIGUSR2 /var/log/uwsgi/app/ops.log >> req.log
    echo -e "Bonjour,\n\nLe process uWSGI a été killé car les requetes suivantes consommaient beaucoup de ressources : \n $(cat req.log) \n uWSGI a été redémarré\nCordialement,\n\n$HOSTNAME." | mail -s "Requête lourde détectée, uWSGI redémarré" damien.bellamy@polyconseil.fr
    rm -f req.log

fi

sleep 5
