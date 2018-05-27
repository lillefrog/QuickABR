unit commonUnit;


interface
Uses   Dialogs,Windows,Messages,Sysutils,FilterUnit,Wav_handler;

Type TSubMeas = array[0..2000] of single;       // must fit TFilterData(filterunit) and TDTSignal (TDTunit)
Type TMeas = array[0..100] of TSubMeas;

Type TSubMeas2 = array[0..1000] of single;
Type TMeas2 = array[0..100] of TSubMeas2;

Type TJewett = Array[1..9] of integer;
Type TJewettAmp = Array[1..9] of single;
Type TMeadianList = Array of Single;

Type
  TMeasFile = Record         // definition of a .AB3 fil
    Kommentar: String[255];
    Kommentar2: String[255];     // not used
    SampelRate: Single;
    Filter:Integer;
    Jewett:TJewett;           // not used
    Amp_Tone  :Integer;      // I dB SPL   -100 betyder ingen tone
    Freq_Tone :Integer;      // Frequency of the tone 0 means click only
    Amp_Klik  :Integer;      // I dB SPL
    Freq_Klik :Integer;      // not used
    //Name_Klik :String[255];
    Nr: Integer;                // How far did the recording go before being disconnected.
    Tag:integer;
    Meas: TMeas;
    Resume: TSubMeas;       // Avarage of all measurements inc filter, mostly for display purposes
  End;

Type
  TMeasFile2 = Record         // definitionen on a .AB4 fil
    Kommentar: String[255];
    Kommentar2: String[255];     // not used
    SampelRate: Single;
    Filter:Integer;
    Jewett:TJewett;           // not used
    Amp_Tone  :Integer;      // I dB SPL   -100 means no tone
    Freq_Tone :Integer;      // Frequency of the tone 0 means click only
    Amp_Klik  :Integer;      // I dB SPL
    Freq_Klik :Integer;      // not used
    Nr: Integer;                // Hvor langt optagelsen er nået hvis den bliver afbrudt.
    Tag:integer;
    Meas: TMeas2;
    Resume: TSubMeas2;       // Gennemsnittet af alle målinger inc filter, Mest for display purposes
  End;

type
  TABR_Data = Array[0..3] of TSoundFile;     //0:UM-A   1:UM-B   2:M-A   3:M-B

type TABR_Info = Record
  Numbers_of_Awarages: Array[0..3] of integer;
  Max_avarages: integer;
  InitFileName:String[255];
  Kommentar: String[255];
  Kommentar2: String[255];     // not used
  Program_version: String[255];     // not used
  SampelRate: Single;
  ABR_SampleRate: Single;
  Filter:Integer;
  JewettP:TJewett;          // sample for positive peaks: -1 for no mark
  JewettN:TJewett;          // sample for negative peaks: -1 for no mark
  JewettPAmp:TJewettAmp;          // sample for positive peaks: -1 for no mark
  JewettNAmp:TJewettAmp;          // sample for negative peaks: -1 for no mark
  Amp_Tone  :Integer;      // I dB SPL   -100 betyder ingen tone
  Freq_Tone :Integer;      // Frequency of the tone 0 means click only
  Amp_Klik  :Integer;      // I dB SPL
  Freq_Klik :Integer;      // not used
  Name_Klik :String[255];
  Max_Turns:integer;
  Turn_Nr: Integer;                // Hvor langt optagelsen er nået hvis den bliver afbrudt.
  Tag:integer;
  Peak_reject: single;
  Stim_file_name:string;
  Stim_file_length:integer;
  Kalib_File_name:string;
  NumberOf_Samples:Integer;     // The number of samples in the recording
  Directional_ABR:boolean;
  Invert_Click: boolean;         // invert click if true
  Masked : boolean;
  kanal_ind : integer;
  kanal_ud : integer;
  InstantAmp : integer;   // The instantanious amplitude are only used for short intervals
  Significans: string;    // Significans Level { , * , ** , ***}
End;

             {
type TGraphSettings = Record
  ShowBuffers  :Boolean;
  Show_inverted:Boolean;
  Offset       :Single;
  FromSample   :Integer;
  ToSample     :Integer;
  Filter_freq  :Integer;
  CurveDistance:Single;
end;
            }

