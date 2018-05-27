unit ReadUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, TeeProcs, TeEngine, Chart, Series, ABR, StdCtrls,FilterUnit,
  TDTUnit,commonUnit, ComCtrls, ImgList, CheckLst, FileCtrl, INIfiles,
   math,ReadSettings,Wav_handler;



type
PMyRec = ^TMyRec;
TMyRec = record
  FName : string;
  Fpp   : single;
  Flat  : single;
  FppDD : single;
  SNR   : single;
  Xcor  :single;
  FXcorr : single;  // filtered cross correlation
  JewettP :TJewett;
  JewettN :TJewett;
  JewettPamp :TJewettAmp;
  JewettNamp :TJewettAmp;
end;

type
  TReadForm = class(TForm)
    MainMenu1: TMainMenu;
    Chart1: TChart;
    File1: TMenuItem;
    Save1: TMenuItem;
    Series1: TLineSeries;
    OpenDialog1: TOpenDialog;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Series5: TLineSeries;
    Series6: TLineSeries;
    Series7: TLineSeries;
    Series8: TLineSeries;
    Series9: TLineSeries;
    Series10: TLineSeries;
    Series11: TLineSeries;
    SaveImage1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    TreeView1: TTreeView;
    ImageList1: TImageList;
    OpenDialog2: TOpenDialog;
    Series12: TLineSeries;
    Series13: TLineSeries;
    Series14: TLineSeries;
    Series15: TLineSeries;
    Label4: TLabel;
    Directory1: TMenuItem;
    Load1: TMenuItem;
    Save2: TMenuItem;
    Make1: TMenuItem;
    Export1: TMenuItem;
    SaveDialog2: TSaveDialog;
    PopupMenu1: TPopupMenu;
    Show1: TMenuItem;
    Delete1: TMenuItem;
    Edit1: TEdit;
    LPFilter1: TMenuItem;
    None1: TMenuItem;
    N40001: TMenuItem;
    N35001: TMenuItem;
    N30001: TMenuItem;
    N25001: TMenuItem;
    N20001: TMenuItem;
    Setup1: TMenuItem;
    ExportLatency1: TMenuItem;
    ExportPeakDD1: TMenuItem;
    ExportSNR1: TMenuItem;
    ScrollBar1: TScrollBar;
    ExportXcorr1: TMenuItem;
    ExportXcorrF1: TMenuItem;
    OpenRAW1: TMenuItem;
    Series16: TPointSeries;
    Series17: TPointSeries;
    ExportJewett1: TMenuItem;
    ConvertAB3toCSV1: TMenuItem;
    ExportJewettamp1: TMenuItem;

    Procedure Get_PP_og_latens(filename: string; var ppDif,pp,lat,SNR,Xcor,FXcor: single; var ABR_Info:TABR_Info);
    Function InitJewetMarks(MyChart:Tchart):Boolean;

    Function IntToColor(Nr:integer):TColor ;
    Function Brighten(Mycolor:TColor;Increase:Integer):TColor;

    Procedure SaveMatFileformat(ABR_Data:TABR_Data ;ABR_Info:TABR_Info; FName:string);
    Procedure LoadMatFileformat(var ABR_Data:TABR_Data; var ABR_Info:TABR_Info; FName:string);
    Procedure ReadMF2(Filename  : string; var ABR_Data:TABR_Data; var ABR_Info:TABR_Info);
    procedure SettingsSet(Sett:TGraphSettings);
    procedure SaveJewet(node:integer);
    Procedure kompakt();
    procedure InitTree();

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EksportTree(dType:integer);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1Changing(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure Make1Click(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure TreeView1Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure ExportJewett1Click(Sender: TObject);
    procedure Chart1UndoZoom(Sender: TObject);
    procedure SaveImage1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Save2Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure Show1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure Setup1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure OpenRAW1Click(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure ConvertAB3toCSV1Click(Sender: TObject);
    procedure ExportJewettamp1Click(Sender: TObject);
    


  private
    { Private declarations }
  public
    { Public declarations }
  end;

const   
 AntalKurver:  integer=15  ;


var
  ReadForm  : TReadForm;
  Aktiv_data: integer;
  ActivePanel: TObject;
  Displace_series: Array[0..10] of double;
  TDTData6: array[1..9] of TFilterData;
  Glob_Background: boolean;



implementation

uses ReadUnit2,  ExportUnit, JewetUnit;

var
Read1Settings : TGraphSettings;

{$R *.DFM}
{$M 16384,10485760}





{** Defines the range of colours used for the graphs **}

Function TReadForm.IntToColor(Nr:integer):TColor;
Begin
 Nr:= Nr-((Trunc(Nr/10))*10);

 Case Nr of
   1 : IntToColor:=$0047239b;
   2 : IntToColor:=$005716f0;
   3 : IntToColor:=$007a1e8d;
   4 : IntToColor:=$00cf0ef5;
   5 : IntToColor:=$008c216a;
   6 : IntToColor:=$000022ff;
   7 : IntToColor:=$00fa391d;
   8 : IntToColor:=$00ff0000;
   9 : IntToColor:=$00000000;
   0 : IntToColor:=$0006b409;
 else
  Showmessage('Color Error'+IntToStr(Nr));
  IntToColor:=$0006b409;
 end;
End;



        {** converts Hexadecimal numbers to decimal **}
 {** all non hex chars are ignored without raising an error **}

Function HexToInt(S:String):integer;
var
i,z:integer;
d:double;
Begin
  S:=LowerCase(S);
  d:=0;
  for i:= length(S) downto 0 do
    Begin
    z:= length(S)-i;
    case S[i] of
      ' ' : d:=d;
      '0' : d:=d;
      '1' : d:=d+1*Intpower(16,z);
      '2' : d:=d+2*Intpower(16,z);
      '3' : d:=d+3*Intpower(16,z);
      '4' : d:=d+4*Intpower(16,z);
      '5' : d:=d+5*Intpower(16,z);
      '6' : d:=d+6*Intpower(16,z);
      '7' : d:=d+7*Intpower(16,z);
      '8' : d:=d+8*Intpower(16,z);
      '9' : d:=d+9*Intpower(16,z);
      'a' : d:=d+10*Intpower(16,z);
      'b' : d:=d+11*Intpower(16,z);
      'c' : d:=d+12*Intpower(16,z);
      'd' : d:=d+13*Intpower(16,z);
      'e' : d:=d+14*Intpower(16,z);
      'f' : d:=d+15*Intpower(16,z);
      end;
  end;
  Result:=Round(d);
end;



  {** Modifies a color, positive numbers make it brighter and negative numbers darker **}
           {** Numbers outside -255 to 255 make it white or black **}

Function TReadForm.Brighten(Mycolor:TColor;Increase:Integer):TColor;
var
 HexString:string;
 R,G,B: Integer;
Begin
 HexString:=IntToHex(ColorToRGB(Mycolor),6);

 R:= HexToInt(copy(HexString,1,2));
 G:= HexToInt(copy(HexString,3,2));
 B:= HexToInt(copy(HexString,5,2));

 R:= R + Increase;
 if R>255 then R:=255;
 if R<0 then R:=0;

 G:= G + Increase;
 if G>255 then G:=255;
 if B<0 then B:=0;

 B:= B + Increase;
 if B>255 then B:=255;
 if B<0 then B:=0;

 Result:=StringToColor( '$00'+IntToHex(R,2)+IntToHex(G,2)+IntToHex(B,2) );
end;



//*********** Converts old fileformat to other old file format

Function MyF2ToMyF1(MyFile2  : TMeasFile2): TMeasFile;
var
 i,k:integer;
Begin
 Result.Kommentar :=   MyFile2.Kommentar;
 Result.Kommentar2 :=   MyFile2.Kommentar2;
 Result.SampelRate :=   MyFile2.SampelRate;
 Result.Filter :=   MyFile2.Filter;
 Result.Jewett :=   MyFile2.Jewett;
 Result.Amp_Tone :=   MyFile2.Amp_Tone;
 Result.Freq_Tone :=   MyFile2.Freq_Tone;
 Result.Amp_Klik:=   MyFile2.Amp_Klik;
 Result.Freq_Klik :=   MyFile2.Freq_Klik;
 Result.Nr :=   MyFile2.Nr;
 Result.Tag :=   MyFile2.Tag;
 For k:=0 to length(Result.Meas)-1 do
        Begin
         for i:= 0 to length(Result.Resume)-1 do Result.Meas[k,i]:= 0;
         for i:= 0 to length(MyFile2.Resume)-1 do Result.Meas[k,i]:= MyFile2.Meas[k,i];
        end;
 for i:= 0 to length(Result.Resume)-1 do Result.Resume[i]:= 0;
 for i:= 0 to length(MyFile2.Resume)-1 do Result.Resume[i]:= MyFile2.Resume[i];
end;


//*************************

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



//*************************

Function MatRead(S,target:string):String;
Begin
Result:='';
if pos(LowerCase(target),LowerCase(S))>0 then
  Begin
    if pos(#9,S)>0 then Result:=Copy(S,pos(#9,S),Length(S))
        else if pos('=',S)>0 then Result:=Copy(S,pos('=',S),Length(S))
                else Result:='';
  end;
end;



  // extracts the first number from a string and then deletes it

Procedure ExtractNumbers(Var S:string; var Vn:TSoundFile; seperator:string);
var
 L:Integer;
Begin
 L:= Length(Vn);
 if pos(seperator,S)>0 then
   Begin
     SetLength(Vn,L+1);
     Vn[L]:=StrToFloat(CleanFloat(copy(S,0,pos(#9,S))));
     Delete(S,1,pos(#9,S));
   End
 else
   Begin
     If Length(CleanFloat(S))>0 then
     Begin
       SetLength(Vn,L+1);
       Vn[L]:=StrToFloat(CleanFloat(S));
       S:='';
     end;
   end;
end;



  {****  Extracts 9 integers from a tab(#9) separated string  ****}

Function StrToJewet(Str:String):TJewett;
var
 i:integer;
 S1:string;
Begin
 i:=0;
 Delete(Str,1,pos(#9,Str));
 Repeat
  inc(i);
  if pos(#9,Str)>0 then S1:= CleanFloat(copy(Str,0,pos(#9,Str))) else S1:=CleanFloat(Str) ;
  if S1<>'' then Result[i]:=StrToInt(S1) else Result[i]:=-1 ;
  Delete(Str,1,pos(#9,Str));
 until i=9;
End;

    {****  Extracts 9 Float from a tab(#9) separated string  ****}
Function StrToJewetFloat(Str:String):TJewettAmp;
var
 i:integer;
 S1:string;
Begin
 i:=0;
 Delete(Str,1,pos(#9,Str));
 Repeat
  inc(i);
  if pos(#9,Str)>0 then S1:= CleanFloat(copy(Str,0,pos(#9,Str))) else S1:=CleanFloat(Str) ;
  if S1<>'' then Result[i]:=StrToFloat(S1) else Result[i]:=-1000 ;
  Delete(Str,1,pos(#9,Str));
 until i=9;
End;

//*************************

Function StrArrayToInt(Str:String; nr:integer): integer;
var
 i:integer;
 S1:string;
Begin
 i:=0;
 Delete(Str,1,pos(#9,Str));
 Repeat
  S1:= CleanFloat(copy(Str,0,pos(#9,Str)));
  if S1<>'' then Result:=StrToInt(S1) else Result:=-1 ;
  Delete(Str,1,pos(#9,Str));
  inc(i);
 until i=nr+1;
End;




//*************************

Function SNR_variance(sub3,bufA,bufB: TSoundFile):double;
var
  i,L1,L2:integer;  //
  Avr_Signal,Avr_Noise,Var_Signal,Var_Noise:double;
Begin
  L1:=  Read1Settings.PPFromSample;
  L2:=  Read1Settings.PPToSample;

  if L2>Length(sub3)-1 then L2:=Length(sub3)-1;
  if L1>(L2-1) then L1:=(L2-1);
  Avr_Signal:=0;  Avr_Noise:=0;  Var_Signal:=0;  Var_Noise:=0;

  for i:=L1 to L2 do
    Begin
      Avr_Signal:= Avr_signal + sub3[i];
      Avr_Noise := Avr_Noise + (bufA[i]-bufB[i])/2;
    end;
  Avr_Signal:=Avr_Signal/(L2-L1);
  Avr_Noise:=Avr_Noise/(L2-L1);

  for i:=L1 to L2 do
    Begin
      Var_Signal := Var_Signal+  sqr(sub3[i]-Avr_Signal);     //empiriske varians * n
      Var_Noise  := Var_Noise+  sqr(((bufA[i]-bufB[i])/2)-Avr_Noise);     //empiriske varians * n
    end;
  Var_Signal:=Var_Signal/(L2-L1); //empiriske varians //S2
  Var_Noise:=Var_Noise/(L2-L1); //empiriske varians //S2
  if Var_Noise<>0 then Result:=  Var_Signal/Var_Noise else Result:=0;
end;



 { extracts the recording info from the filename }
Procedure ExtractFileInfo(filename:string; var ID:string; var stim,freq,dB:string);
var
 S:string;
 i:integer;
 strs: array of string;
Begin
  S:=ExtractFileName(filename);
  delete(S,pos('.',S),4);  // remove extension
  i:=0;
  Repeat
    SetLength(strs,i+1);
    strs[i]:=copy(S,1,pos('_',S)-1);
    delete(S,1,pos('_',S));
    inc(i);
  until pos('_',S)=0;

 SetLength(strs,i+1);
 strs[i]:=S;
 ID:=strs[0];
 stim:=strs[i-2];
 freq:=copy(strs[i-1],1,pos('Hz',strs[i-1])-1);
 dB:=copy(strs[i],1,pos('dB',strs[i])-1);
end;



   {**sorts the frequencies by absolut value  **}
function CustomSortProc(Node1, Node2: TTreeNode; Data: Integer): Integer; stdcall;
var
S1,S2:string;
begin
  S1:= Node1.Text;
  S2:= Node2.Text;
  Delete(S1,pos(' ',S1),3);
  Delete(S2,pos(' ',S2),3);
  Result := (StrToInt(S1)-StrToInt(S2));

end;



//***************** Sorts file names for showing

Procedure MySort(var FNames: array of string; Wcount:integer);
var
 i:integer;
 S,Ss,freq,db,db2,StimName: String;
 Bytted: boolean;
Begin
 Repeat
 Bytted:=False;
   for i:=0 to Wcount-1 do begin
     ExtractFileInfo(FNames[i],Ss,StimName,freq,db);
     ExtractFileInfo(FNames[i+1],Ss,StimName,freq,db2);
     if StrToInt(db)<StrToInt(db2) then Begin
       S:=FNames[i];
       FNames[i]:=FNames[i+1];
       FNames[i+1]:=S;
       Bytted:=true;
     end;
   end;
  Until Bytted=False;
End;




//*****************************************************
//*********************************************** **** ***
//    Here the handeling of data starts           ****  ***
//*********************************************** **** ***
//******************************************************



  {** Load Settings **}
procedure GetSettings();
var
  MyINI: TINIFile;
  Path: String;
Begin
 Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 MyINI := TINIFile.create(path+'settings.ini');
  Read1Settings.ShowBuffers   := MyINI.ReadBool('RU1_Setup','ABR_Show_AB',True);
  Read1Settings.Show_inverted := MyINI.ReadBool('RU1_Setup','ABR_Show_inv',false);
  Read1Settings.Offset        := 0;
  Read1Settings.FromSample    := MyINI.ReadInteger('RU1_Setup','MinS',0);
  Read1Settings.ToSample      := MyINI.ReadInteger('RU1_Setup','MaxS',400);
  Read1Settings.Filter_freq   := MyINI.ReadInteger('RU1_Setup','FilterFreq',-1);
  Read1Settings.PPFromSample  := MyINI.ReadInteger('RU1_Setup','PPminS',0);
  Read1Settings.PPToSample    := MyINI.ReadInteger('RU1_Setup','PPmaxS',400);
  Read1Settings.CurveDistance := MyINI.ReadFloat  ('RU1_Setup','Dist',1);
  Read1Settings.SampleRate    := MyINI.ReadFloat  ('RU1_Setup','SampleRate',24414);
  Read1Settings.TotalSamples  := MyINI.ReadInteger('RU1_Setup','TotalSamples',400);
  Read1Settings.Show_Jewet    := MyINI.ReadBool('RU1_Setup','Show_Jewet',false);
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
     MyINI.WriteBool(   'RU1_Setup','ABR_Show_AB' ,  Read1Settings.ShowBuffers  );
     MyINI.WriteBool(   'RU1_Setup','ABR_Show_inv',  Read1Settings.Show_inverted);
     MyINI.WriteInteger('RU1_Setup','MinS',          Read1Settings.FromSample   );
     MyINI.WriteInteger('RU1_Setup','MaxS',          Read1Settings.ToSample     );
     MyINI.WriteInteger('RU1_Setup','FilterFreq',    Read1Settings.Filter_freq  );
     MyINI.WriteInteger('RU1_Setup','PPminS',        Read1Settings.PPFromSample );
     MyINI.WriteInteger('RU1_Setup','PPmaxS',        Read1Settings.PPToSample   );
     MyINI.WriteFloat(  'RU1_Setup','Dist',          Read1Settings.CurveDistance);
     MyINI.WriteFloat(  'RU1_Setup','SampleRate',    Read1Settings.SampleRate   );
     MyINI.WriteInteger('RU1_Setup','TotalSamples',  Read1Settings.TotalSamples );
     MyINI.WriteBool(   'RU1_Setup','Show_Jewet',    Read1Settings.Show_Jewet   );
 MyINI.free;
end;




procedure TReadForm.FormCreate(Sender: TObject);
var
  i:integer;
begin
  Aktiv_Data:=0;
  for i:=0 to 10 do Displace_series[i]:=0;
  //My_LP_Filter_freq:=-1;
  Glob_Background:=false;
  //ABR_Show_AB:=true;
  GetSettings();
end;


//*************************

procedure TReadForm.FormDestroy(Sender: TObject);
begin
  SaveSettings();
end;

//*************************

function HP_filter_Xcorr(Data1,Data2:TSoundFile; fromS,toS:integer; samplerate:single):Single;
var
 Cutoff_Low,Cutoff_High:integer;
Begin
  Cutoff_Low:=100;
  Cutoff_High:=3000;
  Result:=CrossCorr(FilterHP(Data1,Cutoff_Low,samplerate),FilterHP(Data2,Cutoff_Low,samplerate), fromS,toS,Cutoff_High  );

end;

// Analyze the data in a ABR measurement
Procedure TReadForm.Get_PP_og_latens(filename: string; var ppDif,pp,lat,SNR,Xcor,FXcor: single; var ABR_Info:TABR_Info);
var
 ABR_Data:TABR_Data;
 UnMasked,Masked,Diff:TSoundFile;
 fromS,toS:integer;
 Autocorrelation:single;
begin
  ReadForm.LoadMatFileformat(ABR_Data,ABR_Info,filename);
  fromS:=   Read1Settings.PPFromSample;
  toS:=   Read1Settings.ToSample;
  if ABR_Info.Masked then
    Begin    // calculate all the analysis values for masked ABR measurements
        UnMasked:=WavAvr(ABR_Data[0],ABR_Data[1]);
        Masked:=WavAvr(ABR_Data[2],ABR_Data[3]);
        Diff:= WavSubtract(UnMasked,Masked);
        pp:=FindPeakPpeakValue(UnMasked, fromS, toS); // peak peak of unmasked signal

        ppDif:=FindPeakPpeakValue(Diff,fromS,toS);
        if Length(UnMasked)=Length(Masked) then lat:=CrossCorrDelay(UnMasked,Masked,fromS,toS) else lat:=-1;
        SNR:= SNR_variance(Diff,WavSubtract(ABR_Data[1],ABR_Data[3]),WavSubtract(ABR_Data[0],ABR_Data[2]));
        Autocorrelation:=  HP_filter_Xcorr(UnMasked,UnMasked,fromS,toS,ABR_Info.SampelRate);
        Memo1.Lines.Add(filename +' - '+  FloatToStr(Autocorrelation) +' - '+ FloatToStr(HP_filter_Xcorr(UnMasked,Masked,fromS,toS,ABR_Info.SampelRate)) );
        if Autocorrelation<>0 then  Xcor:= (Autocorrelation - HP_filter_Xcorr(UnMasked,Masked,fromS,toS,ABR_Info.SampelRate) ) / Autocorrelation else Xcor:=0;
        FXcor:= CrossCorr(UnMasked,Masked,fromS,toS,Read1Settings.Filter_freq);
    end else Begin    // calculate all the analysis values for UNmasked ABR measurements
        UnMasked:=WavAvr(ABR_Data[0],ABR_Data[1]);
        Diff:= WavSubtract(ABR_Data[0],ABR_Data[1]);
        pp:=FindPeakPpeakValue(UnMasked,fromS,toS);
        ppDif:=FindPeakPpeakValue(Diff,fromS,toS);
        if Length(ABR_Data[0])=Length(ABR_Data[1]) then lat:=CrossCorrDelay(ABR_Data[0],ABR_Data[1],fromS,toS) else lat:=-1;
        SNR:= SNR_variance(Diff,ABR_Data[0],ABR_Data[1]);
        Autocorrelation:= HP_filter_Xcorr(ABR_Data[0],ABR_Data[0],fromS,toS,ABR_Info.SampelRate);
        if Autocorrelation<>0 then Xcor:=(Autocorrelation - HP_filter_Xcorr(ABR_Data[0],ABR_Data[1],fromS,toS,ABR_Info.SampelRate) )/ Autocorrelation else Xcor:=0;
        FXcor:= CrossCorr(ABR_Data[0],ABR_Data[1],fromS,toS,Read1Settings.Filter_freq);
    end;
end;


//*************************

/// <summary>
/// Saves data in mat file format
/// </summary>
Procedure  TReadForm.SaveMatFileformat(ABR_Data:TABR_Data ;ABR_Info:TABR_Info; FName:string);
var
  F:textfile;
  s:String;
  i:integer;
  masked:Boolean;
Begin
  if ABR_Info.Masked then masked:=TRUE else masked:=FALSE;
  AssignFile(F,FName);
  Rewrite(F);
    writeln(F,'[settings]');
      writeln(F,'Numbers_of_Awarages='+#9+
            IntToStr(ABR_Info.Numbers_of_Awarages[0])+#9+
            IntToStr(ABR_Info.Numbers_of_Awarages[1])+#9+
            IntToStr(ABR_Info.Numbers_of_Awarages[2])+#9+
            IntToStr(ABR_Info.Numbers_of_Awarages[3])+#9);
      writeln(F,'Max_Awarages='+#9+IntToStr(ABR_Info.Max_avarages));
      writeln(F,'Kommentar='+#9+ABR_Info.Kommentar );
      writeln(F,'Kommentar2='+#9+ABR_Info.Kommentar2 );
      writeln(F,'Program_version='+#9+ABR_Info.Program_version );
      writeln(F,'SOUND_SampelRate='+#9+FloatToStr(ABR_Info.SampelRate));
      writeln(F,'ABR_SampelRate='+#9+FloatToStr(ABR_Info.ABR_SampleRate ));
      writeln(F,'Filter='+#9+IntToStr(ABR_Info.Filter));
      writeln(F,'JewettP='+#9+
            IntToStr(ABR_Info.JewettP[1])+#9+
            IntToStr(ABR_Info.JewettP[2])+#9+
            IntToStr(ABR_Info.JewettP[3])+#9+
            IntToStr(ABR_Info.JewettP[4])+#9+
            IntToStr(ABR_Info.JewettP[5])+#9+
            IntToStr(ABR_Info.JewettP[6])+#9+
            IntToStr(ABR_Info.JewettP[7])+#9+
            IntToStr(ABR_Info.JewettP[8])+#9+
            IntToStr(ABR_Info.JewettP[9])+#9);
      writeln(F,'JewettN='+#9+
            IntToStr(ABR_Info.JewettN[1])+#9+
            IntToStr(ABR_Info.JewettN[2])+#9+
            IntToStr(ABR_Info.JewettN[3])+#9+
            IntToStr(ABR_Info.JewettN[4])+#9+
            IntToStr(ABR_Info.JewettN[5])+#9+
            IntToStr(ABR_Info.JewettN[6])+#9+
            IntToStr(ABR_Info.JewettN[7])+#9+
            IntToStr(ABR_Info.JewettN[8])+#9+
            IntToStr(ABR_Info.JewettN[9])+#9);
      writeln(F,'JewettPAmp='+#9+
            FloatToStr(ABR_Info.JewettPAmp[1])+#9+
            FloatToStr(ABR_Info.JewettPAmp[2])+#9+
            FloatToStr(ABR_Info.JewettPAmp[3])+#9+
            FloatToStr(ABR_Info.JewettPAmp[4])+#9+
            FloatToStr(ABR_Info.JewettPAmp[5])+#9+
            FloatToStr(ABR_Info.JewettPAmp[6])+#9+
            FloatToStr(ABR_Info.JewettPAmp[7])+#9+
            FloatToStr(ABR_Info.JewettPAmp[8])+#9+
            FloatToStr(ABR_Info.JewettPAmp[9])+#9);
      writeln(F,'JewettNAmp='+#9+
            FloatToStr(ABR_Info.JewettNAmp[1])+#9+
            FloatToStr(ABR_Info.JewettNAmp[2])+#9+
            FloatToStr(ABR_Info.JewettNAmp[3])+#9+
            FloatToStr(ABR_Info.JewettNAmp[4])+#9+
            FloatToStr(ABR_Info.JewettNAmp[5])+#9+
            FloatToStr(ABR_Info.JewettNAmp[6])+#9+
            FloatToStr(ABR_Info.JewettNAmp[7])+#9+
            FloatToStr(ABR_Info.JewettNAmp[8])+#9+
            FloatToStr(ABR_Info.JewettNAmp[9])+#9);
      writeln(F,'Amp_Tone='+#9+FloatToStr(ABR_Info.Amp_Tone ));
      writeln(F,'Freq_Tone='+#9+FloatToStr(ABR_Info.Freq_Tone ));
      writeln(F,'Amp_klik='+#9+FloatToStr(ABR_Info.Amp_Klik ));
      writeln(F,'Freq_klik='+#9+FloatToStr(ABR_Info.Freq_Klik ));
      writeln(F,'Default Stimfile='+#9+ABR_Info.Name_Klik);
      writeln(F,'Max_Turns='+#9+IntToStr(ABR_Info.Max_Turns));
      writeln(F,'Nr='+#9+IntToStr(ABR_Info.Turn_Nr));
      writeln(F,'Tag='+#9+IntToStr(ABR_Info.Tag));
      writeln(F,'Peak_Reject='+#9+FloatToStr(ABR_Info.Peak_reject));
      writeln(F,'Stim_file_name='+#9+ABR_Info.Stim_file_name);
      writeln(F,'Stim_file_length='+#9+IntToStr(ABR_Info.Stim_file_length));
      writeln(F,'Kalibration_file='+#9+ABR_Info.Kalib_File_name);
      writeln(F,'NumberOf_Samples='+#9+IntToStr(ABR_Info.NumberOf_Samples));
      if ABR_Info.Directional_ABR then writeln(F,'Directional_ABR='+#9+'1') else writeln(F,'Directional_ABR='+#9+'0');
      if ABR_Info.Invert_Click then writeln(F,'Invert_Click='+#9+'1') else writeln(F,'Invert_Click='+#9+'0');
      writeln(F,'kanal_ind='+#9+IntToStr(ABR_Info.kanal_ind));
      writeln(F,'kanal_ud='+#9+IntToStr(ABR_Info.kanal_ud));
      if ABR_Info.Masked then writeln(F,'Masked='+#9+'1') else writeln(F,'Masked='+#9+'0');

      //writeln(F,'kalibration='+#9+Glob_Titel);
      //writeln(F,'stimulation file='+#9+Glob_Stim_file_name);
      //writeln(F,'Number of avarges='+#9+IntToStr(Glob_max_avrages ));

    writeln(F,'[/settings]');
    writeln(F,'[data]');
    if masked then writeln(F,'UnMasked Buf A'+#9+'UnMasked Buf B'+#9+'Masked Buf A'+#9+'Masked Buf B')
              else writeln(F,'UnMasked Buf A'+#9+'UnMasked Buf B');
    For i:=0 to length(ABR_Data[0])-1 do
    Begin
      if masked then S:= FloatToStr(ABR_Data[0,i])+#9+FloatToStr(ABR_Data[1,i])+#9+FloatToStr(ABR_Data[2,i])+#9+FloatToStr(ABR_Data[3,i])
                else S:= FloatToStr(ABR_Data[0,i])+#9+FloatToStr(ABR_Data[1,i]);
      writeln(F,S);
    End;
    writeln(F,'[/data]');
CloseFile(F);
TDTForm.SaveLogFile('   {R} '+FName);
end;


//*************************

Procedure  TReadForm.LoadMatFileformat(var ABR_Data:TABR_Data; var ABR_Info:TABR_Info; FName:string);
var
  F:textfile;
  s:String;
  //L:integer;
Begin
  InitABRInfo(ABR_Info);
  InitABRData(ABR_Data);
    AssignFile(F, FName);
    Reset(F);
    Repeat
      Readln(F,S);
      if pos('[settings]',S)>0 then
        Repeat

          Readln(F,S);
          //showmessage(S);
          If MatRead(S,'SampelRate')<>''       then ABR_Info.SampelRate :=StrToFloat(CleanFloat(MatRead(S,'SampelRate')));
          If MatRead(S,'SOUND_SampelRate')<>'' then ABR_Info.SampelRate:= StrToFloat(CleanFloat(MatRead(S,'SOUND_SampelRate')));
          If MatRead(S,'ABR_SampelRate')<>''   then ABR_Info.ABR_SampleRate := StrToFloat(CleanFloat(MatRead(S,'ABR_SampelRate')));
          If MatRead(S,'stimulation file')<>'' then ABR_Info.Name_Klik := MatRead(S,'stimulation file');
          If MatRead(S,'Default Stimfile')<>'' then ABR_Info.Name_Klik := MatRead(S,'Default Stimfile');
          If MatRead(S,'Amp_Tone')<>''  then ABR_Info.Amp_Tone:=  StrToInt(CleanFloat(MatRead(S,'Amp_Tone')));
          If MatRead(S,'Freq_Tone')<>'' then begin ABR_Info.Freq_Tone:= StrToInt(CleanFloat(MatRead(S,'Freq_Tone'))); if ABR_Info.Freq_Tone=0 then ABR_Info.Masked:=false else ABR_Info.Masked:=True;  end;
          If MatRead(S,'Amp_klik')<>''  then ABR_Info.Amp_Klik:=  StrToInt(CleanFloat(MatRead(S,'Amp_klik')));
          If MatRead(S,'Freq_klik')<>'' then ABR_Info.Freq_Klik:= StrToInt(CleanFloat(MatRead(S,'Freq_klik')));
          If MatRead(S,'Numbers_of_Awarages')<>'' then
            Begin
              ABR_Info.Numbers_of_Awarages[0] :=StrArrayToInt(MatRead(S,'Numbers_of_Awarages'),0);
              ABR_Info.Numbers_of_Awarages[1] :=StrArrayToInt(MatRead(S,'Numbers_of_Awarages'),1);
              ABR_Info.Numbers_of_Awarages[2] :=StrArrayToInt(MatRead(S,'Numbers_of_Awarages'),2);
              ABR_Info.Numbers_of_Awarages[3] :=StrArrayToInt(MatRead(S,'Numbers_of_Awarages'),3);
            end;
          If MatRead(S,'Max_Awarages')<>'' then ABR_Info.Max_avarages :=StrToInt(CleanFloat(MatRead(S,'Max_Awarages')));
          If MatRead(S,'Kommentar=')<>''  then ABR_Info.Kommentar  :=MatRead(S,'Kommentar');
          If MatRead(S,'Kommentar2=')<>'' then ABR_Info.Kommentar2 :=MatRead(S,'Kommentar2');
          If MatRead(S,'Program_version')<>'' then ABR_Info.Program_version :=MatRead(S,'Program_version');
          If MatRead(S,'Filter')<>'' then ABR_Info.Filter :=StrToInt(CleanFloat(MatRead(S,'Filter')));
          If MatRead(S,'JewettP=')<>'' then ABR_Info.JewettP :=StrToJewet(MatRead(S,'JewettP'));
          If MatRead(S,'JewettN=')<>'' then ABR_Info.JewettN :=StrToJewet(MatRead(S,'JewettN'));
          If MatRead(S,'JewettPAmp=')<>'' then ABR_Info.JewettPAmp :=StrToJewetFloat(MatRead(S,'JewettPAmp'));
          If MatRead(S,'JewettNAmp=')<>'' then ABR_Info.JewettNAmp :=StrToJewetFloat(MatRead(S,'JewettNAmp'));
          //If MatRead(S,'Amp_Tone')<>''  then ABR_Info.Amp_Tone  :=StrToInt(CleanFloat(MatRead(S,'Amp_Tone')));
          //If MatRead(S,'Freq_Tone')<>'' then ABR_Info.Freq_Tone :=StrToInt(CleanFloat(MatRead(S,'Freq_Tone')));
          //If MatRead(S,'Amp_klik')<>''  then ABR_Info.Amp_Klik  :=StrToInt(CleanFloat(MatRead(S,'Amp_klik')));
          //If MatRead(S,'Freq_klik')<>'' then ABR_Info.Freq_Klik :=StrToInt(CleanFloat(MatRead(S,'Freq_klik')));
          If MatRead(S,'Stim_file_name')<>'' then ABR_Info.Stim_file_name :=MatRead(S,'Stim_file_name');
          If MatRead(S,'stimulation file')<>'' then ABR_Info.Stim_file_name :=MatRead(S,'stimulation file');
          If MatRead(S,'Max_Turns')<>'' then ABR_Info.Max_Turns :=StrToInt(CleanFloat(MatRead(S,'Max_Turns')));
          If MatRead(S,'Nr')<>'' then ABR_Info.Turn_Nr :=StrToInt(CleanFloat(MatRead(S,'Nr')));
          If MatRead(S,'Tag')<>'' then ABR_Info.Tag :=StrToInt(CleanFloat(MatRead(S,'Tag')));
          If MatRead(S,'Peak_Reject')<>'' then ABR_Info.Peak_reject :=StrToFloat(CleanFloat(MatRead(S,'Peak_Reject')));
          If MatRead(S,'Stim_file_name')<>'' then ABR_Info.Stim_file_name :=MatRead(S,'Stim_file_name');
          If MatRead(S,'Stim_file_length')<>'' then ABR_Info.Stim_file_length:= StrToInt(CleanFloat(MatRead(S,'Stim_file_length')));
          If MatRead(S,'Kalibration_file')<>'' then ABR_Info.Kalib_File_name :=MatRead(S,'Kalibration_file');
          If MatRead(S,'kalibration')<>'' then ABR_Info.Kalib_File_name :=MatRead(S,'kalibration');
          If MatRead(S,'NumberOf_Samples')<>'' then ABR_Info.NumberOf_Samples :=StrToInt(CleanFloat(MatRead(S,'NumberOf_Samples')));
          If MatRead(S,'Directional_ABR')<>'' then if CleanFloat(MatRead(S,'Directional_ABR'))='1' then  ABR_Info.Directional_ABR :=TRUE else ABR_Info.Directional_ABR :=FALSE ;
          If MatRead(S,'Invert_Click')<>'' then if CleanFloat(MatRead(S,'Invert_Click'))='1' then  ABR_Info.Invert_Click :=TRUE else ABR_Info.Invert_Click :=FALSE ;
          If MatRead(S,'kanal_ind')<>'' then ABR_Info.kanal_ind :=StrToInt(CleanFloat(MatRead(S,'kanal_ind')));
          If MatRead(S,'kanal_ud')<>'' then ABR_Info.kanal_ud :=StrToInt(CleanFloat(MatRead(S,'kanal_ud')));
          If MatRead(S,'Masked')<>'' then if CleanFloat(MatRead(S,'Masked'))='1' then  ABR_Info.Masked :=TRUE else ABR_Info.Masked :=FALSE ;
        Until (pos('[/settings]',S)>0) OR (pos('[data]',S)>0);


      if pos('[data]',S)>0 then
        Begin
          Readln(F,S);   //Reads the headlines
          Readln(F,S);   //Reads the first data point
          Repeat
            ExtractNumbers(S,ABR_Data[0],#9);
            ExtractNumbers(S,ABR_Data[1],#9);
            if ABR_Info.Freq_Tone <>0 then
              Begin
                ExtractNumbers(S,ABR_Data[2],#9);
                ExtractNumbers(S,ABR_Data[3],#9);
              end;
            Readln(F,S);
          Until (pos('[/data]',S)>0) or EOF(F);
        end;
    until EOF(F);
  CloseFile(F);
  If ABR_Info.NumberOf_Samples<1 then ABR_Info.NumberOf_Samples:=Length(ABR_Data[0])-2;
end;


//*************************

Procedure  TReadForm.ReadMF2(Filename  : string; var ABR_Data:TABR_Data; var ABR_Info:TABR_Info);
var
 Data:TMeasFile;
 F1: file of TMeasFile;    //2000 samples
 F2: file of TMeasFile2;   //1000 samples
 MyXMF   : TMeasFile2;
 siz: Longint;
 ftest: file of Byte;
Begin
  AssignFile(ftest, filename);
  Reset(ftest);
  siz:=filesize(ftest);
  CloseFile(ftest);

  if siz=   816988 then      //  //  siz > 500000
    Begin
     AssignFile(F1, filename);
     Reset(F1);
     read(F1, Data);
     CloseFile(F1);
    End
    Else
    Begin
     AssignFile(F2, filename);
     Reset(F2);
     read(F2, MyXMF);
     CloseFile(F2);
     Data:=MyF2ToMyF1(MyXMF);
    end;

    ABR_Data :=MeasToData(Data);
    ABR_Info :=MeasToInfo(Data);
end;




//*************************

procedure TReadForm.Setup1Click(Sender: TObject);
begin
 Sender:=ReadForm;

 ReadSettingsForm.show;

 ReadSettingsForm.UpdateSettingsForm(Sender,Read1Settings);
end;


//*************************

procedure TReadForm.SettingsSet(Sett:TGraphSettings);
var
 MyNode: TTreeNode;
 Allow : Boolean;
Begin
     Read1Settings := Sett;
     Allow:=true;
     if TreeView1.Selected <> nil then
   Begin
     MyNode:=TreeView1.Selected;
     if MyNode.Level>0 then MyNode:=MyNode.Parent;
     TreeView1Changing(ReadForm, MyNode, Allow);
   end;
end;



//*************************
procedure TReadForm.Save1Click(Sender: TObject);
begin
Showmessage('I''M Sorry Dave, I''m afraid I can''t do that');
end;



//*************************

procedure TReadForm.OpenRAW1Click(Sender: TObject);
var
  S:string;
  Data:TMeasFile;
  F1: file of TMeasFile;    //2000 samples
  F2: file of TMeasFile2;   //1000 samples
  MyXMF   : TMeasFile2;
  siz: Longint;
  ftest: file of Byte;
  i,L,L2,k:integer;
 MySeries: TLineSeries ;
 ScaleY,shift:double;
 SeriesColor:TColor ;
begin
 OpenDialog1.FilterIndex:=3;
 If OpenDialog1.Execute then
 Begin
   shift:=0.01;
   AssignFile(ftest, OpenDialog1.FileName);
   Reset(ftest);
   siz:=filesize(ftest);
   CloseFile(ftest);
   S:= OpenDialog1.FileName;
   S:=AnsiLowerCase(Copy(S,pos('.',S)+1,3));

   if s='ab3' then
   begin
      if siz=   816988 then      //  //  siz > 500000
      Begin
       AssignFile(F1, OpenDialog1.FileName);
       Reset(F1);
       read(F1, Data);
       CloseFile(F1);
      End
      Else
      Begin
       showmessage('non standard file size');
       AssignFile(F2, OpenDialog1.FileName);
       Reset(F2);
       read(F2, MyXMF);
       CloseFile(F2);
       Data:=MyF2ToMyF1(MyXMF);
      end;
      Chart1.SeriesList.Clear;
      L:= Length(Data.Resume)-1;
      L2:= Length(Data.Meas)-1;
      Showmessage(IntToStr(L)+' '+IntToStr(L2));
      ScaleY:= Data.SampelRate/1000;

      for k:=0 to L2 do
      begin
          SeriesColor:=ReadForm.IntToColor(k);
          MySeries := TLineSeries.Create( Self );
          MySeries.ParentChart := Chart1 ;
          MySeries.SeriesColor:= SeriesColor;
          MySeries.ShowInLegend:=False;
          for i:=0 to L do MySeries.AddXY(i/ScaleY,Data.Meas[k,i]+k*shift);
      end;
   end;
 end;
end;


Function TReadForm.InitJewetMarks(MyChart:Tchart):Boolean;
var
 MySeries: TPointSeries ;
Begin
  MySeries := TPointSeries.Create( Self );   //Buffer 1
  MySeries.ParentChart := MyChart ;
  MySeries.SeriesColor := clBlack;
  MySeries.ClickableLine:=False;
  MySeries.Pointer.Style:=psDownTriangle;
  MySeries.ShowInLegend:=False;
  MySeries.Identifier:= IntToStr(-1);


  MySeries := TPointSeries.Create( Self );   //Buffer 2
  MySeries.ParentChart := MyChart ;
  MySeries.SeriesColor := clBlack;
  MySeries.ClickableLine:=False;
  MySeries.Pointer.Style:=psTriangle;
  MySeries.ShowInLegend:=False;
  MySeries.Identifier:= IntToStr(-1);
  result:=true;
end;


//*************************

procedure TReadForm.Open1Click(Sender: TObject);
var
  S,freq,db,StimName: String;
  i,nFiles:integer; //
  FNames: array[0..10] of string;
  ABR_Data:TABR_Data;
  ABR_Info:TABR_Info;
begin
 If OpenDialog1.Execute then Begin
    nFiles:=opendialog1.Files.Count;

    if nFiles=1 then
    begin
      ReadForm2.LoadFile(OpenDialog1.FileName);
      ReadForm2.show;
    end;

    if nFiles>1 then
    begin
      Memo1.Clear;
      Chart1.Title.Text.Clear;
      Chart1.FreeAllSeries;

      for i := 0 to nFiles - 1 do
      FNames[i]:=opendialog1.Files.Strings[i];
      MySort(FNames,nFiles-1);

      InitJewetMarks(Chart1);
      for i := 0 to nFiles - 1 do
      begin
         ExtractFileInfo(FNames[i],StimName,S,freq,db);
         LoadMatFileformat(ABR_Data,ABR_Info,FNames[i]);
         Read1Settings.Offset:= -i;
         Read1Settings.ID :=  FNames[i];
         ReadForm2.PlotCurve(Chart1, ABR_Data, ABR_Info, Read1Settings);

      end;
      Memo1.SelectAll;
      Memo1.CopyToClipboard;
    end;
 end;
End;



//******************* Save graph as a image file

procedure TReadForm.SaveImage1Click(Sender: TObject);
var
S:string;
begin
 if SaveDialog1.Execute then Begin
   S:= SaveDialog1.FileName ;
     // Gemmer Windows meta file
   if (S[length(S)-2]+S[length(S)-1]+S[length(S)])='WMF' then
           Chart1.SaveToMetafile(SaveDialog1.FileName);
     // Gemmer Enhanced Metafile
   if (S[length(S)-2]+S[length(S)-1]+S[length(S)])='EMF' then
           Chart1.SaveToMetafileEnh(SaveDialog1.FileName);
     // Gemmer Bitmap File
   if (S[length(S)-2]+S[length(S)-1]+S[length(S)])='BMP' then
           Chart1.SaveToBitmapFile(SaveDialog1.FileName);
 End;
end;



  // Overrides the zoom out function

procedure TReadForm.Chart1UndoZoom(Sender: TObject);
var
min,max:double;
t: integer;
begin
  Max:=0;  Min:=0;
  Chart1.LeftAxis.Automatic:=False;      // Meget Vigtigt
    for t:= 0 to Chart1.SeriesCount -1 do
    with Chart1.Series[ t ] do
     begin
       If Active then If Max<MaxYValue then Max:=MaxYValue;
       If Active then If Min>MinYValue then Min:=MinYValue;
     end;
     if max<=min then begin max:=1; min:=0 end;
  Chart1.LeftAxis.Maximum:= Max+1*(max-min)/100;
  Chart1.LeftAxis.Minimum:= Min-1*(max-min)/100;
end;






    {**  Compackts a sortet treeView  **}
Procedure TReadForm.kompakt();
var
MyNode1,MyNode2,MyNode3:TTreeNode;
Begin
  MyNode1 := treeview1.Items.GetFirstNode;
  MyNode2 := MyNode1.getNextSibling;
  While MyNode1 <> nil do begin
     While ((MyNode2<>nil) and (MyNode1.Text=MyNode2.Text)) do Begin
        MyNode3:=MyNode2.getFirstChild;
        While MyNode3 <> nil do Begin
           Mynode3.MoveTo(MyNode1,naAddChild);
           MyNode3:=MyNode2.GetNextChild(MyNode3);
        end;
        MyNode2.Delete;
        MyNode2 := MyNode1.getNextSibling;
     end;
     MyNode1:=MyNode2;
     if MyNode1<>nil then MyNode2:= MyNode1.getNextSibling;
  end;
end;




 {**  deactivate all dubletFiles (files with same frequency and amplitude)  **}
procedure TReadForm.InitTree();
var
   MyNode1,MyNode2: TTreeNode;
   OldText:string;
Begin
 MyNode1:= TreeView1.Items.GetFirstNode;
 MyNode2:=MyNode1.getFirstChild;
 While MyNode1 <> nil do begin
    MyNode2:=MyNode2.getNextSibling;   //get next intencity
    if MyNode2 = nil then begin             //if no more intencitys
      MyNode1:= MyNode1.getNextSibling;   //get next frequency
      if MyNode1 <> nil then Begin                  //if frequency exists
        MyNode2:= MyNode1.getFirstChild; // Get first intencity
        OldText:='x';
      end;
    end;
    if MyNode2 <> nil then begin
      if MyNode2.Text=OldText then MyNode2.StateIndex:=1;
      OldText:=MyNode2.Text;
    end;
 end;
end;






      {**  Copy the data from the treeview so you can paste it in calc  **}
{procedure TReadForm.EksportTree(dType:integer);
var
   MyNode1,MyNode2: TTreeNode;
   Xdb:integer;
   X,Y:integer;
Begin
 ExportForm.ClearStringGrid();
 ExportForm.Show; X:=1; Y:=0;

 MyNode1:= TreeView1.Items.GetFirstNode;
 MyNode2:=MyNode1.getFirstChild;
 ExportForm.StringGrid1.Cells[X,Y]:= MyNode1.Text;
 glob_Export_DataType:=dType;
 inc(Y);
 Xdb:=0;
 While ((MyNode1 <> nil) and (MyNode1.StateIndex=1)) do MyNode1:= MyNode1.getNextSibling;
 While MyNode1 <> nil do begin
    if MyNode2.StateIndex<>1 then begin
       while ((StrToInt(MyNode2.Text))>(Xdb+5)) do begin
          Xdb:=Xdb+5;
          inc(y);
          End;
       ExportForm.StringGrid1.Cells[0,Y]:= MyNode2.Text;
       case dType of
         1: ExportForm.StringGrid1.Cells[X,Y]:= FloatToStrF(PMyRec(Mynode2.Data)^.Fpp,  ffFixed,6,3);
         2: ExportForm.StringGrid1.Cells[X,Y]:= FloatToStrF(PMyRec(Mynode2.Data)^.Flat, ffFixed,4,1);
         3: ExportForm.StringGrid1.Cells[X,Y]:= FloatToStrF(PMyRec(Mynode2.Data)^.FppDD,ffFixed,6,3);
         4: ExportForm.StringGrid1.Cells[X,Y]:= FloatToStrF(PMyRec(Mynode2.Data)^.SNR,  ffFixed,4,1);
         5: ExportForm.StringGrid1.Cells[X,Y]:= FloatToStrF(PMyRec(Mynode2.Data)^.Xcor,  ffFixed,9,5);
         6: ExportForm.StringGrid1.Cells[X,Y]:= FloatToStrF(PMyRec(Mynode2.Data)^.FXcorr ,  ffFixed,9,5)
       else
         Showmessage('DataType not supportet: '+inttostr(dType));
       end;
       inc(y);
       Xdb:= StrToInt(MyNode2.Text);
       end;
    MyNode2:=MyNode2.getNextSibling;   //get next intencity
    if MyNode2 = nil then begin             //if no more intencitys
      MyNode1:= MyNode1.getNextSibling;   //get next frequency
      While ((MyNode1 <> nil) and (MyNode1.StateIndex=1)) do MyNode1:= MyNode1.getNextSibling;
      if MyNode1 <> nil then Begin                  //if frequency exists
        MyNode2:= MyNode1.getFirstChild; // Get first intencity
        Inc(X); Y:=0;
        ExportForm.StringGrid1.Cells[X,Y]:= MyNode1.Text;
        inc(Y);
        Xdb:=0;
      end;
    end;
 end;
end;  }


{finds the minimum amplitude of the stimuli in dataset}
{this is important to avoid adding data to negative cells}

Function FindMinimumAmplitude(Tree: TTreeView):integer;
var
  MyNode1,MyNode2: TTreeNode;
Begin
 Result:=100;
 MyNode1:= Tree.Items.GetFirstNode;
 While (MyNode1 <> nil) Do
   begin
     MyNode2:= Mynode1.getFirstChild;
     While (MyNode2 <> nil) Do
     Begin
       if  StrToInt(MyNode2.Text) < Result then Result:= StrToInt(MyNode2.Text);
       MyNode2:= MyNode2.getNextSibling;
     end;
     MyNode1:= MyNode1.getNextSibling;
   end;
end;


procedure TReadForm.EksportTree(dType:integer);
var
   MyNode1,MyNode2: TTreeNode;
   Amp,shift:integer;
   X:integer;
Begin
 shift:=FindMinimumAmplitude(TreeView1);
 ExportForm.ClearStringGrid();
 X:=1;
 MyNode1:= TreeView1.Items.GetFirstNode;
 MyNode2:=MyNode1.getFirstChild;
 ExportForm.StringGrid1.Cells[X,0]:= MyNode1.Text; //Frequency

 glob_Export_DataType:=dType;

 While ((MyNode1 <> nil) and (MyNode1.StateIndex=1)) do MyNode1:= MyNode1.getNextSibling;
 While MyNode1 <> nil do begin
    if MyNode2.StateIndex<>1 then
    begin
       Amp:=  StrToInt(MyNode2.Text) +1 -Shift ;
       if ExportForm.StringGrid1.RowCount < Amp+1 then ExportForm.StringGrid1.RowCount := Amp+1;

       ExportForm.StringGrid1.Cells[0,Amp]:= MyNode2.Text;
       case dType of
         1: ExportForm.StringGrid1.Cells[X,Amp]:= FloatToStrF(PMyRec(Mynode2.Data)^.Fpp,  ffFixed,6,3);
         2: ExportForm.StringGrid1.Cells[X,Amp]:= FloatToStrF(PMyRec(Mynode2.Data)^.Flat, ffFixed,4,1);
         3: ExportForm.StringGrid1.Cells[X,Amp]:= FloatToStrF(PMyRec(Mynode2.Data)^.FppDD,ffFixed,6,3);
         4: ExportForm.StringGrid1.Cells[X,Amp]:= FloatToStrF(PMyRec(Mynode2.Data)^.SNR,  ffFixed,4,1);
         5: ExportForm.StringGrid1.Cells[X,Amp]:= FloatToStrF(PMyRec(Mynode2.Data)^.Xcor,  ffFixed,9,5);
         6: ExportForm.StringGrid1.Cells[X,Amp]:= FloatToStrF(PMyRec(Mynode2.Data)^.FXcorr ,  ffFixed,9,5)
       else
         Showmessage('DataType not supportet: '+inttostr(dType));
       end;
    end;
    MyNode2:=MyNode2.getNextSibling;   //get next intencity
    if MyNode2 = nil then
    begin             //if no more intencitys
       MyNode1:= MyNode1.getNextSibling;   //get next frequency
       While ((MyNode1 <> nil) and (MyNode1.StateIndex=1)) do MyNode1:= MyNode1.getNextSibling;
       if MyNode1 <> nil then
       Begin                  //if frequency exists
         MyNode2:= MyNode1.getFirstChild; // Get first intencity
         Inc(X);
         if ExportForm.StringGrid1.ColCount < X+1 then ExportForm.StringGrid1.ColCount := X+1;
         ExportForm.StringGrid1.Cells[X,0]:= MyNode1.Text;
       end;
    end;
 end;
 ExportForm.Compact1Click(ReadForm);
 ExportForm.Show;
end;


//*********** Exports all Jevet mark latencies to chart

procedure TReadForm.ExportJewett1Click(Sender: TObject);
const
 titels: array[0..21] of string = ('ID','Stim','Freq','Amp','P1','P2','P3','P4','P5','P6','P7','P8','P9','N1','N2','N3','N4','N5','N6','N7','N8','N9');
var
   MyNode1,MyNode2: TTreeNode;
   X,Y,Z,currentRows:integer;
   ID,StimName,freq,dB:string;
begin
  currentRows := ExportForm.StringGrid1.RowCount;
  for x:=0 to 21 do for y:=0 to currentRows do ExportForm.StringGrid1.Cells[x,y]:=''; // clean up the grid
  ExportForm.Show;
  for X:=0 to 21 do ExportForm.StringGrid1.Cells[X,0]:=titels[X];
  Y:=1;
  ExportForm.StringGrid1.RowCount := TreeView1.Items.Count;
  MyNode1:= TreeView1.Items.GetFirstNode;
  MyNode2:= MyNode1.getFirstChild;

While ((MyNode1 <> nil) and (MyNode1.StateIndex=1)) do MyNode1:= MyNode1.getNextSibling;
 While MyNode1 <> nil do begin
    if MyNode2.StateIndex<>1 then
    begin
      ExtractFileInfo(PMyRec(Mynode2.Data)^.FName,ID,StimName,freq,dB); //Extract info from the filename
      ExportForm.StringGrid1.Cells[0,Y]:={ID;}     ExtractFileName(PMyRec(Mynode2.Data)^.FName);
      ExportForm.StringGrid1.Cells[1,Y]:=StimName;
      ExportForm.StringGrid1.Cells[2,Y]:=freq;
      ExportForm.StringGrid1.Cells[3,Y]:=dB;
      for X:=1 to 9 do
        Begin
         Z := PMyRec(Mynode2.Data)^.JewettP[X];
         if Z>0 then ExportForm.StringGrid1.Cells[X+3,Y]:=IntToStr(Z) else ExportForm.StringGrid1.Cells[X+3,Y]:='';
         Z := PMyRec(Mynode2.Data)^.JewettN[X];
         if Z>0 then ExportForm.StringGrid1.Cells[X+3+9,Y]:= IntToStr(Z) else ExportForm.StringGrid1.Cells[X+3+9,Y]:='';
        End;
      Inc(Y);
    End;

    MyNode2:=MyNode2.getNextSibling;
    if MyNode2 = nil then //if no more intensites
      begin
        MyNode1:= MyNode1.getNextSibling;   //get next frequency
        While ((MyNode1 <> nil) and (MyNode1.StateIndex=1)) do MyNode1:= MyNode1.getNextSibling;
        if MyNode1 <> nil then MyNode2:= MyNode1.getFirstChild;    // Get first intensity             //if frequency exists
      end;

 End;
end;


//*********** Exports all Jevet mark amplitudes to chart

procedure TReadForm.ExportJewettamp1Click(Sender: TObject);
const
 titels: array[0..21] of string = ('ID','Stim','Freq','Amp','P1','P2','P3','P4','P5','P6','P7','P8','P9','N1','N2','N3','N4','N5','N6','N7','N8','N9');
var
   MyNode1,MyNode2: TTreeNode;
   X,Y,Z,currentRows:integer;
   Zamp : double;
   ID,StimName,freq,dB:string;
begin
  currentRows := ExportForm.StringGrid1.RowCount;
  for x:=0 to 21 do for y:=0 to currentRows do ExportForm.StringGrid1.Cells[x,y]:=''; // clean up the grid
  ExportForm.Show;
  for X:=0 to 21 do ExportForm.StringGrid1.Cells[X,0]:=titels[X];
  Y:=1;
  ExportForm.StringGrid1.RowCount := TreeView1.Items.Count;
  MyNode1:= TreeView1.Items.GetFirstNode;
  MyNode2:= MyNode1.getFirstChild;

While ((MyNode1 <> nil) and (MyNode1.StateIndex=1)) do MyNode1:= MyNode1.getNextSibling;
 While MyNode1 <> nil do begin
    if MyNode2.StateIndex<>1 then
    begin
      ExtractFileInfo(PMyRec(Mynode2.Data)^.FName,ID,StimName,freq,dB); //Extract info from the filename
      ExportForm.StringGrid1.Cells[0,Y]:={ID;}     ExtractFileName(PMyRec(Mynode2.Data)^.FName);
      ExportForm.StringGrid1.Cells[1,Y]:=StimName;      // get stimulus name
      ExportForm.StringGrid1.Cells[2,Y]:=freq;          // get stimulus frequency
      ExportForm.StringGrid1.Cells[3,Y]:=dB;            // get stimulus amplitude
      for X:=1 to 9 do
        Begin
         Zamp := PMyRec(Mynode2.Data)^.JewettPAmp[X];
         if Zamp>-999 then ExportForm.StringGrid1.Cells[X+3,Y]:=FloatToStr(Zamp) else ExportForm.StringGrid1.Cells[X+3,Y]:='';
         Zamp := PMyRec(Mynode2.Data)^.JewettNAmp[X];
         if Zamp>-999 then ExportForm.StringGrid1.Cells[X+3+9,Y]:= FloatToStr(Zamp) else ExportForm.StringGrid1.Cells[X+3+9,Y]:='';
        End;
      Inc(Y);
    End;

    MyNode2:=MyNode2.getNextSibling;
    if MyNode2 = nil then //if no more intensites
      begin
        MyNode1:= MyNode1.getNextSibling;   //get next frequency
        While ((MyNode1 <> nil) and (MyNode1.StateIndex=1)) do MyNode1:= MyNode1.getNextSibling;
        if MyNode1 <> nil then MyNode2:= MyNode1.getFirstChild;    // Get first intensity             //if frequency exists
      end;

 End;
end;


   {**  Changes the state of a node  **}
procedure TReadForm.TreeView1DblClick(Sender: TObject);
var
MyNode:TTreeNode;
Allow:boolean;
begin
 if ((TreeView1.Selected <> nil) and ((PMyRec(TreeView1.Selected.Data)) <> nil))
 then begin
   MyNode:= TreeView1.Selected;
   if TreeView1.Selected.StateIndex=1 then TreeView1.Selected.StateIndex:=-1
   else TreeView1.Selected.StateIndex:=1;

   Allow:=true;
   if MyNode.Level>0 then MyNode:=MyNode.Parent;
   TreeView1Changing(Sender, MyNode, Allow);
 End;
end;


  // updates the lable in the bottom left corner with information about the selected file
procedure TReadForm.TreeView1Click(Sender: TObject);
begin
if ((TreeView1.Selected <> nil) and ((PMyRec(TreeView1.Selected.Data)) <> nil))
  then Label4.Caption:= 'Xcor= '+ FloatToStr(PMyRec(TreeView1.Selected.Data)^.Xcor );
end;


   {**  Updates Chart1 when TreeView1 Changes  **}
procedure TReadForm.TreeView1Changing(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
var
  MyNode2: TTreeNode;
  freq,db,s,SS,Sig,StimName:string;
  i,N:integer;  // ,J
  SNR: single;
  ABR_Info:TABR_Info;
  ABR_Data:TABR_Data;
begin
 If not(Glob_Background) then
 begin
   N:=Read1Settings.PPToSample - Read1Settings.FromSample;
   i:=0;
   glob_significans_50:=FTest(50,N);
   glob_significans_10:=FTest(10,N);
   glob_significans_01:=FTest(1,N);

   If node.Level=0 then //node:=node.Parent;
   begin
     Chart1.FreeAllSeries;
     InitJewetMarks(Chart1);
     MyNode2:=Node.GetLastChild;
     While ((MyNode2 <> nil))  do   // And (i<10))
     begin
       If MyNode2.StateIndex<>1 then
       begin
         S:=PMyRec(MyNode2.Data)^.FName ;
         SNR:=PMyRec(MyNode2.Data)^.SNR ;
         if SNR>glob_significans_50 then Sig:='*' else sig:=''; // 1.16 FTest(0.05,N);
         if SNR>glob_significans_10 then Sig:=Sig+'*';              // 1.23
         if SNR>glob_significans_01 then Sig:=Sig+'*';     // 1.32
         if fileexists(S) then
         begin
           ExtractFileInfo( S ,Ss,StimName,freq,db);
           LoadMatFileformat(ABR_Data,ABR_Info,S);
           ABR_Info.Significans := Sig;
           ABR_Info.JewettP   := PMyRec(MyNode2.Data)^.JewettP ;
           ABR_Info.JewettN   := PMyRec(MyNode2.Data)^.JewettN ;
           ABR_Info.JewettPAmp   := PMyRec(MyNode2.Data)^.JewettPAmp ;
           ABR_Info.JewettNAmp   := PMyRec(MyNode2.Data)^.JewettNAmp ;
           Read1Settings.Offset:=-i;
           Read1Settings.ID:= IntToStr(MyNode2.AbsoluteIndex);
           ReadForm2.PlotCurve(Chart1, ABR_Data, ABR_Info, Read1Settings);
           inc(i);
         end else showmessage('file don''t exists: '+S);
       end;
       MyNode2:=Mynode2.getPrevSibling;
     End;
   end;
  Chart1UndoZoom(Sender);
  end;
end;



// Opens files and Makes directory

procedure TReadForm.Make1Click(Sender: TObject);
var
  MyRecPtr: PMyRec;
  MyNode1:TTreeNode;
  sr: TSearchRec;
  freq,dB,StimName:string;
  direc,id:string;
  pp,ppDD,latency,SNR,Xcor,FXcorr:single;
  Vaste:boolean;
  ABR_Info:TABR_Info;
begin
  OpenDialog2.DefaultExt:='CSV';
  OpenDialog2.FilterIndex:=4;
  If opendialog2.Execute then begin
    Glob_Background:=true;
    TreeView1.ChangeDelay:=0;
    treeview1.Items.Clear;
    Direc:= IncludeTrailingBackslash(ExtractFilePath(Opendialog2.FileName));
    ReadForm.Caption:= ' '+Direc;
    if FindFirst(Direc+'*.csv' , faReadOnly , sr) = 0 then begin
       Repeat
         ExtractFileInfo(sr.Name,ID,StimName,freq,dB); //Extract info from the filename
         MyNode1 := treeview1.Items.Add(nil,freq+' Hz');
         New(MyRecPtr);
         MyRecPtr^.FName := Direc+sr.Name;

         Get_PP_og_latens(sr.Name,pp,ppDD,latency,SNR,Xcor,FXcorr,ABR_Info);
         Read1Settings.TotalSamples:= ABR_Info.NumberOf_Samples;
         //if ABR_Info.Masked then memo2.Lines.Add('Masked') else memo2.Lines.Add('UnMasked');
         MyRecPtr^.JewettP:=ABR_Info.JewettP;
         MyRecPtr^.JewettN:=ABR_Info.JewettN;
         MyRecPtr^.JewettPAmp:=ABR_Info.JewettPAmp;
         MyRecPtr^.JewettNAmp:=ABR_Info.JewettNAmp;
         MyRecPtr^.Fpp :=  pp;
         MyRecPtr^.Flat := latency;
         MyRecPtr^.FppDD := ppDD;
         MyRecPtr^.SNR:= SNR;
         MyRecPtr^.Xcor:= Xcor;
         MyRecPtr^.FXcorr:= FXcorr;
         treeview1.Items.AddChildObject(MyNode1,dB+'',MyRecPtr);
      until FindNext(sr) <> 0;
    End;
    TreeView1.CustomSort(@CustomSortProc, 0);
    kompakt();
    TreeView1.CustomSort(@CustomSortProc, 0);
    InitTree();
    TreeView1.FullCollapse;
    treeView1.Selected:=  treeView1.Items.GetFirstNode;
    Glob_Background:=False;
    Save2.Enabled   := true;
    Export1.Enabled := true;
    ExportLatency1.Enabled := true;
    ExportPeakDD1.Enabled := true;
    ExportSNR1.Enabled := true;
    ExportXcorr1.Enabled := true;
    ExportXcorrF1.Enabled := true;
    ReadForm.TreeView1Changing(Sender, treeView1.Selected, Vaste);
  End;
end;



procedure TReadForm.Export1Click(Sender: TObject);
begin
 if sender=Export1 then EksportTree(1); // pp dif
 if sender=Exportlatency1 then EksportTree(2); // pp Dif Dif
 if sender=ExportpeakDD1 then EksportTree(3); // latency
 if sender=ExportSNR1 then EksportTree(4); // SNR
 if sender=ExportXcorr1 then EksportTree(5);
 if sender=ExportXcorrF1 then EksportTree(6);
end;




procedure TReadForm.TreeView1Expanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
 if not(Glob_Background) then TreeView1.FullCollapse;
 AllowExpansion:=true;
end;



    {** Saves the treeView1 data **}
procedure TReadForm.Save2Click(Sender: TObject);
var
  MyNode1,MyNode2:TTreeNode;
  S:string;
  F: TextFile;
begin
 Savedialog2.DefaultExt:='AB4';
 Savedialog2.Title:='Save Directory';
 if Savedialog2.Execute then Begin
   AssignFile(F, Savedialog2.FileName);
   Rewrite(F);
   MyNode1:= TreeView1.Items.GetFirstNode;
   While MyNode1 <> nil do begin
     Writeln(F,MyNode1.Text);
     MyNode2:=MyNode1.getFirstChild;
     While MyNode2 <> nil do begin
       S:= MyNode2.Text + #9 ;
       S:= S + FloatToStr(PMyRec(MyNode2.Data)^.Fpp) + #9 ;
       S:= S + FloatToStr(PMyRec(MyNode2.Data)^.Flat) + #9 ;    //lat
       S:= S + FloatToStr(PMyRec(MyNode2.Data)^.FppDD) + #9 ;   //ppDD
       S:= S + FloatToStr(PMyRec(MyNode2.Data)^.SNR) + #9 ;
       S:= S + FloatToStr(PMyRec(MyNode2.Data)^.Xcor) + #9 ;
       S:= S + PMyRec(MyNode2.Data)^.FName + #9 ;
       S:= S + IntToStr(Mynode2.StateIndex);
       //S:= S + PMyRec(MyNode2.Data)^.JewettP + #9 ;
       Writeln(F,S);
       MyNode2:=MyNode2.getNextSibling;
     End;
     MyNode1:=MyNode1.getNextSibling;
   End;
   CloseFile(F);
 End;
end;



    {** Loads the treeView1 data **}
procedure TReadForm.Load1Click(Sender: TObject);
var
 MyRecPtr: PMyRec;
 MyNode1,MyNode2:TTreeNode;
 S,S2,Name,Fname:string;
 F: TextFile;
 PP,lat,ppDD,SNR,Xcor:Single;
 State:integer;
begin
 OpenDialog2.DefaultExt:='AB4';
 OpenDialog2.FilterIndex:=2;
 if OpenDialog2.Execute then begin
   AssignFile(F, OpenDialog2.FileName);
   Reset(F);
   Treeview1.Items.Clear;
   While not EOF(F) do begin
     Readln(F, S);
     If pos(#9,S)>0 then begin
      S2:=copy(S,0,pos(#9,S)-1); //db
      Delete(S,1,pos(#9,S));
      Name:= S2;
      S2:=copy(S,0,pos(#9,S)-1); //PP
      Delete(S,1,pos(#9,S));
      PP:= StrToFloat(S2);

      S2:=copy(S,0,pos(#9,S)-1); //lat
      Delete(S,1,pos(#9,S));
      lat:= StrToFloat(S2);

      S2:=copy(S,0,pos(#9,S)-1); //ppDD
      Delete(S,1,pos(#9,S));
      ppDD:= StrToFloat(S2);

      S2:=copy(S,0,pos(#9,S)-1); //SNR
      Delete(S,1,pos(#9,S));
      SNR:= StrToFloat(S2);

      S2:=copy(S,0,pos(#9,S)-1); //Xcor
      Delete(S,1,pos(#9,S));
      Xcor:= StrToFloat(S2);

      S2:=copy(S,0,pos(#9,S)-1); //Filename
      Delete(S,1,pos(#9,S));
      Fname := S2;

      State := StrToInt(S);  //StateIndex

      New(MyRecPtr);
      MyRecPtr^.FName := Fname;
      MyRecPtr^.Fpp := PP;
      MyRecPtr^.Flat := lat;
      MyRecPtr^.FppDD := ppDD;
      MyRecPtr^.SNR := SNR;
      MyRecPtr^.Xcor := Xcor;
      MyNode2:=treeview1.Items.AddChildObject(MyNode1,Name,MyRecPtr);
      Mynode2.stateindex:=State;
     end else MyNode1 := treeview1.Items.Add(nil,S); //Freq
   End;
   CloseFile(F);
   Save2.Enabled   := true;
   Export1.Enabled := true;
   ExportLatency1.Enabled := true;
   ExportPeakDD1.Enabled := true;
 end;
end;


// display the individual recording (masked and unmasked seperatly)
procedure TReadForm.Show1Click(Sender: TObject);
var
MyNode :TTreeNode;
FileName : String;
begin
 if ((TreeView1.Selected <> nil) and ((PMyRec(TreeView1.Selected.Data)) <> nil))
 then begin
   MyNode := TreeView1.Selected;
   FileName := PMyRec(MyNode.Data)^.FName;
   if FileExists(FileName) then ReadForm2.LoadFile(FileName) else
    Showmessage('File not found' + #13 + FileName);
   ReadForm2.show;
 End;
end;



procedure TReadForm.Delete1Click(Sender: TObject);
var
MyNode :TTreeNode;
FileName,path,MyFileName : String;
begin
 if ((TreeView1.Selected <> nil) and ((PMyRec(TreeView1.Selected.Data)) <> nil))
 then begin
   MyNode := TreeView1.Selected;
   FileName := PMyRec(MyNode.Data)^.FName;

   if FileExists(FileName) then
   begin
     Path:= IncludeTrailingBackslash(ExtractFilePath(FileName));
     MyFileName:= ExtractFileName(FileName);
     Showmessage(MyFileName + #13 + 'is moved to folder skrald');
     if not DirectoryExists(path+'skrald') then
        if not CreateDir(path+'skrald') then Showmessage('Could not make directory');
     RenameFile(filename, path+'skrald\'+MyFileName);
     MyNode.Delete;
   end else
    Showmessage('File not found' + #13 + FileName);

 End;
end;



procedure TReadForm.Exit1Click(Sender: TObject);
begin
 Showmessage('I''M Sorry Dave, I''m afraid I can''t do that');
end;


// set the filter frequency when showing the series of recordings
// Is in the LP filter menu
procedure TReadForm.None1Click(Sender: TObject);
var
 Allow:boolean;
 MyNode:TTreeNode;
begin
 If Sender = None1  then Read1Settings.Filter_freq:= -1;
 If Sender = N40001 then Read1Settings.Filter_freq:= 4000;
 If Sender = N35001 then Read1Settings.Filter_freq:= 3500;
 If Sender = N30001 then Read1Settings.Filter_freq:= 3000;
 If Sender = N25001 then Read1Settings.Filter_freq:= 2500;
 If Sender = N20001 then Read1Settings.Filter_freq:= 2000;
 With sender as TMenuItem do Checked:=true;
    if TreeView1.Selected <> nil then
   Begin
     MyNode:=TreeView1.Selected;
     if MyNode.Level>0 then MyNode:=MyNode.Parent;
     TreeView1Changing(Sender, MyNode, Allow);
   end;
end;




procedure TReadForm.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  MyTreeNode:TTreeNode;
  //JN,JP : TJewett;
  node:integer;
begin
  node:= StrToInt(Series.Identifier);
  MyTreeNode := TreeView1.Items[node];
  //JN:=PMyRec(MyTreeNode.Data)^.JewettN ;
  //JP:=PMyRec(MyTreeNode.Data)^.JewettP ;
  JewetForm.tag:=node;
  JewetForm.FormUpdate(Node,ValueIndex+1,Series.XValue[ValueIndex+1],Series.YValue[ValueIndex+1]);
  //showmessage(floatToStr(Series.XValue[ValueIndex+1]));
  JewetForm.Show;
end;


//*************************

procedure TReadForm.SaveJewet(node:integer);
var
  MyTreeNode:TTreeNode;
  FName:String;
  ABR_Data:TABR_Data;
  ABR_Info:TABR_Info;
  JN,JP : TJewett;
  JNAmp,JPAmp : TJewettAmp;
Begin
  MyTreeNode := TreeView1.Items[node];
  FName:=PMyRec(MyTreeNode.Data)^.FName;
  if fileExists(FName) then
  Begin
    JN:=PMyRec(MyTreeNode.Data)^.JewettN ;
    JP:=PMyRec(MyTreeNode.Data)^.JewettP ;
    JNAmp:=PMyRec(MyTreeNode.Data)^.JewettNAmp ;
    JPAmp:=PMyRec(MyTreeNode.Data)^.JewettPAmp ;
    LoadMatFileformat(ABR_Data,ABR_Info,FName);
    ABR_Info.JewettP:=JP;
    ABR_Info.JewettN:=JN;
    ABR_Info.JewettPAmp:=JPAmp;
    ABR_Info.JewettNAmp:=JNAmp;
    SaveMatFileformat(ABR_Data,ABR_Info,FName);
  end;
end;




procedure TReadForm.ConvertAB3toCSV1Click(Sender: TObject);
var
  //MyRecPtr: PMyRec;
  //MyNode1:TTreeNode;
  sr: TSearchRec;
  NewFName:string; // freq,dB,StimName
  direc:string;     //  ,id
  //pp,ppDD,latency,SNR,Xcor,FXcorr:single;
  //Vaste:boolean;
  ABR_Info:TABR_Info;
  ABR_Data:TABR_Data;
  Flags:TReplaceFlags;
begin
  OpenDialog2.DefaultExt:='AB3';
  OpenDialog2.FilterIndex:=1;

  flags:= [rfReplaceAll, rfIgnoreCase];
  If opendialog2.Execute then
  begin

    Direc:= IncludeTrailingBackslash(ExtractFilePath(Opendialog2.FileName));

    if FindFirst(Direc+'*.AB3' , faReadOnly , sr) = 0 then begin
       Repeat
         //ExtractFileInfo(sr.Name,ID,StimName,freq,dB); //Extract info from the filename
         ReadMF2(sr.Name,ABR_Data,ABR_Info);
         NewFName:= StringReplace(sr.Name,'.AB3','.CSV',flags);
         SaveMatFileformat(ABR_Data,ABR_Info,NewFName);
      until FindNext(sr) <> 0;
    End;

  End;
end;






END.
