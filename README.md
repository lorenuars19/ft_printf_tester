# 42 ft_printf tester
Usage : 
- `curl https://raw.githubusercontent.com/lorenuars19/ft_printf_tester/master/test.sh -o test.sh && chmod 755 test.sh && ./test.sh`
```
    Usage :
            $0 -[cdtv]
            -c | --comp     complexity
            -d | --no-ko    do not ask to display logs of KO
            -t | --tests    number of tests
            -v | --verbose  verbose level [ 0 = pretty | 1 = minimal | 2 = full ]
            -u | --update   check for update and update script
            -h | --help | * displays this message
        Ex:
            $0 -t 420 -c 4 -v 0 -d
            $0 -t 5 -c 420 -v 2
            $0 -t 69 -c 69 -v 1
```
# Notes
this script tries to find your header `ft_printf.h` file and `libprintf.a` automatically
