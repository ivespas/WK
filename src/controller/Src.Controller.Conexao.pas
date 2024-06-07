unit Src.Controller.Conexao;

interface

uses
  Src.Model.Conexao, FireDAC.Comp.Client;

type
  TDBConnectionController = class
  private
    FDBConnection: TDBConnection;
    function GetConnection: TFDConnection;
  public
    constructor Create(const ADatabase, AUsername, APassword, AServer: string;
      APort: Integer);
    destructor Destroy; override;
    property Connection: TFDConnection read GetConnection;
  end;

implementation

{ TDBConnectionController }

constructor TDBConnectionController.Create(const ADatabase, AUsername,
  APassword, AServer: string; APort: Integer);
begin

  FDBConnection := TDBConnection.Create(ADatabase, AUsername, APassword,
    AServer, APort);
end;

destructor TDBConnectionController.Destroy;
begin
  FDBConnection.Free;
  inherited;
end;

function TDBConnectionController.GetConnection: TFDConnection;
begin
  Result := FDBConnection.GetConnection;
end;

end.
