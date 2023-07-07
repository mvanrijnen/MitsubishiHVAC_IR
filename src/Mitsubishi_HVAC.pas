unit Mitsubishi_HVAC;

interface

{
  Source: https://github.com/r45635/HVAC-IR-Control/blob/master/HVAC_BroadLink/SendHVACCmdToRM2.py
}

uses System.SysUtils;

type
  EMHI_HVAC_Exception = class(Exception);
  EMHI_HVAC_NeedEvenDataStringException=class(EMHI_HVAC_Exception);
  EMHI_HVAC_UnsupportedEnumValueException=class(EMHI_HVAC_Exception);

type
  {$SCOPEDENUMS ON}
  TMHI_HVAC_ONOFF = (On, Off);
  TMHI_HVAC_MODE = (Auto, Cold, Dry, Hot);
  TMHI_HVAC_Wide = (LeftEnd, Left, Middle, Right, RightEnd, Swing);
  TMHI_HVAC_Fan = (Auto, Speed1, Speed2, Speed3, Speed4, Speed5, Silent);
  TMHI_HVAC_Vane = (Auto, VaneH1, VaneH2, VaneH3, VaneH4, VaneH5, VaneSwing);
  TMHI_HVAC_DataFormat = (HexCodes, ByteList, BroadlinkHex, BroadlinkASCII, BroadlinkByteList);
  {$SCOPEDENUMS OFF}

  TMHI_HVAC_BroadLink=class
  const
//    CNST_MHI_HVAC_HDR_MARK    = 03400;
//    CNST_MHI_HVAC_HDR_SPACE	  = 01750;
//    CNST_MHI_HVAC_BIT_MARK    = 00450;
//    CNST_MHI_HVAC_ONE_SPACE	  = 01300;
//    CNST_MHI_HVAC_ZERO_SPACE  = 00420;
//    CNST_MHI_HVAC_RPT_MARK	  = 00440;
//    CNST_MHI_HVAC_RPT_SPACE	  = 17100;

    CNST_MHI_HVAC_CONSTANT_BYTE_00 = $23;
    CNST_MHI_HVAC_CONSTANT_BYTE_01 = $cb;
    CNST_MHI_HVAC_CONSTANT_BYTE_02 = $26;
    CNST_MHI_HVAC_CONSTANT_BYTE_03 = $01;
    CNST_MHI_HVAC_CONSTANT_BYTE_04 = $00;
    CNST_MHI_HVAC_CONSTANT_BYTE_14 = $00;
    CNST_MHI_HVAC_CONSTANT_BYTE_15 = $00;
    CNST_MHI_HVAC_CONSTANT_BYTE_16 = $00;

    CNST_MHI_HVAC_PowerOff  = $00;
    CNST_MHI_HVAC_PowerOn  	= $20;

    CNST_MHI_HVAC_ModeAuto 	= %00100000;
    CNST_MHI_HVAC_ModeCold  = %00011000;
    CNST_MHI_HVAC_ModeDry 	= %00010000;
    CNST_MHI_HVAC_ModeHot 	= %00001000;

    CNST_MHI_HVAC_IseeOn  = %01000000;
    CNST_MHI_HVAC_IseeOff = %00000000;

    CNST_MHI_HVAC_FanAuto 		= 0;
    CNST_MHI_HVAC_FanSpeed_1  = 1;
    CNST_MHI_HVAC_FanSpeed_2 	= 2;
    CNST_MHI_HVAC_FanSpeed_3 	= 3;
    CNST_MHI_HVAC_FanSpeed_4 	= 4;
    CNST_MHI_HVAC_FanSpeed_5 	= 5;
    CNST_MHI_HVAC_FanSilent 	= %00000101;

    CNST_MHI_HVAC_VaneAuto 	= %01000000;
    CNST_MHI_HVAC_VaneH1		= %01001000;
    CNST_MHI_HVAC_VaneH2 		= %01010000;
    CNST_MHI_HVAC_VaneH3		= %01011000;
    CNST_MHI_HVAC_VaneH4		= %01100000;
    CNST_MHI_HVAC_VaneH5		= %01101000;
    CNST_MHI_HVAC_VaneSwing = %01111000;

    CNST_MHI_HVAC_WideLeft_end	= %00010000;
    CNST_MHI_HVAC_WideLeft		  = %00100000;
    CNST_MHI_HVAC_WideMiddle		= %00110000;
    CNST_MHI_HVAC_WideRight	   	= %01000000;
    CNST_MHI_HVAC_WideRight_end	= %01010000;
    CNST_MHI_HVAC_WideSwing		  = %10000000;

    CNST_MHI_HVAC_AreaSwing	= %00000000;
    CNST_MHI_HVAC_AreaLeft	= %01000000;
    CNST_MHI_HVAC_AreaRight = %10000000;
    CNST_MHI_HVAC_AreaAuto	= %11000000;

    CNST_MHI_HVAC_CleanOn	 = %00000100;
    CNST_MHI_HVAC_CleanOff = %00000000;

    CNST_MHI_HVAC_PlasmaOn	= %00000100;
    CNST_MHI_HVAC_PlasmaOff = %00000000;

    CNST_TimeCtrlOnStart		= %00000101;
    CNST_TimeCtrlOnEnd		  = %00000011;
    CNST_TimeCtrlOnStartEnd	= %00000111;
    CNST_TimeCtrlOff			  = %00000000;

    CNST_MHI_HVAC_Temperature_MIN     = 16;
    CNST_MHI_HVAC_Temperature_MAX     = 31;
    CNST_MHI_HVAC_Temperature_DEFAULT = 21;

