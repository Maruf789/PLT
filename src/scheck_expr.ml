(* sub-routines called in shcek_expr in scheck.ml *)
open Ast
open Sast
open Printf


let check_uniop uop sexp =
  let ret = SUnaop(Not, sexp) in
  match uop with
    Not -> (match sexp with
        Bool, _ -> Bool, ret
      | _, _ -> raise (Bad_type "\"not\" bad operand type"))
  | Neg -> (match sexp with
        Int, _ -> Int, ret
      | Double, _ -> Double, ret
      | _, _ -> raise (Bad_type "unary negitive: bad operand type"))


let check_binop bop sexp1 sexp2 =
  let t1, _ = sexp1 in
  let t2, _ = sexp2 in
  let ret0 = SBinop(sexp1, bop, sexp2) in
  match bop with
    Plus -> (match t1, t2 with
      (* scalar arithmetic binary op *)
        Int, Int -> Int, ret0
      | Double, Double -> Double, ret0
      | Int, Double -> Double, ret0
      | Double, Int -> Double, ret0
      | String, String -> String, ret0
      (* matrix arithmetic binary op *)
      | IntMat, IntMat -> IntMat, ret0
      | DoubleMat, IntMat -> DoubleMat, ret0
      | IntMat, DoubleMat -> DoubleMat, ret0
      | DoubleMat, DoubleMat -> DoubleMat, ret0
      | StringMat, StringMat -> StringMat, ret0
      (* matrix-scalar arithmetic binary op *)
      | IntMat, Int -> IntMat, ret0
      | DoubleMat, Int -> DoubleMat, ret0
      | IntMat, Double -> DoubleMat, ret0
      | _, _ -> raise (Bad_type "\"+\" bad operand type"))
  | Minus -> (match t1, t2 with
      (* scalar arithmetic binary op *)
        Int, Int -> Int, ret0
      | Double, Double -> Double, ret0
      | Int, Double -> Double, ret0
      | Double, Int -> Double, ret0
      (* matrix arithmetic binary op *)
      | IntMat, IntMat -> IntMat, ret0
      | DoubleMat, IntMat -> DoubleMat, ret0
      | IntMat, DoubleMat -> DoubleMat, ret0
      | DoubleMat, DoubleMat -> DoubleMat, ret0
      (* matrix-scalar arithmetic binary op *)
      | IntMat, Int -> IntMat, ret0
      | DoubleMat, Int -> DoubleMat, ret0
      | IntMat, Double -> DoubleMat, ret0
      | _, _ -> raise (Bad_type "\"-\" bad operand type"))
  | Times -> (match t1, t2 with
      (* scalar arithmetic binary op *)
        Int, Int -> Int, ret0
      | Double, Double -> Double, ret0
      | Int, Double -> Double, ret0
      | Double, Int -> Double, ret0
      (* matrix arithmetic binary op *)
      | IntMat, IntMat -> IntMat, ret0
      | DoubleMat, IntMat -> DoubleMat, ret0
      | IntMat, DoubleMat -> DoubleMat, ret0
      | DoubleMat, DoubleMat -> DoubleMat, ret0
      (* matrix-scalar arithmetic binary op *)
      | IntMat, Int -> IntMat, ret0
      | DoubleMat, Int -> DoubleMat, ret0
      | IntMat, Double -> DoubleMat, ret0
      | _, _ -> raise (Bad_type "\"*\" bad operand type"))
  | Divide -> (match t1, t2 with
      (* scalar arithmetic binary op *)
        Int, Int -> Int, ret0
      | Double, Double -> Double, ret0
      | Int, Double -> Double, ret0
      | Double, Int -> Double, ret0
      (* matrix arithmetic binary op *)
      | IntMat, IntMat -> IntMat, ret0
      | DoubleMat, IntMat -> DoubleMat, ret0
      | IntMat, DoubleMat -> DoubleMat, ret0
      | DoubleMat, DoubleMat -> DoubleMat, ret0
      (* matrix-scalar arithmetic binary op *)
      | IntMat, Int -> IntMat, ret0
      | DoubleMat, Int -> DoubleMat, ret0
      | IntMat, Double -> DoubleMat, ret0
      | _, _ -> raise (Bad_type "\"/\" bad operand type"))
  | Eq -> (match t1, t2 with
        Int, Int -> Bool, ret0
      | Double, Double -> Bool, ret0
      | Int, Double -> Bool, ret0
      | Double, Int -> Bool, ret0
      | String, String -> Bool, ret0
      | _, _ -> raise (Bad_type "\"=\" bad operand type"))
  | Neq -> (match t1, t2 with
        Int, Int -> Bool, ret0
      | Double, Double -> Bool, ret0
      | Int, Double -> Bool, ret0
      | Double, Int -> Bool, ret0
      | String, String -> Bool, ret0
      | _, _ -> raise (Bad_type "\"!=\" bad operand type"))
  | Lt -> (match t1, t2 with
        Int, Int -> Bool, ret0
      | Double, Double -> Bool, ret0
      | Int, Double -> Bool, ret0
      | Double, Int -> Bool, ret0
      | String, String -> Bool, ret0
      | _, _ -> raise (Bad_type "\"<\" bad operand type"))
  | Leq -> (match t1, t2 with
        Int, Int -> Bool, ret0
      | Double, Double -> Bool, ret0
      | Int, Double -> Bool, ret0
      | Double, Int -> Bool, ret0
      | String, String -> Bool, ret0
      | _, _ -> raise (Bad_type "\"<=\" bad operand type"))
  | Gt -> (match t1, t2 with
        Int, Int -> Bool, ret0
      | Double, Double -> Bool, ret0
      | Int, Double -> Bool, ret0
      | Double, Int -> Bool, ret0
      | String, String -> Bool, ret0
      | _, _ -> raise (Bad_type "\">\" bad operand type"))
  | Geq -> (match t1, t2 with
        Int, Int -> Bool, ret0
      | Double, Double -> Bool, ret0
      | Int, Double -> Bool, ret0
      | Double, Int -> Bool, ret0
      | String, String -> Bool, ret0
      | _, _ -> raise (Bad_type "\">=\" bad operand type"))
  | And -> (match t1, t2 with
        Bool, Bool -> Bool, ret0
      | _, _ -> raise (Bad_type "\"and\" bad operand type"))
  | Or -> (match t1, t2 with
        Bool, Bool -> Bool, ret0
      | _, _ -> raise (Bad_type "\"or\" bad operand type"))