Procedure InitABRData(var ABR_Data:TABR_Data);
Procedure InitABRInfo(var ABR_Info:TABR_Info);
Procedure InitMeas(var MeasFile:TMeasFile);
function GetCorrDiff(var ABR_Data:TABR_Data; from,till:integer):single;
function GetCorrDiff_Filtered(var ABR_Data:TABR_Data; from,till:integer; filterFreq:integer):single;

//Legacy functions
Function AvrMeas(kind:integer; number:integer; var MyMeas:TMeasFile):TSubMeas;
function MeasToData(Meas:TMeasFile):TABR_Data;
function MeasToInfo(Meas:TMeasFile):TABR_Info;
Function FindMedian(var MList: TMeadianList):single;

 
Const
 Glob_Median: Boolean = false;
 nVolt: single=100;  // scale values to 10^-6 Volt
 Glob_Program_version: String = 'Quick ABR v.10.0.1.0';

implementation




Procedure Swap(var A,B:single);
var
  Temp:Single;
Begin
  Temp:=A;
  A:=B;
  B:=Temp;
End;



{***   Heap sort   ***}
Procedure sort( var MList: TMeadianList);
var
 Done: Boolean;
 jump,I,J,N:integer;
begin
  N:= Length(MList)-1;
  Jump:= N;
  while Jump>0 do
     Begin
       Jump:= Jump div 2;
       Repeat
         Done:=true;
         For J:=0 to N - Jump do
           Begin
             I:=J+Jump;
             If MList[J]>MList[I] Then
               Begin
                 Swap(MList[J],MList[I]);
                 Done:=False;
               End {IF}
           End; {For}
       Until Done;
  End {while}
end;



Procedure InitABRData(var ABR_Data:TABR_Data);
Begin
  SetLength(ABR_Data[0],0);
  SetLength(ABR_Data[1],0);
  SetLength(ABR_Data[2],0);
  SetLength(ABR_Data[3],0);
End;


Procedure InitABRInfo(var ABR_Info:TABR_Info);
var
  i:integer;
Begin
  for i:=0 to 3 do ABR_Info.Numbers_of_Awarages[i]:=-1;
  ABR_Info.Max_avarages:=-1;
  ABR_Info.Kommentar:='';
  ABR_Info.Kommentar2:='';
  ABR_Info.Program_version:= Glob_Program_version;
  ABR_Info.SampelRate:=-1;
  ABR_Info.ABR_SampleRate := 24414;
  ABR_Info.Filter:=-1;
  for i:=1 to 9 do ABR_Info.JewettN[i]:=-1;
  for i:=1 to 9 do ABR_Info.JewettP[i]:=-1;
  for i:=1 to 9 do ABR_Info.JewettNAmp[i]:=-1000;
  for i:=1 to 9 do ABR_Info.JewettPAmp[i]:=-1000;
  ABR_Info.Amp_Tone:=-1;
  ABR_Info.Freq_Tone:=-1;
  ABR_Info.Amp_Klik:=-1;
  ABR_Info.Freq_Klik:=-1;
  ABR_Info.Name_Klik:='';
  ABR_Info.Max_Turns:=-1;
  ABR_Info.Turn_Nr:=0;
  ABR_Info.Tag:=-1;
  ABR_Info.Peak_reject:=-1;
  ABR_Info.Stim_file_name:='';
  ABR_Info.Stim_file_length:= 1024;
  ABR_Info.Kalib_File_name:='';
  ABR_Info.NumberOf_Samples:=-1;
  ABR_Info.Directional_ABR:=False;
  ABR_Info.Invert_Click:=True;
  ABR_Info.Masked:= True;
  ABR_Info.kanal_ind:=-1;
  ABR_Info.kanal_ud:=-1;
  ABR_Info.InstantAmp:=0;
  ABR_Info.Significans:= '';
  
End;

{**  Initialize MeasFile  **}
Procedure InitMeas(var MeasFile:TMeasFile);
var
  i:integer;
Begin
  with Measfile do Begin
    Kommentar := '';
    Kommentar2:= '';
    SampelRate:= 24414; //48828;
    Filter    := 0;
    Amp_Tone  :=0;
    Freq_Tone :=0;
    Amp_Klik  :=0;
    Freq_Klik :=0;
    Nr:=0;
    Tag:=0;
    For i:= 1 to 9 do Jewett[i]:=0;
    For i:= 0 to Length(resume)-1 do Resume[i]:=0;
    For i:= 0 to Length(Meas)-1 do Meas[i]:=Resume;
  end;
