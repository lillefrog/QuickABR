unit TDTUnit;

interface                                                            

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ZBUSXLib_TLB, OleCtrls, RPCOXLib_TLB, StdCtrls, ComCtrls, ExtCtrls,
  PA5XLib_TLB,math,INIfiles,TDTtreadUnit,TestTreadUnit,commonUnit,abr,FileCtrl,MakeStimUnit, Wav_handler;

const    //tread
  WM_ThreadDoneMsg = WM_User + 8;
  wm_TestThreadDone = WM_User + 9;

type  TDTSignal = array[0..2000] of single;  // must fit TFilterData(filterUnit) and TSubMeas(commonUnit)
type  TSubKalibData2 = Array[1..3] of single;
type  TKalibData = Array of TSubKalibData2;

type
  TTDTForm = class(TForm)
    TreeView1: TTreeView;
    RP1: TRPcoX;
    RP2: TRPcoX;
    RP3: TRPcoX;
    RP4: TRPcoX;
    RP5: TRPcoX;
    RP_SOUND: TRPcoX;
    RP_ABR  : TRPcoX;
    PA5x1: TPA5x;
    PA5x2: TPA5x;
    PA5x3: TPA5x;
    PA5x4: TPA5x;
    PA5x5: TPA5x;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label2: TLabel;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    Label1: TLabel;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    ComboBox2: TComboBox;
    Label4: TLabel;
    ComboBox3: TComboBox;
    Label6: TLabel;
    ComboBox4: TComboBox;
    Label7: TLabel;
    ComboBox5: TComboBox;
    Label8: TLabel;
    Button3: TButton;
    ZBUSx1: TZBUSx;
    Timer1: TTimer;
    Label9: TLabel;
    CheckBox1: TCheckBox;
    Panel2: TPanel;
    ComboBox6: TComboBox;
    Label5: TLabel;
    CheckBox_Invert_click: TCheckBox;
    CheckBox_Save_wav: TCheckBox;


    Function NewLogFile(FName:string):Boolean;
    Function SaveLogFile(MyText:string):Boolean;
    Function kal(freq,kanal:integer; ind:single):single;
    Function kal_click(ind:single):single;
    Function Invkal(freq,kanal:integer; Amp:single):single;
    Function ShowMode(mode:integer):integer;
    function WarningColor(nr:integer):integer;
    Procedure PopulateCBox5();//:integer;
    procedure FormCreate(Sender: TObject);
    Procedure TDTconnect();        // Main connect. Detect all TDT systems and connect to them
    Function Nr_TDT_Connected(RPcoxType:string):integer;
    Function Get_TDT_Sampelrate(st:String):Single;
    Function Get_dB_from_TDT():Single;
    function TDTReset():integer;
    function PM2_on(turn_on:boolean):integer;
    function Set_PM2(kanal:integer):integer;
    Function Kalib_Name(long:boolean):String;
    procedure TDTRecordFast(ABR_Info:TABR_Info);
    procedure TDTTestKal(Freq,tone:single; kanal:integer);
    procedure TDTCalibrate(Freq,Amp:single; kanal:integer);
    procedure Button1Click(Sender: TObject); //Reconnect with TDT
    procedure Button2Click(Sender: TObject); //load kalibration file
    procedure FormDestroy(Sender: TObject);
    Procedure StartThread();
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1Change(Sender: TObject);
    Function  LoadStim(Name:string):boolean;
    procedure ComboBox5Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SetGlobStim(data: TstimFile);
    function TDTSetScaleFactor(ScaleFactor:single):boolean;
    function TDTSet_Klik_Amp(KlikAmp:integer):boolean;
    function TDTSet_Klik_Correction(correction:double):boolean;
    function TDTToneAmpSet(freq:integer; tone:double):boolean;
    procedure Timer1Timer(Sender: TObject);
    procedure TDTRunTest();
    procedure CheckBox1Click(Sender: TObject);
    function TDTSet(ABR_Info:TABR_Info):boolean;
    Procedure ShutUp();
    procedure CheckBox_Invert_clickClick(Sender: TObject);
    procedure CheckBox_Save_wavClick(Sender: TObject);
  private
    { Private declarations }
    MyThread1 : TMyThread; // thread number 1
    MyTestThread1 : TestTread; // thread number 2
    Thread1Active : boolean; // used to test if thread 1 is active
    TestThread1Active : boolean; // used to test if thread 1 is active
    procedure ThreadDone(var AMessage : TMessage); message WM_ThreadDoneMsg; // Message to be sent back from thread when its done
    procedure TestThreadDone(var AMessage : TMessage); message wm_TestThreadDone;

    function TDTRun():boolean;
  public
    { Public declarations }
  end;

Type
  TRPcoxExist = record
    RM2 : Integer;
    RP2 : Integer;
    RA16: Integer;
    RX6 : Integer;
    RX7 : Integer;
    PA5 : Integer;
    INPUT : Integer;
    OUTPUT : Integer;
  End;


var
  TDTForm: TTDTForm;
  RPcoxExist: TRPcoxExist;
  TDTfindes: Boolean;    //Flyttet til ConnonUnit
  

  Kalibreret: boolean;
  KalibData: TKalibData;
  

  Glob_Log_File:string;                  // path to the current logfile
  Glob_Titel: string;                    // title of form1
  Glob_pause: boolean;                   // True when the recording is paused
  Glob_MaxFreq, GLOB_MinFreq :integer;   // The min and max frequency of the calibration
  TDT_KalibFilePath: String;
  TDT_ScaleFactor: single;
  TDT_Max_Output: integer;
  Glob_Peak_reject: double;
  Glob_Stim_file_name:string;
  Glob_klik_Amp: integer;             // Amplitude of the click when masking
  Glob_klik_Freq: integer;
  Glob_TDT_phase:double;              // Starting phase of masker
  Glob_NumberOf_Samples:Integer;     // The number of samples in the recording
  Glob_Directional_ABR:boolean;
  Glob_Invert_Click: boolean;         // invert click if true
  Glob_Save_WavFile: boolean;
  Glob_kanal_ind : integer;
  Glob_kanal_ud : integer;

implementation

var
  Glob_StimFile: TStimFile;
  Local_current_ABR_Info:TABR_Info;
  Local_Nr_TDT_Rejections:integer;



{$R *.DFM}



  {** Load Settings **}
procedure GetSettings();
var
  MyINI: TINIFile;
  Path: String;
  ScaleFactor:single;
Begin
 Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 MyINI := TINIFile.create(path+'settings.ini');
  MyINI.WriteString('TDTSetup','Filnavn',path);
  TDT_KalibFilePath := MyINI.ReadString('TDTSetup','KalibFilePath',path+'default.csv');
  Kalibreret := MyINI.ReadBool('TDTSetup','kalibreret',false);
  Glob_kanal_ud := MyINI.ReadInteger('TDTSetup','kanal_out',1);
  Glob_kanal_ind := MyINI.ReadInteger('TDTSetup','kanal_ind',17);
  Glob_max_avrages := MyINI.ReadInteger('TDTSetup','nAvrages',400);
  Glob_Stim_file_name :=  MyINI.ReadString('TDTSetup','Glob_Stim_file',path+'stim\standart.AB9');
  Glob_klik_Amp :=  MyINI.ReadInteger('KalibSetup','KlikAmp',94);
  Glob_Directional_ABR :=  MyINI.ReadBool('TDTSetup','Directional',True);
  Glob_NumberOf_Samples:= MyINI.ReadInteger('TDTSetup','NumberOf_Samples',2000);
  Glob_Log_File    :=  MyINI.ReadString('TDTSetup','Glob_log_file',path+'standard.log');
  Glob_Peak_reject :=  MyINI.ReadFloat('TDTSetup','Peak_Reject',1);
  ScaleFactor      :=  MyINI.ReadFloat('KalibSetup','ScaleFactor',0);
  Glob_Max_Turns   := round(Glob_max_avrages/8);
  TDT_ScaleFactor:=  48550 * power(10,(ScaleFactor/20));
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
  MyINI.WriteString('TDTSetup','Filnavn',path);
  MyINI.WriteString('TDTSetup','KalibFilePath',TDT_KalibFilePath);
  MyINI.WriteString('TDTSetup','Glob_Stim_file',Glob_Stim_file_name);
  MyINI.WriteString('TDTSetup','Glob_log_file',Glob_log_file);

  MyINI.WriteBool('TDTSetup','kalibreret',Kalibreret);
  MyINI.WriteInteger('TDTSetup','kanal_out',Glob_kanal_ud);
  MyINI.WriteInteger('TDTSetup','kanal_ind',Glob_kanal_ind);
  MyINI.WriteInteger('TDTSetup','nAvrages',Glob_max_avrages);
  MyINI.WriteFloat('TDTSetup','Peak_Reject',Glob_Peak_reject);
  MyINI.WriteBool('TDTSetup','Directional',Glob_Directional_ABR);
  MyINI.WriteInteger('TDTSetup','NumberOf_Samples',Glob_NumberOf_Samples);
 MyINI.free;
