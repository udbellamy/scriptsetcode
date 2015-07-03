#!/bin/bash
## This file lists all the variables and parameters ##

# Define here the path to your t binary (https://github.com/sferik/t)

pathtot='/usr/lib64/ruby/gems/2.0.0/gems/t-2.9.0/bin/t'

# Who are my friends ?

friends=$($pathtot friends)

# How many guys will I follow
followamount=10

# How many days will I wait before unfollow
unfollowtime=4

# Where is my whitelist (people I will never unfollow)
whitelist=./lists/whitelist.txt

# Where is my blacklist (people I will never auto-follow again)
blacklist=./lists/blacklist.txt

# Where is my pending list (people I wait to follow back)
pending=./lists/pending.txt

# Where are my keywords
keywords=./settings/keywords.txt

# Where are extracted the followers of the last most relevant user
data=./lists/data.txt

# Set your welcome message here
welcome="Salut à toi et merci pour le follow back !"
