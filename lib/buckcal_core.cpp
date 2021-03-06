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

/* row and column concatenation */
int_mat rowcat(int_mat mx1, int_mat mx2) {
	if (mx1.rows == 0 || mx1.cols == 0)
		return mx2;
	if (mx2.rows == 0 || mx2.cols == 0)
		return mx1;
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
	mat.rownames = mx1.rownames;
	mat.rownames.insert(mat.rownames.end(), mx2.rownames.begin(), mx2.rownames.end());
	return mat;
}

double_mat rowcat(double_mat mx1, double_mat mx2) {
	if (mx1.rows == 0 || mx1.cols == 0)
		return mx2;
	if (mx2.rows == 0 || mx2.cols == 0)
		return mx1;
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
	mat.rownames = mx1.rownames;
	mat.rownames.insert(mat.rownames.end(), mx2.rownames.begin(), mx2.rownames.end());
	return mat;
}

int_mat rowcat(int_mat mx1, double_mat mx2) {
	return rowcat(mx1, (int_mat) mx2);
}

double_mat rowcat(double_mat mx1, int_mat mx2) {
	return rowcat(mx1, (double_mat) mx2);
}

string_mat rowcat(string_mat mx1, string_mat mx2) {
	if (mx1.rows == 0 || mx1.cols == 0)
		return mx2;
	if (mx2.rows == 0 || mx2.cols == 0)
		return mx1;
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
	mat.rownames = mx1.rownames;
	mat.rownames.insert(mat.rownames.end(), mx2.rownames.begin(), mx2.rownames.end());
	return mat;
}

