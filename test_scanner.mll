{
open Parser
open Lexing

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
| "#"      { comment lexbuf }      (* Comments *)
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
| "mat"           { MAT("") }
| "int mat"       { MAT("int") }
| "double mat"    { MAT("double") }
| "string mat"    { MAT("string") }
| lower(lower|digit|'_')* as lxm { ID(lxm) }
| digit+ as lxm { INT_LITERAL(int_of_string lxm) }
| digit+'.'digit* as lxm { 
            DOUBLE_LITERAL(float_of_string lxm) }
| '\''      { let buffer = Buffer.create 16 in
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
  '\n' { token lexbuf }
| _    { comment lexbuf }

and string_lit buffer = parse
  '\''     { Buffer.contents buffer }
| eof      { raise End_of_file }
| "\\n"    { Buffer.add_char buffer '\n'; string_lit buffer lexbuf }
| "\\t"    { Buffer.add_char buffer '\t'; string_lit buffer lexbuf }
| "\\'"    { Buffer.add_char buffer '\''; string_lit buffer lexbuf }
| '\\'     { Buffer.add_char buffer '\\'; string_lit buffer lexbuf }
| _ as c   { Buffer.add_char buffer c; string_lit buffer lexbuf }

{
  let lexbuf = Lexing.from_channel stdin in 
  let wordlist =
    let rec next l =
      match token lexbuf with
          EOF -> l
        | _ -> next ("Token " :: l) 
    in next []
  in
  List.iter print_endline wordlist
}

