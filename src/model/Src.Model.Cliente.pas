unit Src.Model.Cliente;

interface

type
  TModelCliente = class
  private
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
    FEstado: string;
    procedure SetCodigo(const Value: Integer);
    procedure SetNome(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetEstado(const Value: string);
  public
    property Codigo: Integer read FCodigo write SetCodigo;
    property Nome: string read FNome write SetNome;
    property Cidade: string read FCidade write SetCidade;
    property Estado: string read FEstado write SetEstado;
  end;

implementation

{ TModelCliente }

procedure TModelCliente.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TModelCliente.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TModelCliente.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TModelCliente.SetEstado(const Value: string);
begin
  FEstado := Value;
end;

end.
