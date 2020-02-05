program Pixelando;

uses
  Forms,
  UGetPixel in 'UGetPixel.pas' {FGetPixel};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFGetPixel, FGetPixel);
  Application.Run;
end.
