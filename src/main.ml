open Printf
open Ast
open Sast


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

let rec compile_all flag main_file main_oc =
  let append_new_sast_funs olds newfile =
    let ofname = (newfile ^ ".cpp") in
    let new_oc = open_out ofname in
    let new_sast = compile_all IMP newfile new_oc in
    let new_sfuns = new_sast.spfuns in
    (olds @ new_sfuns)
  in
  let ast = Parser.program Scanner.token (get_lex_buf main_file) in
  let newfiles = ast.pimps in
  let extern_funs = List.fold_left append_new_sast_funs [] newfiles in
  let extern_func_table =
    let to_fun_dec ff = { ff with slocals = []; sbody = [] } in
    List.map to_fun_dec extern_funs
  in
  (*let _ = printf "#extern = %d\n" (List.length extern_func_table) in*)
  let sast0 = Scheck.check flag extern_funs ast in
  let sast = { sast0 with spfuns = extern_func_table @ sast0.spfuns } in
  let tast = Translate.translate flag sast in
  let _ = Codegen.compile main_oc tast in
  sast0


(* main function. return 0 on success, 1 on failure *)
let main in_file oc =
  try
    (*let prog = Parser.program Scanner.token lex_buf in*)
    (*let ast = front_end in_file in
    let sast = Scheck.check lib_funs ast*)
    (ignore (compile_all TOP in_file oc); 0)
  with
    Scanner.Scanner_error x -> perror "Scanner error" x; 1
  | Ast.Syntax_error x -> perror "Parser error" x; 1
  | Sast.Bad_type x -> perror "Sast error" x; 1
  | Tast.Not_now x -> perror "Translate error" x; 1
  | Codegen.Not_done x -> perror "Codegen error" x; 1


(* Shell interface *)
let _ =
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
