(* Static Semantic Check
   Input AST, output SAST *)
open Ast
open Sast
open Scheck_expr
open Lib
open Printf

(* variable table *)
(* type var_table = svar_def list *)

(* find the type of a @name in @var_table
   return: (true, dtype) on found, (false, _) on not_found *)
let find_var var_table name =
  (*let _ = ignore(List.iter (fun (_,n,_) -> printf "%s " n) var_table) in
  let _ = printf "find: %s \n" name in*)
  try
    let t, _, _ = List.find (fun (_,b,_) -> b = name) var_table in
    true, t
  with Not_found -> false, Void

(* general type equality - int = double *)
let eq_t t1 t2 = match t1, t2 with
    Int, Double | Double, Int | IntMat, DoubleMat | DoubleMat, IntMat -> true
  | x, y -> if x == y then true else false


(* function table *)
(* type func_table = sfun_def list *)

(* generate Sast.funsg of Sast.sfun_def *)
let sig_sfunc sfn = {
  fsname = sfn.sfname;
  fsargs = List.map (fun v -> v.vtype) sfn.sargs
}

(* helper: print function signature *)
let print_func_sig sfn =
  let rec args_s xx = match xx with
      [] -> ""
    | [a] -> pt a
    | a::b::tl -> (sprintf "%s, %s" (pt a) (args_s (b::tl)))
  in
  eprintf "%s(%s)\n" sfn.fsname (args_s sfn.fsargs)

(* replace @o in List @lst with @n *)
let rec list_rep o n lst = match lst with
    [] -> []
  | hd::tl -> let a = (if hd=o then n else hd) in a::(list_rep o n tl)

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
  | Double -> Double, SDoubleval 0.0
  | Bool -> Bool, SBoolval false
  | String -> String, SStringval ""
  | IntMat -> IntMat, SMatval ([[]], 0, 0)
  | DoubleMat -> DoubleMat, SMatval ([[]], 0, 0)
  | StringMat -> StringMat, SMatval ([[]], 0, 0)
  | Void -> raise (Bad_type "cannot define a void variable")

(* convert var list to svar_def list *)
let var2def_list vl =
  let var2def v = v.vtype, v.vname, (svar_init_sexpr v.vtype) in
  List.map var2def vl

(* check expr, 
   return a sexpression *)
let rec check_lvalue ftbl vtbl lv = match lv with
    Id x -> let f, t = find_var vtbl x in 
    if f then t, (SId x)
    else raise (Bad_type ("variable " ^ x ^ " not defined"))
  | MatSub(x, e1, e2) -> let f, t = find_var vtbl x in
    if f then t, (SMatSub (x,
                           (check_expr ftbl vtbl e1),
                           (check_expr ftbl vtbl e2)))
    else raise (Bad_type ("variable " ^ x ^ " not defined"))
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
  else raise (Bad_type ("function " ^ fn ^ " not defined"))
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
   return a svar_def list *)
let rec check_vardecs ftbl vtbl vardecs = match vardecs with
    [] -> vtbl
  | hd::tl -> let new_vardec = (
    let new_v, init_e = (
      match hd with
        VarNoInit v -> v, (svar_init_sexpr v.vtype)
      | VarInit (v, e) -> v, (check_expr ftbl vtbl e))
    in
    let new_type, new_name = new_v.vtype, new_v.vname in
    let _ =
      let f, _ = find_var vtbl new_name in
      if not f then () else raise (Bad_type (new_v.vname ^ " defined twice"))
    in
    let new_type =
      if eq_t new_type (fst init_e) then new_type
      else raise (Bad_type "variable and expression type mismatch")
    in
    [(new_type, new_name, init_e)] )
    in
    (check_vardecs ftbl (vtbl@new_vardec) tl)

(* check statement list.
   return: sstmt list *)
let rec check_condstmts ftbl vtbl cs = match cs with(* translate a list of elif *)
    [] -> []
  | hd::tl -> { scond=(check_expr ftbl vtbl hd.cond) ;
                sstmts=(check_stmts ftbl vtbl hd.stmts)
              } :: (check_condstmts ftbl vtbl tl)
and check_stmts ftbl vtbl stmts = match stmts with
    [] -> []
  | hd::tl -> ( match hd with
        Empty -> SEmpty
      | Expr e -> SExpr (check_expr ftbl vtbl e)
      | Return e -> SReturn (check_expr ftbl vtbl e)
      | If (c, cl, ss) -> SIf ((List.hd (check_condstmts ftbl vtbl [c])), 
                               (check_condstmts ftbl vtbl cl),
                               (check_stmts ftbl vtbl ss))
      | CntFor (s, e, ss) -> (
          let f, st = find_var vtbl s in
          let et, e = check_expr ftbl vtbl e in
          let sss = check_stmts ftbl vtbl ss in
          let _ = if f then () else raise (Bad_type (s ^ "undefined")) in
          let et_t = match et with
              IntMat -> Int
            | DoubleMat -> Double
            | StringMat -> String
            | _ -> raise (Bad_type "must be loop in a mat")
          in
          if eq_t et_t st then SCntFor (s, (et, e), sss)
          else raise (Bad_type "loop variable type mismatch") )
      | CndFor cs -> SCndFor (List.hd (check_condstmts ftbl vtbl [cs]))
      | Disp e -> SDisp (check_expr ftbl vtbl e)
      | Continue -> SContinue
      | Break -> SBreak
    ) :: (check_stmts ftbl vtbl tl)


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
  (*let _ = print_func_sig new_fnsg in*)
  let new_sname = new_func_def.fname in (* name *)
  let new_sargs = new_func_def.args in (* arguments *)
  (* check local variables & build variable table *)
  let arg_def = var2def_list new_sargs in
  let new_local = check_vardecs ftbl arg_def new_func_def.locals in
  let vtbl = new_local in
  (* check statements *)
  let new_fstmts = check_stmts ftbl vtbl new_func_def.body in
  let new_sfun_def = { sreturn = new_sret;
                       sfname = new_sname;
                       sargs = new_sargs;
                       slocals = new_local;
                       sbody = new_fstmts } in
  let found, fbody = find_func ftbl new_fnsg in
  if not found then ftbl@[new_sfun_def]
  else (
    if (fbody.sbody=[] && fbody.slocals=[])
    then (list_rep fbody new_sfun_def ftbl)
    else raise (Bad_type ("Function '" ^ new_sname ^ "' already defined"))
  )


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
  let func_table =
    let func_table_0 = lib_funs in (* init function table, should be built-in functions *)
    check_fundefs func_table_0 prg.pfuns
  in
  let var_table =
    let var_table_0 = [] in    (* init variable table as empty *)  
    check_vardecs func_table var_table_0 prg.pvars
  in
  let stm_lines =            (* statements *)
    check_stmts func_table var_table prg.pstms
  in
  { spfuns = func_table;  spvars = var_table; spstms = stm_lines }

