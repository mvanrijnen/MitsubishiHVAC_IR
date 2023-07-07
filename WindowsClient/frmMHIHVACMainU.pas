unit frmMHIHVACMainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmMHIHVACMain = class(TForm)
    rgOperation: TRadioGroup;
    rgMode: TRadioGroup;
    rgHorizontal: TRadioGroup;
    rgFanSpeed: TRadioGroup;
    rgVertical: TRadioGroup;
    rgDataFormat: TRadioGroup;
  private
    { Private declarations }
    procedure UpdateStates;
  public
    { Public declarations }
  end;

var
  frmMHIHVACMain: TfrmMHIHVACMain;

implementation

{$R *.dfm}

{ TfrmMHIHVACMain }

procedure TfrmMHIHVACMain.UpdateStates;
begin

end;

end.
