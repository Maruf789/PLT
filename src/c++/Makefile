CPP := clang++
CFLAGS := -g -Wall -Werror
OBJECTS := buckcal_mat.o buckcal_mat_test.o
OUTPUT := buckcal_mat_test

all: $(OBJECTS)
	$(CPP) $(CFLAGS) -o $(OUTPUT) $(OBJECTS)

%.o: %.cpp
	$(CPP) $(CFLAGS) -c $^

clean:
	rm -f buckcal_mat_test
	rm -f $(OBJECTS)

.PHONY: clean


