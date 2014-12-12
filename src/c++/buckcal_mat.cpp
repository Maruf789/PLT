#include "buckcal_mat.hpp"

using namespace std;

void init_names(vector<string> &rownames, vector<string> &colnames, int r, int c) {
	for (int i = 0; i < r; i++) {
		ostringstream ss;
		ss << "row" << (i + 1);
		rownames.push_back(ss.str());
	}
	for (int i = 0; i < c; i++) {
		ostringstream ss;
		ss << "col" << (i + 1);
		colnames.push_back(ss.str());
	}
}

int_mat::int_mat(int *array, int r, int c) {
	rows = r;
	cols = c;
	/* initialize vector of vectors */
	for (int i = 0; i < r * c; i++)
		m.push_back(array[i]);
	init_names(rownames, colnames, rows, cols);
}

int_mat::int_mat(const int_mat &in) {
	if (this == &in)
		return;
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m = in.m;
	rownames = in.rownames;
	colnames = in.colnames;
}

int_mat::int_mat(const double_mat &in) {
	rows = in.rows;
	cols = in.cols;
	m.resize(rows*cols);
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
		m[i] = in.m[i];
	rownames = in.rownames;
	colnames = in.colnames;	
}

int & int_mat::operator [] (int i) {
	return m.at(i);
}

int_mat & int_mat::operator = (const int_mat &in) {
	if (this == &in)
		return *this;
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m = in.m;
	rownames = in.rownames;
	colnames = in.colnames;
	return *this;
}

int_mat & int_mat::operator = (const double_mat &in) {
	rows = in.rows;
	cols = in.cols;
	m.resize(rows*cols);
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
		m[i] = in.m[i];
	rownames = in.rownames;
	colnames = in.colnames;
	return *this;
}

int_mat int_mat::operator + (const int_mat &in) {
	int_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("operator '+': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '-': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '*': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '/': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '+': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '-': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '*': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '/': matrixes dimensions do not match");
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
	sys << "\t\t";
	for (int i = 0; i < in.cols; i++) {
		sys << in.colnames[i] << "\t";
	}
	sys << endl;
	for (int i = 0; i < in.rows; i++) {
		sys << in.rownames[i] << "\t[";
		for (int j = 0; j < in.cols; j++) {
			sys << in.m[i * in.cols + j];
			if (j < in.cols - 1)
				sys << ",\t";
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
	init_names(rownames, colnames, rows, cols);
}

double_mat::double_mat(const double_mat &in) {
	if (this == &in)
		return;
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m = in.m;
	rownames = in.rownames;
	colnames = in.colnames;
}
double_mat::double_mat(const int_mat &in) {
	rows = in.rows;
	cols = in.cols; 
	m.resize(rows*cols);
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
		m[i] = in.m[i];
	rownames = in.rownames;
	colnames = in.colnames;
}
double & double_mat::operator [] (int i) {
	return m.at(i);
}
double_mat & double_mat::operator = (const double_mat &in) {
	if (this == &in)
		return *this;
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m = in.m;
	rownames = in.rownames;
	colnames = in.colnames;
	return *this;
}
double_mat & double_mat::operator = (const int_mat &in) {
	rows = in.rows;
	cols = in.cols;
	m.resize(rows*cols);
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
		m[i] = in.m[i];
	rownames = in.rownames;
	colnames = in.colnames;
	return *this;
}
double_mat double_mat::operator + (const double_mat &in) {
	double_mat result = *this;

	if (rows != in.rows || cols != in.cols)
		throw std::invalid_argument("operator '+': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '-': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '*': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '/': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '+': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '-': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '*': matrixes dimensions do not match");
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
		throw std::invalid_argument("operator '/': matrixes dimensions do not match");
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
	sys << "\t\t";
	for (int i = 0; i < in.cols; i++) {
		sys << in.colnames[i] << "\t";
	}
	sys << endl;
	for (int i = 0; i < in.rows; i++) {
		sys << in.rownames[i] << "\t[";
		for (int j = 0; j < in.cols; j++) {
			sys << in.m[i * in.cols + j];
			if (j < in.cols - 1)
				sys << ",\t";
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
	init_names(rownames, colnames, rows, cols);
}

string_mat::string_mat(const string_mat &in) {
	if (this == &in)
		return;
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m = in.m;
	rownames = in.rownames;
	colnames = in.colnames;
}
string & string_mat::operator [] (int i) {
	return m.at(i);
}
string_mat & string_mat::operator = (const string_mat &in) {
	if (this == &in)
		return *this;
	rows = in.rows;
	cols = in.cols;
	/* copy array */
	m.resize(rows*cols);
	/* copy array */
	for (int i = 0; i < rows * cols; i++)
		m[i] = in.m[i];
	rownames = in.rownames;
	colnames = in.colnames;
	return *this;
}

ostream & operator << (ostream &sys, const string_mat &in) {
	sys << "\t\t";
	for (int i = 0; i < in.cols; i++) {
		sys << in.colnames[i] << "\t";
	}
	sys << endl;
	for (int i = 0; i < in.rows; i++) {
		sys << in.rownames[i] << "\t[";
		for (int j = 0; j < in.cols; j++) {
			sys << in.m[i * in.cols + j];
			if (j < in.cols - 1)
				sys << ",\t";
		}
		sys << "]" <<endl;
	}
	return sys;
}
