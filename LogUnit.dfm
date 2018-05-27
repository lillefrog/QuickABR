object LogForm: TLogForm
  Left = 288
  Top = 144
  AutoScroll = False
  Caption = 'LogForm'
  ClientHeight = 462
  ClientWidth = 854
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    854
    462)
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 0
    Top = 64
    Width = 857
    Height = 401
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Button1: TButton
    Left = 16
    Top = 8
    Width = 89
    Height = 25
    Caption = 'Save in new file'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 200
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Update'
    TabOrder = 2
    OnClick = Button2Click
  end
  object GroupBox1: TGroupBox
    Left = 280
    Top = 8
    Width = 449
    Height = 49
    Caption = 'Show'
    TabOrder = 3
    object CheckBox1: TCheckBox
      Left = 48
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Open Close'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 48
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Recordings'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 248
      Top = 24
      Width = 145
      Height = 17
      Caption = 'General Comments'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      Left = 144
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Animal Care'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object CheckBox5: TCheckBox
      Left = 248
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Settings'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object CheckBox6: TCheckBox
      Left = 144
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Equipment'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object CheckBox7: TCheckBox
      Left = 336
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Other'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'log'
    Filter = 'Log Files|*.log|All Files|*.*'
    Left = 784
    Top = 8
  end
end
