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