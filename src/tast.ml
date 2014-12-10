(* target language AST *)
open Ast

(* target data type *)
type itype = Ivoid | Iint | Idouble | Istring | Ibool
           | Iint_array | Idouble_array | Istring_array
           | Iint_mat | Idouble_mat | Istring_mat

type ivar = {
  ivtype : itype;
  ivname : string
}

(* target expression *)
type irexpr =
    IId of string
  | IMatSub of string * irexpr * irexpr
  | IIntval of int
  | IDoubleval of float
  | IStringval of string
  | IBoolval of bool
  | IArray of irexpr list
  | IBinop of irexpr * binop * irexpr
  | IAssign of irexpr * irexpr
  | IUnaop of unaop * irexpr
  | ICall of string * irexpr list

(* target variable declare *)
type ivar_dec = itype * string * irexpr (* type, name, init expr *)

(* target statement *)
type irstmt =
    IEmpty
  | IVarDec of ivar_dec
  | IExpr of irexpr
  | IReturn of irexpr (* return e *)
  | IIfHead of irexpr (* if (e) { *)
  | IElseIf of irexpr (* } else if (e) { *)
  | IElse (* } else { *)
  | IBlockEnd (* } *)
  | IForHead of irstmt * irexpr * irexpr (* for (s; s; e) { *)
  | IWhileHead of irexpr (* while (e) { *)
  | IDisp of irexpr (* cout << e << endl *)
  | IContinue (* continue *)
  | IBreak (* break *)

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