unit KalibUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,TDTUnit, ExtCtrls, TeEngine, Series, TeeProcs, Chart, ComCtrls, INIFiles, ABR;

type
  TKalibForm = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    SaveDialog1: TSaveDialog;
    Chart1: TChart;
    Series1: TLineSeries;
    TabSheet1: TTabSheet;
    ComboBox1: TComboBox;
    Button4: TButton;
    Bt_calibM: TButton;
    TabSheet2: TTabSheet;
    CBox_base: TComboBox;
    Label5: TLabel;
    TabSheet3: TTabSheet;
    PageControl1: TPageControl;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Bt_Apply: TButton;
    TabSheet4: TTabSheet;
    Label15: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    CBox_dB: TComboBox;
    CBox_freq: TComboBox;
    Bt_stop: TButton;
    Bt_start: TButton;
    GroupBox1: TGroupBox;
    dB_label: TLabel;
    Button6: TButton;
    Button5: TButton;
    GroupBox4: TGroupBox;
    Edit6: TEdit;
    UpDown1: TUpDown;
    Bt_Apply2: TButton;
    Memo2: TMemo;
    TabSheet5: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Button7: TButton;
    Memo5: TMemo;
    Label12: TLabel;
    Button8: TButton;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    Memo6: TMemo;
    Memo7: TMemo;
    Button9: TButton;
    Memo8: TMemo;
    Timer3: TTimer;
    Button10: TButton;
    Button11: TButton;
    Edit7: TEdit;
    Button12: TButton;
    Label13: TLabel;
    Button13: TButton;
    Bt_test_click: TButton;
    PageControl2: TPageControl;
    TabSheet8: TTabSheet;
    Chart2: TChart;
    TabSheet9: TTabSheet;
    Chart3: TChart;
    LineSeries1: TLineSeries;
    Series2: TLineSeries;
    Label14: TLabel;
    ComboBox2: TComboBox;
    Bt_clickTest: TButton;
    Edit8: TEdit;
    Label16: TLabel;
    Button14: TButton;
    procedure Bt_startClick(Sender: TObject);
    procedure Bt_stopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Bt_calibMClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Bt_ApplyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Bt_Apply2Click(Sender: TObject);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Bt_test_clickClick(Sender: TObject);
    procedure Bt_clickTestClick(Sender: TObject);
    procedure Button14Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  KalibForm: TKalibForm;
  Glob_kalib_stim : single;
  Glob_counter : integer;
  Glob_Kalib_channel : integer;
  Glob_KalibPath : string;
  Glob_Error:integer;
  Glob_Error_string: string;
  stepsize  :  integer;

 Kalib_Start_Freq  :  integer;//      Starting freq
 Kalib_End_Freq    :  integer; //      End Frequency / 100
 Kalib_stepsize1   :  integer; // Freqyency stepsize / 100
 Kalib_stepsize2   :  integer;
 Kalib_ChangeStepsize :  integer;
 Kalib_ScaleFactor : single;


implementation

{$R *.DFM}
{$M 16384,10485760}



  {** Load Settings **}
procedure GetSettings();
var
  MyINI: TINIFile;
  Path: String;
Begin
 Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 MyINI := TINIFile.create(path+'settings.ini');
   Kalib_Start_Freq     :=   MyINI.ReadInteger('KalibSetup','Start_Freq',200);
   Kalib_End_Freq       :=   MyINI.ReadInteger('KalibSetup','End_Freq',8000);
   Kalib_stepsize1      :=   MyINI.ReadInteger('KalibSetup','stepsize1',100);
   Kalib_stepsize2      :=   MyINI.ReadInteger('KalibSetup','stepsize2',200);
   Kalib_ChangeStepsize :=   MyINI.ReadInteger('KalibSetup','ChangeStepsize',1000);
   Kalib_ScaleFactor    :=   MyINI.ReadFloat('KalibSetup','ScaleFactor',0);
 MyINI.free;
end;



  {** Save Settings **}
procedure SaveSettings();
var
  MyINI: TINIFile;
  Path: String;
