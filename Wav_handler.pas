unit Wav_handler;

interface

uses
  SysUtils,dialogs,FFTs,Complexs ;    // Showmessage

type
  PScalar = ^TScalar;
  TScalar = extended;
  PScalars = ^TScalars;
  TScalars = array[0..High(integer) div SizeOf(TScalar) - 1] of TScalar;

type
  TFilterCoff = array[-15..15] of single;

  TSoundFile = Array of double;

  TFFTpoint = record
                freq:double;
                Amp:Double;
                end;

  TFFTpointArray = Array of TFFTpoint;

  Theaderstr = array[1..44] of char;

  TWavheader=record
                Encoding:string;
                filesize:integer;
                FileType:string;
                Code:string; //fmt
                Ukendt:Integer;
                tag:word;
                samplerate:integer;
                bytessec:integer;
                bytessample:word;
                bitssample:word;
                dataLength:integer;
                RealLength:integer;
                chno:word;
                Header:string;
                end;

  { TbyteRecShort = record
               hi:byte;
              end; }

   TbyteRec = record
               lo,hi:byte;
              end;

   TbyteRecBig = record
               B1,B2,B3,B4:byte;
              end;

   TIntegerArray = Array of integer;

   
var
  CosTable : PScalars = nil;
  SinTable : PScalars = nil;
  TrigTableDepth: word = 0;

procedure InitTrigTables(Depth: word);   {private}
Function WavMakeHeader(Samples,SampleRate,NumberOfChannels:integer):TWavheader;
procedure LoadWavFile(FName:string;  var Ch1,Ch2: TSoundFile; var header:TWavheader);   {Loads a Wave file}
procedure SaveWavFile(FName:string;  var Ch1,Ch2: TSoundFile; SRate:single);   {Saves a Wave file}
function  WavMax(Data:TSoundFile; start,slut:integer):double;  {Finds the Maximum value in a wave file is used for Normalize }
Procedure WavNormalize(var Data,Data2:TSoundFile; Max:double); overload; {Normalizes a sound file so it does not exceed max (Important if you want to play it on TDT systems)}
Procedure WavNormalize(var Data:TSoundFile; Max:double); overload;
Function  WavMakeWav(S1:Array of single):TSoundfile;
Function  WavConKatArray(S1,S2:TSoundFile):TSoundFile;  overload;  {Concatenates sound files}
procedure FFT(Depth: word; SrcR, SrcI: PScalars; DestR, DestI: PScalars);  {Advanced FFT function use if you need imaginary components}
//Function SimpleFFT(Input:TSoundFile):TSoundFile;  {Simple FFT function, see example with the function}
Function SimpleFFT2(Input:TSoundFile):TSoundFile;
Procedure Envelope(var Signal:TSoundFile; RiseFall:integer; EnwlopeType:string);   {multiply a envelope on a signal (not used yet)}
Function FindPeaks(Input:TSoundFile):TFFTpointArray;    {Make a list of all local maxima, most usefull on powerspectra}
Function FindPeakPpeakValue(DArray:TSoundFile): Single;  overload;
  Function FindPeakPpeakValue(DArray:array of single): Single; overload;
  Function FindPeakPpeakValue(DArray:TSoundFile; from_sample,to_sample:integer): Single; overload;
  Function FindPeakPpeakValue(DArray:array of single; from_sample,to_sample:integer): Single; overload;
Function CrossCorrDelay(Array1,Array2:TSoundFile; from_sample,to_sample:integer):single;
Function CrossCorr(Array1,Array2:TSoundFile):single;   overload;
  Function CrossCorr(Array1,Array2:TSoundFile; from_sample,to_sample:integer):single;   overload;
  Function CrossCorr(Array1,Array2:TSoundFile; from_sample,to_sample:integer; filterFreq:integer):single;   overload;
Function GetFilterCoff(freq:integer):TFilterCoff;
Function FilterLP(Input:TSoundFile; FilterCoff:TFilterCoff):TSoundFile;
Function FilterHP(Input:TSoundFile; cutoff:integer; SampleRate:single):TSoundFile;
Function TranslateHeader(headerStr:Theaderstr):TWavheader;
Function ReadWavHeader(FName:string):TWavheader;
Function HeaderToStr(header:TWavheader):String;
Function FTest(probability:integer;DegFree:integer):single;
Function WavAvr(File1,File2:TSoundFile):TSoundFile;
Function WavSubtract(File1,File2:TSoundFile):TSoundFile;
Function WavAdd(File1,File2:TSoundFile):TSoundFile;
//Function WavMasked(File1,File2,File3,File4:TSoundFile):TSoundFile;  //Calculats the masked ABR

implementation


Function WavMakeHeader(Samples,SampleRate,NumberOfChannels:integer):TWavheader;
Begin
 if NumberOfChannels>2 then Showmessage('WavMakeHeader this might not work');
 Result.Encoding:='RIFF';
 Result.filesize:= Samples*2+36;
 Result.FileType:='WAVE';
 Result.Code:='fmt';
 Result.Ukendt:=16;
 Result.tag:=1;
 Result.samplerate:=SampleRate;
 Result.bytessample:=2;
 Result.bytessec:= SampleRate*Result.bytessample;
 Result.bitssample:=16;
 Result.dataLength:=Samples*2;
 Result.RealLength:=Samples;
 Result.chno:=NumberOfChannels;
 Result.Header:='data';
end;


Function HeaderToStr(header:TWavheader):String;
var
 S:string;
