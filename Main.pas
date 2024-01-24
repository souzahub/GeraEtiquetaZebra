unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Mask,
  Vcl.WinXPickers, Winapi.ShellAPI, dxSkinsCore, dxSkinDarkroom, cxClasses,
  cxLookAndFeels, dxSkinsForm, dxSkinCoffee, dxSkinBlack, Vcl.Samples.Spin,
  uEtiqueta, uDados;

type
  TMainForm = class(TForm)
    Button1: TButton;
    btGeraLista: TButton;
    btZerar: TButton;
    gbTipo: TGroupBox;
    lbQuantidade: TLabel;
    lbDescricao: TLabel;
    edDescricao: TEdit;
    edQuantidade: TEdit;
    rgTipo: TRadioGroup;
    btDados: TButton;
    pnVertical: TPanel;
    Label2: TLabel;
    sbFonte: TSpinEdit;
    Label3: TLabel;
    sbLargura: TSpinEdit;
    Label4: TLabel;
    sbAltura: TSpinEdit;
    rghModelo: TRadioGroup;
    pnHorizontal: TPanel;
    Label1: TLabel;
    sbComprimentoV: TSpinEdit;
    Label5: TLabel;
    sbAlturaV: TSpinEdit;
    sbCompriTextoV: TSpinEdit;
    Comprimento_texto: TLabel;
    sbAlturaTextoV: TSpinEdit;
    Label6: TLabel;
    procedure btGeraListaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btZerarClick(Sender: TObject);
    procedure rgTipoClick(Sender: TObject);
    procedure btDadosClick(Sender: TObject);
    procedure rghModeloClick(Sender: TObject);
  private
    { Private declarations }
    xAltura, xLargura, xFonte : string;
    xComprVert, xAltVert, xComprTVert, xAltTVert : string;
    procedure geraLista;
    function RemoverAcentos(S: String): String;
    procedure inicializa;
    procedure ArquivoBat;
    procedure DirecionaPainel;

  public
    { Public declarations }
    versao : string;

  end;

var
  MainForm: TMainForm;

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

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ArquivoBat;
end;

procedure TMainForm.btZerarClick(Sender: TObject);
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

   ShowMessage('Zerado com sucesso !');

    // detela os arquivos exixtentes antes de começar
//  try
//       DeleteFile(ExtractFilePath(Application.ExeName)+'ETQ.txt');
//       DeleteFile(ExtractFilePath(Application.ExeName)+edDescricao.text+'.bat');
//   Except
//
//  end;

 inicializa;
 DirecionaPainel;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 inicializa;
 DirecionaPainel;
end;

procedure TMainForm.btDadosClick(Sender: TObject);
begin
  dmDados.xAtivaBusca := True;
  formEtiqueta.showmodal;
  Exit;
end;

procedure TMainForm.btGeraListaClick(Sender: TObject);
begin
  if rgTipo.ItemIndex = -1 then
  begin
    Application.MessageBox('Tipo Obrigatório!',' ATENÇÃO ',mb_Ok+MB_ICONINFORMATION);
    rgTipo.SetFocus;
    Exit;

  end;


  if rghModelo.ItemIndex = -1 then
  begin
    Application.MessageBox('Modelo Obrigatório!',' ATENÇÃO ',mb_Ok+MB_ICONINFORMATION);
    rghModelo.SetFocus;
    Exit;

  end;

  if (edQuantidade.Text = '0') or (edQuantidade.Text = '') then
  begin
    Application.MessageBox('Quantidade zerada ou sem dados!',' ATENÇÃO ',mb_Ok+MB_ICONINFORMATION);
    edQuantidade.SetFocus;
    Exit;

  end;


  // horizontal
  xAltura := sbAltura.Text;
  xFonte := sbFonte.Text;
  xLargura := sbLargura.Text;


  //vertical
  xComprVert := sbComprimentoV.Text;
  xAltVert := sbAlturaV.Text;
  xComprTVert := sbCompriTextoV.Text;
  xAltTVert := sbAlturaTextoV.Text;

  geraLista;

end;

procedure TMainForm.geraLista;
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

 case rghModelo.ItemIndex of

  // Vertical
  0:begin

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

                for I := 1 to  StrToInt(edQuantidade.Text) do
                begin
                // Exemplo 1 Padrao
