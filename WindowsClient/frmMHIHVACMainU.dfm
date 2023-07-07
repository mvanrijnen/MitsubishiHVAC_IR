object frmMHIHVACMain: TfrmMHIHVACMain
  Left = 0
  Top = 0
  Caption = 'MHI HVAC Control'
  ClientHeight = 542
  ClientWidth = 1166
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1166
    542)
  TextHeight = 15
  object rgOperation: TRadioGroup
    Left = 24
    Top = 22
    Width = 120
    Height = 51
    Caption = ' Operation '
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'On'
      'Off')
    TabOrder = 0
    OnClick = rgOperationClick
  end
  object rgMode: TRadioGroup
    Left = 168
    Top = 22
    Width = 120
    Height = 120
    HelpContext = -1
    Caption = 'Mode '
    ItemIndex = 0
    Items.Strings = (
      'Auto'
      'Cold'
      'Dry'
      'Heat')
    TabOrder = 1
    OnClick = rgModeClick
  end
  object rgHorizontal: TRadioGroup
    Left = 576
    Top = 22
    Width = 240
    Height = 120
    Caption = ' Horizontal '
    Columns = 2
    ItemIndex = 5
    Items.Strings = (
      'Left End'
      'Left'
      'Middle'
      'Right'
      'Right End'
      'Swing')
    TabOrder = 2
    OnClick = rgHorizontalClick
  end
  object rgFanSpeed: TRadioGroup
    Left = 314
    Top = 22
    Width = 240
    Height = 120
    Caption = ' Fan Speed '
    Columns = 2
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
    OnClick = rgFanSpeedClick
  end
  object rgVertical: TRadioGroup
    Left = 838
    Top = 22
    Width = 240
    Height = 120
    Caption = ' Vertical '
    Columns = 2
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
    OnClick = rgVerticalClick
  end
  object gbOutput: TGroupBox
    Left = 24
    Top = 160
    Width = 1118
    Height = 362
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Output '
    TabOrder = 5
    object pcOutput: TPageControl
      Left = 2
      Top = 17
      Width = 1114
      Height = 343
      ActivePage = tabOutputBroadlink
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 1050
      ExplicitHeight = 355
      object tabOutputText: TTabSheet
        Caption = 'Text'
        DesignSize = (
          1106
          313)
        object rgDataFormat: TRadioGroup
          Left = 10
          Top = 3
          Width = 319
          Height = 86
          Caption = ' DataFormat '
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Pure IR HexCodes'
            'Pure IR ByteList'
            'Broadlink HexCodes'
            'Broadlink ByteList')
          TabOrder = 0
          OnClick = rgDataFormatClick
        end
        object mmoText: TMemo
          Left = 10
          Top = 95
          Width = 1093
          Height = 206
          Anchors = [akLeft, akTop, akRight, akBottom]
          Lines.Strings = (
            'mmoBroadlinkHex')
          ReadOnly = True
          TabOrder = 1
          ExplicitWidth = 1029
          ExplicitHeight = 218
        end
      end
      object tabOutputBroadlink: TTabSheet
        Caption = 'Broadlink'
        ImageIndex = 1
        DesignSize = (
          1106
          313)
        object mmoBroadlinkHex: TMemo
          Left = 3
          Top = 0
          Width = 1100
          Height = 101
          Anchors = [akLeft, akTop, akRight, akBottom]
          Lines.Strings = (
            'mmoBroadlinkHex')
          ReadOnly = True
          TabOrder = 0
          ExplicitWidth = 1036
          ExplicitHeight = 113
        end
      end
    end
  end
  object gbTemperature: TGroupBox
    Left = 24
    Top = 88
    Width = 120
    Height = 54
    Caption = ' Temperature '
    TabOrder = 6
    object edtTemperature: TSpinEdit
      Left = 25
      Top = 18
      Width = 56
      Height = 30
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxValue = 31
      MinValue = 16
      ParentFont = False
      TabOrder = 0
      Value = 21
      OnChange = edtTemperatureChange
    end
  end
end
