Language Reference Manual of BuckCal
Table of Contents:
Preface
Lexical Component 
Keyword
Identifier 
Literal
Data Unit
Seperator
Operator
Newlines, Whitespaces and Tabs
Data Type
Primitive Data Type
Matrix
Void Data Type
Expression
Variable Declaration 
Variable Scope
Variable Assignment
Variable Comparation
Arithmetic Operation
String Operation
Operator Precedence
Statement
Conditional Statement
Loop Statement
Break and Continue Statement
disp Statement
Function
Function Declarations
Function Definitions
Calling Functions
Matrix
Sample Program
Hello world style
Matrix operation


Table of Contents
Preface
Lexical Component
Keyword
Identifier
Literal
Data Unit
Seperator
Operator
Newlines, Whitespaces and Tabs
Data Type
Primitive Data Type
Matrix
Void Data Type
Expression
Variable Declaration
Variable Scope
Variable Assignment
Variable Comparation
Arithmetic Operation
String Operation
Operator Precedence
Statement
Conditional Statement
Loop Statement
Break and Continue Statement
disp Statement
Function
Function Declarations
Function Definition
Calling Function
Built-in functions
Matrix Operation
Matrix definition
Matrix accessing (non-unit case)
Unit Assignment
Operations with unit.
Sample Program
Hello-world style
Matrix operation
Appendix A. BuckCak Library Function List


Preface
This reference manual describles BuckCal, a matrix manipulation language for calculating expenses.
BuckCal has full support for mathematical matrix operations and is optimized for spreadsheet calculations. With enhanced matrix operations and data type support, programmer can make budget, record expenses, and add numbers with different units without worrying about unit conversion.
BuckCal Programs are translated into R scripts.



Lexical Component
Keyword
Keywords are reserved for language processing, and they cannot be used for identifier or other purposes.
All keywords:
if then else elif fi for in do rof
break continue not and or def fed return
int double bool string mat void
Identifier
An identifier is used to name a variable or function, it could be any combination of lower case letters (a to z), number (0-9) or underscore(_), except that the first letter must be a lower case character (a to z). An identifier cannot be an exact match with one of the reserved keywords.

Examples of valid identifiers:
i
matrix01
	food_day2
col_name
Examples of invalid identifiers:
Var		(upper case letter)
0number	(number as the first letter)
an int	(with space)
*str		(invalid character)
Literal
A literal is used to express a constant value. It can be a numeric value (integer or floating point), a string (including one-character string), a numeric value with supported unit, or a matrix.

Examples:
	12			(integer)
	1.2			(floating point - double)
	true			(boolean)
	‘hello’		(string, single character is also a string)
	1.5mile		(a numeric value with unit)
	{1, 2; 3, 4}	(a matrix)
 
Note that a string must be quoted by single quote, double quote is not accepted. And a literal of numeric value with unit can only be used in matrix.
Data Unit
In a matrix in BuckCal, each column can specify a single data unit, it could be any one of the following basic categories:
(mass and weight) lb, oz, kg, g
(distance) ft, m, km, mile
(area) ft2, m2, km2, mile2
(capacity and volume) ml, l, quart, gallon
The point of only including a small number of built-in units is to provide convenient access to everyday data, as it is the main usage of BuckCal. Currency, as a special case, is supposed to be without a unit in BuckCal, simply because it adds up significant overhead to support all the currencies.
Supported data units can be converted to one another, as long as the original and new units are in the same categoty and both are defined (compatible). Programmer can also mix up different compatible units when doing calculations, which will be automatically converted in the background if they are compatible. Otherwise, a compiler error will be raised. More detail about operation with unit is in section 7.
Seperator
There are several letters served as seperators:
semicolon - ‘;’: seperates each statement, and also each row in a matrix definition.
comma - ‘,’: seperates arguments in a function argument list, also seperates two same-row data members in a matrix definition.
curly bracket - ‘{}’: seperates matrix content with other lexical components, i.e., left curly bracket marks the start of a matrix content, while the right square bracket marks the end.
parenthesis - ‘()’: used to modify operator precedence, and to wrap the argument list of a funtion.

