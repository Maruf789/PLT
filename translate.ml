open Ast

let rec compile prg =
  let funs = prg.pfuns in (* function table *)
  let vars = prg.pvars in (* variable table *)
  let stms = prg.pstms in (* statement list *)
  print_endline "Good"
