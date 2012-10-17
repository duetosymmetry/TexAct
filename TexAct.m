xAct`TexAct`$Version={"0.3.0",{2012,5,5}};
xAct`TexAct`$xTensorVersionExpected={"1.0.4",{2012,5,5}};


(* TexAct, Tex code to format xAct expressions *)

(* Copyright (C) 2008-2012 Thomas B\[ADoubleDot]ckdahl, Jose M. Martin-Garcia and Barry Wardell *)

(* This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published
 by the Free Software Foundation; either version 2 of the License,
  or (at your option) any later version.

This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 General Public License for more details.

You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307,
  USA. 
*)


(* :Title: TexAct *)

(* :Author: Thomas B\[ADoubleDot]ckdahl, Jose M. Martin-Garcia and Barry Wardell *)

(* :Summary: Tex code to formar xAct expressions *)

(* :Brief Discussion:
*)
  
(* :Context: xAct`Texsor` *)

(* :Package Version: 0.3.0 *)

(* :Copyright: Thomas B\[ADoubleDot]ckdahl, Jose M. Martin-Garcia and Barry Wardell (2008-2012) *)

(* :History: see TexAct.History file *)

(* :Keywords: *)

(* :Source: Texsor.nb *)

(* :Warning: *)

(* :Mathematica Version: 5.1 and later *)

(* :Limitations: *)


If[Unevaluated[xAct`xCore`Private`$LastPackage]===xAct`xCore`Private`$LastPackage,xAct`xCore`Private`$LastPackage="xAct`TexAct`"];


BeginPackage["xAct`TexAct`",{"xAct`xCore`","xAct`xPerm`","xAct`xTensor`"}]


If[Not@OrderedQ@Map[Last,{$xTensorVersionExpected,xAct`xTensor`$Version}],Throw@Message[General::versions,"xTensor",xAct`xTensor`$Version,$xTensorVersionExpected]]


Print[xAct`xCore`Private`bars];
Print["Package xAct`TexAct`  version ",$Version[[1]],", ",$Version[[2]]];
Print["CopyRight (C) 2008-2012, Thomas B\[ADoubleDot]ckdahl, Jose M. Martin-Garcia and Barry Wardell, under the General Public License."]


Off[General::shdw]
xAct`TexAct`Disclaimer[]:=Print["These are points 11 and 12 of the General Public License:\n\nBECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM `AS IS\.b4 WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.\n\nIN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES."]
On[General::shdw]


If[xAct`xCore`Private`$LastPackage==="xAct`TexAct`",
Unset[xAct`xCore`Private`$LastPackage];
Print[xAct`xCore`Private`bars];
Print["These packages come with ABSOLUTELY NO WARRANTY; for details type Disclaimer[]. This is free software, and you are welcome to redistribute it under certain conditions. See the General Public License for details."];
Print[xAct`xCore`Private`bars]]


