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


(* Front end: scanner and parser *)
let get_lex_buf in_file =
    try
      Lexing.from_channel (open_in in_file)
    with
      Sys_error msg -> (eprintf "I/O error: %s" msg); raise End_of_file

let front_end files =



(* main function *)
let main in_file oc =
  try
    (*let prog = Parser.program Scanner.token lex_buf in*)
    let prog = front_end [in_file] in
    let sprog = Scheck.check prog in
    let tprog = Translate.translate sprog in
    Codegen.compile oc tprog
  with
    Scanner.Scanner_error x -> perror "Scanner error" x
  | Parsing.Parse_error -> perror "Parser error" (loc_err lex_buf)
  | Sast.Bad_type x -> perror "Sast error" x
  | Tast.Not_now x -> perror "Translate error" x
  | Codegen.Not_done x -> perror "Codegen error" x
  | _ -> perror "Unkown error" (loc_err lex_buf)

(* Shell interface *)
let _ =
  let argc = Array.length Sys.argv in
  if argc >= 2 then
    let oc = 
      let ofile =
        if argc >= 3 then Sys.argv.(2) else "a.cpp"
      in
      try
        open_out ofile
      with
        Sys_error msg -> (eprintf "I/O error: %s" msg); raise End_of_file
    in
    main Sys.argv.(1) oc
  else
    print_endline "Usage: main.bin <input file>"
