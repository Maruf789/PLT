(*
  Translate SAST to TAST
  Input: SAST
  Output: TAST
*)

open Ast
open Sast
open Tast
open Translate_expr
open Printf


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
let smat_to_array m = match m with
    IntMat -> Iint_array
  | DoubleMat -> Idouble_array
  | StringMat -> Istring_array
  | _ -> raise (Not_now "Mat should be IntMat, DoubleMat, StringMat")

let smat_to_cnsr m = match m with
    IntMat -> "int_mat"
  | DoubleMat -> "double_mat"
  | StringMat -> "string_mat"
  | _ -> raise (Not_now "Mat should be IntMat, DoubleMat, StringMat")

(* @isl: irstmt list *)
(* return : irstmt list * irexpr *)
let rec trans_expr isl exp = match exp with
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
  | _, SMatSub (s, e1, e2) -> (let isl, ie1 = trans_expr isl e1 in
                               let isl, ie2 = trans_expr isl e2 in
                               (isl, (trans_matsub s ie1 ie2)))
  | t, SMatval (ell, nr, nc) -> (
      let arr = trans_matval ell in
      let ta = smat_to_array t in
      let tname = sprintf "T_%d" (List.length isl) in
      let isl = isl@[IVarDec (ta, tname, arr)] in
      let ex = ICall ((smat_to_cnsr t), [IId tname; IIntval nr; IIntval nc]) in
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


let rec trans_stmts tid stmts = match stmts with
    [] -> []
  | hd::tl -> ( match hd with
      | SEmpty -> [IEmpty]
      | SExpr e -> let isl, ie = trans_expr [] e in isl@[IExpr ie]
      | SReturn e -> let isl, ie = trans_expr [] e in isl@[IReturn ie]
      | SIf (cs, csl, sl) ->
        let isl1, stmts1 =
          let isl0, ie, is = trans_condstmt tid [] cs in
          (isl0, ([IIfHead ie] @ is))
          in
          let isl2, stmts2 = trans_condstmts tid csl 
          in
          let part3 =
          (let is3 = trans_stmts tid sl in
              ([IElse] @ is3))
          in
        ((isl1 @ isl2) @ (stmts1 @ stmts2) @ part3 @ [IBlockEnd])
      | SCntFor (s, e, ss) -> let iv = ("F_" ^ s) in
        let fs1 = IVarDec(Iint, iv, (IIntval 0)) in
        let fh = IForHead(fs1, IBinop(IId iv, Lt, IIntval 1), IAssign(IId iv, IBinop(IId iv, Plus, IIntval 1))) in
        let lbody = trans_stmts (tid + 1) ss in
        ( [fh] @ lbody @ [IBlockEnd] )
      | SCndFor cs -> let isl0, ie, is = trans_condstmt tid [] cs in
        (isl0 @ [IWhileHead ie] @ is @ [IBlockEnd])
      | SDisp e -> let isl, ie = trans_expr [] e in isl@[IDisp ie]
      | SContinue -> [IContinue]
      | SBreak -> [IBreak]
    ) @ (trans_stmts (tid + 1) tl)
and trans_condstmt tid isl cs =
  let isl0, iec = trans_expr isl cs.scond in
  let ies = trans_stmts (tid + 1) cs.sstmts in
  (isl0, iec, ies)
and trans_condstmts tid condstmtlist = match condstmtlist with 
    [] -> [] , []
    | hd::tl -> let isl1, stmts1 = 
                let isl2, ie2, is2 = trans_condstmt tid [] hd in
                (isl2, ([IElseIf ie2] @ is2))
                in
                let isls, stmtss = trans_condstmts tid tl in
                (isl1@isls, stmts1@stmtss)
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