Begin
 S:=            'Encoding: '  +  header.Encoding;
 S:= S+#13+     'Filetype: '  +  header.FileType;
 S:= S+#13+     'Code:   '    +  header.Code;
 S:= S+#13+     'Filesize: '  +  IntToStr(header.filesize) ;
 S:= S+#13+     'Ukendt:   '  +  IntToStr(header.Ukendt) ;
 S:= S+#13+     'Tag:   '     +  IntToStr(header.tag) ;
 S:= S+#13+     'SampleRate:' +  IntToStr(header.samplerate) ;
 S:= S+#13+     'Byte/Sec:  ' +  IntToStr(header.bytessec) ;
 S:= S+#13+     'Byte/Sample: '  +  IntToStr(header.bytessample) ;
 S:= S+#13+     'Bit/Sample: '  +  IntToStr(header.bitssample) ;
 S:= S+#13+     'Data Length: '  +  IntToStr(header.dataLength) ;
 S:= S+#13+     'Real Length: '  +  IntToStr(header.RealLength) ;
 S:= S+#13+     'Nr of chanl: '  +  IntToStr(header.chno) ;
 S:= S+#13+     'Header:   '  +  header.Header;
 Result:=S;
End;



 {Loads a Wave file}
procedure LoadWavFile(FName:string; var Ch1,Ch2: TSoundFile; var header:TWavheader);
var
  f:  file of byte;
  i,j:integer;
  headerstr : Theaderstr;
  byte1,byte2,byte3,byte4:byte;
  Channel1,Channel2: array of smallint;
  LData: Longint;
  SData: smallint;
begin
 SetLength(Channel1,1);
 SetLength(Channel2,1);
     AssignFile(f,FName);
     reset(f);
     for i:=1 to 44 do   
     begin
         read(f,byte1);
         headerstr[i]:=char(byte1);
     end;
     header:= TranslateHeader(headerstr);
     if header.Header<>'data' then  raise ERangeError.CreateFmt( 'LoadWavFile say: invalid datatype:'+header.Header,[header.bitssample, 8, 32]);
     j:=0;
    if header.chno=1 then  {1 channel}
    Begin
       case header.bitssample of
       32: repeat {32 bits 1 channel}
         read(f,byte1,byte2,byte3,byte4);
           TbyterecBig(LData).B1:=byte1;
           TbyterecBig(LData).B2:=byte2;
           TbyterecBig(LData).B3:=byte3;
           TbyterecBig(LData).B4:=byte4;
           SetLength(Ch1,J+1);
           Ch1[J]:=LData/2147483647;
         j:=j+1;
        until eof(f) ;
       16: repeat {16 bits 1 channel}
         read(f,byte1,byte2);
           Tbyterec(SData).lo:=byte1;
           Tbyterec(SData).hi:=byte2;
           SetLength(Ch1,J+1);
           Ch1[J]:=SData/32767;
         j:=j+1;
        until eof(f) ;
       8: repeat
         read(f,byte1);
           Tbyterec(SData).lo:=byte1;
           Tbyterec(SData).hi:=0;
           SetLength(Ch1,J+1);
           Ch1[J]:=SData/127;
         j:=j+1;
        until eof(f)  ;
       else
         raise ERangeError.CreateFmt( 'LoadWavFile say: %d bit is not valid, can not read file',[header.bitssample, 8, 32]);
       end;
    end;
    if header.chno=2 then  {1 channel}
    Begin
      case header.bitssample of
      32: repeat {32 bits 1 channel}
         read(f,byte1,byte2,byte3,byte4);
           TbyterecBig(LData).B1:=byte1;
           TbyterecBig(LData).B2:=byte2;
           TbyterecBig(LData).B3:=byte4;
           TbyterecBig(LData).B4:=byte4;
           SetLength(Ch1,J+1);
           Ch1[J]:=LData/2147483647;
         read(f,byte1,byte2,byte3,byte4);
           TbyterecBig(LData).B1:=byte1;
           TbyterecBig(LData).B2:=byte2;
           TbyterecBig(LData).B3:=byte3;
           TbyterecBig(LData).B4:=byte4;
           SetLength(Ch2,J+1);
           Ch2[J]:=LData/2147483647;
         j:=j+1;
        until (eof(f)) ;
      16: repeat {16 bits 2 channels}
          read(f,byte1,byte2);
           Tbyterec(SData).lo:=byte1;
           Tbyterec(SData).hi:=byte2;
           SetLength(Ch1,J+1);
           Ch1[J]:=SData/32767;
          read(f,byte1,byte2);
           Tbyterec(SData).lo:=byte1;
           Tbyterec(SData).hi:=byte2;
           SetLength(Ch2,J+1);
           Ch2[J]:=SData/32767;
        j:=j+1;
       until eof(f)  ;
      8: repeat
         read(f,byte1);
           Tbyterec(SData).lo:=byte1;
           Tbyterec(SData).hi:=0;
           SetLength(Ch1,J+1);
           Ch1[J]:=SData/127;
         read(f,byte1);
           Tbyterec(SData).lo:=byte1;
           Tbyterec(SData).hi:=0;
           SetLength(Ch2,J+1);
           Ch2[J]:=SData/127;
         j:=j+1;
       until eof(f);
       else
         raise ERangeError.CreateFmt( 'LoadWavFile say: %d bit is not valid, can not read file',[header.bitssample, 8, 32]);
       end;
    end;
    closefile(f);
    header.RealLength:= Length(Ch1);
end;



 {Finds the Maximum value in a wave file is used for Normalize }
function WavMax(Data:TSoundFile; start,slut:integer):double;
var
 i:integer;
 Max,min:double;
Begin
  if slut=0 then slut:= Length(Data)-1;
  max:=0; min:=0;
  for i:=start to slut do
  Begin
    if Data[i]>max then max:= Data[i];
    if Data[i]<min then min:= Data[i];
  end;
  if sqr(min)>sqr(max) then WavMax:= -1 * min else WavMax:= max;
end;


Procedure WavNormalize(var Data,Data2:TSoundFile; Max:double); overload;
var
 i:integer;
 peak,Max1,Max2:double;
