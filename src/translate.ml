open Ast
open Runtime
(* open Printf *)

exception Bad_type

type var_def_line = int * string *string (* (type, name, value) *)

let var_init_val = function (* generate initial value *)
    1 -> "0"
  | 2 -> "0.0"
  | 3 -> ""
  | 4 -> "TRUE"
  | 11 -> "matrix()"
  | 12 -> "matrix()"
  | 13 -> "matrix()"
  | _ -> raise Bad_type


let trans_lval ftbl vtbl = function (* translate left value to string *)
    Id x -> (find_var vtbl x), x
  | MatSub (_, _, _) -> raise Bad_type
let rec trans_expr ftbl vtbl = function (* translate expr to string *)
    Int x -> 1, string_of_int x
  | Double x -> 2, string_of_float x
  | String x -> 3, ("\'" ^ x ^ "\'")
  | Bool x -> 4, string_of_bool x
  | Lvalue y -> trans_lval ftbl vtbl y
  | Assign (l, e) -> let rt, rv = trans_expr ftbl vtbl e in
                     let lt, lv = trans_lval ftbl vtbl l in
                     rt, (lv ^ "<-" ^ rv)
  | (Mat _|Binop (_, _, _)|Unaop (_, _)|Call (_, _)) -> raise Bad_type

(* translate variable definition list *)
let rec trans_vardecs ftbl vtbl = function
    [] -> vtbl, []
  | hd::tl ->
      let a = [ match hd with (* v.vtype dropped *)
                  VarNoInit v -> 
                    (v.vname ^ "<-" ^ (var_init_val v.vtype)) 
                | VarInit (v, e) -> 
                    (v.vname ^ "<-" ^ (trans_expr ftbl vtbl e))
              ] in
      let vtbl = vtbl in
      let vtbl, b = trans_vardecs ftbl vtbl tl in
        vtbl, a @ b

let gen_disp es = ("print(" ^ es ^ ")")

let rec trans_elifs ftbl vtbl = function (* translate a list of elif *)
    [] -> []
  | hd::tl -> ["} elif (" ^ (trans_expr ftbl vtbl hd.cond) ^ ") {"]
              @ (trans_stmts ftbl vtbl hd.stmts)
              @ (trans_elifs ftbl vtbl tl)
and trans_stmts ftbl vtbl = function (* translate statement list *)
    [] -> []
  | hd::tl -> ( match hd with
                  Disp e -> (let es = trans_expr ftbl vtbl e in [gen_disp es])
                | Empty -> [""]
                | Expr e -> [trans_expr ftbl vtbl e]
                | Return e -> (let es = trans_expr ftbl vtbl e in 
                                 ["return(" ^ (trans_expr ftbl vtbl e) ^ ")"])
                | Continue -> ["continue"]
                | Break -> ["break"]
                | CndFor c ->
                    ["whlie (" ^ (trans_expr ftbl vtbl c.cond) ^ ") {"]
                    @ (trans_stmts ftbl vtbl c.stmts)
                    @ ["}"]
                | CntFor (i, e, s) ->
                    ["for (" ^ i ^ " in " ^
                     (trans_expr ftbl vtbl e) ^ ") {"]
                    @ (trans_stmts ftbl vtbl s) @ ["}"]
                | If (i, ei, e) ->
                    ["if ( " ^ (trans_expr ftbl vtbl i.cond) ^ ") {"]
                    @ (trans_stmts ftbl vtbl i.stmts)
                    @ (trans_elifs ftbl vtbl ei)
                    @ ["} else {"]
                    @ (trans_stmts ftbl vtbl e) @ ["}"]
              ) @ (trans_stmts ftbl vtbl tl)

let rec trans_fundefs ftbl = function
    [] -> ftbl, []
  | hd::tl -> (let ftbl, a = ftbl, [] in
               let ftbl, b = trans_fundefs ftbl tl in 
                 ftbl, a@b)

let compile prg =
  let func_table = [] in (* init function table, should be built-in functions *)
  let func_table, func_lines =
    let funs = prg.pfuns in
      trans_fundefs func_table funs
  in
  let var_table = [] in (* init variable table as empty *)
  let var_table, var_lines =
    let vars = prg.pvars in
      trans_vardecs func_table var_table vars
  in
  let stm_lines =       (* statements *)
    let stms = prg.pstms in
      trans_stmts func_table var_table stms
  in
    List.iter print_endline (func_lines @ var_lines @ stm_lines)
