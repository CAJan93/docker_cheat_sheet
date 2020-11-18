#!/bin/sh

# run beautysh on each .sh in /src dir

for path in `find /src -name '*.sh'`
do
    echo "beautysh $path..." ;
    beautysh $path ;
    echo "done"
done