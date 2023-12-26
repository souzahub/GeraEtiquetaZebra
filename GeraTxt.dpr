program GeraTxt;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MinForm},
  Unit2 in 'Unit2.pas' {Form2},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.CreateForm(TMinForm, MinForm);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
