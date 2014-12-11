#include "buckcal_mat.hpp"
#include <string>
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
	return stoi(x);
}

double double_of_string(string x) {
	return stod(x);
}

int_mat mat_int_of_string(string_mat x) {
	int* array = new int[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = stoi(x.m[i]);
	int_mat mat(array, x.rows, x.cols);
	delete array;
	return mat;
}

double_mat mat_double_of_string(string_mat x) {
	double* array = new double[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = stod(x.m[i]);
	double_mat mat(array, x.rows, x.cols);
	delete array;
	return mat;
}

string_mat mat_string_of_int(int_mat x) {
	string* array = new string[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = to_string(x.m[i]);
	string_mat mat(array, x.rows, x.cols);
	delete array;
	return mat;
}

string_mat mat_string_of_double(double_mat x) {
	string* array = new string[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = to_(x.m[i]);
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
