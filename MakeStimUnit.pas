unit MakeStimUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart, ComCtrls, FileCtrl, Wav_handler,
  Menus,math;
type
 TStimData = array of single;

Type TStimFile = Record
        Stim: TStimData;
        Burst: boolean;
        Reverse: boolean;
        Duration: double;
        RiseFall: double;
        Freq: double;
        comment: String[255];
        SampleRate: double;
        correction: double; //not used but could implement a calibration correction
        end;
type
  TMakeStimForm = class(TForm)
    Panel1: TPanel;
    Bt_Calculate_Stim: TButton;
    ComboBox1: TComboBox;
    Label5: TLabel;
    ComboBox2: TComboBox;
    Label6: TLabel;
    ComboBox3: TComboBox;
    Label7: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Chart2: TChart;
    LineSeries1: TLineSeries;
    Chart3: TChart;
    LineSeries3: TLineSeries;
    LineSeries4: TLineSeries;
    TabSheet3: TTabSheet;
    Chart1: TChart;
    LineSeries5: TLineSeries;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Bt_Load: TButton;
    Bt_save: TButton;
    RadioGroup1: TRadioGroup;
    Bt_Set_Dafault: TButton;
    Edit1: TEdit;
    PopupMenu1: TPopupMenu;
    SaveasBitmap1: TMenuItem;
    SaveasWMF1: TMenuItem;
    SaveasEMF1: TMenuItem;
    ComboBox4: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox5: TComboBox;
    Label3: TLabel;
    Button4: TButton;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    Function  UpdateChart(iNr:integer):boolean;
    procedure Bt_Calculate_StimClick(Sender: TObject);
    procedure ShowStim(var Stim:TStimFile);
    procedure MakeBurst(var Stim:TStimFile);
    procedure MakeClick(var Stim:TStimFile);
    procedure MakeChirp(var Stim:TStimFile; Freq2:single);
    procedure Save_Stim(MyStimfile:TStimFile ; Fname:string ; Dont_ask:boolean ; var FileNotSaved:boolean);
    procedure Load_Stim(var MyStimfile:TStimFile ; Fname:string ; Dont_ask:boolean ; var FileNotFound:boolean);
    procedure Load_Stim_silent(var MyStimfile:TStimFile ; Fname:string ; var FileNotFound:boolean);
    procedure Bt_LoadClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Bt_saveClick(Sender: TObject);
    procedure Bt_Set_DafaultClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SaveasBitmap1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    //procedure Button4Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MakeStimForm: TMakeStimForm;
  Glob_Stim_sampelrate: single;
  Local_New_StimFile: TStimFile;    // The working stimfile not used by TDT yet

implementation

uses TDTUnit;

{$R *.DFM}
{$M 16384,10485760}



{** Clean up a string that contain a float **}
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
      'E' : s2:=s2+'E';
      '.' : begin s2:=s2+DecimalSeparator; inc(p);  end;
      ',' : begin s2:=s2+DecimalSeparator; inc(p);  end;
      end;
    end;
    if p>1 then
    for i :=0 to p-2 do delete(s2,pos(DecimalSeparator,s2),1);
    if (s2<>'') and (s2[length(s2)]=DecimalSeparator) then delete(s2,length(s2),1);
CleanFloat:=s2;
end;



{** Initialize a Stim file **}
Procedure InitStimFile(var Stim:TstimFile);
Begin
  SetLength(Stim.Stim,0);
  Stim.Burst:=False;
  Stim.Duration:=0;
  Stim.RiseFall:=0;
  Stim.Freq:=0;
  Stim.comment:='';
  Stim.SampleRate:=0;
  Stim.correction:=0;
  Stim.Reverse:=false;
end;


{** Form Create **}
procedure TMakeStimForm.FormCreate(Sender: TObject);
begin
  Glob_Stim_sampelrate:=TDTForm.Get_TDT_Sampelrate('SOUND');
  Combobox5.Text:=Inttostr(round(Glob_Stim_sampelrate));
  InitStimFile(Local_New_StimFile);
