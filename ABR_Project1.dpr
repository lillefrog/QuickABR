program Project1;

{%ToDo 'Project1.todo'}
{%ToDo 'ABR_Project1.todo'}

uses
  Forms,
  ABR in 'ABR.pas' {Form1},
  TDTUnit in 'TDTUnit.pas' {TDTForm},
  ReadUnit in 'ReadUnit.pas' {ReadForm},
  FilterUnit in 'FilterUnit.pas',
  commonUnit in 'commonUnit.pas',
  TDTtreadUnit in 'TDTtreadUnit.pas',
  ReadUnit2 in 'ReadUnit2.pas' {ReadForm2},
  ReadSettings in 'ReadSettings.pas' {ReadSettingsForm},
  ExportUnit in 'ExportUnit.pas' {ExportForm},
  MakeStimUnit in 'MakeStimUnit.pas' {MakeStimForm},
  KalibUnit in 'KalibUnit.pas' {KalibForm},
  TestTreadUnit in 'TestTreadUnit.pas',
  LogUnit in 'LogUnit.pas' {LogForm},
  CommentUnit in 'CommentUnit.pas' {CommentForm},
  Wav_handler in 'Wav_handler.pas',
  Complexs in 'Complexs.pas',
  FFTs in 'FFTs.pas',
  JewetUnit in 'JewetUnit.pas' {JewetForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'QuickABR';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTDTForm, TDTForm);
  Application.CreateForm(TReadForm, ReadForm);
  Application.CreateForm(TReadForm2, ReadForm2);
  Application.CreateForm(TReadSettingsForm, ReadSettingsForm);
  Application.CreateForm(TExportForm, ExportForm);
  Application.CreateForm(TMakeStimForm, MakeStimForm);
  Application.CreateForm(TKalibForm, KalibForm);
  Application.CreateForm(TLogForm, LogForm);
  Application.CreateForm(TCommentForm, CommentForm);
  Application.CreateForm(TJewetForm, JewetForm);
  Application.Run;
end.
