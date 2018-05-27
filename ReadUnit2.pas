unit ReadUnit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, TeEngine, Series, ExtCtrls, TeeProcs, Chart, commonUnit, FilterUnit,
  StdCtrls, ReadUnit, INIfiles,FileCtrl,Wav_handler, ReadSettings; //

type
  TReadForm2 = class(TForm)
    Chart1: TChart;
    Series1: TLineSeries;
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
    Series12: TLineSeries;
    Series13: TLineSeries;
    Series14: TLineSeries;
    Series15: TLineSeries;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    LPFilter1: TMenuItem;
    Load1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Edit1: TEdit;
    None1: TMenuItem;
    N40001: TMenuItem;
    N35001: TMenuItem;
    N30001: TMenuItem;
    N25001: TMenuItem;
    N20001: TMenuItem;
    SaveImage1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Setup1: TMenuItem;
    Replay1: TMenuItem;
    Timer1: TTimer;
    Scale1: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    Auto1: TMenuItem;
    N51: TMenuItem;
    Function PlotCurve(MyChart:Tchart; ABR_Data:TABR_Data; ABR_Info:TABR_Info; Sett:TGraphSettings):Boolean;
    Function PlotSubCurve(MyChart:Tchart; ABR_Data:TABR_Data; ABR_Info:TABR_Info; Sett:TGraphSettings; Masked:Boolean):Boolean;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SettingsSet(Sett:TGraphSettings);     { Sets the global settings }
    procedure Load1Click(Sender: TObject);
    procedure LoadFile(FileName: string);
    //Procedure ShowMyData2(var R_TDTDataA: array of TFilterData);
    Procedure ShowMyData3(Raw_ABR_Data:TABR_Data;Raw_ABR_Info:TABR_Info);
    procedure None1Click(Sender: TObject);
    procedure SaveImage1Click(Sender: TObject);
    procedure Setup1Click(Sender: TObject);
    //procedure Replay();
    procedure Timer1Timer(Sender: TObject);
    procedure Replay1Click(Sender: TObject);
    procedure N11Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReadForm2: TReadForm2;


implementation



var
  Read2Settings : TGraphSettings;
  Glob_Showform_ABR_Data :TABR_Data;
  Glob_Showform_ABR_Info :TABR_Info;

{$R *.DFM}




  {** Load Settings **}
procedure GetSettings();
var
  MyINI: TINIFile;
  Path: String;
Begin
 Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 MyINI := TINIFile.create(path+'settings.ini');
  Read2Settings.ShowBuffers   := MyINI.ReadBool('RU2_Setup','ABR_Show_AB',True);
  Read2Settings.Show_inverted := MyINI.ReadBool('RU2_Setup','ABR_Show_inv',false);
  Read2Settings.Offset        := 0;
  Read2Settings.FromSample    := MyINI.ReadInteger('RU2_Setup','MinS',0);
  Read2Settings.ToSample      := MyINI.ReadInteger('RU2_Setup','MaxS',400);
  Read2Settings.Filter_freq   := MyINI.ReadInteger('RU2_Setup','FilterFreq',-1);
  Read2Settings.PPFromSample  := MyINI.ReadInteger('RU2_Setup','PPminS',0);
  Read2Settings.PPToSample    := MyINI.ReadInteger('RU2_Setup','PPmaxS',400);
  Read2Settings.CurveDistance := MyINI.ReadFloat  ('RU2_Setup','Dist',1);
  Read2Settings.SampleRate    := MyINI.ReadFloat  ('RU2_Setup','SampleRate',24414);
  Read2Settings.TotalSamples  := MyINI.ReadInteger('RU2_Setup','TotalSamples',400);
  Read2Settings.Show_Jewet    := MyINI.ReadBool   ('RU2_Setup','Show_Jewet',false);
 MyINI.free;
//Showmessage(intToStr(Read2Settings.PPToSample));
end;



  {** Save Settings **}
