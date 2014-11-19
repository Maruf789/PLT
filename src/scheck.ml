(* Static Semantic Check
   Input AST, output SAST *)
open Ast
open Sast

exception Bad_type of string

(* variable table *)
(* type var_table = var list *)

(* find the type of a @name in @var_table *)
let find_var var_table name =
  let v =
    try List.find (fun v -> v.vname = name) var_table
    with Not_found -> raise (Failure ("Variable " ^ name ^ " not defined"))
  in 
    v.vtype

(* function table *)
(* type func_table = funsg list *)

(* generate signature of a function *)
let sig_func fn =
  { fsname = fn.fname;
    fsargs = (List.fold_left (fun a b -> a@[b.vtype]) [] fn.args)
  }

(* find a function signature(@fnsg) in @func_table *)
let find_func func_table fnsg =
  let func_eq f1 f2 =
    f1.fsname = f2.fsname &&
    try List.for_all2 (=) f1.fsargs f2.fsargs
    with Invalid_argument _ -> false
  in
  List.find (func_eq fnsg) func_table

(* variable default value, 
 return a sexpression *)
let svar_init_sexpr var = match var with
    Int -> Int, SIntval 0
  | Void -> raise (Failure "Cannot define a void variable")
  | _ -> raise (Bad_type "Not implemented")

(* check expr, 
return a sexpression *)
let rec check_lvalue ftbl vtbl lv = match lv with
    Id x -> (find_var vtbl x), (SId x)
  | MatSub(x, e1, e2) -> (find_var vtbl x),
                      (SMatSub (x,
                               (check_expr ftbl vtbl e1),
                               (check_expr ftbl vtbl e2)))
and check_expr ftbl vtbl exp = match exp with
    Intval x -> Int, SIntval x
  | Doubleval x -> Double, SDoubleval x
  | Stringval x -> String, SStringval x
  | Boolval x -> Bool, SBoolval x
  | Lvalue lv -> check_lvalue ftbl vtbl lv
  | _ -> raise (Bad_type "Not implemented")


(* check variable definition list,
  while building variable table
  return a svar list and svar_def list *)
let rec check_vardecs ftbl vtbl vardecs = match vardecs with
    [] -> vtbl, []
  | hd::tl -> check_vardecs ftbl vtbl tl

(* check statement list 
   return a stmt list *)
let rec check_elifs ftbl vtbl elifs = match elifs with(* translate a list of elif *)
    [] -> []
  | hd::tl -> [SExpr (check_expr ftbl vtbl hd.cond)]
              @ (check_stmts ftbl vtbl hd.stmts)
              @ (check_elifs ftbl vtbl tl)
and check_stmts ftbl vtbl stmts = match stmts with
    [] -> []
  | hd::tl -> [ match hd with
                  Disp e -> SDisp (check_expr ftbl vtbl e)
                | _ -> raise (Bad_type "Not implemented")
              ] @ (check_stmts ftbl vtbl tl)

(* check function definition list
   while buiding function table
   return a funsg list and sfun_def list *)
let rec check_fundefs ftbl funsgs = match funsgs with
    [] -> ftbl, []
  | hd::tl -> (let ftbl, a = ftbl, [] in
               let ftbl, b = check_fundefs ftbl tl in 
                 ftbl, a@b)

(* check the whole program
   return a sprogram *)
let check prg =
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
    { spfuns = func_lines;  spvars = var_lines; spstms = stm_lines }