end;


Function CleanInt(S:string):string;
var
 i:integer;
 s2:string;
Begin
  s2:='';
  If S='' then S:=' ';
  for i:=0 to length(S) do
    Begin
    case S[i] of
      '-' : s2:=s2+'-';
      '0' : s2:=s2+'0';
      '1' : s2:=s2+'1';
      '2' : s2:=s2+'2';
      '3' : s2:=s2+'3';
      '4' : s2:=s2+'4';
      '5' : s2:=s2+'5';
      '6' : s2:=s2+'6';
      '7' : s2:=s2+'7';
      '8' : s2:=s2+'8';
      '9' : s2:=s2+'9';
      end;
    end;
CleanInt:=s2;
end;


Function CleanFloat(S:string):string;
var
 i,p:integer;
 s2:string;
Begin
  s2:='';
  If S='' then S:=' ';
  p:=0;
  for i:=0 to length(S) do
    Begin
    case S[i] of
      '-' : s2:=s2+'-';
      '0' : s2:=s2+'0';
      '1' : s2:=s2+'1';
      '2' : s2:=s2+'2';
      '3' : s2:=s2+'3';
      '4' : s2:=s2+'4';
      '5' : s2:=s2+'5';
      '6' : s2:=s2+'6';
      '7' : s2:=s2+'7';
      '8' : s2:=s2+'8';
      '9' : s2:=s2+'9';
      '.' : begin s2:=s2+DecimalSeparator; inc(p);  end;
      ',' : begin s2:=s2+DecimalSeparator; inc(p);  end;
      end;
    end;

    if p>1 then
    for i :=0 to p-2 do delete(s2,pos(DecimalSeparator,s2),1);
    if (s2<>'') and (s2[length(s2)]=DecimalSeparator) then delete(s2,length(s2),1);
CleanFloat:=s2;
end;



  {**  get kalibration data from file  **}
procedure LoadKalib(FName:string);
var
  F: TextFile;
  S,S1,S2,S3: string;
  freq,i : integer;
Begin
 if FName='' then FName:=TDT_KalibFilePath;
 If FileExists(FName) then begin
    AssignFile(F, FName);   // File selected in dialog box
    Reset(F);
    Readln(F, S);                          // Read the first line out of the file
    Readln(F, S);
    TDTForm.Caption:=S;
    Glob_Titel:=S;
    GLOB_MaxFreq:=0; GLOB_MinFreq:=10000000;
    i:=0;
    repeat
      Readln(F, S);                        // Put string in a memo control
      S1:=Copy(S,0,pos(';',S)-1);
      Delete(S,1,pos(';',S));
      S2:=Copy(S,0,pos(';',S)-1);
      Delete(S,1,pos(';',S));
      S3:=Copy(S,0,length(S));
      Delete(S,1,pos(';',S));
      freq :=  StrtoInt(CleanInt(S1));  //freq
      If freq > GLOB_MaxFreq then GLOB_MaxFreq := freq;
      If freq < GLOB_MinFreq then GLOB_MinFreq := freq;
       SetLength(kalibData,i+1);
       kalibData[i,1]:=freq;
       kalibData[i,2]:=StrToFloat(CleanFloat(S2));  //right or left
       kalibData[i,3]:=StrToFloat(CleanFloat(S3));
       inc(i);
    until eof(F);
    CloseFile(F);
    Kalibreret:= TRUE;
    TDTForm.SaveLogFile('{Set} calibration Loaded '+FName);
 end else Begin Showmessage('Could not find: '+FName);  TDTForm.SaveLogFile('{Set} !!calibration Failed '+FName); end;
End;




Function StripRpvds(S:string):string;
var
 S2:string;
Begin
 If S[1]='%' then
 Begin
  S2:=S;
  Delete(S2,1,6);
  Result:='('+LowerCase(s2)+')';
 end else Result:=S;
end;



{*****  End of private functions  *****}


{*****  Start of defined functions  *****}


Function  TTDTForm.NewLogFile(FName:string):Boolean;
var
 OldFileName:string;
Begin
  OldFileName:= Glob_Log_File;
  Glob_Log_File:=FName;
  SaveLogFile('{Set} Logfile Changed from '+OldFileName+' to '+ FName);
  result:=true;
end;



Function  TTDTForm.SaveLogFile(MyText:string):Boolean;
var
  F:textfile;
  s,Path:String;
Begin
if DirectoryExists(ExtractFilePath(Glob_Log_File)) then
Begin
  If fileexists(Glob_Log_File) then
    Begin
    AssignFile(F,Glob_Log_File);
     Append(F);
     writeln(F, '  {'+TimeToStr(Time) +'} '+ MyText);
    CloseFile(F);
    Result:=true;
    End else Begin
    AssignFile(F,Glob_Log_File);
     Rewrite(F);
        writeln(F,'[Start Baseline]');
        Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
        writeln(F,' Start = '+ DateTimeToStr(now));
        writeln(F,' Filnavn = '+path);
        writeln(F,' KalibFilePath = '+TDT_KalibFilePath);
        writeln(F,' Glob_Stim_file = '+Glob_Stim_file_name);
        writeln(F,' Glob_log_file = '+Glob_log_file);
        if Kalibreret then S:='True' else S:='False';
        writeln(F,' kalibreret = '+S);
        writeln(F,' kanal_out = '+IntToStr(Glob_kanal_ud));
        writeln(F,' kanal_ind = '+IntToStr(Glob_kanal_ind));
        writeln(F,' nAvrages = '+IntToStr(Glob_max_avrages));
        writeln(F,' Peak_Reject = '+FloatToStr(Glob_Peak_reject));
        writeln(F,' KlikAmp = '+ IntToStr(Glob_klik_Amp));
        writeln(F,'[Start LogFile] ' + TimeToStr(Time));
        If mytext<>'' then writeln(F, '  {'+TimeToStr(Time) +'} '+ MyText);
    CloseFile(F);
    Result:=true;
    end;
end else begin
                Showmessage('Logfile not found, locate one or make a new one');
                Form1.NewLogfile1Click(TDTForm);
                Result:=true;
                end;
end;





  {**  kalibrate data  **}
Function TTDTForm.kal(freq,kanal:integer; ind:single):single;
var
 MydB,x,y:double;
 i:integer;
 stop:boolean;
Begin
  If not(freq>GLOB_MaxFreq) or (freq<GLOB_MinFreq) then
  Begin
    If not((kanal=1) or (kanal=2)) then Showmessage('Use only Channel 1 or 2');
    stop:= false;
    i:=0; mydb:=0;
    repeat
      if KalibData[i,1]= freq then
         Begin
           MydB:= ind + KalibData[i,1+kanal];
           stop:= true;
         end;
      if KalibData[i,1]> freq then
         Begin
           x:= freq - KalibData[i-1,1];
           y:= KalibData[i,1] - freq;
           MydB:= ind + (KalibData[i-1,1+kanal]*y/(x+y)  +  KalibData[i-1,1+kanal]*x/(x+y) ) ;
           stop:= true;
         end;
      inc(i);
    until stop;
    if MydB > 900 then showmessage('MydB overload '+floatToStr(MydB));
  end else Begin
    Showmessage('outside kalibratet area '+inttostr(freq)+'Hz');
    if button4.Caption='Pause' then Button4.Click;
    MydB:=ind;
  end;
  kal:=0.1*Power(10,(MydB-94)/20);
end;

 {**  kalibrate Click  **}
Function TTDTForm.kal_click(ind:single):single;
var
 MydB:double;
Begin
  MydB:= ind + Glob_StimFile.correction;
  kal_click:=0.1*Power(10,(MydB-94)/20);
