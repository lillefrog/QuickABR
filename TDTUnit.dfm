object TDTForm: TTDTForm
  Left = 248
  Top = 212
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'TDTForm'
  ClientHeight = 507
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    367
    507)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 272
    Top = 44
    Width = 7
    Height = 16
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Label1: TLabel
    Left = 16
    Top = 112
    Width = 3
    Height = 13
  end
  object TreeView1: TTreeView
    Left = 168
    Top = 64
    Width = 193
    Height = 337
    Anchors = [akLeft, akTop, akRight, akBottom]
    Indent = 19
    TabOrder = 1
    Items.Data = {
      010000001D0000000000000000000000FFFFFFFFFFFFFFFF0000000001000000
      04546573741D0000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      000473756231}
  end
  object RP1: TRPcoX
    Left = 280
    Top = 120
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object RP2: TRPcoX
    Left = 280
    Top = 152
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object RP3: TRPcoX
    Left = 280
    Top = 184
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object RP4: TRPcoX
    Left = 280
    Top = 216
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object RP5: TRPcoX
    Left = 280
    Top = 248
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object PA5x1: TPA5x
    Left = 248
    Top = 120
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object PA5x2: TPA5x
    Left = 248
    Top = 152
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 8
    Width = 249
    Height = 25
    Step = 1
    TabOrder = 9
    Visible = False
  end
  object ProgressBar2: TProgressBar
    Left = 8
    Top = 40
    Width = 249
    Height = 25
    TabOrder = 10
    Visible = False
  end
  object Button1: TButton
    Left = 16
    Top = 8
    Width = 129
    Height = 25
    Caption = 'ReConnect'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 40
    Width = 129
    Height = 25
    Caption = 'Load Calibration'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    OnClick = Button2Click
  end
  object Button4: TButton
    Left = 264
    Top = 8
    Width = 57
    Height = 25
    Caption = 'Pause'
    TabOrder = 12
    Visible = False
    OnClick = Button4Click
  end
  object Panel1: TPanel
    Left = 8
    Top = 71
    Width = 153
    Height = 330
    BevelOuter = bvLowered
    TabOrder = 13
    object Label3: TLabel
      Left = 8
      Top = 8
      Width = 96
      Height = 13
      Caption = 'Number of averages'
    end
    object Label4: TLabel
      Left = 8
      Top = 227
      Width = 57
      Height = 13
      Caption = 'Channel out'
    end
    object Label6: TLabel
      Left = 8
      Top = 312
      Width = 87
      Height = 13
      Caption = 'Add 16 for RA4PA'
    end
    object Label7: TLabel
      Left = 8
      Top = 61
      Width = 54
      Height = 13
      Caption = 'Peak reject'
    end
    object Label8: TLabel
      Left = 8
      Top = 111
      Width = 62
      Height = 13
      Caption = 'Stimulus type'
    end
    object Label9: TLabel
      Left = 8
      Top = 272
      Width = 50
      Height = 13
      Caption = 'Channel in'
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 24
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBox1Change
      OnExit = ComboBox1Change
      Items.Strings = (
        '40'
        '60'
        '100'
        '200'
        '400'
        '800'
        '1000'
        '1600'
        '2000'
        '3200'
        '4000'
        '6400')
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 243
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      OnChange = ComboBox1Change
      Items.Strings = (
        '1'
        '2')
    end
    object ComboBox3: TComboBox
      Left = 8
      Top = 288
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      OnChange = ComboBox1Change
      Items.Strings = (
        '1'
        '2'
        '17'
        '18'
        '19'
        '20')
    end
    object ComboBox4: TComboBox
      Left = 8
      Top = 77
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      OnChange = ComboBox1Change
      Items.Strings = (
        '0,1'
        '0,2'
        '1'
        '2'
        '10'
        '20'
        '100')
    end
    object ComboBox5: TComboBox
      Left = 8
      Top = 128
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      OnChange = ComboBox5Change
    end
    object Button3: TButton
      Left = 8
      Top = 160
      Width = 121
      Height = 25
      Caption = 'Make New stimulus'
      TabOrder = 5
      OnClick = Button3Click
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 200
      Width = 97
      Height = 17
      Caption = 'Directional ABR'
      TabOrder = 6
      OnClick = CheckBox1Click
    end
  end
  object PA5x3: TPA5x
    Left = 248
    Top = 184
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object PA5x4: TPA5x
    Left = 248
    Top = 216
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object PA5x5: TPA5x
    Left = 248
    Top = 248
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object ZBUSx1: TZBUSx
    Left = 280
    Top = 88
    Width = 33
    Height = 33
    TabOrder = 17
    Visible = False
    ControlData = {00000100690300006903000000000000}
  end
  object RP_SOUND: TRPcoX
    Left = 200
    Top = 296
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object RP_ABR: TRPcoX
    Left = 232
    Top = 296
    Width = 32
    Height = 32
    ControlData = {00000100560A00002B05000000000000}
  end
  object Panel2: TPanel
    Left = 8
    Top = 408
    Width = 353
    Height = 89
    BevelOuter = bvLowered
    TabOrder = 20
    object Label5: TLabel
      Left = 8
      Top = 8
      Width = 90
      Height = 13
      Caption = 'Samples to Record'
    end
    object ComboBox6: TComboBox
      Left = 8
      Top = 25
      Width = 130
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBox1Change
      Items.Strings = (
        '500'
        '1000'
        '2000')
    end
    object CheckBox_Invert_click: TCheckBox
      Left = 16
      Top = 56
      Width = 97
      Height = 17
      Hint = 'Inverts the click, should always be enabled '
      Caption = 'Invert Click'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBox_Invert_clickClick
    end
    object CheckBox_Save_wav: TCheckBox
      Left = 128
      Top = 56
      Width = 105
      Height = 17
      Hint = 'Saves the full recording as a wav file, requires a lot of space'
      Caption = 'Save as Wav file'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = CheckBox_Save_wavClick
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'csv'
    Filter = 'csv files|*.csv|all files|*.*'
    Left = 248
    Top = 88
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 65520
    Top = 128
  end
end