procedure SaveSettings();
var
  MyINI: TINIFile;
  Path: String;
Begin
 Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 MyINI := TINIFile.create(path+'settings.ini');
     MyINI.WriteBool(   'RU2_Setup','ABR_Show_AB' ,  Read2Settings.ShowBuffers  );
     MyINI.WriteBool(   'RU2_Setup','ABR_Show_inv',  Read2Settings.Show_inverted);
     MyINI.WriteInteger('RU2_Setup','MinS',          Read2Settings.FromSample   );
     MyINI.WriteInteger('RU2_Setup','MaxS',          Read2Settings.ToSample     );
     MyINI.WriteInteger('RU2_Setup','FilterFreq',    Read2Settings.Filter_freq  );
     MyINI.WriteInteger('RU2_Setup','PPminS',        Read2Settings.PPFromSample );
     MyINI.WriteInteger('RU2_Setup','PPmaxS',        Read2Settings.PPToSample   );
     MyINI.WriteFloat(  'RU2_Setup','Dist',          Read2Settings.CurveDistance);
     MyINI.WriteFloat(  'RU2_Setup','SampleRate',    Read2Settings.SampleRate   );
     MyINI.WriteInteger('RU2_Setup','TotalSamples',  Read2Settings.TotalSamples );
     MyINI.WriteBool(   'RU2_Setup','Show_Jewet',    Read2Settings.Show_Jewet   );
 MyINI.free;
end;




procedure TReadForm2.FormCreate(Sender: TObject);
begin
  //ScaleY:=24.414;
  N40001.Checked:=true;
  //My_LP_Filter_freq:= 4000;
  Read2Settings.Filter_freq:= 4000;
  GetSettings();
end;



procedure TReadForm2.FormDestroy(Sender: TObject);
begin
  SaveSettings();
end;



 { Sets the global settings }
procedure TReadForm2.SettingsSet(Sett:TGraphSettings);
Begin
 Read2Settings:=Sett;
 ShowMyData3(Glob_Showform_ABR_Data,Glob_Showform_ABR_Info);
end;


 { Load a single file }
procedure TReadForm2.Load1Click(Sender: TObject);
begin
  If opendialog1.Execute then LoadFile(opendialog1.FileName); //showmessage(opendialog1.FileName);
end;



 { Open a single file }
procedure TReadForm2.LoadFile(FileName: string);
var
 S: String;
 i:integer;
 FileOpen:Boolean;
begin
    FileOpen:=False;
    ReadForm2.Caption:= Filename;
    Chart1.Title.Text.Clear;
    for i:=0 to Chart1.SeriesCount-1 do Chart1.Series[i].ShowInLegend:=false;
    Chart1.Title.Text.Add( Filename );
    S:= FileName;
    S:=AnsiLowerCase(Copy(S,pos('.',S)+1,3));

 if s='ab3' then
 begin
   ReadForm.readMF2(FileName, Glob_Showform_ABR_Data, Glob_Showform_ABR_Info);
   Read2Settings.SampleRate:= Glob_Showform_ABR_Info.SampelRate;
   Read2Settings.TotalSamples:= Glob_Showform_ABR_Info.NumberOf_Samples;
   ShowMyData3(Glob_Showform_ABR_Data,Glob_Showform_ABR_Info);
   FileOpen:=True;
   //ShowMessage('Convert the AB3 files to CSV before opening');
 end;

 if s='csv' then
 begin
   ReadForm.LoadMatFileformat(Glob_Showform_ABR_Data,Glob_Showform_ABR_Info,FileName);
   Read2Settings.SampleRate:= Glob_Showform_ABR_Info.SampelRate;
   Read2Settings.TotalSamples:= Glob_Showform_ABR_Info.NumberOf_Samples;
   ShowMyData3(Glob_Showform_ABR_Data,Glob_Showform_ABR_Info);
   FileOpen:=True;

 end;

 If not(FileOpen) then Showmessage('unknown file extention');

