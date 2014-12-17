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


let gen_fname s = if s = "main" then "B_main" else s

(* translate expr.
   Note that translate an Matval may result in extra irstmt *)
(* @isl: irstmt list *)
(* return : irstmt list * irexpr *)
let rec trans_expr tid isl exp = match exp with
    _, SIntval x -> isl, (IIntval x)
  | _, SDoubleval x -> isl, (IDoubleval x)
  | _, SStringval x -> isl, (IStringval x)
  | _, SBoolval x -> isl, (IBoolval x)
  | _, SId x -> isl, (IId x)
  | _, SBinop (e1, b, e2) -> (let isl, ie1 = trans_expr tid isl e1 in
                              let isl, ie2 = trans_expr tid isl e2 in
                              let isl1, ret = trans_binop ie1 ie2 b in
                              (isl@isl1, ret))
  | _, SAssign (e1, e2) -> (let isl, ie1 = trans_expr tid isl e1 in
                            let isl, ie2 = trans_expr tid isl e2 in
                            (isl, (IAssign (ie1, ie2))))
  | _, SUnaop (u, e) -> let isl, ie = trans_expr tid isl e in
                        (isl, (IUnaop (u, ie)))
  | _, SCall (s, el) -> let s = gen_fname s in
                        let isl, iesl = trans_arglist tid isl el in
                        (isl, ICall (s, iesl))
  | _, SMatSub (s, e1, e2) -> let isl, ie1 = trans_expr tid isl e1 in
                              let isl, ie2 = trans_expr tid isl e2 in
                              (trans_matsub s isl ie1 ie2)
  | t, SMatval (ell, nr, nc) -> (
      let arr = trans_matval ell in
      let ta = smat_to_array t in
      let tname = sprintf "T_%d_%d" tid (List.length isl) in
      let ttname = sprintf "TT_%d_%d" tid (List.length isl) in
      let isl = isl@[IVarDec (ta, tname, arr)] in
      let ex = ICall ((smat_to_cnsr t), [IId tname; IIntval nr; IIntval nc]) in
      let isl = isl@[IVarDec ((ipt t), ttname, ex)] in
      (isl, (IId ttname)))
and trans_arglist tid isl el = match el with
    [] -> isl, []
  | e::tl -> (let isl, ie = trans_expr tid isl e in
              let isl, itl = trans_arglist tid isl tl in
              isl, ie::itl)
and trans_matval ell = (* matrix element should not generate extra irstmt *)
  let el = List.flatten ell in
  let irel = List.map (fun x -> snd (trans_expr 0 [] x)) el in
  (IArray irel)

(* translate variable definition list *)
(* return tid, statement list *)
let rec trans_vardecs tid vars = match vars with
    [] -> tid, []
  | (t, s, e)::tl -> let hd_x = (
    let it = ipt t in
    let isl, ie = trans_expr tid [] e in
    (isl@[IVarDec (it, s, ie)])
  ) in
    let tid, tl_x = trans_vardecs (tid + 1) tl in
    ((tid + 1), (hd_x@tl_x))

