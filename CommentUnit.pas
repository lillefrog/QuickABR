unit CommentUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TCommentForm = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Button3: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure ButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CommentForm: TCommentForm;

implementation

uses TDTUnit;

{$R *.DFM}
{$M 16384,10485760}

procedure TCommentForm.ButtonClick(Sender: TObject);
begin
 Edit1.Enabled:=False;
if Sender = Button2 then Edit1.Text:='{A}';  //Animal Care
if Sender = Button3 then Edit1.Text:='{K}';  //Comment
if Sender = Button4 then Edit1.Text:='{E}';  //Equipment
if Sender = Button5 then Edit1.Text:='{O}';  //Other
if Sender = Button5 then Edit1.Enabled:=True;
end;

procedure TCommentForm.Button1Click(Sender: TObject);
begin
  TDTForm.SaveLogFile(Edit1.Text +' '+ Edit2.Text);
  Edit2.Clear;
end;

procedure TCommentForm.Edit2Change(Sender: TObject);
begin
  button1.Enabled := Edit2.Text<>'';
end;

procedure TCommentForm.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then Button1Click(Sender);
end;

end.
