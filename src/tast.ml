(* target language AST *)
open Ast

exception Not_now of string

(* target data type *)
type itype = Ivoid | Iint | Idouble | Istring | Ibool
           | Iint_array | Idouble_array | Istring_array
           | Iint_mat | Idouble_mat | Istring_mat

type ivar = {
  ivtype : itype;
  ivname : string
}

(* target expression *)
type iexpr =
    IId of string
  (*| IMatSub of string * iexpr * iexpr * iexpr * iexpr (* M(x, y, r, c) *)*)
  | IIntval of int
  | IDoubleval of float
  | IStringval of string
  | IBoolval of bool
  | IArray of iexpr list
  | IBinop of iexpr * binop * iexpr
  | IAssign of iexpr * iexpr
  | IUnaop of unaop * iexpr
  | ICall of string * iexpr list
  | IIndex of string * iexpr

(* target variable declare *)
type ivar_dec = itype * string * iexpr (* type, name, init expr *)

(* target statement *)
type irstmt =
    IEmpty
  | IVarDec of ivar_dec
  | IExpr of iexpr
  | IReturn of iexpr (* return e *)
  | IIfHead of iexpr (* if (e) { *)
  | IElseIf of iexpr (* } else if (e) { *)
  | IElse (* } else { *)
  | IForHead of irstmt * iexpr * iexpr (* for (s; s; e) { *)
  | IWhileHead of iexpr (* while (e) { *)
  | IBlockEnd (* } *)
  | IDisp of iexpr (* cout << e << endl *)
  | IContinue (* continue *)
  | IBreak (* break *)
  | ICheck of string * iexpr (* run-time checking *)

(* target function declare/definite *)
type irfun = {
  ireturn : itype;
  ifname : string;
  iargs : ivar list;
  ibody : irstmt list
}

(* target program *)
type sprogram = {
  ivars : ivar_dec list;
  ifuns : irfun list
}