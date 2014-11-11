module T = Translate
open Printf

let _ = 
  let lexbuf = Lexing.from_channel stdin in
    try
      let prog = Parser.program Scanner.token lexbuf in
        T.compile prog
    with
        T.Bad_type -> print_endline "Error: bad type"
      | _ ->
          let p = lexbuf.Lexing.lex_curr_p in
          let tok = Lexing.lexeme lexbuf in
          let line = p.Lexing.pos_lnum in
          let cnum = p.Lexing.pos_cnum - p.Lexing.pos_bol + 1 
                     - String.length tok in
          let msg = sprintf 
                      "Error: token %s, line %d,%d" 
                      tok line cnum in
            print_endline msg

