object frmMHIHVACMain: TfrmMHIHVACMain
  Left = 0
  Top = 0
  Caption = 'MHI HVAC Control'
  ClientHeight = 543
  ClientWidth = 1090
  Color = clBtnFace
  Constraints.MinHeight = 582
  Constraints.MinWidth = 1106
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    1090
    543)
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
    Width = 1054
    Height = 363
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Output '
    TabOrder = 5
    ExplicitHeight = 362
    object pcOutput: TPageControl
      Left = 2
      Top = 17
      Width = 1050
      Height = 344
      ActivePage = tabOutputText
      Align = alClient
      TabOrder = 0
      ExplicitHeight = 355
      object tabOutputText: TTabSheet
        Caption = 'Text'
        DesignSize = (
          1042
          314)
        object rgDataFormat: TRadioGroup
          Left = 10
          Top = 3
          Width = 399
          Height = 86
          Caption = ' DataFormat '
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            'Pure IR HexCodes'
            'Pure IR ByteList'
            'Broadlink HexCodes'
            'Broadlink ByteList'
            'Broadlink Base64')
          TabOrder = 0
          OnClick = rgDataFormatClick
        end
        object mmoText: TMemo
          Left = 10
          Top = 95
          Width = 1029
          Height = 207
          Anchors = [akLeft, akTop, akRight, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Consolas'
          Font.Style = []
          Lines.Strings = (
            'mmoBroadlinkHex')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 1
          WordWrap = False
        end
        object Button1: TButton
          Left = 415
          Top = 16
          Width = 75
          Height = 25
          Caption = '&Copy'
          TabOrder = 2
          OnClick = Button1Click
        end
        object gbGenerate: TGroupBox
          Left = 496
          Top = 3
          Width = 543
          Height = 86
          Caption = ' Generate '
          TabOrder = 3
          object Label1: TLabel
            Left = 412
            Top = 47
            Width = 55
            Height = 15
            Caption = 'Max Temp'
          end
          object lblMinTemp: TLabel
            Left = 414
            Top = 22
            Width = 53
            Height = 15
            Caption = 'Min Temp'
          end
          object btnGenerate: TButton
            Left = 11
            Top = 20
            Width = 118
            Height = 45
            Caption = '&Generate all'
            TabOrder = 0
            OnClick = btnGenerateClick
          end
          object cbFixedMode: TCheckBox
            Left = 144
            Top = 20
            Width = 89
            Height = 17
            Caption = 'Fixed Mode'
            TabOrder = 1
          end
          object cbFixedFanSpeed: TCheckBox
            Left = 144
            Top = 43
            Width = 97
            Height = 17
            Caption = 'Fixed Fanspeed'
            TabOrder = 2
          end
          object cbFixedHor: TCheckBox
            Left = 273
            Top = 20
            Width = 114
            Height = 17
            Caption = 'Fixed horizontal'
            TabOrder = 3
          end
          object cbFixedVert: TCheckBox
            Left = 273
            Top = 43
            Width = 88
            Height = 17
            Caption = 'Fixed vertical'
            TabOrder = 4
          end
          object edtMinTemp: TSpinEdit
            Left = 473
            Top = 17
            Width = 48
            Height = 24
            MaxValue = 31
            MinValue = 16
            TabOrder = 5
            Value = 16
          end
          object edtMaxTemp: TSpinEdit
            Left = 473
            Top = 47
            Width = 48
            Height = 24
            MaxValue = 31
            MinValue = 16
            TabOrder = 6
            Value = 31
          end
        end
      end
      object tabOutputBroadlink: TTabSheet
        Caption = 'Broadlink'
        ImageIndex = 1
        DesignSize = (
          1042
          314)
        object mmoBroadlinkHex: TMemo
          Left = 3
          Top = 0
          Width = 1036
          Height = 102
          Anchors = [akLeft, akTop, akRight, akBottom]
          Lines.Strings = (
            'mmoBroadlinkHex')
          ReadOnly = True
          TabOrder = 0
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
