(* Semantic checked Abstract Syntax Tree - Safe Abstract Syntax Tree *)
open Op

(* data type *)
type t = Void | Int | Double | String | Bool | IntMat | DoubleMat | StringMat

(* variable *)
type svar = { svtype: t; svname: string }

(* expression with type *)
type expr_val =
    SId of string
  | SMatSub of string * sexpression * sexpression
  | SBoolval of bool
  | SIntval of int
  | SDoubleval of float
  | SStringval of string
  | SMatval of sexpression list list
  | SBinop of sexpression * binop * sexpression
  | SAssign of sexpression * sexpression
  | SUnaop of unaop * sexpression
  | SCall of string * sexpression list
and sexpression = t * expr_val

(* variable definition *)
type svar_def = t * string * sexpression (* type, name, init expr *)

(* statement *)
type scond_stmts = {
  cond : sexpression;
  stmts : sstmt list
}
and sstmt =
    SEmpty
  | SExpr of sexpression
  | SReturn of sexpression
  | SIf of scond_stmts * scond_stmts list * sstmt list
  | SCntFor of string * sexpression * sstmt list
  | SCndFor of scond_stmts
  | SDisp of sexpression
  | SContinue
  | SBreak

(* function signature *)
type funsg = {
  fsname : string;
  fsargs : t list
}

(* function definition *)
type sfun_def = {
  sreturn : t;
  sfname : string;
  sargs : svar list;
  slocals : svar_def list;
  sbody : sstmt list
}


(* program *)
type sprogram = {
  spfuns : sfun_def list;
  spvars : svar_def list;
  spstms : sstmt list;
}

