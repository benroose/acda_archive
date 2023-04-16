#!/bin/bash

# Script to clone and configure all user github repositories
# NOTE: Needs git installed

# File and text variables
git_user="benroose"
git_username="Ben Roose"
git_useremail="ben.roose@wichita.edu"

git_repos=( acda_2017 cs444 )

parent_dir=$HOME
cd ${parent_dir}

for repo in "${git_repos[@]}"
do
    repo_link="git@github.com:${git_user}/${repo}.git"
    
    git clone ${repo_link}
    cd ${repo}
    git remote set-url origin ${repo_link}
    cd ${parent_dir}    
done

git config --global user.name ${git_username}
git config --global user.email ${git_useremail}
