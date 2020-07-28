# 42 ft_printf tester
Usage : 
- `curl https://raw.githubusercontent.com/lorenuars19/ft_printf_tester/master/test.sh`
- `./test.sh [number of tests]`
# Vars there are some variables you can tweak at the top of the file
``` bash
# =============================== Global variables =========================== #
# = = = = = = = = = = = = = = = YOU CAN TWEAK THESES = = = = = = = = = = = = = #
# The time out for execution of tests
_TIME_OUT=3
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
```
# Notes
this script is very simple and very dumb, yet it finds your header `ft_printf.h` file and `libprintf.a` automatically
