(* Code Generation
   Input: TAST, 
   Output: target code string list *)

open Ast
open Tast
open Printf

(* exception Not_now of string *)

(* Translate dtype to C++ types *)
let tpt t = match t with
      Iint | Iint_array -> "int"
    | Idouble | Idouble_array -> "double"
    | Istring | Istring_array -> "string"
    | Ibool -> "bool"
    | Iint_mat -> "int_mat"
    | Idouble_mat -> "double_mat"
    | Istring_mat -> "string_mat"
    | Ivoid -> "void"

let gen_uop op = match op with Neg -> "-" | Not -> "!"

let gen_bop op = match op with
    Plus -> "+" | Minus -> "-" | Times -> "*" | Divide -> "/"
  | Eq -> "==" | Neq -> "!=" | Lt -> "<" | Leq -> "<="
  | Gt -> ">" | Geq -> ">=" | And -> "&&" | Or -> "||"

(* translate expr to string *)
(* @ttbl: (int*sexpr list list) list - temporary variable table *)
(* return: (int*sexpr) list * string - updated ttbl and target code *)
let rec gen_expr ttbl exp = match exp with
    IIntval x -> (sprintf " %d " x)
  | IDoubleval x -> (sprintf "%f" x)
  | IStringval x -> (" \"" ^ x ^ "\" ")
  | IBoolval x -> if x then " true " else " false "
  | IId x -> (" " ^ x ^ " ")
  | IBinop (e1, b, e2) -> (sprintf " ( %s %s %s ) " (gen_expr e1) (gen_bop b) (gen_expr e2))
  | IAssign (e1, e2) -> (sprintf "( %s = %s )" (gen_expr e1) (gen_expr e2))
  | IUnaop (u, e) -> (sprintf "( %s %s )" (gen_uop u) (gen_expr e))
  | ICall (s, el) -> (sprintf "( %s( %s ) )" s (gen_arg_list "," el))
  | IArray el-> raise (Not_now "Matsub not implemented")
and gen_arg_list ttbl sc el = match el with
    [] -> ""
  | [e] -> gen_expr ttbl e
  | e1::e2::tl ->  sprintf "%s %s %s" (gen_expr ttbl e1) sc (gen_arg_list sc (e2::tl))

(* translate variable definition list *)
let rec gen_vardecs vars = match vars with
    [] -> []
  | (t, s, e)::tl ->
    (sprintf "%s %s = %s;" (tpt t) s (gen_expr e)) :: (gen_vardecs tl)


let gen_disp es = ("cout << " ^ es ^ " << endl;")

(* translate statement list *)
let rec gen_stmts stmts = match stmts with
    [] -> []
  | hd::tl -> ( match hd with
        IEmpty -> [";"]
      | IExpr e -> [(gen_expr e) ^ " ;"]
      | IReturn e -> [sprintf "return %s ;" (gen_expr e)]
      | IIfHead e -> [](*(gen_condstmts "if" cs) @ (gen_elifs csl) @ (gen_stmts sl)*)
      | IElseIf e -> [](*(gen_condstmts "if" cs) @ (gen_elifs csl) @ (gen_stmts sl)*)
      | IElse e -> [](*(gen_condstmts "if" cs) @ (gen_elifs csl) @ (gen_stmts sl)*)
      | IForHead e -> [](*(gen_condstmts "if" cs) @ (gen_elifs csl) @ (gen_stmts sl)*)
      | IWhileHead e -> [](*(gen_condstmts "if" cs) @ (gen_elifs csl) @ (gen_stmts sl)*)
      | IDisp e -> (let es = gen_expr e in [gen_disp es])
      | IContinue -> ["continue;"]
      | IBreak -> ["break;"]
    ) @ (gen_stmts tl)


let rec gen_args sc args = match args with
    [] -> ""
  | [a] -> sprintf "%s %s" (tpt a.vtype) (a.vname)
  | a::b::tl -> (sprintf "%s %s%s " (tpt a.vtype) a.vname sc) ^ (gen_args sc (b::tl))
let rec gen_fundefs fundefs = match fundefs with
    [] -> []
  | hd::tl -> (if hd.ibody != [] then
               ([sprintf "%s %s(%s) {" (tpt hd.ireturn) hd.ifname (gen_args "," hd.sargs)]
               @(gen_stmts hd.ibody)@ "}")
               else ([sprintf "%s %s(%s) ;" (tpt hd.itype) hd.ifname (gen_args "," hd.sargs)])
              )@(gen_fundefs tl)


let compile prg =
  let head_lines =
    ["#include \"buckcal_types.h\""] 
  in
  let func_lines =
    let funs = prg.spfuns in
    gen_fundefs funs
  in
  let var_lines =
    let vars = prg.spvars in
    gen_vardecs vars
  in
  let stm_lines =       (* statements *)
    let stms = prg.spstms in
    gen_stmts stms
  in
  let all = head_lines @ func_lines
            @ ["int main() {"] @ var_lines @ stm_lines
            @["return 0;"; "}"] 
  in
  List.iter print_endline all