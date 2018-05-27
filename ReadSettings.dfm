object ReadSettingsForm: TReadSettingsForm
  Left = 1111
  Top = 268
  AutoScroll = False
  Caption = 'Graph Settings'
  ClientHeight = 449
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 270
    Height = 441
    TabOrder = 0
    object Label2: TLabel
      Left = 64
      Top = 24
      Width = 89
      Height = 13
      Caption = 'Visible Time Scale.'
    end
    object Label3: TLabel
      Left = 8
      Top = 144
      Width = 123
      Height = 13
      Caption = 'Distance Between Curves'
    end
    object Label1: TLabel
      Left = 8
      Top = 88
      Width = 38
      Height = 13
      Caption = 'To time:'
    end
    object Label4: TLabel
      Left = 8
      Top = 40
      Width = 48
      Height = 13
      Caption = 'From time:'
    end
    object Label9: TLabel
      Left = 8
      Top = 360
      Width = 38
      Height = 13
      Caption = 'To time:'
    end
    object Label10: TLabel
      Left = 8
      Top = 320
      Width = 48
      Height = 13
      Caption = 'From time:'
    end
    object Label11: TLabel
      Left = 56
      Top = 304
      Width = 120
      Height = 13
      Caption = 'Area to test for PP values'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 208
      Width = 97
      Height = 17
      Caption = 'Invert ABR'
      TabOrder = 0
      OnClick = SettingsChanged
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 232
      Width = 97
      Height = 17
      Caption = 'Show Buffers'
      TabOrder = 1
      OnClick = SettingsChanged
    end
    object Bt_Cancel: TButton
      Left = 96
      Top = 408
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = Bt_CancelClick
    end
    object ScrollBar1: TScrollBar
      Left = 8
      Top = 56
      Width = 249
      Height = 15
      Max = 2000
      Min = 1
      PageSize = 0
      Position = 1
      TabOrder = 3
      OnChange = SettingsChanged
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 160
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      Text = '1'
      OnChange = SettingsChanged
      Items.Strings = (
        '1'
        '2'
        '4')
    end
    object ScrollBar2: TScrollBar
      Left = 8
      Top = 104
      Width = 249
      Height = 15
      DragCursor = 4
      Max = 2000
      Min = 1
      PageSize = 0
      Position = 1
      TabOrder = 5
      OnChange = SettingsChanged
    end
    object ScrollBar6: TScrollBar
      Left = 8
      Top = 376
      Width = 249
      Height = 15
      Max = 500
      Min = 1
      PageSize = 0
      Position = 1
      TabOrder = 6
      OnChange = SettingsChanged
    end
    object ScrollBar5: TScrollBar
      Left = 8
      Top = 336
      Width = 249
      Height = 15
      Max = 500
      Min = 1
      PageSize = 0
      Position = 1
      TabOrder = 7
      OnChange = SettingsChanged
    end
    object Bt_Apply: TButton
      Left = 8
      Top = 408
      Width = 75
      Height = 25
      Caption = 'Apply'
      Enabled = False
      TabOrder = 8
      OnClick = Bt_ApplyClick
    end
    object Bt_SetToDefault: TButton
      Left = 184
      Top = 408
      Width = 75
      Height = 25
      Caption = 'Default'
      TabOrder = 9
      OnClick = Bt_SetToDefaultClick
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 256
      Width = 121
      Height = 17
      Caption = 'Show Jewet Marks'
      TabOrder = 10
      OnClick = SettingsChanged
    end
  end
end
