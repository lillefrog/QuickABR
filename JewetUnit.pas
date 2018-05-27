unit JewetUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ReadUnit,commonUnit,
  StdCtrls,comctrls ;

type
  TJewetForm = class(TForm)
    Bt_P1: TButton;
    Bt_P2: TButton;
    Bt_P3: TButton;
    Bt_P4: TButton;
    Bt_P5: TButton;
    Bt_P6: TButton;
    Bt_P7: TButton;
    Bt_P8: TButton;
    Bt_P9: TButton;
    Bt_N1: TButton;
    Bt_N2: TButton;
    Bt_N7: TButton;
    Bt_N6: TButton;
    Bt_N5: TButton;
    Bt_N4: TButton;
    Bt_N3: TButton;
    Bt_N9: TButton;
    Bt_N8: TButton;
    Bt_Save: TButton;
    Bt_Clear: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormUpdate(Node,Sample:Integer; X,Y:single);
    procedure Bt_P1Click(Sender: TObject);
    procedure Bt_N1Click(Sender: TObject);
    procedure Bt_SaveClick(Sender: TObject);
    procedure Bt_ClearClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  JewetForm: TJewetForm;
  glob_Jewet_Node:Integer;
  glob_Jewet_Sample:Integer;
  glob_Jewet_X:Double;
  glob_Jewet_Y:Double;

implementation

{$R *.DFM}



//*************************

procedure TJewetForm.FormShow(Sender: TObject);
var
 MyTreeNode:TTreeNode;
 JN,JP : TJewett;
begin
if JewetForm.tag>0 then
  Begin
    MyTreeNode := ReadForm.TreeView1.Items[JewetForm.tag];
    JN:=PMyRec(MyTreeNode.Data)^.JewettN ;
    JP:=PMyRec(MyTreeNode.Data)^.JewettP ;

    if JP[1]>0 then Bt_P1.Font.Style:=[fsBold,fsUnderline] else Bt_P1.Font.Style:=[];

   { Showmessage(
      IntToStr(JP[1])+#13+
      IntToStr(JP[2])+#13+
      IntToStr(JP[3])+#13+
      IntToStr(JP[4])+#13+
      IntToStr(JP[5])+#13+
      IntToStr(JP[6])+#13+
      IntToStr(JP[7])
    ); }
  End;
end;


//*************************

procedure TJewetForm.FormUpdate(Node,sample:Integer; X,Y:single);
var
 MyTreeNode:TTreeNode;
 JN,JP : TJewett;
Begin
 glob_Jewet_Node   :=  Node;
 glob_Jewet_Sample :=  Sample;
 glob_Jewet_X :=  X;
 glob_Jewet_Y :=  Y;
 if Node>0 then
  Begin
    MyTreeNode := ReadForm.TreeView1.Items[Node];
    JN:=PMyRec(MyTreeNode.Data)^.JewettN ;
    JP:=PMyRec(MyTreeNode.Data)^.JewettP ;

    if JP[1]>0 then Bt_P1.Font.Style:=[fsBold,fsUnderline] else Bt_P1.Font.Style:=[];
    if JP[2]>0 then Bt_P2.Font.Style:=[fsBold,fsUnderline] else Bt_P2.Font.Style:=[];
    if JP[3]>0 then Bt_P3.Font.Style:=[fsBold,fsUnderline] else Bt_P3.Font.Style:=[];
    if JP[4]>0 then Bt_P4.Font.Style:=[fsBold,fsUnderline] else Bt_P4.Font.Style:=[];
    if JP[5]>0 then Bt_P5.Font.Style:=[fsBold,fsUnderline] else Bt_P5.Font.Style:=[];
    if JP[6]>0 then Bt_P6.Font.Style:=[fsBold,fsUnderline] else Bt_P6.Font.Style:=[];
    if JP[7]>0 then Bt_P7.Font.Style:=[fsBold,fsUnderline] else Bt_P7.Font.Style:=[];
    if JP[8]>0 then Bt_P8.Font.Style:=[fsBold,fsUnderline] else Bt_P8.Font.Style:=[];
    if JP[9]>0 then Bt_P9.Font.Style:=[fsBold,fsUnderline] else Bt_P9.Font.Style:=[];

    if JN[1]>0 then Bt_N1.Font.Style:=[fsBold,fsUnderline] else Bt_N1.Font.Style:=[];
    if JN[2]>0 then Bt_N2.Font.Style:=[fsBold,fsUnderline] else Bt_N2.Font.Style:=[];
    if JN[3]>0 then Bt_N3.Font.Style:=[fsBold,fsUnderline] else Bt_N3.Font.Style:=[];
    if JN[4]>0 then Bt_N4.Font.Style:=[fsBold,fsUnderline] else Bt_N4.Font.Style:=[];
    if JN[5]>0 then Bt_N5.Font.Style:=[fsBold,fsUnderline] else Bt_N5.Font.Style:=[];
    if JN[6]>0 then Bt_N6.Font.Style:=[fsBold,fsUnderline] else Bt_N6.Font.Style:=[];
    if JN[7]>0 then Bt_N7.Font.Style:=[fsBold,fsUnderline] else Bt_N7.Font.Style:=[];
    if JN[8]>0 then Bt_N8.Font.Style:=[fsBold,fsUnderline] else Bt_N8.Font.Style:=[];
    if JN[9]>0 then Bt_N9.Font.Style:=[fsBold,fsUnderline] else Bt_N9.Font.Style:=[];
  End;