//    // BROADLINK_DURATION_CONVERSION_FACTOR (Brodlink do not use exact duration in µs but a factor of BDCF)
//    CNST_BDCF = 269/8192;
//    //	BraodLink Sepecifc Headr for IR command start with a specific code
//    CNST_IR_BroadLink_Code = $26;
  type
    TMHI_HVAC_Temperature=CNST_MHI_HVAC_Temperature_MIN..CNST_MHI_HVAC_Temperature_MAX;
  strict private
    FMHVAC : array[0..17] of byte;
    FHVACOnOff: TMHI_HVAC_ONOFF;
    FHVACISee: TMHI_HVAC_ONOFF;
    FMode: TMHI_HVAC_MODE;
    FTemperature: TMHI_HVAC_Temperature;
    FWide: TMHI_HVAC_Wide;
    FFan: TMHI_HVAC_Fan;
    FVane: TMHI_HVAC_Vane;
    FIR_HexCode: string;
//    FBroadLink_IR_HexCode: string;
//    FBroadLink_IR_Ascii: string;
//    FBroadlink_IR_Bytes: TArray<Byte>;
    FUpdating: Boolean;
    FIR_Bytes: TArray<Byte>;

    procedure InternalUpdate;

    function FetchOnOffByte() : Byte;
    function FetchModeAndISEEByte() : Byte;
    function FetchModeAndWideByte() : Byte;
    function FetchFanAndVaneByte() : Byte;

    procedure SetFan(const Value: TMHI_HVAC_Fan);
    procedure SetHVACISee(const Value: TMHI_HVAC_ONOFF);
    procedure SetHVACOnOff(const Value: TMHI_HVAC_ONOFF);
    procedure SetMode(const Value: TMHI_HVAC_MODE);
    procedure SetTemperature(const Value: TMHI_HVAC_Temperature);
    procedure SetVane(const Value: TMHI_HVAC_Vane);
    procedure SetWide(const Value: TMHI_HVAC_Wide);
  public
    constructor Create;

    procedure BeginUpdate;
    procedure EndUpdate;

    procedure WriteToConsole();

    procedure Reset;

    property OnOff: TMHI_HVAC_ONOFF read FHVACOnOff write SetHVACOnOff;
    property ISee: TMHI_HVAC_ONOFF read FHVACISee write SetHVACISee;
    property Mode: TMHI_HVAC_MODE read FMode write SetMode;
    property Temperature: TMHI_HVAC_Temperature read FTemperature write SetTemperature;
    property Wide: TMHI_HVAC_Wide read FWide write SetWide;
    property Fan: TMHI_HVAC_Fan read FFan write SetFan;
    property Vane: TMHI_HVAC_Vane read FVane write SetVane;

    property IR_HexCode: string read FIR_HexCode;
    property IR_Bytes: TArray<Byte> read FIR_Bytes;

