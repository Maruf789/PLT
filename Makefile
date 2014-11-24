MAKE = make

main:
	cd src && $(MAKE)

.PHONY : test clean
test : main
	cd scripts && ./test.sh ../src/main.bin

clean :
	cd src && $(MAKE) clean
	cd scripts && rm -f *.r 
	cd scripts/test_outputs && rm -f *out.txt
