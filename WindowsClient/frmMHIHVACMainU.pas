unit frmMHIHVACMainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Samples.Spin,
  Mitsubishi_HVAC,
  BroadLinkU;

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
    gbTemperature: TGroupBox;
    edtTemperature: TSpinEdit;
    Button1: TButton;
    gbGenerate: TGroupBox;
    Label1: TLabel;
    lblMinTemp: TLabel;
    btnGenerate: TButton;
    cbFixedMode: TCheckBox;
    cbFixedFanSpeed: TCheckBox;
    cbFixedHor: TCheckBox;
    cbFixedVert: TCheckBox;
    edtMinTemp: TSpinEdit;
    edtMaxTemp: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rgOperationClick(Sender: TObject);
    procedure rgModeClick(Sender: TObject);
    procedure rgFanSpeedClick(Sender: TObject);
    procedure rgHorizontalClick(Sender: TObject);
    procedure rgVerticalClick(Sender: TObject);
    procedure rgDataFormatClick(Sender: TObject);
    procedure edtTemperatureChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
  private
    { Private declarations }
    fisgenerating,
    fstopgenerating : Boolean;
    fhmihvac : TMHI_HVAC_BroadLink;
    fbroadlink : TBroadLink;
    procedure UpdateFromUI;

    procedure GenerateAll;
  public
    { Public declarations }
  end;

var
  frmMHIHVACMain: TfrmMHIHVACMain;

implementation

uses  System.NetEncoding,
      System.Rtti,
      Vcl.Clipbrd,
      ProjLibU;

{$R *.dfm}


{ TfrmMHIHVACMain }

procedure TfrmMHIHVACMain.Button1Click(Sender: TObject);
begin
  Clipboard.AsText := mmoText.Text;
end;

procedure TfrmMHIHVACMain.btnGenerateClick(Sender: TObject);
begin
  if fisgenerating then
  begin
    fstopgenerating := True;
  end
  else begin
    btnGenerate.Caption := 'Stop generating';
    PushMouseCursor();
    try
      GenerateAll();
    finally
      btnGenerate.Caption := '&Generate all';
      PopMouseCursor();
    end;
  end;
end;

procedure TfrmMHIHVACMain.edtTemperatureChange(Sender: TObject);
begin
  UpdateFromUI();
end;

procedure TfrmMHIHVACMain.FormCreate(Sender: TObject);
begin
  fstopgenerating := True;
  fhmihvac := TMHI_HVAC_BroadLink.Create();
  fbroadlink := TBroadLink.Create();
  pcOutput.ActivePage := tabOutputText;
  UpdateFromUI();
end;

procedure TfrmMHIHVACMain.FormDestroy(Sender: TObject);
begin
  fbroadlink.Free;
  fhmihvac.Free;
end;