//    property BroadLink_IR_HexCode: string read FBroadLink_IR_HexCode;
//    property BroadLink_IR_Ascii: string read FBroadLink_IR_Ascii;
//    property Broadlink_IR_Bytes: TArray<Byte> read FBroadlink_IR_Bytes;

    property Updating: Boolean read FUpdating;

    class function CreateDataString(const AOnOff : TMHI_HVAC_ONOFF; const AISee : TMHI_HVAC_ONOFF; const AMode : TMHI_HVAC_MODE; const ATemperature : TMHI_HVAC_Temperature;
                                    const AWide : TMHI_HVAC_Wide; const AFan : TMHI_HVAC_Fan; const AVane : TMHI_HVAC_Vane; const AFormat : TMHI_HVAC_DataFormat) : string;
  end;

implementation

uses System.DateUtils,
     System.Math,
     ProjLibU;


{ TMHI_HVAC_BroadLink }

procedure TMHI_HVAC_BroadLink.BeginUpdate;
begin
  FUpdating := True;
end;

constructor TMHI_HVAC_BroadLink.Create;
begin
  FUpdating := False;
  FIR_HexCode := '';
//  FBroadLink_IR_HexCode := '';
//  FBroadLink_IR_Ascii := '';
  SetLength(FIR_Bytes, 0);
//  SetLength(FBroadlink_IR_Bytes, 0);
  Reset();
end;

class function TMHI_HVAC_BroadLink.CreateDataString(const AOnOff: TMHI_HVAC_ONOFF; const AISee: TMHI_HVAC_ONOFF; const AMode: TMHI_HVAC_MODE; const ATemperature: TMHI_HVAC_Temperature;
                                                    const AWide: TMHI_HVAC_Wide; const AFan: TMHI_HVAC_Fan; const AVane: TMHI_HVAC_Vane; const AFormat : TMHI_HVAC_DataFormat): string;
var
  fhvac : TMHI_HVAC_BroadLink;
begin
  fhvac := TMHI_HVAC_BroadLink.Create();
  try
    fhvac.BeginUpdate();
    try
      fhvac.OnOff := AOnOff;
      fhvac.ISee := AISee;
      fhvac.Mode := AMode;
      fhvac.Temperature := ATemperature;
      fhvac.Wide := AWide;
      fhvac.Fan := AFan;
      fhvac.Vane := AVane;
    finally
      fhvac.EndUpdate();
    end;

    case AFormat of
      TMHI_HVAC_DataFormat.HexCodes: Result := fhvac.IR_HexCode;
      TMHI_HVAC_DataFormat.ByteList: Result := ByteArrayToString(fhvac.IR_Bytes);
//      TMHI_HVAC_DataFormat.BroadlinkHex: Result := fhvac.BroadLink_IR_HexCode;
//      TMHI_HVAC_DataFormat.BroadlinkASCII: Result := fhvac.BroadLink_IR_Ascii;
//      TMHI_HVAC_DataFormat.BroadlinkByteList: Result := ByteArrayToString(fhvac.Broadlink_IR_Bytes);
    else
      raise EMHI_HVAC_UnsupportedEnumValueException.CreateFmt('[%s] Unsupport enum value for enum: %s', ['TMHI_HVAC_BroadLink.CreateDataString', 'Format']);
    end;
  finally
    fhvac.Free;
  end;
