program GeraTxt;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  Unit2 in 'Unit2.pas' {Form2},
  Vcl.Themes,
  Vcl.Styles,
  uDados in 'uDados.pas' {dmDados: TDataModule},
  uEtiqueta in 'uEtiqueta.pas' {formEtiqueta};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TdmDados, dmDados);
  Application.CreateForm(TformEtiqueta, formEtiqueta);

  Application.Run;
end.
