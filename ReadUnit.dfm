object ReadForm: TReadForm
  Left = 258
  Top = 119
  AutoScroll = False
  Caption = 'ReadForm'
  ClientHeight = 558
  ClientWidth = 1039
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1039
    558)
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 8
    Top = 544
    Width = 23
    Height = 13
    Anchors = [akBottom]
    Caption = 'PP ='
  end
  object Chart1: TChart
    Left = 168
    Top = -3
    Width = 873
    Height = 564
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    MarginLeft = 7
    Title.Text.Strings = (
      '')
    OnClickSeries = Chart1ClickSeries
    OnUndoZoom = Chart1UndoZoom
    BottomAxis.LabelStyle = talValue
    LeftAxis.AxisValuesFormat = '#,##0.#####'
    LeftAxis.LabelStyle = talValue
    View3D = False
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    Anchors = [akLeft, akTop, akRight, akBottom]
    object Series15: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clSilver
      ShowInLegend = False
      Title = 'Series14'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series14: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clPurple
      ShowInLegend = False
      Title = 'Series13'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series13: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clOlive
      ShowInLegend = False
      Title = 'Series12'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series12: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clGreen
      ShowInLegend = False
      Title = 'Series11'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series11: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clLime
      ShowInLegend = False
      Title = 'Series10'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series10: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clMaroon
      ShowInLegend = False
      Title = 'Series9'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series9: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clNavy
      ShowInLegend = False
      Title = 'Series8'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series8: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clTeal
      ShowInLegend = False
      Title = 'Series7'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series7: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clFuchsia
      ShowInLegend = False
      Title = 'Series6'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series6: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clGray
      ShowInLegend = False
      Title = 'Series5'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series5: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clBlue
      ShowInLegend = False
      Title = 'Series4'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series4: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = 4210816
      ShowInLegend = False
      Title = 'Series3'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series3: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = clGreen
      ShowInLegend = False
      Title = 'Series2'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ShowInLegend = False
      Title = 'Series1'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series1: TLineSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      SeriesColor = 16512
      ShowInLegend = False
      Title = 'Series0'
      LinePen.Color = clWhite
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series16: TPointSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ShowInLegend = False
      ClickableLine = False
      Pointer.Brush.Color = clBlack
      Pointer.InflateMargins = True
      Pointer.Pen.Color = 64
      Pointer.Style = psDownTriangle
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series17: TPointSeries
      Marks.Callout.Brush.Color = clBlack
      Marks.Visible = False
      ShowInLegend = False
      ClickableLine = False
      Pointer.Brush.Color = clBlack
      Pointer.InflateMargins = True
      Pointer.Style = psTriangle
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Memo1: TMemo
    Left = 160
    Top = 448
    Width = 761
    Height = 113
    TabOrder = 1
    Visible = False
  end
  object TreeView1: TTreeView
    Left = 8
    Top = 8
    Width = 145
    Height = 521
    Anchors = [akLeft, akTop, akBottom]
    Indent = 19
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ReadOnly = True
    ShowHint = False
    SortType = stText
    StateImages = ImageList1
    TabOrder = 2
    OnChanging = TreeView1Changing
    OnClick = TreeView1Click
    OnDblClick = TreeView1DblClick
    OnExpanding = TreeView1Expanding
  end
  object Edit1: TEdit
    Left = 56
    Top = 1083
    Width = 983
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    Visible = False
  end
  object ScrollBar1: TScrollBar
    Left = 16
    Top = 504
    Width = 121
    Height = 17
    PageSize = 0
    TabOrder = 4
    Visible = False
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 464
    object File1: TMenuItem
      Caption = '&File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = '&Save'
        Visible = False
        OnClick = Save1Click
      end
      object SaveImage1: TMenuItem
        Caption = 'Save Image'
        OnClick = SaveImage1Click
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        Visible = False
        OnClick = Exit1Click
      end
      object Setup1: TMenuItem
        Caption = 'Setup'
        OnClick = Setup1Click
      end
      object OpenRAW1: TMenuItem
        Caption = 'Open RAW'
        OnClick = OpenRAW1Click
      end
      object ConvertAB3toCSV1: TMenuItem
        Caption = 'Convert AB3 to CSV'
        OnClick = ConvertAB3toCSV1Click
      end
    end
    object Directory1: TMenuItem
      Caption = 'Directory'
      object Load1: TMenuItem
        Caption = 'Load'
        OnClick = Load1Click
      end
      object Save2: TMenuItem
        Caption = 'Save'
        Enabled = False
        OnClick = Save2Click
      end
      object Make1: TMenuItem
        Caption = 'Make'
        OnClick = Make1Click
      end
      object Export1: TMenuItem
        Caption = 'Export Peak Dif'
        Enabled = False
        OnClick = Export1Click
      end
      object ExportLatency1: TMenuItem
        Caption = 'Export Latency'
        Enabled = False
        OnClick = Export1Click
      end
      object ExportPeakDD1: TMenuItem
        Caption = 'Export Peak DD'
        Enabled = False
        OnClick = Export1Click
      end
      object ExportSNR1: TMenuItem
        Caption = 'Export SNR'
        Enabled = False
        OnClick = Export1Click
      end
      object ExportXcorr1: TMenuItem
        Caption = 'Export Xcorr'
        Enabled = False
        OnClick = Export1Click
      end
      object ExportXcorrF1: TMenuItem
        Caption = 'Export XcorrF'
        Enabled = False
        OnClick = Export1Click
      end
      object ExportJewett1: TMenuItem
        Caption = 'Export Jewett latency'
        OnClick = ExportJewett1Click
      end
      object ExportJewettamp1: TMenuItem
        Caption = 'Export Jewett amp'
        OnClick = ExportJewettamp1Click
      end
    end
    object LPFilter1: TMenuItem
      Caption = 'LP Filter'
      object None1: TMenuItem
        Caption = 'None'
        GroupIndex = 8
        RadioItem = True
        OnClick = None1Click
      end
      object N40001: TMenuItem
        Caption = '4000'
        GroupIndex = 8
        RadioItem = True
        OnClick = None1Click
      end
      object N35001: TMenuItem
        Caption = '3500'
        GroupIndex = 8
        RadioItem = True
        OnClick = None1Click
      end
      object N30001: TMenuItem
        Caption = '3000'
        GroupIndex = 8
        RadioItem = True
        OnClick = None1Click
      end
      object N25001: TMenuItem
        Caption = '2500'
        GroupIndex = 8
        RadioItem = True
        OnClick = None1Click
      end
      object N20001: TMenuItem
        Caption = '2000'
        GroupIndex = 8
        RadioItem = True
        OnClick = None1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ABR'
    Filter = 'CSV Files|*.CSV|AB2 Files|*.AB2|AB Files|*.AB*|All Files|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 88
    Top = 464
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'WMF'
    FileName = 'Test_2000'
    Filter = 
      'Windows Metafile|*.WMF|Enhanced Metafile|*.EMF|Bitmap|*.BMP|All ' +
      'Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 54
    Top = 464
  end
  object ImageList1: TImageList
    Left = 56
    Top = 432
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EEEEEE00B6B6B6007D7D7D0098989800DEDEDE00FDFDFD00000000000000
      00000000000000000000000000000000000000000000FCFCFF00FCFCFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000F3F3
      FF00F3F3FF00FCFCFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F5F5
      F500A1A1A10025252500060606001010100071717100E8E8E800FEFEFE000000
      000000000000000000000000000000000000EAEAFE00BBBBFD00C0C0FD00ECEC
      FE0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FBFBFF00CBCBFD007373
      FB007D7DFB00D5D5FE00FDFDFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FDFDFD00C2C2
      C200323232000303030002020200010101001212120094949400F1F1F1000000
      0000000000000000000000000000000000009696FC002828F9003131F900ADAD
      FD00F8F8FF00FFFFFF00FFFFFF00FFFFFF00FDFDFF00D2D2FE004444FA001313
      F8001717F8009090FC00F9F9FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7E7E7005C5C
      5C00050505000202020014141400050505000101010023232300ABABAB00F5F5
      F500000000000000000000000000000000005151FA001010F8001212F8004A4A
      FA00C4C4FD00F3F3FF000000000000000000E8E8FE006161FA001313F8001010
      F8001C1CF800ABABFD00FBFBFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F9F9F900A5A5A5001515
      15000000000018181800828282003A3A3A00020202000202020035353500C1C1
      C100FBFBFB000000000000000000000000007272FB001212F8001010F8001717
      F8004A4AFA00A0A0FC00E6E6FE00E9E9FE008787FB001818F8001010F8001212
      F8005050FA00E2E2FE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE00EBEBEB00606060000303
      03000707070065656500E7E7E700B2B2B2002828280003030300070707005D5D
      5D00E0E0E000FEFEFE000000000000000000BABAFD002A2AF9001111F8001313
      F8001313F8003131F9007C7CFB007C7CFB001E1EF8001111F8001010F8002929
      F900BBBBFD00FBFBFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFD00D9D9D9004F4F4F001414
      140056565600D4D4D400FEFEFE00F1F1F1008585850010101000020202001414
      140097979700F5F5F5000000000000000000EEEEFF007272FB001515F8001111
      F8001818F8001C1CF8001E1EF8001717F8001010F8001010F8001D1DF8009191
      FC00F3F3FF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EBEBEB00A6A6A6008585
      8500D3D3D300FDFDFD0000000000FDFDFD00D2D2D2004C4C4C00070707000505
      050049494900D7D7D700FDFDFD0000000000FDFDFF00D5D5FE004C4CFA001414
      F8001111F8001414F8001111F8001010F8001010F8001313F8006161FA00E9E9
      FE0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFCFC00F2F2F200EDED
      ED00FAFAFA00000000000000000000000000F8F8F800AEAEAE00202020000303
      03001313130099999900F9F9F90000000000FFFFFF00FAFAFF00C3C3FD004E4E
      FA001414F8001010F8001010F8001010F8001010F8001919F8006E6EFB00C2C2
      FD00EAEAFE00F8F8FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE000000000000000000000000000000000000000000ECECEC00686868000505
      05000202020052525200E6E6E60000000000FFFFFF00FCFCFF00E7E7FE008080
      FB001A1AF8001010F8001010F8001010F8001010F8001212F8001919F8003333
      F9006161FA00A6A6FC00E7E7FE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FDFDFD00B5B5B5001A1A
      1A000101010024242400C4C4C40000000000F3F3FF00C4C4FD007A7AFB002828
      F9001111F8001010F8001111F8001313F8001212F8001111F8001212F8001111
      F8001414F8002626F9009090FC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7E7E7004F4F
      4F000303030018181800AAAAAA0000000000DCDCFE006363FA001F1FF8001313
      F8001111F8001212F8002727F9006B6BFB005757FA002424F9001313F8001111
      F8001313F8001212F8005252FA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FAFAFA009B9B
      9B00202020003A3A3A00C1C1C10000000000EAEAFE008A8AFC002424F9001111
      F8001212F8002222F9008A8AFC00E5E5FE00E1E1FE00ABABFD007474FB004A4A
      FA003E3EF9005C5CFA00B3B3FD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FEFEFE00E7E7
      E700B1B1B100C1C1C100EFEFEF0000000000FAFAFF00C3C3FD004646FA001E1E
      F8003E3EF9009494FC00E5E5FE00FDFDFF0000000000FCFCFF00F1F1FF00DCDC
      FE00D7D7FE00E9E9FE00F9F9FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00FBFBFB00FDFDFD00000000000000000000000000F2F2FF00C4C4FD00A3A3
      FC00CBCBFD00F2F2FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FDFD
      FF00FDFDFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000F03F902100000000
      E01F080100000000C01F000100000000C00F0301000000008007000300000000
      0003000100000000000300010000000082010009000000008701000300000000
      EF81000100000000FF81000100000000FFC1000100000000FFC1000100000000
      FFC1008100000000FFE382050000000000000000000000000000000000000000
      000000000000}
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = 'AB3'
    Filter = 'ABR files|*.AB3|Dir Data|*.AB4|All Files|*.*|CSV files|*.CSV'
    FilterIndex = 4
    Left = 88
    Top = 400
  end
  object SaveDialog2: TSaveDialog
    Filter = 'Dir Data|*.AB4|ABR Data|*.AB*|All Files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 56
    Top = 400
  end
  object PopupMenu1: TPopupMenu
    Left = 88
    Top = 432
    object Show1: TMenuItem
      Caption = 'Show'
      OnClick = Show1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
  end
end
