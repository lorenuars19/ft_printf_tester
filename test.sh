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

# =============================== Global variables ============================#
header_file=.test.header.h
printf_main_file=.test.printf.c
ft_printf_main_file=.test.ft_printf.c


# RND_CHARS
MAX_RND_CHARS=1000

# SEQUENCE
MAX_SEQ_ITEMS=420
# RND_FLAGS
MAX_NUM=50
NUM_CONV="iduxX"
STR_CONV='s'
CHR_CONV='c'
PTR_CONV='p'

# ================================= Functions =================================#
function write_files() 
{
    write_main_ft_printf
    write_main_printf
    write_header_file
}

function write_main_printf()
{
    rm -f $printf_main_file
    echo "/*" >> $printf_main_file
    echo "** Main for testing the stdio printf" >> $printf_main_file
    echo "**" >> $printf_main_file
    echo "** by : lorenuar" >> $printf_main_file
    echo "*/" >> $printf_main_file
    echo "" >> $printf_main_file
    echo "#include \"$header_file"\" >> $printf_main_file
    echo "" >> $printf_main_file
    echo "int"$'\t'"main(void)" >> $printf_main_file
    echo "{" >> $printf_main_file
    echo $'\t'"printf(TEST);" >> $printf_main_file
    echo $'\t'"return (0);" >> $printf_main_file
    echo "}" >> $printf_main_file
    echo "" >> $printf_main_file
}

function write_main_ft_printf()
{
    rm -f $ft_printf_main_file
    echo "/*" >> $ft_printf_main_file
    echo "** Main for testing your ft_printf" >> $ft_printf_main_file
    echo "**" >> $ft_printf_main_file
    echo "** by : lorenuar" >> $ft_printf_main_file
    echo "*/" >> $ft_printf_main_file
    echo "" >> $ft_printf_main_file
    echo "#include \"$header_file"\" >> $ft_printf_main_file
    echo "" >> $ft_printf_main_file
    echo "int"$'\t'"main(void)" >> $ft_printf_main_file
    echo "{" >> $ft_printf_main_file
    echo $'\t'"ft_printf(TEST);" >> $ft_printf_main_file
    echo $'\t'"return (0);" >> $ft_printf_main_file
    echo "}" >> $ft_printf_main_file
    echo "" >> $ft_printf_main_file
}

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
    echo "//# include \"ft_printf.h\"" >> $header_file
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

function rnd_chars()
{
    local n_rand_chars=$((RANDOM%$1))
    local chars="!#$%&'*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ^_abcdefghijklmnopqrstuvwxyz"
    local print=42

    for (( i=0; i<= n_rand_chars; i++))
    do
        tmp=${chars:$((RANDOM%${#chars})):1}
      
        if [[ $((i%print)) -eq 0 ]]
        then
            printf +
        fi
        macro+=$tmp
    done
}

function write_header_file_macro()
{
    macro="# define TEST \""

    rnd_chars $MAX_RND_CHARS

    macro+="\""

    echo $macro >> $header_file
    echo $'\n'$macro
}

function gen_flag ()
{
    flag=''

    local conv=''
    case $1 in
        rnd) return 0 ;;
        num) conv=${NUM_CONV:${$(($RANDOM%${#NUM_CONV}))}:1} ;;
        str) conv=$STR_CONV ;;
        chr) conv=$CHR_CONV ;;
        ptr) conv=$PTR_CONV ;;
        *) return 1 ;;
    esac

    local tmp_flag='%'
    local is_percent=$(($RANDOM%5))
    if [[ $is_percent -eq 1 ]]
    then
        tmp_flag+='%'
        flag=$tmp_flag
        return 0
    fi

    local has_prs=$(($RANDOM%2))
    local zero_space_nothing=$(($RANDOM%3))
    
    if [[ $zero_space_nothing -eq 1 ]] ; then
        tmp_flag+=' '
    elif [[ $zero_space_nothing -eq 0 ]] ; then
        tmp_flag+='0'
    fi

    tmp_flag+=$(($RANDOM%$MAX_NUM))
    if [[ $has_prs -eq 1 ]]
    then
        tmp_flag+='.'
        tmp_flag+=$(($RANDOM%$MAX_NUM))
    fi
    tmp_flag+=$conv
    flag=$tmp_flag
}

function gen_sequence ()
{
    local max_items=$(($RANDOM%$MAX_SEQ_ITEMS))
    items=( rnd num str chr ptr )

    echo max_items : $max_items
    for (( it=0; it<max_items; it++ ))
    do
        sequence+=(${items[$(($RANDOM % $((${#items}+1))))]})
    done
}

# ================================== Program ================================= #

write_files

gen_sequence

for ((se=0;se<${#sequence};se++))
do
    gen_flag ${sequence[$se]}
    printf "Seq["%04d"] %s %-17s\t\t" $se ${sequence[$se]} $flag
done



sleep .1
rm -f $header_file $printf_main_file $ft_printf_main_file