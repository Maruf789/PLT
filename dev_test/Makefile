CPP := g++
CXXLAGS := -g -Wall -Werror
OBJECTS := buckcal_mat.o buckcal_core.o sample.o
OUTPUT := sample.bin

all: clean copy buckcal $(OBJECTS) 
	$(CPP) $(CXXLAGS) -o $(OUTPUT) $(OBJECTS) 

copy:
	cp ../src/c++/buckcal_mat.hpp .
	cp ../src/c++/buckcal_mat.cpp .
	cp ../src/c++/buckcal_core.cpp .
	cp ../src/libraryFiles/buckcal_lib.bc .

buckcal:
	../src/main.bin sample.bc sample.cpp

%.o: %.cpp
	$(CPP) $(CXXLAGS) -c $^

clean:
	rm -f $(OUTPUT)
	rm -f $(OBJECTS)
	rm -f *.cpp
	rm -f *.h*

.PHONY: clean