end;


  {**  Inverse Calibration  **}
Function TTDTForm.Invkal(freq,kanal:integer; Amp:single):single;
var
 MydB,x,y,AmpdB:double;
 i:integer;
 stop:boolean;
Begin
  AmpdB:= 20*log10(10*Amp)+94;
  If not(freq>GLOB_MaxFreq) or (freq<GLOB_MinFreq) then
  Begin
    If not((kanal=1) or (kanal=2)) then Showmessage('Use only Channel 1 or 2');
    stop:= false;
    i:=0; mydb:=0;
    repeat
      if KalibData[i,1]= freq then
         Begin
           MydB:= AmpdB + KalibData[i,1+kanal];
           stop:= true;
         end;
      if KalibData[i,1]> freq then
         Begin
           x:= freq - KalibData[i-1,1];
           y:= KalibData[i,1] - freq;
           MydB:= AmpdB + (KalibData[i-1,1+kanal]*y/(x+y)  +  KalibData[i-1,1+kanal]*x/(x+y) ) ;
           stop:= true;
         end;
      inc(i);
    until stop;
    //if MydB > 300 then showmessage('MydB overload '+floatToStr(MydB));
  end else Begin
    Showmessage('outside kalibratet area '+inttostr(freq)+'Hz');
    MydB:=AmpdB;
  end;
  Result:=MydB;

end;



{** Changes from Record-mode to Setup Mode **}
Function TTDTForm.ShowMode(mode:integer):integer;
begin
 If mode=1 then    //Setup Mode
   begin
     TDTForm.ClientHeight:=507;    //380
     TDTForm.Button1.Visible   := True;
     TDTForm.Button2.Visible   := True;
     TDTForm.Button4.Visible   := False;
     TDTForm.TreeView1.Visible := True;
     TDTForm.ProgressBar1.Visible:=False;
     TDTForm.ProgressBar2.Visible:=False;
     TDTForm.Label2.Visible:=False;
     TDTForm.Caption:=Glob_Titel;
     TDTForm.Panel1.Visible:= True;
   End;

 If mode=2 then    //Record Mode
   begin
     TDTForm.Button1.Visible   := False;
     TDTForm.Button2.Visible   := False;
     TDTForm.Button4.Visible   := True;
     TDTForm.TreeView1.Visible := False;
     TDTForm.ProgressBar1.Visible:=TRUE;
     TDTForm.ProgressBar2.Visible:=TRUE;
     TDTForm.Label2.Visible:=TRUE;
     TDTForm.Panel1.Visible:= False;
     If TDTForm.Caption=Glob_Titel then TDTForm.Caption:='Recording';
     TDTForm.ClientHeight:=75;
   End;
 Showmode:=mode;
end;



Procedure TTDTForm.PopulateCBox5();
var
  Path,S: String;
  F: TSearchRec;
begin
  ComboBox5.Items.Clear;
  Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
  path:= path+'stim\';
  //StimFilePath:=path;  // Global variable
  if not DirectoryExists(path) then CreateDir(path);
  path:= path+'*.AB9';
  FindFirst(path,faReadOnly,F);
  ComboBox5.Items.Add(copy(F.Name,0,pos('.',F.Name)-1));
  while FindNext(F) = 0 do Begin
    S:= copy(F.Name,0,pos('.',F.Name)-1);
    if S<>'standart' then ComboBox5.Items.Add(S);
  end;
end;



{** Form Create **}
procedure TTDTForm.FormCreate(Sender: TObject);
var
FileNotFound:boolean;
Begin
 Glob_TDT_phase:=0;
 Glob_Invert_Click:=True;
 Local_Nr_TDT_Rejections:=0;
 GetSettings();
 TDTconnect();
 LoadKalib(TDT_KalibFilePath);
 Glob_pause:=False;
  ComboBox1.Text:= inttostr(Glob_max_avrages);
  ComboBox2.Text:= inttostr(Glob_kanal_ud);
  ComboBox3.Text:= inttostr(Glob_kanal_ind);
  ComboBox4.Text:= FloatToStrF(Glob_Peak_reject,ffGeneral,4,5);
  ComboBox6.Text:= IntToStr(Glob_NumberOf_Samples);
  CheckBox1.Checked:= Glob_Directional_ABR;
  PopulateCBox5();
  MakeStimForm.Load_Stim_silent(Glob_Stimfile, Glob_Stim_file_name , FileNotFound );

  If filenotfound then Showmessage('no standart stimulus was found') else ComboBox5.Text := copy(Glob_Stim_file_name,0,pos('.',Glob_Stim_file_name)-1);
  TDTCalibrate(1000,-1000,1);
  TDTForm.SaveLogFile('{OPEN} ' + DateToStr(now));
End;



{Denne Procedure forbinder til TDT systemerne og viser dem i Treeview}
Procedure TTDTForm.TDTconnect();
var
 MyNode1: TTreeNode;
 j,RP_Nr,PA5_Nr,RP_index : integer;
 S,path : string;
 RcoNavn: String;
 RPcox: array[1..5] of TRPcoX;
 PA5  : array[1..5] of TPA5x;
 SampelRate:single;
