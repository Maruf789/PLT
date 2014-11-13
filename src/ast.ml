(* variable definition *)
type var = {
    vname : string;
    vtype : int;
  }

(* containers for the occasion that several type can work *)
(* type matelem_container = Int | Double | String *)
(* type matsub_container = Int | Double | String | Mat *)
(* type return_container = Void | Int | Double *)

(* operatiors *)
type binop =  Plus | Minus | Times | Divide 
            | Eq | Neq | Lt | Leq | Gt | Geq | And | Or
type unaop = Not | Neg

(* expression *)
type lvalue =
   Id of string
 | MatSub of string * expr * expr
and expr =
   Bool of bool
 | Int of int
 | Double of float
 | String of string
 | Mat of expr list list
 | Lvalue of lvalue
 | Binop of expr * binop * expr
 | Assign of lvalue * expr
 | Unaop of unaop * expr
 | Call of string * expr list

(* variable declaration *)
type var_dec =
   VarNoInit of var
 | VarInit of var * expr

(* statement *)
type cond_stmts = {
    cond : expr ;
    stmts : stmt list;
}
and stmt =
   Expr of expr
 | Empty
 | Return of expr
 | If of cond_stmts * cond_stmts list * stmt list
 | CntFor of string * expr * stmt list
 | CndFor of cond_stmts
 | Disp of expr
 | Continue
 | Break

(* function definition *)
type func_def = {
    return : int;
    fname : string;
    args : var list;
    locals : var_dec list;
    body : stmt list;
  }

(* program is function definition plus variable definition and statements *)
type program = {
    pfuns : func_def list;
    pvars : var_dec list;
    pstms : stmt list;
  }

(* Location update *)
open Lexing
let incr_lineno lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <- { pos with
    pos_lnum = pos.pos_lnum + 1;
    pos_bol = pos.pos_cnum;
  }
