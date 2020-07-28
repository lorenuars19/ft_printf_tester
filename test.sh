#!/bin/bash

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

# =============================== Global variables =========================== #
# = = = = = = = = = = = = = = = YOU CAN TWEAK THESES = = = = = = = = = = = = = #
_VERBOSE=1
# The time out for execution of tests
_TIME_OUT=5
# The global max for fast tweaking of below maximums
_GLOBAL_MAX_=10
# 1 = add newlines add '\n' between each items in the sequence
WITH_NEWLINES=0
# Max number of generated chars
MAX_RND_CHARS=$_GLOBAL_MAX_
# Max number of sequence items
MAX_SEQ_ITEMS=$_GLOBAL_MAX_
# Max number for flag params
FLAG_NUM_MAX=$_GLOBAL_MAX_
# conversions
NUM_CONV="iduxX"
STR_CONV='s'
CHR_CONV='c'
PTR_CONV='p'
# Max number for generated numbers variables
VARS_NUM_MAX=10000
# Max length for generated string variables
STR_LEN_MAX=$_GLOBAL_MAX_

# ============================================================================ #
WD=.42_Test_42_Logs_Here        # The 'Working Directory'
LOG_DIR=$WD/.42.LOGS_HERE       # The LOGS Directory
LOG_FILE=$LOG_DIR/.42.LOGS      # The LOGS file
# Here you can see how the script searches for your input files
FT_PRINTF_HEADER_FILE=$( mkdir -p $WD && cd $WD && find ../ -type f -name "ft_printf.h" )
FT_PRINTF_LIB_FILE=$( find . -name "libftprintf.a" )
# Down here are all the file names WITH 42's E V E R Y W H E R E
no_dir_header_file=.42.HeAdEr.h
header_file=$WD/$no_dir_header_file
printf_main_file=$WD/.42.PrInTf.c
ft_printf_main_file=$WD/.42.Ft_PrInTf.c
printf_diff_file=$WD/.42.pRiNtF.DiFf
ft_printf_diff_file=$WD/.42.Ft_PrInTf.DiFf
printf_exec_file=$WD/.42.printf.exe
ft_printf_exec_file=$WD/.42.ft_printf.exe

# ================================= Functions =================================#
function write_main_files() 
{   
    # Writes the main for STDIO Printf
    rm -f $printf_main_file
    echo "\
/*
** Main for testing the stdio printf
**
** by : lorenuar
*/

#include \"$no_dir_header_file\"

int		main(void)
{
	printf(TEST);
	return (0);
}
" >> $printf_main_file
    # Writes the main for your ft_printf 
    rm -f $ft_printf_main_file
    echo "\
/*
** Main for testing your ft_printf
**
** by : lorenuar
*/

#include \"$no_dir_header_file\"

int		main(void)
{
	ft_printf(TEST);
	return (0);
}
" >> $ft_printf_main_file
}

function write_header_file()
{
    # Writes the header file
    rm -f $header_file
    echo "\
/*
** Header file which contains the macro to test
** the outputs of your ft_printf and stdio printf
**
** by : lorenuar
*/

#ifndef HEADER_H
# include \"$FT_PRINTF_HEADER_FILE\"
# include <stdio.h>
" >> $header_file
    # This is where all the magic happens (jump to line 215)
    write_sequence
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

    for (( i=0; i<= n_rand_chars; i++))
    do
        tmp=${chars:$((RANDOM%${#chars})):1}
        flag+=$tmp
    done
}

function gen_flag ()
{
    flag=''
    local conv=''
    local is_percent=0
    case $1 in
        rnd) rnd_chars $MAX_RND_CHARS; return 0;;
        num) conv=${NUM_CONV:$(($RANDOM%${#NUM_CONV})):1};;
        str) conv=$STR_CONV;;
        chr) conv=$CHR_CONV;;
        ptr) conv=$PTR_CONV;;
        per) is_percent=1;;
        *) return 1;;
    esac

    local tmp_flag='%'
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

    tmp_flag+=$(($RANDOM%$FLAG_NUM_MAX))
    if [[ $has_prs -eq 1 ]]
    then
        tmp_flag+='.'
        tmp_flag+=$(($RANDOM%$FLAG_NUM_MAX))
    fi
    tmp_flag+=$conv
    flag=$tmp_flag
}

function gen_var ()
{
    flag=''
    local is_null=$(($RANDOM%10))
    case $1 in
        rnd) return 0;;
        num) flag=$(($RANDOM%$VARS_NUM_MAX)); return 0;;
        chr) flag=$(($RANDOM%127)); return 0;;
        str) ;;
        ptr) is_null=1;;
        *) return 1;;
    esac

    if [[ is_null -eq 1 ]]
    then
        flag='NULL'; return 0;
    fi
    flag="\""
    rnd_chars $STR_LEN_MAX
    flag+="\""
}