Begin
 Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 MyINI := TINIFile.create(path+'settings.ini');
   MyINI.WriteInteger('KalibSetup','Start_Freq',Kalib_Start_Freq);
   MyINI.WriteInteger('KalibSetup','End_Freq',Kalib_End_Freq);
   MyINI.WriteInteger('KalibSetup','stepsize1',Kalib_stepsize1);
   MyINI.WriteInteger('KalibSetup','stepsize2',Kalib_stepsize2);
   MyINI.WriteInteger('KalibSetup','ChangeStepsize',Kalib_ChangeStepsize);
   MyINI.WriteFloat('KalibSetup','ScaleFactor',Kalib_ScaleFactor);
   MyINI.WriteInteger('KalibSetup','KlikAmp',Glob_klik_Amp);
 MyINI.free;
end;





procedure TKalibForm.Bt_startClick(Sender: TObject);
var
  Freq,tone:single;
   kanal:integer;
begin
Freq:= strtofloat(CBox_freq.Text);
tone:= strtofloat(CBox_dB.Text);
kanal:=StrToInt(combobox2.text);
TDTForm.TDTTestKal(Freq,tone,kanal);
Timer1.tag:=3;
timer1.Enabled:=true;
end;


procedure TKalibForm.Bt_stopClick(Sender: TObject);
begin
 TDTForm.SaveLogFile('{Set} Level found = '+ dB_label.Caption);
 timer1.Enabled:=false;
 TDTForm.TDTCalibrate(1000,-1000,1); //Reset the sound
 dB_label.Caption:= '-,- dB';
 label15.Caption:= '-,- dB';
end;




procedure TKalibForm.Timer1Timer(Sender: TObject);
var
db:single;
begin
  If Timer1.tag=1 then
    Begin
      db:=TDTForm.Get_dB_from_TDT();
      db_label.Caption:= floattostrF(db,fffixed,4,1) + ' dB';
    End;
  If Timer1.tag=2 then
    Begin
      db:=TDTForm.Get_dB_from_TDT();
      label12.Caption:= floattostrF(db,fffixed,4,1) + ' dB';
    End;
  If Timer1.tag=3 then
    Begin
      db:=TDTForm.Get_dB_from_TDT();
      label15.Caption:= floattostrF(db,fffixed,4,1) + ' dB';
    End;
end;



procedure TKalibForm.Button1Click(Sender: TObject);
var
base:integer;
begin
 Glob_Error:=0;
 Glob_Error_string:='Not verified at frequencies: ';
 base:= strtoint(CBox_base.text) ;
 memo1.Clear;
 Memo1.Lines.Add('"Freq";"Left";"Right"');
 Memo1.Lines.Add('Custom Calibration 01');
 Label2.Caption:='';
 Label3.Caption:='';
 Label4.Caption:='Errors  0';
 Chart1.SeriesList[0].clear;
 Glob_counter:=0;
 Timer2.Tag:=Kalib_Start_Freq;
 Timer2.Enabled:=true;
 TDTForm.TDTCalibrate(Kalib_Start_Freq,base,Glob_Kalib_channel);
end;