End;






 {** **}
Function TReadForm2.PlotCurve(MyChart:Tchart; ABR_Data:TABR_Data; ABR_Info:TABR_Info; Sett: TGraphSettings):Boolean;
var
 i,L,invt:integer;
 Min,Max:integer;
 MySeries: TLineSeries ;
 ScaleY:double;
 ShowBuffers:boolean;
 SeriesTitle:string;
 SeriesColor,BufferColor:TColor ;
 Linewith:integer;
Begin
  Linewith:=1;
  ShowBuffers:=Sett.ShowBuffers;
  ScaleY:=ABR_Info.SampelRate/1000;
  L:=length(ABR_Data[0]);
  if Sett.Show_inverted then invt:=-1 else Invt:=1;

  Min:= Sett.FromSample;
  Max:= Sett.ToSample;
  If Max>(L-1) then Max:= (L-1);
  If Min>(Max-1) then Min:=0;

  SeriesColor:=ReadForm.IntToColor( MyChart.SeriesCount+1);
  BufferColor:= ReadForm.Brighten(SeriesColor,25);

  if Sett.Filter_freq>0 then
    Begin
      for i:=0 to Length(ABR_Data)-1 do
        ABR_Data[i] := FilterLP(ABR_Data[i],GetFilterCoff(Sett.Filter_freq));
    end;

  if ABR_Info.Masked then
  Begin
        SeriesTitle:= IntToStr(ABR_Info.Amp_Tone)+'dB '+ABR_Info.Significans ;

        if Sett.ShowBuffers then
        Begin    //Masked with buffers
            MySeries := TLineSeries.Create( Self );   //Buffer 1
            MySeries.ParentChart := MyChart ;
            MySeries.SeriesColor:= BufferColor;
            MySeries.ShowInLegend:=False;
            MySeries.LinePen.Width:=Linewith;
            MySeries.Identifier:= Sett.ID;
            MySeries.ClickableLine:=False;
            for i:=Min to Max do MySeries.AddXY(i/ScaleY,invt*(ABR_Data[0,i]-ABR_Data[2,i])/ABR_Info.Numbers_of_Awarages[0]+Sett.Offset*Sett.CurveDistance);

            MySeries := TLineSeries.Create( Self );   //Buffer 2
            MySeries.ParentChart := MyChart ;
            MySeries.SeriesColor:=BufferColor;
            MySeries.ShowInLegend:=False;
            MySeries.LinePen.Width:=Linewith;
            MySeries.Identifier:= Sett.ID;
            MySeries.ClickableLine:=False;
            for i:=Min to Max do MySeries.AddXY(i/ScaleY,invt*(ABR_Data[1,i]-ABR_Data[3,i])/ABR_Info.Numbers_of_Awarages[1]+Sett.Offset*Sett.CurveDistance);

            MySeries := TLineSeries.Create( Self );
            MySeries.ParentChart := MyChart ;
            MySeries.Title:= SeriesTitle;
            MySeries.SeriesColor:= SeriesColor;
            MySeries.ShowInLegend:=True;
            MySeries.LinePen.Width:=Linewith;
            MySeries.Identifier:= Sett.ID;
            for i:=Min to Max do MySeries.AddXY(i/ScaleY,0.5*invt* ((ABR_Data[0,i]-ABR_Data[2,i]) + (ABR_Data[1,i]-ABR_Data[3,i]))/ABR_Info.Numbers_of_Awarages[0]+Sett.Offset*Sett.CurveDistance);
       end
        else
        begin  // Masked without buffers
            MySeries := TLineSeries.Create( Self );
            MySeries.ParentChart := MyChart ;
            MySeries.Title:= SeriesTitle;
            MySeries.SeriesColor:= SeriesColor;
            MySeries.ShowInLegend:=True;
            MySeries.LinePen.Width:=Linewith;
            MySeries.Identifier:= Sett.ID;
            for i:=Min to Max do MySeries.AddXY(i/ScaleY,0.5*invt* ((ABR_Data[0,i]-ABR_Data[2,i]) + (ABR_Data[1,i]-ABR_Data[3,i]))/ABR_Info.Numbers_of_Awarages[0]+Sett.Offset*Sett.CurveDistance);
        end;
  Result:=True;
  end
  else
  Begin
        SeriesTitle:= IntToStr(ABR_Info.Amp_Klik)+'dB';
        if ShowBuffers then
        Begin

            MySeries := TLineSeries.Create( Self );   //Buffer 1
            MySeries.ParentChart := MyChart ;
            MySeries.SeriesColor:=BufferColor;
            MySeries.ShowInLegend:=False;
            MySeries.LinePen.Width:=Linewith;
            MySeries.Identifier:= Sett.ID;
            MySeries.ClickableLine:=False;
            for i:=Min to Max do MySeries.AddXY(i/ScaleY,(((ABR_Data[0,i])/(invt))/ABR_Info.Numbers_of_Awarages[0])+ Sett.Offset*Sett.CurveDistance);

            MySeries := TLineSeries.Create( Self );   //Buffer 2
            MySeries.ParentChart := MyChart ;
            MySeries.SeriesColor:=BufferColor;
            MySeries.ShowInLegend:=False;
            MySeries.LinePen.Width:=Linewith;
            MySeries.Identifier:= Sett.ID;
            MySeries.ClickableLine:=False;
            for i:=Min to Max do MySeries.AddXY(i/ScaleY,(((ABR_Data[1,i])/(invt))/ABR_Info.Numbers_of_Awarages[0])+ Sett.Offset*Sett.CurveDistance);

            MySeries := TLineSeries.Create( Self );
            MySeries.ParentChart := MyChart ;
            MySeries.Title:= SeriesTitle;
            MySeries.SeriesColor:= SeriesColor;
            MySeries.ShowInLegend:=True;
            MySeries.LinePen.Width:=Linewith;
            MySeries.Identifier:= Sett.ID;
            for i:=Min to Max do MySeries.AddXY(i/ScaleY,(((ABR_Data[0,i]+ABR_Data[1,i])/(2*invt))/ABR_Info.Numbers_of_Awarages[0])+ Sett.Offset*Sett.CurveDistance);
        end
        else
        Begin
            MySeries := TLineSeries.Create( Self );
            MySeries.ParentChart := MyChart ;
            MySeries.Title:= SeriesTitle;
            MySeries.SeriesColor:= SeriesColor;
            MySeries.ShowInLegend:=True;
            MySeries.LinePen.Width:=Linewith;
            MySeries.Identifier:= Sett.ID;
            for i:=Min to Max do MySeries.AddXY(i/ScaleY,(((ABR_Data[0,i]+ABR_Data[1,i])/(2*invt))/ABR_Info.Numbers_of_Awarages[0])+ Sett.Offset*Sett.CurveDistance);
        end;
  Result:=True;
  End;

  if sett.Show_Jewet then
  Begin
    for i:=1 to 9 do
    Begin
    if ABR_Info.JewettP[i]>0 then MyChart.SeriesList[0].AddXY
                                        (
                                        MySeries.XValue[ABR_Info.JewettP[i]],
                                        MySeries.YValue[ABR_Info.JewettP[i]],
                                        intToStr(i)
                                        );
    if ABR_Info.JewettN[i]>0 then MyChart.SeriesList[1].AddXY
                                        (
                                        MySeries.XValue[ABR_Info.JewettN[i]],
                                        MySeries.YValue[ABR_Info.JewettN[i]],
                                        intToStr(i)
                                        );
    end;
  end;
