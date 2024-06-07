unit Src.Model.Item;

interface

uses
  System.SysUtils, Src.Model.Pedido, Src.Model.Produto;

type
  TModelItem = class
  private
    FIteId: Integer;
    FPedido: TModelPedido;
    FProduto: TModelProduto;
    FQTD: Integer;
    FVlr: Real;
    FTotal: Real;
    procedure SetIteId(const Value: Integer);
    procedure SetPedido(const Value: TModelPedido);
    procedure SetProduto(const Value: TModelProduto);
    procedure SetQTD(const Value: Integer);
    procedure SetVlr(const Value: Real);
    procedure SetTotal(const Value: Real);
  public
    constructor Create;
    destructor Destroy; override;
    property IteId: Integer read FIteId write SetIteId;
    property Pedido: TModelPedido read FPedido write SetPedido;
    property Produto: TModelProduto read FProduto write SetProduto;
    property QTD: Integer read FQTD write SetQTD;
    property Vlr: Real read FVlr write SetVlr;
    property Total: Real read FTotal write SetTotal;
  end;

implementation

{ TModelItem }

constructor TModelItem.Create;
begin
  inherited Create;
  FPedido := TModelPedido.Create;
  FProduto := TModelProduto.Create;
end;

destructor TModelItem.Destroy;
begin
  FPedido.Free;
  FProduto.Free;
  inherited Destroy;
end;

procedure TModelItem.SetIteId(const Value: Integer);
begin
  FIteId := Value;
end;

procedure TModelItem.SetPedido(const Value: TModelPedido);
begin
  if FPedido <> Value then
  begin
    FPedido.Free;
    FPedido := Value;
  end;
end;

procedure TModelItem.SetProduto(const Value: TModelProduto);
begin
  if FProduto <> Value then
  begin
    FProduto.Free;
    FProduto := Value;
  end;
end;

procedure TModelItem.SetQTD(const Value: Integer);
begin
  FQTD := Value;
end;

procedure TModelItem.SetVlr(const Value: Real);
begin
  FVlr := Value;
end;

procedure TModelItem.SetTotal(const Value: Real);
begin
  FTotal := Value;
end;

end.
