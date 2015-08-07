#!/bin/bash

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

number=$(grep "SuperUserService.acknowledge_list_update" /var/log/bluesys/autolib/info-`date +"%Y-%m-%d"`.log |wc -l)
if [[ $number = 0 ]]; then
        
        echo -e "CRITICAL: Attention, la liste des superbadges n est pas validee |cars_ack=$number"
            exit $STATE_CRITICAL
else

        echo -e "OK : $number vehicules mis a jour | cars_ack=$number"
            exit $STATE_OK
fi
