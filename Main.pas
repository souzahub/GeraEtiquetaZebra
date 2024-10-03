unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Mask,
  Vcl.WinXPickers, Winapi.ShellAPI, Vcl.Samples.Spin,
  uEtiqueta, uDados, Vcl.StyledButton;

type
  TMainForm = class(TForm)
    Button1: TButton;
    gbTipo: TGroupBox;
    lbQuantidade: TLabel;
    lbDescricao: TLabel;
    edDescricao: TEdit;
    edQtdInicio: TEdit;
    rgTipo: TRadioGroup;
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
    edQtdFim: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    btGeraArquivo: TStyledGraphicButton;
    btIniciar: TStyledGraphicButton;
    StyledGraphicButton2: TStyledGraphicButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rgTipoClick(Sender: TObject);
    procedure rghModeloClick(Sender: TObject);
    procedure btGeraArquivoClick(Sender: TObject);
    procedure btIniciarClick(Sender: TObject);
    procedure StyledGraphicButton2Click(Sender: TObject);
  private
    { Private declarations }
    xAltura, xLargura, xFonte : string;
    xComprVert, xAltVert, xComprTVert, xAltTVert : string;
    procedure geraLista;
    function RemoverAcentos(S: String): String;
    procedure inicializa;
    procedure ArquivoBat;
    procedure DirecionaPainel;
    procedure GeraLogNumero;

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

function Acentua(Texto: String; Hex : char): string;    //By André
var
  i, tam : integer;
  aux : string;
begin
  tam := length(Texto);
  aux := '';
  for i := 1 to tam do
  begin
    case texto[i] of
      'á' : aux := aux + hex + 'A0';     'Õ' : aux := aux + hex + 'E5';     'Œ' : aux := aux + hex + 'c0';     '°' : aux := aux + hex + 'f8';
      'Á' : aux := aux + hex + 'B5';     'ô' : aux := aux + hex + '93';     '‘' : aux := aux + hex + 'c5';     '±' : aux := aux + hex + 'f1';
      'à' : aux := aux + hex + '85';     'Ô' : aux := aux + hex + 'E2';     '’' : aux := aux + hex + 'c8';     '²' : aux := aux + hex + 'fd';
      'À' : aux := aux + hex + 'B7';     'ö' : aux := aux + hex + '94';     '“' : aux := aux + hex + 'c9';     '³' : aux := aux + hex + 'fc';
      'ã' : aux := aux + hex + 'C6';     'Ö' : aux := aux + hex + '99';     '”' : aux := aux + hex + 'ca';     '´' : aux := aux + hex + 'ef';
      'Ã' : aux := aux + hex + 'C7';     'ú' : aux := aux + hex + 'A3';     '•' : aux := aux + hex + 'fa';     'µ' : aux := aux + hex + 'e6';
      'â' : aux := aux + hex + '83';     'Ú' : aux := aux + hex + 'E9';     '–' : aux := aux + hex + 'cb';     '¶' : aux := aux + hex + 'f4';
      'Â' : aux := aux + hex + 'B6';     'ù' : aux := aux + hex + '97';     '—' : aux := aux + hex + 'cc';     '·' : aux := aux + hex + 'fa';
      'ä' : aux := aux + hex + '84';     'Ù' : aux := aux + hex + 'EB';     '˜' : aux := aux + hex + 'ee';     '¸' : aux := aux + hex + 'f7';
      'Ä' : aux := aux + hex + '8E';     'û' : aux := aux + hex + '96';     '™' : aux := aux + hex + 'cd';     '¹' : aux := aux + hex + 'fb';
      'é' : aux := aux + hex + '82';     'Û' : aux := aux + hex + 'EA';     'š' : aux := aux + hex + 'ce';     'º' : aux := aux + hex + 'f8';
      'É' : aux := aux + hex + '90';     'ü' : aux := aux + hex + '81';     '›' : aux := aux + hex + 'd5';     '»' : aux := aux + hex + 'af';
      'è' : aux := aux + hex + '8A';     'Ü' : aux := aux + hex + '9A';     'œ' : aux := aux + hex + 'd9';     '¼' : aux := aux + hex + 'ac';
      'È' : aux := aux + hex + 'D4';     'ç' : aux := aux + hex + '87';     'Ÿ' : aux := aux + hex + 'dc';     '½' : aux := aux + hex + 'ab';
      'ê' : aux := aux + hex + '88';     'Ç' : aux := aux + hex + '80';     {' ' : aux := aux + hex + 'df';}   '¾' : aux := aux + hex + 'f3';
      'Ê' : aux := aux + hex + 'D2';     'ð' : aux := aux + hex + 'd0';     '¡' : aux := aux + hex + 'ad';     '¿' : aux := aux + hex + 'a8';
      'ë' : aux := aux + hex + '89';     '^' : aux := aux + hex + '5e';     '¢' : aux := aux + hex + 'bd';     'Å' : aux := aux + hex + '8f';
      'Ë' : aux := aux + hex + 'D3';     '_' : aux := aux + hex + '5f';     '£' : aux := aux + hex + '9c';     'Æ' : aux := aux + hex + '92';
      'í' : aux := aux + hex + 'A1';     '~' : aux := aux + hex + '7e';     '¤' : aux := aux + hex + 'cf';     'Ì' : aux := aux + hex + 'de';
      'Í' : aux := aux + hex + 'D6';     '€' : aux := aux + hex + 'a7';     '¥' : aux := aux + hex + 'be';     'Ð' : aux := aux + hex + 'd1';
      'ì' : aux := aux + hex + '8D';     '‚' : aux := aux + hex + 'b1';     '¦' : aux := aux + hex + 'dd';     'Ñ' : aux := aux + hex + 'a5';
      'î' : aux := aux + hex + '8C';     'ƒ' : aux := aux + hex + '9f';     '§' : aux := aux + hex + 'f5';     '×' : aux := aux + hex + 'fa';
      'Î' : aux := aux + hex + 'D7';     '„' : aux := aux + hex + 'b2';     '¨' : aux := aux + hex + 'f9';     'Ø' : aux := aux + hex + 'cb';
      'ï' : aux := aux + hex + '8B';     '…' : aux := aux + hex + 'b3';     '©' : aux := aux + hex + 'b8';     'Ý' : aux := aux + hex + 'd5';
      'Ï' : aux := aux + hex + 'D8';     '†' : aux := aux + hex + 'b4';     'ª' : aux := aux + hex + 'a6';     'Þ' : aux := aux + hex + 'd9';
      'ó' : aux := aux + hex + 'A2';     '‡' : aux := aux + hex + 'b9';     '«' : aux := aux + hex + 'ae';     'ß' : aux := aux + hex + 'dc';
      'Ó' : aux := aux + hex + 'E3';     'ˆ' : aux := aux + hex + 'ba';     '¬' : aux := aux + hex + 'aa';     'å' : aux := aux + hex + 'be';
      'ò' : aux := aux + hex + '95';     '‰' : aux := aux + hex + 'bb';     '­' : aux := aux + hex + 'f0';     'æ' : aux := aux + hex + 'dd';
      'Ò' : aux := aux + hex + 'DO';     'Š' : aux := aux + hex + 'bc';     '®' : aux := aux + hex + 'a9';     'ñ' : aux := aux + hex + 'f1';
      'õ' : aux := aux + hex + 'E4';     '‹' : aux := aux + hex + 'bf';     '¯' : aux := aux + hex + 'f2';     'ÿ' : aux := aux + hex + 'fd';
      'ý' : aux := aux + hex + 'ec';
    else
      aux := aux + texto[i];
    end;
  end;
  Result := Aux;
