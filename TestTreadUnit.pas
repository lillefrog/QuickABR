unit TestTreadUnit;

interface

uses
  Classes, RPCOXLib_TLB;

type
  TestTread = class(TThread)
  private
     RP : TRPcoX;         // Reference to The TDT system
  protected
     procedure Execute; override;
  published
    constructor CreateIt(PriorityLevel: cardinal; MyRPcox : TRPcoX);
    destructor Destroy; override;
  end;

var
  TestThreadResponse : integer;

implementation

uses
  windows,TDTUnit;




constructor TestTread.CreateIt(PriorityLevel: cardinal; MyRPcox : TRPcoX);
begin
  inherited Create(true);                       // Create thread suspended
  Priority := TThreadPriority(PriorityLevel);   // Set Priority Level
  FreeOnTerminate := true;                      // Thread Free Itself when terminated
  RP := MyRPcox;
  Suspended := false;                           // Continue the thread
end;




destructor TestTread.Destroy;
begin
  PostMessage(TDTForm.Handle, wm_TestThreadDone, self.ThreadID, TestThreadResponse);  // Sends message
  inherited destroy;
end;




procedure TestTread.Execute;
var
 index:single;
 Connected:boolean;
begin
  Repeat                                        // wait for data collection
    //index :=RP.GetTagVal('stcode');             // status of data collection
    index:=RP.GetTagVal('recording');         //status of data collection
    Connected :=  (3<=RP.GetStatus);            // are the TDTsystem connected
  until (index=0) OR Not(connected) Or Terminated ;
  if index<>0 then TestThreadResponse:=1 else TestThreadResponse:=0;
end;



end.