Tex::usage="Tex[expr] returns a string with the TeX formatting of the tensorial expression expr.";
TexPrint::usage="TexPrint[expr] returns a string for screen printing of the TeX formatting of the tensorial expression expr. TexPrint[expr, n] starts using parenthesization of level n, instead of the Automatic level.";
TexBreak::usage="TexBreak[string] breaks the string (the output of TexPrint) into different lines of TeX code, always before a sum, approximately every 200 characters (or terms, using the option TexBreakBy) of the string. TexBreak[string, n] allows specifying the frequency of characters or terms. TexBreak[string, n, list] allows specifying different lengths for different lines. Other relevant options are TexBreakAt and TexBreakString.";
TexBreakBy::usage="TexBreakBy is an option for TexBreak specifying whether the string of TeX code must be broken by counting characters (value \"Character\") or by counting terms (value \"Term\").";
TexBreakAt::usage="TexBreakAt is an option for TexBreak specifying where to break the string of TeX code.";
TexBreakString::usage="TexBreakString is an option for TexBreak specifying the string to be introduced at the breaking points.";
$TexPrintInitialBracesQ::usage="$TexPrintInitialBracesQ is a Boolean global variable, with default False. If set to True a tensor is formatted as T{}^{ab}{}_{cd}. If set to False the same tensor is formatted as T^{ab}{}_{cd}.";
$TexScalarParentheses::usage="$TexScalarParentheses is a Boolean global variable, with default True. If set to True the Scalar expressions are formatted with wrapping parentheses.";
$TexFraction::usage="$TexFraction is a global variable specifying the Tex command to be used to format fractions, with default \"\\frac\".";
$TexSmallFraction::usage="$TexSmallFraction is a global variable specifying the Tex command to be use to format rational numbers, with default \"\\tfrac\".";
$TexFractionAsFraction::usage="Option for TexPrint. If True, fractions are printed as fractions, otherwize they are printed as a product with negative exponents.";
$TexParenthesisInitLevel::usage="";
$TexFixExtraRules::usage="";
TexMatrix::usage ="TexMatrix[M] produces TeX code for the matrix M, where all elements are typset by the function Tex. TexMatrix[M, F] uses the function F instead of Tex on the elements.";


Begin["`Private`"]


TexOpen[string_String]:=OpenParenthesis[Decrement[level]]<>string;
TexClose[string_String]:=CloseParenthesis[PreIncrement[level]]<>string;


(* Trick to count maximum depth *)
OpenParenthesis[level_Integer?Negative]:=(minlevel=Min[minlevel,level];"");
CloseParenthesis[level_Integer?Negative]:="";

OpenParenthesis[0]:="";
CloseParenthesis[0]:="";

OpenParenthesis[1]:="\\bigl";
CloseParenthesis[1]:="\\bigr";

OpenParenthesis[2]:="\\Bigl";
CloseParenthesis[2]:="\\Bigr";

OpenParenthesis[3]:="\\biggl";
CloseParenthesis[3]:="\\biggr";

OpenParenthesis[4]:="\\Biggl";
CloseParenthesis[4]:="\\Biggr";

OpenParenthesis[level_Integer?Positive]:="\\left";
CloseParenthesis[level_Integer?Positive]:="\\right";


(* Main. Private *)
TexMaximumLevel[expr_]:=Block[{level=0,minlevel=0},Tex[expr];-minlevel];


(* Safety definitions for direct examples with Tex *)
level=0;
minlevel=0;


$VerboseParenthesizationLevel=False;
TexParenthesis[expr_,initlevel_:Automatic]:=Block[{level=If[initlevel===Automatic,TexMaximumLevel[expr],initlevel]},If[$VerboseParenthesationLevel,Print["Maximum parenthesization level: ",level]];
Tex[expr]
];


(* Just in case *)
Tex[]:="";


$TexFraction="\\frac";
$TexSmallFraction="\\tfrac";


TexFrac1[numer_, denom_,fracsymbol_]:=StringJoin[fracsymbol,"{",Tex[numer],"}{",Tex[denom],"}"];


TexFracExpression[numer_, denom_,fracsymbol_]:=If[WithMinusQ[numer],
StringJoin[TexOperator[Minus],TexFrac1[-(numer),denom,fracsymbol]],
TexFrac1[numer,denom,fracsymbol]
];


WithMinusQ[expr_String]:=SameQ[StringTake[expr,1],"-"];
WithMinusQ[expr_]:=WithMinusQ[Tex[expr]];


(* Numbers *)
Tex[x_Integer]:=ToString[x];
Tex[x_Real]:=ToString[x];
Tex[x_Rational]:=TexFracExpression[Numerator[x],Denominator[x],$TexSmallFraction];
Tex[Complex[0,1]]="i";
Tex[Complex[0,-1]]="-i";
Tex[Complex[0,im_]]:=StringJoin[Tex[im],Tex[I]];
Tex[Complex[re_,im_]]:=StringJoin[TexOpen["("],Tex[re],"+",Tex[im I],TexClose[")"]];


