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
    printf "|%3s|%3s|%3s|\n" "$1" "$2" "$3"
}

# 1 2 3
# 4 5 6
# 7 8 9
# check game over
is_game_over () {
    if [[ $# -ne 9 ]] ; then echo "9 args required for is_game_over"; exit 1; fi
    # horizontal
    if [[ $1 == $2 && $2 == $3 && $3 != " " ]]; then
        echo 1
    elif [[ $4 == $5 && $5 == $6 && $6 != " " ]]; then
        echo 1
    elif [[ $7 == $8 && $8 == $9 && $9 != " " ]]; then
        echo 1
    # vertical
    elif [[ $1 == $4 && $4 == $7 && $7 != " " ]]; then
        echo 1
    elif [[ $2 == $5 && $5 == $8 && $8 != " " ]]; then
        echo 1
    elif [[ $3 == $6 && $6 == $9 && $9 != " " ]]; then
        echo 1
    # diagonal
    elif [[ $1 == $5 && $5 == $9 && $9 != " " ]]; then
        echo 1
    elif [[ $7 == $5 && $5 == $3 && $3 != " " ]]; then
        echo 1
    else
        echo 0
    fi
}

# first line
aa="o"
ab=" "
ac=" "
# second line
ba=" "
bb="o"
bc=" "
# third line
ca=" "
cb="x"
cc="o"

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

    game_over=$(is_game_over "$aa" "$ab" "$ac" "$ba" "$bb" "$bc" "$ca" "$cb" "$cc")
    echo "test $game_over"
done
