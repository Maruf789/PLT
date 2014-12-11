#include <iostream>
#include "buckcal_mat.hpp"

using namespace std;

int main(void) {
	int T_int_array_0[] = {1, 2, 3, 4, 5, 6};
	double T_double_array_0[] = {1.1, 2.2, 3.3, 4.4, 5.5, 6.6};
	int_mat xx = int_mat(T_int_array_0, 2, 3);
	double_mat yy = double_mat(T_double_array_0, 2, 3);
	double_mat zz = yy / xx;
	double_mat zz2 = xx / yy;
	int x = 5;
	cout << xx << endl;
	cout << yy << endl;
	cout << zz << endl;
	cout << zz2 << endl;
	zz = xx - 10;
	cout << zz << endl;
	int T_int_array_1[] = {1, 2, x};
	cout << int_mat(T_int_array_1, 1, 3) << endl;
	return 0;
}