(* Numeric expressions *)
Tex[E]="e";
Tex[Pi]="\\pi";


(* Strings *)
Removetext[string_String]:=StringDrop[StringDrop[string,6],-1]/;StringMatchQ[string,"\\text{*}"];
Removetext[string_String]:=string;
Tex[string_String]:=Removetext@ToString@TeXForm@string;


(* Functions *)
Tex[Sin]:="\\sin";
Tex[Cos]:="\\cos";
Tex[Sec]:="\\sec";
Tex[Csc]:="\\csc";
Tex[Cot]:="\\cot";
Tex[Tan]:="\\tan";


(* Symbols (including constant-symbols and parameters) *)
Tex[symbol_Symbol]:=Tex@PrintAs[symbol];


(* One index *)
TexUpIndex[index_]:=Tex[IndexForm[index]];


$TexPrintInitialBracesQ=False;
initbraces[]:=If[$TexPrintInitialBracesQ,"{}",""];
(* Main *)
TexIndices[]:=Sequence[];
TexIndices[first_?UpIndexQ,more___]:=StringJoin[initbraces[],"^{",TexUpIndex[first],TexIndicesFromUp[more],"}"];
TexIndices[first_?DownIndexQ,more___]:=StringJoin[initbraces[],"_{",TexUpIndex[ChangeIndex@first],TexIndicesFromDown[more],"}"];
(* Previous index was up *)
TexIndicesFromUp[]:=Sequence[];
TexIndicesFromUp[first_?UpIndexQ,more___]:=StringJoin[TexUpIndex[first],TexIndicesFromUp[more]];
TexIndicesFromUp[first_?DownIndexQ,more___]:=StringJoin["}{}_{",TexUpIndex[ChangeIndex@first],TexIndicesFromDown[more]];
(* Previous index was down *)
TexIndicesFromDown[]:=Sequence[];
TexIndicesFromDown[first_?DownIndexQ,more___]:=StringJoin[TexUpIndex[ChangeIndex@first],TexIndicesFromDown[more]];
TexIndicesFromDown[first_?UpIndexQ,more___]:=StringJoin["}{}^{",TexUpIndex[first],TexIndicesFromUp[more]];
(* With derivative indices in postfix notation *)
TexCovDIndices[post_][first_?UpIndexQ,more___]:=StringJoin["{}^{",post,TexUpIndex[first],TexIndicesFromUp[more],"}"];
TexCovDIndices[post_][first_?DownIndexQ,more___]:=StringJoin["{}_{",post,TexUpIndex[ChangeIndex@first],TexIndicesFromDown[more],"}"];


(* Unary minus *)
TexOperator[Minus]="- ";
Tex[-expr_Plus]:=StringJoin[TexOperator[Minus],TexOpen["("],Tex[expr],TexClose[")"]];
Tex[-expr_]:=TexOperator[Minus]<>Tex[expr];


(* Product *)
TexOperator[Times]:=" ";
TexFactor[1]:="";
TexFactor[-1]:=TexOperator[Minus];
TexFactor[expr_Plus]:=StringJoin[TexOpen["("],Tex[expr],TexClose[")"]];
TexFactor[expr_]:=Tex[expr];
TexOrdinaryTimes[expr_Times]:=StringJoin@@Riffle[TexFactor/@List@@expr,TexOperator[Times]];
TexOrdinaryTimes[expr_]:=Tex@expr;


$TexFractionAsFraction=True;


Tex[expr_Times]:=Module[{numer=Numerator[expr],denom=Denominator[expr]},
If[And[!NumberQ[denom],$TexFractionAsFraction],
TexFracExpression[numer,denom,$TexFraction],
TexOrdinaryTimes[expr]
]
];


(* Sum *)
TexOperator[Plus]:=" + ";
Tex[expr_Plus]:=StringJoin@@Riffle[Tex/@List@@expr,TexOperator[Plus]];


