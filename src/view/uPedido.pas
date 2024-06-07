unit uPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.Mask, Vcl.Grids, Vcl.DBGrids, Src.Controller.Cliente,
  Src.Controller.Conexao, Src.Controller.Item, Src.Controller.Pedido,
  Src.Model.Pedido, Src.Controller.Produto, Src.Model.Item, Datasnap.DBClient,
  uViewBuscaPedido;

type
  TFrmPedido = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    EdtCodCli: TLabeledEdit;
    SpeedButton1: TSpeedButton;
    EdtNome: TEdit;
    SpeedButton2: TSpeedButton;
    EdtCodPro: TLabeledEdit;
    EdtDescr: TEdit;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    EdtQtd: TLabeledEdit;
    EdtVlr: TLabeledEdit;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    DataSource: TDataSource;
    Cds: TClientDataSet;
    CdsCodigo: TIntegerField;
    CdsDescr: TStringField;
    CdsQtd: TIntegerField;
    CdsValor: TFloatField;
    CdsTotal: TFloatField;
    Label1: TLabel;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure EdtCodCliKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdtCodProKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure EdtVlrKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtCodProKeyPress(Sender: TObject; var Key: Char);
    procedure EdtCodCliKeyPress(Sender: TObject; var Key: Char);
    procedure EdtQtdKeyPress(Sender: TObject; var Key: Char);
    procedure EdtVlrKeyPress(Sender: TObject; var Key: Char);
    procedure EdtCodProEnter(Sender: TObject);
  private
    { Private declarations }
    FControllerCliente: TControllerCliente;
    FControllerPedido: TControllerPedido;
    FControllerItem: TControllerItem;
    FcontrollerProduto: TControllerProduto;
    FConn: TDBConnectionController;
    vPedTotal: Float64;
    vAtualiza: Boolean;
    vNumPed: Integer;
    procedure HabilitarTodosLabelsEdits(Value: Boolean);
    procedure LimparEdits;
    procedure AlteraItem;
    procedure GetItem;
    procedure PopulaCDS;
    procedure ExibeTotal;
  public
    { Public declarations }
    FPedido: TModelPedido;
    FItem: TmodelItem;
    vBusca: Boolean;
  end;

var
  FrmPedido: TFrmPedido;

implementation

uses
  Src.Model.Produto,
  Src.Model.Cliente, uView.Main, System.Generics.Collections, System.SysUtils;

{$R *.dfm}

procedure TFrmPedido.AlteraItem;
begin
  Cds.Edit;
  Cds.FieldByName('QTD').AsInteger := StrToInt(EdtQtd.Text);
  Cds.FieldByName('VALOR').AsFloat := StrToFloat(EdtVlr.Text);
  Cds.FieldByName('TOTAL').AsFloat := StrToInt(EdtQtd.Text) *
    StrToFloat(EdtVlr.Text);
  Cds.Post;
end;

