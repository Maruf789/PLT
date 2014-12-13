open Ast
open Sast

let lib_funs = [
  { sreturn=Int; sfname="rows";
    sargs=[ {vtype=IntMat; vname="mx"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Int; sfname="rows";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Int; sfname="rows";
    sargs=[ {vtype=StringMat; vname="mx"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Int; sfname="cols";
    sargs=[ {vtype=IntMat; vname="mx"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Int; sfname="cols";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Int; sfname="cols";
    sargs=[ {vtype=StringMat; vname="mx"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=IntMat; sfname="rowcat";
    sargs=[ {vtype=IntMat; vname="mx1"}; {vtype=IntMat; vname="mx2"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=DoubleMat; sfname="rowcat";
    sargs=[ {vtype=DoubleMat; vname="mx1"}; {vtype=DoubleMat; vname="mx2"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=StringMat; sfname="rowcat";
    sargs=[ {vtype=StringMat; vname="mx1"}; {vtype=StringMat; vname="mx2"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=IntMat; sfname="colcat";
    sargs=[ {vtype=IntMat; vname="mx1"}; {vtype=IntMat; vname="mx2"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=DoubleMat; sfname="colcat";
    sargs=[ {vtype=DoubleMat; vname="mx1"}; {vtype=DoubleMat; vname="mx2"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=StringMat; sfname="colcat";
    sargs=[ {vtype=StringMat; vname="mx1"}; {vtype=StringMat; vname="mx2"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="colunit";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=StringMat; vname="u"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="rowname";
    sargs=[ {vtype=IntMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="rowname";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="rowname";
    sargs=[ {vtype=StringMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="colname";
    sargs=[ {vtype=IntMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="colname";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="colname";
    sargs=[ {vtype=StringMat; vname="mx"}; {vtype=StringMat; vname="n"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="init_mat_col";
    sargs=[ {vtype=IntMat; vname="mx"}; {vtype=StringMat; vname="nc"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="init_mat_col";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=StringMat; vname="nc"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="init_mat_col";
    sargs=[ {vtype=StringMat; vname="mx"}; {vtype=StringMat; vname="nc"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="init_mat_size";
    sargs=[ {vtype=IntMat; vname="mx"}; {vtype=Int; vname="nrow"}; {vtype=Int; vname="ncol"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="init_mat_size";
    sargs=[ {vtype=DoubleMat; vname="mx"}; {vtype=Int; vname="nrow"}; {vtype=Int; vname="ncol"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Void; sfname="init_mat_size";
    sargs=[ {vtype=StringMat; vname="mx"}; {vtype=Int; vname="nrow"}; {vtype=Int; vname="ncol"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=String; sfname="string_of_int";
    sargs=[ {vtype=Int; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=String; sfname="string_of_double";
    sargs=[ {vtype=Double; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Int; sfname="int_of_string";
    sargs=[ {vtype=String; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Double; sfname="double_of_string";
    sargs=[ {vtype=String; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=IntMat; sfname="mat_int_of_string";
    sargs=[ {vtype=StringMat; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=DoubleMat; sfname="mat_double_of_string";
    sargs=[ {vtype=StringMat; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=IntMat; sfname="mat_int_of_double";
    sargs=[ {vtype=DoubleMat; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=DoubleMat; sfname="mat_double_of_int";
    sargs=[ {vtype=IntMat; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=StringMat; sfname="mat_string_of_int";
    sargs=[ {vtype=IntMat; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=StringMat; sfname="mat_string_of_double";
    sargs=[ {vtype=DoubleMat; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=Int; sfname="strlen";
    sargs=[ {vtype=String; vname="x"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=String; sfname="slice";
    sargs=[ {vtype=String; vname="x"}; {vtype=IntMat; vname="idx"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=DoubleMat; sfname="var_row";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[]
  };
  { sreturn=DoubleMat; sfname="var_col";
    sargs=[ {vtype=DoubleMat; vname="mx"}; ];
    slocals=[]; sbody=[]
  };
]