Begin
{Initialisere variable}
  Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
  RcoNavn:= Path+'ABR11_CB';               { <-- important filename -- }
  TDT_Max_Output:= 10;                  // Max alloved output from TDT system
  RPcoxExist.RM2 :=0;
  RPcoxExist.RP2 :=0;
  RPcoxExist.RA16:=0;
  RPcoxExist.RX6 :=0;
  RPcoxExist.RX7 :=0;
  RPcoxExist.PA5 :=0;
  RPcoxExist.INPUT  :=0;
  RPcoxExist.OUTPUT :=0;

  RPcox[1]:=RP1; RPcox[2]:=RP2; RPcox[3]:=RP3; RPcox[4]:=RP4; RPcox[5]:=RP5;
  PA5[1]:=PA5x1; PA5[2]:=PA5x2; PA5[3]:=PA5x3; PA5[4]:=PA5x4; PA5[5]:=PA5x5;
  RP_Nr:=1;
  RP_index:=1;
  TreeView1.Items.Clear;
{Forbinder til RM2 hvis den findes}
 While (RPcox[RP_Nr].ConnectRM2('USB',RP_index)=1) do begin
   MyNode1 := TreeView1.Items.Add(nil,'RM2-'+IntToStr(RP_index));
   if (RPcox[RP_Nr].LoadCOF(RcoNavn+'_RM2.rco')=1) then Begin
       If (RPcox[RP_Nr].Run=1) then Begin
         Inc(RPcoxExist.RM2);
         TDT_Max_Output:=1; // if there is a RM2
         SampelRate:= RPcox[RP_Nr].GetSFreq ;
         TreeView1.Items.AddChild(MyNode1,RcoNavn+'_RM2.rco');
         TreeView1.Items.AddChild(MyNode1,'SampelRate= '+IntToStr(Round(SampelRate))+'Hz');
         TreeView1.Items.AddChild(MyNode1,'Cycel use= '+IntToStr(Round(RPcox[RP_Nr].GetCycUse))+'%');
           for j:=1 to RPcox[RP_Nr].GetNumOf('ParTag') do Begin
             S:= IntToStr(j)+' - '+StripRpvds( RPcox[RP_Nr].GetNameOf('ParTag',j));
             TreeView1.Items.AddChild(MyNode1,S);
           end;
       end else TreeView1.Items.AddChild(MyNode1,'Not Running');
   end else TreeView1.Items.AddChild(MyNode1,'Not found: '+RcoNavn+'_RM2.rco');
   If RP_Nr=length(RPcox) then Showmessage('You have to much TDT equipment');
   Inc(RP_Nr);
   Inc(RP_index);
 end;
{Forbinder til RA16 hvis den findes}
 RP_index:=1;
 While (RPcox[RP_Nr].ConnectRA16('USB',RP_index)=1) do begin
   MyNode1 := TreeView1.Items.Add(nil,'RA16-'+IntToStr(RP_index));
   if (RPcox[RP_Nr].LoadCOF(RcoNavn+'_RA16.rco')=1) then Begin
       If (RPcox[RP_Nr].Run=1) then Begin
         Inc(RPcoxExist.RA16);
         SampelRate:= RPcox[RP_Nr].GetSFreq ;
         TreeView1.Items.AddChild(MyNode1,RcoNavn+'_RA16.rco');
         TreeView1.Items.AddChild(MyNode1,'SampelRate= '+IntToStr(Round(SampelRate))+'Hz');
         TreeView1.Items.AddChild(MyNode1,'Cycel use= '+IntToStr(Round(RPcox[RP_Nr].GetCycUse))+'%');
           for j:=1 to RPcox[RP_Nr].GetNumOf('ParTag') do Begin
             S:= IntToStr(j)+' - '+StripRpvds( RPcox[RP_Nr].GetNameOf('ParTag',j));
             TreeView1.Items.AddChild(MyNode1,S);
           end;
       end else TreeView1.Items.AddChild(MyNode1,'Not Running');
   end else TreeView1.Items.AddChild(MyNode1,'Not found: '+RcoNavn+'_RA16.rco');
   If RP_Nr=length(RPcox) then Showmessage('You have to much TDT equipment');
   Inc(RP_Nr);
   Inc(RP_index);
 end;
{Forbinder til RP2 hvis den findes}
 RP_index:=1;
 While (RPcox[RP_Nr].ConnectRP2('USB',RP_index)=1) do begin         // Connect
   MyNode1 := TreeView1.Items.Add(nil,'RP2-'+IntToStr(RP_index));
   if (RPcox[RP_Nr].LoadCOF(RcoNavn+'_RP2.rco')=1) then Begin            // Load
       If (RPcox[RP_Nr].Run=1) then Begin                            // Run
         Inc(RPcoxExist.RP2);
         SampelRate:= RPcox[RP_Nr].GetSFreq ;
         TreeView1.Items.AddChild(MyNode1,RcoNavn+'_RP2.rco');
         TreeView1.Items.AddChild(MyNode1,'SampelRate= '+IntToStr(Round(SampelRate))+'Hz');
         TreeView1.Items.AddChild(MyNode1,'Cycel use= '+IntToStr(Round(RPcox[RP_Nr].GetCycUse))+'%');
           for j:=1 to RPcox[RP_Nr].GetNumOf('ParTag') do Begin
             S:= IntToStr(j)+' - '+StripRpvds( RPcox[RP_Nr].GetNameOf('ParTag',j) );
             TreeView1.Items.AddChild(MyNode1,S);
           End;
       End else TreeView1.Items.AddChild(MyNode1,'Not Running');
   End else TreeView1.Items.AddChild(MyNode1,'Not found: '+RcoNavn+'_RP2.rco');
   If RP_Nr=length(RPcox) then Showmessage('You have to much TDT equipment');
   Inc(RP_Nr);
   Inc(RP_index);
 end;
{Forbinder til RX6 hvis den findes}
 RP_index:=1;
 While (RPcox[RP_Nr].ConnectRX6('USB',RP_index)=1) do begin         // Connect
   MyNode1 := TreeView1.Items.Add(nil,'RX6-'+IntToStr(RP_index));
   if (RPcox[RP_Nr].LoadCOF(RcoNavn+'_RX6.rco')=1) then Begin            // Load
       If (RPcox[RP_Nr].Run=1) then Begin                            // Run
         Inc(RPcoxExist.RX6);
         SampelRate:= RPcox[RP_Nr].GetSFreq ;
         TreeView1.Items.AddChild(MyNode1,RcoNavn+'_RX6.rco');
         TreeView1.Items.AddChild(MyNode1,'SampelRate= '+IntToStr(Round(SampelRate))+'Hz');
         TreeView1.Items.AddChild(MyNode1,'Cycel use= '+IntToStr(Round(RPcox[RP_Nr].GetCycUse))+'%');
           for j:=1 to RPcox[RP_Nr].GetNumOf('ParTag') do Begin
             S:= IntToStr(j)+' - '+StripRpvds( RPcox[RP_Nr].GetNameOf('ParTag',j) );
             TreeView1.Items.AddChild(MyNode1,S);
           End;
       End else TreeView1.Items.AddChild(MyNode1,'Not Running');
   End else TreeView1.Items.AddChild(MyNode1,'Not found: '+RcoNavn+'_RX6.rco');
   If RP_Nr=length(RPcox) then Showmessage('You have to much TDT equipment');
   Inc(RP_Nr);
   Inc(RP_index);
 end;
{Forbinder til RX7 hvis den findes}
 RP_index:=1;
 While (RPcox[RP_Nr].ConnectRX7('USB',RP_index)=1) do begin         // Connect
   MyNode1 := TreeView1.Items.Add(nil,'RX7-'+IntToStr(RP_index));
   if (RPcox[RP_Nr].LoadCOF(RcoNavn+'_RX7.rco')=1) then Begin            // Load
       If (RPcox[RP_Nr].Run=1) then Begin                            // Run
         Inc(RPcoxExist.RX7);
         SampelRate:= RPcox[RP_Nr].GetSFreq ;
         TreeView1.Items.AddChild(MyNode1,RcoNavn+'_RX7.rco');
         TreeView1.Items.AddChild(MyNode1,'SampelRate= '+IntToStr(Round(SampelRate))+'Hz');
         TreeView1.Items.AddChild(MyNode1,'Cycel use= '+IntToStr(Round(RPcox[RP_Nr].GetCycUse))+'%');
           for j:=1 to RPcox[RP_Nr].GetNumOf('ParTag') do Begin
             S:= IntToStr(j)+' - '+StripRpvds( RPcox[RP_Nr].GetNameOf('ParTag',j) );
             TreeView1.Items.AddChild(MyNode1,S);
           End;
       End else TreeView1.Items.AddChild(MyNode1,'Not Running');
   End else TreeView1.Items.AddChild(MyNode1,'Not found: '+RcoNavn+'_RX7.rco');
   If RP_Nr=length(RPcox) then Showmessage('You have to much TDT equipment');
   Inc(RP_Nr);
   Inc(RP_index);
 end;
{Forbinder til PA5 hvis den findes}
 RP_index:=1;
 //RP_Nr:=1;
 PA5_Nr:=1;
 While (PA5[PA5_Nr].ConnectPA5('USB',RP_index)=1) do begin         // Connect
   MyNode1 := TreeView1.Items.Add(nil,'PA5-'+IntToStr(RP_index));
   if (PA5[PA5_Nr].Display('Strobist',0)) then Begin             // skriver til Displayet
      TreeView1.Items.AddChild(MyNode1,'Att:  '+FloatToStrF(PA5[PA5_Nr].GetAtten,FFfixed,3,1)+' dB');
      Inc(RPcoxExist.PA5);
   End else TreeView1.Items.AddChild(MyNode1,'Write Error');
   If PA5_Nr=length(PA5) then Showmessage('You have to much TDT equipment');
   Inc(PA5_Nr);
   Inc(RP_index);
 end;
{viser TDTForm hvis der er problemer}
RPcoxExist.INPUT  := RPcoxExist.RM2 + RPcoxExist.RA16 + RPcoxExist.RX6 + RPcoxExist.RP2 + RPcoxExist.RX7;
RPcoxExist.OUTPUT := RPcoxExist.RM2 + RPcoxExist.RA16 + RPcoxExist.RX6 + RPcoxExist.RX7;
 If not ((RPcoxExist.INPUT>0) AND (RPcoxExist.OUTPUT>0))
   then begin
     TDTForm.Show;
     TDTForm.Activate;
     TDTFindes:=FALSE;
   end
   else
    Begin
      RP_ABR := RP1;
      if RP_Nr>2 then
        Begin
          RP_SOUND:= RP2;
          MyNode1:=TreeView1.Items.GetFirstNode;
          MyNode1.Text:=MyNode1.Text+'   [ABR]';
          MyNode1:=MyNode1.getNextSibling;
          MyNode1.Text:=MyNode1.Text+'   [SOUND]';
          if pos('RM2',MyNode1.Text)>0 then TDT_Max_Output:=1 else TDT_Max_Output:= 10;
        end
        else RP_SOUND:= RP1;
      TDTFindes:=TRUE;
    end;
End;



  {** Reconnect **}
procedure TTDTForm.Button1Click(Sender: TObject);
begin
  TDTconnect();
end;



  {** Reset **}     {Dont know if this works, not tested}
function TTDTForm.TDTReset():integer;
var
 fejl : integer;
 S:string;
