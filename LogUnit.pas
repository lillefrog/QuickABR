unit LogUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, TDTUnit, ExtCtrls;

type
  TLogForm = class(TForm)
    RichEdit1: TRichEdit;
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    Button2: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ShowLog(HOpen,HRecord,Hkomment,HAnimal,HSettings,HEquipment,HOther : Boolean; FName:string);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogForm: TLogForm;

implementation

{$R *.DFM}
{$M 16384,10485760}

procedure TLogForm.Button1Click(Sender: TObject);
var
  datafile : textfile;
  i:integer;
begin
savedialog1.FileName := 'LogFile';
if savedialog1.execute then
 Begin
  assignfile(datafile,savedialog1.filename);
  rewrite(datafile);
    for i := 0 to RichEdit1.Lines.Count-1 do        //indholdet af tekstbox
      if RichEdit1.Lines.Strings[i]<>'' then writeln(datafile,RichEdit1.Lines.Strings[i]);
  Closefile(datafile);
 End;
end;



procedure TLogForm.Button2Click(Sender: TObject);
var
HOpen,HRecord,Hkomment,HAnimal,HSettings,HEquipment,HOther : Boolean;
Begin
    HOpen      := not  CheckBox1.Checked;
    HRecord    := not  CheckBox2.Checked;
    Hkomment   := not  CheckBox3.Checked;
    HAnimal    := not  CheckBox4.Checked;
    HSettings  := not  CheckBox5.Checked;
    HEquipment := not  CheckBox6.Checked;
    HOther     := not  CheckBox7.Checked;
    ShowLog(HOpen,HRecord,Hkomment,HAnimal,HSettings,HEquipment,HOther,'');
end;



procedure TLogForm.ShowLog(HOpen,HRecord,Hkomment,HAnimal,HSettings,HEquipment,HOther : Boolean; FName:string);
var
  F : textfile;
  S : string;
  I,K:integer;
begin
 RichEdit1.Clear;
 If FName='' then assignfile(F,Glob_Log_File) else assignfile(F,FName);
 reset(F);
    while not EOF(F)  do
    Begin
      readLn(F,S);

      RichEdit1.SelStart:=Length(RichEdit1.Text);
      i:= RichEdit1.SelStart;
      K:=RichEdit1.Lines.Add(s);
      RichEdit1.SelStart:=i;
      RichEdit1.SelLength := Length(s);

      If ((pos('[Start LogFile]',S))>0) then  RichEdit1.SelAttributes.Style := [fsBold] ;
      If ((pos('[Start Baseline]',S))>0) then  RichEdit1.SelAttributes.Style := [fsBold] ;
      If ((pos('{OPEN}',S))>0) then  RichEdit1.SelAttributes.Color := clBlue ;
      If ((pos('{EXIT}',S))>0) then  RichEdit1.SelAttributes.Color := clBlue ;
      If ((pos('{R}',S))>0) then  RichEdit1.SelAttributes.Color := clRed ;

      If Hopen  AND ((pos('{OPEN}',S))>0) then  RichEdit1.Lines.Delete(k) ;
      If Hopen  AND ((pos('{EXIT}',S))>0) then  RichEdit1.Lines.Delete(k) ;
      If HRecord  AND ((pos('{R}',S))>0)  then  RichEdit1.Lines.Delete(k) ;
      If Hkomment  AND ((pos('{K}',S))>0)  then  RichEdit1.Lines.Delete(k) ;
      If HAnimal  AND ((pos('{A}',S))>0)  then  RichEdit1.Lines.Delete(k) ;

      If HSettings  AND ((pos('{Set}',S))>0)  then  RichEdit1.Lines.Delete(k) ;
      If HEquipment AND ((pos('{E}',S))>0)  then  RichEdit1.Lines.Delete(k) ;
      If HOther AND ((pos('{O}',S))>0)  then  RichEdit1.Lines.Delete(k) ;
    end;
 Closefile(F);
end;



procedure TLogForm.FormShow(Sender: TObject);
begin
  Button2Click(Sender);
end;

end.
