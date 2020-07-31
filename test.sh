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
# Specify the verbose level : 0 = pretty , 1 = minimal, 2 = full info 
_VERBOSE=2
# The time out for execution of tests
_TIME_OUT=1
# The global max for fast tweaking of below maximums
_GLOBAL_MAX_=20
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
LOG_DIR=$WD/42.LOGS_HERE       	# The LOGS Directory
LOG_FILE=$LOG_DIR/42.LOGS      	# The LOGS file
LOG_DISPLAY_FILE=$WD/42.KO_LOGS.42.sh
# Down here are all the file names WITH 42's E V E R Y W H E R E
no_dir_header_file=42.HeAdEr.h
header_file=$WD/$no_dir_header_file
printf_main_file=$WD/42.PrInTf.c
ft_printf_main_file=$WD/42.Ft_PrInTf.c
printf_diff_file=$WD/42.pRiNtF.DiFf
ft_printf_diff_file=$WD/42.Ft_PrInTf.DiFf
printf_exec_file=$WD/42.printf.exe
ft_printf_exec_file=$WD/42.ft_printf.exe

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
    local max_items=$MAX_SEQ_ITEMS
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

function time_out_kill()
{
    trap - ALRM TERM
    kill -ALRM $sleepkill 2>/dev/null
    kill -ALRM $! 2>/dev/null && return 124
}

function time_out_sleepkill()
{
    trap "time_out_kill" ALRM
    sleep $1& wait
    kill -TERM $command 2>/dev/null
}

function time_out ()
{   
    time_out_sleepkill $1& sleepkill=$!
    shift
    trap "time_out_kill" ALRM TERM
    "$@" & command=$! ; wait $command; RET=$?
    kill -TERM $sleepkill 2>/dev/null
    return $RET          
}

function compile_run()
{
    rm -f $printf_exec_file
    if [[ -e $printf_main_file ]] ; then
        gcc -I. $printf_main_file -o $printf_exec_file
    fi
    if [[ -e $printf_exec_file ]] && time_out $_TIME_OUT ./$printf_exec_file > $printf_diff_file
    then
        echo >> $printf_diff_file
    else
        if [[ $_VERBOSE -ge 1 ]] ; then
            printf "\nTEST : %-6d \033[31;1m STDIO PRINTF TIME OUT or EXEC ERROR\033[m\n" $test_n
            echo $macro
            KO_NUM=$((KO_NUM + 1))
        fi
        printf "\n= = = TEST : %-6d STDIO PRINTF TIMEOUT or EXEC ERROR\n" $test_n >> $LOG_FILE"_"$test_n
		echo $macro >> $LOG_FILE"_"$test_n
        return 2
    fi
    
    rm -f $ft_printf_exec_file
    if [[ -e $ft_printf_main_file ]] ; then
       if ! gcc -I../ $ft_printf_main_file $FT_PRINTF_LIB_FILE -o $ft_printf_exec_file ; then 
        printf "\033[1;31mCOMPILE ERROR\033[m\n" ; return 3
        fi
    fi
    if [[ -e $ft_printf_exec_file ]] && time_out $_TIME_OUT ./$ft_printf_exec_file > $ft_printf_diff_file
    then
        echo >> $ft_printf_diff_file
    else
        if [[ $_VERBOSE -ge 1 ]]
        then
            printf "\nTEST : %-6d \033[31;1m FT_printf TIME OUT or EXEC ERROR\033[m\n" $test_n
            echo $macro
            KO_NUM=$((KO_NUM + 1))
        fi
        printf "\n= = = TEST : %-6d FT_printf TIME OUT or EXEC ERROR\n" $test_n >> $LOG_FILE"_"$test_n
		echo $macro >> $LOG_FILE"_"$test_n
        exit 2
    fi
}

function run_test ()
{
    write_header_file
    
    if ! compile_run ; then return 1
    fi   

    printf "\n= = = TEST : %-6d = =\n" $test_n >> $LOG_FILE"_"$test_n
    echo $macro >> $LOG_FILE"_"$test_n
	
    if [[ $_VERBOSE -ge 1 ]]; then printf "TEST% 6d : " $test_n
	fi
    
    if [[ -e $ft_printf_diff_file ]] && [[ -e $printf_diff_file ]]; then
        diff -a -s -u --label FT_42 $ft_printf_diff_file --label STDIO $printf_diff_file >> $LOG_FILE"_"$test_n
    fi
    
    if [[ $? -eq 0 ]]
    then
		if [[ $_VERBOSE -ge 1 ]]
		then
        	printf "\033[32;1m + OK +\033[m\n" $test_n
			cat $ft_printf_diff_file >> $LOG_FILE"_"$test_n
			if [[ $_VERBOSE -ge 2 ]]
			then
				echo $macro
				cat $ft_printf_diff_file
			fi
		elif [[ $_VERBOSE -eq 0 ]]; then printf "\033[32;1m*\033[m"
		fi
        echo OK >> $LOG_FILE"_"$test_n
		OK_NUM=$((OK_NUM + 1))
		return 0
    else
		if [[ $_VERBOSE -ge 1 ]]
		then
        	printf "\033[31;1m ! KO !\033[m\n" $test_n
			if [[ $_VERBOSE -ge 2 ]]
			then
    			echo $macro
                if [[ -e $ft_printf_diff_file ]] && [[ -e $printf_diff_file ]]; then
        		    diff --color=always -a -u --label FT_42 $ft_printf_diff_file --label STDIO $printf_diff_file
                fi
			fi
		elif [[ $_VERBOSE -eq 0 ]]; then printf "\033[31;1m!%-6d\033[m" $test_n
		fi
		KO_NUM=$((KO_NUM + 1))
		return 2
    fi
}

