#include "buckcal_mat.hpp"
#include <string>
#include <cstdlib>

using namespace std;

/* get number of rows and columns */
int rows(int_mat mx) {
	return mx.rows;
}

int rows(double_mat mx) {
	return mx.rows;
}

int rows(string_mat mx) {
	return mx.rows;
}

int cols(int_mat mx) {
	return mx.cols;
}

int cols(double_mat mx) {
	return mx.cols;
}

int cols(string_mat mx) {
	return mx.cols;
}

/* data conversion */
string string_of_int(int x) {
	ostringstream ss;
	ss << x;
	return ss.str();
}

string string_of_double(double x) {
	ostringstream ss;
	ss << x;
	return ss.str();
}

int int_of_string(string x) {
	return atoi(x.c_str());
}

double double_of_string(string x) {
	return atof(x.c_str());
}

int_mat mat_int_of_string(string_mat x) {
	int* array = new int[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = atoi(x.m[i].c_str());
	int_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;
	delete[] array;
	return mat;
}

double_mat mat_double_of_string(string_mat x) {
	double* array = new double[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = atof(x.m[i].c_str());
	double_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;	
	delete[] array;
	return mat;
}

string_mat mat_string_of_int(int_mat x) {
	string* array = new string[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++) {
		ostringstream ss;
		ss << x.m[i];
		array[i] = ss.str();
	}
	string_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;
	delete[] array;
	return mat;
}

string_mat mat_string_of_double(double_mat x) {
	string* array = new string[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++) {
		ostringstream ss;
		ss << x.m[i];
		array[i] = ss.str();
	}
	string_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;
	delete[] array;
	return mat;
}

int_mat mat_int_of_double(double_mat x) {
	int* array = new int[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = (int) x.m[i];
	int_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;
	delete[] array;
	return mat;
}

double_mat mat_double_of_int(int_mat x)  {
	double* array = new double[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = (double) x.m[i];
	double_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;
	delete[] array;
	return mat;
}

//int_mat rowcat(int_mat mx1, int_mat mx2) ;
//double_mat rowcat(double_mat mx1, double_mat mx2) ;
//string_mat rowcat(string_mat mx1, string_mat mx2) ;
//int_mat colcat(int_mat mx1, int_mat mx2) ;
//double_mat colcat(double_mat mx1, double_mat mx2) ;
//string_mat colcat(string_mat mx1, string_mat mx2) ;

void rowname(int_mat mx, string_mat n) {
	if (mx.rows != n.cols)
		throw std::invalid_argument("Name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("Name matrix should have only one line");
	mx.colnames = n.m;
}

void rowname(double_mat mx, string_mat n) {
	if (mx.rows != n.cols)
		throw std::invalid_argument("Name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("Name matrix should have only one line");
	mx.colnames = n.m;
}

void rowname(string_mat mx, string_mat n) {
	if (mx.rows != n.cols)
		throw std::invalid_argument("Name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("Name matrix should have only one line");
	mx.colnames = n.m;
}	
	
void colname(int_mat mx, string_mat n) {
	if (mx.cols != n.cols)
		throw std::invalid_argument("Name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("Name matrix should have only one line");
	mx.colnames = n.m;
}

void colname(double_mat mx, string_mat n) {
	if (mx.cols != n.cols)
		throw std::invalid_argument("Name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("Name matrix should have only one line");
	mx.colnames = n.m;
}
	
void colname(string_mat mx, string_mat n) {
	if (mx.cols != n.cols)
		throw std::invalid_argument("Name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("Name matrix should have only one line");
	mx.colnames = n.m;
}
