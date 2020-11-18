#!/bin/sh

cd /hwd
echo -e "Current path is ${PWD}\nFolder contains $(ls | tr \\n ' ')"

echo "starting application..."
./hello-world

echo "finished!"