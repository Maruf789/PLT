(* Abstract Syntax Tree *)

(* operators *)
type binop =  Plus | Minus | Times | Divide 
           | Eq | Neq | Lt | Leq | Gt | Geq | And | Or

type unaop = Not | Neg

(* data type *)
type dtype = Void | Int | Double | String | Bool | IntMat | DoubleMat | StringMat

(* variable definition *)
type var = { vtype: dtype; vname: string }
(* type var = Vint of string | Vdouble of string 
         | Vstring of string | Vbool of string 
         | Vintmat of string | Vdoublemat of string | Vstringmat of string *)

(* containers for the occasion that several type can work *)
(* type matelem_container = Int | Double | String *)
(* type matsub_container = Int | Double | String | Mat *)
(* type return_container = Void | Int | Double *)


(* expression *)
type lvalue =
    Id of string
  | MatSub of string * expr * expr
and expr =
    Boolval of bool
  | Intval of int
  | Doubleval of float
  | Stringval of string
  | Matval of expr list list
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
  return : dtype;
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

(* A helper function: convert dtype to string *)
let pt t = match t with
    Int -> "Int"
  | Double -> "Double"
  | String -> "String"
  | Bool -> "Bool"
  | IntMat -> "IntMat"
  | DoubleMat -> "DoubleMat"
  | StringMat -> "StringMat"
  | Void -> "Void"

