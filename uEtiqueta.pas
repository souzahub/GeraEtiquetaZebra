unit uEtiqueta;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.WinXPanels, Vcl.ExtCtrls,
  Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, System.ImageList,
  Vcl.ImgList, Vcl.Mask, Vcl.DBCtrls, uDados, Vcl.Samples.Spin;

type
  TformEtiqueta = class(TForm)
    PnPrincipal: TCardPanel;
    CardCadastro: TCard;
    CardPesquisa: TCard;
    pnPesquisa: TPanel;
    pnPesquisaBotoes: TPanel;
    pnGrid: TPanel;
    edPesquisar: TEdit;
    lbPesquisar: TLabel;
    ImageList1: TImageList;
    btFechar: TButton;
    btIncluir: TButton;
    btAlterar: TButton;
    btExcluir: TButton;
    Panel1: TPanel;
    btCancelar: TButton;
    btSalvar: TButton;
    Panel3: TPanel;
    Label2: TLabel;
    Panel6: TPanel;
    dsEtq: TDataSource;
    DBGrid1: TDBGrid;
    btLimpar: TButton;
    edNome: TEdit;
    Label3: TLabel;
    lbCod: TLabel;
    Panel2: TPanel;
    rghModelo: TRadioGroup;
    pnHorizontal: TPanel;
    edFonte: TEdit;
    Label1: TLabel;
    edComprimento: TEdit;
    Label4: TLabel;
    edAltura: TEdit;
    Label5: TLabel;
    pnVertical: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Comprimento_texto: TLabel;
    Label8: TLabel;
    sbComprimentoV: TSpinEdit;
    sbAlturaV: TSpinEdit;
    sbCompriTextoV: TSpinEdit;
    sbAlturaTextoV: TSpinEdit;
    rgConsulta: TRadioGroup;
    procedure btIncluirClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edPesquisarKeyPress(Sender: TObject; var Key: Char);
    procedure edPesquisarChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dsEtqDataChange(Sender: TObject; Field: TField);
    procedure rghModeloClick(Sender: TObject);
  private
    procedure LocalizaId;
    procedure BuscaDinamica;
    procedure DirecionaPainel; // direciona para o ultimo registro celecionado pelo ID
    { Private declarations }
  public
    xIncluindo, xDeletando, xEditando, xSoAlerta: Boolean;
    xCod : Integer;
    xStaus : string;
  end;

var
  formEtiqueta: TformEtiqueta;

implementation

{$R *.dfm}

uses Winapi.Windows, System.Threading, Main;

procedure TformEtiqueta.btAlterarClick(Sender: TObject);
begin
  if dmDados.FDEtq.IsEmpty then Exit;
  PnPrincipal.ActiveCard := CardCadastro;// ativa card cadastro

  edNome.Text := dmDados.FDEtqNOME.value;
  edFonte.text := IntToStr(dmDados.FDEtqFONTE.value);
  edComprimento.text:= IntToStr(dmDados.FDEtqLARGURA.value);
  edAltura.text:= IntToStr(dmDados.FDEtqALTURA.value);

  rghModelo.ItemIndex := dmDados.FDEtqMODELO.value;

  sbComprimentoV.Text := IntToStr(dmDados.FDEtqCOMPRIMENTO_V.value);
  sbCompriTextoV.Text := IntToStr(dmDados.FDEtqCOMPRIMENTOT_V.value);
  sbAlturaV.Text := IntToStr(dmDados.FDEtqALTURA_V.value);
  sbAlturaTextoV.Text := IntToStr(dmDados.FDEtqALTURAT_V.value);

  xEditando := True;
  xDeletando := False;

end;

procedure TformEtiqueta.btCancelarClick(Sender: TObject);
begin
  LocalizaId;
  PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa
end;

procedure TformEtiqueta.btExcluirClick(Sender: TObject);
var
xErro : string;

begin
  if dmDados.FDEtq.IsEmpty then Exit;

   If MessageDlg(' DESEJA Excluir '+dmDados.FDEtqNOME.Value+' ?',mtConfirmation,[mbyes,mbno],0) = mryes then
   begin
     dmDados.FDEtq.delete;
     dmDados.FDEtq.Refresh;
     dmDados.FDEtq.Close();
     dmDados.FDEtq.Open();
     exit;
   end
   else
   begin
     Exit;
   end;

end;

procedure TformEtiqueta.btFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TformEtiqueta.btIncluirClick(Sender: TObject);
begin
  PnPrincipal.ActiveCard := CardCadastro;// ativa card cadastro
  rghModelo.ItemIndex := -1;
  edNome.Text := '';
  edFonte.text := '0';
  edComprimento.text := '0';
  edAltura.text := '0';

  sbComprimentoV.Text := '0';
  sbAlturaV.Text :='0';
  sbCompriTextoV.Text := '0';
  sbAlturaTextoV.Text :='0';

  DirecionaPainel;
    
  xIncluindo := True;
  xEditando := False;
  xDeletando := False;

end;

