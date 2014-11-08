open Ast

let _ = 
  let lexbuf = Lexing.from_channel stdin in
  let expr = Parser.program Scanner.token lexbuf in
  ignore expr; print_endline "Good!"