end;

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

procedure TMainForm.FormShow(Sender: TObject);
begin
 inicializa;
 DirecionaPainel;
end;

procedure TMainForm.btGeraArquivoClick(Sender: TObject);
begin
// GeraLogNumero; // gera log
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

  if (edQtdInicio.Text = '0') or (edQtdInicio.Text = '') or (edQtdFim.Text = '0') or (edQtdFim.Text = '')then
  begin
    Application.MessageBox('Quantidade zerada ou sem dados!',' ATENÇÃO ',mb_Ok+MB_ICONINFORMATION);

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
  nome : string;
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

              if (edQtdInicio.Text = '') or (edQtdFim.Text = '') then
              begin
                ShowMessage('Informe a quantidade da Etiqueta!');

                Exit;
              end;

             try
                I := 0;
                AssignFile(arq,'LPT1'); //direciona para impressora

                try
                 Rewrite(arq);
                except

                end;

                for I := StrToInt(edQtdInicio.Text) to  StrToInt(edQtdFim.Text) do
                begin

                   writeln(arq,'~JSN^XA');
                   writeln(arq,'^COY,1^MMT^MD');
                   writeln(arq,'^XZ');
                   writeln(arq,'^XA');
                   writeln(arq,'^PRB^FS');
                   writeln(arq,'^XA');
                   writeln(arq,'^FT'+xComprVert+','+xAltVert);
                   writeln(arq,'^A0B,'+xComprTVert+','+xAltTVert);
                   writeln(arq,'^FR^FH^FD'+Acentua(edDescricao.Text,'_')+'^FS');  // gera qualquer nome
                   writeln(arq,'^ISSTRNWARE,N^FS');
                   writeln(arq,'^XZ');
                   writeln(arq,'^XA');
                   writeln(arq,'^ILSTRNWARE^FS');
                   writeln(arq,'^PF0^FS');
                   writeln(arq,'^PQ1,0,1,Y');
                   writeln(arq,'^XZ');
                   writeln(arq,'^XA');
                   writeln(arq,'^IDSTRNWARE');
                   writeln(arq,'^XZ');
                   Next;
                  // Exemplo 1 Padrao
  //                 ^FT  = COMPRIMENTO,ALTURA
  //                 ^A0B = COMPRIMENTO_TEXTO,ALTURA_TEXTO
  //                 xComprVert, xAltVert, xComprTVert, xAltTVert

