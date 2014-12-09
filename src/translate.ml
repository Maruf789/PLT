(* Code Generation
   Input: SAST, 
   Output: target code string list *)

open Ast
open Sast
open Printf

exception Not_now of string

(* Translate dtype to C++ types *)
let tpt t = match t with
      Int -> "int"
    | Double -> "double"
    | String -> "string"
    | Bool -> "bool"
    | IntMat -> "int_mat"
    | DoubleMat -> "double_mat"
    | StringMat -> "string_mat"
    | Void -> "void"

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
  | _, SCall (s, el) -> (sprintf "( %s( %s ) )" s (trans_arg_list "," el))
  | _, SMatSub (s, e1, e2) -> raise (Not_now "Matsub not implemented")
  | _, SMatval (ell, nc, nr) -> raise (Not_now "Matval not implemented")
and trans_arg_list sc el = match el with
    [] -> ""
  | [e] -> trans_expr e
  | e1::e2::tl ->  sprintf "%s %s %s" (trans_expr e1) sc (trans_arg_list sc (e2::tl))

(* translate variable definition list *)
let rec trans_vardecs vars = match vars with
    [] -> []
  | (t, s, e)::tl ->
    (sprintf "%s %s = %s;" (tpt t) s (trans_expr e)) :: (trans_vardecs tl)


let gen_disp es = ("cout << " ^ es ^ " << endl;")

(* translate statement list *)
let rec trans_elifs elifs = match elifs with (* translate a list of elif *)
    [] -> []
  | hd::tl -> (trans_condstmts "elif" hd) @ (trans_elifs tl)
and trans_condstmts sc cs =
  [sprintf "%s (%s) { " sc (trans_expr cs.scond)] @ (trans_stmts cs.sstmts)
and trans_stmts stmts = match stmts with
    [] -> []
  | hd::tl -> ( match hd with
        SEmpty -> [";"]
      | SExpr e -> [(trans_expr e) ^ " ;"]
      | SReturn e -> [sprintf "return %s ;" (trans_expr e)]
      | SIf (cs, csl, sl) -> (trans_condstmts "if" cs) @ (trans_elifs csl) @ (trans_stmts sl)
      | SCntFor (_, _, _) -> raise (Not_now "CntFor not implemented")
      | SCndFor _ -> raise (Not_now "CndFor not implemented")
      | SDisp e -> (let es = trans_expr e in [gen_disp es])
      | SContinue -> ["continue;"]
      | SBreak -> ["break;"]
    ) @ (trans_stmts tl)


let rec trans_args sc args = match args with
    [] -> ""
  | [a] -> sprintf "%s %s" (tpt a.vtype) (a.vname)
  | a::b::tl -> (sprintf "%s %s%s " (tpt a.vtype) a.vname sc) ^ (trans_args sc (b::tl))
let rec trans_fundefs fundefs = match fundefs with
    [] -> []
  | hd::tl -> (if hd.sbody=[] then 
               ([sprintf "%s %s(%s) {" (tpt hd.sreturn) hd.sfname (trans_args "," hd.sargs)]
               @(trans_vardecs hd.slocals)@(trans_stmts hd.sbody))
               else ([sprintf "%s %s(%s) ;" (tpt hd.sreturn) hd.sfname (trans_args "," hd.sargs)])
              )@(trans_fundefs tl)


let compile prg =
  let head_lines = 
    (*["#include \"buckcal_types.h\""; "int_mat GT_int_mat;"; 
     "string_mat GT_string_mat;"; "double_mat GT_double_mat;"]*)
   ["#include \"buckcal_types.h\""]
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
  let all = head_lines @ func_lines
            @ ["int main() {"] @ var_lines @ stm_lines
            @["return 0;"; "}"] 
  in
  List.iter print_endline all

