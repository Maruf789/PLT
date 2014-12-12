#ifndef _BUCKCAL_HPP_
#define _BUCKCAL_HPP_
#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <stdexcept>
#include <sstream>

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

/* for cout */
std::ostream & operator << (std::ostream &sys, const int_mat &in);
std::ostream & operator << (std::ostream &sys, const double_mat &in);
std::ostream & operator << (std::ostream &sys, const string_mat &in);

/* library calls */
int_mat range(int x, int y) ;
int_mat ranger(int x, int y) ;
int rows(int_mat mx) ;
int rows(double_mat mx) ;
int rows(string_mat mx) ;
int cols(int_mat mx) ;
int cols(double_mat mx) ;
int cols(string_mat mx) ;
int_mat rowcat(int_mat mx1, int_mat mx2) ;
double_mat rowcat(double_mat mx1, double_mat mx2) ;
string_mat rowcat(string_mat mx1, string_mat mx2) ;
int_mat colcat(int_mat mx1, int_mat mx2) ;
double_mat colcat(double_mat mx1, double_mat mx2) ;
string_mat colcat(string_mat mx1, string_mat mx2) ;
void colunit(double_mat mx, string_mat u) ;
void rowname(int_mat &mx, string_mat n) ;
void rowname(double_mat &mx, string_mat n) ;
void rowname(string_mat &mx, string_mat n) ;
void colname(int_mat &mx, string_mat n) ;
void colname(double_mat &mx, string_mat n) ;
void colname(string_mat &mx, string_mat n) ;
void init_mat_col(int_mat mx, string_mat nc) ;
void init_mat_col(double_mat mx, string_mat nc) ;
void init_mat_col(string_mat mx, string_mat nc) ;
void init_mat_size(int_mat mx, int nrow, int ncol) ;
void init_mat_size(double_mat mx, int nrow, int ncol) ;
void init_mat_size(string_mat mx, int nrow, int ncol) ;
int_mat addrows(int_mat mx, int_mat dr, string_mat drn) ;
double_mat addrows(double_mat mx, double_mat dr, string_mat drn) ;
string_mat addrows(string_mat mx, string_mat dr, string_mat drn) ;
std::string string_of_int(int x) ;
std::string string_of_double(double x) ;
int int_of_string(std::string x) ;
double double_of_string(std::string x) ;
int_mat mat_int_of_string(string_mat x) ;
double_mat mat_double_of_string(string_mat x) ;
int_mat mat_int_of_double(double_mat x) ;
double_mat mat_double_of_int(int_mat x) ;
string_mat mat_string_of_int(int_mat x) ;
string_mat mat_string_of_double(double_mat x) ;
int strlen(std::string x) ;
std::string slice(std::string x, int_mat idx) ;
double abs(double x) ;
double_mat sum_row(double_mat mx) ;
double_mat sum_col(double_mat mx) ;
double_mat avg_row(double_mat mx) ;
double_mat avg_col(double_mat mx) ;
double_mat var_row(double_mat mx) ;
double_mat var_col(double_mat mx) ;

#endif