(* Square root of a number *)
Tex[Sqrt[num_?NumberQ]]:=StringJoin["\\sqrt{",Tex[num],"}"];
Tex[Power[num_?NumberQ,-1/2]]:=StringJoin[$TexSmallFraction,"{1}{\\sqrt{",Tex[num],"}}"];


ExtractNumericalFactor[expr_Times]:=Times@@(Select[List@@expr,NumberQ]);
ExtractNumericalFactor[num_?NumberQ]:=num;
ExtractNumericalFactor[___]:=1;


(* Other square roots *)
Tex[expr:Times[Power[num_?NumberQ,-1/2],___]]:=Module[{
numfactor=ExtractNumericalFactor[expr Sqrt[num]],
numer=Numerator[expr Sqrt[num]],
denom1=Denominator[expr Sqrt[num]]
},
If[Or[!$TexFractionAsFraction,NumberQ[denom1]],
StringJoin[TexFracExpression[Numerator[numfactor],Denominator[numfactor]Sqrt[num],$TexSmallFraction],TexFactor[expr Sqrt[num]/numfactor]],
TexFracExpression[numer,denom1 Sqrt[num],$TexFraction]]
];


(* Power *)
TexOperator[Power]:="^";
TexBase[x:(_Symbol|_Integer|_?xTensorQ[___])]:=Tex[x];
TexBase[x_]:=StringJoin[TexOpen["("],Tex[x],TexClose[")"]];
TexExponent[x_]:=With[{tex=Tex[x]},If[StringLength[tex]===1,tex,StringJoin["{",tex,"}"]]];
(*Tex[Power[x_,-1]]:=StringJoin["\\frac{1}{",Tex[x],"}"]/;ByteCount[x]<200;*)
Tex[Power[x_,-1]]:=TexFracExpression[1,x,$TexFraction]/;$TexFractionAsFraction;
Tex[Power[x_,n_]]:=StringJoin[TexBase[x],TexOperator[Power],TexExponent[n]];


(* Tensors *)
Tex[tensor_?xTensorQ[indices___]]:=StringJoin[Tex[tensor],TexIndices[indices]];


(* Derivatives of scalar functions *)
deriv[var_,1]:="\\partial "<>Tex[var];
deriv[var_,n_]:="\\partial^{"<>Tex[n]<>"}"<>Tex[var];
withrespectto[vars_List,ders_List]:=Inner[withrespectto,vars,ders,StringJoin];
withrespectto[var_,0]:="";
withrespectto[var_,1]:="\\partial "<>Tex[var];
withrespectto[var_,n_]:="\\partial "<>Tex[var]<>"^{"<>Tex[n]<>"}";
Tex[Derivative[ders__][f_?ScalarFunctionQ][vars__]]:="\\frac{"<>deriv[f[vars],Plus[ders]]<>"}{"<>withrespectto[{vars},{ders}]<>"}";


(* Other scalar functions *)
Tex[f_?ScalarFunctionQ[args__]]:=StringJoin[Tex[f],TexOpen["("],Sequence@@InsertComma[Tex/@{args}],TexClose[")"]];
InsertComma[arguments_List]:=Insert[arguments,", ",List/@Range[2,Length[arguments]]];


(* Remove the Scalar head *)
$TexScalarParentheses=True;
Tex[Scalar[expr_]]:=If[$TexScalarParentheses,
StringJoin[TexOpen["("],Tex[expr],TexClose[")"]],
Tex[expr]
];


(* Covariant derivatives *)
Tex[covd_Symbol?CovDQ[inds__][expr_]]:=TexCovDCombine[TexCovD[covd],Tex[expr],IndexList[inds],$CovDFormat];
Tex[CovD[expr_,ders___,der_Symbol?CovDQ[inds__]]]:=TexCovDCombine[TexCovD[covd],Tex[expr],IndexList[inds],$CovDFormat];
TexCovDCombine[{post_,pre_},exprstring_String,list_IndexList,"Prefix"]:=StringJoin[Tex@pre,TexIndices@@list,exprstring];
TexCovDCombine[{post_,pre_},exprstring_String,list_IndexList,"Postfix"]:=StringJoin[exprstring,TexCovDIndices[Tex@post]@@list];
TexCovD[covd_]:=SymbolOfCovD[covd];


