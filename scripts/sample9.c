#include "buckcal_mat.hpp"
using namespace std;
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
void rowname(int_mat mx, string_mat n) ;
void rowname(double_mat mx, string_mat n) ;
void rowname(string_mat mx, string_mat n) ;
void colname(int_mat mx, string_mat n) ;
void colname(double_mat mx, string_mat n) ;
void colname(string_mat mx, string_mat n) ;
void init_mat_col(int_mat mx, string_mat nc) ;
void init_mat_col(double_mat mx, string_mat nc) ;
void init_mat_col(string_mat mx, string_mat nc) ;
void init_mat_size(int_mat mx, int nrow, int ncol) ;
void init_mat_size(double_mat mx, int nrow, int ncol) ;
void init_mat_size(string_mat mx, int nrow, int ncol) ;
int_mat addrows(int_mat mx, int_mat dr, string_mat drn) ;
double_mat addrows(double_mat mx, double_mat dr, string_mat drn) ;
string_mat addrows(string_mat mx, string_mat dr, string_mat drn) ;
string string_of_int(int x) ;
string string_of_double(double x) ;
int int_of_string(string x) ;
double double_of_string(string x) ;
int_mat mat_int_of_string(string_mat x) ;
double_mat mat_double_of_string(string_mat x) ;
int_mat mat_int_of_double(double_mat x) ;
double_mat mat_double_of_int(int_mat x) ;
string_mat mat_string_of_int(int_mat x) ;
string_mat mat_string_of_double(double_mat x) ;
string slice(string x, int_mat idx) ;
double abs(double x) ;
double_mat sum_row(double_mat mx) ;
double_mat sum_col(double_mat mx) ;
double_mat avg_row(double_mat mx) ;
double_mat avg_col(double_mat mx) ;
double_mat var_row(double_mat mx) ;
double_mat var_col(double_mat mx) ;
int main() {
int b =  0 ;
int a =  2 ;
if ((  b  <=  0  )) {
cout <<  0  << endl;
} else {
cout <<  b  << endl;
}
if ((  a  >  0  )) {
cout <<  a  << endl;
} else {
}
if ((  a  <  0  )) {
} else {
cout <<  0  << endl;
}
return  0  ;
}