Begin
 Max1:= WavMax(Data,0,0); Max2:= WavMax(Data2,0,0);
 If max1>Max2 then  peak:= Max / Max1 else Peak:= Max/Max2;
 for i:=0 to Length(Data)-1 do Data[i]:=  Data[i]* peak;
 for i:=0 to Length(Data2)-1 do Data2[i]:=  Data2[i]* peak;
end;


  {Normalizes a sound file so it does not exceed max (Important if you want to play it on TDT systems)}
Procedure WavNormalize(var Data:TSoundFile; Max:double); overload;
var
 i:integer;
 peak:double;
Begin
 peak:= Max / WavMax(Data,0,0);
 for i:=0 to Length(Data)-1 do Data[i]:=  Data[i]* peak;
end;


Function  WavMakeWav(S1:Array of single):TSoundfile;
var
 L,i:integer;
Begin
 L:=Length(S1);
 SetLength(Result,L);
 for i:=0 to L-1 do Result[i]:=S1[i];
end;



 {Concatenates sound files}
Function WavConKatArray(S1,S2:TSoundFile):TSoundFile;  overload;
var
 L1,L2,i:integer;
Begin
  L1:=Length(S1); L2:=Length(S2);
  For i:=0 to L2-1 do
    Begin
      SetLength(S1,(L1+i+1));
      S1[L1+i]:= S2[i];
    end;
  Result:=S1;
end;

Function WavConKatArray(S1,S2,S3:TSoundFile):TSoundFile;  overload;
Begin  result:=WavConKatArray(S1,S2);   result:=WavConKatArray(result,S3); end;

Function WavConKatArray(S1,S2,S3,S4:TSoundFile):TSoundFile;  overload;
Begin  result:=WavConKatArray(S1,S2,S3);   result:=WavConKatArray(result,S4); end;

Function WavConKatArray(S1,S2,S3,S4,S5:TSoundFile):TSoundFile;  overload;
Begin  result:=WavConKatArray(S1,S2,S3,S4);   result:=WavConKatArray(result,S5); end;

Function WavConKatArray(S1,S2,S3,S4,S5,S6:TSoundFile):TSoundFile;  overload;
Begin  result:=WavConKatArray(S1,S2,S3,S4,S5);   result:=WavConKatArray(result,S6); end;

Function WavConKatArray(S1,S2,S3,S4,S5,S6,S7:TSoundFile):TSoundFile;  overload;
Begin  result:=WavConKatArray(S1,S2,S3,S4,S5,S6);   result:=WavConKatArray(result,S7); end;

Function WavConKatArray(S1,S2,S3,S4,S5,S6,S7,S8:TSoundFile):TSoundFile;  overload;
Begin  result:=WavConKatArray(S1,S2,S3,S4,S5,S6,S7);   result:=WavConKatArray(result,S8); end;




{the recursive part called by FFT when ready}
procedure DoFFT(Depth: word;  SrcR, SrcI: PScalars;  SrcSpacing: word;  DestR, DestI: PScalars);
var
  j, N: integer;
  TempR, TempI: TScalar;
  Shift: word;
  c, s: extended;
begin
 if Depth = 0 then
 begin
  DestR^[0]:= SrcR^[0];
  DestI^[0]:= SrcI^[0];
  exit;
 end;
 N:= Integer(1) shl (Depth - 1);
 DoFFT(Depth - 1, SrcR, SrcI, SrcSpacing * 2, DestR, DestI);
 DoFFT(Depth - 1,  @SrcR^[srcSpacing],  @SrcI^[SrcSpacing],  SrcSpacing * 2,  @DestR^[N],  @DestI^[N]);
 Shift:= TrigTableDepth - Depth;
 for j:= 0 to N - 1 do
  begin
    c:= CosTable^[j shl Shift];
    s:= SinTable^[j shl Shift];
    TempR:= c * DestR^[j + N] - s * DestI^[j + N];
    TempI:= c * DestI^[j + N] + s * DestR^[j + N];
    DestR^[j + N]:= DestR^[j] - TempR;
    DestI^[j + N]:= DestI^[j] - TempI;
    DestR^[j]:= DestR^[j] + TempR;
    DestI^[j]:= DestI^[j] + TempI;
  end;
end;

  {Advanced FFT function use if you need imaginary components}
  {SrcR = Input Real; DestI = Destination Imaginary}
procedure FFT(Depth: word;  SrcR, SrcI: PScalars;  DestR, DestI: PScalars);
var
  j, N: integer;
  Normalizer: extended;
begin
 N:= integer(1) shl depth;
 if Depth > TrigTableDepth then InitTrigTables(Depth);
 DoFFT(Depth, SrcR, SrcI, 1, DestR, DestI);
 Normalizer:= 1 / sqrt(N) ;
 for j:=0 to N - 1 do
   begin
    DestR^[j]:= DestR^[j] * Normalizer;
    DestI^[j]:= DestI^[j] * Normalizer;
   end;
end;



procedure InitTrigTables(Depth: word);
var
  j, N : integer;
begin
 N:= integer(1) shl depth;
 ReAllocMem(CosTable, N * SizeOf(TScalar));
 ReAllocMem(SinTable, N * SizeOf(TScalar));
 for j:=0 to N - 1 do
   begin
   CosTable^[j]:= cos(-(2*Pi)*j/N);
   SinTable^[j]:= sin(-(2*Pi)*j/N);
   end;
 TrigTableDepth:= Depth;
end;


Function IsDifferentFromZero(Input:TSoundFile):Boolean;
var
 i,L:integer;
 Stop:boolean;
Begin
 i:=0;
 L:= Length(Input);
 stop:=False;
 if L=0 then
    Stop:=false // if there is no content in the file
 else
  begin
    repeat
     inc(i);
     if Input[i]<>0 then stop:=true;
    until (stop or (i=(L-1)));
  end;
  Result:=Stop;
