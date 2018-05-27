unit ReadSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, commonUnit, ExtCtrls;

type TGraphSettings = Record
  ShowBuffers  :Boolean;
  Show_inverted:Boolean;
  Offset       :Integer ;
  FromSample   :Integer;
  ToSample     :Integer;
  Filter_freq  :Integer;
  PPFromSample   :Integer;  //Analyze from
  PPToSample     :Integer;  //Analyze to
  CurveDistance:Double ;
  SampleRate   :Single ;
  TotalSamples :Integer;
  ID           :String;  // Identifier for the curve
  Show_Jewet   :Boolean;
end;

type
  TReadSettingsForm = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Bt_Cancel: TButton;
    ScrollBar1: TScrollBar;
    Label1: TLabel;
    Label4: TLabel;
    ComboBox1: TComboBox;
    ScrollBar2: TScrollBar;
    ScrollBar6: TScrollBar;
    Label9: TLabel;
    ScrollBar5: TScrollBar;
    Label10: TLabel;
    Label11: TLabel;
    Bt_Apply: TButton;
    Bt_SetToDefault: TButton;
    CheckBox3: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure Bt_CancelClick(Sender: TObject);
    procedure UpdateSettingsForm(Sender:Tobject; Sett:TGraphSettings);
    procedure SettingsChanged(Sender: TObject);
    procedure Bt_ApplyClick(Sender: TObject);
    procedure Bt_SetToDefaultClick(Sender: TObject);
    
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReadSettingsForm : TReadSettingsForm;
  

implementation

uses ReadUnit2, ReadUnit;

var
 Local_Settings   :TGraphSettings;
 Current_Sender   : Tobject;




{$R *.DFM}


Procedure initGraphSettings(var Settings:TGraphSettings);
Begin
 with Settings do
  Begin
   SampleRate    := 24414;
   TotalSamples  := 500;
   Offset        :=0;
   ShowBuffers   :=True;
   Show_inverted :=False;
   FromSample    :=0;
   ToSample      :=500;
   Filter_freq   :=-1;
   PPFromSample  :=0;
   PPToSample    :=500;
   CurveDistance :=0;
   Show_Jewet    :=False;
  end;
end;



procedure TReadSettingsForm.FormCreate(Sender: TObject);
begin
 initGraphSettings(Local_Settings);
end;


{**  Close without saving  **}
procedure TReadSettingsForm.Bt_CancelClick(Sender: TObject);
begin
 ReadSettingsForm.Close;
end;



 {** Update labels and check that values are legal **}
procedure TReadSettingsForm.SettingsChanged(Sender: TObject);
var
  tid1,tid2:single;
begin
  if ScrollBar1.Position > ScrollBar2.Position-1 then  ScrollBar1.Position:=ScrollBar2.Position-1;

   tid1 := (ScrollBar1.Position/(Local_Settings.SampleRate/1000));
   tid2 := (ScrollBar2.Position/(Local_Settings.SampleRate/1000));
  Label4.Caption:= 'From Time: '+ FloatToStrF(tid1,ffFixed,6,1) +' ms';
  Label1.Caption:= 'To Time: '+ FloatToStrF(tid2,ffFixed,6,1) +' ms';

  if ScrollBar5.Position > ScrollBar6.Position-1 then  ScrollBar5.Position:=ScrollBar6.Position-1;
   tid1 := (ScrollBar5.Position/(Local_Settings.SampleRate/1000));
   tid2 := (ScrollBar6.Position/(Local_Settings.SampleRate/1000));
  Label10.Caption:= 'From Time: '+ FloatToStrF(tid1,ffFixed,6,1) +' ms';
  Label9.Caption:= 'To Time: '+ FloatToStrF(tid2,ffFixed,6,1) +' ms';
  Bt_Apply.Enabled:=true;
end;



 {** Sets the Labels **}
procedure TReadSettingsForm.UpdateSettingsForm(Sender:Tobject; Sett:TGraphSettings);
begin
  {Check if input is legal}
    if Sett.SampleRate<1 then Sett.SampleRate:=24414;
    if Sett.TotalSamples < 10 then
    begin
      Sett.TotalSamples:=10;
      Showmessage('Error in ReadSettingsForm.UpdateSettingsForm: No data');
    end;
    if Sett.FromSample > Sett.TotalSamples then Sett.FromSample:=0;
    if Sett.ToSample   > Sett.TotalSamples then Sett.FromSample:=Sett.TotalSamples;
    if Sett.PPFromSample > Sett.TotalSamples then Sett.PPFromSample:=0;
    if Sett.PPToSample   > Sett.TotalSamples then Sett.PPToSample:=Sett.TotalSamples;
  {/Check if input is legal}
  {Initalize Form}
     Scrollbar1.Max:= Sett.TotalSamples;
     Scrollbar2.Max:= Sett.TotalSamples;
     Scrollbar5.Max:= Sett.TotalSamples;
     Scrollbar6.Max:= Sett.TotalSamples;
     Scrollbar1.Position:=   Sett.FromSample;
     Scrollbar2.Position:=   Sett.ToSample;
     ComboBox1.Text     :=   FloatToStrF(Sett.CurveDistance ,ffFixed,2,2);
     Scrollbar6.Position:=   Sett.PPToSample;
     Scrollbar5.Position:=   Sett.PPFromSample;     // has to be in this order (Strange)
     CheckBox1.Checked  :=   Sett.Show_inverted;
     CheckBox2.Checked  :=   Sett.ShowBuffers;
     CheckBox3.Checked  :=   Sett.Show_Jewet;
  {/Initalize Form}
  {Set Variables}
     Current_Sender:=  Sender;
     Local_Settings:=Sett;
  {/Set Variables}
end;



 {**  Apply settings and close form  **}
procedure TReadSettingsForm.Bt_ApplyClick(Sender: TObject);
var
  Sett:TGraphSettings;
begin
  Sett:=Local_Settings;

  Sett.FromSample       :=Scrollbar1.Position ;
  Sett.ToSample         :=Scrollbar2.Position ;
  Sett.CurveDistance    :=StrToFloat(ComboBox1.Text);
  Sett.PPFromSample     :=Scrollbar5.Position ;
  Sett.PPToSample       :=Scrollbar6.Position ;
  Sett.Show_Jewet       :=CheckBox3.Checked;
  Sett.ShowBuffers      :=CheckBox2.Checked;
  Sett.Show_inverted    :=CheckBox1.Checked;

  if Current_Sender=ReadForm then
    Begin
      ReadForm.SettingsSet(Sett);
      ReadSettingsForm.Close;
      ReadForm.show;
    End;
  if Current_Sender=ReadForm2 then
    Begin
      ReadForm2.SettingsSet(Sett);
      ReadSettingsForm.Close;
      ReadForm2.show;
    End;
   Bt_Apply.Enabled:=False;
end;



 {**  Load Default settings  **}
procedure TReadSettingsForm.Bt_SetToDefaultClick(Sender: TObject);
var
  Sett:TGraphSettings;
begin
  Sett := Local_Settings;   //Begin with the current settings
  Sett.CurveDistance :=1;
  Sett.ShowBuffers   :=True;
  Sett.Show_inverted :=False;
  Sett.FromSample    :=0;
  Sett.ToSample      :=Local_Settings.TotalSamples;
  Sett.PPFromSample  :=0;
  Sett.PPToSample    :=Local_Settings.TotalSamples;
  Sett.Show_Jewet    :=False;
  Local_Settings     :=Sett;   //Save in Local settings
  UpdateSettingsForm(Current_Sender,Sett);
end;





End. // the end
