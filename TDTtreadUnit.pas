unit TDTtreadUnit;

interface

uses
  Dialogs,Sysutils,Classes, comctrls, ZBUSXLib_TLB, RPCOXLib_TLB,commonUnit, ABR;

type
  TMyThread = class(TThread)
  private
    PB : TProgressBar;   // Reference to ProgressBar
    RP : TRPcoX;         // Reference to The TDT system
    procedure InitProgressBar; // Setup ProgressBar  
    procedure UpdateProgressBar; // Update ProgressBar
  protected
    procedure Execute; override; // Main thread execution
  published

    constructor CreateIt(PriorityLevel: cardinal; ProgBar : TProgressBar; MyRPcox : TRPcoX);
    destructor Destroy; override;
  end;

var
GlobStop2:boolean;
Glob_Tread_Response : integer;
TDTtread_Local_Index1:integer;

implementation

uses
 windows, TDTUnit;



constructor TMyThread.CreateIt(PriorityLevel: cardinal; ProgBar : TProgressBar; MyRPcox : TRPcoX);
begin
  inherited Create(true);      // Create thread suspended
  Priority := TThreadPriority(PriorityLevel); // Set Priority Level
  FreeOnTerminate := true; // Thread Free Itself when terminated
  PB := ProgBar;           // Set reference
  RP := MyRPcox;
  Synchronize(InitProgressBar); // Setup the ProgressBar
  Suspended := false;           // Continue the thread
end;



destructor TMyThread.Destroy;
begin
   RP.SetTagVal('t_amp',0);   // shut up TDT - I don't close it i just set the soundlevel=0, this is much faster
   PostMessage(TDTForm.Handle,wm_ThreadDoneMsg,self.ThreadID,Glob_Tread_Response);  // Sends message
   inherited destroy;
end;



procedure TMyThread.Execute; // Main execution for thread
var
 index,Progress: single; 
 connected:boolean;
begin
  Repeat    // wait for data collection
    Progress:=RP.GetTagVal('counter');
    TDTtread_Local_Index1:= round(10*(Progress/Glob_NumberOf_Samples));
    Synchronize(UpdateProgressBar);           // Update progressbar1
    index:=RP.GetTagVal('recording');         //status of data collection
    Connected :=  ( 3 <= RP.GetStatus );      // Is TDT still connected
  until (index=0) OR Not(connected) Or Terminated ;
   Glob_Tread_Response:= round(index*10);
   If not(connected) then Glob_Tread_Response:=Glob_Tread_Response+4;
end;





procedure TMyThread.InitProgressBar; // setup/initialize the ProgressBar
begin
  PB.Min := 0;      // minimum value for bar
  PB.Max := 80;  // (maximum value for bar) this is now set from the main tread
  PB.Step := 1;     // size will be used by each call to StepIt
  PB.Position := 0; // set position to begining
end;



procedure TMyThread.UpdateProgressBar(); // Updates the ProgressBar
begin
  PB.Position:=TDTtread_Local_Index1;
end;



end.
