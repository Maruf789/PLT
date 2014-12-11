#include <vector>
#include <fstream>
#include <string>

class int_mat {
public:
	int rows;
	int cols;
	std::vector<int> m;
	/* constructors */
	int_mat(int *, int, int);
	int_mat(const int_mat &);
	/* overload = and << */
	int_mat & operator = (const int_mat &);
	int_mat operator + (const int_mat &);
	int_mat operator + (const int &);
};

class double_mat {
public:
	int rows;
	int cols;
	std::vector<double> m;
	/* constructors */
	double_mat(double *, int, int);
	double_mat(const double_mat &);
	/* overload = and << */
	double_mat & operator = (const double_mat &);
};

class string_mat {
public:
	int rows;
	int cols;
	std::vector<std::string> m;
	/* constructors */
	string_mat(std::string *, int, int);
	string_mat(const string_mat &);
	/* overload = and << */
	string_mat & operator = (const string_mat &);
};

std::ostream & operator << (std::ostream &sys, const int_mat &in);
std::ostream & operator << (std::ostream &sys, const double_mat &in);
std::ostream & operator << (std::ostream &sys, const string_mat &in);
