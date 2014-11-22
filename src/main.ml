open Printf

let _ =
  if Array.length Sys.argv >= 2 then
    try let lexbuf = Lexing.from_channel (open_in Sys.argv.(1)) in
      try
        let prog = Parser.program Scanner.token lexbuf in
        let sprog = Scheck.check prog in
        Translate.compile sprog
      with  
        Sast.Bad_type x -> print_endline ("Error: bad type " ^ x)
      | Translate.Not_implemented -> print_endline "Error: not implemented"
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
    with
      Sys_error msg -> print_endline("Error: " ^ msg)
  else
    print_endline "Usage: main.bin <input file>"