//                 ^FT  = COMPRIMENTO,ALTURA
//                 ^A0B = COMPRIMENTO_TEXTO,ALTURA_TEXTO
//                 xComprVert, xAltVert, xComprTVert, xAltTVert

                  writeln(arq,'^XA');
                  writeln(arq,'^FT'+xComprVert+','+xAltVert);
                  writeln(arq,'^A0B,'+xComprTVert+','+xAltTVert);
                  writeln(arq,'^FH\^CI28');
                  writeln(arq,'^FD'+edDescricao.text);  // gera qualquer nome
                  writeln(arq,'^FS');
                  writeln(arq,'^CI27');
                  writeln(arq,'^SZ');
                  writeln(arq,'^XZ');

                  Next;
                end;
      //           Result := FileSetAttr(caminho, FileGetAttr(caminho) or faReadOnly); // executa os comando de leitura ou nao
                  Result := FileSetAttr(caminho, FileGetAttr(caminho));
                  CloseFile(arq);
                  ShowMessage('Arquivo criado com sucesso!');
                  ArquivoBat; // gera o arqui.Bat para clicar
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

                for I := 1 to  StrToInt(edQuantidade.Text) do
                begin
                // Exemplo 1 Padrao
                  writeln(arq,'^XA');
                  writeln(arq,'^FT'+xComprVert+','+xAltVert);
                  writeln(arq,'^A0B,'+xComprTVert+','+xAltTVert);
                  writeln(arq,'^FH\^CI28');
                  writeln(arq,'^FD'+Format('%2.3d', [I]));  // gera qualquer nome
                  writeln(arq,'^FS');
                  writeln(arq,'^CI27');
                  writeln(arq,'^SZ');
                  writeln(arq,'^XZ');
                  Next;
                end;
                  Result := FileSetAttr(caminho,
                  FileGetAttr(caminho));
                  CloseFile(arq);

                  ShowMessage('Arquivo criado com sucesso!');
                  ArquivoBat; // gera o arqui.Bat para clicar
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

  // Horizontal
  1:begin

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

              for I := 1 to  StrToInt(edQuantidade.Text) do
              begin
              // Exemplo 1 Padrao
                writeln(arq,'^XA');
                writeln(arq,'^CF0,'+xFonte);
                writeln(arq,'^FO'+xLargura+','+xAltura);
                writeln(arq,'^FD'+edDescricao.text+'^FS'); // gera qualquer nome
                writeln(arq,'^SZ');//Redefinição da impressora
                writeln(arq,'^XZ');
                Next;
              end;
    //           Result := FileSetAttr(caminho, FileGetAttr(caminho) or faReadOnly); // executa os comando de leitura ou nao
                Result := FileSetAttr(caminho, FileGetAttr(caminho));
                CloseFile(arq);
                ShowMessage('Arquivo criado com sucesso!');
                ArquivoBat; // gera o arqui.Bat para clicar
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

              for I := 1 to  StrToInt(edQuantidade.Text) do
              begin
              // Exemplo 1 Padrao
                writeln(arq,'^XA');
                writeln(arq,'^CF0,'+xFonte);
                writeln(arq,'^FO'+xLargura+','+xAltura);
                writeln(arq,'^FD'+Format('%2.3d', [I])+'^FS'); // gera Numero aqui sera onde vai modificar os nbumero ( Ex:01,02 ... 300
                writeln(arq,'^SZ');//Redefinição da impressora
                writeln(arq,'^XZ');
                Next;
              end;
                Result := FileSetAttr(caminho,
                FileGetAttr(caminho));
                CloseFile(arq);

                ShowMessage('Arquivo criado com sucesso!');
                ArquivoBat; // gera o arqui.Bat para clicar
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



 end;



end;


procedure TMainForm.inicializa;
begin

  rghModelo.ItemIndex := -1;
  rgTipo.ItemIndex := -1;
  edDescricao.Text := '';
  edQuantidade.Text := '';
  lbDescricao.Enabled := True;
  edDescricao.Enabled := True;
  edDescricao.SetFocus;

  // Horizontal inicia padrao
  sbFonte.Text := '150'; // Fonte
  sbLargura.Text := '185'; // Largura (esrquerda, direita)
  sbAltura.Text := '20'; //(altura)

  // Vertical
  sbComprimentoV.Text := '500';
  sbAlturaV.Text := '1100';
  sbCompriTextoV.Text := '200';
  sbAlturaTextoV.Text := '130';

end;

procedure TMainForm.ArquivoBat;
var
  caminho: string;
  I: Integer;
  arq: TextFile; { declarando a variável "arq" do tipo arquivo texto }
  Result: Integer;
begin


  caminho := extractfilepath(Application.ExeName) + 'GERAR ETIQUETA' + '.bat';
  try
    I := 0;
    AssignFile(arq, caminho);
    Rewrite(arq);
    writeln(arq, 'ECHO OFF');
    writeln(arq, ExtractFileDir(Application.ExeName));
    writeln(arq, 'TYPE ' + 'ETQ' + '.TXT >LPT1');
    // nome de acordo o com o nome do txt
    Result := FileSetAttr(caminho, FileGetAttr(caminho));
    CloseFile(arq);
    ShowMessage('Arquivo .BAT criado com sucesso!');

  except
    on E: Exception do
      ShowMessage(E.message);
  end;

end;

procedure TMainForm.DirecionaPainel;
begin
  case rghModelo.ItemIndex of
   -1:begin
        pnVertical.Visible := False;
        pnHorizontal.Visible := False;
      end;
    0:
      begin
        pnHorizontal.Visible := True;
        pnVertical.Visible := False;
      end;
    1:
      begin
        pnVertical.Visible := True;
        pnHorizontal.Visible := False;

      end;
  end;

end;

function TMainForm.RemoverAcentos(S: String): String;
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

procedure TMainForm.rghModeloClick(Sender: TObject);
begin

  DirecionaPainel;


end;
procedure TMainForm.rgTipoClick(Sender: TObject);
begin
  case rgTipo.ItemIndex of

   0: begin
        lbDescricao.Enabled := True;
        edDescricao.Enabled := True;
        edDescricao.SetFocus;
      end;

   1: begin
        lbDescricao.Enabled := False;
        edDescricao.Enabled := False;
        edQuantidade.SetFocus;
      end;

  end;
end;

end.
