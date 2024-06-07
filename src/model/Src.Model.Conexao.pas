unit Src.Model.Conexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys.ODBC, FireDAC.Phys.ODBCDef, FireDAC.DApt;

type
  TDBConnection = class
  private
    FConnection: TFDConnection;
    FDatabase: string;
    FUsername: string;
    FPassword: string;
    FServer: string;
    FPort: Integer;
    procedure SetupConnection;
  public
    constructor Create(const ADatabase, AUsername, APassword, AServer: string;
      APort: Integer);
    destructor Destroy; override;
    function GetConnection: TFDConnection;
  end;

implementation

{ TDBConnection }

constructor TDBConnection.Create(const ADatabase, AUsername, APassword,
  AServer: string; APort: Integer);
begin
  FDatabase := ADatabase;
  FUsername := AUsername;
  FPassword := APassword;
  FServer := AServer;
  FPort := APort;

  FConnection := TFDConnection.Create(nil);
  SetupConnection;
end;

destructor TDBConnection.Destroy;
begin
  FConnection.Free;
  inherited;
end;

procedure TDBConnection.SetupConnection;
var
  ODBCConnectionStr: string;
begin
  // Construir a string de conexão ODBC
  ODBCConnectionStr :=
    Format('Driver={MySQL ODBC 8.0 Unicode Driver};Server=%s;Database=%s;User=%s;Password=%s;Port=%d;',
    [FServer, FDatabase, FUsername, FPassword, FPort]);

  // Definir parâmetros de conexão
  FConnection.DriverName := 'ODBC';
  FConnection.Params.Values['ODBCAdvanced'] := ODBCConnectionStr;
  FConnection.LoginPrompt := False;
  try
    FConnection.Connected := True; // Conectar ao banco de dados
  Except
    on E: Exception do
      raise Exception.Create('Erro ao tentar conectar no banco de dados, ' +
        FDatabase + '.');
  end;
end;

function TDBConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

end.
