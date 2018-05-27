unit ABR;
{$WARN SYMBOL_PLATFORM OFF} // do not warn me about stuff not working on linux
interface

uses                                              
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TeEngine, Series, TeeProcs, Chart, Menus, CommonUnit,
  Buttons, FileCtrl, ComCtrls, Wav_handler;


type
  TForm1 = class(TForm)
    Chart1: TChart;
    Series1: TFastLineSeries;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Save1: TMenuItem;
    Load1: TMenuItem;                         
    Exit1: TMenuItem;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series4: TFastLineSeries;
    Series5: TFastLineSeries;
    SaveDialogMeas: TSaveDialog;
    Settings1: TMenuItem;
    TDT1: TMenuItem;
    TreeView1: TTreeView;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Savetest1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Loadtest1: TMenuItem;
    Start_ABR_Button: TButton;
    Timer1: TTimer;
    TestCalibration1: TMenuItem;
    Ti_Next_meas: TTimer;
    ButtonTest: TButton;
    Log1: TMenuItem;
    Addcomment1: TMenuItem;
    EditLogfile1: TMenuItem;
    NewLogfile1: TMenuItem;
    SaveDialog2: TSaveDialog;
    PopupMenu1: TPopupMenu;
    Testing1: TMenuItem;
    Memo1: TMemo;
    About1: TMenuItem;
    Label_chart: TLabel;
    procedure FormCreate(Sender: TObject);
    Procedure SetABRInfo(var ABR_Info: TABR_Info);
    procedure Chart1UndoZoom(Sender: TObject);  //zoom out
{ This is the actual measurement }
    procedure Start_ABR_ButtonClick(Sender: TObject);   //start recording
    Procedure ContinueMeasure(Sender: TObject);       // Starts new file
    procedure RecordSave(ABR_Info:TABR_Info);
    procedure ContinueRecordSave(ABR_Info:TABR_Info);  // Starts new submeasurement
    procedure RunTest(Data:array of double);
{ This part designs the test }
    procedure BitBtn1Click(Sender: TObject);   // Add To Treeview
    procedure BitBtn2Click(Sender: TObject);   // Remove from Treeview
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word; // Verify the imput
      Shift: TShiftState);
{ This controls the setup }
    procedure TDT1Click(Sender: TObject);      //Setup
    procedure Load1Click(Sender: TObject);     // open data files
    procedure Savetest1Click(Sender: TObject); // Save test setup
    procedure Loadtest1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TestCalibration1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Ti_Next_measTimer(Sender: TObject);
    procedure ButtonTestClick(Sender: TObject);
    procedure EditLogfile1Click(Sender: TObject);
    procedure NewLogfile1Click(Sender: TObject);
    procedure Addcomment1Click(Sender: TObject);
    procedure TreeView1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MyPopupHandler(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

const DebugTimer: Boolean = FALSE ;


var
  Form1: TForm1;
   Glob_ABRunit_Data:TABR_Data;
   Glob_ABRunit_Info:TABR_Info;
   Glob_NextFileName: string;
   Glob_TDTConnected :Boolean;
   Glob_MyNode1,Glob_MyNode2: TTreeNode;
   Glob_StartTid : TDateTime;
   Glob_Run_Test : boolean;  // run the test until this is false
   Glob_Test_Click : boolean;
   Glob_Save_OldStyle_Data : boolean;
   Glob_Save_NewStyle_Data : boolean;
   MyGlob_Averager: Array[0..9] of array of double;
   MyGlob_Averager_index:integer;
   Glob_max_avrages : integer;
   Glob_max_Turns : integer;
   Glob_abr_Avarage:TABR_Data;
   Glob_abr_Avarage_nr: Array[0..3] of integer;
   Glob_ABR_Full_Unmask :TSoundFile;
   Glob_ABR_Full_Mask :TSoundFile;

implementation

uses TDTUnit, ReadUnit, ReadUnit2, KalibUnit, LogUnit, CommentUnit;





{$R *.DFM}
{$M 16384,10485760}


  {**  Form Create  **}
procedure TForm1.FormCreate(Sender: TObject);
var
 filename:string;
begin
 DecimalSeparator:='.';
 Label_chart.Caption:='';
 Glob_Save_WavFile:=False;
 Glob_Save_OldStyle_Data:=FALSE;
 Glob_Save_NewStyle_Data:=TRUE;
 Glob_Test_Click:=False;
 if paramcount=1 then Begin        // used when opening a file by dbl. click.
    Filename:= ParamStr(1);         // The first parameter has to be the filename
    if FileExists(Filename) then Timer1.Enabled:=true;
 end;
end;


    { zoom out approx. 4% }
procedure TForm1.Chart1UndoZoom(Sender: TObject);
var
min,max:double;
t:integer;
begin
  Max:=0;  Min:=0;
  Chart1.LeftAxis.Automatic:=False;      // Meget Vigtigt
    for t:= 0 to Chart1.SeriesCount -1 do
    with Chart1.Series[ t ] do
     begin
       If Active then If Max<MaxYValue then Max:=MaxYValue;
       If Active then If Min>MinYValue then Min:=MinYValue;
     end;
  Chart1.LeftAxis.Maximum:= Max+2*(max-min)/100;
  Chart1.LeftAxis.Minimum:= Min-2*(max-min)/100;
end;


procedure NodeTextToSettings(S1,S2:string; var StimName:string; var Freq,Amp:integer);
Begin
   StimName:= ( Copy(S1 , pos('(',S1)+1 , Pos(')',S1)-(1+pos('(',S1)))  );
   S1:= Copy(S1,0,pos('Hz',S1)-1);
   Freq:= StrToInt(S1);    // Get frequency from title

   S2:= Copy(S2,0,length(S2)-2);
   Amp:= StrToInt(S2);         // Get Amplitude from title
end;


{******************************************************************}
{ This part runs the actual measurement }
{******************************************************************}


   {** Start the measurement **}
procedure TForm1.Start_ABR_ButtonClick(Sender: TObject);
var
S:string;
begin
 //Chart1.UndoZoom;
 If SaveDialogMeas.Execute then begin
    S:= SaveDialogMeas.FileName;
    Glob_NextFileName:= Copy(S,0,pos('.',S)-1);
    ContinueMeasure(Sender);
 end;
end;


Procedure TForm1.SetABRInfo(var ABR_Info: TABR_Info);
Begin
   InitABRInfo(ABR_Info);
   ABR_Info.Max_Turns := Glob_max_Turns;
   ABR_Info.Name_Klik    := Glob_Stim_file_name;
   ABR_Info.Stim_file_name:= Glob_Stim_file_name;
   ABR_Info.InitFileName := Glob_NextFileName;
   ABR_Info.Kommentar    := edit1.Text;
   ABR_Info.Max_avarages := Glob_max_avrages;
   ABR_Info.kanal_ind    := Glob_kanal_ind;
   ABR_Info.kanal_ud     := Glob_kanal_ud;
   ABR_Info.SampelRate   := TDTForm.Get_TDT_Sampelrate('SOUND');
   ABR_Info.ABR_SampleRate   := TDTForm.Get_TDT_Sampelrate('ABR');
   ABR_Info.Invert_Click := Glob_Invert_Click;
   ABR_Info.Directional_ABR:= Glob_Directional_ABR;
   ABR_Info.Stim_file_length:=  Glob_NumberOf_Samples-100; //should be improved
   ABR_Info.NumberOf_Samples :=    Glob_NumberOf_Samples;
   ABR_Info.Amp_Klik  :=  Glob_klik_Amp;
   ABR_Info.Freq_Klik :=  Glob_klik_Freq;
   ABR_Info.Turn_Nr := 0;
   //ABR_Info.Stim_file_name := Glob_Stim_file_name;
   ABR_Info.Kalib_File_name  :=TDT_KalibFilePath;
end;


// Continue Measure
Procedure TForm1.ContinueMeasure(Sender: TObject);
var
  StimName:string;
  Freq,tone:integer;
  ABR_Info: TABR_Info;
Begin

 SetABRInfo(ABR_Info);
 If sender = Start_ABR_Button then
 begin
    Glob_TDTConnected:=TRUE;
    Start_ABR_Button.Enabled:=False;
    ButtonTest.Enabled:=False;
    Glob_StartTid:=now;
    Glob_MyNode1:= TreeView1.Items.GetFirstNode;
    Glob_MyNode2:=Glob_MyNode1.getFirstChild;
 end else
 begin
    Glob_MyNode2:=Glob_MyNode2.getNextSibling;   //get next intensity
    if Glob_MyNode2 = nil then                   //if no more intensitys
    begin
      Glob_MyNode1:= Glob_MyNode1.getNextSibling;   //get next frequency
      if Glob_MyNode1 <> nil then                   //if frequency exists
          Glob_MyNode2:= Glob_MyNode1.getFirstChild; // Get first intencity
    end;
 end;

 if ((Glob_MyNode2 <> nil) and (Glob_MyNode1 <> nil)) then begin

 NodeTextToSettings(Glob_MyNode1.Text, Glob_MyNode2.Text, StimName, Freq, tone);

                         // If a spcific stimulus is part of the name THEN load this stimulus
   if StimName<>'' then TDTForm.LoadStim(StimName);// else StimName := Glob_Stim_file_name;

   ABR_Info.Name_Klik    := Glob_Stim_file_name;
   ABR_Info.Stim_file_name:= StimName;
   ABR_Info.Max_avarages:= Glob_max_avrages;

   If freq=0 then begin  //Unmasked
      ABR_Info.Masked    := False;
      ABR_Info.Amp_Klik  := tone;
      ABR_Info.Amp_Tone  :=-1000;
      ABR_Info.Freq_Tone := 1000;
    end
      else
    Begin                //Masked
      ABR_Info.Masked   := True;
      ABR_Info.Amp_Klik := Glob_klik_Amp;
      ABR_Info.Amp_Tone := tone;
      ABR_Info.Freq_Tone:= Freq;
    End;

   if DebugTimer then Form1.Memo1.Lines.Add(FormatDateTime('"1;" sszzz',(now-Glob_StartTid)));
   RecordSave(ABR_Info);   //start the next recording
 end else begin
   TDTForm.Hide;     // If there is no more nodes, stop the recording.
   TDTForm.ShowMode(1);
   Start_ABR_Button.Enabled:=true;
   TDTForm.ShutUp;
   Showmessage(FormatDateTime('"Duration " hh:mm:ss',(now-Glob_StartTid)));  // show the duration of the test
 end;
End;




{** Starts the recording. Is continued in ContinueRecordSave  **}
procedure TForm1.RecordSave(ABR_Info:TABR_Info);
var
 i: integer;
 ABR_Data:TABR_Data;
begin
  InitABRData(ABR_Data);
  TDTForm.ShowMode(2);
  TDTForm.Show;
  if ABR_Info.Amp_Tone > -999
    then TDTForm.Caption:= 'Recording  '+Inttostr(ABR_Info.Freq_Tone)+' Hz '+IntToStr(ABR_Info.Amp_Tone)+'dB'
    else TDTForm.Caption:= 'Recording   Click '+IntToStr(ABR_Info.Amp_Klik )+'dB' ;

  If ABR_Info.Turn_Nr =0 then begin
    Chart1.series[0].Clear;
    Chart1.series[1].Clear;
    for i:= 0 to 3 do begin
       SetLength(Glob_abr_Avarage[i],0); //Reset content (is it really nessary?)
       Glob_abr_Avarage_nr[i]:=0;       //Number of recordings set to 0
    end;
       SetLength(Glob_ABR_Full_Unmask,0);   //The full data is set to 0 length
       SetLength(Glob_ABR_Full_Mask,0);

    TDTForm.Label2.Caption:= inttostr(ABR_Info.Turn_Nr);
    TDTForm.ProgressBar2.Position:= Round(ABR_Info.Turn_Nr);

    Glob_ABRunit_Info:=ABR_Info;
    if DebugTimer then Form1.Memo1.Lines.Add(FormatDateTime('"RecordSave;" sszzz',(now-Glob_StartTid)));
    if TDTForm.TDTSet( ABR_Info ) then
       TDTForm.TDTRecordFast( ABR_Info );
  end else Showmessage('Error TForm1.RecordSave, Nr= '+inttostr(ABR_Info.Turn_Nr));
end;




{** Gets activatet when TDTForm has data, starts a new subRecording **}
procedure TForm1.ContinueRecordSave(ABR_Info:TABR_Info);
var
 i,L:integer;
 S:String;
 Continue:boolean;
begin
 if DebugTimer then Form1.Memo1.Lines.Add(FormatDateTime('"8;" sszzz',(now-Glob_StartTid)));

 for i:=0 to 3 do Chart1.series[i].Clear;
 L:=Length(Glob_abr_Avarage[0]);

 if ((Glob_abr_Avarage_nr[0]>0) AND (Glob_abr_Avarage_nr[1]>0)) then
 begin
   for i:=0 to L-1 do Chart1.series[0].AddXY(i*1000/ABR_Info.SampelRate,Glob_abr_Avarage[0,i]/Glob_abr_Avarage_nr[0]);
   for i:=0 to L-1 do Chart1.series[1].AddXY(i*1000/ABR_Info.SampelRate,Glob_abr_Avarage[1,i]/Glob_abr_Avarage_nr[1]);
 End;
 if ((Glob_abr_Avarage_nr[2]>0) AND (Glob_abr_Avarage_nr[3]>0)) then
 begin
   for i:=0 to L-1 do Chart1.series[2].AddXY(i*1000/ABR_Info.Sampelrate,Glob_abr_Avarage[2,i]/Glob_abr_Avarage_nr[2]);
   for i:=0 to L-1 do Chart1.series[3].AddXY(i*1000/ABR_Info.Sampelrate,Glob_abr_Avarage[3,i]/Glob_abr_Avarage_nr[3]);
 End;


 for i:=0 to 4 do ABR_Info.Numbers_of_Awarages[i] := Glob_abr_Avarage_nr[i];

 ABR_Info.Turn_Nr:=ABR_Info.Turn_Nr+1;

 TDTForm.Label2.Caption:= inttostr(Glob_abr_Avarage_nr[0]+Glob_abr_Avarage_nr[1])+'/'+inttostr(Glob_max_avrages);
 TDTForm.ProgressBar2.Position:= Round(100*((Glob_abr_Avarage_nr[0]+Glob_abr_Avarage_nr[1])/Glob_max_avrages));

 Continue:=FALSE;
 if (Glob_abr_Avarage_nr[0]+Glob_abr_Avarage_nr[1]) < Glob_max_avrages then Continue:=TRUE;
 if (ABR_Info.Masked AND ((Glob_abr_Avarage_nr[2]+Glob_abr_Avarage_nr[3]) < Glob_max_avrages)) then Continue:=TRUE;

 If continue then
 begin      // Continue the recording
   If odd(ABR_Info.Turn_Nr) then ABR_Info.InstantAmp := ABR_Info.Amp_Tone else ABR_Info.InstantAmp:=-1000;

   TDTForm.TDTRecordFast(ABR_Info);
 end else
 begin      // Start next recording
    If ABR_Info.Amp_Tone= -1000 then
    begin
      ABR_Info.Amp_Tone:= ABR_Info.Amp_Klik;
      ABR_Info.Freq_Tone:= 0;
    end;
    S:= Glob_NextFileName+'_'+ABR_Info.Stim_file_name +'_'+IntToStr(ABR_Info.Freq_Tone)+'Hz_'+IntToStr(ABR_Info.Amp_Tone)+'dB.'{.AB3};

    If Glob_Save_NewStyle_Data then      // Save the data in a modified csv file that is easy to read in other programs
    Begin
      ReadForm.SaveMatFileformat(
                Glob_abr_Avarage,
                ABR_Info, S+'CSV'
                );
    End;
    If Glob_Save_WavFile then     // Save the full recording in a wav file
    begin
      WavNormalize(Glob_ABR_Full_mask,Glob_ABR_Full_Unmask,31900);
      SaveWavFile(S+'WAV',Glob_ABR_Full_Unmask,Glob_ABR_Full_mask,24144);
    End;

    ContinueMeasure(Form1);  //starts recording the next file
 end;
end;





{******************************************************************}
 { This part designs the test }
{******************************************************************}




  {**  Add To Treeview **}
procedure TForm1.BitBtn1Click(Sender: TObject);
var
 MyNode1: TTreeNode;
 FreqFindes: Boolean;
begin

 FreqFindes:=False;
 MyNode1:= TreeView1.Items.GetFirstNode;
 while MyNode1 <> nil do begin
   If ((MyNode1.Text)=(ComboBox2.Text+'Hz')) then Begin
     FreqFindes:=True;
     MyNode1.Expanded:=TRUE;
     TreeView1.Items.AddChild(MyNode1,(ComboBox1.Text+'dB'));
   End;
   MyNode1:= MyNode1.getNextSibling;
 End;

 If not(FreqFindes) Then Begin
   MyNode1 := TreeView1.Items.Add(nil,(ComboBox2.Text+'Hz'));
   TreeView1.Items.AddChild(MyNode1,(ComboBox1.Text+'dB'));
 End;
  Start_ABR_Button.Enabled:=True;
end;



  {**  Remove from Treeview  **}
procedure TForm1.BitBtn2Click(Sender: TObject);
var
 MyNode1,MyNode2: TTreeNode;
begin
 MyNode2:=nil;
 MyNode1:= TreeView1.Items.GetFirstNode;
  while MyNode1 <> nil do
  begin
    If MyNode1.Selected then MyNode2:=MyNode1;
    MyNode1:= MyNode1.getNext;
  End;
  IF MyNode2 <> nil then MyNode2.Delete;

  MyNode1:= TreeView1.Items.GetFirstNode;
  If MyNode1=nil then Start_ABR_Button.Enabled:=false;
end;



Function cleanup(T:string):string;
var
 i:integer;
 S:String;
Begin
S:='';
 For i:=0 to Length(T) do
 Begin
   Case T[i] of
   '1': S:=S+'1';
   '2': S:=S+'2';
   '3': S:=S+'3';
   '4': S:=S+'4';
   '5': S:=S+'5';
   '6': S:=S+'6';
   '7': S:=S+'7';
   '8': S:=S+'8';
   '9': S:=S+'9';
   '0': S:=S+'0';
   end;
 end;
 Result:=S;
end;

  {**  Verify the imput  **}
procedure TForm1.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 with Sender as TComboBox do
  try
    if text<>'' then text:= Cleanup(text);
    if text<>'' then StrToInt(Text);
    if key=VK_RETURN then BitBtn1Click(Sender);
  except
    on EConvertError do Showmessage('Not a Integer: '+Text);
  end;
end;


{******************************************************************}
 { This controls the setup }
{******************************************************************}


  {**  Open TDT settings  **}
procedure TForm1.TDT1Click(Sender: TObject);
begin
  TDTForm.ShowMode(1);
  TDTForm.show;
end;


  {** open data files **}
procedure TForm1.Load1Click(Sender: TObject);
begin
  ReadForm.show;
end;


  {** Save test setup **}
procedure TForm1.Savetest1Click(Sender: TObject);
begin
 Savedialog1.InitialDir:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 If savedialog1.Execute then
   Begin
     treeview1.SaveToFile(savedialog1.FileName);
     TDTForm.SaveLogFile('{Set} Settings Saved '+savedialog1.FileName);
   End;
end;


  {** Load test setup **}
procedure TForm1.Loadtest1Click(Sender: TObject);
begin
 Opendialog1.InitialDir:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
 If opendialog1.Execute then
   Begin
     treeview1.LoadFromFile(Opendialog1.FileName);
     TDTForm.SaveLogFile('{Set} Settings Loaded '+savedialog1.FileName);
     Start_ABR_Button.Enabled:=True;
   End;
end;


   {** Reads a file command line **}
procedure TForm1.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=false;
 ReadForm2.LoadFile(ParamStr(1));
 ReadForm2.show;
end;

procedure TForm1.TestCalibration1Click(Sender: TObject);
begin
KalibForm.show;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
Form1.Caption:='QuickABR    (' + TDTForm.Kalib_Name(false)+')';
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
 Form1.Close;
end;

procedure TForm1.Ti_Next_measTimer(Sender: TObject);
begin
Ti_Next_meas.Enabled:=false;
ContinueMeasure(Form1);
end;

procedure TForm1.RunTest(Data:array of double);
var
i,k,N:integer;
Data2:array of double;
SRate:double;
 Signal,Power:TSoundFile ;
begin
 SRate:= TDTForm.Get_TDT_Sampelrate('ABR');
 If Glob_Test_Click AND (Length(data)>10) then
 Begin
   showmessage('Data returned from calibration');
   // This is the return of the data from the test
   KalibForm.Chart2.Series[0].Clear;
   KalibForm.Chart3.Series[0].Clear;
   N:= length(data);
   //if N>1000 then N:=1000;
   Setlength(Signal,N);
   for i:=0 to N-1 do Signal[i]:=Data[i];
   for i:=0 to N-1 do KalibForm.Chart2.Series[0].AddXY((i/N)*SRate,Signal[i]);
   Setlength(Power,0);
   //Power:=SimpleFFT2(Signal);
   //for i:=0 to length(Power)-1 do KalibForm.Chart3.Series[0].AddXY(i*(SRate/N),Power[i]);
   ButtonTestClick(TDTForm);
   Glob_Test_Click:=false;   // }
 end
 else
 Begin
   Chart1.Series[0].Clear;
   Chart1.Series[1].Clear;
   for i:=0 to length(data)-1 do Chart1.series[0].AddXY(i*1000/SRate,Data[i]);
   If (not( Glob_Test_Click)) AND (Length(data)>100) then
    Begin
       // this runs as part of the test every round,
       if MyGlob_Averager_index=9 then MyGlob_Averager_index:=0 else inc(MyGlob_Averager_index);   //<--
       setlength(MyGlob_Averager[MyGlob_Averager_index],Length(Data));
       for i := 0 to length(Data)-1 do  MyGlob_Averager[MyGlob_Averager_index,i]:=Data[i];
       SetLength(Data2,Length(Data));
       for i:=0 to Length(data2)-1 do Data2[i]:=0;
       for i:= 0 to 9 do
       begin
         for k:=0 to Length(data2)-1 do Data2[k]:=Data2[k]+ MyGlob_Averager[i,k];
       end;
       for i:=0 to length(data2)-1 do Chart1.series[1].AddXY(i*1000/SRate,Data2[i]/10);//}
     end;
  If Glob_Run_Test then
   Begin
    // this is starting the test
    TDTForm.TDTRunTest();
   end;
 end;
end;



   // *** Run Test
procedure TForm1.ButtonTestClick(Sender: TObject);
var
i,k: integer;
Data:array of double;
begin
If ButtonTest.Caption='Test' then
   Begin
     for i:= 0 to 9 do
     begin
       //setlength(MyGlob_Averager[i],2000);    Glob_NumberOf_Samples
       setlength(MyGlob_Averager[i],Glob_NumberOf_Samples);
       for k:=0 to length(MyGlob_Averager[i])-1 do MyGlob_Averager[i,k]:=0;
     end;
     ButtonTest.Caption:='Stop';
     Glob_Run_Test:=true;
     SetLength(Data,0);
     RunTest(Data);
   End else Begin
     ButtonTest.Caption:='Test';
     Glob_Run_Test:=False;
   end;
end;



procedure TForm1.EditLogfile1Click(Sender: TObject);
begin
 LogForm.Show;
end;



procedure TForm1.NewLogfile1Click(Sender: TObject);
begin
 SaveDialog2.DefaultExt:='log';
 SaveDialog2.FileName:='LogFile';
 If SaveDialog2.Execute then
  Begin
    TDTForm.NewLogFile(SaveDialog2.FileName);
  end;
end;


procedure TForm1.Addcomment1Click(Sender: TObject);
begin
  CommentForm.show;
end;


procedure TForm1.TreeView1ContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
 MyNode1: TTreeNode;
 MyItem: TMenuItem;
 Path,S: String;
 F: TSearchRec;
begin
  PopupMenu1.Items.Clear;
  MyItem := TMenuItem.Create(Self);
  MyItem.Caption := 'REMOVE';
  MyItem.OnClick :=  MyPopUpHandler;
  PopupMenu1.Items.Add(MyItem);
  PopupMenu1.Items.InsertNewLineAfter(MyItem);

  Path:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)))+'stim\' ;
  if not DirectoryExists(path) then CreateDir(path);
  path:= path+'*.AB9';
  Showmessage(path);
  FindFirst(path,faReadOnly,F);
   MyItem := TMenuItem.Create(Self);
   MyItem.Caption := copy(F.Name,0,pos('.',F.Name)-1);
   MyItem.OnClick :=  MyPopUpHandler;
   PopupMenu1.Items.Add(MyItem);
  while FindNext(F) = 0 do Begin
    S:= copy(F.Name,0,pos('.',F.Name)-1);
    if S<>'standart' then
       Begin
          MyItem := TMenuItem.Create(Self);
          MyItem.Caption := copy(F.Name,0,pos('.',F.Name)-1);
          MyItem.OnClick :=  MyPopUpHandler;
          PopupMenu1.Items.Add(MyItem);
       end;
  end;
  MyNode1:=TreeView1.Selected;
  if (MyNode1<>nil) AND (MyNode1.Level=0)then PopupMenu1.Popup(
                Form1.Left + TreeView1.Left + MousePos.x +20,
                Form1.Top  + TreeView1.Top  + MousePos.y +20);
