#!/bin/sh

backup () {
if [ -d "$demeteorized_path/node_modules/" ]; then
  echo "$(tput setaf 1)Backing up node modules...$(tput sgr 0)"
  mv "$demeteorized_path/node_modules/" "/tmp/node_modules_$timestamp"
fi
}

restore () {
if [ -d "/tmp/node_modules_$timestamp" ]; then
  mv "/tmp/node_modules_$timestamp" "$demeteorized_path/node_modules"
fi
}

update () {

stop 

backup
demeteorizer
restore
start
echo "$(tput setaf 1)Restarted$(tput sgr 0)"

}

stop () {
  echo "$(tput setaf 1)Killing node...$(tput sgr 0)"
  pkill node
}

start () {
  MONGO_URL=mongodb://localhost:27017/final_preprod2 PLATFORM=DEV ROOT_URL=http://localhost:3000 PORT=3000 node $demeteorized_path/main.js &
}

deploy () {

if [ -d "$demeteorized_git" ]; then
  echo "$(tput setaf 1)Backing up .git directory...$(tput sgr 0)"
  mv "$demeteorized_git" "/tmp/demeteorized_git"
  restore_git=true
fi

backup
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

cd ..
restore

}


demeteorized_path=".demeteorized"
demeteorized_git="$demeteorized_path/.git"
home_path=~
restore_git=false
timestamp=$(date +%s)

if [ $# -eq 0 ]; then
  echo "No arguments supplied"
  exit
fi

if [ ! -d "$demeteorized_path" ]; then
  echo "Not a valid demeteorized path"
  exit
fi

if [ $1 = "deploy" ]; then
deploy
exit
fi

if [ $1 = "start" ]; then
start
exit
fi

if [ $1 = "update" ]; then
update
exit
fi

echo "bad argument"
