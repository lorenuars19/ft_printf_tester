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
CCFLAGS="-Wall -Wextra -Werror"
# Specify the verbose level : 0 = pretty , 1 = minimal, 2 = full info
_VERBOSE=2
# The time out for execution of tests
_TIME_OUT=0.1
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
printf_exec_file=$WD/42.printf.test
ft_printf_exec_file=$WD/42.ft_printf.test

# ================================= Functions =================================#

function check_up_to_date ()
{
    checkdir=.CHECK_UP_TO_DATE_
    mkdir -p $checkdir
    ofile=$checkdir/.ofile_check_up_to_date
    nfile=$checkdir/.nfile_check_up_to_date
    rm -f $ofile $nfile
    cp $0 $ofile
    curl -s $1 -o $nfile
    diff -u $ofile $nfile >/dev/null
    local diff_ret=$?
    if [[ $diff_ret -eq 1 ]]
    then
        while true
        do
            read -p "New version exists do you want to update ?[Y/n]" yn
            case $yn in
                [Nn]* )
                    printf "\033[033mYou cancelled the update\033[0m\n"
                    rm -rf $checkdir $ofile $nfile
                return;;
                [Yy]* | * )
                    printf "\033[33mDownloading new update ..."
                    cp $nfile $0
                    printf " \033[32;1mUpdated successfully.\033[0m\n"
                    rm -rf $checkdir $ofile $nfile
                return;;
            esac
        done
    else
        printf "\033[32;1mYou have the latest version\033[0m\n"
    fi
    rm -rf $checkdir $ofile $nfile
}

function write_main_files()
{
    # Writes the main for STDIO Printf
    if [[ ! -f $printf_main_file ]]
    then
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
	printf(\"|\n< Return %08d >\n\", printf(\"|\" TEST));
	return (0);
}
        " > $printf_main_file
    fi
    # Writes the main for your ft_printf
    if [[ ! -f $ft_printf_main_file ]]
    then
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
	ft_printf(\"|\n< Return %08d >\n\", ft_printf(\"|\" TEST ));
	return (0);
}
        " > $ft_printf_main_file
    fi
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
    " > $header_file
    # This is where all the magic happens
    write_sequence
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
    flag=""
    case $1 in
        FLG)
            flag="%"
        return 0;;
        NO)
            flag=""
        return 0;;
        SP)
            flag=" "
        return 0;;
        ZR)
            flag="0"
        return 0;;
        ST*)
            set -f
            flag="*"
        return 0;;
        DT)
            flag="."
        return 0;;
        FW)
            rnd_number $FLAG_NUM_MAX
            flag=$R_NUM
        return 0;;
        PR)
            rnd_number $FLAG_NUM_MAX 0
            flag=$R_NUM
        return 0;;
        CV_CHR)
            flag='c'
        return 0;;
        CV_STR)
            flag='s'
        return 0;;
        CV_PTR)
            flag='p'
        return 0;;
        CV_NUM)
            flag=${NUM_CONV:$(($RANDOM%${#NUM_CONV})):1}
        return 0;;
        rnd)
            flag=""
            rnd_chars $MAX_RND_CHARS
        return 0;;
        *)
        return 1;;
    esac
}

function gen_var ()
{
    flag=''
    local is_null=$(($RANDOM%10))
    case $1 in
        ST_FW)
            rnd_number $FLAG_NUM_MAX
            flag=$R_NUM
        return 0;;
        ST_PR)
            rnd_number $FLAG_NUM_MAX 0
            flag=$R_NUM
        return 0;;
        CV_CHR)
            rnd_number 127 0
            flag=$R_NUM
        return 0;;
        CV_STR)
            flag+=\"
            rnd_chars $MAX_RND_CHARS
            flag+=\"
        return 0;;
        CV_PTR)
            flag="NULL"
        return 0;;
        CV_NUM)
            rnd_number $FLAG_NUM_MAX
            flag=$R_NUM
        return 0;;
        *)
        return 0;;
    esac
}

function rnd_number ()
{
    local negative=$(($RANDOM%2))
    R_NUM=$(($RANDOM%$1))
    if [[ negative -eq 1 ]] && [[ -z $2 ]]
    then
        R_NUM=$((-$R_NUM))
    fi
}

