open Ast
open Sast
open Tast


let trans_matsub s ie1 ie2 =
	match ie1, ie2 with
		IIntval x, IIntval y -> (
			let int0 = IIntval 0 in
			let int1 = IIntval 1 in
			let x_ = IBinop ((IIntval x), Minus, int1) in
			let y_ = IBinop ((IIntval y), Minus, int1) in
			let r = ICall("rows", [IId s]) in
			let c = ICall("cols", [IId s]) in
			match x, y with
				0, 0 -> IMatSub (s, int0, int0, r, c)
			| _, 0 -> IMatSub (s, x_, int0, int1, c)
			|	0, _ -> IMatSub (s, int0, y_, r, int1)
			|	_, _ -> IMatSub (s, x_, y_, int1, int1)
		)
	| _ -> raise (Not_now "Matsub index should be integer only")