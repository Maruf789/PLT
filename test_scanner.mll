{ type token = LPAREN | RPAREN | LSBRACK | RSBRACK | LBRACE | RBRACE | SEMI |  COMMA | PLUS | MINUS | TIMES | DIVIDE | ASSIGN | EQ | NEQ | LT | LEQ | GT | GEQ | IF | THEN | ELSE | ELIF | FI | FOR | IN | DO | ROF | RETURN | BREAK | CONTINUE | ELSE | WHILE | RETURN | NOT | AND | OR | DEF | FED | DISP | INT | DOUBLE | STRING | BOOL | MAT | VOID | EOF | BOOL_LITERAL of bool | ID of string | INT_LITERAL of int | DOUBLE_LITERAL of float | STRING_LITERAL of string }

{ (*open Parser*) }

let upper = ['A'-'Z']
let lower = ['a'-'z']
let digit = ['0'-'9']

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "#"      { comment lexbuf }           (* Comments *)
| '('      { LPAREN }
| ')'      { RPAREN }
| '['      { LSBRACK }
| ']'      { RSBRACK }
| '{'      { LBRACE }
| '}'      { RBRACE }
| ';'      { SEMI }
| ','      { COMMA }
| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }
| ':'      { ASSIGN }
| '='      { EQ }
| "!="     { NEQ }
| '<'      { LT }
| "<="     { LEQ }
| ">"      { GT }
| ">="     { GEQ }
| "if"     { IF }
| "then"   { THEN }
| "else"   { ELSE }
| "elif"   { ELIF }
| "fi"     { FI}
| "for"    { FOR }
| "in"     { IN }
| "do"     { DO }
| "rof"    { ROF}
| "return" { RETURN }
| "break"  { BREAK }
| "continue" { CONTINUE }
| "else"   { ELSE }
| "while"  { WHILE }
| "return" { RETURN }
| "not"    { NOT }
| "and"    { AND }
| "or"     { OR }
| "def"    { DEF }
| "fed"    { FED }
| "disp"   { DISP }
| "int"    { INT }
| "double" { DOUBLE }
| "string" { STRING }
| "bool"   { BOOL }
| "true"   { BOOL_LITERAL(true) }
| "false"  { BOOL_LITERAL(false) }
| "mat"    { MAT }
| "void"   { VOID }
| (lower|digit|'_')* as lxm { ID(lxm) }
| digit+ as lxm { INT_LITERAL(int_of_string lxm) }
| digit+'.'digit+ as lxm { 
            DOUBLE_LITERAL(double_of_string lxm) }
| '\''      { let buffer = Buffer.create 16 in
              STRING_LITERAL(string_lit lexbuf) }
| ""
| eof       { EOF }
| _ as char { raise (Failure
             ("illegal character " ^ Char.escaped char)) }

and comment = parse
  "\n" { token lexbuf }
| _    { comment lexbuf }

and string_lit = parse
  '\''     { Buffer.contents buffer }
| eof      { raise End_of_file }
| _ as c   { Buffer.add_char buffer c; string_lit lexbuf }


{
  let lexbuf = Lexing.from_channel stdin in 
    match token lexbuf with
      EOF -> ()
    | _ -> print_string "Token"
}
