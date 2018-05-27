object Form1: TForm1
  Left = 335
  Top = 194
  AutoScroll = False
  Caption = 'ABR 11 Recording'
  ClientHeight = 448
  ClientWidth = 867
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  DesignSize = (
    867
    448)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 72
    Height = 13
    Caption = 'Frequency (Hz)'
  end
  object Label2: TLabel
    Left = 96
    Top = 16
    Width = 84
    Height = 13
    Caption = 'Intensity (dB SPL)'
  end
  object Label3: TLabel
    Left = 8
    Top = 426
    Width = 46
    Height = 16
    Anchors = [akLeft, akBottom]
    Caption = 'Notes:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Chart1: TChart
    Left = 185
    Top = 0
    Width = 682
    Height = 419
    BackWall.Brush.Color = clWhite
    BackWall.Color = clWhite
    Legend.Visible = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    OnUndoZoom = Chart1UndoZoom
    BottomAxis.LabelStyle = talValue
    View3D = False
    BevelOuter = bvSpace
    Color = clWhite
    TabOrder = 0
    Anchors = [akLeft, akTop, akRight, akBottom]
    DesignSize = (
      682
      419)
    object Label_chart: TLabel
      Left = 462
      Top = 402
      Width = 27
      Height = 13
      Anchors = [akRight, akBottom]
      Caption = 'Noise'
    end
    object Memo1: TMemo
      Left = 168
      Top = 208
      Width = 393
      Height = 97
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssVertical
      TabOrder = 0
      Visible = False
    end
    object Series1: TFastLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = 8421440
      LinePen.Color = 8421440
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TFastLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = 64
      LinePen.Color = 64
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series3: TFastLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      LinePen.Color = clRed
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series4: TFastLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clMaroon
      LinePen.Color = clMaroon
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series5: TFastLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = 4194368
      LinePen.Color = 4194368
      LinePen.Width = 2
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object TreeView1: TTreeView
    Left = 8
    Top = 96
    Width = 169
    Height = 283
    Anchors = [akLeft, akTop, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    HotTrack = True
    Indent = 19
    ParentFont = False
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = False
    SortType = stText
    TabOrder = 1
    OnClick = TreeView1Click
    OnContextPopup = TreeView1ContextPopup
  end
  object ComboBox1: TComboBox
    Left = 96
    Top = 32
    Width = 81
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = '70'
    OnKeyDown = ComboBox1KeyDown
    Items.Strings = (
      '90'
      '85'
      '80'
      '75'
      '70'
      '65'
      '60'
      '55'
      '50'
      '45'
      '40'
      '35'
      '30'
      '25'
      '20'
      '15'
      '10'
      '5'
      '0')
  end
  object ComboBox2: TComboBox
    Left = 8
    Top = 32
    Width = 81
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = '0'
    OnKeyDown = ComboBox1KeyDown
    Items.Strings = (
      '0'
      '100'
      '200'
      '300'
      '400'
      '500'
      '700'
      '1000'
      '1500'
      '2000'
      '3000'
      '4000'
      '5000'
      '6000'
      '8000')
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 64
    Width = 89
    Height = 25
    Caption = 'Add'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 104
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Remove'
    TabOrder = 5
    OnClick = BitBtn2Click
  end
  object Edit1: TEdit
    Left = 64
    Top = 426
    Width = 799
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    MaxLength = 240
    TabOrder = 6
  end
  object Start_ABR_Button: TButton
    Left = 8
    Top = 386
    Width = 121
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Start Recording'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = Start_ABR_ButtonClick
  end
  object ButtonTest: TButton
    Left = 136
    Top = 386
    Width = 41
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = 'Test'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = ButtonTestClick
  end
  object MainMenu1: TMainMenu
    Left = 304
    Top = 48
    object File1: TMenuItem
      Caption = '&File'
      object Save1: TMenuItem
        Caption = '&Save'
        Visible = False
      end
      object Load1: TMenuItem
        Caption = '&Open'
        OnClick = Load1Click
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
    object Settings1: TMenuItem
      Caption = 'Settings'
      object TDT1: TMenuItem
        Caption = 'TDT settings'
        OnClick = TDT1Click
      end
      object Savetest1: TMenuItem
        Caption = 'Save test'
        OnClick = Savetest1Click
      end
      object Loadtest1: TMenuItem
        Caption = 'Load test'
        OnClick = Loadtest1Click
      end
      object TestCalibration1: TMenuItem
        Caption = 'Calibration'
        OnClick = TestCalibration1Click
      end
    end
    object Log1: TMenuItem
      Caption = '&Log'
      object Addcomment1: TMenuItem
        Caption = 'Add comment'
        OnClick = Addcomment1Click
      end
      object EditLogfile1: TMenuItem
        Caption = 'Edit Logfile'
        OnClick = EditLogfile1Click
      end
      object NewLogfile1: TMenuItem
        Caption = 'New Logfile'
        OnClick = NewLogfile1Click
      end
    end
  end
  object SaveDialogMeas: TSaveDialog
    DefaultExt = 'CSV'
    Filter = 'CSV Files|*.CSV|AB3 Files|*.AB3|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save Data'
    Left = 336
    Top = 48
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ABS'
    FileName = 'MyTest'
    Filter = 'ABR System file|*.ABS'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 144
    Top = 296
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ABS'
    Filter = 'ABR Test File|*.ABS'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Load Test Setup'
    Left = 112
    Top = 296
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 80
    Top = 296
  end
  object Ti_Next_meas: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Ti_Next_measTimer
    Left = 48
    Top = 296
  end
  object SaveDialog2: TSaveDialog
    Left = 16
    Top = 296
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    AutoPopup = False
    Left = 272
    Top = 48
    object Testing1: TMenuItem
      Caption = 'Testing'
    end
  end
end
