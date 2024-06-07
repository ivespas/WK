unit Src.Controller.Item;

interface

uses
  System.Generics.Collections,
  Src.Model.Item,
  Src.Model.Produto,
  Src.Model.Pedido, Src.Controller.Conexao, Datasnap.DBClient;

type
  TControllerItem = class
  private
    FItems: TObjectList<TModelItem>;
  public
    constructor Create;
    destructor Destroy; override;
    function AdicionarItem(pConn: TDBConnectionController;
      pItem: TModelItem): Boolean;
    function EditarItem(pConn: TDBConnectionController; IteId: Integer;
      Pedido: TModelPedido; Produto: TModelProduto; QTD: Integer;
      Vlr: Currency): Boolean;
    function ExcluirItem(pConn: TDBConnectionController;
      PEDID: Integer): Boolean;
    function ListarItens(pConn: TDBConnectionController; pPedId: Integer)
      : TObjectList<TModelItem>;
    function ObterItem(pConn: TDBConnectionController; PEDID, PROID: Integer)
      : TModelItem;
    function GetLastPed(pConn: TDBConnectionController): Integer;
  end;

implementation

uses
  FireDAC.Comp.Client, System.SysUtils;

{ TControllerItem }

constructor TControllerItem.Create;
begin
  inherited Create;
  FItems := TObjectList<TModelItem>.Create;
end;

destructor TControllerItem.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TControllerItem.AdicionarItem(pConn: TDBConnectionController;
  pItem: TModelItem): Boolean;
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
    Qry.SQL.Add('INSERT INTO TESTE.ITEM');
    Qry.SQL.Add('(PEDID, PROID, QTD, VLRUNI, VLRTOT ) VALUES ');
    Qry.SQL.Add('(:PEDID, :PROID, :QTD, :VLRUNI, :VLRTOT) ');
    Qry.ParamByName('PEDID').AsInteger := pItem.Pedido.PEDID;
    Qry.ParamByName('PROID').AsInteger := pItem.Produto.Codigo;
    Qry.ParamByName('QTD').AsFloat := pItem.QTD;
    Qry.ParamByName('VLRUNI').AsFloat := pItem.Vlr;
    Qry.ParamByName('VLRTOT').AsFloat := pItem.Total;
    Try
      Qry.ExecSQL;
      pConn.Connection.Commit;
      Result := True;
    Except
      on E: Exception Do
      Begin
        raise Exception.Create('Erro ao tentar gravar dados da tabela item.');
        pConn.Connection.Rollback;
        Result := false;
      End;
    End;

  finally
    FreeAndNil(Qry);
  end;
end;

function TControllerItem.EditarItem(pConn: TDBConnectionController;
  IteId: Integer; Pedido: TModelPedido; Produto: TModelProduto; QTD: Integer;
  Vlr: Currency): Boolean;
var
  Item: TModelItem;
begin
  Item := ObterItem(pConn, Pedido.PEDID, Produto.Codigo);
  if Assigned(Item) then
  begin
    Item.Pedido.PEDID := Pedido.PEDID;
    Item.Produto.Codigo := Produto.Codigo;
    Item.QTD := QTD;
    Item.Vlr := Vlr;
    Item.Total := QTD * Vlr;
    Result := True;
  end
  else
    Result := false;
end;

function TControllerItem.ExcluirItem(pConn: TDBConnectionController;
  PEDID: Integer): Boolean;
var
  Item: TModelItem;
  Qry: TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    pConn.Connection.StartTransaction;
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('DELETE FROM TESTE.ITEM WHERE PEDID = :PEDID');
    Qry.ParamByName('PEDID').AsInteger := PEDID;
    try
      Qry.ExecSQL;
      pConn.Connection.Commit;
    except
      on E: Exception do
      Begin
        raise Exception.Create('Erro ao tentar excluir registro de item.');
        pConn.Connection.Rollback;;
      End;
    end;

  finally
    FreeAndNil(Qry);
  end;
end;

function TControllerItem.GetLastPed(pConn: TDBConnectionController): Integer;
Var
  Qry: TFDQuery;
begin
  Result := 0;
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('SELECT MAX(PEDID) AS PEDID FROM teste.PEDIDO');
    Qry.Open;
    Result := Qry.FieldByName('PEDID').AsInteger;
  finally
    FreeAndNil(Qry)
  end;

end;

function TControllerItem.ListarItens(pConn: TDBConnectionController;
  pPedId: Integer): TObjectList<TModelItem>;
var
  lItem: TModelItem;
  Qry: TFDQuery;
  ItemList: TObjectList<TModelItem>;
begin
  ItemList := TObjectList<TModelItem>.Create;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := pConn.Connection;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('SELECT T1.ITEMID, T1.PEDID, T1.PROID, T2.DESCRICAO, T1.QTD, T1.VLRUNI, T1.VLRTOT ');
    Qry.SQL.Add
      ('FROM TESTE.ITEM T1 INNER JOIN TESTE.PRODUTO T2 ON T2.CODIGO = T1.PROID');
    Qry.SQL.Add('WHERE T1.PEDID = :PEDID');
    Qry.ParamByName('PEDID').AsInteger := pPedId;
    Qry.Open;
    Qry.First;

    while not Qry.Eof do
    begin
      lItem := TModelItem.Create;
      try
        lItem.IteId := Qry.FieldByName('ITEMID').AsInteger;
        lItem.Pedido.PEDID := Qry.FieldByName('PEDID').AsInteger;
        lItem.Produto.Codigo := Qry.FieldByName('PROID').AsInteger;
        lItem.Produto.Descricao := Qry.FieldByName('DESCRICAO').AsString;
        lItem.QTD := Qry.FieldByName('QTD').AsInteger;
        lItem.Vlr := Qry.FieldByName('VLRUNI').AsFloat;
        lItem.Total := Qry.FieldByName('VLRTOT').AsFloat;

        ItemList.Add(lItem);
      except
        lItem.Free;
        raise;
      end;

      Qry.Next;
    end;

    Result := ItemList;
  finally
    Qry.Free;
  end;
end;

function TControllerItem.ObterItem(pConn: TDBConnectionController;
  PEDID, PROID: Integer): TModelItem;
var
  lItem: TModelItem;
  Qry: TFDQuery;
begin
  Result := nil;

  lItem := TModelItem.Create;
  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('SELECT ITEMID, PEDID, PROID, QTD, VLRUNI, VLRTOT FROM teste.item  PEDID = :P_PEDIDO AND PROID = :P_PRODUTO');
    Qry.ParamByName('P_PEDIDO').AsInteger := PEDID;
    // Qry.ParamByName('P_PRODUTO').AsInteger := PROID;
    Qry.Open;

    lItem.IteId := Qry.FieldByName('ITEMID').AsInteger;
    lItem.Pedido.PEDID := Qry.FieldByName('PEDID').AsInteger;
    lItem.Produto.Codigo := Qry.FieldByName('PROID').AsInteger;
    lItem.QTD := Qry.FieldByName('QTD').AsInteger;
    lItem.Vlr := Qry.FieldByName('VLRUNI').AsFloat;
    lItem.Total := Qry.FieldByName('VLRTOT').AsFloat;

    if (lItem.Pedido.PEDID = PEDID) AND (lItem.Produto.Codigo = PROID) then
      Result := lItem;
  finally
    FreeAndNil(Qry);
  end;

end;

end.
