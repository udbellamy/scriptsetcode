#!/bin/bash
#set -x
#    echo "Enter target path"
#    read target
    for ARG in $*
    do
        echo "Copy to $ARG:/tmp : "
        ssh -n $ARG mv /tmp/check_time_offset.sh /usr/lib/nagios/plugins/
done
        echo "Done!!"
    exit 0
else
    echo "file does not exist"
exit 2 
fi
