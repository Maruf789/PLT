(* Code Generation
   Input: SAST, 
   Output: target code string list *)

open Sast
(* open Printf *)

let rec trans_expr = function (* translate expr to string *)
    Int x -> 1, string_of_int x
  | Double x -> 2, string_of_float x
  | String x -> 3, ("\'" ^ x ^ "\'")
  | Bool x -> 4, string_of_bool x
  | Id x -> (find_var vtbl x), x
  | MatSub (_, _, _) -> raise Bad_type
  | Assign (l, e) -> let rt, rv = trans_expr e in
                     let lt, lv = trans_lval l in
                     rt, (lv ^ "<-" ^ rv)
  | (Mat _|Binop (_, _, _)|Unaop (_, _)|Call (_, _)) -> raise Bad_type

(* translate variable definition list *)
let rec trans_vardecs = function
    [] -> vtbl, []
  | hd::tl ->
      let a = [ match hd with (* v.vtype dropped *)
                  VarNoInit v -> 
                    (v.vname ^ "<-" ^ (var_init_val v.vtype)) 
                | VarInit (v, e) -> 
                    (v.vname ^ "<-" ^ (trans_expr e))
              ] in
      let vtbl = vtbl in
      let vtbl, b = trans_vardecs tl in
        vtbl, a @ b

let gen_disp es = ("print(" ^ es ^ ")")

let rec trans_elifs = function (* translate a list of elif *)
    [] -> []
  | hd::tl -> ["} elif (" ^ (trans_expr hd.cond) ^ ") {"]
              @ (trans_stmts hd.stmts)
              @ (trans_elifs tl)
and trans_stmts = function (* translate statement list *)
    [] -> []
  | hd::tl -> ( match hd with
                  Disp e -> (let es = trans_expr e in [gen_disp es])
                | Empty -> [""]
                | Expr e -> [trans_expr e]
                | Return e -> (let es = trans_expr e in 
                                 ["return(" ^ (trans_expr e) ^ ")"])
                | Continue -> ["continue"]
                | Break -> ["break"]
                | CndFor c ->
                    ["whlie (" ^ (trans_expr c.cond) ^ ") {"]
                    @ (trans_stmts c.stmts)
                    @ ["}"]
                | CntFor (i, e, s) ->
                    ["for (" ^ i ^ " in " ^
                     (trans_expr e) ^ ") {"]
                    @ (trans_stmts s) @ ["}"]
                | If (i, ei, e) ->
                    ["if ( " ^ (trans_expr i.cond) ^ ") {"]
                    @ (trans_stmts i.stmts)
                    @ (trans_elifs ei)
                    @ ["} else {"]
                    @ (trans_stmts e) @ ["}"]
              ) @ (trans_stmts tl)

let rec trans_fundefs = function
    [] -> []
  | hd::tl -> (let a = [] in
               let b = trans_fundefs tl in 
                 a@b)

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

