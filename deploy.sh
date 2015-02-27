#!/bin/sh
demeteorized_path="$(pwd)/.demeteorized"
demeteorized_git="$demeteorized_path/.git"
restore_git=false
timestamp=$(date +%s)

update () {
if [ -d "$demeteorized_path/node_modules/" ]; then
  echo "Backing up node modules..."
  mv "$demeteorized_path/node_modules/" "/tmp/node_modules_$timestamp"
fi
demeteorizer
cd $demeteorized_path

if [ -d "/tmp/node_modules_$timestamp" ]; then
  mv "/tmp/node_modules_$timestamp" "node_modules"
fi
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

if [ $1 = "update" ]; then
update
fi
