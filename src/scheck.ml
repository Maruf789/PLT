(* Static Semantic Check
   Input AST, output SAST *)
open Ast
open Sast
open Scheck_expr

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
(* type func_table = sfun_def list *)

(* FIXME: Maybe Ast.func_def -> Sast.sfun_def is needed *)
(* generate Sast.funsg of a Ast.func_def *)
let sig_func fn = {
  fsname = fn.fname;
  fsargs = List.map (fun v -> v.vtype) fn.args
}

(* generate Sast.funsg of Sast.sfun_def *)
let sig_sfunc sfn = {
  fsname = sfn.sfname;
  fsargs = List.map (fun v -> v.svtype) sfn.sargs
}

(* find a function signature(@fnsg) in @func_table *)
let find_func func_table fnsg =
  let func_eq f1 fd =
    let f2 = sig_sfunc fd in
      f1.fsname = f2.fsname &&
      try List.for_all2 (=) f1.fsargs f2.fsargs
      with Invalid_argument _ -> false
  in
    try List.find (func_eq fnsg) func_table
    with Not_found -> raise (Failure ("Function " ^ fnsg.fsname ^ " not defined"))

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
and check_matval ftbl vtbl matx =
  let check_exp_list exp_list_list =
    List.map (List.map (check_expr ftbl vtbl)) exp_list_list
  in
    check_matval_s (check_exp_list matx)
and check_call ftbl vtbl fn exp_list =
  let sexp_list = List.map (check_expr ftbl vtbl) exp_list in
  let typ_list = List.map (fst) sexp_list in
  let fnsg = find_func ftbl {fsname=fn; fsargs=typ_list} in
    fnsg.sreturn, SCall(fn, sexp_list)
and check_expr ftbl vtbl exp = match exp with
    Intval x -> Int, SIntval x
  | Doubleval x -> Double, SDoubleval x
  | Stringval x -> String, SStringval x
  | Boolval x -> Bool, SBoolval x
  | Matval matx -> check_matval ftbl vtbl matx
  | Lvalue lv -> check_lvalue ftbl vtbl lv
  | Binop(e1, bop, e2) -> check_binop bop
                            (check_expr ftbl vtbl e1)
                            (check_expr ftbl vtbl e2)
  | Unaop(uop, x) -> check_uniop uop (check_expr ftbl vtbl x)
  | Assign(lv, x) -> check_assign (check_lvalue ftbl vtbl lv) 
                       (check_expr ftbl vtbl x)
  | Call(fn, xl) -> check_call ftbl vtbl fn xl


(* check variable definition list,
   while building variable table
   return a svar list and svar_def list *)
let rec check_vardecs ftbl vtbl vardecs = match vardecs with
    [] -> vtbl, []
  | hd::tl -> ignore(hd); (check_vardecs ftbl vtbl tl)

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