end;




procedure TForm1.MyPopupHandler(Sender: TObject);
var
  MyNode1: TTreeNode;
begin
  MyNode1:=TreeView1.Selected;
  with Sender as TMenuItem do begin
    MyNode1.Text:= Copy(MyNode1.Text,0,Pos('Hz',MyNode1.Text)+1);
    If caption<>'REMOVE' then MyNode1.Text:= MyNode1.Text+' ('+Caption+')';
  end;
end;




procedure TForm1.TreeView1Click(Sender: TObject);
var
 Mousepos:Tpoint;
 MyNode1: TTreeNode;
 HT: THitTests;
 X,Y:integer;
 S:String;
begin
 Mousepos:=mouse.CursorPos;
 X:= Mousepos.x - Form1.Left -(TreeView1.Left +5 );
 Y:= Mousepos.y - Form1.Top  -(TreeView1.Top  +52);
 HT := TreeView1.GetHitTestInfoAt(X,Y);
 MyNode1:=TreeView1.GetNodeAt(X,Y);
 //if AnItem<>nil then Showmessage(AnItem.Text);
 //if (htOnIcon in HT)  then Showmessage('Icon');
 //if (htNowhere in HT)  then Showmessage('htNowhere');
 //if (htOnIndent in HT)  then Showmessage('htOnIndent');
 //if (htOnItem in HT)  then Showmessage('Item');
 if (htOnLabel in HT) And (MyNode1<>nil) And (MyNode1.Level=0) then
    Begin
      S:= MyNode1.Text;
      if (Length(s))=(pos('Hz',S)+1) then {Showmessage(S);} Combobox2.Text:= Copy(S,0,pos('Hz',S)-1);
    end;
end;





procedure TForm1.About1Click(Sender: TObject);
begin
Showmessage(Glob_Program_version);
end;

end.   // the end
