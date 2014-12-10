#include <iostream>
#include "buckcal_mat.hpp"

using namespace std;

int main(void) {
	int T_int_array_0[] = {1, 2, 3, 4, 5, 6};
	int_mat xx = int_mat(T_int_array_0, 2, 3);
	int x = 5;
	cout << xx << endl;
	int T_int_array_1[] = {1, 2, x};
	cout << int_mat(T_int_array_1, 1, 3) << endl;
	return 0;
}
