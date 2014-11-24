open Printf

let main lex_buf =
  try
    let prog = Parser.program Scanner.token lex_buf in
    let sprog = Scheck.check prog in
      Translate.compile sprog
  with
      Scanner.Scanner_error x -> print_endline ("Scanner error: " ^ x)
    | Sast.Bad_type x -> print_endline ("Sast error: " ^ x)
		| Translate.Not_implemented -> print_endline "Translate error: not implemented"
		| _ ->
			let p = lex_buf.Lexing.lex_curr_p in
			let tok = Lexing.lexeme lex_buf in
			let line = p.Lexing.pos_lnum in
			let cnum = p.Lexing.pos_cnum - p.Lexing.pos_bol + 1
				         - String.length tok in
			let msg = sprintf
				"Error: token %s, line %d,%d"
				tok line cnum in
			print_endline msg

let _ =
  if Array.length Sys.argv >= 2 then
    try
      let lexbuf = Lexing.from_channel (open_in Sys.argv.(1)) in
        main lexbuf
    with
      Sys_error msg -> print_endline("Error: " ^ msg)
  else
    print_endline "Usage: main.bin <input file>"
