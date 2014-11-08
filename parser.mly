%{ open Ast %}

%token LPAREN RPAREN LSBRACK RSBRACK LBRACE RBRACE SEMI COMMA ASSIGN
%token PLUS MINUS TIMES DIVIDE
%token IF THEN ELIF ELSE FI FOR IN DO ROF RETURN BREAK CONTINUE DEF FED DISP
%token EQ NEQ LT LEQ GT GEQ NOT AND OR
%token INT DOUBLE STRING BOOL
%token <int> MAT
%token <string> ID
%token <bool>  BOOL_LITERAL
%token <int> INT_LITERAL
%token <float> DOUBLE_LITERAL
%token <string> STRING_LITERAL
%token EOF

%right ASSIGN
%left OR
%left AND
%right NOT
%left LT GT LEQ GEQ
%left EQ NEQ
%left PLUS MINUS
%left TIMES DIVIDE
%nonassoc NEG

%start program
%type <Ast.program> program

%%

/* ---data type related--- */

/* data type representation */
dtype:
/*| VOID                { 0 }*/
  | INT                 { 1 }
  | DOUBLE              { 2 }
  | STRING              { 3 }
  | BOOL                { 4 }
  | MAT                 { 10+$1 }


/* variable declaration or definition */
var_dec_def:
    dtype ID SEMI                     { VarNoInit({ vname = $2; vtype = $1; }) } /* not initialized*/
  | dtype ID ASSIGN expr SEMI         { VarInit({ vname = $2; vtype = $1; }, $4) }


/* variable declaration or definition list */
var_dec_def_list:
                                  { [] } /* empty */
  | var_dec_def_list var_dec_def  { $1 @ [$2] }


/* --- arguments and function related --- */


/* argument list in function declaration/definition */
arg_def_list :
    dtype ID     { [{ vname = $2; vtype = $1; }] }
  | dtype        { [{ vname = "_"; vtype = $1; }] }
  | arg_def_list COMMA dtype ID   { $1 @ [{ vname = $4; vtype = $3; }] }
  | arg_def_list COMMA dtype      { $1 @ [{ vname = "_"; vtype = $3; }] }


/* a function definition */
func_def:
    DEF dtype ID LPAREN arg_def_list RPAREN DO var_dec_def_list stmt_list FED {
        { return = $2; fname = $3; args = $5; locals = $8; body = $9; }
      }
  | DEF ID LPAREN arg_def_list RPAREN DO var_dec_def_list stmt_list FED {
        { return = 0; fname = $2; args = $4; locals = $7; body = $8; } 
      }


/* a list of function definitions */
func_def_list:
  | func_def                { [$1] } /* nothing */
  | func_def_list func_def  { $1 @ [$2] }


/* --- if related --- */

/* represent a series of elif */
elif_list:
                                       { [] } /* nothing */
  | elif_list ELIF expr THEN stmt_list { $1 @ [{cond=$3; stmts=$5}] }


/* represent the optional else statement */
else_stmt:
                      { [] } /* nothing */
  | ELSE stmt_list    { $2 }


/* --- matrix literal related --- */

/* matrix literal, list of list */
mat_literal:
  | LBRACE RBRACE               { [[]] }
  | LBRACE mat_rows RBRACE      { $2 }


/* rows of matrix */
mat_rows:
  | mat_row                { [$1] } /* first row */
  | mat_rows SEMI mat_row  { $1 @ [$3] }


/* elements in a matrix row */
mat_row:
  | expr                { [$1] } /* first element */
  | mat_row COMMA expr  { $1 @ [$3]  }


/* an expression */
expr:
    BOOL_LITERAL                       { Bool($1) }
  | INT_LITERAL                        { Int($1) }
  | DOUBLE_LITERAL                     { Double($1) }
  | STRING_LITERAL                     { String($1) }
  | mat_literal                        { Mat($1) }
  | ID                                 { Lvalue(Id($1)) }
  | ID LSBRACK expr COMMA expr RSBRACK /* matrix select */
                                       { Lvalue(MatSub($1, $3, $5)) }
  | expr PLUS   expr                   { Binop($1, Plus,  $3) }
  | expr MINUS  expr                   { Binop($1, Minus,  $3) }
  | expr TIMES  expr                   { Binop($1, Times, $3) }
  | expr DIVIDE expr                   { Binop($1, Divide,  $3) }
  | expr EQ     expr                   { Binop($1, Eq,   $3) }
  | expr NEQ    expr                   { Binop($1, Neq,  $3) }
  | expr LT     expr                   { Binop($1, Lt,   $3) }
  | expr LEQ    expr                   { Binop($1, Leq,  $3) }
  | expr GT     expr                   { Binop($1, Gt,   $3) }
  | expr GEQ    expr                   { Binop($1, Geq,  $3) }
  | expr AND    expr                   { Binop($1, And,  $3) }
  | expr OR     expr                   { Binop($1, Or,   $3) }
  | ID ASSIGN expr                     { Assign(Id($1), $3) }
  | NOT expr                           { Unaop(Not, $2) }
  | MINUS expr %prec NEG               { Unaop(Neg, $2) }
  | ID LPAREN arg_call_list RPAREN     { Call($1, $3) }
  | LPAREN expr RPAREN                 { $2 }

/* argument list in function calling */
arg_call_list:
                              { [] } /* type and ID */
  | arg_call_list COMMA expr  { $1 @ [ $3 ] }

/* --- program related --- */ 

/* a list of statements */
stmt_list:
                   { [] } /* nothing */
  | stmt_list stmt { $1 @ [$2] }

/* a statement */
stmt:
    expr SEMI                                      { Expr($1) }
  | RETURN expr SEMI                               { Return($2) }
  | IF expr THEN stmt_list elif_list else_stmt FI  { If({cond=$2; stmts=$4}, $5, $6) }
  | FOR ID IN expr DO stmt_list ROF                { CntFor($2, $4, $6) } /* counting loop */
  | FOR expr DO stmt_list ROF                      { CndFor({cond=$2; stmts=$4}) } /* conditional loop */
  | DISP expr SEMI                                 { Disp($2) }
  | CONTINUE SEMI                                  { Continue }
  | BREAK SEMI                                     { Break }

/* With this, no reduce/shift conflict. But 4 rules never reduced 

program:
                       { {pfuns = []; pvars = []; pstms = [];} }
 | program func_declare { {pfuns = $1.pfuns @ [$2]; pvars = $1.pvars; pstms = $1.pstms;} }
 | program func_def    { {pfuns = $1.pfuns @ [$2]; pvars = $1.pvars; pstms = $1.pstms;} }
 | program var_dec_def { {pfuns = $1.pfuns; pvars = $1.pvars @ [$2]; pstms = $1.pstms;} }
 | program stmt        { {pfuns = $1.pfuns; pvars = $1.pvars; pstms = $1.pstms @ [$2];} }
*/

/* This cause shift/reduce conflict in var_dec_def_list */
program:
    func_def_list var_dec_def_list stmt_list  {
        {pfuns = $1; pvars = $2; pstms = $3;}
      }
  | var_dec_def_list stmt_list  {
        {pfuns = []; pvars = $1; pstms = $2;}
      }