end;

     {SHOULD NOT BE USED, use SimpleFFT2 instead}
{**** Very simple FFT, Takes a real signal and  ****}
{****          returns a Power spectrum         ****}

{ Var WavSignal,Power:TSoundFile                 }
{ L:= length(WavSignal);                         }
{ Power:=SimpleFFT(WavSignal);                   }
{ for i:=0 to length(Power)-1 do Chart1.Series[0].AddXY(i*(sampelrate/L),Power[i]);   }

Function SimpleFFT(Input:TSoundFile):TSoundFile;
var
 SrcR, SrcI,DestR, DestI : PScalars;
 N,L,i,Depth : integer;
Begin
 if not IsDifferentFromZero(Input) then Result:= Input else
Begin
 L:=Length(Input);
 Showmessage('Dont use SimpleFFT' + IntToStr(L));
 Depth:=1;
 Repeat
  inc(Depth);
  N:= integer(1) shl Depth;
 Until (N  >= L);
 if not(N=L) then
  Begin
    Setlength(Input,N);
    for i:=L to N-1 do Input[i]:= Input[L-1];
  End;
 GetMem(SrcR, N * SizeOf(TScalar));
 GetMem(SrcI, N * SizeOf(TScalar));
 GetMem(DestR, N * SizeOf(TScalar));
 GetMem(DestI, N * SizeOf(TScalar));

 for i:=0 to N - 1 do
   Begin
     SrcR^[i]:=Input[i]  ;
     SrcI^[i]:=0;
   End ;
 FFT(Depth,SrcR, SrcI, DestR, DestI);
 SetLength(Result,(N div 2));
 for i:=0 to (N div 2)-1 do Result[i]:= sqrt(sqr(DestI^[i]) + sqr(DestR^[i]));
 FreeMem(SrcR, N * SizeOf(TScalar));
 FreeMem(SrcI, N * SizeOf(TScalar));
 FreeMem(DestR, N * SizeOf(TScalar));
 FreeMem(DestI, N * SizeOf(TScalar));
end;
end;


// Better FFT function should always be used instead of SimpleFFT
// require  (FFTs,Complexs) in uses

Function SimpleFFT2(Input:TSoundFile):TSoundFile;
var
 Source: array of TComplex;
 Dest: array of TComplex;
 Count,i: integer;
 test : Boolean;
Begin
 if not IsDifferentFromZero(Input) then Result:= Input else
Begin
 Count:=Length(Input);

 For i:=0 to Count-1 do
   begin
     SetLength(Source,i+1);
     SetLength(Dest,i+1);
     Dest[i].Re:=0;
     Dest[i].Im:=0;
     Source[i].Re := Input[i];
     Source[i].Im := 0;
   End;

 ForwardFFT(Source,Dest,Count);

 For i:=0 to round((Length(Dest)-1)/2) do
   begin
     SetLength(Result,i+1);
     Result[i]:= sqrt(sqr(Dest[i].Re) +  sqr(Dest[i].Im));
   End;

end;
end;



 {multiply a envelope on a signal (not used yet)}
Procedure Envelope(var Signal:TSoundFile; RiseFall:integer; EnwlopeType:string);
var
L,i:integer;
a:single;
done:Boolean;
Begin

Done:=false;
L:=Length(Signal);

if EnwlopeType = 'COS2_FLAT' then  begin
  if Risefall<=0 then Risefall:=Round(0.2*L);
  for i:=0 to RiseFall-1 do Signal[i]:= Signal[i] * sqr( cos( ((i*0.5*Pi))/RiseFall +(0.5*Pi)) );
  for i:=RiseFall to L-RiseFall-1 do Signal[i]:= Signal[i] * 1;
  for i:=L-RiseFall to L-1 do Signal[i]:= Signal[i] * sqr( cos( (((i-(L-RiseFall))*0.5*Pi))/RiseFall) );
  Done:=True;
End;

if EnwlopeType = 'COS_FLAT' then  begin
  if Risefall<=0 then Risefall:=Round(0.2*L);
  for i:=0 to RiseFall-1 do Signal[i]:= Signal[i] * abs( cos( ((i*0.5*Pi))/RiseFall +(0.5*Pi)) );
  for i:=RiseFall to L-RiseFall-1 do Signal[i]:= Signal[i] * 1;
  for i:=L-RiseFall to L-1 do Signal[i]:= Signal[i] * abs( cos( (((i-(L-RiseFall))*0.5*Pi))/RiseFall) );
  Done:=True;
End;

if EnwlopeType = 'HAMMING' then  begin
  for i:=0 to L-1 do Signal[i]:= Signal[i] * (0.54 - 0.46* cos((2*PI*i)/(L-1) )  ) ;
  Done:=True;
End;

if EnwlopeType = 'HANNING' then  begin
  for i:=0 to L-1 do Signal[i]:= Signal[i] * 0.5*(1 - cos((2*PI*i)/(L-1)));
  Done:=True;
End;

if EnwlopeType = 'COSINE' then  begin
  for i:=0 to L-1 do Signal[i]:= Signal[i] * sin((PI*i)/(L-1));
  Done:=True;
End;

if EnwlopeType = 'BLACKHARRIS' then  begin
  for i:=0 to L-1 do Signal[i]:= Signal[i] * 0.35875 - 0.48829*cos((2*pi*i)/(L-1)) + 0.14128*cos((4*pi*i)/(L-1)) - 0.01168*cos((6*pi*i)/(L-1))  ;
  Done:=True;
End;

if EnwlopeType = 'GAUSS' then  begin
  a:=0.4;
  for i:=0 to L-1 do Signal[i]:= Signal[i] * Exp( -0.5* sqr( (i-(L-1)/2)/(a*(L-1)/2) )  ) ;
  Done:=True;
End;

If not done then raise exception.Create('No filter of type '+ EnwlopeType);
end;



 {Make a list of all local maxima, most useful on powerspectra}
