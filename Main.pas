unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Mask,
  Vcl.WinXPickers, Winapi.ShellAPI, dxSkinsCore, dxSkinDarkroom, cxClasses,
  cxLookAndFeels, dxSkinsForm, dxSkinCoffee, dxSkinBlack;

type
  TMinForm = class(TForm)
    Button1: TButton;
    btGeraLista: TButton;
    btZerar: TButton;
    gbTipo: TGroupBox;
    lbQuantidade: TLabel;
    Label1: TLabel;
    edDescricao: TEdit;
    edQuantidade: TEdit;
    rgTipo: TRadioGroup;
    procedure btGeraListaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btZerarClick(Sender: TObject);
  private
    { Private declarations }
    procedure geraLista;
    function RemoverAcentos(S: String): String;
    procedure inicializa;
  public
    { Public declarations }
    versao : string;
  end;

var
  MinForm: TMinForm;

implementation

uses
  System.SysUtils;

{$R *.dfm}

procedure AbrirPastaDoArquivo(const nomeArquivo: string);
var
  pasta: string;
begin
  // Obtenha o caminho completo do arquivo
  pasta := ExtractFilePath(nomeArquivo);
  // Abra a pasta no explorador de arquivos
  ShellExecute(1, 'open', 'explorer.exe', PChar('/select,' + nomeArquivo), PChar(pasta), SW_SHOWNORMAL);

end;

procedure TMinForm.Button1Click(Sender: TObject);
var
  arq: TextFile; { declarando a variável "arq" do tipo arquivo texto }
  caminho, nome : string;
  X, I : Integer;
  Result: Integer;
  numeros: TArray<String>;

begin
 if edDescricao.Text = '' then
 begin
  ShowMessage('Informe a descrição da Etiqueta!');
  Exit;
 end;

  caminho := extractfilepath(Application.ExeName)+edDescricao.Text+ '.bat';

  try
    I := 0;
    AssignFile(arq,caminho);
    Rewrite(arq);

    writeln(arq,'ECHO OFF');
    writeln(arq,ExtractFileDir(Application.ExeName));
    writeln(arq,'TYPE '+'ETQ'+'.TXT >LPT1'); // nome de acordo o com o nome do txt

    Result := FileSetAttr(caminho,FileGetAttr(caminho));
    CloseFile(arq);
    ShowMessage('Arquivo .BAT criado com sucesso!');
    AbrirPastaDoArquivo(caminho);
   except
    On E: Exception do
      ShowMessage(E.message);
  end;

end;

procedure TMinForm.btZerarClick(Sender: TObject);
var
   SearchRec : TSearchRec;
   caminho: string;
begin
  // deleta todos os arquivos dentro da pasta .txt e .bat
  caminho := ExtractFilePath(Application.ExeName);

   try

      FindFirst(caminho+'*.txt', faAnyFile, SearchRec );
      repeat
         DeleteFile( caminho + SearchRec.name );
      until FindNext( SearchRec ) <> 0;
   finally
      FindClose( SearchRec );
   end;

    try

      FindFirst(caminho+'*.bat', faAnyFile, SearchRec );
      repeat
         DeleteFile( caminho + SearchRec.name );
      until FindNext( SearchRec ) <> 0;
   finally
      FindClose( SearchRec );
   end;

    // detela os arquivos exixtentes antes de começar
//  try
//       DeleteFile(ExtractFilePath(Application.ExeName)+'ETQ.txt');
//       DeleteFile(ExtractFilePath(Application.ExeName)+edDescricao.text+'.bat');
//   Except
//
//  end;

 inicializa;


end;

procedure TMinForm.FormShow(Sender: TObject);
begin
 inicializa;
end;

procedure TMinForm.btGeraListaClick(Sender: TObject);
begin
  if rgTipo.ItemIndex = -1 then
  begin
    ShowMessage('TIPO OBRIGATÓRIO!');
    rgTipo.SetFocus;
    Exit;
  end;
  geraLista;

end;

procedure TMinForm.geraLista;
var
  arq: TextFile; { declarando a variável "arq" do tipo arquivo texto }
  caminho, nome : string;
  X, I : Integer;
  Result: Integer;
  numeros: TArray<String>;

