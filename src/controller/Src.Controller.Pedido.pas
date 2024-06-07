unit Src.Controller.Pedido;

interface

uses
  System.Generics.Collections,
  Src.Model.Pedido, Src.Controller.Conexao;

type
  TControllerPedido = class
  private
    FPedidos: TObjectList<TModelPedido>;
  public
    constructor Create;
    destructor Destroy; override;
    function AdicionarPedido(pConn: TDBConnectionController;
      Pedido: TModelPedido): Boolean;
    function EditarPedido(pConn: TDBConnectionController;
      pPedido: TModelPedido): Boolean;
    function ExcluirPedido(pConn: TDBConnectionController;
      pPedId: Integer): Boolean;
    function ListarPedidos: TObjectList<TModelPedido>;
    function ObterPedido(pConn: TDBConnectionController; pPedido: TModelPedido)
      : TModelPedido;
    function GetNewNumPed(pConn: TDBConnectionController): Integer;
  end;

implementation

uses
  System.SysUtils, FireDAC.Comp.Client;

{ TControllerPedido }

constructor TControllerPedido.Create;
begin
  inherited Create;
  FPedidos := TObjectList<TModelPedido>.Create;
end;

destructor TControllerPedido.Destroy;
begin
  FPedidos.Free;
  inherited Destroy;
end;

function TControllerPedido.AdicionarPedido(pConn: TDBConnectionController;
  Pedido: TModelPedido): Boolean;
var
  Qry: TFDQuery;
begin
  Result := false;
  Qry := TFDQuery.Create(nil);
  try
    pConn.Connection.StartTransaction;
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('INSERT INTO TESTE.PEDIDO (CLIID, EMISSAO, TOTAL) VALUES (:CLIID, :EMISSAO, :TOTAL)');
    Qry.ParamByName('CLIID').AsInteger := Pedido.Cliente.Codigo;
    Qry.ParamByName('EMISSAO').AsDate := Pedido.Emissao;
    Qry.ParamByName('TOTAL').AsFloat := Pedido.Total;
    Try
      Qry.ExecSQL;
      pConn.Connection.Commit;
      Result := True;
    Except
      on E: Exception Do
      Begin
        raise Exception.Create('Erro ao tentar gravar Pedido.');
        pConn.Connection.Rollback;
        Result := false;
      End;
    End;

  finally
    FreeAndNil(Qry);
  end;

end;

function TControllerPedido.EditarPedido(pConn: TDBConnectionController;
  pPedido: TModelPedido): Boolean;
var
  Qry: TFDQuery;
begin
  Result := false;
  Qry := TFDQuery.Create(nil);
  try
    pConn.Connection.StartTransaction;
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE TESTE.PEDIDO SET');
    Qry.SQL.Add(' CLIID = :CLIID, EMISSAO = :EMISSAO, TOTAL = :TOTAL');
    Qry.SQL.Add('WHERE PEDID = :PEDID');
    Qry.ParamByName('CLIID').AsInteger := pPedido.Cliente.Codigo;
    Qry.ParamByName('EMISSAO').AsDateTime := pPedido.Emissao;
    Qry.ParamByName('TOTAL').AsFloat := pPedido.Total;
    Qry.ParamByName('PEDID').AsInteger := pPedido.PedId;
    Try
      Qry.ExecSQL;
      pConn.Connection.Commit;
      Result := True;
    Except
      on E: Exception Do
      Begin
        raise Exception.Create('Erro ao tentar alterar Pedido.');
        Result := false;
      End;
    End;

  finally
    FreeAndNil(Qry);
  end;
end;

function TControllerPedido.ExcluirPedido(pConn: TDBConnectionController;
  pPedId: Integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result := false;
  Qry := TFDQuery.Create(nil);
  try
    pConn.Connection.StartTransaction;
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM TESTE.PEDIDO WHERE PEDID = :PEDID');
    Qry.ParamByName('PEDID').AsInteger := pPedId;
    try
      Qry.ExecSQL;
      pConn.Connection.Commit;
      Result := True;
    except
      on E: Exception do
      Begin
        raise Exception.Create('erro ao excluir pedido.');
        pConn.Connection.Rollback;
        Result := false;
      End;
    end;

  finally
    FreeAndNil(Qry);
  end;
end;

function TControllerPedido.GetNewNumPed(pConn: TDBConnectionController)
  : Integer;
var
  Qry: TFDQuery;
begin
  Result := 0;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT AUTO_INCREMENT ');
    Qry.SQL.Add('FROM INFORMATION_SCHEMA.TABLES');
    Qry.SQL.Add('WHERE TABLE_SCHEMA = ''TESTE'' ');
    Qry.SQL.Add('AND TABLE_NAME = ''PEDIDO'' ');
    Qry.Open;
    Result := Qry.FieldByName('AUTO_INCREMENT').AsInteger;
  finally
    FreeAndNil(Qry);
  end;

end;

function TControllerPedido.ListarPedidos: TObjectList<TModelPedido>;
begin
  Result := FPedidos;
end;

function TControllerPedido.ObterPedido(pConn: TDBConnectionController;
  pPedido: TModelPedido): TModelPedido;
var
  Qry: TFDQuery;
  lPedido: TModelPedido;
begin
  Result := nil;
  lPedido := TModelPedido.Create;
  Qry := TFDQuery.Create(nil);
  Try
    pConn.Connection.StartTransaction;
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('SELECT PEDID, CLIID, EMISSAO, TOTAL FROM TESTE.PEDIDO WHERE PEDID = :PEDID');
    Qry.ParamByName('PEDID').AsInteger := pPedido.PedId;
    Qry.Open;

    lPedido.PedId := Qry.FieldByName('PEDID').AsInteger;
    lPedido.Cliente.Codigo := Qry.FieldByName('PEDCLI').AsInteger;
    lPedido.Emissao := Now;
    lPedido.Total := Qry.FieldByName('TOTAL').AsFloat;

    Result := lPedido;
  Finally
    FreeAndNil(Qry);
    FreeAndNil(lPedido);
  End;

end;

end.
