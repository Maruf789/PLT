(* Static Semantic Check
   Input AST, output SAST *)
open Ast
open Sast

exception Bad_type of string

(* variable default value, 
 return a sexpression *)
let svar_init_sexpr = function
    Int -> Int, SIntval 0
  | Void -> raise (Failure "Cannot define a void variable")
  | _ -> raise (Bad_type "Not implemented")

(* check expr, 
return a sexpression *)
let rec check_expr ftbl vtbl = function
    Intval x -> Int, SIntval x
  | Doubleval x -> Double, SDoubleval x
  | Stringval x -> String, SStringval x
  | Boolval x -> Bool, SBoolval x
  | _ -> raise Bad_type "Not implemented"


(* check variable definition list,
  while building variable table
  return a svar list and svar_def list *)
let rec check_vardecs ftbl vtbl = function
    [] -> vtbl, []
  | hd::tl ->
      let a = [ match hd with (* v.vtype dropped *)
                  VarNoInit v -> 
                    (v.vname ^ "<-" ^ (var_init_val v.vtype)) 
                | VarInit (v, e) -> 
                    (v.vname ^ "<-" ^ (check_expr ftbl vtbl e))
              ] in
      let vtbl = vtbl in
      let vtbl, b = check_vardecs ftbl vtbl tl in
        vtbl, a @ b

let gen_disp es = ("print(" ^ es ^ ")")

(* check statement list 
   return a stmt list *)
let rec check_elifs ftbl vtbl = function (* translate a list of elif *)
    [] -> []
  | hd::tl -> ["} elif (" ^ (check_expr ftbl vtbl hd.cond) ^ ") {"]
              @ (check_stmts ftbl vtbl hd.stmts)
              @ (check_elifs ftbl vtbl tl)
and check_stmts ftbl vtbl = function 
    [] -> []
  | hd::tl -> ( match hd with
                  Disp e -> (let es = check_expr ftbl vtbl e in [gen_disp es])
                | Empty -> [""]
                | Expr e -> [check_expr ftbl vtbl e]
                | Return e -> (let es = check_expr ftbl vtbl e in 
                                 ["return(" ^ (check_expr ftbl vtbl e) ^ ")"])
                | Continue -> ["continue"]
                | Break -> ["break"]
                | CndFor c ->
                    ["whlie (" ^ (check_expr ftbl vtbl c.cond) ^ ") {"]
                    @ (check_stmts ftbl vtbl c.stmts)
                    @ ["}"]
                | CntFor (i, e, s) ->
                    ["for (" ^ i ^ " in " ^
                     (check_expr ftbl vtbl e) ^ ") {"]
                    @ (check_stmts ftbl vtbl s) @ ["}"]
                | If (i, ei, e) ->
                    ["if ( " ^ (check_expr ftbl vtbl i.cond) ^ ") {"]
                    @ (check_stmts ftbl vtbl i.stmts)
                    @ (check_elifs ftbl vtbl ei)
                    @ ["} else {"]
                    @ (check_stmts ftbl vtbl e) @ ["}"]
              ) @ (check_stmts ftbl vtbl tl)

(* check function definition list
   while buiding function table
   return a funsg list and sfun_def list *)
let rec check_fundefs ftbl = function
    [] -> ftbl, []
  | hd::tl -> (let ftbl, a = ftbl, [] in
               let ftbl, b = check_fundefs ftbl tl in 
                 ftbl, a@b)

(* check the whole program
   return a sprogram *)
let compile prg =
  let func_table = [] in (* init function table, should be built-in functions *)
  let func_table, func_lines =
    let funs = prg.pfuns in
      check_fundefs func_table funs
  in
  let var_table = [] in (* init variable table as empty *)
  let var_table, var_lines =
    let vars = prg.pvars in
      check_vardecs func_table var_table vars
  in
  let stm_lines =       (* statements *)
    let stms = prg.pstms in
      check_stmts func_table var_table stms
  in
    List.iter print_endline (func_lines @ var_lines @ stm_lines)

