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
FT_PRINTF_HEADER_FILE=$( find . -type f -name "ft_printf.h" )
FT_PRINTF_LIB_FILE=$(find . -name "libftprintf.a" )

WD=.42_Test_42_Logs_Here
no_dir_header_file=42.HeAdEr.h
header_file=$WD/$no_dir_header_file
printf_main_file=$WD/42.PrInTf.c
ft_printf_main_file=$WD/42.Ft_PrInTf.c
printf_diff_file=$WD/42.pRiNtF.DiFf
ft_printf_diff_file=$WD/42.Ft_PrInTf.DiFf
printf_exec_file=$WD/printf.exe
ft_printf_exec_file=$WD/ft_printf.exe

_GLOBAL_MAX_=16

# RND_CHARS
MAX_RND_CHARS=$_GLOBAL_MAX_

# SEQUENCE
MAX_SEQ_ITEMS=$_GLOBAL_MAX_

# RND_FLAGS
FLAG_NUM_MAX=$_GLOBAL_MAX_
NUM_CONV="iduxX"
STR_CONV='s'
CHR_CONV='c'
PTR_CONV='p'

# RND_VARS
VARS_NUM_MAX=10000
STR_LEN_MAX=$_GLOBAL_MAX_

# ================================= Functions =================================#
function write_main_files() 
{
    rm -f $printf_main_file
    echo "/*" >> $printf_main_file
    echo "** Main for testing the stdio printf" >> $printf_main_file
    echo "**" >> $printf_main_file
    echo "** by : lorenuar" >> $printf_main_file
    echo "*/" >> $printf_main_file
    echo "" >> $printf_main_file
    echo "#include \"$no_dir_header_file"\" >> $printf_main_file
    echo "" >> $printf_main_file
    echo "int"$'\t'"main(void)" >> $printf_main_file
    echo "{" >> $printf_main_file
    echo $'\t'"printf(TEST);" >> $printf_main_file
    echo $'\t'"return (0);" >> $printf_main_file
    echo "}" >> $printf_main_file
    echo "" >> $printf_main_file

    rm -f $ft_printf_main_file
    echo "/*" >> $ft_printf_main_file
    echo "** Main for testing your ft_printf" >> $ft_printf_main_file
    echo "**" >> $ft_printf_main_file
    echo "** by : lorenuar" >> $ft_printf_main_file
    echo "*/" >> $ft_printf_main_file
    echo "" >> $ft_printf_main_file
    echo "#include \"$no_dir_header_file"\" >> $ft_printf_main_file
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
    case $1 in
        rnd) return 0;;
        num) flag=$(($RANDOM%$VARS_NUM_MAX)); return 0;;
        chr) flag=$(($RANDOM%127)); return 0;;
        str) ;;
        ptr) flag=$(($RANDOM%$((VARS_NUM_MAX*100))));;
        *) return 1;;
    esac
    local is_null=$(($RANDOM%10))

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
    local max_items=$(($RANDOM%$MAX_SEQ_ITEMS))
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
        #printf "Seq["%04d"] %s %s" $se ${sequence[$se]} $flag$'\n'
        macro+=$flag
        macro+="\\\\n"
    done
    macro+="\""$sep
    se=0
    while (( $se<${#sequence} ))
    do
        gen_var ${sequence[$se]}
        #printf "Seq["%04d"] %s %s" $se ${sequence[$se]} $flag$'\n'
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
    echo $'\n\n'$macro
}

# ================================== Program ================================= #

mkdir -p $WD

write_main_files
write_header_file
write_sequence

echo $FT_PRINTF_HEADER_FILE

rm -f $printf_exec_file\
&& gcc -I../ $printf_main_file -o $printf_exec_file\
&& ./$printf_exec_file > $printf_diff_file\
&& cat -A $printf_diff_file

#gcc $ft_printf_main_file ; ./a.out

#sleep 1
#rm -f $header_file $printf_main_file $ft_printf_main_file