end;


//*************************

procedure TJewetForm.Bt_P1Click(Sender: TObject);
var
 MyTreeNode:TTreeNode;
 i:integer;
begin
  MyTreeNode := ReadForm.TreeView1.Items[glob_Jewet_Node];
  i:=-1;
  if sender=Bt_P1 then i:=1;
  if sender=Bt_P2 then i:=2;
  if sender=Bt_P3 then i:=3;
  if sender=Bt_P4 then i:=4;
  if sender=Bt_P5 then i:=5;
  if sender=Bt_P6 then i:=6;
  if sender=Bt_P7 then i:=7;
  if sender=Bt_P8 then i:=8;
  if sender=Bt_P9 then i:=9;
  if i>0 then
    Begin
      PMyRec(MyTreeNode.Data)^.JewettP[i] := glob_Jewet_Sample;
      PMyRec(MyTreeNode.Data)^.JewettPamp[i] := glob_Jewet_Y;  // Add jewet amplitude to MyTreeNode data
      ReadForm.chart1.SeriesList[0].AddXY( glob_Jewet_X, glob_Jewet_Y,intToStr(i));
    End;
  JewetForm.Close;
end;


//*************************

procedure TJewetForm.Bt_N1Click(Sender: TObject);
var
  MyTreeNode:TTreeNode;
  i:integer;
begin
  MyTreeNode := ReadForm.TreeView1.Items[glob_Jewet_Node];
  i:=-1;
  if sender=Bt_N1 then i:=1;
  if sender=Bt_N2 then i:=2;
  if sender=Bt_N3 then i:=3;
  if sender=Bt_N4 then i:=4;
  if sender=Bt_N5 then i:=5;
  if sender=Bt_N6 then i:=6;
  if sender=Bt_N7 then i:=7;
  if sender=Bt_N8 then i:=8;
  if sender=Bt_N9 then i:=9;
  if i>0 then
    Begin
      PMyRec(MyTreeNode.Data)^.JewettN[i] := glob_Jewet_Sample;
      PMyRec(MyTreeNode.Data)^.JewettNamp[i] := glob_Jewet_Y;  // Add jewet amplitude to MyTreeNode data
      ReadForm.chart1.SeriesList[1].AddXY( glob_Jewet_X, glob_Jewet_Y,intToStr(i));
    End;
  JewetForm.Close;
end;



//*************************

procedure TJewetForm.Bt_SaveClick(Sender: TObject);
begin
  if glob_Jewet_Node>0 then ReadForm.SaveJewet(glob_Jewet_Node);
end;


//*************************

procedure TJewetForm.Bt_ClearClick(Sender: TObject);
var
 i:integer;
 MyTreeNode:TTreeNode;
begin
  if MessageDlg('This will delete all Jewett marks on this curve.  Continue?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    MyTreeNode := ReadForm.TreeView1.Items[glob_Jewet_Node];
    for i:=1 to 9 do PMyRec(MyTreeNode.Data)^.JewettN[i] := -1;
    for i:=1 to 9 do PMyRec(MyTreeNode.Data)^.JewettP[i] := -1;
    for i:=1 to 9 do PMyRec(MyTreeNode.Data)^.JewettNAmp[i] := -1000;
    for i:=1 to 9 do PMyRec(MyTreeNode.Data)^.JewettPAmp[i] := -1000;
    JewetForm.Close;
  end;
end;


//*************************

procedure TJewetForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if glob_Jewet_Node>0 then ReadForm.SaveJewet(glob_Jewet_Node);
end;



end.
