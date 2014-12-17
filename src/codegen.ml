(* Code Generation
   Input: TAST, 
   Output: target code string list *)

open Ast
open Tast
open Printf

exception Not_done of string

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

let gen_uop op = match op with Neg -> "-"
                             | Not -> "!"

let gen_bop op = match op with
    Plus -> "+" | Minus -> "-" | Times -> "*" | Divide -> "/"
  | Eq -> "==" | Neq -> "!=" | Lt -> "<" | Leq -> "<="
  | Gt -> ">" | Geq -> ">=" | And -> "&&" | Or -> "||"

(* translate expr to string *)
(* @ttbl: (int*sexpr list list) list - temporary variable table *)
(* return: (int*sexpr) list * string - updated ttbl and target code *)
let rec gen_expr exp = match exp with
    IIntval x -> (sprintf " %d " x)
  | IDoubleval x -> (sprintf "%f" x)
  | IStringval x -> (" string(\"" ^ x ^ "\") ")
  | IBoolval x -> if x then " true " else " false "
  | IId x -> (" " ^ x ^ " ")
  | IBinop (e1, b, e2) -> (sprintf "( %s %s %s )" (gen_expr e1) (gen_bop b) (gen_expr e2))
  | IAssign (e1, e2) -> (sprintf "( %s = %s )" (gen_expr e1) (gen_expr e2))
  | IUnaop (u, e) -> (sprintf "( %s %s )" (gen_uop u) (gen_expr e))
  | ICall (s, el) -> (sprintf "( %s(%s) )" s (gen_arg_list "," el))
  | IArray el->  (sprintf "{%s}" (gen_arg_list "," el) )
  | IIndex (s, e) -> (sprintf " (%s[%s]) " s (gen_expr e))
and gen_arg_list sc el = match el with
    [] -> ""
  | [e] -> gen_expr e
  | e1::e2::tl ->  sprintf "%s %s %s" (gen_expr e1) sc (gen_arg_list sc (e2::tl))

(* translate variable definition list *)
let rec gen_vardecs vars = match vars with
    [] -> []
  | v::tl -> (gen_vardec v) :: (gen_vardecs tl)
and gen_vardec var =
  let t, s, e = var in match t with
    Iint_array | Idouble_array | Istring_array ->
    sprintf "%s %s[] = %s;" (tpt t) s (gen_expr e)
  | t -> sprintf "%s %s = %s;" (tpt t) s (gen_expr e)

let gen_disp es = ("cout << " ^ es ^ " << endl;")

(* translate statement list *)
let rec gen_stmt stmt = match stmt with
    IEmpty -> ";"
  | IVarDec (vt, vn, ve) -> (gen_vardec (vt, vn, ve))
  | IExpr e -> ((gen_expr e) ^ " ;")
  | IReturn e -> (sprintf "return %s ;" (gen_expr e))
  | IIfHead e -> (sprintf "if (%s) {"  (gen_expr e))
  | IElseIf e -> (sprintf "} else if (%s) {"  (gen_expr e))
  | IElse -> (sprintf "} else {")
  | IForHead (e1, e2, e3) -> (sprintf "for (%s %s; %s) {" (gen_stmt e1) (gen_expr e2) (gen_expr e3))
  | IWhileHead e -> (sprintf "while (%s) {"  (gen_expr e))
  | IBlockEnd -> "}"
  | IDisp e -> (sprintf "cout << %s << endl;" (gen_expr e))
  | IContinue -> "continue;"
  | IBreak -> "break;"
  | ICheck (s, e) -> (sprintf "if (!(%s)) throw invalid_argument(\"%s\");" (gen_expr e) s)
  | Itry -> "try {"
  | ICatch -> "} catch (exception & e) { cerr << e.what() << endl; }"
and gen_stmts stmts = match stmts with
    [] -> []
  | hd::tl -> (gen_stmt hd) :: (gen_stmts tl)

let rec gen_args sc args = match args with
    [] -> ""
  | [a] -> sprintf "%s %s" (tpt a.ivtype) (a.ivname)
  | a::b::tl -> (sprintf "%s %s%s " (tpt a.ivtype) a.ivname sc) ^ (gen_args sc (b::tl))
let rec gen_fundefs fundefs = match fundefs with
    [] -> []
  | hd::tl -> (if hd.ibody != [] then
                 ([sprintf "%s %s(%s) {" (tpt hd.ireturn) hd.ifname (gen_args "," hd.iargs)]
                  @(gen_stmts hd.ibody)@ ["}"])
               else ([sprintf "extern %s %s(%s);" (tpt hd.ireturn) hd.ifname (gen_args "," hd.iargs)])
              )@(gen_fundefs tl)


let compile oc prg =
  let head_lines =
    ["#include \"buckcal_mat.hpp\""; "using namespace std;"]
  in
  let var_lines =
    let vars = prg.ivars in
    gen_vardecs vars
  in
  let func_lines =
    let funs = prg.ifuns in
    gen_fundefs funs
  in
  let all = head_lines @ var_lines @ func_lines in
  (*List.iter print_endline all*)
  List.iter (fun line -> fprintf oc "%s\n" line) all