Function FindPeaks(Input:TSoundFile):TFFTpointArray;
var
i,k,L:integer;
X:double;
Begin
k:=0;
L:= length(Input);
SetLength(Result,0);
for i:=3 to L-4 do
  Begin
   if (Input[i]>Input[i+1]) AND (Input[i]>Input[i+2]) AND (Input[i]>Input[i+3]) 
   AND (Input[i]>Input[i-1]) AND (Input[i]>Input[i-2]) AND (Input[i]>Input[i-3])
   then
     Begin
       SetLength(Result,k+1);
       X:= Input[i];
       result[k].Amp:= X;
       result[k].freq:=i;
       inc(k);
     end;
  end;
end;





Function FindPeakPpeakValue(DArray:TSoundFile): Single; overload;
var
  i,L : integer;
  max,min : Single;
begin
 max:= DArray[0]; min:= DArray[0];
 L:= Length(DArray);
   For i:=0 to L-1 do
   begin
     if DArray[i]>max then max:= DArray[i];
     if DArray[i]<min then min:= DArray[i];
   end;
 Result:= max-min;
End;



Function FindPeakPpeakValue(DArray:array of single): Single; overload;
var
  i,L : integer;
  max,min : Single;
begin
 max:= DArray[0]; min:= DArray[0];
 L:= Length(DArray);
   For i:=0 to L-1 do
   begin
     if DArray[i]>max then max:= DArray[i];
     if DArray[i]<min then min:= DArray[i];
   end;
 Result:= max-min;
End;




Function FindPeakPpeakValue(DArray:TSoundFile; from_sample,to_sample:integer): Single; overload;
var
i,L : integer;
max,min : single;
begin
L:=Length(DArray)-1;
if L>0 then
   Begin
        max:= DArray[0]; min:= DArray[0];
        if to_sample > L then to_sample:=L;
        if from_sample > to_sample-1 then from_sample:=to_sample-1;

          For i:=from_sample to to_sample do begin
           if DArray[i]>max then max:= DArray[i];
           if DArray[i]<min then min:= DArray[i];
         end;
        Result:= max-min;
   End
End;


Function FindPeakPpeakValue(DArray:array of single; from_sample,to_sample:integer): Single; overload;
var
i,L : integer;
max,min : single;
begin
L:=Length(DArray)-1;
if L>0 then
   Begin
        max:= DArray[0]; min:= DArray[0];
        if to_sample > L then to_sample:=L;
        if from_sample > to_sample-1 then from_sample:=to_sample-1;

          For i:=from_sample to to_sample do begin
           if DArray[i]>max then max:= DArray[i];
           if DArray[i]<min then min:= DArray[i];
         end;
        Result:= max-min;
   End
End;

//************Calculates the delay that results in the highest cross correlation score

Function CrossCorrDelay(Array1,Array2:TSoundFile; from_sample,to_sample:integer):single;
var
 k,i,kmax,jitter: integer;
 sum,sum_Old:double;
begin
  jitter:=50;
  Sum_Old:=-1000000;
  kmax:=-1000000;
  if (from_sample-jitter)<1 then from_sample:=jitter+1;
  if (to_sample+jitter)>Length(Array1) then to_sample:=Length(Array1)-(jitter+1);
  if length(Array1)<>length(Array2) then showmessage('Arrays have to be equeal Length for CrossCorr');
  For k:=(-jitter) to jitter do
  begin
    Sum:=0;
    For i:=from_sample to to_sample do sum:= sum + (Array1[i]* Array2[i+k]);
    if sum > sum_Old then begin kmax:=k; sum_Old:=sum; end;
  end;
  If kmax=-1000000 then showmessage('CrossCorr error1');
  Result:=kmax;
end;


//************Calculates the cross correlation of two syncronized signals

Function CrossCorr(Array1,Array2:TSoundFile):single;
var
 i: integer;
 sum:double;
begin
    Sum:=0;
    For i:=0 to Length(Array1)-1 do sum:= sum + (Array1[i]* Array2[i]);
  Result:=sum;
end;


Function CrossCorr(Array1,Array2:TSoundFile; from_sample,to_sample:integer):single;
var
 i,L1,L2: integer;
 sum:double;
begin
    Sum:=0;
    L1:=Length(Array1)-1;
    L2:=Length(Array2)-1;
    If L1 > L2 then L1 := L2;
    If to_sample > L1 then to_sample:=L1;
    If from_sample > L1 then from_sample:=0;

    For i:=from_sample to to_sample do sum:= sum + (Array1[i]* Array2[i]);
  Result:=sum;
end;



//************Calculates the cross correlation of two Filtered and syncronized signals

Function CrossCorr(Array1,Array2:TSoundFile; from_sample,to_sample:integer; filterFreq:integer):single;   overload;
var
 FArray1,FArray2 :  TSoundFile;
Begin
  FArray1 := FilterLP( Array1 , GetFilterCoff(filterFreq));
  FArray2 := FilterLP( Array2 , GetFilterCoff(filterFreq));
  Result:=CrossCorr(FArray1,FArray2, from_sample,to_sample);
end;


//***********************************************


Function GetFilterCoff(freq:integer):TFilterCoff;
var
 Filtered:Boolean;
