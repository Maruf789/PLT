MAKE = make

build : clean
	cd src && $(MAKE)

.PHONY : test clean
test : build
	cd scripts && ./test.sh ../src/main.bin

clean :
	-cd src && $(MAKE) clean
	-cd scripts && $(MAKE) clean 
	-cd scripts/test_outputs && rm -f *out.txt
	-cd scripts/cfiles && rm -f *.cpp *.h *.hpp
	-cd scripts/binfiles && rm -f *.bin