begin
      {
       Arquivo do Sistema = faSysFile,
       Oculta Arquivo     = faHidden,
       Só Leitura         = faReadOnly
      }
      //      Result := FileSetAttr(caminho,
      //      FileGetAttr(caminho) or faSysFile);

      //      Result := FileSetAttr(caminho,
      //      FileGetAttr(caminho) or faHidden);

  case rgTipo.ItemIndex of

    0:begin  // texto normal

        if edDescricao.Text = '' then
        begin
          ShowMessage('Informe a descrição da Etiqueta!');
          edDescricao.SetFocus;
          Exit;
        end;

        if edQuantidade.Text = '' then
        begin
          ShowMessage('Informe a quantidade da Etiqueta!');
          edQuantidade.SetFocus;
          Exit;
        end;

        caminho := extractfilepath(Application.ExeName)+'ETQ'+'.txt';

        try
          I := 0;
          AssignFile(arq,caminho);
          Rewrite(arq);

          for I := 0 to  StrToInt(edQuantidade.Text) do
          begin

          // Exemplo 1 Padrao
            writeln(arq,'^XA');
            writeln(arq,'^CF0,40');
            writeln(arq,'^CF0,150');
            writeln(arq,'^FO185,20');
            writeln(arq,'^FD'+edDescricao.text+'^FS'); // gera qualquer nome
            writeln(arq,'^SZ');//Redefinição da impressora
            writeln(arq,'^XZ');

          end;

//           Result := FileSetAttr(caminho, FileGetAttr(caminho) or faReadOnly); // executa os comando de leitura ou nao
            Result := FileSetAttr(caminho, FileGetAttr(caminho));
            CloseFile(arq);
            ShowMessage('Arquivo criado com sucesso!');
            AbrirPastaDoArquivo(caminho);

         except

//          On E: Exception do
//            ShowMessage(E.message);
            ShowMessage('ERRO, Clique no botao ZERAR !');

        end;

      end;

    1:begin // numero
        if edQuantidade.Text = '' then
        begin
          ShowMessage('Informe a quantidade da Etiqueta!');
          edQuantidade.SetFocus;
          Exit;
        end;

        caminho := extractfilepath(Application.ExeName)+'ETQ'+'.txt';

        try
          I := 0;
          AssignFile(arq,caminho);
          Rewrite(arq);

          for I := 0 to  StrToInt(edQuantidade.Text) do
          begin

          // Exemplo 1 Padrao
            writeln(arq,'^XA');
            writeln(arq,'^CF0,40');
            writeln(arq,'^CF0,150');
            writeln(arq,'^FO185,20');
            writeln(arq,'^FD'+Format('%2.3d', [I])+'^FS'); // gera Numero aqui sera onde vai modificar os nbumero ( Ex:01,02 ... 300
            writeln(arq,'^SZ');//Redefinição da impressora
            writeln(arq,'^XZ');


          end;

            Result := FileSetAttr(caminho,
            FileGetAttr(caminho));
            CloseFile(arq);

            ShowMessage('Arquivo criado com sucesso!');
            AbrirPastaDoArquivo(caminho);

         except
//
//          On E: Exception do
//
//            ShowMessage(E.message);
          ShowMessage('ERRO, Clique no botao ZERAR !');

        end;


      end;


  end;


end;


procedure TMinForm.inicializa;
begin
   rgTipo.ItemIndex := -1;
   edDescricao.Text := '';
   edQuantidade.Text := '';
   edDescricao.SetFocus;

end;

function TMinForm.RemoverAcentos(S: String): String;
const StrA = 'áéíóúàèìòùãõâêîôûçüÁÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕÇÜ';
      StrB = 'aeiouaeiouaoaeioucuAEIOUAEIOUAEIOUAOCU';
var i,aPos: Integer;
begin
  for i:= 1 to Length(S) do
    begin
      aPos:= Pos(S[i],StrA);
      if aPos > 0 then S[i]:= StrB[aPos];
    end;
  Result:= S;
end;

end.
