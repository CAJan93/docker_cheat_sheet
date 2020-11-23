#!/bin/bash

# An example cmd line tool.
# Usage:
#           ./command_line_tool.sh [--param1 PARAM1] [--param2]

# -e Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
set -e
set -u

# error handling
exitWithError() {
    echo "$1"
    echo "Usage: $0 [--param1 PARAM1] [--param2]"
    exit 1
}

# default values
PARAM1=$USER
PARAM2=false

# process arguments.
while [ "$#" -gt 0 ]; do                                # While the number of arguments is greater then 0
    case $1 in                                          # Process arguments in pairs. Look at the first arguments (param1 or param2)
        --param1) PARAM1="$2"; shift ;;                 # Shift skips an argument
        --param2) PARAM2=true ;;
        *) exitWithError "Unknown parameter: $1" ;;     # call function exitWithError with one argument
    esac
    shift
done

echo "doing the stuff that you want to do"


if [ "$PARAM2" = true ]; then
    echo "Do stuff, since PARAM2 is true"
fi