(* Lie derivatives *)
Tex[LieD[n_Symbol[_]][expr_]]:="\\mathcal{L}_"<>Tex[n]<>Tex[expr];


(* Parametric derivative *)
TexParamD[{ps_}]:="\\partial_"<>Tex[ps]<>" ";
TexParamD[ps:{__}]:="\\partial_"<>Tex[First[ps]]<>"^{"<>ToString[Length[ps]]<>"} ";
Tex[ParamD[ps__][expr_]]:=If[$ParamDFormat=="Postfix",
StringJoin[Tex[expr],"{}_{,",Sequence@@(Tex/@{ps}),"}"],Apply[StringJoin,TexParamD/@Split@Sort[{ps}]]<>Tex[expr]
];
(*
Tex[ParamD[ps__][expr_]]:=Apply[StringJoin,TexParamD/@Split@Sort[ps]]<>TexOpen["["]<>Tex[expr]<>TexClose["]"];
*)


(* Basis *)


(* Equal *)
Tex[Equal[lhs_,rhs_]]:=StringJoin[Tex[lhs]," = ",Tex[rhs]];


$TexFixExtraRules={};


(* Note that we remove the dollars! This is because \[Mu]3 is converted into $\mu$3 for instance *)
TexFix[string_String]:=StringReplace[string,Join[{"+-"->"-","+ -"->"- "," _"->"_"," ^"->"^","  "->" ","$"->""},$TexFixExtraRules]];


(* Main. Public *)
TexPrint[expr_,initlevel_:Automatic]:=TexFix@TexParenthesis[ScreenDollarIndices[expr],initlevel];


