unit Src.Model.Produto;

interface

type
  TModelProduto = class
  private
    FCodigo: Integer;
    FDescricao: string;
    FQTD: Integer;
    FVlr: Real;
    procedure SetCodigo(const Value: Integer);
    procedure SetDescricao(const Value: string);
    procedure SetVlr(const Value: Real);
    procedure SetQtd(const Value: Integer);
  public
    property Codigo: Integer read FCodigo write SetCodigo;
    property Descricao: string read FDescricao write SetDescricao;
    property Vlr: Real read FVlr write SetVlr;
    property Qtd: Integer read FQTD write SetQtd;
  end;

implementation

uses
  System.SysUtils;

{ TModelProduto }

procedure TModelProduto.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TModelProduto.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TModelProduto.SetVlr(const Value: Real);
begin
  FVlr := Value;
end;

procedure TModelProduto.SetQtd(const Value: Integer);
begin
  FQTD := Value;
end;

end.
