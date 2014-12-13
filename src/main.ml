open Printf
open Ast

let return_failure = if true then () else (exit 1)

(* error reporting functions *)
let loc_err lex_buf =
  let p = lex_buf.Lexing.lex_curr_p in
  let tok = Lexing.lexeme lex_buf in
  let fname = p.Lexing.pos_fname in
  let line = p.Lexing.pos_lnum in
  let cnum = p.Lexing.pos_cnum - p.Lexing.pos_bol + 1
             - String.length tok in
  sprintf "token %s, in %s line %d,%d" tok fname line cnum

let perror head err_msg =
  eprintf "%s: %s\n" head err_msg


(* Front end: scanner and parser *)
let get_lex_buf in_file =
    try
      let lexbuf = Lexing.from_channel (open_in in_file) in
      lexbuf.Lexing.lex_curr_p <- { 
        lexbuf.Lexing.lex_curr_p with Lexing.pos_fname = in_file 
      };
      lexbuf
    with
      Sys_error x -> let msg = sprintf "import %s" x in
                     raise (Ast.Syntax_error msg)

let front_end file =
  let rec bfs queue visited funlist =
    let add_queue visited oldq newfile =
      if List.mem newfile visited then oldq else oldq@[newfile]
    in
    match queue with
      [] -> [], visited, funlist
    | hd::tl -> if List.mem hd visited then bfs tl visited funlist
                else begin
                  let lex_buf = get_lex_buf hd in
                  try
                    let visited = hd::visited in
                    let prog = Parser.program Scanner.token lex_buf in
                    let newfiles = prog.pimps in
                    let newq = List.fold_left (add_queue visited) tl newfiles in
                    let funlist = funlist @ prog.pfuns in
                    bfs newq visited funlist
                  with
                    Parsing.Parse_error -> raise (Syntax_error (loc_err lex_buf))
                end
  in
  let _, _, funlist = bfs [file] [] [] in
  let prog = Parser.program Scanner.token (get_lex_buf file) in
  { pimps = []; pfuns = funlist;
    pvars = prog.pvars; pstms = prog.pstms }


(* main function *)
let main in_file oc =
  try
    (*let prog = Parser.program Scanner.token lex_buf in*)
    let ast = front_end in_file in
    let sast = Scheck.check ast in
    let tast = Translate.translate sast in
    Codegen.compile oc tast
  with
    Scanner.Scanner_error x -> perror "Scanner error" x; return_failure
  | Ast.Syntax_error x -> perror "Parser error" x; return_failure
  | Sast.Bad_type x -> perror "Sast error" x; return_failure
  | Tast.Not_now x -> perror "Translate error" x; return_failure
  | Codegen.Not_done x -> perror "Codegen error" x; return_failure

(* Shell interface *)
let _ =
  let argc = Array.length Sys.argv in
  if argc >= 2 then
    let oc =
      let ofile =
        if argc >= 3 then Sys.argv.(2) else "buckcal_out.cpp"
      in
      open_out ofile
    in
    main Sys.argv.(1) oc
  else
    eprintf "Usage: main.bin <input file>\n"; return_failure