end;



{JCD New}
procedure IntegrateDiff(Signal1,signal2: TSoundFile; till,From:integer; var result: single);
  var i:integer;
  begin
  result:=0;
  for i:= 0 to length(signal1)-1 do
  if (i>From) and (i<till) then
    result:=result+sqr(signal1[i]-signal2[i]);
end;




Procedure Xcorrelation(Signal1,signal2: TSubMeas; fra,til:integer; var result: TSubMeas);
var
  tau,t,index,i: integer;
  sum:single;
begin
  For i:=0 to Length(result)-1 do result[i]:=0;
  if (til=0) or (til > (Length(signal1)-1)) then til:= Length(signal1)-1;
  if fra > (Length(signal1)-2) then fra := (Length(signal1)-2);

  For i:=0 to fra do begin signal1[i]:=0; signal2[i]:=0; end;
  For i:=til to Length(signal1)-1 do begin signal1[i]:=0; signal2[i]:=0; end;
  fra:=0; til:= Length(signal1)-1;

  for tau:=fra to til do
  begin
     sum:=0;
     for t:= fra to til do
     begin
        index:=t+tau-(Length(signal1)) div 2;
        if (index>0) and (index< Length(signal1)) then
        sum:=sum+(signal1[t])*(signal2[index]);
     end;
     result[tau]:=sum;
  end;
end;






              //  AvrMeas   MedianMeas
Function AvrageMeas(kind:integer; number:integer; var MyMeas:TMeasFile):TSubMeas;
var
 i,j,L:integer;
 TempMeas: TSubMeas;
 NrS,Count_max : integer;     // number of sampels in each buffer
 test:single;
 break:boolean;
Begin
 L:= length(TempMeas);
 i:=0; Break:=false;
 if L>1500 then
   Repeat               //test to see if there is data in the last part of the signal
    test:= MyMeas.Meas[5,i+1100];
    if test>0.0000001 then break:=true;
    if test<-0.0000001 then break:=true;
   inc(i);
   until (i>100) or break;


 if break then NrS := round((L-1)/2) else NrS := round((L-1)/4); // If there is no data we assume it is the old data file and ignore the rest
 For i:=0 to L do TempMeas[i]:=0;
 if number = 0 then  number:= MyMeas.Nr-1;
 if number > MyMeas.Nr-1 then  Count_max:= MyMeas.Nr-1  else Count_max:=number;
 If Count_max < 0 then Showmessage('AvrMeas Error: '+inttostr(Count_max));
{*Uden Tone*}
  If kind=1 then begin      // A- Buffer uden Tone
    for j:=0 to Count_max do begin
     If not(odd(j)) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] +
                nVolt*MyMeas.Meas[j,i]/(Count_max);
    End;
  End;

  If kind=2 then begin      // B- Buffer uden Tone
    for j:=0 to Count_max do begin
     If not(odd(j)) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] +
                                            (nVolt*MyMeas.Meas[j,i+NrS]/(Count_max));
    End;
  End;

  If kind=3 then begin      // Sum uden Tone
    for j:=0 to Count_max do begin
     If not(odd(j)) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] +
                    nVolt*(MyMeas.Meas[j,i] + MyMeas.Meas[j,i+NrS])/(2*(Count_max));
    End;
  End;
{*/Uden Tone*}

