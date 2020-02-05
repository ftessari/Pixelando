unit UGetPixel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, jpeg, Mask, dxGDIPlusClasses;

type
  TFGetPixel = class(TForm)
    StatusBar: TStatusBar;
    PanelBtn: TPanel;
    btnCalc: TBitBtn;
    Memo: TMemo;
    logo: TImage;
    EditPath: TMaskEdit;
    OpenDialog: TOpenDialog;
    imgAnexo: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCalcClick(Sender: TObject);
    procedure EditPathClick(Sender: TObject);
    private
      { Private declarations }
    public
      { Public declarations }
  end;

  TCl = record
    Count: Integer;
    Color: TColor;
  end;

var
  FGetPixel: TFGetPixel;
  b: TBitmap;
  cs: Array of TCl;

implementation

{$R *.dfm}

function ColorIndex(const Cl: TColor): Integer;
var
  l: Integer;
begin
  Result := -1;
  for l := 0 to Length(cs) - 1 do
    if cs[l].Color = Cl then
      begin
        Result := l;
        Break;
      end;
end;

procedure TFGetPixel.btnCalcClick(Sender: TObject);
var
  x, y, i, n: Integer;
  c: Cardinal;
begin
  b := TBitmap.Create;
  SetLength(cs, 0);
  try
    b.LoadFromFile(EditPath.Text);
    with b, Canvas do
      begin
        n := -1;
        for y := 0 to b.Height - 1 do
          for x := 0 to b.Width - 1 do
            begin
              c := Pixels[x, y];
              i := ColorIndex(c);
              if i = -1 then
                begin
                  n := Length(cs);
                  SetLength(cs, n + 1);
                  with cs[n] do
                    begin
                      Inc(Count);
                      Color := c;
                    end;
                end
              else
                Inc(cs[i].Count);
            end;
        if n = 0 then
          Memo.Lines.Add('Encontrado:')
        else
          Memo.Lines.Add('Foram encontrados:');
        Memo.Lines.Add('');
        y := 0;
        n := cs[0].Count;
        for x := 0 to Length(cs) - 1 do
          with cs[x] do
            begin
              Memo.Lines.Add('  ' + IntToStr(Count) + ' pixels da cor ' + ColorToString(Color));
              if Count > n then
                begin
                  y := x;
                  n := Count;
                end;
            end;
        Memo.Lines.Add('');
        Memo.Lines.Add('Cor Predominante: ' + ColorToString(cs[y].Color));
      end;
  finally
    FreeAndNil(b);
  end;
end;

procedure TFGetPixel.EditPathClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    EditPath.Text := OpenDialog.FileName;
  if EditPath.Text <> '' then
    btnCalc.Enabled := true;
end;

procedure TFGetPixel.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
end;

procedure TFGetPixel.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    Close;
end;

end.
