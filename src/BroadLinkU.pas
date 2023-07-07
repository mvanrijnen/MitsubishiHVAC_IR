unit BroadLinkU;

interface


type
  {$SCOPEDENUMS ON}
  TBroadLinkDeviceType=(RM2, RM4);
  {$SCOPEDENUMS OFF}
  TBroadLink=class
  const
    CNST_DEVTYPE_RM2='RM2';
    CNST_DEVTYPE_RM4='RM4';

    CNST_MHI_HVAC_HDR_MARK    = 03400;
    CNST_MHI_HVAC_HDR_SPACE	  = 01750;
    CNST_MHI_HVAC_BIT_MARK    = 00450;
    CNST_MHI_HVAC_ONE_SPACE	  = 01300;
    CNST_MHI_HVAC_ZERO_SPACE  = 00420;
    CNST_MHI_HVAC_RPT_MARK	  = 00440;
    CNST_MHI_HVAC_RPT_SPACE	  = 17100;

    // BROADLINK_DURATION_CONVERSION_FACTOR (Brodlink do not use exact duration in µs but a factor of BDCF)
    CNST_BDCF = 269/8192;
    //	BraodLink Sepecifc Headr for IR command start with a specific code
    CNST_IR_BroadLink_Code = $26;
  private
    FHost: string;
    FPort: Integer;
    FDeviceType: TBroadLinkDeviceType;
    FMacAddress: string;
    FDataBytes: TArray<Byte>;
    FBroadlink_HexCode: string;
    FBroadlink_AsciiCode: string;
    FBroadlink_DataBytes: TArray<Byte>;
    procedure SetDataBytes(const Value: TArray<Byte>);
  public
    constructor Create;

    procedure Send();

    property Host: string read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property MacAddress: string read FMacAddress write FMacAddress;

    property DeviceType: TBroadLinkDeviceType read FDeviceType write FDeviceType;
    property DataBytes: TArray<Byte> read FDataBytes write SetDataBytes;

    property Broadlink_HexCode: string read FBroadlink_HexCode;
    property Broadlink_AsciiCode: string read FBroadlink_AsciiCode;
    property Broadlink_DataBytes: TArray<Byte> read FBroadlink_DataBytes;
  end;


implementation

uses  System.SysUtils,
      System.Math,
      ProjLibU;

{ TBroadLink }

constructor TBroadLink.Create;
begin
  FHost := '127.0.0.1';
  FPort := 90;
  FMacAddress := '';
  FDeviceType := TBroadLinkDeviceType.RM4;
end;

procedure TBroadLink.Send;
var
  hexcodeascii : string;
begin
//
end;

procedure TBroadLink.SetDataBytes(const Value: TArray<Byte>);
var
  mask,
  i,j: integer;
  strdatacode,
  strrepeatframe,
  strheaderframe,
  strhexcode,
  tmpstrcode  : string;
begin
  FDataBytes := Value;

  for i := 0 to Length(DataBytes)-1 do
  begin
    mask := 1;
    tmpstrcode := '';
    for j := 0 to 7 do
    begin
      if (DataBytes[i] and mask<>0) then
         tmpstrcode := tmpstrcode + IntToHex(trunc(TBroadLink.CNST_MHI_HVAC_BIT_MARK*TBroadLink.CNST_BDCF), 2) + IntToHex(trunc(TBroadLink.CNST_MHI_HVAC_ONE_SPACE*TBroadLink.CNST_BDCF), 2)
      else
        tmpstrcode := tmpstrcode + IntToHex(trunc(TBroadLink.CNST_MHI_HVAC_BIT_MARK*TBroadLink.CNST_BDCF), 2) + IntToHex(trunc(TBroadLink.CNST_MHI_HVAC_ZERO_SPACE*TBroadLink.CNST_BDCF), 2);
      mask := mask shl 1;
    end;
	  strhexcode := strhexcode + tmpstrcode;
  end;

  FBroadlink_HexCode := IntToHex(TBroadLink.CNST_IR_BroadLink_Code, 2);
  FBroadlink_HexCode := FBroadlink_HexCode + IntToHex(00, 2);

  strheaderframe := Val2BRCode(TBroadLink.CNST_MHI_HVAC_HDR_MARK*TBroadLink.CNST_BDCF);
	strheaderframe := strheaderframe + Val2BRCode(TBroadLink.CNST_MHI_HVAC_HDR_SPACE*TBroadLink.CNST_BDCF);
  strrepeatframe := Val2BRCode(TBroadLink.CNST_MHI_HVAC_RPT_MARK*TBroadLink.CNST_BDCF);
  strrepeatframe := strrepeatframe + Val2BRCode(TBroadLink.CNST_MHI_HVAC_RPT_SPACE*TBroadLink.CNST_BDCF);
	strdatacode := strheaderframe + strhexcode + strrepeatframe;

  FBroadlink_HexCode := FBroadlink_HexCode + Val2BRCode(strdatacode.Length/2, True);
  FBroadlink_HexCode := FBroadlink_HexCode + strdatacode;
  FBroadlink_HexCode := FBroadlink_HexCode + '0d05';

  FBroadlink_AsciiCode := UnHexLify(FBroadlink_HexCode.Replace(' ', '', [rfReplaceAll]).Replace(#13, '', [rfReplaceAll]));
  FBroadlink_DataBytes := HexDataToByteList(FBroadlink_HexCode);
end;

end.
