object CommentForm: TCommentForm
  Left = 96
  Top = 614
  BorderStyle = bsDialog
  Caption = 'Add Comment'
  ClientHeight = 103
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 65
    Height = 21
    Enabled = False
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 80
    Top = 8
    Width = 329
    Height = 21
    TabOrder = 1
    OnChange = Edit2Change
    OnKeyDown = Edit2KeyDown
  end
  object Button1: TButton
    Left = 416
    Top = 8
    Width = 49
    Height = 25
    Caption = 'Add'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 56
    Top = 40
    Width = 377
    Height = 57
    Caption = 'Type of Comment'
    TabOrder = 3
    object Button3: TButton
      Left = 104
      Top = 24
      Width = 81
      Height = 25
      Caption = 'General'
      TabOrder = 0
      OnClick = ButtonClick
    end
    object Button2: TButton
      Left = 16
      Top = 24
      Width = 81
      Height = 25
      Caption = 'Animal Care'
      TabOrder = 1
      OnClick = ButtonClick
    end
    object Button4: TButton
      Left = 192
      Top = 24
      Width = 81
      Height = 25
      Caption = 'Equipment'
      TabOrder = 2
      OnClick = ButtonClick
    end
    object Button5: TButton
      Left = 280
      Top = 24
      Width = 81
      Height = 25
      Caption = 'Other'
      TabOrder = 3
      OnClick = ButtonClick
    end
  end
end
