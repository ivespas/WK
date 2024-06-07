unit Src.Controller.CargaBase;

interface

uses
  System.Generics.Collections,
  Src.Model.Cliente,
  Src.Controller.Conexao,
  FireDAC.Comp.Client,
  System.SysUtils,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf,
  FireDAC.Comp.UI,
  IniFiles,
  System.Classes;

type
  TControllerCargaDados = class
  private
    { private declarations }
    FConn: TDBConnectionController;
    // FCliente, FProduto: TStringList;

    procedure CargaCliente;
    procedure CargaProduto;
    procedure CriarArquivoConfig(const ABase, AUser, ASenha, AServer: string;
      APorta: Integer);
    procedure LerArquivoConfig(out ABase, AUser, ASenha, AServer: string;
      out APorta: Integer);
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    procedure Carregar;

  end;

implementation

{ TControllerCargaDados }

procedure TControllerCargaDados.CargaCliente;
Var
  Qry: TFDQuery;
  vBase, vUser, vSenha, vServer: string;
  vPorta, I: Integer;
  lStringListFile: TStringList;
  lStringListLine: TStringList;
  lCounter: Integer;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'MOCKCLIENTE.csv') then
    raise Exception.Create('Erro, não foi possivel popular a tabela de cliente, arquivo MOCKCLIENTE.csv não foi encontrado.');
  vBase := '';
  vUser := '';
  vSenha := '';
  vServer := '';
  vPorta := 0;

  if not FileExists(ExtractFilePath(ParamStr(0)) + 'config.ini') then
    CriarArquivoConfig('teste', 'root', 'Powersolutions', 'localhost', 3306);

  LerArquivoConfig(vBase, vUser, vSenha, vServer, vPorta);

  FConn := TDBConnectionController.Create(vBase, vUser, vSenha,
    vServer, vPorta);

  // TStringList que carrega todo o conteúdo do arquivo
  lStringListFile := TStringList.Create;

  // TStringList que carrega o conteúdo da linha
  lStringListLine := TStringList.Create;

  lStringListFile.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'MOCKCLIENTE.csv');

  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := FConn.Connection;
    FConn.Connection.StartTransaction;

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO TESTE.CLIENTE');
    Qry.SQL.Add('  (NOME, CIDADE, ESTADO)');
    Qry.SQL.Add('VALUES');
    Qry.SQL.Add('  (:NOME, :CIDADE, :ESTADO);');

    Qry.Params.ArraySize := 20;

    Qry.Params.ArraySize := lStringListFile.Count;

    for lCounter := 0 to Pred(lStringListFile.Count) do
    begin
      lStringListLine.StrictDelimiter := True;

      lStringListLine.CommaText := lStringListFile[lCounter];

      Qry.ParamByName('NOME').AsStrings[lCounter] := lStringListLine[0];
      Qry.ParamByName('CIDADE').AsStrings[lCounter] := lStringListLine[1];
      Qry.ParamByName('ESTADO').AsStrings[lCounter] := lStringListLine[2];
    end;

    try
      Qry.Execute(lStringListFile.Count, 0);
      FConn.Connection.Commit;
    except on E: Exception do
    raise Exception.Create('Erro ao importar arquivo de cliente.');
    end;

  finally
    lStringListLine.Free;
    lStringListFile.Free;
    Qry.Free;
  end;

end;

procedure TControllerCargaDados.CargaProduto;
Var
  Qry: TFDQuery;
var
  vBase, vUser, vSenha, vServer: string;
  vPorta: Integer;
  lStringListFile: TStringList;
  lStringListLine: TStringList;
  lCounter: Integer;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'MOCKPRODUTO.csv') then
    raise Exception.Create('Erro, não foi possivel importar dados de produto pois o arquivo MOCKPRODUTO.csv não foi encontrado.');
  vBase := '';
  vUser := '';
  vSenha := '';
  vServer := '';
  vPorta := 0;

  if not FileExists(ExtractFilePath(ParamStr(0)) + 'config.ini') then
    CriarArquivoConfig('teste', 'root', 'Powersolutions', 'localhost', 3306);

  LerArquivoConfig(vBase, vUser, vSenha, vServer, vPorta);

  FConn := TDBConnectionController.Create(vBase, vUser, vSenha,
    vServer, vPorta);

  lStringListFile := TStringList.Create;

  lStringListLine := TStringList.Create;


  lStringListFile.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'MOCKPRODUTO.csv');

  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := FConn.Connection;
    FConn.Connection.StartTransaction;

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('INSERT INTO TESTE.PRODUTO');
    Qry.SQL.Add('  (DESCRICAO, QTD, VALOR)');
    Qry.SQL.Add('VALUES');
    Qry.SQL.Add('  (:DESCRICAO, :QTD, :VALOR);');

    Qry.Params.ArraySize := 20;

    Qry.Params.ArraySize := lStringListFile.Count;

    for lCounter := 0 to Pred(lStringListFile.Count) do
    begin
      lStringListLine.StrictDelimiter := True;

      lStringListLine.CommaText := lStringListFile[lCounter];

      Qry.ParamByName('DESCRICAO').AsStrings[lCounter] := lStringListLine[0];
      Qry.ParamByName('QTD').AsStrings[lCounter] := lStringListLine[1];
      Qry.ParamByName('VALOR').AsStrings[lCounter] := lStringListLine[2];
    end;

    try
      Qry.Execute(lStringListFile.Count, 0);
      FConn.Connection.Commit;
    except on E: Exception do
      raise Exception.Create('Erro ao importar arquivo de produtos.');
    end;

  finally
    lStringListLine.Free;
    lStringListFile.Free;
    Qry.Free;
  end;
end;

procedure TControllerCargaDados.Carregar;
begin
  CargaCliente;
  CargaProduto;
end;

constructor TControllerCargaDados.Create;
begin
  inherited Create;
end;

procedure TControllerCargaDados.CriarArquivoConfig(const ABase, AUser, ASenha,
  AServer: string; APorta: Integer);
var
  ConfigFile: TStringList;
begin
  ConfigFile := TStringList.Create;
  try
    ConfigFile.Add('[Config]');
    ConfigFile.Add('Base=' + ABase);
    ConfigFile.Add('User=' + AUser);
    ConfigFile.Add('Senha=' + ASenha);
    ConfigFile.Add('Server=' + AServer);
    ConfigFile.Add('Porta=' + IntToStr(APorta));

    ConfigFile.SaveToFile(ExtractFilePath(ParamStr(0)) + 'config.ini');
  finally
    ConfigFile.Free;
  end;

end;

destructor TControllerCargaDados.Destroy;
begin

  inherited;
end;

procedure TControllerCargaDados.LerArquivoConfig(out ABase, AUser, ASenha,
  AServer: string; out APorta: Integer);
var
  Ini: TIniFile;
begin
  ABase := '';
  AUser := '';
  ASenha := '';
  AServer := '';
  APorta := 0;

  if FileExists(ExtractFilePath(ParamStr(0)) + 'config.ini') then
  begin
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
    try
      ABase := Ini.ReadString('Config', 'Base', '');
      AUser := Ini.ReadString('Config', 'User', '');
      ASenha := Ini.ReadString('Config', 'Senha', '');
      AServer := Ini.ReadString('Config', 'Server', '');
      APorta := Ini.ReadInteger('Config', 'Porta', 0);
    finally
      Ini.Free;
    end;
  end;

end;

end.