procedure TKalibForm.Timer2Timer(Sender: TObject);
var
db:single;
i,base:integer;
go : boolean;
datafile : textfile;
begin
  go:=false;
  base:= strtoint(CBox_base.text) ;
  i:=timer2.Tag;
  db:=TDTForm.Get_dB_from_TDT();
  label12.Caption:= floattostrF((db),fffixed,4,1) + ' dB';
  if (sqr(base-db)<1) then go:=true else Glob_kalib_stim:= (base+Glob_kalib_stim)-dB;

  if (((base+Glob_kalib_stim)>100) or (Glob_counter>10)) then begin
    go:=true;
    inc(Glob_Error);
    TDTForm.PM2_on(true);
    label4.Caption:= 'Error (Not Verified) = '+inttostr(Glob_Error);
    Glob_Error_string:= Glob_Error_string+IntToStr(i)+'; ';
  end;
  label2.Caption:=inttostr(glob_counter);
  label3.Caption:=floattostr(Glob_kalib_stim);

  if go then begin
    Memo1.Lines.Add(inttostr(i)+';'+floattostrF((base+Glob_kalib_stim-db),fffixed,4,2) + ';'+floattostrF((base+Glob_kalib_stim-db),fffixed,4,2));
    Chart1.SeriesList[0].AddXY(i,(base+Glob_kalib_stim-db));
    stepsize:= Kalib_stepsize1;
    If timer2.tag>=Kalib_ChangeStepsize then stepsize:=Kalib_stepsize2;
    timer2.Tag:=timer2.Tag + stepsize ;    //stepsize
    Glob_kalib_stim:=0;
    Glob_counter:=0;
    label3.Caption:=floattostr(Glob_kalib_stim);
  end;

  inc(Glob_counter);

  If (timer2.Tag>=(Kalib_End_Freq+1)) then begin       // (Maximum frequency to test divided by 100 )+1
    timer2.Enabled:=false;
    TDTForm.TDTCalibrate(1000,-1000,Glob_Kalib_channel); //silence ???
    //save file
      //assignfile(datafile,Glob_KalibPath+'_Ch'+inttostr(Glob_Kalib_channel));
      //rewrite(datafile);
      //for i := 0 to memo1.Lines.Count-1 do writeln(datafile,Memo1.Lines.Strings[i]);
      //Closefile(datafile);
    //Save File end
  {  if Glob_Kalib_channel<11 then begin  //if there are more channels
      inc(Glob_Kalib_channel);
      TDTForm.Set_PM2(Glob_Kalib_channel);
      timer2.Tag:=Kalib_Start_Freq;
      TDTForm.PM2_on(true);
       Memo1.Clear;
       Memo1.Lines.Add('"Freq";"Left";"Right"');
       Memo1.Lines.Add('Højtaler '+inttostr(Glob_Kalib_channel+1));
      timer2.Enabled:=true;
    end else begin  }
                MessageBeep(MB_ICONASTERISK);
                if Glob_Error>0 then Showmessage(Glob_Error_string);
                if Glob_Error>0 then TDTForm.SaveLogFile('{Set} '+ Glob_Error_string);
                //end; //The end
  end
    else begin
    i:=timer2.Tag;
    TDTForm.TDTCalibrate(i,base+Glob_kalib_stim,Glob_Kalib_channel);
    end;
end;


{** Stop Calibration **}
procedure TKalibForm.Button2Click(Sender: TObject);
begin
  Timer2.Enabled:=false;
  TDTForm.TDTCalibrate(1000,-1000,Glob_Kalib_channel);
end;



procedure TKalibForm.Button3Click(Sender: TObject);
var
datafile : textfile;
i:integer;
begin
if savedialog1.execute then
 Begin
  if Memo1.Lines.Strings[1]='Custom Calibration 01' then Memo1.Lines.Strings[1]:= ExtractFileName(savedialog1.FileName);
  assignfile(datafile,savedialog1.filename);                                                   
  rewrite(datafile);
    for i := 0 to memo1.Lines.Count-1 do        //indholdet af tekstbox
      if Memo1.Lines.Strings[i]<>'' then writeln(datafile,Memo1.Lines.Strings[i]);
  Closefile(datafile);
  TDTForm.SaveLogFile('{Set} Calibration data saved: '+savedialog1.filename);
 End;
end;



procedure TKalibForm.Button4Click(Sender: TObject);
var
fejl:integer;
kanal:integer;
begin
 kanal:=strtoint(Combobox1.Text);
 fejl:=TDTForm.Set_PM2(kanal);
 if not(fejl=1) then showmessage('Bad Channel');
end;

procedure TKalibForm.Bt_calibMClick(Sender: TObject);
var
base:integer;
begin
if savedialog1.execute then
 Begin
  Glob_Kalib_channel:=0;
  Glob_Error:=0;
  base:= strtoint(CBox_base.text) ;
  TDTForm.TDTCalibrate((Kalib_Start_freq),base,Glob_Kalib_channel);
  TDTForm.Set_PM2(Glob_Kalib_channel);
  Glob_KalibPath:= savedialog1.filename;
  Timer2.Tag:= Kalib_Start_freq;
  Timer2.Enabled:=true;
   Memo1.Clear;
   Memo1.Lines.Add('"Freq";"Left";"Right"');
   Memo1.Lines.Add('Højtaler '+inttostr(Glob_Kalib_channel+1));
 end;
end;




procedure TKalibForm.FormCreate(Sender: TObject);
begin
GetSettings();
//Glob_kanal:=20;
label4.Caption:= 'Errors  0';
 Edit1.text:= IntToStr(Kalib_Start_Freq);
 Edit2.text:= IntToStr(Kalib_End_Freq);
 Edit3.text:= IntToStr(Kalib_stepsize1);
 Edit5.text:= IntToStr(Kalib_stepsize2);
 Edit4.text:= IntToStr(Kalib_ChangeStepsize);
 Edit6.text:= FloatToStrF(Kalib_ScaleFactor,ffFixed,4,1);
 Tabsheet1.TabVisible:= False;
 //Tabsheet6.TabVisible:= False;