end;


{** Spectrum setup **}
Function TMakeStimForm.UpdateChart(iNr:integer):boolean;
var
  max,min,temp:double;
Begin
  max:= Chart2.SeriesList[0].MaxYValue;
  min:= Chart2.SeriesList[0].MinYValue;
  if min>max then Begin temp:=min; Min:=max; Max:=temp; end;
  If min=max then max:=max+0.001;
  if Max<0 then Max:=Max*-1;
  Chart2.LeftAxis.Maximum:= Max*2;
  Chart2.LeftAxis.Minimum:= Min;
  if max>min then result:=true else result:=false;
end;



{** Make a new stimulus **}
procedure TMakeStimForm.Bt_Calculate_StimClick(Sender: TObject);
var
  freq2  : integer;
  MyStimFile: Tstimfile;
  flag: TReplaceFlags;
begin
{Init}
 Freq2:=        StrToInt(ComboBox4.Text);
 initStimFile(MyStimFile);
 MyStimFile.Duration:=StrToFloat(CleanFloat(ComboBox3.Text));
 MyStimFile.RiseFall:= StrToFloat(CleanFloat(ComboBox2.Text));
 MyStimFile.Freq:= StrToInt(ComboBox1.Text);
 MyStimFile.comment:=Edit1.Text;
 MyStimFile.SampleRate:= StrToFloat(CleanFloat(ComboBox5.Text));

 if (MyStimFile.SampleRate < 1) OR (MyStimFile.SampleRate > 900000) then
 Begin
   Showmessage('Invalid Samplerate '+FloatToStr(MyStimFile.SampleRate)+'Hz');
   MyStimFile.SampleRate := 24414;
 End;

 if MyStimFile.Duration<(MyStimFile.RiseFall*2) then
 Begin
   MyStimFile.RiseFall:= (MyStimFile.Duration/2);
   Showmessage(  'The duration of the signal has to be more than'+ #13
                +'twice the duration of the rise fall time'+
                'Rise fall time set to :'+FloatToStr(MyStimFile.RiseFall)+'ms');
   Combobox2.Text:=FloatToStr(MyStimFile.RiseFall);
 end;

 // The FFT I'm using has a max length if our stin is longer than that we warn the user
 if (MyStimFile.Duration*MyStimFile.SampleRate) > 21950 then
   Showmessage(  'The duration of the signal is too long for the FFT'+ #13
                +'analysis, it will be disabled for this stimuli');


 Edit1.Text:='_'+IntToStr(Round(MyStimFile.Freq))+'Hz_'+FloatToStr(MyStimFile.Duration)+'ms';
 Flag:= [rfReplaceAll];
 if pos('.',Edit1.Text)>0 then Edit1.Text:=StringReplace(Edit1.Text,'.','-',Flag);

 Case RadioGroup1.ItemIndex of
    0: MakeBurst(MyStimFile);             //Burst
    1: MakeClick(MyStimFile);             //click
    2: Bt_Load.Click;                     //Custom
    3: MakeChirp(MyStimFile,freq2);       //chirp
 End;

   Local_New_StimFile := MyStimFile;
   ShowStim(Local_New_StimFile);
   Bt_save.Enabled:=true;
   Bt_Set_Dafault.Enabled:=true;
end;



{*** Show Stimulus ***}
procedure TMakeStimForm.ShowStim(var Stim:TStimFile);
var
  Power,WavSignal:TSoundFile;
  TempStim: TStimData;
  i,L: integer;
  Corrupt : boolean;
  T:double;