TexMatrix[M_?MatrixQ,F_: Tex]:=Module[{rows=Length[M],cols=Length@First@M},StringJoin["\\left(\\begin{array}{",StringJoin@@ConstantArray["c",{cols}],"}\n",StringJoin[Riffle[StringJoin[Riffle[F/@#," & "]]&/@M,"\\\\\n"]],"\n\\end{array}\\right)"]]


Tex[xAct`SymManipulator`SymH[headlist_,sym_,label_]?xTensorQ[inds___]]:=TexSymH[xAct`SymManipulator`SymH[headlist,sym,label][inds]]


Tex[xAct`SymManipulator`CovarD[D1_?CovDQ,T_?xTensorQ,list_]]:=StringJoin[Tex[Last@SymbolOfCovD[D1]],Tex[T]];


TexGroupSymbols[points_,sym_]:=Which[xAct`SymManipulator`SubgroupQ[Symmetric[points],sym],(* Symmetric *)
{"(",")"},
xAct`SymManipulator`SubgroupQ[Antisymmetric[points],sym],(* Antisymmetric *)
{"[","]"},
True,(* Everything else *)
{"Unkown","Unkown"}];


TexSymH[x:(xAct`SymManipulator`SymH[headlist_,sym_,label_][inds___])]:=Module[
{texfail=False,n=Length@List[inds], indlist=List@inds, longorbits, orbitgroupsymbols,orbitondowninds,orbitonupinds, downsymorbits, upsymorbits, excludesymdowninds,excludesymupinds, downindexslots, beginsym, endsym, beginexclude, endexclude, preindexsymbolrules, postindexsymbolrules},
longorbits=Sort/@Select[Orbits[sym,n],Length[#]>1&];
orbitgroupsymbols=TexGroupSymbols[#,sym]&/@longorbits;
If[Length@Select[orbitgroupsymbols,First[#]==="Unkown"&]>0,
texfail=True;
Print["Not a disjoint union of symmetric and antisymmetric groups."];];
downindexslots=Select[Range[1,Length@indlist],DownIndexQ[indlist[[#]]]&];
orbitondowninds=xAct`SymManipulator`Private`SubsetQ[#,downindexslots]&/@longorbits;
orbitonupinds=Length[Intersection[#,downindexslots]]==0&/@longorbits;
If[Not[And@@MapThread[Or,{orbitondowninds,orbitonupinds}]],
texfail=True;
Print["Not all indices are good positions."]];
downsymorbits=Pick[longorbits,orbitondowninds];
upsymorbits=Pick[longorbits,orbitonupinds];
If[Not@And[OrderedQ[Join@@downsymorbits],OrderedQ[Join@@upsymorbits]],
texfail=True;
Print["The symmetries are overlapping."]];
excludesymdowninds=Complement[Range[First@#,Last@#],#]&/@downsymorbits;
excludesymdowninds=Intersection[#,downindexslots]&/@excludesymdowninds;
excludesymupinds=Complement[Range[First@#,Last@#],#]&/@upsymorbits;
excludesymupinds=Intersection[#,Complement[Range@n,downindexslots]]&/@excludesymupinds;
beginsym=Join[First/@downsymorbits,First/@upsymorbits];
endsym=Join[Last/@downsymorbits,Last/@upsymorbits]; 
beginexclude=Join[First/@Select[excludesymdowninds,(Length@#>0)&],First/@Select[excludesymupinds,(Length@#>0)&]];
endexclude=Join[Last/@Select[excludesymdowninds,(Length@#>0)&],Last/@Select[excludesymupinds,(Length@#>0)&]];
preindexsymbolrules=Rule[#,orbitgroupsymbols[[First@First@Position[longorbits,#,2,1],1]]]&/@beginsym;
postindexsymbolrules=Rule[#,orbitgroupsymbols[[First@First@Position[longorbits,#,2,1],2]]]&/@endsym;
preindexsymbolrules=Join[preindexsymbolrules,Rule[#,"|"]&/@beginexclude];
postindexsymbolrules=Join[postindexsymbolrules,Rule[#,"|"]&/@endexclude];
preindexsymbolrules=Rule[#,(#/.preindexsymbolrules)/.Rule[#,""]]&/@Range[n];
postindexsymbolrules=Rule[#,(#/.postindexsymbolrules)/.Rule[#,""]]&/@Range[n];
If[texfail,Print["Could not typset the SymH object nicely."];
StringJoin["\\underset{",label,"}{Sym}(",TexPrint@xAct`SymManipulator`RemoveSym@x,")"],
TexKnownSymH[headlist,n, indlist,preindexsymbolrules, postindexsymbolrules]]]


TexKnownSymH[headlist_,n_, indlist_,preindexsymbolrules_, postindexsymbolrules_]:=Module[{numindices=Length/@SlotsOfTensor/@headlist,partitionedslots,internalexpr, indicesoftensor, texstring="",  texstringtensor="", i=1, CovarDs, newheadlist=headlist},
CovarDs=First/@Position[newheadlist,xAct`SymManipulator`CovarD,2];
While[Length@CovarDs>0,
numindices=ReplacePart[numindices,(#->Sequence[Length@newheadlist[[#,3]],numindices[[#]]-Length@newheadlist[[#,3]]])&/@CovarDs];
newheadlist=ReplacePart[newheadlist,(#->Sequence[Last@SymbolOfCovD@newheadlist[[#,1]],newheadlist[[#,2]]])&/@CovarDs];
CovarDs=First/@Position[newheadlist,xAct`SymManipulator`CovarD,2];
];
(* Extract indices belonging to the different tensors. Can this be done in a simpler way? *)
partitionedslots=Last/@Rest@FoldList[{Drop[#1[[1]],#2],Take[#1[[1]],#2]}&,{Range[n],{}},numindices];
indicesoftensor=indlist[[#]]&/@partitionedslots;
While[i<=Length@newheadlist,
texstringtensor= TexTensorWithSym[newheadlist[[i]],indicesoftensor[[i]],partitionedslots[[i]] ,preindexsymbolrules, postindexsymbolrules];
texstring=StringJoin[texstring,texstringtensor];
i=i+1];
texstring]


TexTensorWithSym[head_,inds_,slots_,preindexsymbolrules_, postindexsymbolrules_]:=Module[{texstring=Tex@head, i=1, fromdown,postindexsymbol=""},
While[i<=Length[inds],
texstring=StringJoin[texstring,TexSymIndex[inds[[i]],i==1,fromdown,slots[[i]]/.preindexsymbolrules]];
fromdown=DownIndexQ[inds[[i]]];
postindexsymbol=slots[[i]]/.postindexsymbolrules;
texstring=StringJoin[texstring,postindexsymbol];
i=i+1;];
If[Length@inds>0, texstring=StringJoin[texstring,"}"]];
texstring]


TexSymIndex[index_,firstindexQ_,fromdownQ_,preindexsymbol_]:=
Module[{indexstring},
indexstring=Which[
firstindexQ&&DownIndexQ[index]&&Not[$TexPrintInitialBracesQ],"_{",
firstindexQ&&DownIndexQ[index]&&$TexPrintInitialBracesQ,"{}_{",
firstindexQ&&Not[$TexPrintInitialBracesQ],"^{",
firstindexQ&&$TexPrintInitialBracesQ,"{}^{",
fromdownQ&&DownIndexQ[index],"",
fromdownQ,"}{}^{",
DownIndexQ[index],"}{}_{",
True,""];
StringJoin[indexstring,preindexsymbol,TexUpIndex[UpIndex @index]]]


Options[TexBreak]={TexBreakBy->"Character",TexBreakAt->" + "|" - ",TexBreakString->" \\nonumber \\\\ \n&&"};


TexBreak[string_String,n_Integer,l_List,options___]:=Module[{splittablePositions,breakat,breakby,breakstring,splitat,positions,perLine},
{breakat,breakby,breakstring}={TexBreakAt,TexBreakBy,TexBreakString}/.CheckOptions[options]/.Options[TexBreak];

(* Positions where the string can be split: wherever + or - is encountered *)
splittablePositions=First/@StringPosition[string,breakat];

(* The terms/characters per line that the user specified *)
If[l!={},perLine=SparseArray[l,Automatic,n],perLine={n}];

(* Positions at which the string will be split *)
Switch[breakby,

"Character",
positions={};
Module[{iter,currentPosition=0,nearestPosition,strlen=StringLength[string]},
(* Split parts where lengths are given explicitly *)For[iter=1,(iter<=Length[perLine])&&(currentPosition+perLine[[iter]]<strlen),iter++,

nearestPosition=Nearest[Select[splittablePositions-currentPosition,Positive],perLine[[iter]]];

If[nearestPosition!={},
currentPosition+=First@nearestPosition;
AppendTo[positions,currentPosition],
currentPosition=strlen
];
];

(* Split remainder into strings of length~n) *)While[(currentPosition+n<strlen),nearestPosition=Nearest[Select[splittablePositions-currentPosition,Positive],n];
If[nearestPosition!={},
currentPosition+=First@nearestPosition;
AppendTo[positions,currentPosition],
currentPosition=strlen
];
];
],

"Term",
(* The terms at which we want to split *)
splitat=Accumulate[perLine];

(* Pad out every n terms *)splitat=Flatten[AppendTo[splitat,Range[Last[splitat]+n,Length[splittablePositions],n]]];

(* Remove split points which are past the end of the string *)splitat=Select[splitat,#<=Length[splittablePositions]&];

(* The positions in the string to split at *)
positions=Map[Part[splittablePositions,#]&,splitat];,

_,
Throw["Invalid value for option TexBreakBy."]

];

(* Split string *)
StringInsert[string,breakstring,positions]
];
(* Shortcuts and defaults *)
TexBreak[string_String,n_Integer,options___]:=TexBreak[string,n,{},options];
TexBreak[string_String,options___]:=TexBreak[string,200,{},options];


End[]


EndPackage[]