{*Med Tone*}
  If kind=4 then begin      // A- Buffer Tone
    for j:=0 to Count_max do begin
     If odd(j) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] +
                                        (nVolt*MyMeas.Meas[j,i]/(Count_max));
    End;
  End;

  If kind=5 then begin      // B- Buffer Tone
    for j:=0 to Count_max do begin
     If odd(j) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] +
                nVolt*(MyMeas.Meas[j,i+NrS]/(Count_max));
    End;
  End;

  If kind=6 then begin      // Sum Med Tone
    for j:=0 to Count_max do begin
     If odd(j) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] +
                nVolt*(MyMeas.Meas[j,i] + MyMeas.Meas[j,i+NrS])/(2*(Count_max));
    End;
  End;
{*/Med Tone*}

  If kind=7 then begin      // A- Buffer Difference
    for j:=0 to Count_max do begin
     If not(odd(j)) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] +
                                               nVolt*(MyMeas.Meas[j,i]/(Count_max));       //A  Uden Tone
     If     odd(j)  then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] -
                                                nVolt*(MyMeas.Meas[j,i]/(Count_max));       //A  Med Tone
    End;
  End;

  If kind=8 then begin      // B- Buffer Difference
    for j:=0 to Count_max do begin
     If not(odd(j)) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] +
                                           nVolt*(MyMeas.Meas[j,i+NrS]/(Count_max));  //B  Uden Tone
     If     odd(j)  then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] -
                                             nVolt*(MyMeas.Meas[j,i+NrS]/(Count_max));  //B  Med Tone
    End;
  End;

  If kind=9 then begin      // Total Difference
    if mymeas.Freq_Tone = 0 then
     for j:=0 to Count_max do begin
       If not(odd(j)) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] + nVolt*(MyMeas.Meas[j,i] + MyMeas.Meas[j,i+NrS])/(2*(Count_max));
       If     odd(j)  then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] + nVolt*(MyMeas.Meas[j,i] + MyMeas.Meas[j,i+NrS])/(2*(Count_max));
     end
    else
     for j:=0 to Count_max do begin
       If not(odd(j)) then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] + nVolt*(MyMeas.Meas[j,i] + MyMeas.Meas[j,i+NrS])/(2*(Count_max));
       If     odd(j)  then for i:=0 to NrS do TempMeas[i]:= TempMeas[i] - nVolt*(MyMeas.Meas[j,i] + MyMeas.Meas[j,i+NrS])/(2*(Count_max));
     End;
  End;


  If kind=10 then begin      // lungfish     A   unmasked
     for j:=0 to Count_max do begin
       If ( (not(odd(j))) And (odd(j div 2)) ) then for i:=0 to L do TempMeas[i]:= TempMeas[i] + nVolt*(MyMeas.Meas[j,i] / Count_max);
     end
  End;


  If kind=11 then begin      // lungfish     B   Unmasked
     for j:=0 to Count_max do begin
       If ( (not(odd(j))) And (not(odd(j div 2))) ) then for i:=0 to L do TempMeas[i]:= TempMeas[i] + nVolt*(MyMeas.Meas[j,i] / Count_max);
     end
  End;

  If kind=12 then begin      // lungfish     A   masked
     for j:=0 to Count_max do begin
       If ( ((odd(j))) And (odd(j div 2)) ) then for i:=0 to L do TempMeas[i]:= TempMeas[i] + nVolt*(MyMeas.Meas[j,i] / Count_max);
     end
  End;


  If kind=13 then begin      // lungfish     B   masked
     for j:=0 to Count_max do begin
       If ( ((odd(j))) And (not(odd(j div 2))) ) then for i:=0 to L do TempMeas[i]:= TempMeas[i] + nVolt*(MyMeas.Meas[j,i] / Count_max);
     end
  End;

 Result:=TempMeas;   
End;





Function FindMedian(var MList: TMeadianList):single;  //has to start on 0
Var
 L: integer;
Begin
 Result:=-1;
 Sort(MList);
 L := Length(MList);
 If (L>0) then
 If odd(L) then Result := MList[round((L-1)/2)] else
                Result := ( MList[round(L/2)-1] + MList[round(L/2)] ) /2 ;  // -1 because the array start on 0
End;




                    // AvrMeas  MedianMeas
Function MedianMeas(kind:integer; number:integer; var MyMeas:TMeasFile):TSubMeas;
var
 i,j,k:integer;
 TempMeas,TempMeas2: TSubMeas;
 NrS,Count_max : integer;     // number of sampels in each buffer
 MList:TMeadianList;
Begin
 NrS := round((length(TempMeas)-1)/2);
 For i:=0 to length(TempMeas)-1 do TempMeas[i]:=0;
 if number = 0 then  number:= MyMeas.Nr-1;
 if number > MyMeas.Nr-1 then  Count_max:= MyMeas.Nr-1  else Count_max:=number;
 If Count_max < 0 then Showmessage('AvrMeas Error: '+inttostr(Count_max));
 SetLength(MList,0);

