#!/bin/bash

#set -x

for process in `ps aux | grep dbellamy | grep -iE nc | awk -F ' ' '{print $2}'`; do echo " Kill process: $process" | head -1 | xargs kill -9 > /dev/null 2>&1 ; done