end;

procedure TMHI_HVAC_BroadLink.EndUpdate;
begin
  FUpdating := False;
  InternalUpdate();
end;

function TMHI_HVAC_BroadLink.FetchFanAndVaneByte: Byte;
begin
  Result := 0;
  case Fan of
    TMHI_HVAC_Fan.Auto: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_FanAuto;
    TMHI_HVAC_Fan.Speed1: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_FanSpeed_1;
    TMHI_HVAC_Fan.Speed2: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_FanSpeed_2;
    TMHI_HVAC_Fan.Speed3: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_FanSpeed_3;
    TMHI_HVAC_Fan.Speed4: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_FanSpeed_4;
    TMHI_HVAC_Fan.Speed5: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_FanSpeed_5;
    TMHI_HVAC_Fan.Silent: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_FanSilent;
  else
    raise EMHI_HVAC_UnsupportedEnumValueException.CreateFmt('[%s] Unsupport enum value for enum: %s', ['TMHI_HVAC_BroadLink.FetchFanAndVaneByte', 'Fan']);
  end;

  case Vane of
    TMHI_HVAC_Vane.Auto: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_VaneAuto;
    TMHI_HVAC_Vane.VaneH1: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_VaneH1;
    TMHI_HVAC_Vane.VaneH2: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_VaneH2;
    TMHI_HVAC_Vane.VaneH3: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_VaneH3;
    TMHI_HVAC_Vane.VaneH4: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_VaneH4;
    TMHI_HVAC_Vane.VaneH5: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_VaneH5;
    TMHI_HVAC_Vane.VaneSwing: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_VaneSwing;
  else
    raise EMHI_HVAC_UnsupportedEnumValueException.CreateFmt('[%s] Unsupport enum value for enum: %s', ['TMHI_HVAC_BroadLink.FetchFanAndVaneByte', 'Vane']);
  end;
end;

function TMHI_HVAC_BroadLink.FetchModeAndISEEByte: Byte;
begin
  Result := 0;
  case Mode of
    TMHI_HVAC_MODE.Auto: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ModeAuto;
    TMHI_HVAC_MODE.Cold: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ModeCold;
    TMHI_HVAC_MODE.Dry: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ModeDry;
    TMHI_HVAC_MODE.Hot: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ModeHot;
  else
    raise EMHI_HVAC_UnsupportedEnumValueException.CreateFmt('[%s] Unsupport enum value for enum: %s', ['TMHI_HVAC_BroadLink.FetchModeAndISEEByte', 'Mode']);
  end;
  case ISee of
    TMHI_HVAC_ONOFF.On: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_IseeOn;
    TMHI_HVAC_ONOFF.Off: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_IseeOff;
  else
    raise EMHI_HVAC_UnsupportedEnumValueException.CreateFmt('[%s] Unsupport enum value for enum: %s', ['TMHI_HVAC_BroadLink.FetchModeAndISEEByte', 'ISee']);
  end;
end;

function TMHI_HVAC_BroadLink.FetchModeAndWideByte: Byte;
begin
  Result := 0;
  case Mode of
    TMHI_HVAC_MODE.Auto: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ModeAuto;
    TMHI_HVAC_MODE.Cold: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ModeCold;
    TMHI_HVAC_MODE.Dry: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ModeDry;
    TMHI_HVAC_MODE.Hot: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ModeHot;
  else
    raise EMHI_HVAC_UnsupportedEnumValueException.CreateFmt('[%s] Unsupport enum value for enum: %s', ['TMHI_HVAC_BroadLink.FetchModeAndWideByte', 'Mode']);
  end;
  case Wide of
    TMHI_HVAC_Wide.LeftEnd: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_WideLeft_end;
    TMHI_HVAC_Wide.Left: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_WideLeft;
    TMHI_HVAC_Wide.Middle: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_WideMiddle;
    TMHI_HVAC_Wide.Right: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_WideRight;
    TMHI_HVAC_Wide.RightEnd: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_WideRight_end;
    TMHI_HVAC_Wide.Swing: Result := Result or TMHI_HVAC_BroadLink.CNST_MHI_HVAC_WideSwing;
  else
    raise EMHI_HVAC_UnsupportedEnumValueException.CreateFmt('[%s] Unsupport enum value for enum: %s', ['TMHI_HVAC_BroadLink.FetchModeAndWideByte', 'Wide']);
  end;