function print_summary ()
{
    if [[ $test_n -le 0 ]] ; then test_n=$(($test_n + 1))
    fi

	local percent_ko=$(perl -e 'print '${KO_NUM}'.0 / '${test_n}'.0 * 100' )

	printf "\nSummary : \033[32;1m%6d OK \033[31;1m%6d KO \033[37;1m%6d TOTAL\033[m\t" $OK_NUM $KO_NUM $test_n

	if [[ ${percent_ko//.*} -lt 40 ]] && [[ ${percent_ko//*} != '0' ]]
	then 
		printf "\033[32;1mPercent KO : %f%%\033[m\n" $percent_ko
	else
		printf "\033[31;1mPercent KO : %f%%\033[m\n" $percent_ko
	fi
}

function cleanup ()
{
	print_summary
    rm -f $printf_diff_file $printf_exec_file $printf_main_file $ft_printf_diff_file $ft_printf_exec_file $ft_printf_main_file
    exit
}

function input_files()
{
    if [[ -e Makefile ]] || [[ -e makefile ]]; then make; fi
    FT_PRINTF_HEADER_FILE=$( cd $WD && find ../ -type f -name "ft_printf.h" )
    if [[ -z $FT_PRINTF_HEADER_FILE ]] ; then echo "ft_printf.h Not Found" ; exit 1
    fi
    FT_PRINTF_LIB_FILE=$( find . -name "libftprintf.a" )
    if [[ -z $FT_PRINTF_LIB_FILE ]] ; then echo "libftprintf.a Not Found" ; exit 1
    fi
}

function usage()
{
    echo "\
    Usage :
        $0 -[cdtv]
        -c | --comp     complexity
        -d | --no-ko    do not ask to display logs of KO
        -t | --tests    number of tests
        -v | --verbose  verbose level
                        0 = pretty
                        1 = minimal
                        2 = full
    "
    exit 1
}
# ================================== Program ================================= #
# Arg check
NO_DISPLAY=0
MAX_TESTS=1
_VERBOSE=0
_GLOBAL_MAX_=2

while [[ $1 != "" ]]; do
    case $1 in
    -v | --verbose )    shift ; _VERBOSE=$1;;
    -t | --tests )      shift ; MAX_TESTS=$1;;
    -c | --comp ) shift ; _GLOBAL_MAX_=$1;;
    -d | --no-ko ) NO_DISPLAY=1;;
    *) usage;;
    esac
    shift
done
# Max number of generated chars
MAX_RND_CHARS=$_GLOBAL_MAX_
# Max number of sequence items
MAX_SEQ_ITEMS=$_GLOBAL_MAX_
# Max number for flag params
FLAG_NUM_MAX=$_GLOBAL_MAX_

# Delete old LOGS
rm -f $LOG_FILE*
# Create Working Directory
mkdir -p $WD $LOG_DIR
# Run make & Check input files
input_files
# Write files
write_main_files
# Set up cleanup
trap cleanup SIGINT EXIT SIGSEGV SIGABRT SIGBUS
# Run the tests
OK_NUM=0
KO_NUM=0
declare -a KO_ARR
for (( test_n=0;test_n<$MAX_TESTS; test_n++ ))
do
    run_test $test_n
	status=$?
	if [[ $status -ne 0 ]] 
	then
		KO_ARR+=( $LOG_FILE"_"$test_n )
    fi
done
if [[ KO_NUM -gt 0 ]]
then
    print_summary
    rm -f $LOG_DISPLAY_FILE \
    && echo "cat "${KO_ARR[@]}" | less" > $LOG_DISPLAY_FILE \
    && chmod 775 $LOG_DISPLAY_FILE

    while true && [[ ! $NO_DISPLAY ]] ; do
        read -p "Do you want to display all the logs of the failed tests in less ?" yn
        case $yn in
            [Yy]* ) ./$LOG_DISPLAY_FILE; break;;
            [Nn]* ) exit;;
            * ) exit;;
        esac
    done
fi