begin
 Combobox5.Text:= FloatToStr(Stim.SampleRate);
 Combobox3.Text:= FloatToStr(Stim.Duration);
 Combobox2.Text:= FloatToStr(Stim.RiseFall);
 if Stim.Reverse then Combobox4.Text:= FloatToStr(Stim.Freq) else Combobox1.Text:= FloatToStr(Stim.Freq);

 T:= 1+round(Stim.Duration+(2*Stim.RiseFall));
 if Chart3.BottomAxis.Minimum<T then Chart3.BottomAxis.Maximum:= T;
 T:= 1+round(Stim.SampleRate/2);
 If Chart2.BottomAxis.Minimum<T then Chart2.BottomAxis.Maximum:= T; 

  TempStim:= Stim.Stim;
  L:= length(Stim.Stim);
  SetLength(WavSignal,L);
  For i :=0 to L-1 do WavSignal[i]:=Stim.Stim[i];
  Corrupt:= False;

  if L<21950 then
    Power:=SimpleFFT2(WavSignal)
  else
    Power:=0;

//Draw
 Chart1.Series[0].Clear;
 Chart2.Series[0].Clear;
 Chart3.Series[0].Clear;
 Chart3.Series[1].Clear;

 for i:=0 to length(TempStim)-1 do If (FloatToStr(TempStim[i]) = 'NAN') then Corrupt:=true  ;
 if not(Corrupt) then begin
   for i:=0 to length(TempStim)-1 do Chart3.Series[0].AddXY((i*1000/Stim.SampleRate),TempStim[i]); //osillogram
   for i:=0 to length(Power)-1 do Chart2.Series[0].AddXY(i*(Stim.SampleRate/(L)),Power[i]);  //spectre
 end else Showmessage('Data file Corrupt');

 UpdateChart(1);
end;


 {** Make a Tone Burst **}
procedure TMakeStimForm.MakeBurst(var Stim:TStimFile);
var
 RiseFall_S,Duration_S,fall_S:integer;
 Envelope:TStimData;
 i:integer;
begin
{Init}
  Stim.Burst:=True;
  RiseFall_S:=round(Stim.SampleRate/1000*Stim.RiseFall);
  Duration_S:=round(Stim.SampleRate/1000*Stim.Duration);
  Fall_S:=Duration_S-RiseFall_S;
  Setlength(Stim.Stim,Duration_S+4);
  Setlength(Envelope,Duration_S+4);
  for i:=0 to length(Stim.Stim)-1 do Stim.Stim[i]:=0;
  for i:=0 to length(Envelope)-1 do Envelope[i]:=0;
{Envelope}
If Risefall_S>0 then begin
  for i:=0 to RiseFall_S do Envelope[i]:= sqr(cos( (i*0.5*Pi)/RiseFall_S +(0.5*Pi) ));
  for i:=RiseFall_S to Fall_S do Envelope[i]:= 1;
  for i:=Fall_S to Duration_S do Envelope[i]:= sqr(cos( (((i-Fall_S)*0.5*Pi))/RiseFall_S) );
End else for i:=0 to Duration_S do Envelope[i]:= 1;

  for i:=Duration_S to length(Envelope)-1 do Envelope[i]:= 0;
{Stimulus}
  for i:=0 to length(Stim.Stim)-1 do Stim.Stim[i]:= sin(Stim.Freq*i*2*Pi/Stim.SampleRate);
  for i:=0 to length(Stim.Stim)-1 do Stim.Stim[i]:= Stim.Stim[i]*Envelope[i];
end;



 {*** Make a Click ***}
procedure TMakeStimForm.MakeClick(var Stim:TStimFile);
var
 Duration_S:integer;
 i,shift:integer;
begin
  shift:=2; //samples
  Duration_S:=round(Stim.SampleRate/1000*(Stim.Duration/2));
  Setlength(Stim.Stim,(2*Duration_S)+shift+4); // Adds a few samples in the end
  for i:=0 to length(Stim.Stim)-1 do Stim.Stim[i]:=0;
  for i:=0+shift to Duration_S+shift do Stim.Stim[i]:= 1;
  for i:=Duration_S+shift to (2*Duration_S)+shift do Stim.Stim[i]:= -1;
end;


{*** Make a Frequency Sweep ***}
procedure TMakeStimForm.MakeChirp(var Stim:TStimFile; Freq2:single);
var
 Duration_S, RiseFall_S:integer;
 i,L:integer;
 freq,Hold,phase,Envelope:double;
 HoldStim:TStimData;