procedure TformEtiqueta.btSalvarClick(Sender: TObject);
var
xErro: string;
begin

    if Trim(edNome.Text) = '' then
    begin
      Application.MessageBox('Preencha o nome!',' ATENÇÃO ',mb_Ok+MB_ICONINFORMATION);
      edNome.SetFocus;
      exit;
    end;

    if (Trim(edFonte.Text) = '') or (Trim(edComprimento.Text) = '') or (Trim(edAltura.Text) = '') then
    begin
      Application.MessageBox('Fonte, Comprimento, Altura!',' Campos obrigatórios ',mb_Ok+MB_ICONINFORMATION);
      exit;
    end;


    if rghModelo.ItemIndex = -1 then
    begin
      Application.MessageBox('Modelo obrigatório!',' ATENÇÃO ',mb_Ok+MB_ICONINFORMATION);
      rghModelo.SetFocus;
      Exit;
    end;

    If MessageDlg(' DESEJA SALVAR ?',mtConfirmation,[mbyes,mbno],0) = mryes then
    begin

       case rghModelo.ItemIndex of
          -1:
            begin
              edFonte.text := '0';
              edComprimento.text := '0';
              edAltura.text := '0';
              sbComprimentoV.Text := '0';
              sbAlturaV.Text :='0';
              sbCompriTextoV.Text := '0';
              sbAlturaTextoV.Text :='0';

            end;
          0:
            begin
              edFonte.text := '0';
              edComprimento.text := '0';
              edAltura.text := '0';

            end;
          1:
            begin
              sbComprimentoV.Text := '0';
              sbAlturaV.Text :='0';
              sbCompriTextoV.Text := '0';
              sbAlturaTextoV.Text :='0';

            end;

        end;



      if xIncluindo then
      begin
        dmDados.FDAuxiliar.Close;
        dmDados.FDAuxiliar.SQL.Clear;
        dmDados.FDAuxiliar.SQL.Add('insert into ETIQUETAS (NOME, FONTE, LARGURA, ALTURA, CADASTRO,'
        +'MODELO, COMPRIMENTO_V, ALTURA_V, COMPRIMENTOT_V, ALTURAT_V)');

        dmDados.FDAuxiliar.SQL.Add('values(:vNOME, :vFONTE, :vLARGURA, :vALTURA, :vCADASTRO,'
        +':vMODELO, :vCOMPRIMENTO_V, :vALTURA_V, :vCOMPRIMENTOT_V, :vALTURAT_V)');

        dmDados.FDAuxiliar.ParamByName('vNOME').Value := edNome.Text;
        dmDados.FDAuxiliar.ParamByName('vFONTE').Value := StrToInt(edFonte.Text);
        dmDados.FDAuxiliar.ParamByName('vLARGURA').Value := StrToInt(edComprimento.Text);
        dmDados.FDAuxiliar.ParamByName('vALTURA').Value := StrToInt(edAltura.Text);
        dmDados.FDAuxiliar.ParamByName('vCADASTRO').Value := now;
        dmDados.FDAuxiliar.ParamByName('vMODELO').Value := rghModelo.ItemIndex;
        dmDados.FDAuxiliar.ParamByName('vCOMPRIMENTO_V').Value := StrToInt(sbComprimentoV.Text);
        dmDados.FDAuxiliar.ParamByName('vALTURA_V').Value := StrToInt(sbAlturaV.Text);
        dmDados.FDAuxiliar.ParamByName('vCOMPRIMENTOT_V').Value := StrToInt(sbCompriTextoV.Text);
        dmDados.FDAuxiliar.ParamByName('vALTURAT_V').Value := StrToInt(sbAlturaTextoV.Text);

        dmDados.FDAuxiliar.ExecSQL( xErro );
        dmDados.FDEtq.Close;
        dmDados.FDEtq.Open;

        xIncluindo := False;

//        LocalizaId;

        PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa

      end;

      if xEditando then
      begin
        dmDados.FDAuxiliar.Close;
        dmDados.FDAuxiliar.SQL.Clear;
        dmDados.FDAuxiliar.SQL.Add('update ETIQUETAS set NOME=:vNOME, FONTE=:vFONTE, LARGURA=:vLARGURA, ALTURA=:vALTURA,'
        +'MODELO=:vMODELO, COMPRIMENTO_V=:vCOMPRIMENTO_V, ALTURA_V=:vALTURA_V, COMPRIMENTOT_V=:vCOMPRIMENTOT_V, ALTURAT_V=:vALTURAT_V where ID=:vID');

        dmDados.FDAuxiliar.ParamByName('vNOME').Value := edNome.Text;
        dmDados.FDAuxiliar.ParamByName('vFONTE').Value := StrToInt(edFonte.Text);
        dmDados.FDAuxiliar.ParamByName('vLARGURA').Value := StrToInt(edComprimento.Text);
        dmDados.FDAuxiliar.ParamByName('vALTURA').Value := StrToInt(edAltura.Text);
        dmDados.FDAuxiliar.ParamByName('vMODELO').Value := rghModelo.ItemIndex;
        dmDados.FDAuxiliar.ParamByName('vCOMPRIMENTO_V').Value := StrToInt(sbComprimentoV.Text);
        dmDados.FDAuxiliar.ParamByName('vALTURA_V').Value := StrToInt(sbAlturaV.Text);
        dmDados.FDAuxiliar.ParamByName('vCOMPRIMENTOT_V').Value := StrToInt(sbCompriTextoV.Text);
        dmDados.FDAuxiliar.ParamByName('vALTURAT_V').Value := StrToInt(sbAlturaTextoV.Text);
        dmDados.FDAuxiliar.ParamByName('vID').Value := dmDados.FDEtqID.Value;

        dmDados.FDAuxiliar.ExecSQL( xErro );
        dmDados.FDEtq.Close;
        dmDados.FDEtq.Open;

        xEditando := False;
        LocalizaId;
        PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa

      end;

    end
    else
    begin
     Close;
     xIncluindo := False;
     xEditando  := False;
     xDeletando := False;
     Exit;

    end;