end;


 {** Plot the masked or unmasked subcurve of a masked ABR **}
Function TReadForm2.PlotSubCurve(MyChart:Tchart; ABR_Data:TABR_Data; ABR_Info:TABR_Info; Sett:TGraphSettings; Masked:Boolean):Boolean;
var
 New_ABR_Data:TABR_Data;
Begin
ABR_Info.Masked:=False;

Sett.Show_Jewet := False;
if Masked then
  Begin
    New_ABR_Data[0]:= ABR_Data[2];
    New_ABR_Data[1]:= ABR_Data[3];
    New_ABR_Data[2]:= ABR_Data[0];
    New_ABR_Data[3]:= ABR_Data[1];
  End
  Else New_ABR_Data:= ABR_Data;

Result:= PlotCurve(MyChart, New_ABR_Data, ABR_Info, Sett);
end;



Procedure TReadForm2.ShowMyData3(Raw_ABR_Data:TABR_Data;Raw_ABR_Info:TABR_Info);
Begin
 Chart1.FreeAllSeries;
 ReadForm.InitJewetMarks(Chart1);

if Raw_ABR_Info.Masked then
 begin
 Read2Settings.Offset:= -1;
  PlotCurve(   Chart1, Raw_ABR_Data, Raw_ABR_Info, Read2Settings);        //difference
 Read2Settings.Offset:=  0;
  PlotSubCurve(Chart1, Raw_ABR_Data, Raw_ABR_Info, Read2Settings, True ); //Masked
 Read2Settings.Offset:=  1;
  PlotSubCurve(Chart1, Raw_ABR_Data, Raw_ABR_Info, Read2Settings, False); //unmasked
 end
 else
 begin
   Read2Settings.Offset:=  0;
   PlotCurve(   Chart1, Raw_ABR_Data, Raw_ABR_Info, Read2Settings);
 end;
