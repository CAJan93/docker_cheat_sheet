#!/bin/bash
# tik tak to

printf "playing tik tak to\n\n\n"

game_over=0

# print line with a length of $1
print_line () {
    if [[ $# -ne 1 ]] ; then echo "1 arg required for print_line"; exit 1; fi
    line=""
    for (( i=0 ; i<$1 ; ++i )); do
        line="${line}-"
    done
    printf "%s\n" $line 
}

# print a line that involves x and o
print_game_line () {
    if [[ $# -ne 3 ]] ; then echo "3 args required for print_game_line"; exit 1; fi
    printf "|%3s|%3s|%3s|%3s\n" $1 $2 $3
}


# first line
aa=" "
ab=" "
ac=" "
# second line
ba=" "
bb=" "
bc=" "
# third line
ca=" "
cb=" "
cc=" "

# game loop until game over
until [[ $game_over -eq 1 ]] ; do

    # print board
    print_line 13
    print_game_line "$aa" "$ab" "$ac"
    print_line 13
    print_game_line "$ba" "$bb" "$bc"
    print_line 13
    print_game_line "$ca" "$cb" "$cc"
    print_line 13

    game_over=1
done
