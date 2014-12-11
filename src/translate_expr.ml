open Ast
open Sast
open Tast

let int0 = IIntval 0
let int1 = IIntval 1

let trans_matsub s ie1 ie2 =
  let r = ICall("rows", [IId s]) in
  let c = ICall("cols", [IId s]) in
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