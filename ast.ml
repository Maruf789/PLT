(* legal operations *)
type binop =  Plus | Minus | Times | Divide | Eq | Neq | Lt | Leq | Gt | Geq | And | Or

type unaop = Not | Neg

(* variable definition *)
type var = {
    vname : string;
    vtype : int;
  }

(* function definition *)
type func = {
    fname : string;
    args : var list;
    locals : var list;
    body : stmt list;
    return : int;
  }

(* containers for the occasion that several type can work *)
type matelem_container = Int | Double | String | Bool
type matsub_container = Int | Double | String | Mat
type return_container = Void | Int | Double

(* expression *)
type expr =
   Bool of bool
 | Int of int
 | Double of double
 | String of string
 | Mat of mat_literal
 | Id of string
 | MatSub of matsub_container
 | Binop of expr
 | Assign
 | Unaop of expr
 | ID LPAREN def_call_arg_list RPAREN { Call($1, $3) }

（* variable declaration or definition *）
type var_dec_def =
   VarNoInit of var
 | VarInit of var * expr



(* statement *)
type stmt =
   Expr of expr
 | Return of expr
 | If of (expr, stmt_list) * (expr, stmt_list) list * (expr, stmt_list)
 | CntFor of string * list list * stmt_list
 | CndFor of expr * stmt_list
 | Disp of expr
 | Continue
 | Break

(* an variable declaration or definition *)
type var_dec_def =
   VarNoInit of var
 | VarInit of var * expr

(* program is function definition plus variable definition and statements *)
type program = func_def list * var_def list * stmt list


(* Location update *)
open Lexing
let incr_lineno lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <- { pos with
    pos_lnum = pos.pos_lnum + 1;
    pos_bol = pos.pos_cnum;
  }


