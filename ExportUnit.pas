unit ExportUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, TeEngine, Series, ExtCtrls, TeeProcs, Chart, Menus, math, StdCtrls;

type TSubSetData = record
        X: single;
        Y: single;
        end;

type TSetData = array of TSubSetData;

type
  TExportForm = class(TForm)
    StringGrid1: TStringGrid;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Action1: TMenuItem;
    Calculate1: TMenuItem;
    Chart1: TChart;
    Series3: TLineSeries;
    Series1: TLineSeries;
    CopytoClipboard1: TMenuItem;
    Memo1: TMemo;
    Series2: TPointSeries;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Calculateall1: TMenuItem;
    Chart2: TChart;
    Series4: TLineSeries;
    Compact1: TMenuItem;
    Series5: TPointSeries;
    Series6: TLineSeries;
    Label3: TLabel;
    Procedure ClearStringGrid();
    Procedure Simplefit(MySetData:TSetData);
    procedure Calculate1Click(Sender: TObject);
    procedure CalculateCol(XCol:integer);
    procedure StringGrid1Click(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Calculateall1Click(Sender: TObject);
    Function copyrow(FromRow,ToRow,AntalCols:integer):Boolean;
    procedure Compact1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportForm: TExportForm;
  glob_significans_50:double;
  glob_significans_10:double;
  glob_significans_01:double;
  glob_Export_DataType: integer;   //4=SNR

implementation

{$R *.DFM}
{$M 16384,10485760}

Procedure TExportForm.ClearStringGrid();
var
  mRow,mCol:integer;
begin
  for mRow:=0 to Stringgrid1.RowCount-1 do
    For mCol:=0 to Stringgrid1.ColCount-1 do Stringgrid1.Cells[mCol,mRow]:='' ;
end;

{Simple fit for SNR function}
Procedure TExportForm.Simplefit(MySetData:TSetData);
var
 i:integer;
 Treshold:integer;
 TdB:double;
Begin
 Treshold:=-1;
 //Chart1.SeriesList[3].Clear;
 //Chart1.SeriesList[4].Clear;
 for i:=1 to length(MySetData)-1 do
   Begin
   if (MySetData[i].Y > glob_significans_01) and (MySetData[i-1].Y < glob_significans_01) then Treshold:=i;
   end;
 if Treshold>0 then
   Begin
     TdB := (((glob_significans_01 - MySetData[Treshold-1].Y) / (MySetData[Treshold].Y -MySetData[Treshold-1].Y))*
                (MySetData[Treshold].X -MySetData[Treshold-1].X)) + MySetData[Treshold-1].X;
     Chart1.SeriesList[3].AddXY(TdB,glob_significans_01);
     Chart1.SeriesList[4].AddXY(MySetData[Treshold-1].X,MySetData[Treshold-1].Y);
     Chart1.SeriesList[4].AddXY(MySetData[Treshold].X,MySetData[Treshold].Y);
   end;
end;



Procedure linefit(MySetData:TSetData; var A,B,Corr,sA,sB: double);
var
 sum_x,sum_y,sum_xy,sum_x2,sum_y2 : double;
 xi,yi,sxy,sxx,syy : double;
 i,n : integer;
 sigmaA,sigmaB,see : double;
begin
 if (not(MySetData=nil) and (high(MySetData)>0)) then begin
   sum_x:=0; sum_y:=0; sum_xy:=0; sum_x2:=0; sum_y2:=0;    // initialise
   n:=high(MySetData);             // last post in MySetData
   for i:=0 to n do begin
      xi:= Mysetdata[i].X;
      yi:= Mysetdata[i].Y;
       if yi>=1 then yi:=0.9999;    // needed to apply transformation
       if yi<=0 then yi:=0.0001;
      yi:= ln(-1/(yi-1)-1);        // Transforms to linear data
      sum_x:=sum_x+xi;
      sum_y:=sum_y+yi;
      sum_xy:=sum_xy + (xi*yi);
      sum_x2:=sum_x2 + (xi*xi);
      sum_y2:=sum_y2 + (yi*yi);
   end;
   N:=n+1;                        // Number of posts in MySetData
   sxx:=sum_x2-sum_x*sum_x/N;
   sxy:=sum_xy-sum_x*sum_y/N;
   syy:=sum_y2-sum_y*sum_y/N;
   if ((sxx<>0) and not(N=2) and (sxy>1e-10) and (syy>1e-10) ) then begin
       B:=sxy/sxx;                                    //slope
       A:=((sum_x2*sum_y-sum_x*sum_xy)/N)/sxx;        //intercept
       corr:= sxy/ sqrt(sxx*syy);      //correlation coffient
       see:= sqrt( (sum_y2-A*sum_y-B*sum_xy) / (N-2));   //see = Standart error of estimate
       sigmaB:= see/sqrt(sxx);                        //standard deviation (not used but could be usefull later)
       sigmaA:= sigmaB*sqrt(sum_x2/N);
       sB:=sigmaB; sA:=sigmaA;
   end;// else showmessage('Not enough data to correlate');
 end else showmessage('no data in array');
end;




procedure TExportForm.Calculate1Click(Sender: TObject);
var
 XCol:integer  ;
begin
 XCol:=stringgrid1.Col;     //Temp disable
 CalculateCol(XCol);
end;


function FindSetMax(Setdata: Tsetdata):single;
var
 i:integer;
 Max:single;
begin
 Max:=-1000;
 for i:=0 to length(Setdata)-1 do
   Begin
    if Setdata[i].X > Max then Max := Setdata[i].X;
   end;
   result:=Max;
end;


function FindSetMin(Setdata: Tsetdata):single;
var
 i:integer;
 Min:single;
begin
 Min:=1000;
 for i:=0 to length(Setdata)-1 do
   Begin
    if Setdata[i].X < Min then Min := Setdata[i].X;
   end;
   result:=Min;
end;



procedure TExportForm.CalculateCol(XCol:integer);
var
 A,B,y,x: double;
 i,errorCount:integer;
 correl_coef,sA,sB: double;
 linear: boolean;
 ngood:integer;
 Setdata: Tsetdata;
 S:string;
begin
  ngood:=1;
  linear:=False;
  Label3.Caption:=  'Significans Threshold: '+ FloatToStrF(glob_significans_01,ffFixed,2,2 );
 for i:=0 to 4 do Chart1.Series[i].Clear;
setlength(setdata,20);
 for i :=1 to 20 do
   If ((stringgrid1.Cells[Xcol,i])<>'') then begin
     if (StrToFloat(stringgrid1.Cells[Xcol,i])) > (StrToFloat(Combobox1.Text)) then begin
       setlength(setdata,ngood);
       setdata[ngood-1].X:= StrToFloat(stringgrid1.Cells[0,i]);
       setdata[ngood-1].Y:= StrToFloat(stringgrid1.Cells[Xcol,i]);
       inc(ngood);
     end;
   end;



If ngood > 3 then begin
   if glob_Export_DataType=4 then Simplefit(SetData);
   linefit(SetData,A,B,correl_coef,sA,sB);
   Chart1.Title.Text.Text   := FloatToStrF(A,ffFixed,7,7)+ ' + '+ FloatToStrF(B,ffFixed,7,7)+'X';

   for i:=0 to high(setdata) do  begin
      y:=setdata[i].Y;
      x:=setdata[i].X;
      
      if linear then begin
         if y>=1 then y:=0.9999;    // needed to apply transformation
         if y<=0 then y:=0.0001;
         y:= ln(-1/(y-1)-1);
       end;
      Chart1.Series[1].AddXY(x,y);
      Chart1.Series[1].Title:='Org. data';
      Chart1.Series[1].ShowInLegend:=true;
   end;
 if B<>0 then begin
   for i:=round(FindSetMin(Setdata)-1) to round(FindSetMax(Setdata)+1) do begin
     y:=A+B*i;
     if not(linear) then y:= 1-(1/(power(2.71828183,y)+1));
     Chart1.Series[0].AddXY(i,y);
     Chart1.Series[0].Title:='corr: '+floattostrF(correl_coef,ffFixed,3,3);
     Chart1.Series[0].ShowInLegend:=true;
   end;

   y:= StrToFloat(Combobox2.Text);
   y:= ln(-1/(y-1)-1);
   x:= (y-A)/B;
      S:=stringgrid1.Cells[Xcol,0];
      Delete(S,pos('Hz',S),2);
   Memo1.Lines.Add(  S + #9 + FloatToStr(x)   );
 end;
 end;
end;



procedure TExportForm.StringGrid1Click(Sender: TObject);
begin
 Calculate1Click(Sender);
end;


procedure TExportForm.CopytoClipboard1Click(Sender: TObject);
var
  S:string;
  mRow,mCol:integer;
begin
  memo1.Clear;
  for mRow:=0 to Stringgrid1.RowCount-1 do begin   //export as grid
    S:='';
    For mCol:=0 to Stringgrid1.ColCount-1 do S := S + Stringgrid1.Cells[mCol,mRow] + #9 ;
    Memo1.Lines.Add(S);
  end;
 Memo1.SelectAll;
 Memo1.CutToClipboard;
end;


     
procedure TExportForm.FormCreate(Sender: TObject);
begin
glob_significans_50:=0;
glob_significans_10:=0;
glob_significans_01:=0;


Combobox1.Items.Add(FloatToStrF(0.2,ffFixed,5,3));
Combobox1.Items.Add(FloatToStrF(0.1,ffFixed,5,3));
Combobox1.Items.Add(FloatToStrF(0.05,ffFixed,5,3));
Combobox1.Text:= FloatToStrF(0.001,ffFixed,5,3);

Combobox2.Items.Add(FloatToStrF(0.2,ffFixed,5,3));
Combobox2.Items.Add(FloatToStrF(0.1,ffFixed,5,3));
Combobox2.Items.Add(FloatToStrF(0.05,ffFixed,5,3));
Combobox2.Items.Add(FloatToStrF(0.01,ffFixed,5,3));
Combobox2.Text:= FloatToStrF(0.001,ffFixed,5,3);
end;



procedure TExportForm.Calculateall1Click(Sender: TObject);
var
i:integer;
begin
 memo1.Clear;
 Chart2.Series[0].Clear;
 for i:=1 to 19 do begin
   CalculateCol(i);
 end;
 Memo1.SelectAll;
 Memo1.CopyToClipboard;
end;



Function TExportForm.copyrow(FromRow,ToRow,AntalCols:integer):Boolean;
var
 i:integer;
Begin
 For i:=0 to AntalCols do
   Begin
     Stringgrid1.Cells[i,ToRow]:=Stringgrid1.Cells[i,FromRow];
     Stringgrid1.Cells[i,FromRow]:='';
   end;
   Result:=true;
end;


Function SwitchRows(Row1,Row2:integer; Grid: TStringGrid):boolean;
var
col:integer;
temp:string;
Begin
 result:=false;
 for col:=0 to Grid.ColCount do
   Begin
     temp:=Grid.Cells[col,Row1];
     Grid.Cells[col,Row1]:=Grid.Cells[col,Row2];
     Grid.Cells[col,Row2]:=temp;
     Result:=true;
   end;
end;



procedure TExportForm.Compact1Click(Sender: TObject);
var
 mRow,i,donor:integer;
 AntalRows:Integer;
begin
 AntalRows:= Stringgrid1.RowCount;
 mRow:=0;
 repeat
   inc(mRow);
   donor:=1;
   if Stringgrid1.Cells[0,mRow]='' then
      Begin
        donor:=0;
        for i:= AntalRows downto mRow+1 do if Stringgrid1.Cells[0,i]<>'' then donor:=i;
        if donor<>0 then SwitchRows(donor,mRow,Stringgrid1);
      end;
 until (mRow=AntalRows) or (donor=0);
end;




end.
