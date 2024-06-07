unit Src.Model.Pedido;

interface

uses
  System.SysUtils, Src.Model.Cliente;

type
  TModelPedido = class
  private
    FPedId: Integer;
    FCliente: TModelCliente;
    FEmissao: TDateTime;
    FTotal: Currency;
    procedure SetPedId(const Value: Integer);
    procedure SetCliente(const Value: TModelCliente);
    procedure SetEmissao(const Value: TDateTime);
    procedure SetTotal(const Value: Currency);
  public
    constructor Create;
    destructor Destroy; override;
    property PedId: Integer read FPedId write SetPedId;
    property Cliente: TModelCliente read FCliente write SetCliente;
    property Emissao: TDateTime read FEmissao write SetEmissao;
    property Total: Currency read FTotal write SetTotal;
  end;

implementation

{ TPedido }

constructor TModelPedido.Create;
begin
  inherited Create;
  FCliente := TModelCliente.Create;
end;

destructor TModelPedido.Destroy;
begin
  FCliente.Free;
  inherited Destroy;
end;

procedure TModelPedido.SetPedId(const Value: Integer);
begin
  FPedId := Value;
end;

procedure TModelPedido.SetCliente(const Value: TModelCliente);
begin
  if FCliente <> Value then
  begin
    FCliente.Free;
    FCliente := Value;
  end;
end;

procedure TModelPedido.SetEmissao(const Value: TDateTime);
begin
  FEmissao := Value;
end;

procedure TModelPedido.SetTotal(const Value: Currency);
begin
  FTotal := Value;
end;

end.
