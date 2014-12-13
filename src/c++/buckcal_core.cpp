#include "buckcal_mat.hpp"
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
	int *array = new int[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = atoi(x.m[i].c_str());
	int_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;
	delete[] array;
	return mat;
}

double_mat mat_double_of_string(string_mat x) {
	double *array = new double[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = atof(x.m[i].c_str());
	double_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;	
	delete[] array;
	return mat;
}

string_mat mat_string_of_int(int_mat x) {
	string *array = new string[x.rows * x.cols];
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
	string *array = new string[x.rows * x.cols];
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
	int *array = new int[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = (int) x.m[i];
	int_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;
	delete[] array;
	return mat;
}

double_mat mat_double_of_int(int_mat x)  {
	double *array = new double[x.rows * x.cols];
	for (int i = 0; i < x.rows * x.cols; i++)
		array[i] = (double) x.m[i];
	double_mat mat(array, x.rows, x.cols);
	mat.rownames = x.rownames;
	mat.colnames = x.colnames;
	delete[] array;
	return mat;
}

int_mat rowcat(int_mat mx1, int_mat mx2) {
	if (mx1.cols != mx2.cols)
		throw std::invalid_argument("rowcat: matrix does not have the same number of columns");
	int *array = new int[mx1.rows * mx1.cols + mx2.rows * mx2.cols];
	for (int i = 0; i < mx1.rows * mx1.cols; i++)
		array[i] = mx1.m[i];
	for (int i = 0; i < mx2.rows * mx2.cols; i++)
		array[i + mx1.rows * mx1.cols] = mx2.m[i];
	int_mat mat(array, mx1.rows + mx2.rows, mx1.cols);
	delete[] array;
	mat.colnames = mx1.colnames;
	mat.rownames = mx1.colnames;
	mat.rownames.insert(mat.rownames.end(), mx2.rownames.begin(), mx2.rownames.end());
	return mat;
}

double_mat rowcat(double_mat mx1, double_mat mx2) {
	if (mx1.cols != mx2.cols)
		throw std::invalid_argument("rowcat: matrix does not have the same number of columns");
	double *array = new double[mx1.rows * mx1.cols + mx2.rows * mx2.cols];
	for (int i = 0; i < mx1.rows * mx1.cols; i++)
		array[i] = mx1.m[i];
	for (int i = 0; i < mx2.rows * mx2.cols; i++)
		array[i + mx1.rows * mx1.cols] = mx2.m[i];
	double_mat mat(array, mx1.rows + mx2.rows, mx1.cols);
	delete[] array;
	mat.colnames = mx1.colnames;
	mat.rownames = mx1.colnames;
	mat.rownames.insert(mat.rownames.end(), mx2.rownames.begin(), mx2.rownames.end());
	return mat;
}

string_mat rowcat(string_mat mx1, string_mat mx2) {
	if (mx1.cols != mx2.cols)
		throw std::invalid_argument("rowcat: matrix does not have the same number of columns");
	string *array = new string[mx1.rows * mx1.cols + mx2.rows * mx2.cols];
	for (int i = 0; i < mx1.rows * mx1.cols; i++)
		array[i] = mx1.m[i];
	for (int i = 0; i < mx2.rows * mx2.cols; i++)
		array[i + mx1.rows * mx1.cols] = mx2.m[i];
	string_mat mat(array, mx1.rows + mx2.rows, mx1.cols);
	delete[] array;
	mat.colnames = mx1.colnames;
	mat.rownames = mx1.colnames;
	mat.rownames.insert(mat.rownames.end(), mx2.rownames.begin(), mx2.rownames.end());
	return mat;
}

int_mat colcat(int_mat mx1, int_mat mx2) {
	if (mx1.rows != mx2.rows)
		throw std::invalid_argument("colcat: matrix does not have the same number of rows");
	int *array = new int[mx1.rows * mx1.cols + mx2.rows * mx2.cols];
	for (int i = 0; i < mx1.rows; i++) {
		for (int j = 0; j < mx1.cols; j++)
			array[i * (mx1.cols + mx2.cols) + j] = mx1.m[i * mx1.cols + j];
		for (int j = 0; j < mx2.cols; j++)
			array[i * (mx1.cols + mx2.cols) + mx1.cols + j] = mx2.m[i * mx2.cols + j];
	}
	int_mat mat(array, mx1.rows, mx1.cols + mx2.cols);
	delete[] array;
	mat.rownames = mx1.rownames;
	mat.colnames = mx1.colnames;
	mat.colnames.insert(mat.colnames.end(), mx2.colnames.begin(), mx2.colnames.end());
	return mat;
}

double_mat colcat(double_mat mx1, double_mat mx2) {
	if (mx1.rows != mx2.rows)
		throw std::invalid_argument("colcat: matrix does not have the same number of rows");
	double *array = new double[mx1.rows * mx1.cols + mx2.rows * mx2.cols];
	for (int i = 0; i < mx1.rows; i++) {
		for (int j = 0; j < mx1.cols; j++)
			array[i * (mx1.cols + mx2.cols) + j] = mx1.m[i * mx1.cols + j];
		for (int j = 0; j < mx2.cols; j++)
			array[i * (mx1.cols + mx2.cols) + mx1.cols + j] = mx2.m[i * mx2.cols + j];
	}
	double_mat mat(array, mx1.rows, mx1.cols + mx2.cols);
	delete[] array;
	mat.rownames = mx1.rownames;
	mat.colnames = mx1.colnames;
	mat.colnames.insert(mat.colnames.end(), mx2.colnames.begin(), mx2.colnames.end());
	return mat;
}

string_mat colcat(string_mat mx1, string_mat mx2) {
	if (mx1.rows != mx2.rows)
		throw std::invalid_argument("colcat: matrix does not have the same number of rows");
	string *array = new string[mx1.rows * mx1.cols + mx2.rows * mx2.cols];
	for (int i = 0; i < mx1.rows; i++) {
		for (int j = 0; j < mx1.cols; j++)
			array[i * (mx1.cols + mx2.cols) + j] = mx1.m[i * mx1.cols + j];
		for (int j = 0; j < mx2.cols; j++)
			array[i * (mx1.cols + mx2.cols) + mx1.cols + j] = mx2.m[i * mx2.cols + j];
	}
	string_mat mat(array, mx1.rows, mx1.cols + mx2.cols);
	delete[] array;
	mat.rownames = mx1.rownames;
	mat.colnames = mx1.colnames;
	mat.colnames.insert(mat.colnames.end(), mx2.colnames.begin(), mx2.colnames.end());
	return mat;
}

void rowname(int_mat &mx, string_mat n) {
	if (mx.rows != n.cols)
		throw std::invalid_argument("rowname: name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("rowname: name matrix should have only one row");
	mx.rownames = n.m;
}

void rowname(double_mat &mx, string_mat n) {
	if (mx.rows != n.cols)
		throw std::invalid_argument("rowname: name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("rowname: name matrix should have only one row");
	mx.rownames = n.m;
}

void rowname(string_mat &mx, string_mat n) {
	if (mx.rows != n.cols)
		throw std::invalid_argument("rowname: name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("rowname: name matrix should have only one row");
	mx.rownames = n.m;
}	
	
void colname(int_mat &mx, string_mat n) {
	if (mx.cols != n.cols)
		throw std::invalid_argument("rowname: name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("rowname: name matrix should have only one row");
	mx.colnames = n.m;
}

void colname(double_mat &mx, string_mat n) {
	if (mx.cols != n.cols)
		throw std::invalid_argument("rowname: name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("rowname: name matrix should have only one row");
	mx.colnames = n.m;
}
	
void colname(string_mat &mx, string_mat n) {
	if (mx.cols != n.cols)
		throw std::invalid_argument("rowname: name matrix does not have enough entries");
	if (n.rows > 1)
		throw std::invalid_argument("rowname: name matrix should have only one row");
	mx.colnames = n.m;
}

int strlen(std::string x) {
	return x.length();
}

std::string slice(std::string x, int_mat idx) {
	if (idx.rows > 1 || idx.cols != 2)
		throw std::invalid_argument("slice: two elements are required for string range");
	return x.substr(idx.m[0] + 1, idx.m[1] + 1);
}
