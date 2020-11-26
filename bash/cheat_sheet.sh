# basics
# https://github.com/LeCoupa/awesome-cheatsheets/blob/master/languages/bash.sh
# https://devhints.io/bash


# watch a chained command
watch 'docker ps --format "{{.ID}},{{.Image}},{{.Ports}},{{.Status}}" | tty-table'

# run software installed via dkpg from terminal
dpkg -L <PACKAGE> # find software
# run e.g. /opt/DockStation/dockstation

# use zsh
# install via
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# checkout plugins on https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins#docker
# add plugins via
nano ~/.zshrc
# add plugin section at end like this
plugins=(
    git
    docker
)
# start via
zsh

# list running processes
ps aux

# change default editor 
sudo update-alternatives --config editor

# git rmeove submodule
# https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule
0. mv a/submodule a/submodule_tmp
1. git submodule deinit -f -- a/submodule    
2. rm -rf .git/modules/a/submodule
3. git rm -f a/submodule
# Note: a/submodule (no trailing slash)
# or, if you want to leave it in your working tree and have done step 0
3.   git rm --cached a/submodule
3bis mv a/submodule_tmp a/submodule

# git pull hard
git fetch --all
#Backup your current branch:
git checkout -b backup-master
git reset --hard origin/master # or to whatever branch you want to pull
# now your current branch is same as origin/master