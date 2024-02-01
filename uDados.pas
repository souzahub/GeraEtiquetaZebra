unit uDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.UI,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TdmDados = class(TDataModule)
    FDAuxiliar: TFDQuery;
    SqlConexao: TFDConnection;
    FDEtq: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDEtqID: TIntegerField;
    FDEtqNOME: TStringField;
    FDEtqFONTE: TIntegerField;
    FDEtqLARGURA: TIntegerField;
    FDEtqALTURA: TIntegerField;
    FDEtqCADASTRO: TSQLTimeStampField;
    FDEtqMODELO: TIntegerField;
    FDEtqCOMPRIMENTO_V: TIntegerField;
    FDEtqALTURA_V: TIntegerField;
    FDEtqCOMPRIMENTOT_V: TIntegerField;
    FDEtqALTURAT_V: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure FDEtqMODELOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    const ARQUIVOCONFIGURACAO = 'bdcaminho.cfg'; // variavel que nunca pode ter alteracao ( arquivo Externo )

  public

    xAtivaBusca: Boolean;
    procedure CarregarConfiguracoes;
    procedure Conectar;
    procedure Desconectar;
  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Main, uEtiqueta;

{$R *.dfm}

procedure TdmDados.CarregarConfiguracoes;
var
  ParametroDrive : String;
  ParametroDatabase : string;
  Contador : Integer;
  ListaParametros : TStringList;

begin

  // ler os aqrivo e faz a conexao
  SqlConexao.Params.Clear;
  if not FileExists(ARQUIVOCONFIGURACAO) then
    raise Exception.Create('Arquivo de Configuração não encontrado');
  ListaParametros := TStringList.Create;
  try
    ListaParametros.LoadFromFile(ARQUIVOCONFIGURACAO);
    for Contador := 0 to Pred(ListaParametros.Count) do
    begin
      if ListaParametros[Contador].IndexOf('=') > 0 then
      begin

        ParametroDrive := ListaParametros[Contador].Split(['='])[0].Trim; // Drive
        ParametroDatabase := ListaParametros[Contador].Split(['='])[1].Trim; // Caminho do banco

        SqlConexao.Params.Add(ParametroDrive+ '='+ParametroDatabase);

      end;

    end;

  finally
    ListaParametros.Free;
  end;

end;

procedure TdmDados.Conectar;
begin
  SqlConexao.Connected;
end;

procedure TdmDados.DataModuleCreate(Sender: TObject);
begin
 CarregarConfiguracoes;
 Conectar;
end;

procedure TdmDados.DataModuleDestroy(Sender: TObject);
begin
 Desconectar;
end;

procedure TdmDados.Desconectar;
begin
  SqlConexao.Connected := False;
end;

procedure TdmDados.FDEtqMODELOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if FDEtqMODELO.Value = 0 then
  begin
    Text:= 'VERTICAL' ;
    Exit;
  end;

  if FDEtqMODELO.Value = 1 then
  begin
    Text:= 'HORIZONTAL' ;
    Exit;
  end;

end;

end.