begin
  If Stim.Freq>Freq2 then
 Begin
  Stim.Reverse:=True;
  Hold:=Stim.Freq;
  Stim.Freq:=Freq2;
  Freq2:=Hold;
 end;

{Init}
  Duration_S:=round(Stim.SampleRate/1000*Stim.Duration);
  RiseFall_S:=round(Stim.SampleRate/1000*Stim.RiseFall);
  Setlength(Stim.Stim,Duration_S+4);
  for i:=0 to length(Stim.Stim)-1 do Stim.Stim[i]:=0;
  phase:=0;    freq:=0;  Envelope:=0;
{calculation}
  For i:=0 to Length(Stim.Stim)-1 do
     Begin
       if (i<RiseFall_S+1) then freq:= Stim.Freq;
       if ((Duration_S-RiseFall_S)>i) AND (i>RiseFall_S)  then freq:= Stim.Freq + (i-RiseFall_S)*((Freq2-Stim.Freq)/(Duration_S-2*RiseFall_S));  //multiply slope with x to get the instantanious frequency
       if (i>(Duration_S-RiseFall_S)) then freq:= Freq2;

       if (i<RiseFall_S+1) then Envelope := Power( cos((i*0.5*pi)/RiseFall_S+0.5*pi) ,2);
       if ((Duration_S-RiseFall_S)>i) AND (i>RiseFall_S)   then Envelope := 1;
       if (i>(Duration_S-RiseFall_S)) AND (i<(Duration_S))   then Envelope := sqr(cos( (((i-(Duration_S-RiseFall_S))*0.5*Pi))/RiseFall_S) ); //Power( cos((i-(RiseFall_S+Duration_S))*0.5*pi / RiseFall_S ),2);

       phase := phase + (2*pi*freq)/Stim.SampleRate;
       Stim.Stim[i] := Envelope * sin(phase);
     end;

if Stim.Reverse then
  Begin
    SetLength(HoldStim,Length(Stim.Stim));
    L:= Length(Stim.Stim)-1 ;
    for i:=0 to L do HoldStim[i]  := Stim.Stim[L-i] ;
    for i:=0 to L do Stim.Stim[i] := HoldStim[i];
  end;
end;



{** Basic save function **}
Function Save_Stimfile(MyStimfile:TStimFile ; Fname:string):Boolean;
var
  F:textfile;
  s:String;
  i:integer;