{*Uden Tone*}
  If kind=1 then begin      // A- Buffer uden Tone
     for i:=1 to NrS do Begin
     k:=0;
       for j:=0 to Count_max do begin
        If not(odd(j)) then
           Begin
            inc(k);
            SetLength(MList,k+1);
            MList[k]:=  nVolt*MyMeas.Meas[j,i];
           End;
        End;
       TempMeas[i]:= FindMedian(MList);
     End;
  End;

  If kind=2 then begin      // A- Buffer uden Tone
     for i:=1 to NrS do Begin
     k:=0;
       for j:=0 to Count_max do begin
        If not(odd(j)) then
           Begin
            inc(k);
            SetLength(MList,k+1);
            MList[k]:=  nVolt*MyMeas.Meas[j,i+NrS];
           End;
        End;
       TempMeas[i]:= FindMedian(MList);
     End;
  End;

  If kind=3 then begin      // Sum uden Tone
    TempMeas := MedianMeas(1, number,MyMeas);
    TempMeas2 := MedianMeas(2, number,MyMeas);
    for i:=1 to NrS do TempMeas[i] := (TempMeas[i] + TempMeas2[i]) / 2;
  End;
{*/Uden Tone*}

{*Med Tone*}
  If kind=4 then begin      // A- Buffer Tone
     for i:=1 to NrS do Begin
     k:=0;
       for j:=0 to Count_max do begin
        If (odd(j)) then
           Begin
            inc(k);
            SetLength(MList,k+1);
            MList[k]:=  nVolt*MyMeas.Meas[j,i];
           End;
       End;
       TempMeas[i]:= FindMedian(MList);
     End;
  End;

  If kind=5 then begin      // B- Buffer Tone
     for i:=1 to NrS do Begin
     k:=0;
       for j:=0 to Count_max do begin
        If (odd(j)) then
           Begin
            inc(k);
            SetLength(MList,k+1);
            MList[k]:=  nVolt*MyMeas.Meas[j,i+NrS];
           End;
       End;
       TempMeas[i]:= FindMedian(MList);
     End;
  End;

  If kind=6 then begin      // Sum med Tone
    TempMeas := MedianMeas(1, number,MyMeas);
    TempMeas2 := MedianMeas(4, number,MyMeas);
    for i:=1 to NrS do TempMeas[i] := (TempMeas[i] + TempMeas2[i]) / 2;
  End;
{*/Med Tone*}

  If kind=7 then begin      // A- Buffer Difference
    TempMeas := MedianMeas(1, number,MyMeas);     //A  Uden Tone
    TempMeas2 := MedianMeas(4, number,MyMeas);    //A  Med Tone
    for i:=1 to NrS do TempMeas[i] := (TempMeas[i] - TempMeas2[i]);
  End;

  If kind=8 then begin      // B- Buffer Difference
    TempMeas := MedianMeas(2, number,MyMeas);     //B  Uden Tone
    TempMeas2 := MedianMeas(5, number,MyMeas);    //B  Med Tone
    for i:=1 to NrS do TempMeas[i] := (TempMeas[i] - TempMeas2[i]);
  End;

  If kind=9 then begin      // Total Difference
    TempMeas := MedianMeas(7, number,MyMeas);
    TempMeas2 := MedianMeas(8, number,MyMeas);
    for i:=1 to NrS do TempMeas[i] := (TempMeas[i] + TempMeas2[i]) / 2;
  End;
 Result:=TempMeas;
End;



Function AvrMeas(kind:integer; number:integer; var MyMeas:TMeasFile):TSubMeas;
Begin
  If Glob_Median then  Result := MedianMeas(kind, number,MyMeas)
  else Result := AvrageMeas(kind, number,MyMeas);
end;



function MeasToData(Meas:TMeasFile):TABR_Data;
var
 i,L:integer;
 MaskedA,MaskedB,UnMaskedA,UnMaskedB:TSubMeas;
 lungfish:boolean;
Begin

lungfish:=False;

 if lungfish then
 begin
   UnMaskedA:= AvrMeas(10, 0,Meas);
   UnMaskedB:= AvrMeas(11, 0,Meas);
   MaskedA:= AvrMeas(12, 0,Meas);
   MaskedB:= AvrMeas(13, 0,Meas);
 end
  else
 Begin
   UnMaskedA:= AvrMeas(1, 0,Meas);
   UnMaskedB:= AvrMeas(2, 0,Meas);
   MaskedA:= AvrMeas(4, 0,Meas);
   MaskedB:= AvrMeas(5, 0,Meas);
 end;

 L:=Length(UnMaskedA);
 SetLength(Result[0],L);
 for i:=0 to L-1 do Result[0,i]:=UnMaskedA[i];

 L:=Length(UnMaskedB);
 SetLength(Result[1],L);
 for i:=0 to L-1 do Result[1,i]:=UnMaskedB[i];

 L:=Length(MaskedA);
 SetLength(Result[2],L);
 for i:=0 to L-1 do Result[2,i]:=MaskedA[i];

 L:=Length(MaskedB);
 SetLength(Result[3],L);
 for i:=0 to L-1 do Result[3,i]:=MaskedB[i];

 { for k:=0 to 3 do
  Begin
     i:=0; Break:=False;
     if (Length(Result[k]))>1500 then
     Repeat               //test to see if there is data in the last part of the signal
      if Result[k,i+1100]>0.0000001 then break:=true;
      if Result[k,i+1100]<-0.0000001 then break:=true;
     inc(i);
     until (i>100) or break;
     if not(break) then setlength(Result[k],1000);
  end;}
