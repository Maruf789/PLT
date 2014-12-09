open Ast
open Sast

(* intermediate representation *)

(* IR expression *)
type irexpr =
    IId of string
  | IMatSub of string * irexpr * irexpr
  | IBoolval of bool
  | IIntval of int
  | IDoubleval of float
  | IStringval of string
  | IMatval of string * int * int (* arrayname, nrow, ncol *)
  | IBinop of irexpr * binop * irexpr
  | IAssign of irexpr * irexpr
  | IUnaop of unaop * irexpr
  | ICall of string * irexpr list

(* IR variable declare *)
type ivar_dec = dtype * string * irexpr (* type, name, init expr *)

(* IR statement *)
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

(* IR function declare/definite *)
type irfun = {
  ireturn : dtype;
  ifname : string;
  iargs : var list;
  ibody : irstmt list
}

(* IR program *)
type sprogram = {
  ivars : ivar_dec list;
  ifuns : irfun list
}