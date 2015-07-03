#!/bin/bash
#set -x

print_usage() {            
            echo -e "\\033[1;32m"  "*****************************************************\n"
            echo -e "\\033[1;31m" " Usage : $0 host1, host2,...\n"
            echo -e "\\033[1;32m"  "*****************************************************\n"
            tput sgr0
}

if [[ $# -eq 0 ]]; then
    print_usage
    exit 0
fi

for ARG in $* 
do
      ssh-copy-id -i ~/.ssh/id_rsa.pub $ARG
done
        echo "Done!!"
    exit 0
