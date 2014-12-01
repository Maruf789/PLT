(* Code Generation
   Input: SAST, 
   Output: target code string list *)

open Ast
open Sast
open Printf

exception Not_now of string

let trans_uop op = match op with Neg -> "-" | Not -> "!"

let trans_bop op = match op with
    Plus -> "+" | Minus -> "-" | Times -> "*" | Divide -> "/"
  | Eq -> "==" | Neq -> "!=" | Lt -> "<" | Leq -> "<="
  | Gt -> ">" | Geq -> ">=" | And -> "&&" | Or -> "||"

(* translate expr to string *)
let rec trans_expr exp = match exp with
    _, SIntval x -> (sprintf " %d " x)
  | _, SDoubleval x -> (sprintf "%f" x)
  | _, SStringval x -> (" \"" ^ x ^ "\" ")
  | _, SBoolval x -> if x then " true " else " false "
  | _, SId x -> (" " ^ x ^ " ")
  | _, SBinop (e1, b, e2) -> (sprintf " ( %s %s %s ) " (trans_expr e1) (trans_bop b) (trans_expr e2))
  | _, SAssign (e1, e2) -> (sprintf "( %s = %s )" (trans_expr e1) (trans_expr e2))
  | _, SUnaop (u, e) -> (sprintf "( %s %s )" (trans_uop u) (trans_expr e))
  | _, SCall (s, el) -> (sprintf "( %s( %s ) )" s (trans_expr_list ", " el))
  | _, SMatSub (s, e1, e2) -> raise (Not_now "Matsub not implemented")
  | _, SMatval ell -> raise (Not_now "Matval not implemented")
and trans_expr_list sc el = match el with
    [] -> ""
  | [e] -> trans_expr e
  | e1::e2::tl ->  sprintf "%s%s %s" (trans_expr e1) sc (trans_expr_list sc (e2::tl))

(* translate variable definition list *)
let rec trans_vardecs vars = match vars with
    [] -> []
  | (t, s, e)::tl ->
    (sprintf "%s %s = %s;" (pt t) s (trans_expr e)) :: (trans_vardecs tl)


let gen_disp es = ("cout << " ^ es ^ " << endl;")

(* translate statement list *)
let rec trans_elifs elifs = match elifs with (* translate a list of elif *)
    [] -> []
  | hd::tl -> [""] @ (trans_elifs tl)
and trans_condstmts sc cs =
  [sprintf "%s (%s) { " sc (trans_expr cs.scond)] @ []
and trans_stmts stmts = match stmts with
    [] -> []
  | hd::tl -> ( match hd with
        SEmpty -> [";"]
      | SExpr e -> [(trans_expr e) ^ " ;"]
      | SReturn e -> [sprintf "return %s ;" (trans_expr e)]
      | SIf (cs, csl, sl) -> [trans_condstmts "if" cs] @ (trans_elifs csl) @ (trans_stmts sl)
      | SCntFor (_, _, _) -> raise (Not_now "CntFor not implemented")
      | SCndFor _ -> raise (Not_now "CndFor not implemented")
      | SDisp e -> (let es = trans_expr e in [gen_disp es])
      | SContinue -> ["continue;"]
      | SBreak -> ["break;"]
    ) @ (trans_stmts tl)

let rec trans_fundefs fundefs = match fundefs with
    [] -> []
  | hd::tl -> (let a = [] in
               let b = trans_fundefs tl in 
               a@b)

let compile prg =
  let head_lines = 
    ["#include <types.h>"]
  in
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
  List.iter print_endline (head_lines @ func_lines @ var_lines @ stm_lines)

