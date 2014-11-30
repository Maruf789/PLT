open Ast
open Sast

let lib_funs = [
  { sreturn=IntMat; sfname="range";
    sargs=[ {vtype=Int; vname="x"}; {vtype=Int; vname="y"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=IntMat; sfname="ranger";
    sargs=[ {vtype=Int; vname="x"}; {vtype=Int; vname="y"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Int; sfname="rows";
    sargs=[ {vtype=IntMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Int; sfname="rows";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Int; sfname="rows";
    sargs=[ {vtype=StringMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Int; sfname="cols";
    sargs=[ {vtype=IntMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Int; sfname="cols";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Int; sfname="cols";
    sargs=[ {vtype=StringMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=IntMat; sfname="rowcat";
    sargs=[ {vtype=IntMat; vname="mx1"}; {vtype=IntMat; vname="mx2"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="rowcat";
    sargs=[ {vtype=DoubleMat; vname="mx1"}; {vtype=DoubleMat; vname="mx2"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="rowcat";
    sargs=[ {vtype=StringMat; vname="mx1"}; {vtype=StringMat; vname="mx2"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=IntMat; sfname="colcat";
    sargs=[ {vtype=IntMat; vname="mx1"}; {vtype=IntMat; vname="mx2"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="colcat";
    sargs=[ {vtype=DoubleMat; vname="mx1"}; {vtype=DoubleMat; vname="mx2"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="colcat";
    sargs=[ {vtype=StringMat; vname="mx1"}; {vtype=StringMat; vname="mx2"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="colunit";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=StringMat; vname="u"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="rowname";
    sargs=[ {vtype=IntMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="rowame";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="rowname";
    sargs=[ {vtype=StringMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="colname";
    sargs=[ {vtype=IntMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="colname";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="colname";
    sargs=[ {vtype=StringMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="init_mat_col";
    sargs=[ {vtype=IntMat; vname="mx"}; {vtype=StringMat; vname="nc"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="init_mat_col";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=StringMat; vname="nc"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="init_mat_col";
    sargs=[ {vtype=StringMat; vname="mx"}; {vtype=StringMat; vname="nc"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="init_mat_size";
    sargs=[ {vtype=IntMat; vname="mx"}; {vtype=Int; vname="nrow"}; {vtype=Int; vname="ncol"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="init_mat_size";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=Int; vname="nrow"}; {vtype=Int; vname="ncol"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Void; sfname="init_mat_size";
    sargs=[ {vtype=StringMat; vname="mx"}; {vtype=Int; vname="nrow"}; {vtype=Int; vname="ncol"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=IntMat; sfname="addrows";
    sargs=[ {vtype=IntMat; vname="mx"}; {vtype=IntMat; vname="dr"}; {vtype=StringMat; vname="drn"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="addrows";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=DoubleMat; vname="dr"}; {vtype=StringMat; vname="drn"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="addrows";
    sargs=[ {vtype=StringMat; vname="mx"}; {vtype=StringMat; vname="dr"}; {vtype=StringMat; vname="drn"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=String; sfname="string_of_int";
    sargs=[ {vtype=String; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=String; sfname="string_of_double";
    sargs=[ {vtype=String; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Int; sfname="int_of_string";
    sargs=[ {vtype=String; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Double; sfname="double_of_string";
    sargs=[ {vtype=String; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=IntMat; sfname="mat_int_of_string";
    sargs=[ {vtype=StringMat; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="mat_double_of_string";
    sargs=[ {vtype=StringMat; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="mat_double_of_double";
    sargs=[ {vtype=DoubleMat; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="mat_double_of_int";
    sargs=[ {vtype=IntMat; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=String; sfname="slice";
    sargs=[ {vtype=String; vname="x"}; {vtype=IntMat; vname="idx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Double; sfname="abs";
    sargs=[ {vtype=Double; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="sum_row";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="sum_col";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="avg_row";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="avg_col";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="var_row";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="var_col";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[SEmpty]
  };
]
