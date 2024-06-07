unit uViewBuscaPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, FireDAC.Comp.Client, Src.Controller.Conexao,
  Vcl.StdCtrls, Src.Model.Pedido;

type
  TFrmBuscaPedido = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    DataSource: TDataSource;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ComboBox1: TComboBox;
    EdtBusca: TEdit;
    SpeedButton3: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EdtBuscaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    FQry: TFDQuery;
    FPedido: TModelPedido;
    procedure Busca(pField, pTexto: String);

  public
    { Public declarations }
    FConn: TDBConnectionController;
  end;

var
  FrmBuscaPedido: TFrmBuscaPedido;

implementation

{$R *.dfm}

uses uPedido;

procedure TFrmBuscaPedido.Busca(pField, pTexto: String);
Var
  vAux: String;
begin
  vAux := '';

  FQry.Close;
  FQry.SQL.Clear;
  FQry.SQL.Add('SELECT T1.PEDID, T1.CLIID, T2.NOME, T1.EMISSAO, T1.TOTAL ');
  FQry.SQL.Add
    ('FROM TESTE.PEDIDO T1 INNER JOIN TESTE.cliente T2 ON T2.CODIGO = T1.CLIID');
  FQry.SQL.Add('WHERE ' + pTexto);
  FQry.Open;
end;

procedure TFrmBuscaPedido.EdtBuscaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    if EdtBusca.Text <> '' then
      SpeedButton3.Click;
end;

procedure TFrmBuscaPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FQry);
end;

procedure TFrmBuscaPedido.FormCreate(Sender: TObject);
begin
  FQry := TFDQuery.Create(nil);
end;

procedure TFrmBuscaPedido.FormShow(Sender: TObject);
begin
  FQry.Connection := FConn.Connection;
  DataSource.DataSet := FQry;
  FQry.Close;
  FQry.SQL.Clear;
  FQry.SQL.Add('SELECT T1.PEDID, T1.CLIID, T2.NOME, T1.EMISSAO, T1.TOTAL ');
  FQry.SQL.Add
    ('FROM TESTE.PEDIDO T1 INNER JOIN TESTE.cliente T2 ON T2.CODIGO = T1.CLIID');
  FQry.Open;
end;

procedure TFrmBuscaPedido.SpeedButton1Click(Sender: TObject);
begin
  FrmPedido.vBusca := false;
  Close;
end;

procedure TFrmBuscaPedido.SpeedButton2Click(Sender: TObject);
begin
  FrmPedido.FPedido := TModelPedido.Create;
  FrmPedido.FPedido.PedId := FQry.FieldByName('PEDID').AsInteger;
  FrmPedido.FPedido.Cliente.Codigo := FQry.FieldByName('CLIID').AsInteger;
  FrmPedido.FPedido.Cliente.Nome := FQry.FieldByName('NOME').AsString;
  FrmPedido.FPedido.Emissao := FQry.FieldByName('EMISSAO').AsDateTime;
  FrmPedido.FPedido.Total := FQry.FieldByName('TOTAL').AsFloat;
  FrmPedido.vBusca := true;

  Close;
end;

procedure TFrmBuscaPedido.SpeedButton3Click(Sender: TObject);
Var
  vAux: String;
begin
  if EdtBusca.Text = '' then
  Begin
    raise Exception.Create('Informe uma valor no campo de busca.');
    EdtBusca.SetFocus;
    exit;
  End;

  case ComboBox1.ItemIndex of
    0:
      vAux := 'T1.PEDID = ' + EdtBusca.Text;
    1:
      vAux := 'T2.NOME LIKE ' + QuotedStr('%' + EdtBusca.Text + '%');
  end;

  Busca('', vAux);

end;

end.
