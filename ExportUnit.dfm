object ExportForm: TExportForm
  Left = 387
  Top = 174
  AutoScroll = False
  Caption = 'ExportForm'
  ClientHeight = 537
  ClientWidth = 854
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    854
    537)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 232
    Width = 78
    Height = 16
    Caption = 'Noise Limit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 32
    Top = 208
    Width = 71
    Height = 16
    Caption = 'Threshold'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 32
    Top = 184
    Width = 175
    Height = 16
    Caption = 'Significans Threshold: ??'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StringGrid1: TStringGrid
    Left = 24
    Top = 264
    Width = 817
    Height = 263
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 22
    DefaultRowHeight = 20
    RowCount = 20
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 0
    OnClick = StringGrid1Click
  end
  object Chart1: TChart
    Left = 288
    Top = 8
    Width = 545
    Height = 242
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BackWall.Color = clWhite
    Title.Text.Strings = (
      'Correlation Data')
    View3D = False
    Color = clWhite
    TabOrder = 1
    Anchors = [akLeft, akTop, akRight]
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
    object Series2: TPointSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Length = 8
      Marks.Visible = False
      ClickableLine = False
      Pointer.HorizSize = 3
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 3
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series3: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = 4194368
      ShowInLegend = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series5: TPointSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Style = smsXValue
      Marks.Visible = True
      SeriesColor = clNavy
      ShowInLegend = False
      ValueFormat = '#,##0.#'
      ClickableLine = False
      Pointer.InflateMargins = True
      Pointer.Style = psDiagCross
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series6: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clBlack
      ShowInLegend = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 257
    Height = 49
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object ComboBox1: TComboBox
    Left = 128
    Top = 232
    Width = 137
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = '1'
  end
  object ComboBox2: TComboBox
    Left = 128
    Top = 208
    Width = 137
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = '1'
  end
  object Chart2: TChart
    Left = 8
    Top = 64
    Width = 257
    Height = 113
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Legend.Visible = False
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    View3D = False
    Color = clWhite
    TabOrder = 5
    object Series4: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      Pointer.HorizSize = 3
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 3
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object MainMenu1: TMainMenu
    Left = 480
    Top = 304
    object File1: TMenuItem
      Caption = '&File'
      object CopytoClipboard1: TMenuItem
        Caption = 'Copy to Clipboard'
        OnClick = CopytoClipboard1Click
      end
    end
    object Action1: TMenuItem
      Caption = '&Action'
      object Calculate1: TMenuItem
        Caption = 'Calculate'
        OnClick = Calculate1Click
      end
      object Calculateall1: TMenuItem
        Caption = 'Calculate all'
        OnClick = Calculateall1Click
      end
      object Compact1: TMenuItem
        Caption = 'Compact'
        OnClick = Compact1Click
      end
    end
  end
end
