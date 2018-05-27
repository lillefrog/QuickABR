object MakeStimForm: TMakeStimForm
  Left = 739
  Top = 430
  AutoScroll = False
  Caption = 'MakeStim'
  ClientHeight = 548
  ClientWidth = 684
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
  DesignSize = (
    684
    548)
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 104
    Top = 96
    Width = 56
    Height = 13
    Caption = 'Sample rate'
  end
  object Label4: TLabel
    Left = 104
    Top = 32
    Width = 42
    Height = 13
    Caption = 'Filename'
  end
  object Panel1: TPanel
    Left = 424
    Top = 8
    Width = 257
    Height = 145
    TabOrder = 0
    object Label5: TLabel
      Left = 8
      Top = 80
      Width = 102
      Height = 16
      Caption = 'Frequency(Hz)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 36
      Width = 127
      Height = 16
      Caption = 'Rise/Fall time(ms)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 0
      Width = 89
      Height = 16
      Caption = 'Duration(ms)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 8
      Top = 96
      Width = 22
      Height = 13
      Caption = 'Start'
      Visible = False
    end
    object Label2: TLabel
      Left = 128
      Top = 96
      Width = 19
      Height = 13
      Caption = 'End'
      Visible = False
    end
    object Bt_Calculate_Stim: TButton
      Left = 144
      Top = 16
      Width = 65
      Height = 25
      Caption = 'Make'
      TabOrder = 0
      OnClick = Bt_Calculate_StimClick
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 112
      Width = 89
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = '1000'
      OnChange = ComboBox3Change
      Items.Strings = (
        '200'
        '500'
        '700'
        '1000'
        '2000'
        '4000'
        '6000'
        '8000')
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 52
      Width = 89
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = '1'
      OnChange = ComboBox3Change
      Items.Strings = (
        '0,5'
        '1'
        '2'
        '3'
        '4'
        '6'
        '8')
    end
    object ComboBox3: TComboBox
      Left = 8
      Top = 16
      Width = 89
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Text = '5'
      OnChange = ComboBox3Change
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6')
    end
    object ComboBox4: TComboBox
      Left = 128
      Top = 112
      Width = 89
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      Text = '4000'
      Visible = False
      OnChange = ComboBox3Change
      Items.Strings = (
        '200'
        '500'
        '700'
        '1000'
        '2000'
        '4000'
        '6000'
        '8000')
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 160
    Width = 697
    Height = 393
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Spectrum'
      object Chart2: TChart
        Left = 0
        Top = 0
        Width = 689
        Height = 365
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Legend.Visible = False
        Title.Text.Strings = (
          'Power Spectrum')
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.Logarithmic = True
        BottomAxis.Maximum = 24000.000000000000000000
        BottomAxis.Minimum = 100.000000000000000000
        BottomAxis.MinorTickCount = 8
        BottomAxis.MinorTickLength = 4
        BottomAxis.Title.Caption = 'Frequency (Hz)'
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.MinorTickLength = 3
        View3D = False
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        PopupMenu = PopupMenu1
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
    object TabSheet2: TTabSheet
      Caption = 'Ossilogram'
      ImageIndex = 1
      object Chart3: TChart
        Left = 0
        Top = 0
        Width = 689
        Height = 397
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Legend.Visible = False
        Title.Text.Strings = (
          'Stimulus')
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.Maximum = 24.000000000000000000
        BottomAxis.Title.Caption = 'Time (ms)'
        LeftAxis.Automatic = False
        LeftAxis.AutomaticMaximum = False
        LeftAxis.AutomaticMinimum = False
        LeftAxis.Maximum = 1.100000000000000000
        LeftAxis.Minimum = -1.100000000000000000
        View3D = False
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 0
        object LineSeries3: TLineSeries
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
        object LineSeries4: TLineSeries
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          SeriesColor = 4227072
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
    object TabSheet3: TTabSheet
      Caption = 'Window'
      ImageIndex = 2
      object Chart1: TChart
        Left = 0
        Top = 0
        Width = 689
        Height = 397
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        Legend.Visible = False
        Title.Text.Strings = (
          'Hanning Window')
        BottomAxis.Automatic = False
        BottomAxis.AutomaticMaximum = False
        BottomAxis.AutomaticMinimum = False
        BottomAxis.Maximum = 1024.000000000000000000
        BottomAxis.Title.Caption = 'Sampels'
        View3D = False
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 0
        object LineSeries5: TLineSeries
          Marks.Callout.Brush.Color = clBlack
          Marks.Visible = False
          Title = 'LineSeries1'
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
  object Bt_Load: TButton
    Left = 8
    Top = 16
    Width = 81
    Height = 25
    Caption = 'Load Stim'
    TabOrder = 2
    OnClick = Bt_LoadClick
  end
  object Bt_save: TButton
    Left = 8
    Top = 48
    Width = 81
    Height = 25
    Caption = 'Save Stim'
    Enabled = False
    TabOrder = 3
    OnClick = Bt_saveClick
  end
  object RadioGroup1: TRadioGroup
    Left = 280
    Top = 8
    Width = 137
    Height = 145
    Caption = 'Stimulus type'
    ItemIndex = 0
    Items.Strings = (
      'Burst'
      'Click'
      'Custom'
      'Chirp')
    TabOrder = 4
    OnClick = RadioGroup1Click
  end
  object Bt_Set_Dafault: TButton
    Left = 8
    Top = 80
    Width = 81
    Height = 25
    Caption = 'Set as default'
    TabOrder = 5
    Visible = False
    OnClick = Bt_Set_DafaultClick
  end
  object Edit1: TEdit
    Left = 104
    Top = 48
    Width = 169
    Height = 21
    TabOrder = 6
  end
  object ComboBox5: TComboBox
    Left = 104
    Top = 112
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'Sample Rate'
    OnChange = ComboBox5Change
    Items.Strings = (
      '24414'
      '48828'
      '97656'
      '195312')
  end
  object Button4: TButton
    Left = 200
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 8
    Visible = False
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'AB9'
    Filter = 'Stim Files|*.AB9|All Files|*.*'
    Left = 8
    Top = 120
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Stim files|*.AB9|WAV files|*.wav'
    Left = 40
    Top = 120
  end
  object PopupMenu1: TPopupMenu
    Left = 72
    Top = 120
    object SaveasBitmap1: TMenuItem
      Caption = 'Save as Bitmap'
      OnClick = SaveasBitmap1Click
    end
    object SaveasWMF1: TMenuItem
      Caption = 'Save as WMF'
      OnClick = SaveasBitmap1Click
    end
    object SaveasEMF1: TMenuItem
      Caption = 'Save as EMF'
      OnClick = SaveasBitmap1Click
    end
  end
end
