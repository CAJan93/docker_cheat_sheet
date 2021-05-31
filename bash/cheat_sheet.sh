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

# change mode of all files
sudo find . -type f  -exec chmod 644 {} \;

# output everything from program to file
program > output.txt 2>&1

#!/bin/bash
# called a shebang. You can also call python or other interpreters with this
# debug with #!/bin/bash -x
echo mycommand # will print what command would be executed. Also nice for debugging

# when creating a new command via bash scripts,
# make sure that the name is still available via 
type thename

# Variables
# Variables are case sensitive

# use a variable within some text
echo ${var}iable 

# raw strings, not variables 
echo '$var' # $var

# always quote variables like below, in case your variable contains spaces 
"$x"

# if, then, elif, else
# then runs, if the if command returned 0
# else runs, if then if command returned != 0
# make sure that your script always returns a value

# Why are spaces important in if expressions?
if [[ $str = "test" ]] # true if str == test
if [[ $str="test" ]] # always true. No comparison, but a single word. Which is not an empty string, so true

# why use [[ instead of [
# [ is the oldfashioned shell build-in test command
# has a lot of hickups. Use it only if you write stuff for non-bash shells

# comparing integers (floats are not supported)
[[ num1 OP num2 ]]
OP: -eq, -ne, -lt, -gt
> or = and similar will only work with strings
# pattern matching 
if [[ var =~ ^[0-9]+$ ]]; then # var is number

# Special vars
# number of arguments in script
$#
# exit status from last command
$?

# combining tests
[[ $# -eq 1 && $1 == "foo" ]]
# there should be exactly 1 arguemnt that has the value foo

# use printf for fancy output
printf "hello\n"                        # equivalent to echo "hello"
printf "hi %s\n" $USER                  # %s takes string
printf "hi $%s " a b c                  # hi a hi b hi c # prints for every input
printf "|%30s |%30s |%30s |\n" $(ls)    # table with column width of 30 chars
printf -v greeting "hi"                 # output saved in variale greeting
# more pretty printing: https://wiki.bash-hackers.org/commands/builtin/printf
# or man printf

# streams
# all shell scripts connect to stdin stdout and stderr
# streams are represented as files in /dev/<streamname>
echo "this is an error" > /dev/stderr # or echo "this is an error" 1>&2
# redirecting via > or < only redirecty stdout
# discard output via > /dev/null

# Loops
# while test is == 0, repeat
while test; do
    # code
done
# until test is == 0, repeat
until test; do 
    # code
done
# foreach loop 
for var in array; do 
    # code
done
# c-style. Use <, =, !=, > for the test, e.g. (( i=0; i<10; ++i))
for (( init; test; update )); do 
    # code
done
# switch-case
case $1 in 
    cat)
        echo "meow";;
    dog|smalldog)   # match multiple
        echo "wof";;
    *)
        echo "any other animal"
esac
# group. Use same I/O for all commands
{ echo "hi"; echo "there" } >> file.txt 
# run second part only if first succeeds. Only call exit if script is called with wrong num args
[[ $# -ne 2 ]] && { echo "2 arguments are needed"; exit 1 }

# Variables
# Use declare to define type of variable. If you assign wrong type does NOT give error
declare -i aninteger 
declare +i aninteger        # no longer an integer
declare -i aninteger="5+4"  # 9
aninteger="somestring"      # 0

# math expression
let n =100/2                # 50
((++n))                     # 51; different from $((++n)), which will try to execute 51
result=$((++n))             # result holds ouput. n is incremented
((n= $(ls | wc -l) *10 ))   # update n depending on number of files in folder

# constants
declare -r const="someval"
const="other val" # error: variable const

# export makes the variable accessable to child processes 
# the following are equivalent:
export var=1
declare -x var=1 
# changing the variable in the child process does not change the variable in the parent process!
# variable attributes are never passed to child processes. So, you can change a const from the parent in the child process

# arrays
declare -a x
array=("value1" "value2")
${x[0]} # get value at 0
${x[@]} # get all values
${x[*]} # get all values
x[0]="value" # set value at 0
${#x[@]} # size of array

# handling input
# special vars
${10}   # positional argument at position 10
$0      # hold name of script (for debugging)
$@      # all args from script
"$@"    # all arguments, but each is quoted
"$*"    # all arguments as one string
$#      # number of args passed to script
# commands
shift   # removes the first arg of your script. Makes $1 = $2 and removes old $1
# process all args from script with
while [[ $1 ]]; do 
    # process arg
    shift
done
# Use getopts to process args more fancy
getopts "ab"   # accepts arguments -a and -b
getopts "abc:" # accepts arguments -a, -b and -c "someval"

# functions
f () {
    # do stuff
}
# call via f param1 param2
# use echo to pass return 
f () { 
    declare -l myLocalVar
    local myOtherLocalVar
    echo "stuff"
}
myVar=$(f) # myVar is now "stuff"

# export function via
# makes someFunc available from subshell.
# E.g.: We define someFunc in script1.sh. This script calls script2.sh
# script2.sh can now use someFunc, because it was exported
export -f someFunc

# output stuff
cat << END
some raw stirng
multi line
END

# command in pipe runs in subshell
ls | while read -r ; do ((++count)); done
# count will be updated, but its local to the subshell, so its useless

# strings
${#var}     # length of string
${var#pattern}    # remove shortest match from beginning of string
${var##pattern}   # remove longest match from beginning of string
${var%pattern}    # remove shortest match from end of string
${var%%pattern}   # remove longest match from end of string
pattern:
*   # match any string, excluding empty string
?   # match any single char 
[]  # sets of chars in these brackets

# search and replace
${var/pattern/string}   # search and replace first match
${var//pattern/string}   # search and replace all matches

# set default value if variable is not set or empty
${var:=defaultValue}
# set default value if variable is not
${var=defaultValue}

# regex (uses POSIS exteded regex)
# Match strings against patterns using =~

# end of options
rm -- -l.txt
# I am able to remove file -l.txt now. rm -l.txt would tell me that rm does not have option -l

# run a script even when you close terminal 
nohub myscript &
# run script with lower prio to reduce resource useage
nice myscript
# use at to run a script at specific time
at -f myscript noon tomorrow
# use cron or launchd to run it in interval

# use set -nv to print every line without executing it
set -e # to terminate whenever there is an error