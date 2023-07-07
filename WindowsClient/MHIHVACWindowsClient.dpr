program MHIHVACWindowsClient;

uses
  Vcl.Forms,
  frmMHIHVACMainU in 'frmMHIHVACMainU.pas' {frmMHIHVACMain},
  Mitsubishi_HVAC in '..\src\Mitsubishi_HVAC.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMHIHVACMain, frmMHIHVACMain);
  Application.Run;
end.
