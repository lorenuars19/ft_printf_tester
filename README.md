# 42 ft_printf tester
Usage : 
- `curl https://raw.githubusercontent.com/lorenuars19/ft_printf_tester/master/test.sh -o test.sh && chmod 755 test.sh`
```
   Usage :
        ./test.sh -[cdtv]
        -c | --comp     complexity
        -d | --no-ko    do not ask to display logs of KO
        -t | --tests    number of tests
        -v | --verbose  verbose level [ 0 = pretty | 1 = minimal | 2 = full ]
    Ex:
        ./test.sh -t 420 -c 4 -v 0 -d
        ./test.sh -t 5 -c 420 -v 2
        ./test.sh -t 69 -c 69 -v 1
```
# Notes
this script is very simple and very dumb, yet it finds your header `ft_printf.h` file and `libprintf.a` automatically