procedure TFrmPedido.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN THEN
  Begin
    GetItem;
    EdtCodPro.ReadOnly := true;
    EdtCodPro.SetFocus;
    Cds.Edit;
  End;

  if Key = VK_DELETE then
  Begin
    if not DataSource.DataSet.IsEmpty then
    begin
      if MessageDlg('Tem certeza que deseja apagar este registro?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        vPedTotal := vPedTotal - DataSource.DataSet.FieldByName
          ('total').AsFloat;
        DataSource.DataSet.Delete;
        ExibeTotal;
      end;
    end;
  End;
end;

procedure TFrmPedido.EdtCodCliKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    if EdtCodCli.Text <> '' then
      SpeedButton1.Click;
end;

procedure TFrmPedido.EdtCodCliKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', #8]) then
  begin
    Key := #0;
    ShowMessage('Por favor, digite apenas números.');
  end;
end;

procedure TFrmPedido.EdtCodProEnter(Sender: TObject);
begin
  if EdtNome.Text = '' then
    EdtCodCli.SetFocus;
end;

procedure TFrmPedido.EdtCodProKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    if EdtCodPro.Text <> '' then
      SpeedButton2.Click;
end;

procedure TFrmPedido.EdtCodProKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', #8]) then
  begin
    Key := #0;
    ShowMessage('Por favor, digite apenas números.');
  end;
end;

procedure TFrmPedido.EdtQtdKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', #8]) then
  begin
    Key := #0;
    ShowMessage('Por favor, digite apenas números.');
  end;
end;

procedure TFrmPedido.EdtVlrKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    if (EdtCodPro.Text <> '') and (EdtQtd.Text <> '') AND (EdtVlr.Text <> '')
    then
      SpeedButton6.Click;
end;

procedure TFrmPedido.EdtVlrKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', #8]) then
  begin
    Key := #0;
    ShowMessage('Por favor, digite apenas números.');
  end;
end;

procedure TFrmPedido.ExibeTotal;
begin
  Cds.First;
  vPedTotal := 0;
  while not Cds.Eof do
  Begin
    vPedTotal := vPedTotal + Cds.FieldByName('total').AsFloat;
    Cds.Next;
  End;
  Label1.Caption := FormatFloat('#,##0.00', vPedTotal);
end;

procedure TFrmPedido.FormCreate(Sender: TObject);
begin
  FConn := FrmMain.FConn;
  HabilitarTodosLabelsEdits(False);
  Cds.CreateDataSet;
  vPedTotal := 0;
end;

procedure TFrmPedido.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;

  if Key = #27 then
    SpeedButton5.Click;
end;

procedure TFrmPedido.GetItem;
begin
  EdtCodPro.Text := Cds.FieldByName('CODIGO').AsInteger.ToString;
  EdtDescr.Text := Cds.FieldByName('DESCR').AsString;
  EdtQtd.Text := Cds.FieldByName('QTD').AsInteger.ToString;
  EdtVlr.Text := Cds.FieldByName('VALOR').AsFloat.ToString;
end;

procedure TFrmPedido.HabilitarTodosLabelsEdits(Value: Boolean);
var
  I: Integer;
begin
  for I := 0 to FrmPedido.ComponentCount - 1 do
  begin
    if FrmPedido.Components[I] is TEdit then
      (FrmPedido.Components[I] as TEdit).Enabled := Value
    else if FrmPedido.Components[I] is TLabeledEdit then
      (FrmPedido.Components[I] as TLabeledEdit).Enabled := Value;

    SpeedButton1.Enabled := Value;
    SpeedButton2.Enabled := Value;
    SpeedButton6.Enabled := Value;

  end;

end;

procedure TFrmPedido.LimparEdits;
begin
  var
    I: Integer;
  begin
    for I := 0 to FrmPedido.ComponentCount - 1 do
    begin
      if FrmPedido.Components[I] is TEdit then
        (FrmPedido.Components[I] as TEdit).Text := '';

      if FrmPedido.Components[I] is TLabeledEdit then
        (FrmPedido.Components[I] as TLabeledEdit).Text := '';
    end;
  end;
end;

procedure TFrmPedido.PopulaCDS;
begin
  if Cds.State in [dsBrowse, dsInactive] then
    Cds.Append;

  Cds.FieldByName('Codigo').AsInteger := FItem.Produto.Codigo;
  Cds.FieldByName('Descr').AsString := FItem.Produto.Descricao;
  Cds.FieldByName('QTD').AsInteger := FItem.QTD;
  Cds.FieldByName('Valor').AsFloat := FItem.Vlr;
  Cds.FieldByName('Total').AsFloat := FItem.Total;
  Cds.Post;
end;

procedure TFrmPedido.SpeedButton1Click(Sender: TObject);
var
  Controller: TControllerCliente;
  Cliente: TModelCliente;
begin
  Controller := TControllerCliente.Create;
  EdtNome.Text := '';
  try
    Cliente := Controller.ObterCliente(FConn, StrToInt(EdtCodCli.Text));
    EdtCodCli.Text := Cliente.Codigo.ToString;
    EdtNome.Text := Cliente.Nome;

  finally
    if EdtNome.Text = '' then
      FrmPedido.SetFocus;
    Controller.Free;
  end;

end;

procedure TFrmPedido.SpeedButton2Click(Sender: TObject);
var
  Controller: TControllerProduto;
  Produto: TModelProduto;
begin
  Controller := TControllerProduto.Create;
  try
    Produto := Controller.ObterProduto(FConn, StrToInt(EdtCodPro.Text));

    EdtCodPro.Text := Produto.Codigo.ToString;
    EdtDescr.Text := Produto.Descricao;
    EdtQtd.Text := Produto.QTD.ToString();
    EdtVlr.Text := FloatToStr(Produto.Vlr);
  finally
    if EdtDescr.Text = '' then
      EdtCodCli.SetFocus;
    Controller.Free;
  end;
end;

procedure TFrmPedido.SpeedButton3Click(Sender: TObject);
begin
  HabilitarTodosLabelsEdits(true);
  LimparEdits;
  EdtCodCli.SetFocus;
  SpeedButton3.Enabled := False;
  SpeedButton4.Enabled := true;
  SpeedButton7.Enabled := true;
  SpeedButton8.Enabled := False;

  FControllerPedido := TControllerPedido.Create;
  FControllerCliente := TControllerCliente.Create;
  FControllerItem := TControllerItem.Create;
  FcontrollerProduto := TControllerProduto.Create;
  FItem := TmodelItem.Create;
  if not Cds.Active then
    Cds.Open;
  vPedTotal := 0;
end;

procedure TFrmPedido.SpeedButton4Click(Sender: TObject);
begin
  FreeAndNil(FControllerPedido);
  FreeAndNil(FControllerItem);
  FreeAndNil(FControllerCliente);
  FreeAndNil(FcontrollerProduto);

  SpeedButton3.Enabled := true;
  SpeedButton4.Enabled := False;
  SpeedButton7.Enabled := False;
  SpeedButton8.Enabled := true;
  HabilitarTodosLabelsEdits(False);

  Cds.EmptyDataSet;
  Cds.Close;
  LimparEdits;
  vAtualiza := False;
  Label1.Caption := '0.00';
end;

procedure TFrmPedido.SpeedButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmPedido.SpeedButton6Click(Sender: TObject);
begin
  if EdtCodPro.Text = '' then
  Begin
    ShowMessage('Informe o código do produto.');
    EdtCodPro.SetFocus;
    Exit;
  End;

  if EdtQtd.Text = '' then
  Begin
    ShowMessage('Informe a quantidade do produto.');
    EdtQtd.SetFocus;
    Exit;
  End;

  if EdtVlr.Text = '' then
  Begin
    ShowMessage('Informe o valor do produto.');
    EdtVlr.SetFocus;
    Exit;
  End;

  FItem := TmodelItem.Create;
  Try
    FItem.Produto.Codigo := StrToInt(EdtCodPro.Text);
    FItem.Produto.Descricao := EdtDescr.Text;
    FItem.QTD := StrToInt(EdtQtd.Text);
    FItem.Vlr := StrToFloat(EdtVlr.Text);
    FItem.Total := FItem.QTD * FItem.Vlr;
    vPedTotal := vPedTotal + FItem.Total;

    if Cds.State in [dsBrowse, dsInactive] then
      Cds.Append;

    Cds.FieldByName('Codigo').AsInteger := FItem.Produto.Codigo;
    Cds.FieldByName('Descr').AsString := FItem.Produto.Descricao;
    Cds.FieldByName('QTD').AsInteger := FItem.QTD;
    Cds.FieldByName('Valor').AsFloat := FItem.Vlr;
    Cds.FieldByName('Total').AsFloat := FItem.Total;
    Cds.Post;

    ExibeTotal;
    EdtCodCli.SetFocus;
  finally
    EdtCodPro.ReadOnly := False;
    EdtCodPro.Text := '';
    EdtDescr.Text := '';
    EdtQtd.Text := '0';
    EdtVlr.Text := '0.00';

  end;
end;

procedure TFrmPedido.SpeedButton7Click(Sender: TObject);
Var
  lPedido: TModelPedido;
  lItem: TmodelItem;
  vNumPed: Integer;
begin
  lPedido := TModelPedido.Create;
  Try
    lPedido.Cliente.Codigo := StrToInt(EdtCodCli.Text);
    lPedido.Emissao := Now;
    lPedido.Total := vPedTotal;
    if not vAtualiza then
    Begin
      FControllerPedido.AdicionarPedido(FConn, lPedido);
      vNumPed := FControllerItem.GetLastPed(FConn);
    End
    else
    Begin
      lPedido.PedId := FPedido.PedId;
      FControllerPedido.EditarPedido(FConn, FPedido);
      FControllerItem.ExcluirItem(FConn, FPedido.PedId);

    End;

    Cds.First;
    while not Cds.Eof do
    Begin
      lItem := TmodelItem.Create;
      if not vAtualiza then
        lItem.Pedido.PedId := vNumPed
      else
        lItem.Pedido.PedId := lPedido.PedId;
      lItem.Produto.Codigo := CdsCodigo.AsInteger;
      lItem.Produto.Descricao := CdsDescr.AsString;
      lItem.Vlr := CdsValor.AsFloat;
      lItem.QTD := CdsQtd.AsInteger;
      lItem.Total := CdsTotal.AsFloat;

      FControllerItem.AdicionarItem(FConn, lItem);
      Cds.Next;
    End;

  Finally
    FreeAndNil(lPedido);
    SpeedButton7.Enabled := False;
    LimparEdits;
    HabilitarTodosLabelsEdits(False);
    SpeedButton3.Enabled := true;
    SpeedButton4.Enabled := False;
    SpeedButton7.Enabled := False;
    SpeedButton8.Enabled := true;
    Cds.EmptyDataSet;
    Cds.Close;
    vPedTotal := 0;
  End;

end;

procedure TFrmPedido.SpeedButton8Click(Sender: TObject);
var
  ItemList: TObjectList<TmodelItem>;
  I: Integer;
begin
  vBusca := true;
  if EdtCodCli.Text <> '' then
    Exit;
  vAtualiza := False;
  Application.CreateForm(TFrmBuscaPedido, FrmBuscaPedido);
  FrmBuscaPedido.FConn := FConn;
  FrmBuscaPedido.ShowModal;
  if not vBusca then
    Exit;

  HabilitarTodosLabelsEdits(true);
  LimparEdits;
  EdtCodCli.SetFocus;
  try
    EdtCodCli.Text := FPedido.Cliente.Codigo.ToString;
    EdtNome.Text := FPedido.Cliente.Nome;

    ItemList := TObjectList<TmodelItem>.Create;
    ItemList := FControllerItem.ListarItens(FConn, FPedido.PedId);

    vPedTotal := 0;
    if not Cds.Active then
    Begin
      Cds.CreateDataSet;
      Cds.Open;
    End;
    for I := 0 to Pred(ItemList.Count) do
    begin
      Cds.Append;
      Cds.FieldByName('codigo').AsInteger := ItemList.Items[I].Produto.Codigo;
      Cds.FieldByName('descr').AsString := ItemList.Items[I].Produto.Descricao;
      Cds.FieldByName('QTD').AsInteger := ItemList.Items[I].QTD;
      Cds.FieldByName('valor').AsFloat := ItemList.Items[I].Vlr;
      Cds.FieldByName('total').AsFloat := ItemList.Items[I].Total;
      vPedTotal := vPedTotal + ItemList.Items[I].Total;
      Cds.Post;
    end;
    ExibeTotal;
    vAtualiza := true;
    FrmBuscaPedido.Release;
    FrmBuscaPedido := nil;
  finally
    SpeedButton8.Enabled := False;
    SpeedButton4.Enabled := true;
    SpeedButton7.Enabled := true;
    vBusca := False;
  end;

end;

procedure TFrmPedido.SpeedButton9Click(Sender: TObject);
var
  InputStr: string;
  Number: Integer;
  IsValid: Boolean;
begin
  repeat
    InputStr := InputBox('Informe o número do pedido',
      'Por favor, digite um número:', '');
    IsValid := TryStrToInt(InputStr, Number);
    if not IsValid then
      ShowMessage('Entrada inválida. Por favor, digite apenas números.');
  until IsValid;

  FControllerPedido.ExcluirPedido(FConn, Number);
  FControllerItem.ExcluirItem(FConn, Number);
  // Label1.Caption := 'Número digitado: ' + IntToStr(Number);

end;

end.