procedure TfrmMHIHVACMain.GenerateAll;
          procedure Add2Text(const ATitle : string);
          begin
            fbroadlink.DataBytes := fhmihvac.IR_Bytes;
            case rgDataFormat.ItemIndex of
              0 : mmoText.Text := mmoText.Text + ATitle +'=' +  SplitLen(fhmihvac.IR_HexCode, 2) + #13#10;
              1 : mmoText.Text := mmoText.Text + ATitle +'=' +  ByteArrayToString(fhmihvac.IR_Bytes)+ #13#10;
              2 : mmoText.Text := mmoText.Text + ATitle +'=' +  SplitLen(fbroadlink.Broadlink_HexCode, 2)+ #13#10;
              3 : mmoText.Text := mmoText.Text + ATitle +'=' +  ByteArrayToString(fbroadlink.Broadlink_DataBytes)+ #13#10;
              4 : mmoText.Text := mmoText.Text + ATitle +'=' +  TBase64Encoding.Base64.EncodeBytesToString(fbroadlink.Broadlink_DataBytes).Replace(#13#10, '', [rfReplaceAll])+ #13#10;
          //    2 : mmoText.Text := SplitLen(fhmihvac.BroadLink_IR_HexCode, 2);
          //    3 : mmoText.Text := ByteArrayToString(fhmihvac.Broadlink_IR_Bytes);
            end;
          end;

var
  stext : string;
  fmode,
  fmodeStart,
  fmodeEnd : TMHI_HVAC_MODE;
  ffanspeed,
  ffanspeedStart,
  ffanspeedEnd : TMHI_HVAC_Fan;
  fhor,
  fhorStart,
  fhorEnd : TMHI_HVAC_Wide;
  fver,
  fverStart,
  fverEnd : TMHI_HVAC_Vane;
  ftemp,
  ftempStart,
  ftempEnd : TMHI_HVAC_Temperature;
begin
  fisgenerating := True;
  fstopgenerating := False;
  try
    mmoText.Clear;
    stext := 'Off';
    fhmihvac.Reset();
    fhmihvac.OnOff := TMHI_HVAC_ONOFF.On;
    Add2Text(stext);

    fhmihvac.BeginUpdate();
    try
      fhmihvac.OnOff := TMHI_HVAC_ONOFF.On;
      if cbFixedMode.Checked then
      begin
        case rgMode.ItemIndex of
          0 : fhmihvac.Mode := TMHI_HVAC_MODE.Auto;
          1 : fhmihvac.Mode := TMHI_HVAC_MODE.Cold;
          2 : fhmihvac.Mode := TMHI_HVAC_MODE.Dry;
          3 : fhmihvac.Mode := TMHI_HVAC_MODE.Hot;
        end;
        fmodeStart :=fhmihvac.Mode;
        fmodeEnd :=fhmihvac.Mode;
      end
      else begin
        fmodeStart := Low(TMHI_HVAC_MODE);
        fmodeEnd := High(TMHI_HVAC_MODE);
      end;

      if cbFixedFanSpeed.Checked then
      begin
        case rgFanSpeed.ItemIndex of
          0 : fhmihvac.Fan := TMHI_HVAC_Fan.Auto;
          1 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed1;
          2 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed2;
          3 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed3;
          4 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed4;
          5 : fhmihvac.Fan := TMHI_HVAC_Fan.Speed5;
          6 : fhmihvac.Fan := TMHI_HVAC_Fan.Silent;
        end;
        ffanspeedStart := fhmihvac.Fan;
        ffanspeedEnd := fhmihvac.Fan;
      end
      else begin
        ffanspeedStart := Low(TMHI_HVAC_Fan);
        ffanspeedEnd := High(TMHI_HVAC_Fan);
      end;

      if cbFixedHor.Checked then
      begin
        case rgHorizontal.ItemIndex of
          0 : fhmihvac.Wide := TMHI_HVAC_Wide.LeftEnd;
          1 : fhmihvac.Wide := TMHI_HVAC_Wide.Left;
          2 : fhmihvac.Wide := TMHI_HVAC_Wide.Middle;
          3 : fhmihvac.Wide := TMHI_HVAC_Wide.Right;
          4 : fhmihvac.Wide := TMHI_HVAC_Wide.RightEnd;
          5 : fhmihvac.Wide := TMHI_HVAC_Wide.Swing;
        end;
        fhorStart := fhmihvac.Wide;
        fhorEnd := fhmihvac.Wide;
      end
      else begin
        fhorStart := Low(TMHI_HVAC_Wide);
        fhorEnd := High(TMHI_HVAC_Wide);
      end;

      if cbFixedVert.Checked then
      begin
        case rgVertical.ItemIndex of
          0 : fhmihvac.Vane := TMHI_HVAC_Vane.Auto;
          1 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH1;
          2 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH2;
          3 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH3;
          4 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH4;
          5 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneH5;
          6 : fhmihvac.Vane := TMHI_HVAC_Vane.VaneSwing;
        end;
        fverStart := fhmihvac.Vane;
        fverEnd := fhmihvac.Vane;
      end
      else begin
        fverStart := Low(TMHI_HVAC_Vane);
        fverEnd := High(TMHI_HVAC_Vane) ;
      end;
    finally
      fhmihvac.EndUpdate;
    end;


    for fmode := fmodeStart to fmodeEnd do
    begin
      for ftemp := edtMinTemp.Value to edtMaxTemp.Value do
      begin
        for ffanspeed := ffanspeedStart to ffanspeedEnd do
        begin
          for fhor := fhorStart to fhorEnd do
          begin
            for fver := fverStart to fverEnd do
            begin
              fhmihvac.Temperature := ftemp;
              fhmihvac.Wide := fhor;
              fhmihvac.Vane := fver;
              fhmihvac.Mode := fmode;
              fhmihvac.Fan := ffanspeed;

              stext := 'On';
              stext := sText + '|Temp_' + IntToStr(ftemp);
              stext := sText + '|Mode_' + TRttiEnumerationType.GetName(fmode);
              stext := sText + '|Fan_' + TRttiEnumerationType.GetName(ffanspeed);
              stext := sText + '|Ver_' + TRttiEnumerationType.GetName(fver);
              Add2Text(stext);
              SendMessage(mmoText.Handle, EM_LINESCROLL, 0, mmoText.Lines.Count);
              Application.ProcessMessages;
              if fstopgenerating then
                 Break;
            end;
            if fstopgenerating then
               Break;
          end;
          if fstopgenerating then
             Break;
        end;
        if fstopgenerating then
           Break;
      end;
      if fstopgenerating then
         Break;
    end;
    SendMessage(mmoText.Handle, EM_LINESCROLL, 0, mmoText.Lines.Count);
    Application.ProcessMessages;
  finally
    fisgenerating := False;
  end;
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
    fhmihvac.Temperature := edtTemperature.Value;

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

//  mmoBroadlinkHex.Text := SplitLen(fhmihvac.BroadLink_IR_HexCode, 2);

  fbroadlink.DataBytes := fhmihvac.IR_Bytes;
  case rgDataFormat.ItemIndex of
    0 : mmoText.Text := SplitLen(fhmihvac.IR_HexCode, 2);
    1 : mmoText.Text := ByteArrayToString(fhmihvac.IR_Bytes);
    2 : mmoText.Text := SplitLen(fbroadlink.Broadlink_HexCode, 2);
    3 : mmoText.Text := ByteArrayToString(fbroadlink.Broadlink_DataBytes);
    4 : mmoText.Text := TBase64Encoding.Base64.EncodeBytesToString(fbroadlink.Broadlink_DataBytes).Replace(#13#10, '', [rfReplaceAll]);
//    2 : mmoText.Text := SplitLen(fhmihvac.BroadLink_IR_HexCode, 2);
//    3 : mmoText.Text := ByteArrayToString(fhmihvac.Broadlink_IR_Bytes);
  end;
end;

end.
