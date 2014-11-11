open Ast
open Printf

exception Bad_type

type var_def_line = int * string *string (* (type, name, value) *)

let var_init_val = function
    1 -> "0"
  | 2 -> "0.0"
  | 3 -> ""
  | 4 -> "TRUE"
  | 11 -> ""
  | 12 -> ""
  | 13 -> ""
  | _ -> raise Bad_type

let trans_lval = function (* translate left value to string *)
    Id x -> x
  | MatSub (_, _, _) -> raise Bad_type
let rec trans_expr = function (* translate expr to string *)
    Int x -> string_of_int x
  | Double x -> string_of_float x
  | String x -> ("\'" ^ x ^ "\'")
  | Bool x -> string_of_bool x
  | Lvalue y -> trans_lval y
  | Assign (l, e) -> ((trans_lval l) ^ "<-" ^ (trans_expr e)) 
  | (Mat _|Binop (_, _, _)|Unaop (_, _)|Call (_, _)) -> raise Bad_type

let rec trans_vardefs = function
    [] -> []
  | hd::tl -> ( match hd with (* v.vtype dropped *)
                  VarNoInit v -> (v.vname ^ "<-" ^ (var_init_val v.vtype)) 
                | VarInit (v, e) -> (v.vname ^ "<-" ^ (trans_expr e))
              ) :: (trans_vardefs tl)
  

let rec trans_stmts = function
    [] -> []
  | hd::tl -> ( match hd with
                  Disp e -> ("print(" ^ (trans_expr e) ^ ")")
                | Empty -> ""
                | Expr e -> (trans_expr e)
                | Return e -> ("return(" ^ (trans_expr e) ^ ")")
                | Continue -> "continue"
                | Break -> "break"
		| If (_, _, _)|CntFor (_, _, _)|CndFor _ -> raise Bad_type
              ) :: (trans_stmts tl)

let compile prg =
  (*let funs = prg.pfuns in (* function table *)*)
  let var_lines =           (* variable definitions *)
    let vars = prg.pvars in 
      trans_vardefs vars
  in
  let stm_lines =           (* statements *)
    let stms = prg.pstms in   
      trans_stmts stms
  in
    List.iter (printf "%s\n") (var_lines @ stm_lines)

