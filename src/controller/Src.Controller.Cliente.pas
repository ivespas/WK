unit Src.Controller.Cliente;

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
  FireDAC.Comp.UI;

type
  TControllerCliente = class
  private
    FClientes: TObjectList<TModelCliente>;
  public
    constructor Create;
    destructor Destroy; override;
    function AdicionarCliente(pConn: TDBConnectionController; Codigo: Integer;
      Nome, Cidade, Estado: string): TModelCliente;
    function EditarCliente(pConn: TDBConnectionController; Codigo: Integer;
      Nome, Cidade, Estado: string): Boolean;
    function ExcluirCliente(pConn: TDBConnectionController;
      Codigo: Integer): Boolean;
    function ListarClientes: TObjectList<TModelCliente>;
    function ObterCliente(pConn: TDBConnectionController; Codigo: Integer)
      : TModelCliente;
  end;

implementation

uses
  uView.Main;

{ TControllerCliente }

constructor TControllerCliente.Create;
begin
  inherited Create;
  FClientes := TObjectList<TModelCliente>.Create;
end;

destructor TControllerCliente.Destroy;
begin
  FClientes.Free;
  inherited Destroy;
end;

function TControllerCliente.AdicionarCliente(pConn: TDBConnectionController;
  Codigo: Integer; Nome, Cidade, Estado: string): TModelCliente;
var
  Cliente: TModelCliente;
begin
  Cliente := TModelCliente.Create;
  Cliente.Codigo := Codigo;
  Cliente.Nome := Nome;
  Cliente.Cidade := Cidade;
  Cliente.Estado := Estado;
  FClientes.Add(Cliente);
  Result := Cliente;
end;

function TControllerCliente.EditarCliente(pConn: TDBConnectionController;
  Codigo: Integer; Nome, Cidade, Estado: string): Boolean;
var
  Cliente: TModelCliente;
begin
  Cliente := ObterCliente(pConn, Codigo);
  if Assigned(Cliente) then
  begin
    Cliente.Nome := Nome;
    Cliente.Cidade := Cidade;
    Cliente.Estado := Estado;
    Result := True;
  end
  else
    Result := False;
end;

function TControllerCliente.ExcluirCliente(pConn: TDBConnectionController;
  Codigo: Integer): Boolean;
var
  Cliente: TModelCliente;
begin
  Cliente := ObterCliente(pConn, Codigo);
  if Assigned(Cliente) then
  begin
    FClientes.Remove(Cliente);
    Result := True;
  end
  else
    Result := False;
end;

function TControllerCliente.ListarClientes: TObjectList<TModelCliente>;
begin
  Result := FClientes;
end;

function TControllerCliente.ObterCliente(pConn: TDBConnectionController;
  Codigo: Integer): TModelCliente;
var
  Cliente: TModelCliente;
  Qry: TFDQuery;
begin
  Result := nil;

  Cliente := TModelCliente.Create;
  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('SELECT CODIGO, NOME, CIDADE, ESTADO FROM TESTE.CLIENTE WHERE CODIGO = :P_CODIGO');
    Qry.ParamByName('P_CODIGO').AsInteger := Codigo;
    Qry.Open;

    if Qry.IsEmpty then
      raise Exception.Create('Erro Cliente não encontrado.');

    Cliente.Codigo := Qry.FieldByName('CODIGO').AsInteger;
    Cliente.Nome := Qry.FieldByName('NOME').AsString;
    Cliente.Cidade := Qry.FieldByName('CIDADE').AsString;
    Cliente.Estado := Qry.FieldByName('ESTADO').AsString;

    if Cliente.Codigo = Codigo then
      Result := Cliente;

  finally
    FreeAndNil(Qry);
  end;
end;

end.
