unit Src.Controller.Produto;

interface

uses
  System.Generics.Collections,
  Src.Model.Produto,
  Src.Controller.Conexao,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf,
  FireDAC.Comp.UI;

type
  TControllerProduto = class
  private
    FProdutos: TObjectList<TModelProduto>;
  public
    constructor Create;
    destructor Destroy; override;
    function AdicionarProduto(pConn: TDBConnectionController; Codigo: Integer;
      Descricao: string; Vlr: Currency): TModelProduto;
    function EditarProduto(pConn: TDBConnectionController; Codigo: Integer;
      Descricao: string; Vlr: Currency): Boolean;
    function ExcluirProduto(pConn: TDBConnectionController;
      Codigo: Integer): Boolean;
    function ListarProdutos: TObjectList<TModelProduto>;
    function ObterProduto(pConn: TDBConnectionController; Codigo: Integer)
      : TModelProduto;
  end;

implementation

uses
  FireDAC.Comp.Client, System.SysUtils;

{ TControllerProduto }

constructor TControllerProduto.Create;
begin
  inherited Create;
  FProdutos := TObjectList<TModelProduto>.Create;
end;

destructor TControllerProduto.Destroy;
begin
  FProdutos.Free;
  inherited Destroy;
end;

function TControllerProduto.AdicionarProduto(pConn: TDBConnectionController;
  Codigo: Integer; Descricao: string; Vlr: Currency): TModelProduto;
var
  Produto: TModelProduto;
begin
  Produto := TModelProduto.Create;
  Produto.Codigo := Codigo;
  Produto.Descricao := Descricao;
  Produto.Vlr := Vlr;
  FProdutos.Add(Produto);
  Result := Produto;
end;

function TControllerProduto.EditarProduto(pConn: TDBConnectionController;
  Codigo: Integer; Descricao: string; Vlr: Currency): Boolean;
var
  Produto: TModelProduto;
begin
  Produto := ObterProduto(pConn, Codigo);
  if Assigned(Produto) then
  begin
    Produto.Descricao := Descricao;
    Produto.Vlr := Vlr;
    Result := True;
  end
  else
    Result := False;
end;

function TControllerProduto.ExcluirProduto(pConn: TDBConnectionController;
  Codigo: Integer): Boolean;
var
  Produto: TModelProduto;
begin
  Produto := ObterProduto(pConn, Codigo);
  if Assigned(Produto) then
  begin
    FProdutos.Remove(Produto);
    Result := True;
  end
  else
    Result := False;
end;

function TControllerProduto.ListarProdutos: TObjectList<TModelProduto>;
begin
  Result := FProdutos;
end;

function TControllerProduto.ObterProduto(pConn: TDBConnectionController;
  Codigo: Integer): TModelProduto;
var
  Produto: TModelProduto;
  Qry: TFDQuery;
begin
  Result := nil;
  Produto := TModelProduto.Create;
  Qry := TFDQuery.Create(nil);

  try
    Qry.Connection := pConn.Connection;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add
      ('SELECT CODIGO, DESCRICAO, QTD, VALOR FROM TESTE.PRODUTO WHERE CODIGO = :P_CODIGO');
    Qry.ParamByName('P_CODIGO').AsInteger := Codigo;
    Qry.Open;

    if Qry.IsEmpty then
    Begin
      raise Exception.Create('Produto não localizado.');
      Exit;
    End;

    Produto.Codigo := Qry.FieldByName('CODIGO').AsInteger;
    Produto.Descricao := Qry.FieldByName('DESCRICAO').AsString;
    Produto.Qtd := Qry.FieldByName('QTD').AsInteger;
    Produto.Vlr := Qry.FieldByName('VALOR').AsFloat;

    if Produto.Codigo = Codigo then
      Result := Produto;
  finally
    FreeAndNil(Qry);
  end;

end;

end.