begin
  fejl:= ZBUSx1.ConnectZBUS('USB');
  S:= 'Connect: ';
  If fejl=1 then S:=S+'Sucess' else S:=S+'ERROR';

  S:=   S +#13+ ZBUSx1.GetError ;

  fejl:= ZBUSx1.FlushIO(1) ; S:=S +#13 + 'Flush(1): ';
  If fejl=1 then S:=S+'Sucess' else S:=S+'ERROR';


  fejl:= ZBUSx1.HardwareReset(1); S:=S +#13 + 'Reset(1): ';
  If fejl=0 then S:=S+'Sucess' else S:=S+'ERROR';

  TDTReset:= fejl;
  Showmessage(S+#13+ZBUSx1.GetError);

end; //}




function TTDTForm.PM2_on(turn_on:boolean):integer;
Begin
 If  Nr_TDT_Connected('rx6')>0 then begin
   If  Nr_TDT_Connected('rm2')>0 then begin
     If turn_on then begin
        RP2.SetTagVal('pm2_2',0);
        RP2.SetTagVal('pm2_2',256);   // on
     end else begin
        RP2.SetTagVal('pm2_2',0);
        RP2.SetTagVal('pm2_2',512);   // off
     end;
   end else begin
     If turn_on then begin
        RP1.SetTagVal('pm2_2',0);
        RP1.SetTagVal('pm2_2',256);   // on
     end else begin
        RP1.SetTagVal('pm2_2',0);
        RP1.SetTagVal('pm2_2',512);   // off
     end;
   end;
   PM2_on:=1;
 end else PM2_on:=0;
End;


function TTDTForm.Set_PM2(kanal:integer):integer;
Begin
 If  Nr_TDT_Connected('rx6')>0 then begin
   Set_PM2:=1;
   If ((kanal>15) or (kanal<0)) then Set_PM2:=-1 else
   begin
     If  Nr_TDT_Connected('rm2')>0 then begin
      RP2.SetTagVal('pm2_2',0);
      RP2.SetTagVal('pm2_1',kanal*4);  // set channel
      RP2.SetTagVal('pm2_2',256);      // on
     end else begin
      RP1.SetTagVal('pm2_2',0);
      RP1.SetTagVal('pm2_1',kanal*4);  // set channel
      RP1.SetTagVal('pm2_2',256);      // on
     end;
   end;
 end else Set_PM2:=0;
End;


{*** Get name of calibration file ***}
Function TTDTForm.Kalib_Name(long:boolean):String;
begin
  if long then Kalib_Name:=TDT_KalibFilePath else Kalib_Name:=Glob_Titel;
end;


{** Use this to get sampelrate **}
Function TTDTForm.Get_TDT_Sampelrate(st:String):Single;
Begin
 if st='ABR'    then Result:= RP_ABR.GetSFreq
                else Result:= RP_SOUND.GetSFreq ;

 if (Result<2) or (Result>900000) then
   Begin
     {Showmessage('TDT system rapports a unusual sample rate of '+ FloatToStr(Result)+'Hz'
                  +#13+'Value adjusted into range (24414Hz)'+#13+
                  'You might want to restart the TDT system' );}
     Result:=24414;
   End;
End;




{** Use this to see if a needed unit is connected **}
Function TTDTForm.Nr_TDT_Connected(RPcoxType:string):integer;
var
fejl: integer;
Number:integer;
Begin
 fejl:=1;
 Number:=0;
 RPcoxType:= LowerCase(RPcoxType);
 If RPcoxType = 'rm2'  then Begin Number:= RPcoxExist.RM2;  fejl:=0 end;
 If RPcoxType = 'rp2'  then Begin Number:= RPcoxExist.RP2;  fejl:=0 end;
 If RPcoxType = 'ra16' then Begin Number:= RPcoxExist.RA16; fejl:=0 end;
 If RPcoxType = 'rx6'  then Begin Number:= RPcoxExist.RX6;  fejl:=0 end;
 If RPcoxType = 'rx7'  then Begin Number:= RPcoxExist.RX7;  fejl:=0 end;
 If RPcoxType = 'pa5'  then Begin Number:= RPcoxExist.PA5;  fejl:=0 end;
 If RPcoxType = 'pm2'  then Begin Number:= 1;  fejl:=0 end;  //set manually
If fejl=1 then Showmessage('Undefined unit type '+RPcoxType);
Nr_TDT_Connected:= Number;
End;


    {** Load new kalibration file **}
procedure TTDTForm.Button2Click(Sender: TObject);
var
  Path: string;
begin
  Path:= IncludeTrailingBackslash(ExtractFilePath(TDT_KalibFilePath));
  OpenDialog1.InitialDir:=path;
if OpenDialog1.Execute then begin
    TDT_KalibFilePath:=OpenDialog1.FileName;
    LoadKalib(TDT_KalibFilePath);
  end;
end;


   {**  Save  **}
procedure TTDTForm.FormDestroy(Sender: TObject);
begin
 SaveSettings();
 TDTForm.SaveLogFile('{EXIT}');
 RP_SOUND.Halt;
 RP_ABR.Halt;
end;


{***************************************************************************}
{** Procedurene herunder kan ændres så de passer til det aktuelle program **}
{***************************************************************************}




{** Use this to get kalib data from rx6 **}
Function TTDTForm.Get_dB_from_TDT():Single;
Begin
 result := RP_SOUND.GetTagVal('kalib');
 if result=0 then result :=  RP_ABR.GetTagVal('kalib');
End;




{**  Tester kalibration  **}
procedure TTDTForm.TDTTestKal(Freq,tone:single; kanal:integer);
var
tdtamp:single;
begin
   if tone > -999 then TDTamp:=kal(round(freq),round(kanal),tone) else TDTamp:=0 ; // korrigere for kalibreringen af høretelefonerne
   //RP_ABR.SetTagVal('t_amp',TDTamp);        // Sætter tonens amplitude
   //RP_ABR.SetTagVal('t_freq',freq);         // sætter tonens frekvens
   RP_SOUND.SetTagVal('t_amp',TDTamp);      // Same but for a separate sound generator
   RP_SOUND.SetTagVal('t_freq',freq);
End;



procedure TTDTForm.TDTCalibrate(Freq,Amp:single; kanal:integer);
var
 TDTamp:single;
begin
   if Amp > -999 then TDTamp:=0.1*Power(10,(Amp-94)/20) else TDTamp:=0 ;

   RP_ABR.SetTagVal('output',kanal);
   RP_ABR.SetTagVal('dualChannel',0);

   RP_SOUND.SetTagVal('output',kanal);
   RP_SOUND.SetTagVal('dualChannel',0);

   RP_SOUND.SetTagVal('t_amp',TDTamp);
   RP_SOUND.SetTagVal('t_freq',freq);
   RP_SOUND.SetTagVal('ScaleFactor',TDT_ScaleFactor);
End;




{**  Starter Tone optagelsen og retunere data  **}
procedure TTDTForm.TDTRecordFast(ABR_Info:TABR_Info);
var
  i: integer;
begin

   Glob_pause:=False;           //is needed if TDTform is closed while paused
   button4.Enabled:=true;
   button4.Caption:='Pause';    //is needed if TDTform is closed while paused
   Local_current_ABR_Info := ABR_Info;  // save data for the ThreadDone procedure

   if DebugTimer then Form1.Memo1.Lines.Add(FormatDateTime('"TDTRecordFast;" sszzz',(now-Glob_StartTid)));
   if TDTForm.TDTToneAmpSet(ABR_Info.freq_tone, ABR_Info.InstantAmp {Amp_Tone} ) then
     Begin
       if DebugTimer then Form1.Memo1.Lines.Add(FormatDateTime('"TDTRecordFast_loop1;" sszzz',(now-Glob_StartTid)));
       i:=RP_ABR.SoftTrg(1);
          //RP_SOUND.SoftTrg(1);
          if DebugTimer then Form1.Memo1.Lines.Add(FormatDateTime('"TDTRecordFast_loop2;" sszzz',(now-Glob_StartTid)));
       if i=1 then   StartThread()        // if the trigger works, start the new thread
       else Begin
         Showmessage('Error: Could not trig a TDT system');
         Glob_TDTConnected:=FALSE;
       end;
     End else Glob_TDTConnected:=FALSE;
End;


{Procedure PeakCheck(raw_data:array of single; PeakRejected:boolean);
var
 temp_data:array of single;
 L,x,i:integer;
Begin
 L:= Glob_NumberOf_Samples;
 SetLength(temp_data,L);

//PeakPeakValue:= FindPeakPpeakValue(raw_data)/500;

     for x:= 0 to 7 do
       Begin
         For i:= 0 to L-1 do temp_data[i]:= raw_data[i+x*L];
         If  (FindPeakPpeakValue(temp_data)/500) > Glob_Peak_reject
          Then  Begin
                 temp_data
                End
       End;
 //If PeakPeakValue> Glob_Peak_reject then
end;      }



  {** this runs when one of the threads i done **}
{procedure TTDTForm.ThreadDone(var AMessage: TMessage); // keep track of when and which thread is done executing
var
 i,x,L,shifter:integer;
 raw_data:array of single;
 masked,PeakRejected:boolean;
 ABR_Info:TABR_Info;
 PeakPeakValue:single;
begin
 button4.Enabled:=True; //Enable the pausebutton if it has been used
 ABR_Info:= Local_current_ABR_Info;
  if (MyThread1 <> nil) then   Thread1Active := false;
  if Thread1Active <> false then Showmessage('Thread1Active = True in TTDTForm.ThreadDone ');

  //Form1.Label_chart.Caption:= 'turn '+IntToStr(ABR_Info.Amp_Tone);
  if odd(ABR_Info.Turn_Nr) AND (ABR_Info.Amp_Tone>-1000) then masked:=TRUE else masked:=FALSE;
  if not(Masked) then TDTForm.Color:=clBtnFace else TDTForm.Color:=clRed ;

  L:= Glob_NumberOf_Samples;
  setlength(raw_data,(8*Glob_NumberOf_Samples)+1);
  i:=RP_ABR.ReadTag('kanal1',raw_data[0],0,(8*Glob_NumberOf_Samples));   // Get data from TDT system
  if i<>1 then Showmessage('ThreadDone data not retrived');            // warning if the system is disconnected
  PeakPeakValue:= FindPeakPpeakValue(raw_data)/500;                    // 500 is the scale factor from the TDT system


  If PeakPeakValue> Glob_Peak_reject then
  //PeakCheck(raw_data,PeakRejected);
  //If PeakRejected then
   Begin
     inc(Local_Nr_TDT_Rejections);   //count consecutive rejections

     TDTForm.Color:=clRed;
     Form1.Label_chart.Caption :='REJECTED   (Peak-Peak value: '+FloatToStrF((PeakPeakValue),ffExponent,4,0)+')';

     if Local_Nr_TDT_Rejections < 4 then
       Begin

         i:=RP_ABR.SoftTrg(1);
         if i=1 then   StartThread()        // if the trigger works, start the new thread
       end
       else
       Begin
       Showmessage('The signal keeps being rejected, '+#13+'this can be caused by movmentin the subject or noise reject being set to low');
       Local_Nr_TDT_Rejections :=0;
       Button4Click(Button4);
       button4.Enabled:=True;
       end;
   end
   else
   begin
     Local_Nr_TDT_Rejections:=0; // Reset count of rejections if there are just one good measurement
     TDTForm.Color:=clBtnFace;
     Form1.Label_chart.Caption :='Recording   (Peak-Peak value: '+FloatToStrF((PeakPeakValue),ffExponent,4,0)+')';

     Glob_TDTConnected := (i=1);
     if masked then
       begin
       SetLength(Glob_abr_Avarage[0],Glob_NumberOf_Samples);
       SetLength(Glob_abr_Avarage[1],Glob_NumberOf_Samples);
       SetLength(Glob_abr_Avarage[2],Glob_NumberOf_Samples);
       SetLength(Glob_abr_Avarage[3],Glob_NumberOf_Samples);
       shifter:=2;
       end else begin
       SetLength(Glob_abr_Avarage[0],Glob_NumberOf_Samples);
       SetLength(Glob_abr_Avarage[1],Glob_NumberOf_Samples);
       Shifter:=0;
       end;

     for x:= 0 to 7 do
       case x of
       0,1,4,5:  Begin    // buffer A Unmasked/Masked
                   For i:= 0 to L-1 do Glob_abr_Avarage[0+shifter,i]:= Glob_abr_Avarage[0+shifter,i]+raw_data[i+x*L];
                   Glob_abr_Avarage_nr[0+shifter]:= Glob_abr_Avarage_nr[0+shifter]+1;
                   End;
       2,3,6,7:  Begin    // buffer B Unmasked/Masked
                   For i:= 0 to L-1 do Glob_abr_Avarage[1+shifter,i]:= Glob_abr_Avarage[1+shifter,i]+raw_data[i+x*L];
                   Glob_abr_Avarage_nr[1+shifter]:= Glob_abr_Avarage_nr[1+shifter]+1;
                   End;
      end;


     if Glob_Save_WavFile then
       Begin
          if masked
          then  Glob_ABR_Full_mask:=WavConKatArray(Glob_ABR_Full_mask, WavMakeWav(raw_data))
          else Glob_ABR_Full_Unmask:=WavConKatArray(Glob_ABR_Full_Unmask, WavMakeWav(raw_data));
       end;

     //If (Nr_TDT_Connected('rx6')>0) and (Nr_TDT_Connected('rm2')>0) then RP2.SetTagVal('t_amp',0);
      RP_SOUND.SetTagVal('t_amp',0);
     if DebugTimer then Form1.Memo1.Lines.Add(FormatDateTime('"ThreadDone;" sszzz',(now-Glob_StartTid)));
     if not(Glob_pause) then Form1.ContinueRecordSave(ABR_Info);
   end;
end;     }


function TTDTForm.WarningColor(nr:integer):integer;
begin
if nr = 0 then TDTForm.Color:=clBtnFace;
if nr = 0 then TDTForm.Color:=$00D0D0FF;
if nr = 1 then TDTForm.Color:=$00C0C0FF;
if nr = 2 then TDTForm.Color:=$00B0B0FF;
if nr = 3 then TDTForm.Color:=$00A0A0FF;
if nr = 4 then TDTForm.Color:=$009090FF;
if nr = 5 then TDTForm.Color:=$008080FF;
if nr = 6 then TDTForm.Color:=$007070FF;
if nr = 7 then TDTForm.Color:=$006060FF;
if nr = 8 then TDTForm.Color:=$005050FF;
if nr > 8 then TDTForm.Color:=$004040FF;
result:=nr;
end;


  {** this runs when one of the threads i done **}
procedure TTDTForm.ThreadDone(var AMessage: TMessage); // keep track of when and which thread is done executing
var
 i,x,L,shifter:integer;
 raw_data:array of single;
 masked:boolean;
 ABR_Info:TABR_Info;
begin
 button4.Enabled:=True;                 //Enable the pausebutton if it has been used
 ABR_Info:= Local_current_ABR_Info;
  if (MyThread1 <> nil) then   Thread1Active := false;
  if Thread1Active <> false then Showmessage('Thread1Active = True in TTDTForm.ThreadDone ');

  if odd(ABR_Info.Turn_Nr) AND (ABR_Info.Amp_Tone>-1000) then masked:=TRUE else masked:=FALSE;

  L:= Glob_NumberOf_Samples;
  setlength(raw_data,(8*Glob_NumberOf_Samples)+1);
  i:=RP_ABR.ReadTag('kanal1',raw_data[0],0,(8*Glob_NumberOf_Samples));   // Get data from TDT system
  if i<>1 then Showmessage('ThreadDone data not retrived');            // warning if the system is disconnected



   begin
     Local_Nr_TDT_Rejections:=0; // Reset count of rejections if there are just one good measurement
     TDTForm.Color:=clBtnFace;

     if masked then
       begin
       SetLength(Glob_abr_Avarage[0],Glob_NumberOf_Samples);
       SetLength(Glob_abr_Avarage[1],Glob_NumberOf_Samples);
       SetLength(Glob_abr_Avarage[2],Glob_NumberOf_Samples);
       SetLength(Glob_abr_Avarage[3],Glob_NumberOf_Samples);
       shifter:=2;
       end else begin
       SetLength(Glob_abr_Avarage[0],Glob_NumberOf_Samples);
       SetLength(Glob_abr_Avarage[1],Glob_NumberOf_Samples);
       Shifter:=0;
       end;

     for x:= 0 to 7 do
     If (Glob_abr_Avarage_nr[0+shifter]+Glob_abr_Avarage_nr[1+shifter]) < Glob_max_avrages then
     Begin
      if Odd(Floor((Glob_abr_Avarage_nr[0+shifter] + Glob_abr_Avarage_nr[1+shifter])/2))
      then
        Begin   // buffer A Unmasked/Masked
               Form1.Label_chart.Caption :='Recording   (Peak-Peak value: '+ FloatToStrF(  FindPeakPpeakValue(raw_data, round(x*L) ,round(((L-1)+(x*L))) ) /500  ,ffExponent,4,0 )+')';
          if (  Glob_Peak_reject > ( FindPeakPpeakValue(raw_data, round(x*L) ,round(((L-1)+(x*L))) ) /500)  ) then
          Begin
            For i:= 0 to L-1 do Glob_abr_Avarage[0+shifter,i]:= Glob_abr_Avarage[0+shifter,i]+raw_data[i+x*L];
            Glob_abr_Avarage_nr[0+shifter]:= Glob_abr_Avarage_nr[0+shifter]+1;
          End else inc(Local_Nr_TDT_Rejections);
        end
         else
        Begin   // buffer B Unmasked/Masked
          if (Glob_Peak_reject > (FindPeakPpeakValue(raw_data,(x*L),((L-1)+(x*L)))/500)) then
          Begin
            For i:= 0 to L-1 do Glob_abr_Avarage[1+shifter,i]:= Glob_abr_Avarage[1+shifter,i]+raw_data[i+x*L];
            Glob_abr_Avarage_nr[1+shifter]:= Glob_abr_Avarage_nr[1+shifter]+1;
          End else inc(Local_Nr_TDT_Rejections);
        end;
     end;

     WarningColor(Local_Nr_TDT_Rejections);
     //if Local_Nr_TDT_Rejections = 0 then TDTForm.Color:=clBtnFace;
     //if Local_Nr_TDT_Rejections > 0 then TDTForm.Color:=#200000;

     if Glob_Save_WavFile then  // Save Data as wav file
       Begin
          if masked
          then  Glob_ABR_Full_mask:=WavConKatArray(Glob_ABR_Full_mask, WavMakeWav(raw_data))
          else Glob_ABR_Full_Unmask:=WavConKatArray(Glob_ABR_Full_Unmask, WavMakeWav(raw_data));
       end;

      RP_SOUND.SetTagVal('t_amp',0);   // stop the tone temporarely
      ABR_Info.Stim_file_length := Length(Glob_StimFile.Stim);
     if DebugTimer then Form1.Memo1.Lines.Add(FormatDateTime('"ThreadDone;" sszzz',(now-Glob_StartTid)));
     if not(Glob_pause) then Form1.ContinueRecordSave(ABR_Info);
   end;
end;


      {**  Starts a new tread  **}
Procedure TTDTForm.StartThread();
var
  S:string;
Begin

   if (MyThread1 = nil) or (Thread1Active = false) then // make sure its not already running
   begin
     MyThread1 := TMyThread.CreateIt(2, ProgressBar1, RP_ABR);  // priority,
     Thread1Active := true;
   end
   else
   Begin
     If (MyThread1 = nil) then S:= 'MyThread1 = nil' else S:= 'MyThread1 <> nil';
     If (Thread1Active = false) then S:=S+ ' ; Thread1Active = false' else S:=s+ ' ; Thread1Active = false';
     ShowMessage('Thread still executing'+#10+S);
   end
end;


  {**  Pause / Resume button **}
procedure TTDTForm.Button4Click(Sender: TObject);
begin
if button4.Caption='Pause' then begin
   Glob_pause:=true;
   button4.Caption:= 'Resume';
   button4.Enabled:=false;
   end else begin
   Glob_pause:=False;
   button4.Caption:= 'Pause';
   Form1.ContinueRecordSave(Local_current_ABR_Info);
   end;
end;





   {**  Change in settings **}
procedure TTDTForm.ComboBox1Change(Sender: TObject);
var
 result : single;
begin
 result:=0;
 with Sender as TComboBox do
  try
    result:=StrTofloat(text);
  except
    on EConvertError do Showmessage('Not a Integer: ' + Text);
  end;

 If sender = Combobox6 then
        Begin
          Glob_NumberOf_Samples:=Round(result);
          TDTForm.SaveLogFile('{Set} NumberOf_Samples = '+IntToStr(Glob_NumberOf_Samples));
        End;
 If sender = Combobox4 then
        Begin
          Glob_Peak_reject:=result;
          TDTForm.SaveLogFile('{Set} Peak Reject = '+FloatToStrF(Glob_Peak_reject,fffixed,2,2 ));
        End;
 If sender = Combobox3 then
        Begin
          Glob_kanal_ind:=round(result);
          TDTForm.SaveLogFile('{Set} Channel in = '+IntToStr(Glob_kanal_ind));
        End;
 If sender = Combobox2 then
        Begin
          Glob_kanal_ud:=round(result);
          TDTForm.SaveLogFile('{Set} Channel Out = '+IntToStr(Glob_kanal_ud));
        End;
 If sender = Combobox1 then
        Begin
          Glob_max_Turns := round(result/8);
          Glob_max_avrages:=Glob_max_Turns*8;
          Combobox1.Text:=IntToStr(Glob_max_avrages);
          TDTForm.SaveLogFile('{Set} Number of avrages = '+IntToStr(Glob_max_avrages));
        End;
end;


Function TTDTForm.LoadStim(Name:string):boolean;
var
  path : string;
  notfound:boolean;
  Stim:TStimFile;
Begin
  Result:=False;
  path:= Name + '.AB9' ;
  MakeStimForm.Load_Stim_silent(Stim,path,notfound);
  If notfound then showmessage('Stimfile '+Path+' not found') else
        Begin
          if Stim.comment='Auto generated' then Stim.comment:= Name;
          TDTForm.SetGlobStim(Stim);
          TDTForm.SaveLogFile('{Set} Stimfile Loaded = '+Path);
          Result:=True;
        End;
end;



procedure TTDTForm.ComboBox5Change(Sender: TObject);
begin
 if ComboBox5.Text <> '' then begin
   LoadStim(ComboBox5.Text);
 End;
end;


    {** On Exit **}
procedure TTDTForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
MyNode1: TTreeNode;
begin
 SaveSettings();
 MyNode1:= Form1.TreeView1.Items.GetFirstNode;
 Form1.ButtonTest.Enabled:= True;
 If MyNode1=nil then Form1.Start_ABR_Button.Enabled:=false else Form1.Start_ABR_Button.Enabled:= True;

end;

   {** Make new stim **}
procedure TTDTForm.Button3Click(Sender: TObject);
begin
 MakeStimForm.Show;
end;



procedure TTDTForm.SetGlobStim(data: TstimFile);
Begin
   Glob_StimFile := data;
end;



procedure TTDTForm.Timer1Timer(Sender: TObject);
begin
  timer1.enabled:=false;
  StartThread();
end;


function TTDTForm.TDTSetScaleFactor(ScaleFactor:single):boolean;
Begin
  TDT_ScaleFactor:=  48550 * power(10,(ScaleFactor/20));
  RP_ABR.SetTagVal('ScaleFactor',TDT_ScaleFactor);
  RP_SOUND.SetTagVal('ScaleFactor',TDT_ScaleFactor);
  result:=true;
end;


function TTDTForm.TDTSet_Klik_Amp(KlikAmp:integer):boolean;
var
TDTklik:double;
Begin
  Glob_klik_Amp:=KlikAmp;
  TDTklik:=0.28*power(10,((klikAmp-94)/20));
  RP_SOUND.SetTagVal('k_amp',TDTklik);
  result:=true;
end;

function TTDTForm.TDTSet_Klik_Correction(correction:double):boolean;
Begin
  Glob_StimFile.correction := correction;
  result:=true;
end;


function TTDTForm.TDTToneAmpSet(freq:integer; tone:double):boolean;
var
  TDTamp:double;
  fejl:integer;
begin
  fejl:=0;
  if tone > -999 then TDTamp:=kal(freq,Glob_kanal_ud+1,tone)  else  TDTamp:=0;

   if (TDTamp>TDT_Max_Output) then Begin
                showmessage('TDTOverload'+#13+'The RM2 is clipping the signal');
                Button4Click(Button4);
                fejl:=100;
                end;
   //if 1<>RP_ABR.SetTagVal('t_amp',TDTamp)    then inc(fejl);
   if 1<>RP_SOUND.SetTagVal('t_amp',TDTamp)  then inc(fejl);
   if fejl=0 then result:=true else result:=false;
   If fejl<>0 then Showmessage( 'TTDTForm.TDTSet could not be set, Error= '+IntToStr(fejl) );
end;



function TTDTForm.TDTSet(ABR_Info:TABR_Info):boolean;
var
kanal:integer;
TDTamp,TDTklik:double;
fejl,iSet,invert,stim_length:integer;
phase:double;
begin
  phase:=0;
  fejl:=0;
   kanal:= ABR_Info.kanal_ud ;

  if ABR_Info.Amp_Tone > -999 then TDTamp:=kal(ABR_Info.Freq_Tone, kanal+1, ABR_Info.Amp_Tone)  else  TDTamp:=0;            // korrigere for kalibreringen af højtaler
  //if ABR_Info.Amp_Klik > -999 then TDTklik:=kal(ABR_Info.Freq_Klik, kanal, ABR_Info.Amp_Klik)   else  TDTklik:=0;         //Must fix
  if ABR_Info.Amp_Klik > -999 then TDTklik:= kal_click(ABR_Info.Amp_Klik) else  TDTklik:=0; // use the canibration from the stim file
  if DebugTimer then Form1.Memo1.Lines.Add(FormatDateTime('"10;" sszzz',(now-Glob_StartTid)));

  //showmessage(floatToStr(TDTklik));
   if (TDTamp>TDT_Max_Output) then Begin
                showmessage('TDTOverload'+#13+'The RM2 TDT amplitude is clipping the signal');
                Button4Click(Button4);
                fejl:=100;
                end;

   if (TDTklik>TDT_Max_Output) then Begin
                showmessage('TDTOverload'+#13+'The RM2 click is clipping the signal');
                Button4Click(Button4);
                fejl:=100;
                end;



  if ABR_Info.Directional_ABR then iSet:=1 else iSet:=0;
  if ABR_Info.Invert_Click then invert:=2 else invert:=1;


  stim_length:=Length(Glob_StimFile.Stim);
  //ShowMessage('stimL:'+intToStr(stim_length)+' samples'+intToStr(ABR_Info.NumberOf_Samples));

  if 1<>RP_ABR.SetTagVal('stim_length',stim_length)                then inc(fejl);
  if 1<>RP_ABR.SetTagVal('samples',ABR_Info.NumberOf_Samples)      then inc(fejl);
  if 1<>RP_ABR.SetTagVal('input',ABR_Info.kanal_ind)               then inc(fejl);
  if 1<>RP_ABR.SetTagVal('output',kanal)                           then inc(fejl);
  if 1<>RP_ABR.SetTagVal('t_amp',0)                                then inc(fejl); // Sætter tonens amplitude
  if 1<>RP_ABR.SetTagVal('t_freq',ABR_Info.Freq_Tone)              then inc(fejl); // sætter tonens frekvens
  if 1<>RP_ABR.WriteTag('StimFile',Glob_StimFile.Stim[0],0,stim_length)   then inc(fejl); // StimFile
  if 1<>RP_ABR.SetTagVal('k_amp',0)                                then inc(fejl); // Sætter klik amp
  if 1<>RP_ABR.SetTagVal('ScaleFactor',TDT_ScaleFactor)            then inc(fejl); // Sætter klik amp
  if 1<>RP_ABR.SetTagVal('dualChannel',iSet)                       then inc(fejl);

  if 1<>RP_SOUND.SetTagVal('stim_length',stim_length)                then inc(fejl);
  if 1<>RP_SOUND.SetTagVal('modulus',Invert)                         then inc(fejl); // invert click, if 2 then cliks are inverted if 1 then not.
  if 1<>RP_SOUND.SetTagVal('phase',phase)                            then inc(fejl);
  if 1<>RP_SOUND.SetTagVal('samples',ABR_Info.NumberOf_Samples)      then inc(fejl);
  //if 1<>RP_SOUND.SetTagVal('input',ABR_Info.kanal_ind)               then inc(fejl);
  if 1<>RP_SOUND.SetTagVal('output',kanal)                           then inc(fejl);
  if 1<>RP_SOUND.SetTagVal('t_amp',TDTamp)                           then inc(fejl); // Sætter tonens amplitude
  if 1<>RP_SOUND.SetTagVal('t_freq',ABR_Info.Freq_Tone)              then inc(fejl); // sætter tonens frekvens
  if 1<>RP_SOUND.WriteTag('StimFile',Glob_StimFile.Stim[0],0,stim_length)   then inc(fejl); // StimFile
  if 1<>RP_SOUND.SetTagVal('k_amp',TDTklik)                          then inc(fejl); // Sætter klik amp
  if 1<>RP_SOUND.SetTagVal('ScaleFactor',TDT_ScaleFactor)            then inc(fejl); // Sætter klik amp
  if 1<>RP_SOUND.SetTagVal('dualChannel',iSet)                       then inc(fejl);

  If fejl=0 then Result:=true else Result:=false;
  If fejl<>0 then Showmessage( 'TTDTForm.TDTSet could not be set, Error= '+IntToStr(fejl) );
end;     //}


Procedure TTDTForm.ShutUp();
Begin
  RP_SOUND.SetTagVal('k_amp',0);
  RP_SOUND.SetTagVal('t_amp',0);
end;




function TTDTForm.TDTRun():boolean;
Begin
   if (1 = RP_ABR.SoftTrg(1)) AND (1 = RP_SOUND.SoftTrg(1))   then Result:=true else Result:=False;
end;



procedure TTDTForm.TDTRunTest();
var
 S:String;
 ABR_Info: TABR_Info;
Begin
 if (MyTestThread1 = nil) or (TestThread1Active = false) then // make sure its not already running
   begin
     form1.SetABRInfo(ABR_Info);
     //Showmessage('Start thread');
     ABR_Info.Amp_Tone := -1000;
     ABR_Info.Freq_Tone := 0;
     ABR_Info.Invert_Click := false;

     if TDTSet(ABR_Info) then
        Begin
        if TDTRun() then
          Begin
            MyTestThread1 := TestTread.CreateIt(2,RP_ABR);
            TestThread1Active := true;
          end;
        end else Showmessage('Lost connection to TDT system');
   end
   else
   Begin
     If (MyTestThread1 = nil) then S:= 'MyTestThread1 = nil' else S:= 'MyTestThread1 <> nil';
     If (TestThread1Active = false) then S:=S+ ' ; TestThread1Active = false' else S:=s+ ' ; TestThread1Active = false';
     ShowMessage('TestThread still executing'+#10+S);
   end;
end;



procedure TTDTForm.TestThreadDone(var AMessage : TMessage);
var
 L,i,x:integer;
 Data:array of double ;
 raw_data:array of single;
Begin
  if (MyTestThread1 <> nil) then   TestThread1Active := false;
  if TestThread1Active <> false then Showmessage('TestThread1Active = True in TTDTForm.ThreadDone ')
  else
    Begin
        L:= Glob_NumberOf_Samples;
        setlength(raw_data,(8*L)+1);
        setlength(data,L);
        i:=RP_ABR.ReadTag('kanal1',raw_data[0],0,(8*L));
        

        for x:= 0 to 7 do For i:= 0 to L-1 do Data[i]:= Data[i]+raw_data[i+x*L];
        For i:= 0 to L-1 do Data[i]:= Data[i]/8;

      end;

 //if AMessage.LParam=1 then Form1.RunTest(Data) else Form1.Button2Click(Button2);
 Form1.RunTest(Data);
end;



procedure TTDTForm.CheckBox1Click(Sender: TObject);
var
S:string;
begin
  Glob_Directional_ABR:=CheckBox1.Checked;
  if Glob_Directional_ABR then S:= 'True' else S:='False';
  TDTForm.SaveLogFile('{Set} Directional ABR = '+ S);
end;



procedure TTDTForm.CheckBox_Invert_clickClick(Sender: TObject);
begin
  Glob_Invert_Click:= CheckBox_Invert_click.Checked;
end;


procedure TTDTForm.CheckBox_Save_wavClick(Sender: TObject);
begin
  Glob_Save_WavFile:= CheckBox_Save_wav.Checked;
end;

END.