end;

procedure TformEtiqueta.btLimparClick(Sender: TObject);
begin

  edPesquisar.Text :='';
  BuscaDinamica;
end;

procedure TformEtiqueta.DBGrid1CellClick(Column: TColumn);
begin
 xCod :=  dmDados.FDEtqID.Value;
end;

procedure TformEtiqueta.LocalizaId;
begin
  dmDados.FDEtq.Locate('ID', xCod, []);
end;

procedure TformEtiqueta.rghModeloClick(Sender: TObject);
begin
  DirecionaPainel;
end;

procedure TformEtiqueta.BuscaDinamica;
begin


    with dmDados.FDEtq do
    begin
      close;
      prepared := true;
      SQL.Clear;
      SQL.Add('select * from ETIQUETAS');
      SQL.Add('where MODELO=:vMODELO');
      SQL.Add('AND (NOME LIKE  '+QuotedStr('%'+edPesquisar.Text+'%'));
      SQL.Add(')order by NOME');

      ParamByName('vMODELO').AsInteger := rgConsulta.ItemIndex;
      Open;

    end;

//    dmDados.FDEtq.Close;
//    dmDados.FDEtq.SQL.Clear;
//    dmDados.FDEtq.SQL.Add('select * from ETIQUETAS where');
//    dmDados.FDEtq.SQL.Add('(NOME LIKE '+QuotedStr('%'+EdPesquisar.Text+'%') );
//    dmDados.FDEtq.SQL.Add(')order by NOME');
//    dmDados.FDEtq.Open;

end;

procedure TformEtiqueta.DirecionaPainel;
begin

 BuscaDinamica;

 case rghModelo.ItemIndex of
    -1:
      begin
        pnVertical.Visible := False;
        pnHorizontal.Visible := False;

      end;
    0:
      begin
        pnVertical.Visible := True;
        pnHorizontal.Visible := False;

      end;
    1:
      begin
        pnHorizontal.Visible := True;
        pnVertical.Visible := False;

      end;

  end;


end;

procedure TformEtiqueta.DBGrid1DblClick(Sender: TObject);
begin
  btAlterarClick(Sender);

end;

procedure TformEtiqueta.dsEtqDataChange(Sender: TObject;
  Field: TField);
begin
 lbCod.Caption := 'ID: '+IntToStr(dmDados.FDEtqID.value);
end;

procedure TformEtiqueta.edPesquisarChange(Sender: TObject);
begin
 BuscaDinamica;
end;

procedure TformEtiqueta.edPesquisarKeyPress(Sender: TObject; var Key: Char);
begin
// if Key = #13 then
// btPesquisarClick(Sender);
end;

procedure TformEtiqueta.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if dmDados.FDEtq.IsEmpty then
  begin
    ShowMessage('Sem registro encontrado');
    Exit;
  end;

  if  dmDados.xAtivaBusca = True then
  begin
    MainForm.rghModelo.ItemIndex := dmDados.FDEtqMODELO.Value;
    MainForm.edDescricao.Text := dmDados.FDEtqNOME.Value;
    MainForm.sbFonte.Text := IntToStr(dmDados.FDEtqALTURA.Value);
    MainForm.sbLargura.Text := IntToStr(dmDados.FDEtqLARGURA.Value);
    MainForm.sbAltura.Text := IntToStr(dmDados.FDEtqALTURA.Value);
    dmDados.xAtivaBusca := False;
    Exit;
  end
  else
  dmDados.xAtivaBusca := False;
  Exit;

end;

procedure TformEtiqueta.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
     Perform(WM_nextdlgctl,0,0);
// else if Key =  #27 then
//     Perform(WM_nextdlgctl,1,0)
//
  If Key = #27 Then Close;
end;

procedure TformEtiqueta.FormShow(Sender: TObject);
begin

  PnPrincipal.ActiveCard := CardPesquisa;// ativa card pesqisa
  lbCod.Caption := '';
  edPesquisar.Text := '';

  rgConsulta.ItemIndex := 0;

  btIncluir.SetFocus;
  buscaDinamica;


end;

end.
