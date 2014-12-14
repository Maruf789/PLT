MAKE=make

all : clean
	cd src && $(MAKE)

.PHONY : test clean
test :
	cd test && ./test.sh ../src/main.bin

clean :
	-cd src && $(MAKE) clean
	-cd test && $(MAKE) clean 