end;

procedure TKalibForm.FormActivate(Sender: TObject);
begin
KalibForm.Caption:='KalibForm    (' + TDTForm.Kalib_Name(false)+')';
Edit7.Text:= IntToStr(Glob_Klik_Amp);
If form1.Visible=true then form1.Visible:=false;
end;



procedure TKalibForm.Bt_ApplyClick(Sender: TObject);
begin
 try
   Kalib_Start_Freq  := StrToInt(Edit1.text);   //      Starting freq
   Kalib_End_Freq    := StrToInt(Edit2.text);   //      End Frequency / 100
   Kalib_stepsize1   := StrToInt(Edit3.text);   // Freqyency stepsize / 100
   Kalib_stepsize2   := StrToInt(Edit5.text);
   Kalib_ChangeStepsize := StrToInt(Edit4.text);
   Glob_Kalib_channel     := StrToInt(Combobox2.Text);

   TDTForm.SaveLogFile('{Set} New Calibration settings: Start_Freq='+Edit1.text+' End_Freq='+Edit2.text+
                        ' stepsize1='+Edit3.text+' stepsize2='+Edit5.text+' ChangeStepsize='+Edit4.text+' Level='+CBox_base.Text+' Channel='+Combobox2.Text);
 except
  on EConvertError do showmessage('Not A number');
 end;
 if Kalib_Start_Freq >= Kalib_End_Freq then
        Begin
          Showmessage('Stop frequency has to be larger than Start Frequency');
          Kalib_End_Freq:= Kalib_Start_Freq + 1000;
          Edit2.text:= IntToStr(Kalib_End_Freq);
        end;
end;



procedure TKalibForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 SaveSettings();
 If form1.Visible=False then form1.Visible:=True;
end;



procedure TKalibForm.FormDestroy(Sender: TObject);
begin
 SaveSettings();
end;


procedure TKalibForm.Bt_Apply2Click(Sender: TObject);
var
 factor: double;
begin
 factor := Kalib_ScaleFactor;
 Try
   factor:= StrToFloat(Edit6.Text);
 except
  on EConvertError do showmessage('Not A number');
 end;
    if MessageDlg('This setting is only used to compensate for different microphones.'+#13+
           'If you did not change the microphone you should not need this!'+#13+
           'are you sure you want to continue?',
           mtWarning , [mbYes, mbNo], 0) = mrYes then
    Begin
      Kalib_ScaleFactor:=factor;
      TDTForm.TDTSetScaleFactor(Kalib_ScaleFactor);
      TDTForm.SaveLogFile('{Set} Microphone Scale Factor set to = '+FloatToStrF(Kalib_ScaleFactor,fffixed,2,2 ));
    end;
end;





procedure TKalibForm.UpDown1ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
var
 factor: single;
begin
 factor:=Kalib_ScaleFactor;
 Try
   factor:= StrToFloat(Edit6.Text);
 except
  on EConvertError do showmessage('Not A number');
 end;

  if Direction=updUp then factor:=factor+0.1;
  if Direction=updDown then factor:=factor-0.1;
  Edit6.text:= FloatToStrF(Factor,ffFixed,4,1);
end;

procedure TKalibForm.Button5Click(Sender: TObject);
begin
 TDTForm.SaveLogFile('{Set} Start test Microphone ');
 TDTForm.TDTCalibrate(1000,-1000,Glob_Kalib_channel);
 timer1.Enabled:=true;
 Timer1.tag:=1;

end;

procedure TKalibForm.Button7Click(Sender: TObject);
begin
  TDTForm.Button2Click(Sender);
  KalibForm.Caption:='KalibForm    (' + TDTForm.Kalib_Name(false)+')';
end;

procedure TKalibForm.Button8Click(Sender: TObject);
begin
 TDTForm.SaveLogFile('{Set} Start test Acceleration ');
 TDTForm.TDTCalibrate(159.15,-1000,Glob_Kalib_channel);
 timer1.Enabled:=true;
 Timer1.tag:=1;