Begin
  Result:=False;
  AssignFile(F,FName);
  Rewrite(F);
    writeln(F,'[settings]');
         If MyStimfile.Burst Then S:='1' else S:='0';
         writeln(F,'Burst='     +#9+          ( S                    ));
         If MyStimfile.Reverse Then S:='1' else S:='0';
         writeln(F,'Reverse='   +#9+          ( S                    ));
         writeln(F,'Duration='  +#9+FloatToStr( MyStimfile.Duration  ));
         writeln(F,'RiseFall='  +#9+FloatToStr( MyStimfile.RiseFall  ));
         writeln(F,'Freq='      +#9+FloatToStr( MyStimfile.Freq      ));
         writeln(F,'comment='   +#9+          ( MyStimfile.comment   ));
         writeln(F,'SampleRate='+#9+FloatToStr( MyStimfile.SampleRate));
         writeln(F,'correction='+#9+FloatToStr( MyStimfile.correction));
    writeln(F,'[/settings]');
    writeln(F,'[data]');
        For i:=0 to length(MyStimfile.Stim)-1 do  writeln(F,FloatToStr(MyStimfile.Stim[i]));
    writeln(F,'[/data]');
  CloseFile(F);
  Result:=True;
end;


{*** Save Stim file as ***}
procedure TMakeStimForm.Save_Stim(MyStimfile:TStimFile ; Fname:string ; Dont_ask:boolean ; var FileNotSaved:boolean);
var
  path:string;
begin
 FileNotSaved:=true;
 Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + 'stim\' ;
 MyStimfile.comment:= Fname;
 If dont_ask then begin
    if DirectoryExists(Path) then begin
      try
       Save_Stimfile(MyStimfile, Path+Fname);
       if fileexists(Path+Fname) then FileNotSaved:=False;
      except
       FileNotSaved:=true;
      end;
    end else  Showmessage(Path+Fname +#13+ ' Directory do not exists! file not saved!');
 end else begin
    SaveDialog1.InitialDir:= Path;
    SaveDialog1.FileName:=Fname;
    if SaveDialog1.Execute then begin
      try
       Save_Stimfile(MyStimfile, Savedialog1.FileName);
       if fileexists(Savedialog1.FileName) then FileNotSaved:=False;
      except
       FileNotSaved:=true;
      end;
    end;
 end;
end;



 {*******************}
Function StimRead(S,target:string):String;
Begin
  Result:='';
  if pos(LowerCase(target),LowerCase(S))>0 then
  Begin
    if pos(#9,S)>0 then Result:=Copy(S,pos(#9,S),Length(S))
        else if pos('=',S)>0 then Result:=Copy(S,pos('=',S),Length(S))
                else Result:='';
  end;
end;



 {** Basic Load function **}
Function Load_StimFile(FName:String):TStimFile ;
var
  F:textfile;
  s:String;
  L,Error:integer;
  Value:single;
Begin
    Error:=0;
    AssignFile(F, FName);
    Reset(F);
    Repeat
      Readln(F,S);
      if pos('[settings]',S)>0 then
        Repeat
          Readln(F,S);
          If StimRead(S,'Burst')<>''      then if CleanFloat(StimRead(S,'Burst'))='1' then  Result.Burst :=TRUE else Result.Burst :=FALSE ;
          If StimRead(S,'Reverse')<>''    then if CleanFloat(StimRead(S,'Burst'))='1' then  Result.Reverse :=TRUE else Result.Reverse :=FALSE ;
          If StimRead(S,'Duration')<>''   then Result.Duration   := StrToFloat(CleanFloat(StimRead(S,'Duration')));
          If StimRead(S,'RiseFall')<>''   then Result.RiseFall   := StrToFloat(CleanFloat(StimRead(S,'RiseFall')));
          If StimRead(S,'SampleRate')<>'' then Result.SampleRate := StrToFloat(CleanFloat(StimRead(S,'SampleRate')));
          If StimRead(S,'correction')<>'' then Result.correction := StrToFloat(CleanFloat(StimRead(S,'correction')));
          If StimRead(S,'Freq')<>''       then Result.Freq       := StrToFloat(CleanFloat(StimRead(S,'Freq')));
          If StimRead(S,'comment')<>''    then Result.comment :=StimRead(S,'comment');
        Until (pos('[/settings]',S)>0) OR (pos('[data]',S)>0);

      if pos('[data]',S)>0 then
        Begin
          Readln(F,S);
          Repeat
            try
              value:=StrToFloat(CleanFloat(S));
              L:=Length(Result.Stim);
              Setlength(Result.Stim,L+1);
              Result.Stim[L]:=value;
            except
             Inc(Error);
            end;
            Readln(F,S);
          Until (pos('[/data]',S)>0) or EOF(F) or (error>3);
          if error>0 then Showmessage('some of the data in the stimfile was not read correctly: Errors='+inttoStr(error));
        end;
    until EOF(F);
  CloseFile(F);
end;


{*** Load Stim file ***}
procedure TMakeStimForm.Load_Stim(var MyStimfile:TStimFile ; Fname:string ; Dont_ask:boolean ; var FileNotFound:boolean);
var
  Ch1,Ch2: TSoundFile;
  header:TWavheader;
  path:string;
  i:integer;
begin
   FileNotFound:= true;
   Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + 'stim\'  ;
   opendialog1.InitialDir:= Path;
   opendialog1.Filter:='Stim Files|*.AB9|Wav Files|*.Wav';
   Path:= Path + FName;
   if not(dont_ask) then
      If opendialog1.Execute then
          path:= opendialog1.FileName;

   If FileExists(path) then
        begin
         if '.WAV'= Uppercase(ExtractFileExt(path)) then
                Begin
                  LoadWavFile(opendialog1.FileName,Ch1,Ch2,header);
                  Showmessage(HeaderToStr(header));
                  SetLength(MyStimfile.Stim,Length(Ch1));
                  for i:=0 to length(MyStimfile.Stim)-1 do MyStimfile.Stim[i]:=Ch1[i];
                  MyStimfile.SampleRate:= header.samplerate;
                  MyStimfile.Burst:=false;
                  MyStimfile.RiseFall:=0;
                  MyStimfile.Duration:= 1000*(Length(Ch1)/Mystimfile.SampleRate);
                  MyStimfile.correction:=0;
                  MyStimfile.Freq:=0;
                  MyStimfile.comment:='Loaded from wavefile';
                  Local_New_StimFile:= MyStimfile;
                  ShowStim(MyStimfile);
                end
             Else
                Begin
                  MyStimfile:=Load_StimFile(path);
                  if MyStimfile.Duration>0 then  // if the duration is 0 the file is probably enpty
                  Begin
                    FileNotFound:= false;
                    If MyStimfile.SampleRate<1 then MyStimfile.SampleRate:=24414;
                    ShowStim(MyStimfile);
                    Local_New_StimFile:= MyStimfile;
                    Combobox3.Text:= floattostrF( MyStimFile.Duration, ffGeneral ,2,2);
                    Combobox2.Text:= floattostrF( MyStimFile.RiseFall, ffGeneral ,2,2 );
                    Combobox1.Text:= floattostr ( MyStimFile.Freq );
                    Edit1.Text:= MyStimFile.comment;
                  end else showmessage('File had no content, it might be an older filetype or corrupted')

                End;
             //Local_New_StimFile:= MyStimfile;
             //ShowStim(MyStimfile);
        end;

   If FileNotFound AND dont_ask then showmessage('File not found' +#13+ path);
end;



{*** Load Stim file *** SILENT ***}
{ used to load a file without create.form }
procedure TMakeStimForm.Load_Stim_silent(var MyStimfile:TStimFile ; Fname:string ; var FileNotFound:boolean);
var
  path:string;
begin
   FileNotFound:= true;
   Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + 'stim\'+ FName  ;
   If FileExists(path) then
        begin
         MyStimfile:=Load_StimFile(Path);
         Glob_Stim_file_name:=FName;
         FileNotFound:= false;
        end else showmessage('File not found '+path);
end;


   {Load button Click}
procedure TMakeStimForm.Bt_LoadClick(Sender: TObject);
var
 MyStimfile:TStimFile ;
 Fname:string ;
 FileNotFound:boolean;
begin
  Fname:= ' ';
  FileNotFound:= true;
  Load_Stim(MyStimfile, Fname, false, FileNotFound);
end;



procedure TMakeStimForm.RadioGroup1Click(Sender: TObject);
begin
  Edit1.Text:='';
  Case RadioGroup1.ItemIndex of
    0: begin  //Burst
        Combobox3.Enabled := True;    //Rise fall
        Combobox2.Enabled := True;    //Duration
        Combobox1.Enabled := True;    //Start Freq
        Combobox4.Enabled := False;   //End Freq
        Label1.Visible:=False;  Label2.Visible:=False; Combobox4.Visible := False;
       end;

    1: begin  //Click
        Combobox3.Enabled := True;    //Rise fall
        Combobox2.Enabled := False;   //Duration
        Combobox1.Enabled := False;   //Start Freq
        Combobox4.Enabled := False;   //End Freq
        Label1.Visible:=False;  Label2.Visible:=False; Combobox4.Visible := False;
       end;

    2: begin  //custom
        Showmessage('This function is not implemented yet');
        Combobox3.Enabled := False;   //Rise fall
        Combobox2.Enabled := False;   //Duration
        Combobox1.Enabled := False;   //Start Freq
        Combobox4.Enabled := False;   //End Freq
        Label1.Visible:=False;  Label2.Visible:=False; Combobox4.Visible := False;
       end;

    3: begin  //chirp
        Combobox3.Enabled := True;   //Rise fall
        Combobox2.Enabled := True;   //Duration
        Combobox1.Enabled := True;   //Start Freq
        Combobox4.Enabled := True;   //End Freq
        
        Label1.Visible:=true;  Label2.Visible:=true; Combobox4.Visible := True;
       end;
  end;
end;






procedure TMakeStimForm.Bt_saveClick(Sender: TObject);
var
 FileNotSaved:boolean;
begin
 If Edit1.Text<>'' then
 begin
 FileNotSaved:=true;
 Save_Stim(Local_New_StimFile, Edit1.Text , false , FileNotSaved ); //Save the new stimfile
 If FileNotSaved then showmessage('File not saved') else Bt_Save.Enabled:=False;
 end else Showmessage('"" not a valid stimulus name');
end;



procedure TMakeStimForm.Bt_Set_DafaultClick(Sender: TObject);
var
 NotSaved:boolean;
begin
 Save_Stim(Local_New_StimFile, 'standart.AB9' , true, NotSaved);  //Should not be used 'standart' is a bad name
 if NotSaved then showmessage('file not saved') else showmessage(Local_New_StimFile.comment+ ' set as default');
end;


procedure TMakeStimForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
TDTForm.PopulateCBox5();
TDTForm.Visible:=True;
if Bt_Save.Enabled then Showmessage('Stimulus not saved');
end;


procedure TMakeStimForm.SaveasBitmap1Click(Sender: TObject);
var
  S:string;
begin
  SaveDialog1.FileName:='Powerspectrum01';
  SaveDialog1.Filter:= 'Image Files|*.wmf;*.emf;*.bmp|All files|*.*' ;
 if SaveDialog1.Execute then
   Begin
     // Gemmer Windows meta file
     if Sender=SaveasWMF1 then
                Begin
                  S:=ChangeFileExt(SaveDialog1.FileName,'.WMF');
                  Chart2.SaveToMetafile(S);
                End;
     // Gemmer Enhanced Metafile
     if Sender=SaveasEMF1 then
                Begin
                  S:=ChangeFileExt(SaveDialog1.FileName,'.EMF');
                  Chart2.SaveToMetafile(S);
                End;
     // Gemmer Bitmap File
     if Sender=SaveasBitmap1  then
                Begin
                  S:=ChangeFileExt(SaveDialog1.FileName,'.BMP');
                  Chart2.SaveToMetafile(S);
                End;
   End;
end;



procedure TMakeStimForm.FormActivate(Sender: TObject);
begin
TDTForm.Visible:=false;
end;


procedure TMakeStimForm.ComboBox5Change(Sender: TObject);
begin
 if length(Local_New_StimFile.Stim) > 1 then
 Begin
   Local_New_StimFile.SampleRate:= StrToInt(ComboBox5.Text);
   ShowStim(Local_New_StimFile);
 End;
end;


procedure TMakeStimForm.ComboBox3Change(Sender: TObject);
begin
Edit1.Text:='';
end;


{procedure TMakeStimForm.Button4Click(Sender: TObject);
var
 Ch1,Ch2: TSoundFile;
 header:TWavheader;
 MyStim  :TStimFile;
 i:integer;
begin
  If opendialog1.Execute then
    Begin
          LoadWavFile(opendialog1.FileName,Ch1,Ch2,header);

          Showmessage(HeaderToStr(header));
          SetLength(MyStim.Stim,Length(Ch1));
          for i:=0 to length(MyStim.Stim)-1 do MyStim.Stim[i]:=Ch1[i];
          MyStim.Burst:=false;
          MyStim.Duration:=1000;
          MyStim.RiseFall:=0;
          MyStim.Freq:=0;
          MyStim.comment:='Loaded from wavefile';
          ShowStim(MyStim);
    end;
end; }

end.
