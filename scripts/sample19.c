#include "buckcal_mat.hpp"
using namespace std;
void callreturn(int b) {
cout <<  b  << endl;
(  b  = (  b  + ( returnint( b ) ) ) ) ;
cout <<  b  << endl;
}
int main() {
int b =  4 ;
( callreturn( b ) ) ;
return  0  ;
}
