program MitsubishiHVAC_cmd;

{$APPTYPE CONSOLE}

{$R *.res}

//
// https://github.com/r45635/HVAC-IR-Control/blob/master/HVAC_BroadLink/SendHVACCmdToRM2.py
//
uses
  System.SysUtils,
  System.IOUtils,
  Mitsubishi_HVAC in '..\src\Mitsubishi_HVAC.pas';

const
   CNST_DATAFORMAT = TMHI_HVAC_DataFormat.ByteList;
   CNST_DUMPFILE = 'D:\Data\MHI\mhidump.txt';


procedure ClearDumpFile();
begin
  if TFile.Exists(CNST_DUMPFILE) then
     TFile.Delete(CNST_DUMPFILE);
end;

procedure WriteDumpFile(const AComment, AData : string);
begin
  if not TDirectory.Exists(TPath.GetDirectoryName(CNST_DUMPFILE)) then
     TDirectory.CreateDirectory(TPath.GetDirectoryName(CNST_DUMPFILE));
  TFile.AppendAllText(CNST_DUMPFILE, Format('%s: %s', [AComment, AData]) + #13#10);
end;

var
  myHVAC : TMHI_HVAC_BroadLink;

//  presets : TArray<string>;
begin
//  SetLength(presets, 6);
//  presets[00] := TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.HVACOff, TMHI_HVAC_ISEE.ISEEOff, TMHI_HVAC_MODE.Auto, 21, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT);  // OFF
//  presets[01] := TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.HVACOn, TMHI_HVAC_ISEE.ISEEOff, TMHI_HVAC_MODE.Cold, 21, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT);  // ON, Auto 21graden
//  presets[02] := TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.HVACOn, TMHI_HVAC_ISEE.ISEEOff, TMHI_HVAC_MODE.Cold, 22, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT);  // ON, Auto 22graden
//  presets[03] := TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.HVACOn, TMHI_HVAC_ISEE.ISEEOff, TMHI_HVAC_MODE.Cold, 23, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT);  // ON, Auto 23graden
//  presets[04] := TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.HVACOn, TMHI_HVAC_ISEE.ISEEOff, TMHI_HVAC_MODE.Cold, 24, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT);  // ON, Auto 24graden
//  presets[05] := TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.HVACOn, TMHI_HVAC_ISEE.ISEEOff, TMHI_HVAC_MODE.Cold, 25, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT);  // ON, Auto 25graden

  ClearDumpFile();
  WriteDumpFile('Airco Off', TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.Off, TMHI_HVAC_ONOFF.Off, TMHI_HVAC_MODE.Auto, 21, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT));
  WriteDumpFile('Airco Cool, 21', TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.On, TMHI_HVAC_ONOFF.Off, TMHI_HVAC_MODE.Cold, 21, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT));  // ON, Auto 21graden
  WriteDumpFile('Airco Cool, 22', TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.On, TMHI_HVAC_ONOFF.Off, TMHI_HVAC_MODE.Cold, 22, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT));  // ON, Auto 22graden
  WriteDumpFile('Airco Cool, 23', TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.On, TMHI_HVAC_ONOFF.Off, TMHI_HVAC_MODE.Cold, 23, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT));  // ON, Auto 23graden
  WriteDumpFile('Airco Cool, 24', TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.On, TMHI_HVAC_ONOFF.Off, TMHI_HVAC_MODE.Cold, 24, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT));  // ON, Auto 24graden
  WriteDumpFile('Airco Cool, 25', TMHI_HVAC_BroadLink.CreateDataString(TMHI_HVAC_ONOFF.On, TMHI_HVAC_ONOFF.Off, TMHI_HVAC_MODE.Cold, 25, TMHI_HVAC_Wide.Swing, TMHI_HVAC_Fan.Auto, TMHI_HVAC_Vane.VaneSwing, CNST_DATAFORMAT));  // ON, Auto 25graden

  myHVAC := TMHI_HVAC_BroadLink.Create;
  try
    myHVAC.WriteToConsole();
//    Writeln('IRData: ' + #13#10, myHVAC.Hex);
//    Writeln('BLHexData: ' + #13#10, myHVAC.BroadLinkHexData);
//    Writeln('BLASCIIData: ' + #13#10, myHVAC.BroadLinkAsciiData);
    Writeln;

    myHVAC.Temperature := 20;
    myHVAC.WriteToConsole();
//    Writeln('IRData: ' + #13#10, myHVAC.Hex);
//    Writeln('BLHexData: ' + #13#10, myHVAC.BroadLinkHexData);
//    Writeln('BLASCIIData: ' + #13#10, myHVAC.BroadLinkAsciiData);
    Writeln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  writeln;
  write('druk op enter...');
  readln;
end.
