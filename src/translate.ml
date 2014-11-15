(* Code Generation
   Input: SAST, 
   Output: target code string list *)

open Sast
(* open Printf *)

exception Not_implemented

(* translate expr to string *)
let rec trans_expr = function 
    String, SStringval x -> ("\'" ^ x ^ "\'")
  | _, _ -> raise Not_implemented

(* translate variable definition list *)
let rec trans_vardecs = function
    [] -> []
  | hd::tl ->
      let a = [""] in
      let b = trans_vardecs tl in
        a @ b

let gen_disp es = ("print(" ^ es ^ ")")

(* translate statement list *)
let rec trans_elifs = function (* translate a list of elif *)
    [] -> []
  | hd::tl -> [""] @ (trans_elifs tl)
and trans_stmts = function 
    [] -> []
  | hd::tl -> ( match hd with
                  SDisp e -> (let es = trans_expr e in [gen_disp es])
                | _ -> raise Not_implemented
              ) @ (trans_stmts tl)

let rec trans_fundefs = function
    [] -> []
  | hd::tl -> (let a = [] in
               let b = trans_fundefs tl in 
                 a@b)

let compile prg =
  let func_lines =
    let funs = prg.spfuns in
      trans_fundefs funs
  in
  let var_lines =
    let vars = prg.spvars in
      trans_vardecs vars
  in
  let stm_lines =       (* statements *)
    let stms = prg.spstms in
      trans_stmts stms
  in
    List.iter print_endline (func_lines @ var_lines @ stm_lines)

