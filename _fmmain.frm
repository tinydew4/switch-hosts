object fmMain: TfmMain
  Left = 432
  Height = 480
  Top = 180
  Width = 640
  Caption = 'Switch hosts'
  ClientHeight = 480
  ClientWidth = 640
  Position = poWorkAreaCenter
  LCLVersion = '6.7'
  object LbHosts: TListBox
    Left = 0
    Height = 480
    Top = 0
    Width = 100
    Align = alLeft
    ItemHeight = 0
    OnDblClick = LbHostsDblClick
    TabOrder = 0
  end
  object MmHosts: TMemo
    Left = 100
    Height = 480
    Top = 0
    Width = 540
    Align = alClient
    Font.CharSet = HANGEUL_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = '굴림체'
    Font.Pitch = fpFixed
    Font.Quality = fqDraft
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssAutoBoth
    TabOrder = 1
    WordWrap = False
  end
  object TmBatch: TTimer
    Interval = 100
    OnTimer = TmBatchTimer
    Left = 16
    Top = 8
  end
end
