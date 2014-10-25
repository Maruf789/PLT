
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
| lower(lower|digit|'_')* as lxm { ID(lxm) }
| digit+ as lxm { INT_LITERAL(int_of_string lxm) }
| digit+'.'digit+ as lxm { 
            DOUBLE_LITERAL(float_of_string lxm) }
| '\''      { let buffer = Buffer.create 16 in
              STRING_LITERAL(string_lit buffer lexbuf) }
| ""
| eof       { EOF }
| _ as c    { let p = Lexing.lexeme_start_p lexbuf in
              let msg = Printf.sprintf 
                   "illegal character %s, in %s line %d,%d" 
                   (Char.escaped c)
                   p.Lexing.pos_fname
                   p.Lexing.pos_lnum
                   (p.Lexing.pos_cnum - p.Lexing.pos_bol + 1)
              in
              raise (Failure msg)}

and comment = parse
  "\n" { token lexbuf }
| _    { comment lexbuf }

and string_lit buffer = parse
  '\''     { Buffer.contents buffer }
| eof      { raise End_of_file }
| _ as c   { Buffer.add_char buffer c; string_lit buffer lexbuf }