Const
  FilterLP0Hz: TFilterCoff = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  FilterLP2000Hz: TFilterCoff = (0.001691,0.001737,0.001392,-0.000111,-0.003481,-0.008619,-0.014024,-0.016731,    -0.012990,0.000451,0.024871,0.058518,0.096469,0.131607,0.156482,0.165470, 0.156482,0.131607,0.096469,0.058518,0.02487,0.000451,-0.012990,-0.016731, -0.014024,-0.008619,-0.003481,-0.000111,0.001392,0.001737,0.001691);
  FilterLP2500Hz: TFilterCoff = (-0.000396,0.000812,0.002544,0.004412,0.004819,0.001541,-0.006577,-0.017688, -0.026153,-0.023901,-0.003839,0.036106,0.090421,0.146571,0.188958,0.204738, 0.188958,0.146571,0.090421,0.036106,-0.003839,-0.023901,-0.026153,-0.017688, -0.006577,0.001541,0.004819,0.004412,0.002544,0.000812,-0.000396);
  FilterLP3000Hz: TFilterCoff = (-0.001085,-0.002045,-0.002243,-0.000337,0.004424,0.009877,0.010527, 0.000988,-0.018111,-0.036268,-0.035839,-0.001703,0.067326,0.153257,0.224865, 0.252734,0.224865,0.153257,0.067326,-0.001703,-0.035839,-0.036268,-0.018111, 0.000988,0.010527,0.009877,0.004424,-0.000337,-0.002243,-0.002045,-0.001085);
  FilterLP3500Hz: TFilterCoff = (0.001433,0.000205,-0.002112,-0.004409,-0.003383,0.003632,0.013485,0.015975, 0.001343,-0.027292,-0.048143,-0.031000,0.040099,0.148466,0.247726,0.287951, 0.247726,0.148466,0.040099,-0.031000,-0.048143,-0.027292,0.001343,0.015975, 0.013485,0.003632,-0.003383,-0.004409,-0.002112,0.000205,0.001433);
  FilterLP4000Hz: TFilterCoff = (0.000265,0.001899,0.002312,-0.000557,-0.006152,-0.007964,0.001321,0.017667, 0.022064,-0.002267,-0.043572,-0.056826,0.003033,0.133599,0.270574,0.329203, 0.270574,0.133599,0.003033,-0.056826,-0.043572,-0.002267,0.022064,0.017667, 0.001321,-0.007964,-0.006152,-0.000557,0.002312,0.001899,0.000265);
Begin
 Filtered:=False;
 if freq=-1   then Begin Result:=FilterLP0Hz;    Filtered:=true; end;
 if freq=2000 then Begin Result:=FilterLP2000Hz; Filtered:=true; end;
 if freq=2500 then Begin Result:=FilterLP2500Hz; Filtered:=true; end;
 if freq=3000 then Begin Result:=FilterLP3000Hz; Filtered:=true; end;
 if freq=3500 then Begin Result:=FilterLP3500Hz; Filtered:=true; end;
 if freq=4000 then Begin Result:=FilterLP4000Hz; Filtered:=true; end;

 If not(Filtered) then
   Begin
    Result:=FilterLP4000Hz;
    raise ERangeError.CreateFmt( 'Wav_handler.GetFilterCoff say: %d is not within the valid range of %d..%d',[freq, 2000, 4000]);
   end;
end;




Function FilterLP(Input:TSoundFile; FilterCoff:TFilterCoff):TSoundFile;
var
L,i,j:Integer;
Sum:double;
Begin
  L:= length(Input);
  SetLength(Result,L);
  For i :=0 to L-1 do
    begin
      Sum:=0;
      For j:=-15 to 15 do
        Begin
         if (((L>(i+j)) And ((i+j)>-1))) then sum:= Sum+ FilterCoff[j]*Input[i+j];
        end;
      Result[i]:=Sum;
    End;
end;


Function FilterHP(Input:TSoundFile; cutoff:integer; SampleRate:single):TSoundFile;
var
 RC,dt,a : double;
 i:integer;
Begin
  RC := 1/(2*pi*cutoff);
  dt := 1/SampleRate;
  a  := RC / (RC+dt);
  setlength(Result,length(Input));
  Result[0]:= Input[0];
  for i:=1 to length(Input)-1 do Result[i]:= a* ( Result[i-1] + Input[i] - Input[i-1] );
end;




Function TranslateHeader(headerStr:Theaderstr):TWavheader;
var
i:integer;
header:TWavheader;
Begin
   //Encoding
     header.Encoding:= headerstr[1] + headerstr[2] + headerstr[3] + headerstr[4];
  //Filesize
     i:=ord(headerstr[8])*256*256*256+ord(headerstr[7])*256*256
       +ord(headerstr[6])*256+ord(headerstr[5]);
       header.filesize:=i;
  //FileType
       header.FileType := headerstr[9] + headerstr[10] + headerstr[11] + headerstr[12];
  //Code
     header.Code := headerstr[13] + headerstr[14] + headerstr[15] + headerstr[16];
  //Ukendt
          i:=ord(headerstr[20])*256*256*256+ord(headerstr[19])*256*256
       +ord(headerstr[18])*256+ord(headerstr[17]);
       Header.Ukendt:=i;
  //Tag
     i:=ord(headerstr[22])*256+ord(headerstr[21]);
     header.tag:=i;
  //Number of channels
     i:=ord(headerstr[24])*256+ord(headerstr[23]);
     header.chno:=i;
  //sampelrate
     i:=ord(headerstr[28])*256*256*256+ord(headerstr[27])*256*256
       +ord(headerstr[26])*256+ord(headerstr[25]);
       header.samplerate:=i;
  //Bytes/sek
     i:=ord(headerstr[32])*256*256*256+ord(headerstr[31])*256*256
       +ord(headerstr[30])*256+ord(headerstr[29]);
       header.bytessec:=i;
  //Bytes/sampel
     i:=ord(headerstr[34])*256+ord(headerstr[33]);
     header.bytessample:=i;
  //Bits/sampel
     i:=ord(headerstr[36])*256+ord(headerstr[35]);
     header.bitssample:=i;
  //Header
       Header.Header:= headerstr[37] + headerstr[38] + headerstr[39] + headerstr[40];
  //Data size
     i:=ord(headerstr[44])*256*256*256+ord(headerstr[43])*256*256
       +ord(headerstr[42])*256+ord(headerstr[41]);
       header.dataLength:=i;
  //Real Length // is unknown until the whole file is read
   Header.RealLength:=-1;
  Result:= header;