end;

function TMHI_HVAC_BroadLink.FetchOnOffByte: Byte;
begin
  case OnOff of
    TMHI_HVAC_ONOFF.On: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_PowerOn;
    TMHI_HVAC_ONOFF.Off: Result := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_PowerOff;
  else
    raise EMHI_HVAC_UnsupportedEnumValueException.CreateFmt('[%s] Unsupport enum value for enum: %s', ['TMHI_HVAC_BroadLink.FetchOnOffByte', 'OnOff']);
  end;
end;


procedure TMHI_HVAC_BroadLink.Reset;
begin
  FHVACOnOff := TMHI_HVAC_ONOFF.On;
  FHVACISee := TMHI_HVAC_ONOFF.Off;
  FMode := TMHI_HVAC_MODE.Auto;
  FTemperature := CNST_MHI_HVAC_Temperature_DEFAULT;
  FWide := TMHI_HVAC_Wide.Swing;
  FFan := TMHI_HVAC_Fan.Auto;
  FVane := TMHI_HVAC_Vane.Auto;
  InternalUpdate();
end;

procedure TMHI_HVAC_BroadLink.SetFan(const Value: TMHI_HVAC_Fan);
begin
  if Value<>Fan then
  begin
    FFan := Value;
    InternalUpdate();
  end;
end;

procedure TMHI_HVAC_BroadLink.SetHVACISee(const Value: TMHI_HVAC_ONOFF);
begin
  if Value<>ISee then
  begin
    FHVACISee := Value;
    InternalUpdate();
  end;
end;

procedure TMHI_HVAC_BroadLink.SetHVACOnOff(const Value: TMHI_HVAC_ONOFF);
begin
  if Value<>OnOff then
  begin
    FHVACOnOff := Value;
    InternalUpdate();
  end;
end;

procedure TMHI_HVAC_BroadLink.SetMode(const Value: TMHI_HVAC_MODE);
begin
  if Value<>Mode then
  begin
    FMode := Value;
    InternalUpdate();
  end;
end;

procedure TMHI_HVAC_BroadLink.SetTemperature(const Value: TMHI_HVAC_Temperature);
begin
  if Value<>Temperature then
  begin
    FTemperature := Value;
    InternalUpdate();
  end;
end;

procedure TMHI_HVAC_BroadLink.SetVane(const Value: TMHI_HVAC_Vane);
begin
  if Value<>Vane then
  begin
    FVane := Value;
    InternalUpdate();
  end;
end;

procedure TMHI_HVAC_BroadLink.SetWide(const Value: TMHI_HVAC_Wide);
begin
  if Value<>Wide then
  begin
    FWide := Value;
    InternalUpdate();
  end;
end;