//                    writeln(arq,'^XA');
//                    writeln(arq,'^CI28'); // aceita acento
//                    writeln(arq,'^FT'+xComprVert+','+xAltVert);
//                    writeln(arq,'^A0B,'+xComprTVert+','+xAltTVert);
//                    writeln(arq,'^FH\^CI28');
//                    writeln(arq,'^FD'+edDescricao.text);  // gera qualquer nome
//                    writeln(arq,'^FS');
//                    writeln(arq,'^CI27');
//                    writeln(arq,'^SZ');
//                    writeln(arq,'^XZ');
                end;

                CloseFile(arq);

              except


              ShowMessage('ERRO AO IMPRIMIR!');

             end;

            end;

          1:begin // numero

              if (edQtdInicio.Text = '') or (edQtdFim.Text = '') then
              begin
                ShowMessage('Informe a quantidade da Etiqueta!');
                edQtdInicio.SetFocus;
                Exit;
              end;

              try

                I := 0;
                AssignFile(arq,'LPT1'); //direciona para impressora

                try
                 Rewrite(arq);
                except

                end;

                for I := StrToInt(edQtdInicio.Text) to  StrToInt(edQtdFim.Text) do
                begin

                // Exemplo 1 Padrao
                  writeln(arq,'~JSN^XA');
                  writeln(arq,'^COY,1^MMT^MD');
                  writeln(arq,'^XZ');
                  writeln(arq,'^XA');
                  writeln(arq,'^PRB^FS');
                  writeln(arq,'^XA');
                  writeln(arq,'^FT'+xComprVert+','+xAltVert);
                  writeln(arq,'^A0B,'+xComprTVert+','+xAltTVert);
                  writeln(arq,'^FD'+Format('%2.3d', [I]));  // gera qualquer nome
                  writeln(arq,'^ISSTRNWARE,N^FS');
                  writeln(arq,'^XZ');
                  writeln(arq,'^XA');
                  writeln(arq,'^ILSTRNWARE^FS');
                  writeln(arq,'^PF0^FS');
                  writeln(arq,'^PQ1,0,1,Y');
                  writeln(arq,'^XZ');
                  writeln(arq,'^XA');
                  writeln(arq,'^IDSTRNWARE');
                  writeln(arq,'^XZ');
                  Next;

                end;
//                GeraLogNumero; // gera log
                CloseFile(arq);

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

            if (edQtdInicio.Text = '') or (edQtdFim.Text = '') then
            begin
              ShowMessage('Informe a quantidade da Etiqueta!');

              Exit;
            end;


            try
              I := 0;
              AssignFile(arq,'LPT1'); //direciona para impressora

              try
               Rewrite(arq);
               except

              end;

              for I := StrToInt(edQtdInicio.Text) to  StrToInt(edQtdFim.Text) do
              begin

                writeln(arq,'~JSN^XA');
                writeln(arq,'^COY,1^MMT^MD');
                writeln(arq,'^XZ');
                writeln(arq,'^XA');
                writeln(arq,'^CF0,'+xFonte);
                writeln(arq,'^FO'+xLargura+','+xAltura);
                writeln(arq,'^FR^FH^FD'+Acentua(edDescricao.Text,'_')+'^FS');  // gera qualquer nome
                writeln(arq,'^ISSTRNWARE,N^FS');
                writeln(arq,'^XZ');
                writeln(arq,'^XA');
                writeln(arq,'^ILSTRNWARE^FS');
                writeln(arq,'^PF0^FS');
                writeln(arq,'^PQ1,0,1,Y');
                writeln(arq,'^XZ');
                writeln(arq,'^XA');
                writeln(arq,'^IDSTRNWARE');
                writeln(arq,'^XZ');
                Next;

              end;

              CloseFile(arq);

             except

    //          On E: Exception do
    //            ShowMessage(E.message);
                ShowMessage('ERRO, Clique no botao ZERAR !');

            end;

          end;

        1:begin // numero
            if (edQtdInicio.Text = '') or (edQtdFim.Text = '') then
            begin
              ShowMessage('Informe a quantidade da Etiqueta!');

              Exit;
            end;

            try
              I := 0;
              AssignFile(arq,'LPT1'); //direciona para impressora

              try
               Rewrite(arq);
               except

              end;

              for I := StrToInt(edQtdInicio.Text) to  StrToInt(edQtdFim.Text) do
              begin

                writeln(arq,'~JSN^XA');
                writeln(arq,'^COY,1^MMT^MD');
                writeln(arq,'^XZ');
                writeln(arq,'^XA');
                writeln(arq,'^CF0,'+xFonte);
                writeln(arq,'^FO'+xLargura+','+xAltura);
                writeln(arq,'^FD'+Format('%2.3d', [I])+'^FS'); // gera Numero aqui sera onde vai modificar os nbumero ( Ex:01,02 ... 300
                writeln(arq,'^ISSTRNWARE,N^FS');
                writeln(arq,'^XZ');
                writeln(arq,'^XA');
                writeln(arq,'^ILSTRNWARE^FS');
                writeln(arq,'^PF0^FS');
                writeln(arq,'^PQ1,0,1,Y');
                writeln(arq,'^XZ');
                writeln(arq,'^XA');
                writeln(arq,'^IDSTRNWARE');
                writeln(arq,'^XZ');
                Next;
              end;
              CloseFile(arq);


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


