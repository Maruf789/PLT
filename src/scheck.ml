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

(* generate Sast.funsg of Sast.sfun_def *)
let sig_sfunc sfn = {
  fsname = sfn.sfname;
  fsargs = List.map (fun v -> v.vtype) sfn.sargs
}

(* find a function signature in function table
   arguments: @fnsg - function signature to be found
              @func_table - function table
   return: (true, sfun_def) on found, (false, _) on not_found *)
let find_func func_table fnsg =
  let dummy = {sreturn=Void; sfname="_"; sargs=[]; slocals=[]; sbody=[]} in
  let func_eq f1 fd =
    let f2 = sig_sfunc fd in
      f1.fsname = f2.fsname &&
      try List.for_all2 (=) f1.fsargs f2.fsargs
      with Invalid_argument _ -> false
  in
    try true, (List.find (func_eq fnsg) func_table)
    with Not_found -> false, dummy

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
  let found, fnsg = find_func ftbl {fsname=fn; fsargs=typ_list} in
    if found then fnsg.sreturn, SCall(fn, sexp_list)
    else raise (Failure ("Function " ^ fn ^ " not defined"))
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


(* check_fundef
     check function definition
   arguments: Sast.sfun_def list, Ast.func_def
   return: Sast.sfun_def list *)
let check_fundef ftbl new_func_def =
  let sig_func fn = {
    fsname = fn.fname;
    fsargs = List.map (fun v -> v.vtype) fn.args
  } in
  let new_fnsg = sig_func new_func_def in (* signature *)
  let new_sret = new_func_def.return in (* return type *)
  let new_sname = new_func_def.fname in (* name *)
  let new_sargs = new_func_def.args in (* arguments *)
  (* check local variables & build variable table *)
  let vtbl, new_lvars = check_vardecs ftbl [] new_func_def.locals in
  (* check statements *)
  let new_fstmts = check_stmts ftbl vtbl new_func_def.body in
  let new_sfun_def = { sreturn = new_sret;
                       sfname = new_sname;
                       sargs = new_sargs;
                       slocals = new_lvars;
                       sbody = new_fstmts } in
  let found, fbody = find_func ftbl new_fnsg in
    if not found then ftbl@[new_sfun_def]
    else raise (Failure ("Function " ^ new_sname ^ " already defined"))
(* check function definition list
   input: func_def list
   return: sfun_def list *)
let rec check_fundefs ftbl funsgs = match funsgs with
    [] -> ftbl
  | hd::tl -> (let new_ftbl = check_fundef ftbl hd in
                 check_fundefs new_ftbl tl)

(* check the whole program
   return a sprogram *)
let check prg =
  let func_table = [] in (* init function table, should be built-in functions *)
  let func_lines =
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

