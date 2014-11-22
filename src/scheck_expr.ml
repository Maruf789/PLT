(* sub-routines called in shcek_expr in scheck.ml *)
open Ast
open Sast

let check_uniop uop sexp = match uop with
    Not -> (match sexp with
               Bool, exp -> Bool, SUnaop(Neg, exp)
             | _, _ -> raise (Bad_type "Not implemented"))
  | Neg -> (match sexp with
               Int, exp -> Int, SUnaop(Neg, exp)
             | Double, exp -> Double, SUnaop(Neg, exp)
             | _, _ -> raise (Bad_type "Not implemented"))


let check_binop bop sexp1 sexp2 =
  let t1, _ = sexp1 in
  let t2, _ = sexp2 in
  let ret0 = SBinop(sexp1, bop, sexp2) in
    match bop with
        Plus -> (match t1, t2 with
                    Int, Int -> Int, ret0
                  | Double, Double -> Double, ret0
                  | Int, Double -> Double, ret0
                  | Double, Int -> Double, ret0
                  | String, String -> String, ret0
                  | _, _ -> raise (Bad_type "Not implemented"))
      | Minus -> (match t1, t2 with
                     Int, Int -> Int, ret0
                   | Double, Double -> Double, ret0
                   | Int, Double -> Double, ret0
                   | Double, Int -> Double, ret0
                   | _, _ -> raise (Bad_type "Not implemented"))
      | Times -> (match t1, t2 with
                     Int, Int -> Int, ret0
                   | Double, Double -> Double, ret0
                   | Int, Double -> Double, ret0
                   | Double, Int -> Double, ret0
                   | _, _ -> raise (Bad_type "Not implemented"))
      | Divide -> (match t1, t2 with
                      Int, Int -> Int, ret0
                    | Double, Double -> Double, ret0
                    | Int, Double -> Double, ret0
                    | Double, Int -> Double, ret0
                    | _, _ -> raise (Bad_type "Not implemented"))
      | Eq -> (match t1, t2 with
                  Int, Int -> Bool, ret0
                | Double, Double -> Bool, ret0
                | Int, Double -> Bool, ret0
                | Double, Int -> Bool, ret0
                | String, String -> Bool, ret0
                | _, _ -> raise (Bad_type "= : bad operand type"))
      | Neq -> (match t1, t2 with
                   Int, Int -> Bool, ret0
                 | Double, Double -> Bool, ret0
                 | Int, Double -> Bool, ret0
                 | Double, Int -> Bool, ret0
                 | String, String -> Bool, ret0
                 | _, _ -> raise (Bad_type "!= : bad operand type"))
      | Lt -> (match t1, t2 with
                  Int, Int -> Bool, ret0
                | Double, Double -> Bool, ret0
                | Int, Double -> Bool, ret0
                | Double, Int -> Bool, ret0
                | String, String -> Bool, ret0
                | _, _ -> raise (Bad_type "< : bad operand type"))
      | Leq -> (match t1, t2 with
                   Int, Int -> Bool, ret0
                 | Double, Double -> Bool, ret0
                 | Int, Double -> Bool, ret0
                 | Double, Int -> Bool, ret0
                 | String, String -> Bool, ret0
                 | _, _ -> raise (Bad_type "<= : bad operand type"))
      | Gt -> (match t1, t2 with
                  Int, Int -> Bool, ret0
                | Double, Double -> Bool, ret0
                | Int, Double -> Bool, ret0
                | Double, Int -> Bool, ret0
                | String, String -> Bool, ret0
                | _, _ -> raise (Bad_type "> : bad operand type"))
      | Geq -> (match t1, t2 with
                   Int, Int -> Bool, ret0
                 | Double, Double -> Bool, ret0
                 | Int, Double -> Bool, ret0
                 | Double, Int -> Bool, ret0
                 | String, String -> Bool, ret0
                 | _, _ -> raise (Bad_type ">= : bad operand type"))
      | And -> (match t1, t2 with
                   Bool, Bool -> Bool, ret0
                 | _, _ -> raise (Bad_type "AND : bad operand type"))
      | Or -> (match t1, t2 with
                  Bool, Bool -> Bool, ret0
                | _, _ -> raise (Bad_type "OR : bad operand type"))


let check_matval_s sexp_list_list =
  let size_check tll =
    let helpr a b = match a, b with
      -1, y -> y
      | x, y -> (if x = y then y
                 else raise (Bad_type "Mat: rows must have same length"))
    in
      List.fold_left helpr (-1) (List.map (List.length) tll)
  in
  let type_check tll =
    (*let mat_elem_type = [Int; Double; String] in*)
    let helpr a b = match a, b with
        _, Void -> raise (Bad_type "Mat: elements cannot be void")
      | Void, y -> y
      | Int, Int -> Int
      | Int, Double -> Double
      | Double, Int -> Double
      | String, String -> String
      | _, _ -> raise (Bad_type "Mat: elements must have same type")
    in
      List.fold_left helpr Void (List.flatten tll)
  in
  let typ_ll = List.map (List.map fst) sexp_list_list in
  let _ = size_check typ_ll in
  let rt = (match (type_check typ_ll) with
               Int -> IntMat
             | Double -> DoubleMat
             | String -> StringMat) in
    rt, (SMatval sexp_list_list)


let check_assign sexp1 sexp2 = 
  let t1, ev1 = sexp1 in
  let t2, ev2 = sexp2 in
    match t1, t2 with
        Int, Int -> Int, SAssign(ev1, ev2)
      | Double, Int -> Double, SAssign(ev1, ev2)
      | Int, Double -> Double, SAssign(ev1, ev2)
      | String, String -> String, SAssign(ev1, ev2)
      | Bool, Bool -> Bool, SAssign(ev1, ev2)
      | _, _ -> raise (Bad_type "Not implemented")

