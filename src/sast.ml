(* Semantic checked Abstract Syntax Tree - Safe Abstract Syntax Tree *)
open Ast

exception Bad_type of string

(* variable *)
(* type svar = { svtype: dtype; svname: string } *)

(* expression with type *)
type sexpr_val =
    SId of string
  | SMatSub of string * sexpr * sexpr
  | SBoolval of bool
  | SIntval of int
  | SDoubleval of float
  | SStringval of string
  | SMatval of sexpr list list
  | SBinop of sexpr * binop * sexpr
  | SAssign of sexpr_val * sexpr_val
  | SUnaop of unaop * sexpr_val
  | SCall of string * sexpr list
and sexpr = dtype * sexpr_val

(* variable definition *)
type svar_def = dtype * string * sexpr (* type, name, init expr *)

(* statement *)
type scond_stmts = {
  scond : sexpr;
  sstmts : sstmt list
}
and sstmt =
    SEmpty
  | SExpr of sexpr
  | SReturn of sexpr
  | SIf of scond_stmts * scond_stmts list * sstmt list
  | SCntFor of string * sexpr * sstmt list
  | SCndFor of scond_stmts
  | SDisp of sexpr
  | SContinue
  | SBreak

(* function signature *)
type funsg = {
  fsname : string;
  fsargs : dtype list
}

(* function definition *)
type sfun_def = {
  sreturn : dtype;
  sfname : string;
  sargs : var list;
  slocals : svar_def list;
  sbody : sstmt list
}


(* program *)
type sprogram = {
  spfuns : sfun_def list;
  spvars : svar_def list;
  spstms : sstmt list;
}

