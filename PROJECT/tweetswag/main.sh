#!/bin/bash

source ./settings/settings.sh
source ./functions.sh

alias t=$pathtot

listfollowers
echo Followers Listed
sortfollowers
echo Followers Sorted
cleandata
echo Data cleaned
usercleanup
echo Users Cleaned Up
autofollow
echo Users Followed
autounfollow
echo Users Unfollowed or Welcomed
cat $data

exit 0
