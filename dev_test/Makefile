build :
	## copy C++ header here
	cp ../src/c++/buckcal_mat.hpp .
	cp ../src/c++/buckcal_mat.cpp .
	cp ../src/c++/buckcal_lib.cpp .

	../src/main.bin sample.bc sample.cpp
	g++ sample.cpp buckcal_mat.cpp buckcal_lib.cpp -o sample.bin