//procedure TMHI_HVAC_BroadLink.InternalUpdate();
//var
//  mask,
//  i,j: integer;
//  strdatacode,
//  strrepeatframe,
//  strheaderframe,
//  strhexcode,
//  tmpstrcode  : string;
//begin
//  if FUpdating then
//     Exit;
//
//  // Build_Cmd: Build the Command applying all parameters defined. The cmd is stored in memory, not send.
//  FMHVAC[00] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_00;
//  FMHVAC[01] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_01;
//  FMHVAC[02] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_02;
//  FMHVAC[03] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_03;
//  FMHVAC[04] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_04;
//  FMHVAC[05] := FetchOnOffByte();
//  FMHVAC[06] := FetchModeAndISEEByte();
//  FMHVAC[07] := Max(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_Temperature_MIN, Min(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_Temperature_MAX, Self.Temperature)) - TMHI_HVAC_BroadLink.CNST_MHI_HVAC_Temperature_MIN;
//  FMHVAC[08] := FetchModeAndWideByte();
//  FMHVAC[09] := FetchFanAndVaneByte();
//  FMHVAC[10] := HourOf(Now)*6+(MinuteOf(Now) div 10);
//  FMHVAC[11] := 00; {TODO -oOwner -cGeneral : EndTime}
//  FMHVAC[12] := 00; {TODO -oOwner -cGeneral : StartTime}
//  FMHVAC[13] := 00; {TODO -oOwner -cGeneral : Timer}
//  FMHVAC[14] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_14;
//  FMHVAC[15] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_15;
//  FMHVAC[16] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_16;
//
//  // Calculate Checksum
//  FMHVAC[17] := ((FMHVAC[00] + FMHVAC[01] + FMHVAC[02] + FMHVAC[03] + FMHVAC[04] + FMHVAC[05] + FMHVAC[06] + FMHVAC[07] +
//                  FMHVAC[08] + FMHVAC[09] + FMHVAC[11] + FMHVAC[12] + FMHVAC[13] + FMHVAC[14] + FMHVAC[15] + FMHVAC[16]) mod (256));
//
//  FIR_HexCode := '';
//  for i := 0 to 17  do
//      FIR_HexCode := FIR_HexCode + IntToHex(FMHVAC[i], 2);
//  FIR_Bytes := HexDataToByteList(FIR_HexCode);
//
//
//  for i := 0 to 17 do
//  begin
//    mask := 1;
//    tmpstrcode := '';
//    for j := 0 to 7 do
//    begin
//      if (FMHVAC[i] and mask<>0) then
//         tmpstrcode := tmpstrcode + IntToHex(trunc(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_BIT_MARK*TMHI_HVAC_BroadLink.CNST_BDCF), 2) + IntToHex(trunc(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ONE_SPACE*TMHI_HVAC_BroadLink.CNST_BDCF), 2)
//      else
//        tmpstrcode := tmpstrcode + IntToHex(trunc(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_BIT_MARK*TMHI_HVAC_BroadLink.CNST_BDCF), 2) + IntToHex(trunc(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ZERO_SPACE*TMHI_HVAC_BroadLink.CNST_BDCF), 2);
//      mask := mask shl 1;
//    end;
//	  strhexcode := strhexcode + tmpstrcode;
//  end;
//  // strhexcode contain the Frame for the HVAC Mitsubishi IR Command requested
//
//  FBroadLink_IR_HexCode := IntToHex(TMHI_HVAC_BroadLink.CNST_IR_BroadLink_Code, 2);
//  FBroadLink_IR_HexCode := FBroadLink_IR_HexCode + IntToHex(00, 2);
//
//  strheaderframe := Val2BRCode(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_HDR_MARK*TMHI_HVAC_BroadLink.CNST_BDCF);
//	strheaderframe := strheaderframe + Val2BRCode(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_HDR_SPACE*TMHI_HVAC_BroadLink.CNST_BDCF);
//  strrepeatframe := Val2BRCode(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_RPT_MARK*TMHI_HVAC_BroadLink.CNST_BDCF);
//  strrepeatframe := strrepeatframe + Val2BRCode(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_RPT_SPACE*TMHI_HVAC_BroadLink.CNST_BDCF);
//	strdatacode := strheaderframe + strhexcode + strrepeatframe;
//
//  FBroadLink_IR_HexCode := FBroadLink_IR_HexCode + Val2BRCode(strdatacode.Length/2, True);
//  FBroadLink_IR_HexCode := FBroadLink_IR_HexCode + strdatacode;
//  FBroadLink_IR_HexCode := FBroadLink_IR_HexCode + '0d05';
//  FBroadLink_IR_Ascii := UnHexLify(FBroadLink_IR_HexCode.Replace(' ', '', [rfReplaceAll]).Replace(#13, '', [rfReplaceAll]));
//  FBroadlink_IR_Bytes := HexDataToByteList(FBroadLink_IR_HexCode);
//end;

