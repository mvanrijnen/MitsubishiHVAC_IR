object frmMHIHVACMain: TfrmMHIHVACMain
  Left = 0
  Top = 0
  Caption = 'MHI HVAC Control'
  ClientHeight = 460
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object rgOperation: TRadioGroup
    Left = 24
    Top = 22
    Width = 120
    Height = 60
    Caption = ' Operation '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'On'
      'Off')
    TabOrder = 0
  end
  object rgMode: TRadioGroup
    Left = 168
    Top = 22
    Width = 264
    Height = 60
    HelpContext = -1
    Caption = 'Mode '
    Columns = 4
    ItemIndex = 0
    Items.Strings = (
      'Auto'
      'Cold'
      'Dry'
      'Heat')
    TabOrder = 1
  end
  object rgHorizontal: TRadioGroup
    Left = 312
    Top = 104
    Width = 120
    Height = 180
    Caption = ' Horizontal '
    ItemIndex = 5
    Items.Strings = (
      'Left End'
      'Left'
      'Middle'
      'Right'
      'Right End'
      'Swing')
    TabOrder = 2
  end
  object rgFanSpeed: TRadioGroup
    Left = 26
    Top = 104
    Width = 120
    Height = 210
    Caption = ' Fan Speed '
    ItemIndex = 0
    Items.Strings = (
      'Auto'
      'Speed 1'
      'Speed 2'
      'Speed 3'
      'Speed 4'
      'Speed 5'
      'Silent')
    TabOrder = 3
  end
  object rgVertical: TRadioGroup
    Left = 168
    Top = 104
    Width = 120
    Height = 210
    Caption = ' Vertical '
    ItemIndex = 6
    Items.Strings = (
      'Auto'
      'H 1'
      'H 2'
      'H 3'
      'H 4'
      'H 5'
      'Swing')
    TabOrder = 4
  end
  object rgDataFormat: TRadioGroup
    Left = 26
    Top = 336
    Width = 406
    Height = 97
    Caption = ' DataFormat '
    Columns = 2
    Items.Strings = (
      'Pure IR HexCodes'
      'Pure IR ByteList'
      'Broadlink HexCodes'
      'Broadlink ByteList')
    TabOrder = 5
  end
end