End;




 {Read the header of a Wave file}
Function ReadWavHeader(FName:string):TWavheader;
var
  f:  file of byte;
  i:integer;
  headerstr:Theaderstr;
  byte1:byte;
begin
     AssignFile(f,FName);
     reset(f);
     for i:=1 to 44 do
     begin
       read(f,byte1);
       headerstr[i]:=char(byte1);
     end;
     closefile(f);
     Result:= TranslateHeader(headerStr);

end;





Procedure IntToBytes(K:integer; var B1,B2,B3,B4:char);  overload;
Begin
    //K:= header.filesize;
    B4:= chr( (K div (256*256*256)) );
    K:= K mod (256*256*256);
    B3:= chr( (K div (256*256)) );
    K:= K mod (256*256);
    B2:= chr( (K div (256)) );
    K:= K mod (256);
    B1:= chr(K);
end;


Procedure IntToBytes(K:integer; var B1,B2:char);  overload;
Begin
    B2:= chr( (K div (256)) );
    K:= K mod (256);
    B1:= chr(K);
end;


//Function WavMakeHeader(SpRate,



procedure SaveWavFile(FName:string;  var Ch1,Ch2: TSoundFile; SRate:single);   {Saves a Wave file}
var
  header:TWavheader;
  f:  file of byte;
  i,Samples,channels:integer;
  Hstr:Theaderstr;
  byte1,byte2,byte3,byte4:byte;
  //VSmall:Shortint;
  Small:Smallint;
  Big:Longint;
Begin
  if SRate>1 then begin
  Samples:=Length(Ch1);
  if Length(Ch2)+100 > Length(Ch1) then channels:=2 Else channels:=1;
  header:=WavMakeHeader(Samples,round(SRate),channels);
  end;
  Hstr[1]:=  'R'; Hstr[2]:= 'I'; Hstr[3]:= 'F'; Hstr[4]:= 'F';          //Encoding (RIFF)
  IntToBytes(header.filesize,Hstr[5],Hstr[6],Hstr[7],Hstr[8]);          //Filesize
  Hstr[9]:=  'W'; Hstr[10]:= 'A'; Hstr[11]:= 'V'; Hstr[12]:= 'E';       //Filetype (WAVE)
  Hstr[13]:= 'f'; Hstr[14]:= 'm'; Hstr[15]:= 't'; Hstr[16]:= ' ';       //Code
  IntToBytes(header.Ukendt,Hstr[17],Hstr[18],Hstr[19],Hstr[20]);        //Ukendt
  IntToBytes(header.tag ,Hstr[21],Hstr[22]);                            //Tag
  IntToBytes(header.chno,Hstr[23],Hstr[24]);                            //Number of channels
  IntToBytes(header.samplerate,Hstr[25],Hstr[26],Hstr[27],Hstr[28]);    //sampelrate
  IntToBytes(header.bytessec,Hstr[29],Hstr[30],Hstr[31],Hstr[32]);      //Bytes/sek
  IntToBytes(header.bytessample,Hstr[33],Hstr[34]);                     //Bytes/sampel
  IntToBytes(header.bitssample ,Hstr[35],Hstr[36]);                     //Bits/sampel
  Hstr[37]:= 'd'; Hstr[38]:= 'a'; Hstr[39]:= 't'; Hstr[40]:= 'a';       //Header
  IntToBytes(header.dataLength,Hstr[41],Hstr[42],Hstr[43],Hstr[44]);    //Data size

 //Save Data
 AssignFile(f,FName);
 rewrite(f);

 for i:=1 to 44 do write(f,Byte(Hstr[i]));

 for i:=0 to Length(ch1)-1 do
 Begin
     if header.chno=1 then
     begin  // 1 channel
       //if header.bitssample=32 then    // 16bit
       case header.bitssample of
       32: Begin
           Big:= round(ch1[i]);
           Byte1:=TbyterecBig(Big).B1;
           Byte2:=TbyterecBig(Big).B2;
           Byte3:=TbyterecBig(Big).B3;
           Byte4:=TbyterecBig(Big).B4;
           write(f,byte1,byte2,byte3,byte4);
           end;
      // if header.bitssample=16 then    // 16bit
       16: Begin
           Small:= round(ch1[i]);
           Byte1:=Tbyterec(Small).lo;
           Byte2:=Tbyterec(Small).hi;
           write(f,byte1,byte2);
           end;
       //if header.bitssample=8 then   // 8bit
       8:  Begin
           Small:= round(ch1[i]);
           Byte1:=Tbyterec(Small).lo;
           write(f,byte1);
           end;
       else
           raise ERangeError.CreateFmt( 'SaveWavFile say: %d bit is not valid, use %d , 16 or %d',[header.bitssample, 8, 32]);
       end;
     end;

     if header.chno=2 then
     Begin  // 2 channels
       //if header.bitssample=32 then    // 32bit
       case header.bitssample of
       32: Begin
           Big:= round(ch1[i]);
            Byte1:=TbyterecBig(Big).B1;
            Byte2:=TbyterecBig(Big).B2;
            Byte3:=TbyterecBig(Big).B3;
            Byte4:=TbyterecBig(Big).B4;
            write(f,byte1,byte2,byte3,byte4);
           if i<Length(ch2)-1 then Big:= round(ch2[i]) else Big:=0;
            Byte1:=TbyterecBig(Big).B1;
            Byte2:=TbyterecBig(Big).B2;
            Byte3:=TbyterecBig(Big).B3;
            Byte4:=TbyterecBig(Big).B4;
            write(f,byte1,byte2,byte3,byte4);
          end;
       //if header.bitssample=16 then    // 16bit
       16: Begin
           Small:= round(ch1[i]);
            Byte1:=Tbyterec(Small).lo;
            Byte2:=Tbyterec(Small).hi;
            write(f,byte1,byte2);
           if i<Length(ch2)-1 then Small:= round(ch2[i]) else Small:=0;
            Byte1:=Tbyterec(Small).lo;
            Byte2:=Tbyterec(Small).hi;
            write(f,byte1,byte2);
          end;
       //if header.bitssample=8 then     // 8bit    // virker nok ikke :P
       8:  Begin
           Small:= round(ch1[i]);
            Byte1:=Tbyterec(Small).lo;
            write(f,byte1);
           if i<Length(ch2)-1 then Small:= round(ch2[i]) else Small:=0;
            Byte1:=Tbyterec(Small).lo;
            write(f,byte1);
          end;
       else
          raise ERangeError.CreateFmt( 'SaveWavFile say: %d bit is not valid, use %d , 16 or %d',[header.bitssample, 8, 32]);
       end;

     end;
 end;
 closefile(f);