procedure TMHI_HVAC_BroadLink.InternalUpdate();
var
  mask,
  i,j: integer;
  strdatacode,
  strrepeatframe,
  strheaderframe,
  strhexcode,
  tmpstrcode  : string;
begin
  if FUpdating then
     Exit;

  // Build_Cmd: Build the Command applying all parameters defined. The cmd is stored in memory, not send.
  FMHVAC[00] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_00;
  FMHVAC[01] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_01;
  FMHVAC[02] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_02;
  FMHVAC[03] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_03;
  FMHVAC[04] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_04;
  FMHVAC[05] := FetchOnOffByte();
  FMHVAC[06] := FetchModeAndISEEByte();
  FMHVAC[07] := Max(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_Temperature_MIN, Min(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_Temperature_MAX, Self.Temperature)) - TMHI_HVAC_BroadLink.CNST_MHI_HVAC_Temperature_MIN;
  FMHVAC[08] := FetchModeAndWideByte();
  FMHVAC[09] := FetchFanAndVaneByte();
  FMHVAC[10] := HourOf(Now)*6+(MinuteOf(Now) div 10);
  FMHVAC[11] := 00; {TODO -oOwner -cGeneral : EndTime}
  FMHVAC[12] := 00; {TODO -oOwner -cGeneral : StartTime}
  FMHVAC[13] := 00; {TODO -oOwner -cGeneral : Timer}
  FMHVAC[14] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_14;
  FMHVAC[15] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_15;
  FMHVAC[16] := TMHI_HVAC_BroadLink.CNST_MHI_HVAC_CONSTANT_BYTE_16;

  // Calculate Checksum
  FMHVAC[17] := ((FMHVAC[00] + FMHVAC[01] + FMHVAC[02] + FMHVAC[03] + FMHVAC[04] + FMHVAC[05] + FMHVAC[06] + FMHVAC[07] +
                  FMHVAC[08] + FMHVAC[09] + FMHVAC[11] + FMHVAC[12] + FMHVAC[13] + FMHVAC[14] + FMHVAC[15] + FMHVAC[16]) mod (256));

  FIR_HexCode := '';
  for i := 0 to 17  do
      FIR_HexCode := FIR_HexCode + IntToHex(FMHVAC[i], 2);
  FIR_Bytes := HexDataToByteList(FIR_HexCode);


//  for i := 0 to 17 do
//  begin
//    mask := 1;
//    tmpstrcode := '';
//    for j := 0 to 7 do
//    begin
//      if (FMHVAC[i] and mask<>0) then
//         tmpstrcode := tmpstrcode + IntToHex(trunc(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_BIT_MARK*TMHI_HVAC_BroadLink.CNST_BDCF), 2) + IntToHex(trunc(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ONE_SPACE*TMHI_HVAC_BroadLink.CNST_BDCF), 2)
//      else
//        tmpstrcode := tmpstrcode + IntToHex(trunc(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_BIT_MARK*TMHI_HVAC_BroadLink.CNST_BDCF), 2) + IntToHex(trunc(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_ZERO_SPACE*TMHI_HVAC_BroadLink.CNST_BDCF), 2);
//      mask := mask shl 1;
//    end;
//	  strhexcode := strhexcode + tmpstrcode;
//  end;
//  // strhexcode contain the Frame for the HVAC Mitsubishi IR Command requested
//
//  FBroadLink_IR_HexCode := IntToHex(TMHI_HVAC_BroadLink.CNST_IR_BroadLink_Code, 2);
//  FBroadLink_IR_HexCode := FBroadLink_IR_HexCode + IntToHex(00, 2);
//
//  strheaderframe := Val2BRCode(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_HDR_MARK*TMHI_HVAC_BroadLink.CNST_BDCF);
//	strheaderframe := strheaderframe + Val2BRCode(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_HDR_SPACE*TMHI_HVAC_BroadLink.CNST_BDCF);
//  strrepeatframe := Val2BRCode(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_RPT_MARK*TMHI_HVAC_BroadLink.CNST_BDCF);
//  strrepeatframe := strrepeatframe + Val2BRCode(TMHI_HVAC_BroadLink.CNST_MHI_HVAC_RPT_SPACE*TMHI_HVAC_BroadLink.CNST_BDCF);
//	strdatacode := strheaderframe + strhexcode + strrepeatframe;
//
//  FBroadLink_IR_HexCode := FBroadLink_IR_HexCode + Val2BRCode(strdatacode.Length/2, True);
//  FBroadLink_IR_HexCode := FBroadLink_IR_HexCode + strdatacode;
//  FBroadLink_IR_HexCode := FBroadLink_IR_HexCode + '0d05';
//  FBroadLink_IR_Ascii := UnHexLify(FBroadLink_IR_HexCode.Replace(' ', '', [rfReplaceAll]).Replace(#13, '', [rfReplaceAll]));
//  FBroadlink_IR_Bytes := HexDataToByteList(FBroadLink_IR_HexCode);
end;


