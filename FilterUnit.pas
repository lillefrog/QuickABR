unit FilterUnit;

interface

Uses
SysUtils ,Dialogs;//

Type TFilterData = Array[0..2000] of single;  // must fit TSubMeas(commonUnit) and TDTSignal (TDTunit)
Function BpFilter(Input:TFilterData;upper,Lower:double):TFilterData;
Function LpFilter(Input:TFilterData;freq:integer):TFilterData;
Procedure LpFilterP(var Input:TFilterData; var freq:integer);

{ FIR Low-Pass Filter, Filter Order = 30}
Const  FilterLP2000Hz: array[-15..15] of single=
    (0.001691,0.001737,0.001392,-0.000111,-0.003481,-0.008619,-0.014024,-0.016731,
    -0.012990,0.000451,0.024871,0.058518,0.096469,0.131607,0.156482,0.165470,
    0.156482,0.131607,0.096469,0.058518,0.02487,0.000451,-0.012990,-0.016731,
    -0.014024,-0.008619,-0.003481,-0.000111,0.001392,0.001737,0.001691);

Const  FilterLP2500Hz: array[-15..15] of single=
    (-0.000396,0.000812,0.002544,0.004412,0.004819,0.001541,-0.006577,-0.017688,
    -0.026153,-0.023901,-0.003839,0.036106,0.090421,0.146571,0.188958,0.204738,
    0.188958,0.146571,0.090421,0.036106,-0.003839,-0.023901,-0.026153,-0.017688,
    -0.006577,0.001541,0.004819,0.004412,0.002544,0.000812,-0.000396);

Const  FilterLP3000Hz: array[-15..15] of single=
    (-0.001085,-0.002045,-0.002243,-0.000337,0.004424,0.009877,0.010527,
    0.000988,-0.018111,-0.036268,-0.035839,-0.001703,0.067326,0.153257,0.224865,
    0.252734,0.224865,0.153257,0.067326,-0.001703,-0.035839,-0.036268,-0.018111,
    0.000988,0.010527,0.009877,0.004424,-0.000337,-0.002243,-0.002045,-0.001085);

Const  FilterLP3500Hz: array[-15..15] of single=
    (0.001433,0.000205,-0.002112,-0.004409,-0.003383,0.003632,0.013485,0.015975,
    0.001343,-0.027292,-0.048143,-0.031000,0.040099,0.148466,0.247726,0.287951,
    0.247726,0.148466,0.040099,-0.031000,-0.048143,-0.027292,0.001343,0.015975,
    0.013485,0.003632,-0.003383,-0.004409,-0.002112,0.000205,0.001433);

Const  FilterLP4000Hz: array[-15..15] of single=
    (0.000265,0.001899,0.002312,-0.000557,-0.006152,-0.007964,0.001321,0.017667,
    0.022064,-0.002267,-0.043572,-0.056826,0.003033,0.133599,0.270574,0.329203,
    0.270574,0.133599,0.003033,-0.056826,-0.043572,-0.002267,0.022064,0.017667,
    0.001321,-0.007964,-0.006152,-0.000557,0.002312,0.001899,0.000265);


implementation



Function BpFilter(Input:TFilterData;upper,Lower:double):TFilterData;
var
L,i,J,k:integer;
drift,b,a,bnot,bhat:double;
AA: Array of Array of single;
bb,bb2: Array of single;
fx:TFilterData;
Begin
//Correct for very low freq drift
L:=Length(Input);
SetLength(AA,L,L);
SetLength(bb,L);
SetLength(bb2,L);
drift:= (Input[L-1]- Input[0]) / (L-1);
for i:=0 to L-1 do Result[i]:= Input[i]- drift*i;
//
b:= 2*pi/Lower;
a:= 2*pi/Upper;
bnot:= (b-a)/pi;
bhat:= bnot/2;

for i:=0 to L-1 do bb[i]:= (sin((i+1)*b)-sin((i+1)*a))/((i+1)*pi);
for i:=0 to L-2 do bb2[i+1]:= bb[i];
bb2[0]:=bnot;
for i:=0 to L-1 do
        Begin
          k:=0;
          for J:=i to L-1 do
             Begin
              AA[i,J]:=bb2[k];
              AA[J,i]:=bb2[k];
              inc(k);
             end;
        end;
AA[0,0]:=bhat;
AA[L-1,L-1]:=bhat;

for i:=0 to L-2 do
        Begin
          AA[i+1,1] := AA[i,1]-bb2[i];
          AA[(L-1)-i,L-1]:=AA[i,1]-bb2[i];
        end;

for i:=0 to L-1 do
        Begin
          fx[i]:=0;
          for J:=0 to L-1 do
            Begin
              fx[i]:= fx[i]+ AA[i,J]*Result[J];
            end;
        end;
   //shift
  Result:=fx;
end;




Function LpFilter(Input:TFilterData;freq:integer):TFilterData;
var
  BigArray : Array[-15..length(Input)+15] of single;
  i,j,lang :integer;
  sum: single;
  Filtered: boolean;
Begin

 lang:= length(Input);
 Filtered:=False;
 for i:=-15 to lang+15 do BigArray[i]:=0;
 For i :=0 to lang-1 do BigArray[i]:= Input[i];

 If freq=-1 then begin
   LpFilter:=Input;
   Filtered:=TRUE;
 End;

 If freq=2000 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP2000Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;

 If freq=2500 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP2500Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;

 If freq=3000 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP3000Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;

 If freq=3500 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP3500Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;

 If freq=4000 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP4000Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;
 If Not filtered then Showmessage('This filter is not installed: '+IntToStr(freq)+'Hz');
End;






Procedure LpFilterP(var Input:TFilterData; var freq:integer);
var
  BigArray : Array[-15..length(Input)+15] of single;
  i,j,lang :integer;
  sum: single;
  Filtered: boolean;
  LpFilter:TFilterData;
Begin

 lang:= length(Input);
 Filtered:=False;
 for i:=-15 to lang+15 do BigArray[i]:=0;
 For i :=0 to lang-1 do BigArray[i]:= Input[i];

 If freq=-1 then begin
   LpFilter:=Input;
   Filtered:=TRUE;
 End;

 If freq=2000 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP2000Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;

 If freq=2500 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP2500Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;

 If freq=3000 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP3000Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;

 If freq=3500 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP3500Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;

 If freq=4000 then begin
   For i :=0 to lang-1 do begin
     Sum:=0;
     For j:=-15 to 15 do sum:= Sum+ FilterLP4000Hz[j]*BigArray[i+j];
     LpFilter[i]:=Sum;
   End;
   Filtered:=TRUE;
 End;


 If Not filtered then Showmessage('This filter is not installed: '+IntToStr(freq)+'Hz');
  freq:=2000;
 for i:=0 to length(Input)-1 do Input[i]:=LpFilter[i];
  
End;




end.