function gen_sequence ()
{
    local max_items=$((1+$RANDOM%$MAX_SEQ_ITEMS))
    items=(rnd num str chr ptr per)
    local index=$((RANDOM % $((${#items} + 1)) ))
    sequence=(${items[$index]})
    for (( it=0; it<$max_items ; it++ ))
    do
        index=$((RANDOM % $((${#items} + 1)) ))
        sequence+=(${items[$index]})
    done
}

function write_sequence ()
{
    local sep=", "
    macro="# define TEST \""
    gen_sequence
    for (( se=0 ; se<${#sequence} ; se++ ))
    do
        gen_flag ${sequence[$se]}
        macro+=$flag
        if [[ WITH_NEWLINES -eq 1 ]]
        then
            macro+="\\n"
        fi
    done
    macro+="\""$sep
    se=0
    while (( $se<${#sequence} ))
    do
        gen_var ${sequence[$se]}
        macro+=$flag
        se=$((se+1))
        if [[ $se -lt ${#sequence} ]] && [[ -n $flag ]]
        then
            macro+=$sep
        fi
    done
    if [[ ${macro:$((${#macro} - ${#sep})):${#sep}} == $sep ]]
    then
        macro=${macro:0:$((${#macro} - ${#sep}))}
    fi
    echo $macro >> $header_file
    echo "#endif" >> $header_file
}

function run_test ()
{
    write_header_file
    rm -f $printf_exec_file
    gcc -I../ $printf_main_file -o $printf_exec_file
    if timeout $_TIME_OUT ./$printf_exec_file > $printf_diff_file
    then
        echo >> $printf_diff_file
    else
        printf "\rTEST : %-6d \033[31;1m STDIO PRINTF TIME OUT or EXEC ERROR\033[m\n" $test_n
        printf "\n= = = TEST : %-6d STDIO PRINTF TIMEOUT or EXEC ERROR\n" \
$test_n >> $LOG_FILE"_"$test_n
        exit 1
    fi
    rm -f $ft_printf_exec_file
    if ! gcc -I../ $ft_printf_main_file $FT_PRINTF_LIB_FILE -o $ft_printf_exec_file
    then 
        printf "\033[1;31mCOMPILE ERROR\033[m\n"
        exit 1
    fi
    if timeout $_TIME_OUT ./$ft_printf_exec_file > $ft_printf_diff_file
    then
        echo >> $ft_printf_diff_file
    else
        printf "\rTEST : %-6d \033[31;1m TIME OUT or EXEC ERROR\033[m\n" $test_n
        printf "\n= = = TEST : %-6d TIME OUT or EXEC ERROR\n" $test_n >> $LOG_FILE"_"$test_n
        return 1
    fi
    printf "= = = TEST : %-6d = =\n" $test_n >> $LOG_FILE"_"$test_n
    echo $macro >> $LOG_FILE"_"$test_n
	if [[ $_VERBOSE -eq 1 ]] ; then printf "TEST : %-6d" $test_n ; fi
    diff -s -u --label FT_42 $ft_printf_diff_file\
 --label STDIO $printf_diff_file >> $LOG_FILE"_"$test_n
    if [[ $? -eq 0 ]]
    then
		if [[ $_VERBOSE -eq 1 ]]
		then
        	printf "\rTEST : %-6d \033[32;1m + OK +\033[m\n" $test_n
			#echo $macro
			cat $ft_printf_diff_file >> $LOG_FILE"_"$test_n
        	echo OK >> $LOG_FILE"_"$test_n
		fi
		OK_NUM=$((OK_NUM + 1))
    else
		if [[ $_VERBOSE -eq 1 ]]
		then
        	printf "\rTEST : %-6d \033[31;1m ! KO !\033[m\n" $test_n
    		echo $macro
        	diff --color=always -u --label FT_42 $ft_printf_diff_file\
 --label STDIO $printf_diff_file
		fi
		KO_NUM=$((KO_NUM + 1))	
    fi
}

function cleanup ()
{
	local percent_ko=$(perl -e 'print '${KO_NUM}'.0 / '${test_n}'.0 * 100' )
	printf "\nSummary : \033[32;1m%6d OK \033[31;1m%6d KO \033[37;1m%6d TOTAL\033[m\n" $OK_NUM $KO_NUM $test_n
	if [[ ${percent_ko//.*} -lt 40 ]]
	then 
		printf "\033[32;1mPercent KO : %f%%\033[m\n" $percent_ko
	else
		printf "\033[31;1mPercent KO : %f%%\033[m\n" $percent_ko
	fi

    rm -f $printf_diff_file $printf_exec_file $printf_main_file \
    $ft_printf_diff_file $ft_printf_exec_file $ft_printf_main_file
    exit
}

# ================================== Program ================================= #
# Arg check
if [[ $# -ne 1 ]]
then
    echo "Usage $0 [Number of tests to run]"
    exit 1
fi
# Set up cleanup
trap cleanup SIGINT EXIT
# Create Working Directory
mkdir -p $WD $LOG_DIR
# Delete old LOGS
rm -f $LOG_FILE*
# Write files
write_main_files
# Run the tests
OK_NUM=0
KO_NUM=0
for (( test_n=0;test_n<$1; test_n++ ))
do
    run_test $test_n
    if [[ $? -eq 1 ]]
    then
        exit 1
    fi
done
# printf "Summary \033[32;1m%-6d OK \033[31;1m%-6d KO \033[30;1m%-6d TOTAL\033[m\n" $OK_NUM $KO_NUM $1