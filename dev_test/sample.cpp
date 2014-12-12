#include "buckcal_mat.hpp"
using namespace std;
int main() {
int T_0_0[] = { 1  ,  2  ,  3 };
int_mat TT_0_0 = ( int_mat( T_0_0  ,  1  ,  3 ) );
int T_1_0[] = { 1  ,  2  ,  3  ,  4 };
int_mat TT_1_0 = ( int_mat( T_1_0  ,  1  ,  4 ) );
int T_2_0[] = { 1  ,  2  ,  3  ,  4 };
int_mat TT_2_0 = ( int_mat( T_2_0  ,  2  ,  2 ) );
int T_3_0[] = { 1  ,  2 };
int_mat TT_3_0 = ( int_mat( T_3_0  ,  1  ,  2 ) );
if (( ( cols( TT_0_0 ) ) ==  2  )) {
int T_1_0[] = { 1  ,  2  ,  3 };
int_mat TT_1_0 = ( int_mat( T_1_0  ,  1  ,  3 ) );
cout << ( cols( TT_1_0 ) ) << endl;
int T_3_0[] = { 1  ,  2  ,  3 };
int_mat TT_3_0 = ( int_mat( T_3_0  ,  1  ,  3 ) );
( cols( TT_3_0 ) ) ;
} else if (( ( cols( TT_1_0 ) ) ==  3  )) {
cout <<  string("cols=3")  << endl;
int T_4_0[] = { 1  ,  2  ,  3 };
int_mat TT_4_0 = ( int_mat( T_4_0  ,  1  ,  3 ) );
( cols( TT_4_0 ) ) ;
int T_5_0[] = { 1  ,  2  ,  3 };
int_mat TT_5_0 = ( int_mat( T_5_0  ,  1  ,  3 ) );
( cols( TT_5_0 ) ) ;
int T_6_0[] = { 1  ,  2  ,  3 };
int_mat TT_6_0 = ( int_mat( T_6_0  ,  1  ,  3 ) );
( cols( TT_6_0 ) ) ;
} else if (( ( rows( TT_2_0 ) ) ==  1  )) {
cout <<  string("rows=1")  << endl;
int T_5_0[] = { 1  ,  2  ,  3 };
int_mat TT_5_0 = ( int_mat( T_5_0  ,  1  ,  3 ) );
( cols( TT_5_0 ) ) ;
int T_6_0[] = { 1  ,  2  ,  3 };
int_mat TT_6_0 = ( int_mat( T_6_0  ,  1  ,  3 ) );
( cols( TT_6_0 ) ) ;
} else if (( ( rows( TT_3_0 ) ) ==  2  )) {
cout <<  string("rows=2")  << endl;
int T_6_0[] = { 1  ,  2  ,  3 };
int_mat TT_6_0 = ( int_mat( T_6_0  ,  1  ,  3 ) );
( cols( TT_6_0 ) ) ;
int T_7_0[] = { 1  ,  2  ,  3 };
int_mat TT_7_0 = ( int_mat( T_7_0  ,  1  ,  3 ) );
( cols( TT_7_0 ) ) ;
} else {
cout <<  string("end")  << endl;
int T_4_0[] = { 1  ,  2  ,  3 };
int_mat TT_4_0 = ( int_mat( T_4_0  ,  1  ,  3 ) );
( cols( TT_4_0 ) ) ;
}
return  0  ;
}
