program MHIHVACWindowsClient;

uses
  Vcl.Forms,
  frmMHIHVACMainU in 'frmMHIHVACMainU.pas' {frmMHIHVACMain},
  Mitsubishi_HVAC in '..\src\Mitsubishi_HVAC.pas',
  ProjLibU in '..\src\ProjLibU.pas',
  BroadLinkU in '..\src\BroadLinkU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMHIHVACMain, frmMHIHVACMain);
  Application.Run;
end.
