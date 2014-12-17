open Printf
open Ast


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
  let rec dfs stack visited funlist =
    let add_stack visited olds newfile =
      if List.mem newfile visited then olds else newfile::olds
    in
    match stack with
      [] -> [], visited, funlist
    | hd::tl -> if List.mem hd visited then dfs tl visited funlist
                else begin
                  let lex_buf = get_lex_buf hd in
                  try
                    let visited = hd::visited in
                    let prog = Parser.program Scanner.token lex_buf in
                    let newfiles = prog.pimps in
                    let news = List.fold_left (add_stack visited) tl newfiles in
                    let funlist = prog.pfuns @ funlist in
                    dfs news visited funlist
                  with
                    Parsing.Parse_error -> raise (Syntax_error (loc_err lex_buf))
                end
  in
  let _, _, funlist = dfs [file] [] [] in
  let prog = Parser.program Scanner.token (get_lex_buf file) in
  { pimps = []; pfuns = funlist;
    pvars = prog.pvars; pstms = prog.pstms }


(* main function. return 0 on success, 1 on failure *)
let main in_file oc =
  try
    (*let prog = Parser.program Scanner.token lex_buf in*)
    let ast = front_end in_file in
    let sast = Scheck.check ast in
    let tast = Translate.translate sast in
    (Codegen.compile oc tast; 0)
  with
    Scanner.Scanner_error x -> perror "Scanner error" x; 1
  | Ast.Syntax_error x -> perror "Parser error" x; 1
  | Sast.Bad_type x -> perror "Sast error" x; 1
  | Tast.Not_now x -> perror "Translate error" x; 1
  | Codegen.Not_done x -> perror "Codegen error" x; 1

(* Shell interface *)
let () =
  let argc = Array.length Sys.argv in
  let exit_code =
    if argc >= 2 then
      let oc =
        let ofile =
          if argc >= 3 then Sys.argv.(2) else "buckcal_out.cpp"
        in
        open_out ofile
      in
      main Sys.argv.(1) oc
    else
      (eprintf "Usage: main.bin <input file>\n"; 1)
  in
  exit exit_code
