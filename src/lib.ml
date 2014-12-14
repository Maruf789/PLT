open Ast
open Sast

let lib_funs = [
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
  { sreturn=Void; sfname="rowname";
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
  { sreturn=IntMat; sfname="init_mat";
    sargs=[ {vtype=Int; vname="r"}; {vtype=Int; vname="c"}; {vtype=Int; vname="init"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="init_mat";
    sargs=[ {vtype=Int; vname="r"}; {vtype=Int; vname="c"}; {vtype=Double; vname="init"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="init_mat";
    sargs=[ {vtype=Int; vname="r"}; {vtype=Int; vname="c"}; {vtype=String; vname="init"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=String; sfname="string_of_int";
    sargs=[ {vtype=Int; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=String; sfname="string_of_double";
    sargs=[ {vtype=Double; vname="x"}; ];
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
  { sreturn=IntMat; sfname="mat_int_of_double";
    sargs=[ {vtype=DoubleMat; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="mat_double_of_int";
    sargs=[ {vtype=IntMat; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="mat_string_of_int";
    sargs=[ {vtype=IntMat; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="mat_string_of_double";
    sargs=[ {vtype=DoubleMat; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=Int; sfname="strlen";
    sargs=[ {vtype=String; vname="x"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=String; sfname="slice";
    sargs=[ {vtype=String; vname="x"}; {vtype=Int; vname="l"}; {vtype=Int; vname="r"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=IntMat; sfname="getrow";
    sargs=[ {vtype=IntMat; vname="mat"}; {vtype=Int; vname="r"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="getrow";
    sargs=[ {vtype=DoubleMat; vname="mat"}; {vtype=Int; vname="r"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="getrow";
    sargs=[ {vtype=StringMat; vname="mat"}; {vtype=Int; vname="r"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=IntMat; sfname="getcol";
    sargs=[ {vtype=IntMat; vname="mat"}; {vtype=Int; vname="c"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="getcol";
    sargs=[ {vtype=DoubleMat; vname="mat"}; {vtype=Int; vname="c"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="getcol";
    sargs=[ {vtype=StringMat; vname="mat"}; {vtype=Int; vname="c"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=IntMat; sfname="setrow";
    sargs=[ {vtype=IntMat; vname="mat"}; {vtype=Int; vname="r"}; {vtype=IntMat; vname="set"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="setrow";
    sargs=[ {vtype=DoubleMat; vname="mat"}; {vtype=Int; vname="r"}; {vtype=DoubleMat; vname="set"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="setrow";
    sargs=[ {vtype=StringMat; vname="mat"}; {vtype=Int; vname="r"}; {vtype=StringMat; vname="set"}; ];
    slocals=[]; sbody=[SEmpty]
  };
   { sreturn=IntMat; sfname="setcol";
    sargs=[ {vtype=IntMat; vname="mat"}; {vtype=Int; vname="c"}; {vtype=IntMat; vname="set"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=DoubleMat; sfname="setcol";
    sargs=[ {vtype=DoubleMat; vname="mat"}; {vtype=Int; vname="c"}; {vtype=DoubleMat; vname="set"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="setcol";
    sargs=[ {vtype=StringMat; vname="mat"}; {vtype=Int; vname="c"}; {vtype=StringMat; vname="set"}; ];
    slocals=[]; sbody=[SEmpty]
  };
  { sreturn=StringMat; sfname="init_mat";
    sargs=[ {vtype=StringMat; vname="mat"}; {vtype=Int; vname="c"}; {vtype=StringMat; vname="set"}; ];
    slocals=[]; sbody=[SEmpty]
  };
]
