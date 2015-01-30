#!/bin/sh
demeteorized_path="$(pwd)/.demeteorized"
demeteorized_git="$demeteorized_path/.git"
restore_git=false

start () {
cd $demeteorized_path
echo "start"
}

deploy () {
if [ -d "$demeteorized_git" ]; then
  echo "$(tput setaf 1)Backing up .git directory...$(tput sgr 0)"
  mv "$demeteorized_git" "/tmp/demeteorized_git"
  restore_git=true
fi

demeteorizer
cd $demeteorized_path

if [ "$restore_git" = true ] ; then
  echo "$(tput setaf 1)Restoring .git directory...$(tput sgr 0)"
  mv "/tmp/demeteorized_git" "./.git"
else
  echo "$(tput setaf 1)Creating .git directory...$(tput sgr 0)"
  git init
  git remote add deploy "git@212.227.108.193:/home/git/git4all.git"
fi

git add --all .
commit_msg="deploy "$(date)
git commit -m "$commit_msg" 

git push -f deploy master
}

if [ $# -eq 0 ]; then
  echo "No arguments supplied"
fi

if [ $1 = "deploy" ]; then
deploy
fi

if [ $1 = "start" ]; then
start
fi
