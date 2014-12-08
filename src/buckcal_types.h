// buckcal_types.h
#ifndef BUCKCAL_TYPES_H
#define BUCKCAL_TYPES_H

#include <iostream>
#include <string>
#include <vector>

using namespace std;

// typedefs
typedef vector<int> _int_mat;
typedef vector<double> _double_mat;
typedef vector<string> _string_mat;

struct int_mat {
  int c; // number of columns
  int r; // number of rows
  _int_mat m; // int vector
  int_mat(double *a, int r, int c);
};

struct double_mat {
  int c; // number of columns
  int r; // number of rows
  _int_mat m; // int vector
  double_mat(double *a, int r, int c);
};

struct string_mat {
  int c; // number of columns
  int r; // number of rows
  _string_mat m; // int vector
  string_mat(string *a, int r, int c);
};

/*
 * Support of sub may be not easy. 
struct sub_int_mat {
  int c; // number of columns
  int r; // number of rows
  _int_mat m; // int vector
};

struct sub_double_mat {
  int c; // number of columns
  int r; // number of rows
  _int_mat m; // int vector
};

struct sub_string_mat {
  int c; // number of columns
  int r; // number of rows
  _int_mat m; // int vector
};
*/
// mat helper functions


#endif
