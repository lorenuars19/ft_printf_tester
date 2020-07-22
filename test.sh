#!/bin/zsh

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    test.sh                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lorenuar <lorenuar@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/07/16 13:17:01 by lorenuar          #+#    #+#              #
#    Updated: 2020/07/16 13:17:02 by lorenuar         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Vars
header_file=.test.header.h
printf_main_file=.test.printf.c
ft_printf_main_file=.test.ft_printf.c


function write_header_file()
{
    rm -f $header_file
    echo "/*" >> $header_file
    echo "** Header file which contains the macro to test" >> $header_file
    echo "** the outputs of your ft_printf and stdio printf" >> $header_file
    echo "**" >> $header_file
    echo "** by : lorenuar" >> $header_file
    echo "*/" >> $header_file

    echo "" >> $header_file
    echo "#ifndef TEST_HEADER_H" >> $header_file
    echo "# include \"ft_printf.h\"" >> $header_file
    echo "# include <stdio.h>" >> $header_file
    echo "" >> $header_file
    
    write_header_file_macro
    
    echo "#endif" >> $header_file
}

function str_contains ()
{
    for (( j=0 ; j<${#1}; j++))
    do
        if [[ ${1:$j:1} == $2 ]]
        then
            return 1
        fi
    done
    return 0
}

function write_rnd_chars()
{
    local n_rand_chars=$((RANDOM%$1))

    local excluded_chars=$'\n\\\'\"/'

    local char_min=$((20))
    local char_max=$((127-char_min-2))
    for (( i=0; i<= n_rand_chars; i++))
    do
        tmp=$(printf "$(printf \\%1o $((char_min + $RANDOM % char_max)) )" )
        dummy=$RANDOM
        

    local print=50
        if ! str_contains  $excluded_chars $tmp
        then

            if [[ $((i%print)) -eq 1 ]]
            then
                #printf "\033[31m-\033[m\n"
            fi
            i=$((i-1))
        else
            if [[ $((i%print)) -eq 1 ]]
            then
                printf "\033[32m+\033[m"
            fi
            macro+=$tmp
        fi

    done

}

function write_header_file_macro()
{
    macro="# define TEST \""
   
    write_rnd_chars 50

    macro+="\""

    echo $macro >> $header_file
    echo $'\n'$macro
}

write_header_file

rm -f $header_file
