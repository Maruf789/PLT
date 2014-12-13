CPP := clang++
CFLAGS := -g -Wall -Werror
OBJECTS := buckcal_mat.o buckcal_core.o buckcal_lib.o sample.o
OUTPUT := sample.bin

all: copy buckcal $(OBJECTS)
	$(CPP) $(CFLAGS) $(OBJECTS) -o $(OUTPUT)

copy:
	cp ../src/c++/buckcal_mat.hpp .
	cp ../src/c++/buckcal_mat.cpp .
	cp ../src/c++/buckcal_core.cpp .
	cp ../src/libraryFiles/buckcal_lib.bc .

buckcal:
	#../src/main.bin buckcal_lib.bc buckcal_lib.cpp
	../src/main.bin sample.bc sample.cpp

%.o: %.cpp
	$(CPP) $(CFLAGS) -c $^

clean:
	rm -f $(OUTPUT)
	rm -f $(OBJECTS)

.PHONY: clean

