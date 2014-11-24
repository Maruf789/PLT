open Printf

(* error reporting functions *)
let loc_err lex_buf =
  let p = lex_buf.Lexing.lex_curr_p in
		let tok = Lexing.lexeme lex_buf in
		let line = p.Lexing.pos_lnum in
		let cnum = p.Lexing.pos_cnum - p.Lexing.pos_bol + 1
			         - String.length tok in
		  sprintf "token %s, line %d,%d" tok line cnum

let perror head err_msg =
  eprintf "%s: %s\n" head err_msg

(* main function *)
let main lex_buf =
  try
    let prog = Parser.program Scanner.token lex_buf in
    let sprog = Scheck.check prog in
      Translate.compile sprog
  with
      Scanner.Scanner_error x -> perror "Scanner error" x
    | Parsing.Parse_error -> perror "Parser error" (loc_err lex_buf)
    | Sast.Bad_type x -> perror "Sast error" x
		| Translate.Not_implemented -> perror "Translate error" (loc_err lex_buf)
		| _ -> perror "Unkown error" (loc_err lex_buf)

(* Shell interface *)
let _ =
  if Array.length Sys.argv >= 2 then
    try
      let lexbuf = Lexing.from_channel (open_in Sys.argv.(1)) in
        main lexbuf
    with
      Sys_error msg -> print_endline("Error: " ^ msg)
  else
    print_endline "Usage: main.bin <input file>"
