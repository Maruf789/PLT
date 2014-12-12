(* Helper functions in translate *)
open Ast
open Sast
open Tast

(* Translate dtype to C++ types *)
let ipt t = match t with
    Int -> Iint
  | Double -> Idouble
  | String -> Istring
  | Bool -> Ibool
  | IntMat -> Iint_mat
  | DoubleMat -> Idouble_mat
  | StringMat -> Istring_mat
  | Void -> Ivoid

(* Translate mat type to C++ array type *)
let smat_to_array m = match m with
    IntMat -> Iint_array
  | DoubleMat -> Idouble_array
  | StringMat -> Istring_array
  | _ -> raise (Not_now "Mat should be IntMat, DoubleMat, StringMat")

(* Translate mat type to constructor name *)
let smat_to_cnsr m = match m with
    IntMat -> "int_mat"
  | DoubleMat -> "double_mat"
  | StringMat -> "string_mat"
  | _ -> raise (Not_now "Mat should be IntMat, DoubleMat, StringMat")

(* Int 0 and 1 *)
let int0 = IIntval 0
let int1 = IIntval 1
(* rows and columns of a mat @s *)
let rows s = ICall("rows", [IId s])
let cols s = ICall("cols", [IId s])

let trans_binop e1 e2 b = [], IBinop (e1, b, e2)

let trans_matsub s ie1 ie2 =
  let r = rows s in
  let c = cols s in
  match ie1, ie2 with
    IIntval x, IIntval y -> (
      let x_ = IBinop ((IIntval x), Minus, int1) in
      let y_ = IBinop ((IIntval y), Minus, int1) in
      match x, y with
        0, 0 -> raise (Not_now "Matsub index should be integer only")
      | _, 0 -> raise (Not_now "Matsub index should be integer only")
      | 0, _ -> raise (Not_now "Matsub index should be integer only")
      | _, _ -> IIndex (s, IBinop(IBinop(x_, Times, c), Plus, y_))
    )
  | _ -> raise (Not_now "Matsub index should be integer only")
