type token =
  | LPAREN
  | RPAREN
  | LSBRACK
  | RSBRACK
  | LBRACE
  | RBRACE
  | SEMI
  | COMMA
  | ASSIGN
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | IF
  | THEN
  | ELIF
  | ELSE
  | FI
  | FOR
  | IN
  | DO
  | ROF
  | RETURN
  | BREAK
  | CONTINUE
  | DEF
  | FED
  | DISP
  | EQ
  | NEQ
  | LT
  | LEQ
  | GT
  | GEQ
  | NOT
  | AND
  | OR
  | INT
  | DOUBLE
  | STRING
  | BOOL
  | MAT of (int)
  | ID of (string)
  | BOOL_LITERAL of (bool)
  | INT_LITERAL of (int)
  | DOUBLE_LITERAL of (float)
  | STRING_LITERAL of (string)
  | EOF

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.program