let check_matval_s sexp_list_list =
  let size_check tll =
    let ncol_list = List.map (List.length) tll in (* ncol of each row *)
    let num_col = (* get number of columns while checking *)
      let helpr a b = match a, b with
          (-1), y -> y
        | x, y -> (if x = y then y
                   else raise (Bad_type "Mat rows must have same length"))
      in List.fold_left helpr (-1) ncol_list in
    let num_row = List.length ncol_list in
    (num_row, num_col)
  in
  let type_check tll =
    (*let mat_elem_type = [Int; Double; String] in*)
    let helpr a b = match a, b with
        _, Void -> raise (Bad_type "Mat elements cannot be void")
      | Void, y -> y
      | Int, Int -> Int
      | Int, Double -> Double
      | Double, Double -> Double
      | Double, Int -> Double
      | String, String -> String
      | x, y -> raise (Bad_type (sprintf "Mat elements must have same type (%s, %s)" (pt x) (pt y)))
    in
    List.fold_left helpr Void (List.flatten tll)
  in
  let typ_ll = List.map (List.map fst) sexp_list_list in
  (* FIXME: Maybe we should also return size of the matrix? *)
  let ncol, nrow = size_check typ_ll in
  let rt = (match (type_check typ_ll) with
        Int -> IntMat
      | Double -> DoubleMat
      | String -> StringMat
      | _ -> raise (Bad_type "Mat can only contain int, double or string")
    ) in
  rt, (SMatval (sexp_list_list, ncol, nrow))


let check_assign sexp1 sexp2 =
  let t1, _ = sexp1 in
  let t2, _ = sexp2 in
  let ret0 = SAssign(sexp1, sexp2) in
  match t1, t2 with
  (* scalar assignment *)
    Int, Int -> Int, ret0
  | Double, Int -> Double, ret0
  | Double, Double -> Double, ret0
  | Int, Double -> Double, ret0
  | String, String -> String, ret0
  | Bool, Bool -> Bool, ret0
  (* matrix assignment *)
  | IntMat, IntMat -> IntMat, ret0
  | IntMat, DoubleMat -> IntMat, ret0
  | DoubleMat, DoubleMat -> DoubleMat, ret0
  | DoubleMat, IntMat -> DoubleMat, ret0
  | StringMat, StringMat -> StringMat, ret0
  (* 1-by-1 mat assigned <-> scalar *)
  | Int, IntMat -> Int, ret0 
  | Double, IntMat -> Double, ret0
  | Int, DoubleMat -> Int, ret0
  | Double, DoubleMat -> Double, ret0
  | String, StringMat -> String, ret0
  | IntMat, Int -> Int, ret0
  | IntMat, Double -> Double, ret0
  | DoubleMat, Int -> Int, ret0
  | DoubleMat, Double -> Double, ret0
  | StringMat, String -> String, ret0
  | x, y -> raise (Bad_type (sprintf "%s : %s operand types invalid" (pt x) (pt y)))
