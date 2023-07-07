unit frmMHIHVACMainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Mitsubishi_HVAC;

type
  TfrmMHIHVACMain = class(TForm)
    rgOperation: TRadioGroup;
    rgMode: TRadioGroup;
    rgHorizontal: TRadioGroup;
    rgFanSpeed: TRadioGroup;
    rgVertical: TRadioGroup;
    gbOutput: TGroupBox;
    pcOutput: TPageControl;
    tabOutputText: TTabSheet;
    tabOutputBroadlink: TTabSheet;
    rgDataFormat: TRadioGroup;
    mmoBroadlinkHex: TMemo;
    mmoText: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rgOperationClick(Sender: TObject);
    procedure rgModeClick(Sender: TObject);
    procedure rgFanSpeedClick(Sender: TObject);
    procedure rgHorizontalClick(Sender: TObject);
    procedure rgVerticalClick(Sender: TObject);
    procedure rgDataFormatClick(Sender: TObject);
  private
    { Private declarations }
    fhmihvac : TMHI_HVAC_BroadLink;
    procedure UpdateFromUI;
  public
    { Public declarations }
  end;

var
  frmMHIHVACMain: TfrmMHIHVACMain;

implementation

{$R *.dfm}

function SplitLen(const AValue : string; const APartLen : Integer; const ASeperator : Char = ' ') : string;
var
  i : integer;
begin
  Result := '';
  i := 0;
  while ((i+APartLen)<AValue.Length) do
  begin
    Result := Result + AValue.Substring(i, APartLen) + ASeperator;
    i := i + APartLen;
  end;
  Result := Result.TrimRight([ASeperator]);
end;


{ TfrmMHIHVACMain }

procedure TfrmMHIHVACMain.FormCreate(Sender: TObject);
begin
  fhmihvac := TMHI_HVAC_BroadLink.Create();
  pcOutput.ActivePage := tabOutputBroadlink;
  UpdateFromUI();
end;

procedure TfrmMHIHVACMain.FormDestroy(Sender: TObject);
begin
  fhmihvac.Free;
end;

procedure TfrmMHIHVACMain.rgDataFormatClick(Sender: TObject);
begin
  UpdateFromUI();
end;

procedure TfrmMHIHVACMain.rgFanSpeedClick(Sender: TObject);
begin
  UpdateFromUI();
end;

procedure TfrmMHIHVACMain.rgHorizontalClick(Sender: TObject);
begin
  UpdateFromUI();
end;

procedure TfrmMHIHVACMain.rgModeClick(Sender: TObject);
begin
  UpdateFromUI();
end;

procedure TfrmMHIHVACMain.rgOperationClick(Sender: TObject);
begin
  UpdateFromUI();
end;

procedure TfrmMHIHVACMain.rgVerticalClick(Sender: TObject);
begin
  UpdateFromUI();
end;

procedure TfrmMHIHVACMain.UpdateFromUI;
begin
  fhmihvac.BeginUpdate;
  try
    case rgOperation.ItemIndex of
      0 : fhmihvac.OnOff := TMHI_HVAC_ONOFF.On;
      1 : fhmihvac.OnOff := TMHI_HVAC_ONOFF.Off;
    end;

    case rgMode.ItemIndex of
      0 : fhmihvac.Mode := TMHI_HVAC_MODE.Auto;
      1 : fhmihvac.Mode := TMHI_HVAC_MODE.Cold;
      2 : fhmihvac.Mode := TMHI_HVAC_MODE.Dry;
      3 : fhmihvac.Mode := TMHI_HVAC_MODE.Hot;
    end;

    case rgFanSpeed.ItemIndex of
      0 : fhmihvac.Fan := TMHI_HVAC_Fan.Auto;
      1 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed1;
      2 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed2;
      3 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed3;
      4 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed4;
      5 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed5;
      6 : fhmihvac.Fan := TMHI_HVAC_Fan.Silent;
    end;

    case rgHorizontal.ItemIndex of
      0 : fhmihvac.Wide := TMHI_HVAC_Wide.LeftEnd;
      1 : fhmihvac.Wide := TMHI_HVAC_Wide.Left;
      2 : fhmihvac.Wide := TMHI_HVAC_Wide.Middle;
      3 : fhmihvac.Wide := TMHI_HVAC_Wide.Right;
      4 : fhmihvac.Wide := TMHI_HVAC_Wide.RightEnd;
      5 : fhmihvac.Wide := TMHI_HVAC_Wide.Swing;
    end;

    case rgVertical.ItemIndex of
      0 : fhmihvac.Vane := TMHI_HVAC_Vane.Auto;
      1 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH1;
      2 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH2;
      3 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH3;
      4 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH4;
      5 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH5;
      6 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneSwing;
    end;
  finally
    fhmihvac.EndUpdate;
  end;

  mmoBroadlinkHex.Text := SplitLen(fhmihvac.BroadLink_IR_HexCode, 2);

  case rgDataFormat.ItemIndex of
    0 : mmoText.Text := SplitLen(fhmihvac.IR_HexCode, 2);
    1 : mmoText.Text := ByteArrayToString(fhmihvac.IR_Bytes);
    2 : mmoText.Text := SplitLen(fhmihvac.BroadLink_IR_HexCode, 2);
    3 : mmoText.Text := ByteArrayToString(fhmihvac.Broadlink_IR_Bytes);
  end;
end;

end.