end;



Function FTest(probability:integer;DegFree:integer):single;
Const
 DEGR: array[0..15] of Integer=(      5,    10,    20,    30,    40,    50,   100,   200,   300,   400,   500,   600,   700,  1000,  1500,  1900);
 F005: array[0..15] of single =( 5.0503,2.9782,2.1242,1.8409,1.6928,1.5995,1.3917,1.2626,1.2095,1.1790,1.1587,1.1439,1.1325,1.1097,1.0887,1.0784);
 F001: array[0..15] of single =(10.9670,4.8491,2.9377,2.3860,2.1142,1.9490,1.5977,1.3912,1.3090,1.2624,1.2317,1.2095,1.1925,1.1586,1.1277,1.1127);
F0001: array[0..15] of single =(29.7524,8.7539,4.2900,3.2171,2.7268,2.4413,1.8674,1.5516,1.4306,1.3632,1.3191,1.2876,1.2636,1.2161,1.1731,1.1524);
var
i:integer;
done,error:boolean;
Begin
 i := -1;
 Error := true;
 Result:= -1;
repeat
 inc(i);
 if DEGR[i]>DegFree then done:=true else done:=False;
until done or (i>=(Length(DEGR)-1));

If probability=50 then
        Begin
          Result:=F005[i];
          Error:=False;
        end;

If probability=10 then
        Begin
          Result:=F001[i];
          Error:=False;
        end;

If probability=1 then
        Begin
          Result:=F0001[i];
          Error:=False;
        end;
If Error then raise exception.Create('Impossible Value for F-test '+ FloatToStr(probability));
end;


Function WavAvr(File1,File2:TSoundFile):TSoundFile;
var
 i,L:Integer;
Begin
 L:=Length(File1);
 if L>Length(File2) then L:=Length(File2);
 SetLength(Result,L);
 for i:=0 to L-1 do Result[i]:=(File1[i]+File2[i])/2;
end;


Function WavSubtract(File1,File2:TSoundFile):TSoundFile;
var
 i,L:Integer;
Begin
 L:=Length(File1);
 if L>Length(File2) then L:=Length(File2);
 SetLength(Result,L);
 for i:=0 to L-1 do Result[i]:=(File1[i]-File2[i]);
end;


Function WavAdd(File1,File2:TSoundFile):TSoundFile;
var
 i,L:Integer;
Begin
 L:=Length(File1);
 if L>Length(File2) then L:=Length(File2);
 SetLength(Result,L);
 for i:=0 to L-1 do Result[i]:=(File1[i]+File2[i]);
end;





{Function WavMasked(File1,File2,File3,File4:TSoundFile):TSoundFile;  //Calculats the masked ABR
var
 i,L:Integer;
Begin
 L:=Length(File1);
 if L>Length(File2) then L:=Length(File2);
 if L>Length(File3) then L:=Length(File3);
 if L>Length(File4) then L:=Length(File4);
 SetLength(Result,L);
 for i:=0 to L-1 do Result[i]:=((File1[i]+File2[i]) - (File3[i]+File4[i])) / 2;
End; }




procedure DetectPeaks(Data:TSoundFile; var posi,Nega:TIntegerArray);
var
  Width_peak:integer; // maximum width of peak in samples
  Hight_peak:double;  // minimum Hight of peak
  i,k,Wid,N,P:integer;    // Max,Min
  temp1,temp2: TIntegerArray;
  PPeak,NPeak:Boolean;
  PPeak_old,NPeak_old:Boolean;
Begin
    Showmessage('This function is not yet finished');
{*
  Hight_peak:= 1;
  Width_peak:= 10;

  PPeak:=False; NPeak:=False;


  Wid:=  Round(Width_peak/2);
  For i:=Wid+1 to Length(Data)-(Wid+1) do
  Begin


    IF   ( (Data[i]-Data[i-Wid] ) > Hight_peak )
    AND  ( (Data[i]-Data[i+Wid] ) > Hight_peak )
    THEN                                         // if both values are below the peak
      Begin
       k:= Length(temp1)+1;
       SetLength(temp1,k);
       temp1[k]:=i;
       If PPeak then if Data[i]>Data[Posi[P]] then Posi[P]:=i;
       PPeak:=True;
      end else PPeak:=False;


    IF   ( -(Data[i]-Data[i-Wid]) > Hight_peak )
    AND  ( -(Data[i]-Data[i+Wid]) > Hight_peak )
    THEN                                         // if both values are abowe the peak
      Begin
       k:= Length(temp2)+1;
       SetLength(temp2,k);
       temp2[k]:=i;
       If NPeak then if Data[i]>Data[Nega[P]] then Nega[P]:=i;
       NPeak:=True;
      end else NPeak:=False;

    IF PPeak_old AND not(PPeak) then inc(P);
    IF NPeak_old AND not(NPeak) then inc(N);

    PPeak_old:=PPeak;
    NPeak_old:=NPeak;

  End;

  posi:=temp1;
  Nega:=temp2;
  *}
end;


end.