function gen_sequence ()
{
    sequence=( )
    local max_items=$MAX_SEQ_ITEMS
    local zero_items=( ZR NO )
    local conv_items=( CV_NUM CV_STR CV_CHR CV_PTR )
    for (( it=0; it<$max_items; it++ ))
    do
        local flag_or_rnd=$(($RANDOM%2))
        if [[ $flag_or_rnd -eq 1 ]] && [[ $_GLOBAL_MAX_ -ge 5 ]]
        then
            sequence+=( rnd )
        else
            sequence+=( FLG )
            local has_precision=$(($RANDOM%2))
            local fw_star=$(($RANDOM%2))
            local pr_star=$(($RANDOM%2))
            local conv=${conv_items[$(($RANDOM%${#conv_items[@]}))]}

            if [[ $has_precision -eq 1 ]]
            then
                zero_items=( NO )
            fi
            if [[ $conv = "CV_STR" ]] || [[ $conv = "CV_CHR" ]] || [[ $conv = "CV_PTR" ]]
            then
                zero_items=( NO )
            fi
            if [[ $conv = "CV_PTR" ]] || [[ $conv = "CV_CHR" ]]
            then
                has_precision=0
            fi

            local zero_space_nothing=${zero_items[$(($RANDOM%${#zero_items[@]}))]}
            sequence+=( $zero_space_nothing )

            if [[ $fw_star -eq 1 ]]
            then
                sequence+=( ST_FW )
            else
                sequence+=( FW )
            fi
            if [[ $has_precision -eq 1 ]]
            then
                sequence+=( DT )
                if [[ $pr_star -eq 1 ]]
                then
                    sequence+=( ST_PR )
                else
                    sequence+=( PR )
                fi
            fi
            sequence+=( $conv )
        fi
    done
}

function write_sequence ()
{
    set -f
    local sep=", "
    macro="# define TEST \""
    gen_sequence
    for (( se=0; se<${#sequence[@]}; se++ ))
    do
        gen_flag ${sequence[$se]}
        macro+="$flag"
    done
    macro+="\""$sep
    se=0
    while (( $se<${#sequence[@]} ))
    do
        gen_var ${sequence[$se]}
        macro+="$flag"
        se=$((se+1))
        if [[ $se -lt ${#sequence[@]} ]] && [[ -n $flag ]]
        then
            macro+="$sep"
        fi
    done
    if [[ ${macro:$((${#macro} - ${#sep})):${#sep}} == $sep ]]
    then
        macro=${macro:0:$((${#macro} - ${#sep}))}
    fi
    echo $macro >> $header_file
    echo "#endif" >> $header_file
    set +f
}

# **************************************************************************** #
#                               RUNNING TESTS                                  #
# **************************************************************************** #

time_out_clean_up()
{
    trap - ALRM
    kill -ALRM $a >/dev/null 2>&1
    kill $! >/dev/null 2>&1 &&
    return 124
}

time_out_watcher()
{
    trap "time_out_clean_up" ALRM >/dev/null 2>&1
    sleep $1&
    wait $! >/dev/null 2>&1
    kill -ALRM $$ >/dev/null 2>&1
}

time_out ()
{
    time_out_watcher $1&
    a=$!
    shift
    trap "time_out_clean_up" ALRM >/dev/null
    "$@"&
    T+=( $! )
    if ps -p $! >/dev/null 2>&1
    then
        wait -nf $! >/dev/null 2>&1
    fi
    RET=$?
    if ps -p $a >/dev/null 2>&1
    then
        wait -n $a >/dev/null 2>&1
    fi
    kill -ALRM $a >/dev/null 2>&1
    return $RET
}

function compile_run()
{
    rm -f $printf_exec_file
    if [[ -f $printf_main_file ]]
    then
        if ! gcc $CCFLAGS -I. $printf_main_file -o $printf_exec_file 2>/dev/null
        then
            if [[ $_VERBOSE -ge 3 ]]
            then
                printf "\nTEST : %-6d \033[34;1m STDIO PRINTF COMPILATION ERROR (tester made invalid pattern)\033[m\n" $test_n
                echo $macro
                gcc $CCFLAGS -I. $printf_main_file -o $printf_exec_file
            fi
            macro=''
            sequence=()
            run_test $test_n
            return 3
        fi
    fi

    if [[ -f $printf_exec_file ]] && time_out $_TIME_OUT ./$printf_exec_file > $printf_diff_file ; STD_RET=$?
    then
        echo >> $printf_diff_file
    else
        printf "\n= = = TEST : %-6d STDIO PRINTF TIMEOUT or EXEC ERROR %3d\n" $test_n $STD_RET >> $LOG_FILE"_"$test_n
        echo $macro >> $LOG_FILE"_"$test_n
        if [[ $_VERBOSE -ge 1 ]]
        then
            printf "\n= = = TEST : %-6d \033[33;1m STDIO PRINTF TIMEOUT or EXEC ERROR %3d\033[m\n" $test_n $STD_RET >> $LOG_FILE"_"$test_n
            echo $macro >> $LOG_FILE"_"$test_n
        fi
        return 1
    fi

    rm -f $ft_printf_exec_file
    if [[ -f $ft_printf_main_file ]]
    then
        if ! gcc $CCFLAGS -I../ $ft_printf_main_file $FT_PRINTF_LIB_FILE -o $ft_printf_exec_file
        then
            printf "\033[1;31m FT_PRINTF : COMPILE ERROR\033[m\n"
            return 2
        fi
    fi

    if [[ -f $ft_printf_exec_file ]] && time_out $_TIME_OUT ./$ft_printf_exec_file > $ft_printf_diff_file ; RET=$?
    then
        echo >> $ft_printf_diff_file
    else
        if [[ $_VERBOSE -ge 1 ]]
        then
            printf "\nTEST : %-6d \033[33;1m FT_printf TIME OUT or EXEC ERROR %3d\033[m\n" $test_n $RET
            echo $macro
            TO_NUM=$((TO_NUM + 1))
        elif [[ $_VERBOSE -ge 0 ]]
        then
            printf "\033[33;1m&%d \033[0m" $test_n
        fi
        printf "\n= = = TEST : %-6d FT_printf TIME OUT or EXEC ERROR %3d\n" $test_n $RET >> $LOG_FILE"_"$test_n
        echo $macro >> $LOG_FILE"_"$test_n
        return 1
    fi

    return 0
}

function validate_test ()
{
    if [[ $_VERBOSE -ge 3 ]]
    then
        gcc $CCFLAGS -I. $printf_main_file -o $printf_exec_file
    fi
    if ! gcc $CCFLAGS -I. $printf_main_file -o $printf_exec_file >/dev/null 2>&1
    then
        return 1
    fi
    return 0
}

function run_test ()
{
    test_valid=0
    while [[ test_valid -eq 0 ]]
    do
        write_main_files
        write_header_file
        if validate_test
        then
            test_valid=1
        fi
    done

    if ! compile_run
    then
        return $?
    fi

    printf "\n= = = TEST : %-6d = =\n" $test_n >> $LOG_FILE"_"$test_n
    echo $macro >> $LOG_FILE"_"$test_n
    if [[ $_VERBOSE -ge 1 ]]
    then
        printf "TEST% 6d : " $test_n
    fi
    if [[ -e $ft_printf_diff_file ]] && [[ -e $printf_diff_file ]]
    then
        diff -a -s -u  --label STDIO $printf_diff_file --label FT_42 $ft_printf_diff_file >> $LOG_FILE"_"$test_n
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
        elif [[ $_VERBOSE -eq 0 ]]
        then
            printf "\033[32;1m*%d \033[m" $test_n
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
                if [[ -e $ft_printf_diff_file ]] && [[ -e $printf_diff_file ]]
                then
                    if [[ $(uname) == "Linux" ]]
                    then
                        diff --suppress-blank-empty -w -B --color=always -a -u  --label STDIO $printf_diff_file --label FT_42 $ft_printf_diff_file
                    else
                        diff -a -u  --label STDIO $printf_diff_file --label FT_42 $ft_printf_diff_file
                    fi
                fi
            fi
        elif [[ $_VERBOSE -eq 0 ]]
        then
            printf "\033[31;1m!%d \033[m" $test_n
        fi
        KO_NUM=$((KO_NUM + 1))
        return 2
    fi
}

function print_summary ()
{
    if [[ $test_n -le 0 ]]
    then
        test_n=$(($test_n + 1))
    fi
    KO_NUM=${#KO_ARR[@]}
    OK_NUM=${#OK_ARR[@]}
    TO_NUM=${#TO_ARR[@]}
    TOTAL=$(( $KO_NUM + $OK_NUM + $TO_NUM ))
    local percent_ko=$(perl -e 'print '${KO_NUM}'.0 / '${test_n}'.0 * 100' )
    printf "\nSummary : \033[32;1m%6d OK \033[31;1m%6d KO \033[33;1m%6d TO\033[37;1m%6d TOTAL \033[m\t" $OK_NUM $KO_NUM $TO_NUM $TOTAL
    if [[ ${percent_ko//.*} -lt 20 ]] && [[ ${percent_ko//*} != '0' ]]
    then
        printf "\033[32;1mPercent KO : %f%%\033[m\n" $percent_ko
    else
        printf "\033[31;1mPercent KO : %f%%\033[m\n" $percent_ko
    fi

    echo ${TO_ARR[@]}
}

function cleanup ()
{
    print_summary
    rm -f $printf_diff_file $printf_exec_file $printf_main_file $ft_printf_diff_file $ft_printf_exec_file $ft_printf_main_file
    rm -rf $checkdir $ofile $nfile
    kill ${T[@]} 2>/dev/null
    exit
}

function input_files()
{
    if [[ -e Makefile ]] || [[ -e makefile ]]
    then
        make re
    fi
    FT_PRINTF_HEADER_FILE=$( cd $WD && find ../ -type f -name "ft_printf.h" )
    if [[ -z $FT_PRINTF_HEADER_FILE ]]
    then
        echo "ft_printf.h Not Found"
        exit 1
    fi
    FT_PRINTF_LIB_FILE=$( find . -name "libftprintf.a" )
    if [[ -z $FT_PRINTF_LIB_FILE ]]
    then
        echo "libftprintf.a Not Found"
        exit 1
    fi
}

function usage  ()
{
    echo "\
    Usage :
        $0 -[cdtv]
        -c | --comp     complexity
        -d | --no-ko    do not ask to display logs of KO
        -t | --tests    number of tests
        -v | --verbose  verbose level [ 0 = pretty | 1 = minimal | 2 = full ]
        -u | --update   check for update and update script
        -h | --help     displays this message
    Ex:
        $0 -t 420 -c 4 -v 0 -d
        $0 -t 5 -c 420 -v 2
        $0 -t 69 -c 69 -v 1
    "
    cleanup
}
# ================================== Program ================================= #

# set -vbT

# Arg check
NO_DISPLAY=0
MAX_TESTS=5
_VERBOSE=0
_GLOBAL_MAX_=4

if [[ $# -eq 0 ]]
then
    usage
fi
while [[ $1 != "" ]]
do
    case $1 in
        -v | --verbose )
            shift
        _VERBOSE=$1;;
        -t | --tests )
            shift
        MAX_TESTS=$1;;
        -c | --comp )
            shift
        _GLOBAL_MAX_=$1;;
        -d | --no-ko )
        NO_DISPLAY=1;;
        -u | --update )
            check_up_to_date "https://raw.githubusercontent.com/lorenuars19/ft_printf_tester/master/test.sh"
        exit;;
        -h | --help | *)
        usage;;
    esac
    shift
done

if [[ $_GLOBAL_MAX_ -lt 0 ]]
then
    _GLOBAL_MAX_=0
fi
# Max number of generated chars
MAX_RND_CHARS=$(( 1 + ($_GLOBAL_MAX_) ))
# Max number of sequence items
MAX_SEQ_ITEMS=$(( $_GLOBAL_MAX_ ))
# Max number for flag params
FLAG_NUM_MAX=20
if [[ $FLAG_NUM_MAX -ge 42 ]]
then
    FLAG_NUM_MAX=42
fi
# Delete old LOGS
rm -rf $LOG_DIR
# Create Working Directory
mkdir -p $WD $LOG_DIR
# Run make & Check input files
input_files

write_main_files
# Set up cleanup
trap cleanup SIGINT EXIT SIGSEGV SIGABRT SIGBUS
# Run the tests
OK_NUM=0
KO_NUM=0
TO_NUM=0
declare -a KO_ARR TO_ARR OK_ARR
KO_ARR=( )
OK_ARR=( )
TO_ARR=( )
for (( test_n = 1 ; test_n <= $MAX_TESTS ; test_n++ ))
do
    write_main_files
    status=3
    while [[ $status -eq 3 ]]
    do
        run_test $test_n
        status=$?
    done

    if [[ $status -eq 2 ]]
    then
        KO_ARR+=( $LOG_FILE"_"$test_n )
    elif [[ $status -eq 1 ]]
    then
        TO_ARR+=( $test_n )
    elif [[ $status -eq 0 ]]
    then
        OK_ARR+=( $test_n )
    fi
done
if [[ KO_NUM -gt 0 ]]
then
    print_summary
    rm -f $LOG_DISPLAY_FILE \
    && echo "cat "${KO_ARR[@]}" | less" > $LOG_DISPLAY_FILE \
    && chmod 775 $LOG_DISPLAY_FILE
    printf "\033[36;1m\n./%s\n\033[mTo display KO Logs at anytime\n" $LOG_DISPLAY_FILE

    while true && [[ $NO_DISPLAY -eq 0 ]]
    do
        read -p "Do you want to display all the logs of the failed tests in less ?[y/N]" yn
        case $yn in
            [Yy]* )
                ./$LOG_DISPLAY_FILE
            break;;
            [Nn]* )
            exit;;
            * )
            exit;;
        esac
    done
fi