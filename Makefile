MAKE = make

main:
	cd src && $(MAKE)

.PHONY : test clean
test : main
	cd scripts && ./test.sh ../src/main

clean :
	cd src && $(MAKE) clean
	cd scripts && rm *.r 
