(* 
  Translate SAST to TAST
  Input: SAST
  Output: TAST
*)

open Ast
open Sast
open Tast
open Printf

exception Not_now of string

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

(* translate expr. 
   Note that translate an Matval may result in extra irstmt *)
(* @isl: irstmt list *)
(* return : irstmt list * irexpr *)
let rec trans_expr isl exp =
  let smat_to_array m = match m with
    IntMat -> Iint_array
  | DoubleMat -> Idouble_array
  | StringMat -> Istring_array
  | _ -> raise (Not_now "Mat should be IntMat, DoubleMat, StringMat")
  in
  let smat_to_cnsr m = match m with
    IntMat -> "int_mat"
  | DoubleMat -> "double_mat"
  | StringMat -> "string_mat"
  | _ -> raise (Not_now "Mat should be IntMat, DoubleMat, StringMat")
  in
  match exp with
    _, SIntval x -> isl, (IIntval x)
  | _, SDoubleval x -> isl, (IDoubleval x)
  | _, SStringval x -> isl, (IStringval x)
  | _, SBoolval x -> isl, (IBoolval x)
  | _, SId x -> isl, (IId x)
  | _, SBinop (e1, b, e2) -> (let isl, ie1 = trans_expr isl e1 in
                              let isl, ie2 = trans_expr isl e2 in
                              (isl, (IBinop (ie1, b,ie2))))
  | _, SAssign (e1, e2) -> (let isl, ie1 = trans_expr isl e1 in
                            let isl, ie2 = trans_expr isl e2 in
                            (isl, (IAssign (ie1, ie2))))
  | _, SUnaop (u, e) -> (let isl, ie = trans_expr isl e in
                         (isl, (IUnaop (u, ie))))
  | _, SCall (s, el) -> (let is1, iesl = trans_arglist isl el in
                         (isl, ICall (s, iesl)))
  | _, SMatSub (s, e1, e2) -> raise (Not_now "Matsub not implemented")
  | t, SMatval (ell, nr, nc) -> (let arr = trans_matval ell in
                                 let ta = smat_to_array t in
                                 let tname = sprintf "T_%d" (List.length isl) in
                                 let isl = isl@[IVarDec (ta, tname, arr)] in
                                 let ex = ICall ((smat_to_cnsr t), [IStringval tname; IIntval nr; IIntval nc]) in
                                 isl, ex)
and trans_arglist is1 el = match el with
    [] -> is1, []
  | e::tl -> (let isl, ie = trans_expr is1 e in
              let isl, itl = trans_arglist isl tl in
              isl, ie::itl)
and trans_matval ell = (* matrix element should not generate extra irstmt *)
  let el = List.flatten ell in
  let irel = List.map (fun x -> snd (trans_expr [] x)) el in
  (IArray irel)

(* translate variable definition list *)
let rec trans_vardecs vars = match vars with
    [] -> []
  | (t, s, e)::tl -> (
      let it = ipt t in
      let isl, ie = trans_expr [] e in
      (isl@[IVarDec (it, s, ie)])
    ) @ (trans_vardecs tl)


(*
        SEmpty -> [IEmpty]
      | SExpr e -> let isl, ie = trans_expr [] e in isl@[IExpr ie] translate statement list *)
let rec trans_stmts tid stmts = match stmts with
    [] -> []
  | hd::tl -> ( match hd with
      | SReturn e -> let isl, ie = trans_expr [] e in isl@[IReturn ie]
      | SIf (cs, csl, sl) ->let part1 = let isl0, ie, is = trans_condstmt tid [] cs in
                                        (isl0 @ [IIfHead ie] @ is)
                                      in
                            let rec helper condstmtlist = match condstmtlist with 
                                                      [] -> []
                                                      | hd::tl -> ((let isl2, ie2, is2 = trans_condstmt tid [] hd in
                                                        (isl2 @ [IElseIf ie2] @ is2)) @ (helper tl))
                                      in
                            let part2 = helper csl
                                      in
                            let part3 = (let is3 = trans_stmts tid sl in
                                        (is3 @ [IElse] @ is3))
                                      in
                            (part1 @ part2 @ part3 @ [IBlockEnd])
      | SCntFor (s, e, ss) -> (*let iterv = ("F_" ^ s) in
                              let *) raise (Not_now "CntFor not implemented")
      | SCndFor cs -> let isl0, ie, is = trans_condstmt tid [] cs in
                      (isl0 @ [IWhileHead ie] @ is)
      | SDisp e -> let isl, ie = trans_expr [] e in isl@[IReturn ie]
      | SContinue -> [IContinue]
      | SBreak -> [IBreak]
    ) @ (trans_stmts (tid + 1) tl)
and trans_condstmt tid isl cs =
  let isl0, iec = trans_expr isl cs.scond in
  let ies = trans_stmts (tid + 1) cs.sstmts in
  (isl0, iec, ies)


(* translate function declaration/definition *)
let rec trans_args args = match args with
    [] -> []
  | a::tl -> {ivtype = (ipt a.vtype); ivname = a.vname} :: (trans_args tl)

let rec trans_fundefs fundefs = match fundefs with
    [] -> []
  | hd::tl -> (
      let ss_v = trans_vardecs hd.slocals in
      let ss_s = trans_stmts 0 hd.sbody in
      { ireturn = (ipt hd.sreturn); ifname = hd.sfname;
        iargs = (trans_args hd.sargs); ibody = (ss_v@ss_s) }
    )::(trans_fundefs tl)

(* translate whole program *)
let translate prg =
  let func_lines =
    let funs = prg.spfuns in
    trans_fundefs funs
  in
  let var_lines =
    let vars = prg.spvars in
    trans_vardecs vars
  in
  let stmt_lines =
    let stmts = prg.spstms in
    trans_stmts 0 stmts
  in
  let main_func = {
    ireturn = Iint;
    ifname = "main";
    iargs = [];
    ibody = var_lines @ stmt_lines
  } in
  { ivars = []; ifuns = func_lines @ [main_func] }