int_mat colcat(int_mat mx1, int_mat mx2) {
	if (mx1.rows == 0 || mx1.cols == 0)
		return mx2;
	if (mx2.rows == 0 || mx2.cols == 0)
		return mx1;
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
	if (mx1.rows == 0 || mx1.cols == 0)
		return mx2;
	if (mx2.rows == 0 || mx2.cols == 0)
		return mx1;
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

int_mat colcat(int_mat mx1, double_mat mx2) {
	return colcat(mx1, (int_mat) mx2);
}

double_mat colcat(double_mat mx1, int_mat mx2) {
	return colcat(mx1, (double_mat) mx2);
}

string_mat colcat(string_mat mx1, string_mat mx2) {
	if (mx1.rows == 0 || mx1.cols == 0)
		return mx2;
	if (mx2.rows == 0 || mx2.cols == 0)
		return mx1;
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

/* row and column names */
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
		throw std::invalid_argument("rowname: name matrix does not have matching entries");
	if (n.rows > 1)
		throw std::invalid_argument("rowname: name matrix should have only one row");
	mx.colnames = n.m;
}

void colname(double_mat &mx, string_mat n) {
	if (mx.cols != n.cols)
		throw std::invalid_argument("rowname: name matrix does not have matching entries");
	if (n.rows > 1)
		throw std::invalid_argument("rowname: name matrix should have only one row");
	mx.colnames = n.m;
}
	
void colname(string_mat &mx, string_mat n) {
	if (mx.cols != n.cols)
		throw std::invalid_argument("rowname: name matrix does not have matching entries");
	if (n.rows > 1)
		throw std::invalid_argument("rowname: name matrix should have only one row");
	mx.colnames = n.m;
}

/* string operations */
int strlen(string x) {
	return x.length();
}

string slice(string x, int l, int r) {
	if (r <= l || l <= 0 || r <= 0 || l > (int) x.length() || r > (int) x.length() + 1)
		throw std::invalid_argument("slice: invalid range");
	return x.substr(l + 1, r + 1);
}

/* get or set row/col */
int_mat getrow(int_mat mat, int r) {
	if (r > mat.rows || r < 1)
		throw std::invalid_argument("getrow: argument not in row range");
	int *array = new int[mat.cols];
	for (int i = 0; i < mat.cols; i++)
		array[i] = mat.m[(r - 1) * mat.cols + i];
	int_mat new_mat = int_mat(array, 1, mat.cols);
	new_mat.rownames[0] = mat.rownames[r - 1];
	new_mat.colnames = mat.colnames;
	delete[] array;
	return new_mat;
}

double_mat getrow(double_mat mat, int r) {
	if (r > mat.rows || r < 1)
		throw std::invalid_argument("getrow: argument row not in row range");
	double *array = new double[mat.cols];
	for (int i = 0; i < mat.cols; i++)
		array[i] = mat.m[(r - 1) * mat.cols + i];
	double_mat new_mat = double_mat(array, 1, mat.cols);
	new_mat.rownames[0] = mat.rownames[r - 1];
	new_mat.colnames = mat.colnames;
	delete[] array;
	return new_mat;
}

string_mat getrow(string_mat mat, int r) {
	if (r > mat.rows || r < 1)
		throw std::invalid_argument("getrow: argument row not in row range");
	string *array = new string[mat.cols];
	for (int i = 0; i < mat.cols; i++)
		array[i] = mat.m[(r - 1) * mat.cols + i];
	string_mat new_mat = string_mat(array, 1, mat.cols);
	new_mat.rownames[0] = mat.rownames[r - 1];
	new_mat.colnames = mat.colnames;
	delete[] array;
	return new_mat;
}

void setrow(int_mat &mat, int r, int_mat set) {
	if (r > mat.rows || r < 1)
		throw std::invalid_argument("setrow: argument row not in row range");	
	if (mat.cols != set.cols)
		throw std::invalid_argument("setrow: matrix to be set does not have matching column number");
	if (set.rows > 1)
		throw std::invalid_argument("setrow: input matrix has more than one row");
	for (int i = 0; i < mat.cols; i++)
		mat.m[(r - 1) * mat.cols + i] = set.m[i];
	mat.rownames[r - 1] = set.rownames[0];
}

void setrow(double_mat &mat, int r, double_mat set) {
	if (r > mat.rows || r < 1)
		throw std::invalid_argument("setrow: argument row not in row range");	
	if (mat.cols != set.cols)
		throw std::invalid_argument("setrow: matrix to be set does not have matching column number");
	if (set.rows > 1)
		throw std::invalid_argument("setrow: input matrix has more than one row");
	for (int i = 0; i < mat.cols; i++)
		mat.m[(r - 1) * mat.cols + i] = set.m[i];
	mat.rownames[r - 1] = set.rownames[0];
}

void setrow(string_mat &mat, int r, string_mat set) {
	if (r > mat.rows || r < 1)
		throw std::invalid_argument("setrow: argument row not in row range");	
	if (mat.cols != set.cols)
		throw std::invalid_argument("setrow: matrix to be set does not have matching column number");
	if (set.rows > 1)
		throw std::invalid_argument("setrow: input matrix has more than one row");
	for (int i = 0; i < mat.cols; i++)
		mat.m[(r - 1) * mat.cols + i] = set.m[i];
	mat.rownames[r - 1] = set.rownames[0];
}

void setrow(int_mat &mat, int r, double_mat set) {
	setrow(mat, r, (int_mat) set);
}

void setrow(double_mat &mat, int r, int_mat set) {
	setrow(mat, r, (double_mat) set);
}

int_mat getcol(int_mat mat, int c) {
	if (c > mat.cols || c < 1)
		throw std::invalid_argument("getcol: argument not in col range");
	int *array = new int[mat.rows];
	for (int i = 0; i < mat.rows; i++)
		array[i] = mat.m[i * mat.cols + (c - 1)];
	int_mat new_mat = int_mat(array, mat.rows, 1);
	new_mat.colnames[0] = mat.colnames[c - 1];
	new_mat.rownames = mat.rownames;
	delete[] array;
	return new_mat;
}

double_mat getcol(double_mat mat, int c) {
	if (c > mat.cols || c < 1)
		throw std::invalid_argument("getcol: argument not in col range");
	double *array = new double[mat.rows];
	for (int i = 0; i < mat.rows; i++)
		array[i] = mat.m[i * mat.cols + (c - 1)];
	double_mat new_mat = double_mat(array, mat.rows, 1);
	new_mat.colnames[0] = mat.colnames[c - 1];
	new_mat.rownames = mat.rownames;
	delete[] array;
	return new_mat;
}

string_mat getcol(string_mat mat, int c) {
	if (c > mat.cols || c < 1)
		throw std::invalid_argument("getcol: argument not in col range");
	string *array = new string[mat.rows];
	for (int i = 0; i < mat.rows; i++)
		array[i] = mat.m[i * mat.cols + (c - 1)];
	string_mat new_mat = string_mat(array, mat.rows, 1);
	new_mat.colnames[0] = mat.colnames[c - 1];
	new_mat.rownames = mat.rownames;
	delete[] array;
	return new_mat;
}

void setcol(int_mat &mat, int c, int_mat set) {
	if (c > mat.cols || c < 1)
		throw std::invalid_argument("setcol: argument row not in column range");	
	if (mat.rows != set.rows)
		throw std::invalid_argument("setcol: matrix to be set does not have matching row number");
	if (set.cols > 1)
		throw std::invalid_argument("setcol: input matrix has more than one column");
	for (int i = 0; i < mat.rows; i++)
		mat.m[i * mat.cols + (c - 1)] = set.m[i];
	mat.colnames[c - 1] = set.colnames[0];
}

void setcol(double_mat &mat, int c, double_mat set) {
	if (c > mat.cols || c < 1)
		throw std::invalid_argument("setcol: argument row not in column range");	
	if (mat.rows != set.rows)
		throw std::invalid_argument("setcol: matrix to be set does not have matching row number");
	if (set.cols > 1)
		throw std::invalid_argument("setcol: input matrix has more than one column");
	for (int i = 0; i < mat.rows; i++)
		mat.m[i * mat.cols + (c - 1)] = set.m[i];
	mat.colnames[c - 1] = set.colnames[0];
}

void setcol(string_mat &mat, int c, string_mat set) {
	if (c > mat.cols || c < 1)
		throw std::invalid_argument("setcol: argument row not in column range");	
	if (mat.rows != set.rows)
		throw std::invalid_argument("setcol: matrix to be set does not have matching row number");
	if (set.cols > 1)
		throw std::invalid_argument("setcol: input matrix has more than one column");
	for (int i = 0; i < mat.rows; i++)
		mat.m[i * mat.cols + (c - 1)] = set.m[i];
	mat.colnames[c - 1] = set.colnames[0];
}

void setcol(int_mat &mat, int c, double_mat set) {
	setcol(mat, c, (int_mat) set);
}

void setcol(double_mat &mat, int c, int_mat set) {
	setcol(mat, c, (double_mat) set);
}

/* init matrixes */
int_mat init_mat(int r, int c, int init) {
	if (r < 0 || c < 0)
		throw std::invalid_argument("init_mat: invalid row and column");
	int *array = new int[r * c];
	for (int i = 0; i < r * c; i++)
		array[i] = init;
	int_mat mat = int_mat(array, r, c);
	delete[] array;
	return mat;
}

double_mat init_mat(int r, int c, double init) {
	if (r < 0 || c < 0)
		throw std::invalid_argument("init_mat: invalid row and column");
	double *array = new double[r * c];
	for (int i = 0; i < r * c; i++)
		array[i] = init;
	double_mat mat = double_mat(array, r, c);
	delete[] array;
	return mat;
}

string_mat init_mat(int r, int c, string init) {
	if (r < 0 || c < 0)
		throw std::invalid_argument("init_mat: invalid row and column");
	string *array = new string[r * c];
	for (int i = 0; i < r * c; i++)
		array[i] = init;
	string_mat mat = string_mat(array, r, c);
	delete[] array;
	return mat;
}
