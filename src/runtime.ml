(* Static semantic analysis *)
open Ast

(* variable table *)
(* type var_table = var list *)

(* find the type of a @name in @var_table *)
let find_var var_table name = 
  let v = List.find (fun v -> v.vname = name) var_table in 
    v.vtype



(* function table *)
(* type func_table = func list *)

(* generate signature of a function *)
let sig_func fn = 
  { fnname = fn.fname;
    fnargs = (List.fold_left (fun a b -> a@[b.vtype]) [] fn.args)
  }

(* find a function signature(@fnsg) in @func_table *)
let find_func func_table fnsg =
  let func_eq f1 f2 =
    f1.fnname = f2.fnname &&
    try List.for_all2 (=) f1.fnargs f2.fnargs
    with Invalid_argument _ -> false
  in 
    List.find (func_eq fnsg) func_table
