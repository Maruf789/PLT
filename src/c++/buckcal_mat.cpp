#include <iostream>
#include <stdexcept>
#include "buckcal_mat.hpp"

using namespace std;

int_mat::int_mat(int *array, int r, int c) {
	rows = r;
	cols = c;
	/* initialize vector of vectors */
	for (int i = 0; i < r * c; i++)
		m.push_back(array[i]);
}

int_mat::int_mat(const int_mat &in) {
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m = in.m;
}

int_mat::int_mat(const double_mat &in) {
	rows = in.rows;
	cols = in.cols;
	m.resize(rows*cols);
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
		m[i] = in.m[i];
}

int & int_mat::operator [] (int i) {
	return m.at(i);
}

int_mat & int_mat::operator = (const int_mat &in) {
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m = in.m;
	return *this;
}

int_mat & int_mat::operator = (const double_mat &in) {
	rows = in.rows;
	cols = in.cols;
	m.resize(rows*cols);
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
		m[i] = in.m[i];
	return *this;
}

int_mat int_mat::operator + (const int_mat &in) {
	int_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] += in.m[i];
	return result;
}

int_mat int_mat::operator + (const int &in) {
	int_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] += in;
	return result;
}

int_mat int_mat::operator - (const int_mat &in) {
	int_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] -= in.m[i];
	return result;
}

int_mat int_mat::operator - (const int &in) {
	int_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] -= in;
	return result;
}

int_mat int_mat::operator * (const int_mat &in) {
	int_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] *= in.m[i];
	return result;
}

int_mat int_mat::operator * (const int &in) {
	int_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] *= in;
	return result;
}

int_mat int_mat::operator / (const int_mat &in) {
	int_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] /= in.m[i];
	return result;
}

int_mat int_mat::operator / (const int &in) {
	int_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] /= in;
	return result;
}

double_mat int_mat::operator + (const double_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] = double(this->m[i]) + in.m[i];
	return result;
}

double_mat int_mat::operator + (const double &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] += in;
	return result;
}

double_mat int_mat::operator - (const double_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] -= in.m[i];
	return result;
}

double_mat int_mat::operator - (const double &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] -= in;
	return result;
}

double_mat int_mat::operator * (const double_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] *= in.m[i];
	return result;
}

double_mat int_mat::operator * (const double &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] *= in;
	return result;
}

double_mat int_mat::operator / (const double_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] /= in.m[i];
	return result;
}

double_mat int_mat::operator / (const double &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] /= in;
	return result;
}

ostream & operator << (ostream &sys, const int_mat &in) {
	for (int i = 0; i < in.rows; i++) {
		sys << "[";
		for (int j = 0; j < in.cols; j++) {
			sys << in.m[i * in.cols + j];
			if (j < in.cols - 1)
				sys << ", ";
		}
		sys << "]" <<endl;
	}
	return sys;
}

double_mat::double_mat(double *array, int r, int c) {
	rows = r;
	cols = c;
	/* initialize vector of vectors */
	for (int i = 0; i < r * c; i++)
		m.push_back(array[i]);
}

double_mat::double_mat(const double_mat &in) {
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m = in.m;
}
double_mat::double_mat(const int_mat &in) {
	rows = in.rows;
	cols = in.cols;
	m.resize(rows*cols);
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
		m[i] = in.m[i];
}
double & double_mat::operator [] (int i) {
	return m.at(i);
}
double_mat & double_mat::operator = (const double_mat &in) {
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m = in.m;
	return *this;
}
double_mat & double_mat::operator = (const int_mat &in) {
	rows = in.rows;
	cols = in.cols;
	m.resize(rows*cols);
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
		m[i] = in.m[i];
	return *this;
}
double_mat double_mat::operator + (const double_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] += in.m[i];
	return result;
}

double_mat double_mat::operator + (const double &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] += in;
	return result;
}

double_mat double_mat::operator - (const double_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] -= in.m[i];
	return result;
}

double_mat double_mat::operator - (const double &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] -= in;
	return result;
}

double_mat double_mat::operator * (const double_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] *= in.m[i];
	return result;
}

double_mat double_mat::operator * (const double &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] *= in;
	return result;
}

double_mat double_mat::operator / (const double_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] /= in.m[i];
	return result;
}

double_mat double_mat::operator / (const double &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] /= in;
	return result;
}

double_mat double_mat::operator + (const int_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] += in.m[i];
	return result;
}

double_mat double_mat::operator + (const int &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] += in;
	return result;
}

double_mat double_mat::operator - (const int_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] -= in.m[i];
	return result;
}

double_mat double_mat::operator - (const int &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] -= in;
	return result;
}

double_mat double_mat::operator * (const int_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] *= in.m[i];
	return result;
}

double_mat double_mat::operator * (const int &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] *= in;
	return result;
}

double_mat double_mat::operator / (const int_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("Matrixes do not match");
	for (int i = 0; i < rows*cols; i++)
		result.m[i] /= in.m[i];
	return result;
}

double_mat double_mat::operator / (const int &in) {
	double_mat result = *this;

	for (int i = 0; i < rows*cols; i++)
		result.m[i] /= in;
	return result;
}

ostream & operator << (ostream &sys, const double_mat &in) {
	for (int i = 0; i < in.rows; i++) {
		sys << "[";
		for (int j = 0; j < in.cols; j++) {
			sys << in.m[i * in.cols + j];
			if (j < in.cols - 1)
				sys << ", ";
		}
		sys << "]" <<endl;
	}
	return sys;
}

string_mat::string_mat(string *array, int r, int c) {
	rows = r;
	cols = c;
	/* initialize vector of vectors */
	for (int i = 0; i < r * c; i++)
		m.push_back(array[i]);
}

string_mat::string_mat(const string_mat &in) {
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
			m.push_back(in.m[i]);
}
string & string_mat::operator [] (int i) {
	return m.at(i);
}
string_mat & string_mat::operator = (const string_mat &in) {
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
			m.push_back(in.m[i]);
	return *this;
}

ostream & operator << (ostream &sys, const string_mat &in) {
	for (int i = 0; i < in.rows; i++) {
		sys << "[";
		for (int j = 0; j < in.cols; j++) {
			sys << in.m[i * in.cols + j];
			if (j < in.cols - 1)
				sys << ", ";
		}
		sys << "]" <<endl;
	}
	return sys;
}