procedure TMainForm.GeraLogNumero;
var
  arq: TextFile; { declarando a variável "arq" do tipo arquivo texto }
  caminho, nome : string;
  X : Integer;
  Result: Integer;

begin

  caminho := extractfilepath(Application.ExeName)+'log\'+'Log_'+FormatDateTime('hhmmss.zzz', Now) + '.txt';
  X := 0;

  try

     AssignFile(arq,caminho);
     Rewrite(arq);
     Writeln(arq,'============================');
     Writeln(arq,'LOG GERA ETIQUETA');
     Writeln(arq,'Data: '+DateTimeToStr(Now));
     Writeln(arq,'============================');
     Writeln(arq,'');


     writeln(arq,'De'+' - ', edQtdInicio.Text);
     writeln(arq,'Até'+' - ', edQtdFim.Text);
     writeln(arq,'');
     CloseFile(arq);


   except
    On E: Exception do
      ShowMessage(E.message);

  end;

end;

procedure TMainForm.inicializa;
begin

  rghModelo.ItemIndex := -1;
  rgTipo.ItemIndex := -1;
  edDescricao.Text := '';
  edQtdInicio.Text := '';
  edQtdFim.Text := '';
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
  arq: TextFile; { declarando a variável "arq" do tipo arquivo texto }
  Result: Integer;
begin
  caminho := extractfilepath(Application.ExeName) + 'GERAR ETIQUETA' + '.bat';
  try
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
  edQtdInicio.Text := '';
  edQtdFim.Text := '';

  case rgTipo.ItemIndex of

   0: begin
        edQtdInicio.Text := '1';
        edQtdFim.Text := '1';
        lbDescricao.Enabled := True;
        edDescricao.Enabled := True;
        edDescricao.SetFocus;
      end;

   1: begin
        edQtdInicio.SetFocus;
        lbDescricao.Enabled := False;
        edDescricao.Enabled := False;

      end;

  end;
end;

procedure TMainForm.StyledGraphicButton2Click(Sender: TObject);
begin
  dmDados.xAtivaBusca := True;
  formEtiqueta.showmodal;
  Exit;
end;

procedure TMainForm.btIniciarClick(Sender: TObject);
var
   SearchRec : TSearchRec;
   caminho: string;
begin

 inicializa;
 DirecionaPainel;
  // deleta todos os arquivos dentro da pasta .txt e .bat
//
//  caminho := ExtractFilePath(Application.ExeName);
//
//   try
//
//      FindFirst(caminho+'*.txt', faAnyFile, SearchRec );
//      repeat
//         DeleteFile( caminho + SearchRec.name );
//      until FindNext( SearchRec ) <> 0;
//   finally
//      FindClose( SearchRec );
//   end;
//
//    try
//
//      FindFirst(caminho+'*.bat', faAnyFile, SearchRec );
//      repeat
//         DeleteFile( caminho + SearchRec.name );
//      until FindNext( SearchRec ) <> 0;
//   finally
//      FindClose( SearchRec );
//   end;
//
//   ShowMessage('Zerado com sucesso !');

    // detela os arquivos exixtentes antes de começar
//  try
//       DeleteFile(ExtractFilePath(Application.ExeName)+'ETQ.txt');
//       DeleteFile(ExtractFilePath(Application.ExeName)+edDescricao.text+'.bat');
//   Except
//
//  end;



end;

end.
