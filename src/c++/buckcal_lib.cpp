#include "buckcal_mat.hpp"
#include <string>
#include <cstdio>
#include <sstream>
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
	return to_string(x);
}

string string_of_double(double x) {
	return to_string(x);
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
	delete array;
	return mat;
}

double_mat mat_double_of_string(string_mat x) {
	double* array = new double[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = atof(x.m[i].c_str());
	double_mat mat(array, x.rows, x.cols);
	delete array;
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
	delete array;
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
	delete array;
	return mat;
}

int_mat mat_int_of_double(double_mat x) {
	int* array = new int[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = (int) x.m[i];
	int_mat mat(array, x.rows, x.cols);
	delete array;
	return mat;
}

double_mat mat_double_of_int(int_mat x)  {
	double* array = new double[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = (double) x.m[i];
	double_mat mat(array, x.rows, x.cols);
	delete array;
	return mat;
}