procedure TMHI_HVAC_BroadLink.WriteToConsole;
begin
  Writeln;

  Write('On/Off: ');
  case OnOff of
    TMHI_HVAC_ONOFF.On: Writeln('On');
    TMHI_HVAC_ONOFF.Off: Writeln('Off');
  end;

  Write('ISee  : ');
  case ISee of
    TMHI_HVAC_ONOFF.On: Writeln('On');
    TMHI_HVAC_ONOFF.Off: Writeln('Off');
  end;

  Write('Mode  : ');
  case Mode of
    TMHI_HVAC_MODE.Auto: Writeln('Auto');
    TMHI_HVAC_MODE.Cold: Writeln('Cold');
    TMHI_HVAC_MODE.Dry: Writeln('Dry');
    TMHI_HVAC_MODE.Hot: Writeln('Hot');
  end;

  Write('Temp  : ');
  Writeln(Integer(Temperature).ToString);

  Write('Wide  : ');
  case Wide of
    TMHI_HVAC_Wide.LeftEnd: Writeln('LeftEnd');
    TMHI_HVAC_Wide.Left: Writeln('Left');
    TMHI_HVAC_Wide.Middle: Writeln('Middle');
    TMHI_HVAC_Wide.Right: Writeln('Right');
    TMHI_HVAC_Wide.RightEnd: Writeln('RightEnd');
    TMHI_HVAC_Wide.Swing: Writeln('Swing');
  end;

  Write('Fan   : ');
  case Fan of
    TMHI_HVAC_Fan.Auto: Writeln('Auto');
    TMHI_HVAC_Fan.Speed1: Writeln('Speed 1');
    TMHI_HVAC_Fan.Speed2: Writeln('Speed 2');
    TMHI_HVAC_Fan.Speed3: Writeln('Speed 3');
    TMHI_HVAC_Fan.Speed4: Writeln('Speed 4');
    TMHI_HVAC_Fan.Speed5: Writeln('Speed 5');
    TMHI_HVAC_Fan.Silent: Writeln('Silent');
  end;

  Write('Vane  : ');
  case Vane of
    TMHI_HVAC_Vane.Auto: Writeln('Auto');
    TMHI_HVAC_Vane.VaneH1: Writeln('H1');
    TMHI_HVAC_Vane.VaneH2: Writeln('H2');
    TMHI_HVAC_Vane.VaneH3: Writeln('H3');
    TMHI_HVAC_Vane.VaneH4: Writeln('H4');
    TMHI_HVAC_Vane.VaneH5: Writeln('H5');
    TMHI_HVAC_Vane.VaneSwing: Writeln('Swing');
  end;
end;

end.
