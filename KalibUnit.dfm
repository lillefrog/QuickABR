object KalibForm: TKalibForm
  Left = 481
  Top = 132
  AutoScroll = False
  Caption = 'KalibForm'
  ClientHeight = 576
  ClientWidth = 552
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    552
    576)
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 0
    Top = 296
    Width = 560
    Height = 284
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Legend.Visible = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    BottomAxis.Title.Caption = 'Frequency (Hz)'
    LeftAxis.Title.Caption = 'Correction (dB)'
    View3D = False
    TabOrder = 0
    Anchors = [akLeft, akTop, akRight, akBottom]
    object Series1: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 561
    Height = 289
    ActivePage = TabSheet6
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    object TabSheet3: TTabSheet
      Caption = 'Calibrate Microphone'
      ImageIndex = 2
      OnExit = Bt_stopClick
      DesignSize = (
        553
        261)
      object GroupBox1: TGroupBox
        Left = 8
        Top = 80
        Width = 489
        Height = 97
        Caption = 'Test Microphone'
        TabOrder = 0
        object dB_label: TLabel
          Left = 297
          Top = 15
          Width = 136
          Height = 66
          Caption = '-,- dB'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -53
          Font.Name = 'Trebuchet MS'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Button6: TButton
          Left = 152
          Top = 24
          Width = 75
          Height = 65
          Caption = 'Stop'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = Bt_stopClick
        end
        object Button5: TButton
          Left = 8
          Top = 24
          Width = 137
          Height = 17
          Caption = 'Test Microphone (1000Hz)'
          TabOrder = 1
          OnClick = Button5Click
        end
        object Button8: TButton
          Left = 8
          Top = 48
          Width = 137
          Height = 17
          Caption = 'Test Acc (159.15Hz)'
          TabOrder = 2
          OnClick = Button8Click
        end
        object Button13: TButton
          Left = 8
          Top = 72
          Width = 137
          Height = 17
          Caption = 'Test Hydrophone (250Hz)'
          TabOrder = 3
          OnClick = Button13Click
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 192
        Width = 369
        Height = 57
        Caption = 'Adjust Microphone'
        TabOrder = 1
        object Edit6: TEdit
          Left = 112
          Top = 20
          Width = 57
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          Text = '0'
        end
        object UpDown1: TUpDown
          Left = 168
          Top = 20
          Width = 17
          Height = 24
          Min = -1000
          Max = 1000
          TabOrder = 1
          OnChangingEx = UpDown1ChangingEx
        end
        object Bt_Apply2: TButton
          Left = 198
          Top = 20
          Width = 75
          Height = 25
          Caption = 'Apply'
          TabOrder = 2
          OnClick = Bt_Apply2Click
        end
      end
      object Memo2: TMemo
        Left = 16
        Top = 8
        Width = 521
        Height = 65
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          
            'Place the microphone in the calibrator and make sure that the ca' +
            'librator and the microphone '
          
            'amplifier is on. Then start the test and verify that the output ' +
            'is the same as written on the kalibrator. If '
          
            'not ajust it until it is the same. If you have to change this nu' +
            'mber without changes to the microphone or '
          
            'amplifier it could be a warning about a bad microphone or low ba' +
            'ttery in the amplifier.')
        ParentColor = True
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Settings'
      ImageIndex = 1
      DesignSize = (
        553
        261)
      object Label5: TLabel
        Left = 304
        Top = 85
        Width = 134
        Height = 20
        Caption = 'Calibration Level'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 16
        Top = 92
        Width = 75
        Height = 13
        Caption = 'Start Frequency'
      end
      object Label6: TLabel
        Left = 16
        Top = 116
        Width = 75
        Height = 13
        Caption = 'Stop Frequency'
      end
      object Label7: TLabel
        Left = 16
        Top = 140
        Width = 49
        Height = 13
        Caption = 'Step size1'
      end
      object Label10: TLabel
        Left = 16
        Top = 164
        Width = 90
        Height = 13
        Caption = 'Change Frequency'
      end
      object Label11: TLabel
        Left = 16
        Top = 188
        Width = 49
        Height = 13
        Caption = 'Step size2'
      end
      object Label14: TLabel
        Left = 304
        Top = 147
        Width = 67
        Height = 20
        Caption = 'Channel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CBox_base: TComboBox
        Left = 304
        Top = 112
        Width = 57
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Text = '60'
        Items.Strings = (
          '94'
          '90'
          '80'
          '70'
          '60'
          '50'
          '40')
      end
      object Edit1: TEdit
        Left = 112
        Top = 88
        Width = 121
        Height = 21
        TabOrder = 1
        Text = '200'
      end
      object Edit2: TEdit
        Left = 112
        Top = 112
        Width = 121
        Height = 21
        TabOrder = 2
        Text = '20000'
      end
      object Edit3: TEdit
        Left = 112
        Top = 135
        Width = 121
        Height = 21
        TabOrder = 3
        Text = '100'
      end
      object Edit4: TEdit
        Left = 112
        Top = 159
        Width = 121
        Height = 21
        TabOrder = 4
        Text = '2000'
      end
      object Edit5: TEdit
        Left = 112
        Top = 183
        Width = 121
        Height = 21
        TabOrder = 5
        Text = '500'
      end
      object Bt_Apply: TButton
        Left = 120
        Top = 216
        Width = 97
        Height = 25
        Caption = 'Apply'
        TabOrder = 6
        OnClick = Bt_ApplyClick
      end
      object Memo3: TMemo
        Left = 16
        Top = 8
        Width = 521
        Height = 65
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          
            'The calibration level is the level that the system will try to g' +
            'et from the loudspeakers. If the level is to '
          
            'high the Loudspeakers can be damaged, but if it is too low the s' +
            'ignal to noise ratio will be too low. ')
        ParentColor = True
        TabOrder = 7
      end
      object ComboBox2: TComboBox
        Left = 305
        Top = 170
        Width = 57
        Height = 21
        ItemHeight = 13
        TabOrder = 8
        Text = '1'
        Items.Strings = (
          '1')
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Multichannel'
      Enabled = False
      DesignSize = (
        553
        261)
      object ComboBox1: TComboBox
        Left = 40
        Top = 119
        Width = 57
        Height = 22
        Style = csOwnerDrawFixed
        ItemHeight = 16
        TabOrder = 0
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15')
      end
      object Button4: TButton
        Left = 128
        Top = 120
        Width = 57
        Height = 21
        Caption = 'channel'
        TabOrder = 1
        OnClick = Button4Click
      end
      object Bt_calibM: TButton
        Left = 216
        Top = 120
        Width = 113
        Height = 21
        Caption = 'Calibrate all channels'
        TabOrder = 2
        OnClick = Bt_calibMClick
      end
      object Memo4: TMemo
        Left = 16
        Top = 8
        Width = 521
        Height = 65
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          
            'This makes it possible to calibrate several loudspeakears at the' +
            ' same time, but it requires a RX6 and a '
          'multiplexer connected to the system to work.')
        ParentColor = True
        TabOrder = 3
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Calibrate'
      ImageIndex = 4
      DesignSize = (
        553
        261)
      object Label3: TLabel
        Left = 264
        Top = 8
        Width = 32
        Height = 13
        Caption = 'Label3'
        Visible = False
      end
      object Label2: TLabel
        Left = 264
        Top = 24
        Width = 32
        Height = 13
        Caption = 'Label2'
        Visible = False
      end
      object Label4: TLabel
        Left = 16
        Top = 49
        Width = 70
        Height = 20
        Caption = 'Errors  0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 328
        Top = 8
        Width = 136
        Height = 66
        Caption = '-,- dB'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -53
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Button1: TButton
        Left = 8
        Top = 12
        Width = 75
        Height = 25
        Caption = 'Calibrate'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 88
        Top = 12
        Width = 75
        Height = 25
        Caption = 'Stop'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 168
        Top = 12
        Width = 75
        Height = 25
        Caption = 'Save'
        TabOrder = 2
        OnClick = Button3Click
      end
      object Memo1: TMemo
        Left = 16
        Top = 80
        Width = 521
        Height = 157
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 3
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Test Calibration'
      ImageIndex = 3
      OnExit = Bt_stopClick
      DesignSize = (
        553
        261)
      object Label15: TLabel
        Left = 320
        Top = 107
        Width = 136
        Height = 66
        Caption = '-,- dB'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -53
        Font.Name = 'Trebuchet MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 32
        Top = 152
        Width = 81
        Height = 20
        Caption = 'Amplitude'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 32
        Top = 184
        Width = 85
        Height = 20
        Caption = 'Frequency'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CBox_dB: TComboBox
        Left = 144
        Top = 152
        Width = 89
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Text = '94'
        Items.Strings = (
          '94'
          '90'
          '80'
          '70'
          '60'
          '50'
          '40'
          '30'
          '20'
          '10')
      end
      object CBox_freq: TComboBox
        Left = 144
        Top = 184
        Width = 89
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        Text = '1000'
      end
      object Bt_stop: TButton
        Left = 406
        Top = 184
        Width = 59
        Height = 25
        Caption = 'Stop'
        TabOrder = 2
        OnClick = Bt_stopClick
      end
      object Bt_start: TButton
        Left = 326
        Top = 184
        Width = 59
        Height = 25
        Caption = 'Start'
        TabOrder = 3
        OnClick = Bt_startClick
      end
      object Button7: TButton
        Left = 32
        Top = 112
        Width = 193
        Height = 25
        Caption = 'Load Calibration File'
        TabOrder = 4
        OnClick = Button7Click
      end
      object Memo5: TMemo
        Left = 16
        Top = 8
        Width = 521
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          
            'This pane makes it possible to test any calibration file. It is ' +
            'good practise to test any calibration file you just '
          
            'made. To test a file, first load it, then choose the amplitude a' +
            'nd frequency you want to test and press start. If '
          
            'the calibration is good the output should be very close to the v' +
            'alue you set. There will be some variation and '
          'one or two dB difference is not unusual.'
          
            'Be aware that the file becomes the default for the system until ' +
            'replaced manually.')
        ParentColor = True
        TabOrder = 5
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Click Calibration'
      ImageIndex = 5
      DesignSize = (
        553
        261)
      object Label13: TLabel
        Left = 16
        Top = 96
        Width = 72
        Height = 13
        Caption = 'Click Amplitude'
      end
      object Label16: TLabel
        Left = 16
        Top = 144
        Width = 73
        Height = 13
        Caption = 'Click correction'
      end
      object Memo6: TMemo
        Left = 16
        Top = 8
        Width = 145
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          'Calibrate the click stimullus ')
        ParentColor = True
        TabOrder = 0
      end
      object Edit7: TEdit
        Left = 16
        Top = 112
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object Button12: TButton
        Left = 88
        Top = 200
        Width = 65
        Height = 25
        Caption = 'Apply'
        TabOrder = 2
        OnClick = Button12Click
      end
      object Bt_test_click: TButton
        Left = 16
        Top = 200
        Width = 65
        Height = 25
        Caption = 'Test'
        TabOrder = 3
        OnClick = Bt_test_clickClick
      end
      object PageControl2: TPageControl
        Left = 168
        Top = 8
        Width = 377
        Height = 241
        ActivePage = TabSheet8
        TabOrder = 4
        object TabSheet8: TTabSheet
          Caption = 'Click'
          object Chart2: TChart
            Left = 0
            Top = 0
            Width = 369
            Height = 209
            BackWall.Brush.Color = clWhite
            BackWall.Brush.Style = bsClear
            Legend.Visible = False
            Title.AdjustFrame = False
            Title.Text.Strings = (
              'TChart')
            Title.Visible = False
            BottomAxis.Axis.Width = 1
            BottomAxis.Axis.Visible = False
            LeftAxis.Axis.Visible = False
            View3D = False
            View3DWalls = False
            BevelOuter = bvNone
            TabOrder = 0
            object Series2: TLineSeries
              Marks.Callout.Brush.Color = clBlack
              Marks.Visible = False
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = False
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
        end
        object TabSheet9: TTabSheet
          Caption = 'Powerspectrum'
          ImageIndex = 1
          object Chart3: TChart
            Left = 0
            Top = 0
            Width = 369
            Height = 209
            BackWall.Brush.Color = clWhite
            BackWall.Brush.Style = bsClear
            Legend.Visible = False
            Title.AdjustFrame = False
            Title.Text.Strings = (
              'TChart')
            Title.Visible = False
            BottomAxis.Axis.Width = 1
            BottomAxis.Axis.Visible = False
            LeftAxis.Axis.Visible = False
            View3D = False
            View3DWalls = False
            BevelOuter = bvNone
            TabOrder = 0
            object LineSeries1: TLineSeries
              Marks.Callout.Brush.Color = clBlack
              Marks.Visible = False
              Pointer.InflateMargins = True
              Pointer.Style = psRectangle
              Pointer.Visible = False
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
            end
          end
        end
      end
      object Bt_clickTest: TButton
        Left = 16
        Top = 232
        Width = 65
        Height = 25
        Caption = 'Run'
        TabOrder = 5
        OnClick = Bt_clickTestClick
      end
      object Edit8: TEdit
        Left = 16
        Top = 160
        Width = 121
        Height = 21
        TabOrder = 6
        Text = '0'
      end
      object Button14: TButton
        Left = 88
        Top = 232
        Width = 65
        Height = 25
        Caption = 'Save'
        TabOrder = 7
        OnClick = Button14Click
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Noise'
      ImageIndex = 6
      DesignSize = (
        553
        261)
      object Memo7: TMemo
        Left = 16
        Top = 8
        Width = 521
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        Lines.Strings = (
          'Measure the bacground noise in the same area as the calibration')
        ParentColor = True
        TabOrder = 0
      end
      object Button9: TButton
        Left = 16
        Top = 96
        Width = 89
        Height = 25
        Caption = 'Measure Noise'
        TabOrder = 1
        OnClick = Button9Click
      end
      object Memo8: TMemo
        Left = 16
        Top = 128
        Width = 521
        Height = 117
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object Button10: TButton
        Left = 208
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Save'
        TabOrder = 3
        OnClick = Button10Click
      end
      object Button11: TButton
        Left = 120
        Top = 96
        Width = 75
        Height = 25
        Caption = 'Stop'
        TabOrder = 4
        OnClick = Button11Click
      end
    end
  end
  object Timer1: TTimer
    Tag = 1
    Enabled = False
    Interval = 1100
    OnTimer = Timer1Timer
    Left = 368
    Top = 288
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 1100
    OnTimer = Timer2Timer
    Left = 400
    Top = 288
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    FileName = 'Calib'
    Filter = 'CSV files|*.csv|TXT files|*.txt|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 472
    Top = 288
  end
  object Timer3: TTimer
    Enabled = False
    Interval = 1100
    OnTimer = Timer3Timer
    Left = 436
    Top = 288
  end
end
