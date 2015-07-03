#!/bin/bash
### This file lists all the functions we are using in the main script ###

source ./settings/settings.sh

# Clean the data file from the users I already follow
function cleandata {
	$pathtot friends > lists/friends.txt
	cat $data | while read $line
	do
	newguy=$(echo $line | sed s/\@// )
	echo $newguy
	alreadyfollowed=$(grep $newguy list/friends.txt | wc -l)
		if [[ alreadyfollowed = 1 ]]; then
			sed -i '/'"$line"'/d' $data
		fi
	done
}

# Define the last most relevant user to copy followers
lastrelevant=$(head -n1 $data)

# List all the followers of this user and output to data file
function listfollowers {
	$pathtot friends -l $lastrelevant > $data
}	

# Sort that list with provided keywords and output the followammount most relevant to pending file
function sortfollowers {
	./keywords.py $keywords $data > temp
	cat temp | awk '{ print $13}' | head -n $followamount > $data
	rm -rf temp
}

# Remove the blacklist users from the pending file
function usercleanup {
	touch temp
	grep -Fxv -f $blacklist $data > temp
	cat temp > $data
	rm -rf temp
}

# Follow your new friends and log the date
function autofollow {
	cat $data | while read line
	do
	$pathtot follow $line
        echo $(date +"%j") $line | sed s/@// >> $pending
	done
}

# Unfollow those who didn't follow you back after unfollowtime days & send a welcome message to the good guys
function autounfollow {
        limit=$(date +"%j" --date ''"$unfollowtime"' days ago')

	cat $pending | while read line
	do

		dudecheck=$(echo $line | awk '{ print $2}')
		followeddate=$(echo $line | awk '{ print $1}')
		followback=$(echo $friends | grep $dudecheck | wc -l)
		inwhitelist=$(grep $dudecheck $whitelist | wc -l)

			if [[ $followeddate -le $limit ]] && [[ $followback = 0 ]] && [[ $inwhitelist = 0 ]]; then
				$pathtot unfollow $dudecheck
				echo @$dudecheck >> $blacklist
				sed -i '/'"$line"'/d' $pending
				echo "$dudecheck has been unfollowed :("
			elif [[ $followback = 1 ]]; then
			#	$pathtot dm @$dudecheck "$welcome"
				sed -i '/'"$line"'/d' $pending
			#	echo "$dudecheck has been welcomed !"
			fi
	done
}

