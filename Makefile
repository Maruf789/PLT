MAKE = make

main: clean
	cd src && $(MAKE)

.PHONY : test clean
test :
	cd scripts && ./test.sh ../src/main.bin

clean :
	cd src && $(MAKE) clean
	cd scripts && rm -f *.r 
	cd scripts/test_outputs && rm -f *out.txt