end;



function MeasToInfo(Meas:TMeasFile):TABR_Info;
var
  i:integer;
Begin
 for i:=0 to 3 do
    Result.Numbers_of_Awarages[i] :=  1;//Meas.Tag;  I already did the avaraging so I have to set it to 1
  Result.Max_avarages := -1;
  Result.Kommentar    := Meas.Kommentar;
  Result.Kommentar2   := Meas.Kommentar2;
  Result.SampelRate   := Meas.SampelRate;
  Result.Filter       := Meas.Filter;
 for i:=1 to 9 do Result.JewettP[i] := Meas.jewett[i];
 for i:=1 to 9 do Result.JewettN[i] := -1;
  Result.Amp_Tone    := Meas.Amp_Tone;
  Result.Freq_Tone   := Meas.Freq_Tone;
  Result.Amp_Klik    := Meas.Amp_Klik;
  Result.Freq_Klik   := Meas.Freq_Klik;
  Result.Name_Klik   := '';//Meas.Name_Klik;
  Result.Turn_Nr     := Meas.Nr;
  Result.Tag         := Meas.Tag;
  Result.Peak_reject      := -1;
  Result.Stim_file_name   := '';//Meas.Name_Klik;
  Result.NumberOf_Samples := Length(Meas.Resume);
  Result.Directional_ABR  := FALSE;
  Result.Invert_Click  := TRUE;
  Result.kanal_ind     := -1;
  Result.kanal_ud      := -1;
  if Meas.Freq_Tone=0 then Result.Masked:=False else Result.Masked:=True;
end;


function GetCorrDiff(var ABR_Data:TABR_Data; from,till:integer):single;
var
 UnMaskedSignal,MaskedSignal,dummy: TSoundFile;
 AutoCorrMax,XcorrMax:single;
begin
    UnMaskedSignal:=  WavAvr(ABR_Data[0],ABR_Data[1]);
    MaskedSignal  :=  WavAvr(ABR_Data[2],ABR_Data[3]);

    SetLength(dummy,Length(UnMaskedSignal));

    IntegrateDiff(UnMaskedSignal,dummy,till,From, AutocorrMax);
    if length(MaskedSignal)= Length(UnmaskedSignal)
      then IntegrateDiff(MaskedSignal,UnmaskedSignal,till,From, XcorrMax)
      else XcorrMax:=-1;
    
    if autocorrmax<>0 then result:=xcorrmax/autocorrmax else result:=0;
    If XcorrMax=-1 then Result:=0;
end;



function GetCorrDiff_Filtered(var ABR_Data:TABR_Data; from,till:integer; filterFreq:integer):single;
var
 UnMaskedSignal,MaskedSignal,dummy: TSoundFile;
 AutoCorrMax,XcorrMax:single;
begin
    UnMaskedSignal:=  FilterLP( WavAvr(ABR_Data[0],ABR_Data[1]), GetFilterCoff(filterFreq));
    MaskedSignal  :=  FilterLP( WavAvr(ABR_Data[2],ABR_Data[3]), GetFilterCoff(filterFreq));

    SetLength(dummy,Length(UnMaskedSignal));

    if length(MaskedSignal)= Length(UnmaskedSignal)
      then IntegrateDiff(MaskedSignal,UnmaskedSignal,till,From, XcorrMax)
      else XcorrMax:=-1;

      IntegrateDiff(UnMaskedSignal,dummy,till,From, AutocorrMax);
      if autocorrmax<>0 then result:=xcorrmax/autocorrmax else result:=0;
      If XcorrMax=-1 then Result:=0;
end;



end.

