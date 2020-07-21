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

function write_rnd_chars()
{
    n_rand_chars=$((RANDOM%$1))

    excluded_chars="\'\"\n\\\v"

    for (( i=0; i<= n_rand_chars; ))
    do
        tmp=$(printf "$(printf \\%2o $(($RANDOM%127)) )" )
        dummy=$RANDOM

        if [[ $tmp =~ ${excluded_chars} ]]
        then
             echo "Match" $tmp
        else
           echo "OK"
            macro+=$tmp
            $((i++))
        fi

    done

}

function write_header_file_macro()
{
    macro="# define TEST \""
   
    write_rnd_chars 500

    macro+="\""

    echo $macro >> $header_file
    echo $macro
}

write_header_file