end;


procedure TKalibForm.Button13Click(Sender: TObject);
begin
 TDTForm.SaveLogFile('{Set} Start test Hydrophone ');
 TDTForm.TDTCalibrate(250,-1000,Glob_Kalib_channel);
 timer1.Enabled:=true;
 Timer1.tag:=1;
end;


procedure TKalibForm.Button9Click(Sender: TObject);
begin
 memo8.Clear;
 Memo8.Lines.Add('"Freq";"Noise"');
 Memo8.Lines.Add('Noise Measurement 01');

 Chart1.SeriesList[0].clear;
 Timer3.Tag:=Kalib_Start_Freq;
 Timer3.Enabled:=true;
 TDTForm.TDTCalibrate(Kalib_Start_Freq,-1000,Glob_Kalib_channel);
end;



procedure TKalibForm.Timer3Timer(Sender: TObject);
var
 dB : double;
 i : integer;
begin
  i:=timer3.Tag;
  timer3.Enabled:=false;
  db:=TDTForm.Get_dB_from_TDT();
  Memo8.Lines.Add(inttostr(i)+';'+floattostrF((db),fffixed,4,2));
  Chart1.SeriesList[0].AddXY(i,db);

    stepsize:= Kalib_stepsize1;
    If timer3.tag>=Kalib_ChangeStepsize then stepsize:=Kalib_stepsize2;
    timer3.Tag:=timer3.Tag + stepsize ;    //stepsize

  If (timer3.Tag>=(Kalib_End_Freq+1)) then begin       // (Maximum frequency to test divided by 100 )+1
    timer3.Enabled:=false;
    TDTForm.TDTCalibrate(1000,-1000,Glob_Kalib_channel); //silence ???
    MessageBeep(MB_ICONASTERISK);   // The End
  end
    else begin
    i:=timer3.Tag;
    timer3.Enabled:=true;
    TDTForm.TDTCalibrate(i,-1000,Glob_Kalib_channel);
    end;
end;



procedure TKalibForm.Button10Click(Sender: TObject);
var
  datafile : textfile;
  i:integer;
begin
savedialog1.FileName := 'Noise Measurement';
if savedialog1.execute then
 Begin
  assignfile(datafile,savedialog1.filename);
  rewrite(datafile);
    for i := 0 to memo8.Lines.Count-1 do        //indholdet af tekstbox
      if Memo8.Lines.Strings[i]<>'' then writeln(datafile,Memo8.Lines.Strings[i]);
  Closefile(datafile);
  TDTForm.SaveLogFile('{Set} Noise data saved '+savedialog1.filename);
 End;
end;


procedure TKalibForm.Button11Click(Sender: TObject);
begin
  Timer3.Enabled:=false;
  TDTForm.TDTCalibrate(1000,-1000,Glob_Kalib_channel);
end;

// click calibration > Apply
procedure TKalibForm.Button12Click(Sender: TObject);
var
  KlikAmp:integer;
  KlikCorrection:double;
begin
 KlikAmp:=Glob_Klik_Amp;
 Try
   KlikAmp:= StrToInt(Edit7.Text);
   KlikCorrection:= StrTofloat(Edit8.Text);
   if klikAmp>200 then showmessage('Are you crasy?'+#13+'That is a way to much');
   if TDTForm.TDTSet_Klik_Amp(KlikAmp) then Showmessage('Amp set to '+ IntToStr(KlikAmp));
   TDTForm.SaveLogFile('{Set} KlikAmp set to = '+IntToStr(KlikAmp));
   TDTForm.TDTSet_Klik_Correction(KlikCorrection); // set click calibration level (does not save result)
   TDTForm.SaveLogFile('{Set} KlikCorrection set to = '+FloatToStr(KlikAmp));
 except
  on EConvertError do showmessage('Not A Integer');
 end;

end;





procedure TKalibForm.Bt_test_clickClick(Sender: TObject);
begin
 Glob_Test_Click:=true;
 Form1.ButtonTestClick(Sender);
end;

procedure TKalibForm.Bt_clickTestClick(Sender: TObject);
begin
//Set TDT


end;

procedure TKalibForm.Button14Click(Sender: TObject);
begin
// here we need to save the stimulus so the calibraion is stored
ShowMessage('sorry dave I can not do that');
end;

end.