end;



  {** Activates a filter **}
procedure TReadForm2.None1Click(Sender: TObject);
begin
 If Sender = None1 then Read2Settings.Filter_freq:= -1;
 If Sender = N40001 then Read2Settings.Filter_freq:= 4000;
 If Sender = N35001 then Read2Settings.Filter_freq:= 3500;
 If Sender = N30001 then Read2Settings.Filter_freq:= 3000;
 If Sender = N25001 then Read2Settings.Filter_freq:= 2500;
 If Sender = N20001 then Read2Settings.Filter_freq:= 2000;
 With sender as TMenuItem do Checked:=true;

 ShowMyData3(Glob_Showform_ABR_Data,Glob_Showform_ABR_Info);
end;


 {** Saves the chart as a image **}
procedure TReadForm2.SaveImage1Click(Sender: TObject);
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


  {** Show the Setup **}
procedure TReadForm2.Setup1Click(Sender: TObject);
begin
  Read2Settings.SampleRate:= Glob_Showform_ABR_Info.SampelRate;
  Sender:=ReadForm2;
  ReadSettingsForm.UpdateSettingsForm(Sender,Read2Settings);
  ReadSettingsForm.show;
end;


 {** Changes the scale of the Y axis **}
procedure TReadForm2.N11Click(Sender: TObject);
var
 ScaleTo: Integer;
begin
   Scaleto:=1;
   if sender=N21 then Scaleto:=2;
   if sender=N51 then Scaleto:=5;
  With ReadForm2.Chart1.LeftAxis do Begin
     if sender=Auto1 then Automatic:=true else Automatic:=false;
     Maximum := ScaleTo;
     Minimum :=-ScaleTo;
    end
end;











procedure TReadForm2.Timer1Timer(Sender: TObject);
begin

//Timer1.Tag:=Timer1.Tag+2;
//if Timer1.Tag >= 100 then Timer1.Enabled:=false;
//Replay();
end;

procedure TReadForm2.Replay1Click(Sender: TObject);
begin
Showmessage('Sorry I can not do that');
//Timer1.Tag:=0;
//Timer1.Enabled:=true;
end;






end.
