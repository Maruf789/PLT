{ 
  open Parser 
  open Lexing
  
  (* increase line no *)
  let incr_lineno lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <- { pos with
    pos_lnum = pos.pos_lnum + 1;
    pos_bol = pos.pos_cnum;
  }
}

let upper = ['A'-'Z']
let lower = ['a'-'z']
let digit = ['0'-'9']

rule token = parse
  [' ' '\t' '\r'] { token lexbuf } (* Whitespace *)
| '\n'     { incr_lineno lexbuf; token lexbuf } (* Newline *)
| '#'      { comment lexbuf }      (* Comments *)
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
| '>'      { GT }
| ">="     { GEQ }
| "not"    { NOT }
| "and"    { AND }
| "or"     { OR }
| "if"     { IF }
| "then"   { THEN }
| "else"   { ELSE }
| "elif"   { ELIF }
| "fi"     { FI }
| "for"    { FOR }
| "in"     { IN }
| "do"     { DO }
| "rof"    { ROF}
| "return" { RETURN }
| "break"  { BREAK }
| "continue" { CONTINUE }
| "def"    { DEF }
| "fed"    { FED }
| "disp"   { DISP }
| "int"    { INT }
| "double" { DOUBLE }
| "string" { STRING }
| "bool"   { BOOL }
| "true"   { BOOL_LITERAL(true) }
| "false"  { BOOL_LITERAL(false) }
| "int mat"       { MAT(1) }
| "double mat"    { MAT(2) }
| "string mat"    { MAT(3) }
| lower(lower|digit|'_')* as lxm { ID(lxm) }
| digit+ as lxm { INT_LITERAL(int_of_string lxm) }
| digit+'.'digit* as lxm { 
            DOUBLE_LITERAL(float_of_string lxm) }
| '\''      { let buffer = [] in
              STRING_LITERAL(string_lit buffer lexbuf) }
| eof       { EOF }
| _ as c    { let p = lexeme_start_p lexbuf in
              let msg = Printf.sprintf
                   "illegal character %s, in %s line %d,%d"
                   (Char.escaped c)
                   p.pos_fname
                   p.pos_lnum
                   (p.pos_cnum - p.pos_bol + 1)
              in
              raise (Failure msg) }

and comment = parse
  '\n' { incr_lineno lexbuf; token lexbuf }
| eof  { EOF }
| _    { comment lexbuf }

and string_lit buf = parse
  '\''     { String.concat "" (List.rev buf) }
| eof      { raise End_of_file }
| '\n'     { raise End_of_file }
| "\\n"    { string_lit ("\\n"::buf) lexbuf }
| "\\t"    { string_lit ("\\t"::buf) lexbuf }
| "\\'"    { string_lit ("\\'"::buf) lexbuf }
| "\\\\"   { string_lit ("\\\\"::buf) lexbuf }
| _ as c   { string_lit ((Char.escaped c)::buf) lexbuf }

