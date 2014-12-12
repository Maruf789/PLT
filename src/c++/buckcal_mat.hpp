#ifndef _BUCKCAL_HPP_
#define _BUCKCAL_HPP_
#include <iostream>
#include <vector>
#include <fstream>
#include <string>

class int_mat;
class double_mat;
class string_mat;

class double_mat {
public:
	int rows;
	int cols;
	std::vector<double> m;
	std::vector<std::string> rownames;
	std::vector<std::string> colnames;
	/* constructors */
	double_mat(double *, int, int);
	double_mat(const double_mat &);
	double_mat(const int_mat &);
	/* index */
	double & operator [] (int);
	/* overload = and << */
	double_mat & operator = (const double_mat &);
	double_mat & operator = (const int_mat &);
	double_mat operator + (const double_mat &);
	double_mat operator + (const double &);
	double_mat operator - (const double_mat &);
	double_mat operator - (const double &);
	double_mat operator * (const double_mat &);
	double_mat operator * (const double &);
	double_mat operator / (const double_mat &);
	double_mat operator / (const double &);
	double_mat operator + (const int_mat &);
	double_mat operator + (const int &);
	double_mat operator - (const int_mat &);
	double_mat operator - (const int &);
	double_mat operator * (const int_mat &);
	double_mat operator * (const int &);
	double_mat operator / (const int_mat &);
	double_mat operator / (const int &);
};

class int_mat {
public:
	int rows;
	int cols;
	std::vector<int> m;
	std::vector<std::string> rownames;
	std::vector<std::string> colnames;
	/* constructors */
	int_mat(int *, int, int);
	int_mat(const int_mat &);
	int_mat(const double_mat &);
	/* index */
	int & operator [] (int);
	/* overload = and << */
	int_mat & operator = (const int_mat &);
	int_mat & operator = (const double_mat &);
	int_mat operator + (const int_mat &);
	int_mat operator + (const int &);
	int_mat operator - (const int_mat &);
	int_mat operator - (const int &);
	int_mat operator * (const int_mat &);
	int_mat operator * (const int &);
	int_mat operator / (const int_mat &);
	int_mat operator / (const int &);
	double_mat operator + (const double_mat &);
	double_mat operator + (const double &);
	double_mat operator - (const double_mat &);
	double_mat operator - (const double &);
	double_mat operator * (const double_mat &);
	double_mat operator * (const double &);
	double_mat operator / (const double_mat &);
	double_mat operator / (const double &);
};

class string_mat {
public:
	int rows;
	int cols;
	std::vector<std::string> m;
	std::vector<std::string> rownames;
	std::vector<std::string> colnames;
	/* constructors */
	string_mat(std::string *, int, int);
	string_mat(const string_mat &);
	/* index */
	std::string & operator [] (int);
	/* overload = and << */
	string_mat & operator = (const string_mat &);
};

std::ostream & operator << (std::ostream &sys, const int_mat &in);
std::ostream & operator << (std::ostream &sys, const double_mat &in);
std::ostream & operator << (std::ostream &sys, const string_mat &in);
#endif