Example 1:
mat A : {1, 2; 3, 4};
This is a 2 x 2 matrix definition. Inside the brackets is the content in the matrix row, where a comma seperates two number in a same row, and a semicolon seperates two rows. Finally, a semicolon marks the end of this statement.

Example 2:
	i: (2 + 3) * 4;
This is an integer assignment with a pair of parenthesis to modify operator precedence. In this case, i will be 20 (addition followed by multiplication), instead of 14 when there is no parenthesis (multiplication followed by addition).
Operator
There are six(6) operators in symbol form in BuckCal:
plus - ‘+’
mathematical addition for numeric values, concatenation for strings, one-on-one addition for numeric elements in matrix
minus - ‘-’
mathematical substraction for numeric values, one-on-one substraction for numeric elements in matrix
multiply - ‘*’
mathemtical multiply for numeric values, one-on-one multiplication for numeric elements in matrix
divide - ‘/’
mathematical division for numeric values, one-on-one division for numeric elements in matrix
equal mark - ‘=’
used only for content comparison, output a boolean value, usually used with if statement (e.g. i = 2)
colon - ‘:’
used for variable assignment and initialization (e.g. int c: 3)
square bracket - ‘[]’
matrix subscripting. Input row and column number (which is counted from 1) seperated by comma (‘,’), and use 0 to represent all. (e.g. budget[0,1] select first column)

Specifically, below are the mathematic operators (+ - * /) and examples of their usage:


+
-
*
/
double op double
1.0+2.1=3.1
1.0-2.1=-1.1
1.0*2.1=2.1
2.1/1.0=2.1
int op int
1+2=3
1-2=-1
1*2=2
1/2=0
string op string
’s’+’u’=’su’
N/A
N/A
N/A
matrix op {int|double}
{1, 2; 3, 4}
+
1
=
{2, 3; 4, 5}
{1, 2; 3, 4}
-
1
=
{0, 1;
 2, 3}
{1, 2; 3, 4}
*
1.2
=
{1.2, 2.4;
 3.6, 4.8}
{1, 2; 3, 4}
/
2.0
=
{1.5, 1.0;
 1.5, 2.0}
matrix op matrix
{1, 2; 3, 4}
+
{1, 2; 3, 4}
=
{2, 4; 6, 8}
{1, 2; 3, 4}
-
{1, 2; 3, 4}
=
{0, 0; 0, 0}
{1, 2; 3, 4}
*
{1, 2; 3, 4}
=
{1, 4;
 9, 16}
{1, 2; 3, 4}
/
{1, 2; 3, 4}
=
{1, 1;
 1, 1}

	Additionally, there are three operators that are written as words, all of which are for logical operation:
not: e.g. not A, the expression is the negation of A.
and: e.g. A and B, the expression is true if both A and B are true.
or: e.g. A or B, the expression is true if either A, B, or both, are true.

Details on operators and operation can be found in section 4 (‘Expression’).

Newlines, Whitespaces and Tabs
In BuckCal, newlines, whitespaces and tabs are only used to split lexical components, especially identifiers and literals. There is no required alignment of spacing style.

However, for the consideration of readability, in addition to seperate all lexical components by whitespaces (as it is normally done), it is recommended as a good practice to only write one statement per line, and use tabs properly in a control structure or in a function to indent and align the code. Examples and more about coding style are illustrated in Section 7 (‘Sample Programs’).


Data Type
In BuckCal, these are primitive data types: number (integer and floting point number), string, and boolean. Data with same primitive data type can be composed into a matrix. Besides, number in matrix can have unit.
 Primitive Data Type
int
	The 32-bit int data type can hold integer values in the range of -2,147,483,648 to 2,147,483,647
Here are some examples of declaring and initializing integer variables:
int foo;
int bar = 42;

The first line declares an integer named foo but does not define its value; it is left unintialized, and its value should not be assumed to be anything in particular. And the second line declares and defines a value

double
	The real number type double represents fractional numbers. Its minimum value is 2.2250738585072014e-308, and its maximum value is 1.7976931348623157e+308. The floating point data type is signed; trying to use unsigned float, for example, will cause a compile-time error. Here are some examples of declaring and initializing real number variables:
double foo;
double bar = 114.3943;
The first line declares a float named foo but does not define its value; it is left unintialized, and its value should not be assumed to be anything in particular.The real number type provided in BuckCal is of finite precision, and accordingly, not all real numbers can be represented exactly.

string
string represents characters and character strings. BuckCal does not support a built-in character type, therefore, a character, a literal, and a long series of characters are all referred to be a string. Strings are constant and immutable; their values cannot be changed after they are created. The string data type is inspired from the original Unicode specification, which defines characters (which is, in BuckCal, referred broadly as strings) as 16-bit or more entities. The range of legal code points is U+0000 to U+10FFFF, known as Unicode scalar value. (Refer to the definition of the U+n notation in the Unicode Standard. <http://www.unicode.org /reports/tr27/#notation> )
A string in BuckCal is represented in the UTF-16 format in which supplementary characters are represented by surrogate pairs. Buckcal uses the UTF-16 representation for all string characters, variables and literals. Strings whose code points are greater than U+FFFF are called supplementary characters. The set of characters from U+0000 to U+FFFF is sometimes referred to as the Basic Multilingual Plane (BMP). A string value (be it a one-letter string, literals, or a string variable with multiple letters or words), therefore, represents Basic Multilingual Plane (BMP) code points, including the surrogate code points, or code units of the UTF-16 encoding. However, there is no concept of “index values” in a string. In fact, a string is the source code representation of a fixed value, which is represented directly in BuckCal code without requiring computation or the access to its indices. The only operation that can be made on strings is concatenation.
 
boolean
The boolean data type has only two possible values: true and false. Use this data type for simple flags that track true/false conditions. This data type represents one bit of information, but its "size" isn't something that's precisely defined.
Matrix
A matrix (mat) is a data collection type, which can store data of the same primitive data type. That means a matrix can be a number-matrix, string-matrix, or bool-matrix. A matrix is composed of rows and columns. Rows and columns have names. By default, row names are “r1”, “r2”, … , and column names “c1”, “c2”, … . A number-matrix can have only one unit per column.
Void Data Type
Void data type (void) is only used in a function’s return value. A void return means that the function have no return value. An expression with void type cannot be accepted in BuckCal.

Expression
Variable Declaration
All variables must be declared with its data type before used. The initial value is optional; but if there is one, it must be an expression resulting in the same type with variable.
Grammer: 
datatype identifier [: inital value]
Samples are as follows:
int a : 1 + 2;
double d : 2.0;
string c : “This is a string”;
bool b;
If variables are declared without initial value, their default values are as follows.
int a; # a = 0
double d; # d = 0.0
string s; # s = “”
bool b; # b = false
To create a non-empty matrix, the {} operator is needed. Columns are separated with a comma, and rows are separated with a semicolon. All rows must have the same number of elements. Example:
mat m: {1, 2; 4, 5};
	Mtrix variable declared without initial value is empty:
		mat m; # m = {}
Variable Scope
There are two levels of scope: top and function. A “top variable” is a variable with top scope, “function variable” with function scope.
A variable defined within a function has a function scope. It can only be referenced with in the function where it is defined. Top variables are defined out of function. 
Scopes are isolated from each other: a variable defined in top variable cannot be refrenced with in a function. If a function variable has the same name as a top variable, it is treated as a diffrent variable and has no connect with the top one.
Variable Assignment
The assignment operator “:” stores the value of its right operand in the variable specified by its left operand. The left operand (commonly referred to as the “left value”) cannot be a literal or constant value.
The left and right operand should be of the same type. The only exceptions:
Integer and double can be assigned to each other. Only the integer part of a double will be assigned to an int.
Example: 
(double b : 1.2; int a;)
a : b; # a = 1
Double with unit can be assigned to double and integer. The unit part is ignored in assignment, so this case is equavilent to assign a double to a double/integer.
Variable Comparation
Comparation operators can be used to compare primitive variable pairs of the same type. The result of comparation is a boolean: true or false.
“=” test if the two variables equal. “!=” returns the opposite.
“<” test if the left operand is less than right operand. “>=” returns the opposite.
“>” test if the left operand is greater than right operand. “>=” returns the opposite.
String is compared by dictonary order. For boolean, true is greater than false.
Arithmetic Operation
For int and double, addition(+), subtraction(-), multiplication (*), and division(/) are supported, as well as negation(-). If int and double are mixed, int are converted to double first.
String Operation
concatenation: use operator “+” to join two strings and return a new string. Example: 
string a : “b”+”c”
we get a as “bc”
slicing: use function slice() to get a substring out of a string. Example:
	string a : “ABCDEFGH”
	slice(a, range(1, 4));
	we get “ABCD”
	slice(a, {1, 2, 4, 6});
	we get “ABDF”
Operator Precedence
	Rules of precedence ensure when dealing with multiple operators, codes can be concise and simple while not having ambiguity. A simple example of precedence is a: b + c * d. This expression means that the result of c multiplying with d is added to b, and then the addition result is assigned to a.
	In BuckCal, most operators are left-associated, some special cases would be stated later. The orders of highest precedence to lowest precedence follows as the list below. Sometimes, two or more operators have same predence.
parenthesis “()”
function calls, matrix subscripting
unary negative
multiplication, division expressions
addition and substraction expressions
greater-than, less-than, greater-than-or-equal-to, and less-than-or-equal-to expressions
Equal-to and not-equal-to expressions
logical NOT expressions
logical AND expressions
logical OR expressions
assignment expressions

Statement
Statements are implemented to cause actions and control flow within your programs.
Conditional Statement
The if-then-else-fi statement is used to conditionally execute part of the program, based on the truth value of a given expression. Here is the general form of an if-else-fi statement:

if expr then
statement1;
else 
statement2;
fi

If expr evaluates to true, then only statement1 is executed. However, if expr evaluates to false, then only statement2 is executed only. The else clause is optional.

Here is an actual example:
if b < 0 then
disp a;
else
	disp b;
fi
 	NOTE: function ‘disp’ prints on screen.

The if-then-elif-then-else-fi statement is used to cascade the conditional execution of the program. Here is the general form of an if-elif-else-fi statement:

if expr1 then
	statement1;
elif expr2 then
statement2;
elif expr3 then
statement3;
else
	statement4;
fi 
 
Just like in if-then-else-fi, the else clause is optional here. Here is an actual example:
	if b = 0 then
		disp “b is 0”;
	elif b = 1 then
		disp “b is 1”;
	fi
Loop Statement
The for statement is a loop statement used to iterate over a range of values. It is compact and easy to read. Here is the general form of the for statement:

for r in {1; 2; 3; 4; 5} do
	#do something
rof

In the above example, ‘r’ traverses through b.rows and performs the action written between for and rof on every row.

As a more useful example, the following code traverse the rows in a matrix, with the help of built-in function range() and rows():

# suppose mat b is defined before
int r;
for r in range(1, rows(b)):
#do something to b[r, 0]
rof
Break and Continue Statement 
5.3.1 Break Statement
The break statement can be used to terminate a for loop. Here is an example:
for r in (range 1 5) do # “range(1, 5)” returns {1; 2; 3; 4; 5}
if r > 4 then
     	break	;
else
#do something
fi
rof


The above example exits the for loop by executing the break statement when it finds r > 4.

	5.3.2 Continue statement
The continue statement can be used in loops to terminate an iteration of the loop and begin the next iteration. Here is an example:
for r in {1; 2; 3; 4; 5} do
if r < 2 then 
     	continue;
else
#do something
fi
rof


The above example exits the iteration when it finds r < 2 and jumps to the next iteration.
disp Statement
The keyword disp can print any variable(including literal) and expression with a return value other than void type. The format is:
disp expr
This will print the value of expression to stdout, in a pre-defined pretty look.


Function
The function is a fundamental modular in BuckCal. A function is usually designed to perform a specific task, and its name often reflects that task.
BuckCal provide some built-in functions (section 6.4). User can also define their own functions.
Function Declarations
	A function declaration is to specify a function's return value type, the name of function, and a list of types of arguments. Here is the general form:
	type : identifier(argument-list);
	Examples of function declaration:
	void : helper(int x);
	mat : range(int, int);
	int : cols(mat);
	The declaration begins with the return value type and a “:”. After that is the function name (“range”).  The list of argument is between a pair of parentheses. Note that the name of formal variables are optional. In fact, the names (if any) are ignored, and only types take effect. Finally it ends with a semicolon(“;”).
Function declaration can only be in the top level.
Function Definition
A function definition begins with a line similar to Declaration, which specifies the name of the function, the argument list, and its return type. The difference is argument list contains <type, identifer> pairs, where the name of formal variables are must.
It also includes a function body, beginning with “def” keyword and end with “fed” keyword. In the function body is the declarations of local variables, and a list of expressions and statements that determine what the function does. Note that all variable declarations must appear before any expressions and statements.
Here is the general form:
type : identifier(argument-list) def
	function-body
fed
A function definition cannot appears in another function’s definition. That means it only exists in top level code. Recursion is allowed - a function can call it self in definition.
Calling Function
	BuckCal built-in functions can be called anywhere, anytime in a program. User-defined function must be defined first with a Function Definition before ready for calling. Alternatively, user can write a Function Decalration before invoking, but the function has to be implemented somewhere else.
A typecall pattern for user-defined function is declared it in the source file where it is invoked, but defined somewhere else. Sepecially, BuckCal provide some library functions, user can just include the declarations and then use them.
Built-in functions
mat : range(int x, int y);
Return a vector {x; x+1; … ; y}. If  y < x, return {}
int : rows(mat M);
int : cols(mat M);
Return the number of rows/columns  in matrix M; 
mat : rowcat(mat M1, mat M2);
mat : colcat(mat M1, mat M2);
Return a new matrix looks like M1 added all rows from M2
Return a new matrix looks like M1 added all columns from M2
void : colunit(mat M, mat U);
Set the units of every column of M. U looks like {‘kg’, ‘m’, …}
void : owname(mat M, mat N);
void : colname(mat M, mat N);
Set names of rows/columns in a matrix. N looks like {‘a’, ‘b’, …}. 
The default value are ‘r1’, ‘r2’, … / ‘c1’, ‘c2’, ...


Matrix Operation
Because of the complexity of matrix operation, here is a chapter specially for matrix.
Matrix definition
Example code, define a matrix variable A and display it.
mat A : {1, 2, 3; 4, 5, 6; 7, 8, 9};
disp A;
We get a matrix A like this:
1  2  3
4  5  6
7  8  9
	Another useful function can return a column initialized matrix:
		mat A : init_mat_col({‘a’, ‘b’, ‘c’});
We get a 0*3 matrix A, whose column names are ‘a’ ‘b’ ‘c’. 
Matrix accessing (non-unit case)
	Operator [row, col] is for accessing a sub-matrix of a matrix. Note that counting and indexing begins with 1 in BuckCal. So 0 refers to all rows/ columns.
read element(s):
double a : A[1, 2];  # we get a = 2
disp A[1, 0]; # we get the 1st row of A.
disp A[0, range(1,2)]; # we get the first 2 columns of A.
write element(s):
A[1, 2] : 4.0; # set (1st row, 2nd column) of A to 4.0
A[1, 2] : {4.0}; # set (1st row, 2nd column) of A to 4.0
A[1, 0] : range(1, (cols A)); 
# set 1st row of A as 1, 2,...
	As a special case of matrix , vector can be accessed with operator [index], since vector is a one dimension structure. As in mat, index can be a int or vector.
Unit Assignment
By default, elements in matrix don’t have units. There a two appraoches to assign unit.
Explicitly: The colunit function can set the unit for every column in a matrix. For example:
colunit(M, {‘lb’, ‘ft’});.
set unit for all two columns of M. That implies cols(M) = 2; if not, a error generated.
colunit(M[0, 2], {‘ft’});
set the unit of 2nd column of M. Specificlly, the following case is equavalent to previous one.
colunit(M[1, 2], {‘ft’}); # The row index is ignored.
To unset the column unit:
	colunit(M[0, range(1, 2)], {‘’, ‘’});
Now the unit of 2nd column is gone! Note:There is no implicity way to remove units.
To reset the column unit to units in the same category, just use colunit. 0 numbers are converted to new unit.
colunit(M[0, 2], {‘m’});
To reset the column unit to units in the different category: No direct way !
Implicitly: The unit of a column is decided when first assigned with “double with unit”. Be advised, once the unit is set, the “category” of unit is also set. So if “double with unit” is assigned to other elements of the same column, the unit have to be in the same category . Example:
mat M : {1, 2; 3, 4; 1, 5} # now M have no units
####################################################
M[2, 1] : {1kg}; 
# the 1st column has unit ‘kg’, and category ‘weight’
####################################################
M[2, 1] : {2}; 
# the 1st column still has unit ‘kg’
####################################################
M[1, 1] : {1lb};
# In fact ‘lb’ is converted to ‘kg’.
# Now M{1, 1} = 0.45 , since 1lb = 0.45kg
####################################################
M[3, 1] : {1m};
# Assignment fail! ‘m’ belongs to ‘length’, not ‘weight’
####################################################
The column unit is a attribute of a matrix, as is name of column. And the unit can be printed when disp a matrix:
    	c1(kg)	c2
r1 	0.45 	 2
r2 	2 	 4
r3 	1 	 5
Operations with unit.
M : rowcat(M1, M2);
The units of corresponding columns in M1 and M2 should be of the same unit. Otherwise a runtime error is raised.
double a : M[1, 1] ; 	# a = 1
M1[1, 2] : a;		# M[1, 2] = 1
When a double with unit assigned to a double, the unit are dropped. 
M : rowcat(M1, M2);
The units of corresponding columns in M1 and M2 should be of the same unit. Otherwise a runtime error is raised.
binary operations:
M1[1, 0] + M2[1, 0]; M1[0, 1] - M2[0, 2];
M1[1, 0] * M2[2, 0]; M1[0, 1] - M2[0, 1];
The units/names are dropped in result.


Sample Program
Hello-world style
# function definition
void : hello() def
	disp “hello”;
fed
# top level code 
hello();
int a : 5;
int i : 0;
mat v ;
for i do
	if i <= 5 do
		v : colcat(v, {i});
		i : i + 1;
	else
		break;
	fi
orf
double b : 0.0;
for x in v do
	if x <= 2 then
		b : b + x*x;
	elif x <= 4 then
		b : b + x;
	else
		b : b + x/2.0;
	fi
orf
endstr : “End” ;
disp endstr ;
Matrix operation
# sum up rows! not using sum_row deliberately.
mat : sum_up_rows(mat M) def
	int x;
	mat s: range(1, cols(M)) * 0;
	for x in range(1, (rows M)) do
		s: s+ M[x, 0];
	orf
	return s;
fed
# initialize a mat
mat budget: init_mat_col({‘Food’, ‘Price’});
colunit(budget[0, 1], {‘lb’});
# add one row with naming
budget: addrows(budget, {1+1, 3.3}, {‘John’});
# add one column and naming
budget: colcat({0}, budget);
colname(budget[0, 1], {‘Paper’});
# add one row with naming
budget: addrows(budget, {250*2, 0, 5.10}, {‘Tom’});
# summing
subdget: sum_up_rows(budget);
# display
disp budget;

=============================================================
Note: The output of disp statement is as follows:
budget:


Paper
Food(lb) 
Price
John 
0
2 
3.3
Tom 
500 
0
5.10
.
Appendix A. BuckCak Library Function List
mat : init_mat_col(mat NC);
	Return a matrix with 0 rows and N columns. NC looks like {‘Name’, ‘Age’, ‘...’, ...}.
N = cols(NC), and the names of columns are specified by NC.
mat : addrows(mat M, mat dR, mat dRn); 
	Add rows in dR to M, and naming the new added rows with dRn. dRn looks like {‘Tom’, ‘John’, ‘...’, ...}, and its length equals to the row number of dR.
Note: the naming of this function is different “rowcat”, which begins with “row”. Because rowcat is a buit-in function while addrows not.

mat : sum_row(mat M);
mat : sum_col(mat M);
	Return a vector, as the sum of rows/columns in mat M.
mat : avg_row(mat M);
mat : avg_col(mat M);	
	Return a vector, as the average of all rows/columns in mat M.
mat : var_row(mat M);
	Return a row vector v, where v[i] is the variace of numbers in M[0, i].
mat : var_col(mat M);
	Return a column vector v, where v[i] is the variace of numbers in M[i, 0].

