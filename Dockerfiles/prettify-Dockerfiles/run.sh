#!/bin/bash

# run dockfmt on each dockerfile in /src dir and pipe output to <DOCKEFILENAME.clean>
# Ignore all files that include the word clean

for f in $(find /src -name *dockerfile* -type f | grep -v clean); do 
    echo -e "formatting $f\n\tand writing output to\n\t$f.clean";
    dockfmt fmt $f > $f.clean;
done
    