(*
  translate statement. 
  A temporary variable id (@tid) is for preventing naming conflict
  return : tid, statement list
*)
let rec trans_stmts tid stmts = (*print_int tid;*) match stmts with
    [] -> tid, []
  | hd::tl -> let tid, hd_stmts = 
    ( match hd with
      | SEmpty -> (tid, [IEmpty])
      | SExpr e -> let isl, ie = trans_expr tid [] e in (tid, isl@[IExpr ie])
      | SReturn e -> let isl, ie = trans_expr tid [] e in (tid, isl@[IReturn ie])
      | SIf (cs, csl, sl) ->
        let tid, isl1, stmts1 =
          let isl0, ie, is = trans_condstmt tid [] cs in
          ((tid+1), isl0, ([IIfHead ie] @ is))
        in
        let tid, (isl2, stmts2) = (tid+1), trans_condstmts tid csl in
        let tid, part3 =
          let tid, is3 = trans_stmts tid sl in
          ((tid+1), ([IElse] @ is3))
        in
        (tid, ((isl1 @ isl2) @ (stmts1 @ stmts2) @ part3 @ [IBlockEnd]))
      | SCntFor (s, e, ss) ->
        let iv = ("F_" ^ s) in
        let fs1 = IVarDec(Iint, iv, (IIntval 0)) in  
        let isl, temparr = (trans_expr tid [] e) in
        let tt = (sprintf "TT_%d" tid) in
        let tarrtype = ipt (fst e) in
        let tt_array = IVarDec(tarrtype, tt, temparr) in
        let fh = IForHead(fs1, (IBinop(IId iv, Lt, (IBinop((rows tt),Times,(cols tt))))), 
                          (IAssign(IId iv, IBinop(IId iv, Plus, int1))))
        in
        let mainbody =
          let lbody_h = IExpr (IAssign(IId s, IIndex(tt, IId iv))) in
          let _, lbody = trans_stmts (tid + 1) ss in
          (lbody_h :: lbody)
        in
        ((tid+1), ( isl @ [tt_array] @ [fh] @ mainbody @ [IBlockEnd] ))
      | SCndFor cs -> let isl0, ie, is = trans_condstmt tid [] cs in
        (tid+1, (isl0 @ [IWhileHead ie] @ is @ [IBlockEnd]))
      | SDisp e -> let isl, ie = trans_expr tid [] e in (tid+1, isl@[IDisp ie])
      | SContinue -> (tid, [IContinue])
      | SBreak -> (tid, [IBreak])
    ) in
    let tid, tl_stmts = trans_stmts (tid + 1) tl in
    (tid, hd_stmts@tl_stmts)
and trans_condstmt tid isl cs =
  let isl0, iec = trans_expr tid isl cs.scond in
  let _, iss = trans_stmts (tid + 1) cs.sstmts in
  (isl0, iec, iss)
and trans_condstmts tid condstmtlist = match condstmtlist with 
    [] -> [], []
  | hd::tl -> let isl1, stmts1 = 
    let isl2, ie2, is2 = trans_condstmt tid [] hd in
    (isl2, ([IElseIf ie2] @ is2))
    in
    let isls, stmtss = trans_condstmts (tid+1) tl in
    (isl1@isls, stmts1@stmtss)


(* translate main function - add return 0 if no statment of the last one is not return *)
let trans_main_func tid stmts =
  let _, main_stmts = trans_stmts tid stmts in
  match (List.rev main_stmts) with
    [] -> [IReturn (IIntval 0)]
  | hd::_ -> match hd with IReturn _ -> main_stmts
                          | _ -> main_stmts @ [IReturn int0]

(* translate function declaration/definition *)
let rec trans_args args = match args with
    [] -> []
  | a::tl -> {ivtype = (ipt a.vtype); ivname = a.vname} :: (trans_args tl)

let rec trans_fundefs fundefs = match fundefs with
    [] -> []
  | hd::tl -> (
      let _, ss_v = trans_vardecs 0 hd.slocals in
      let _, ss_s = trans_stmts 0 hd.sbody in
      let fname = gen_fname hd.sfname in
      { ireturn = (ipt hd.sreturn); ifname = fname;
        iargs = (trans_args hd.sargs); ibody = (ss_v@ss_s) }
    )::(trans_fundefs tl)


(* translate whole program *)
let translate need_main prg =
  let func_lines =
    let funs = prg.spfuns in
    trans_fundefs funs
  in
  let tid, var_lines =
    let vars = prg.spvars in
    trans_vardecs 0 vars
  in
  let stmt_lines =
    let stmts = prg.spstms in
    trans_main_func tid stmts
  in
  let main_func = {
    ireturn = Iint;
    ifname = "main";
    iargs = [];
    ibody = [Itry] @ var_lines @ stmt_lines @ [ICatch]
  } in
  match need_main with
    TOP -> { ivars = []; ifuns = func_lines @ [main_func] }
  | _ -> { ivars = []; ifuns = func_lines }

