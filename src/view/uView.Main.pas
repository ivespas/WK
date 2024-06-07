unit uView.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.CategoryButtons, Vcl.Buttons, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList, Src.Controller.Conexao, IniFiles,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  Src.Controller.CargaBase;

type
  TFrmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Image3: TImage;
    Image4: TImage;
    Panel7: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    SplitView1: TSplitView;
    CategoryButtons1: TCategoryButtons;
    Panel8: TPanel;
    SpbSair: TSpeedButton;
    ImageList1: TImageList;
    ActionList1: TActionList;
    ActVenda: TAction;
    SplitView2: TSplitView;
    Panel9: TPanel;
    Label5: TLabel;
    FlowPanel1: TFlowPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ImageList2: TImageList;
    ActionList2: TActionList;
    Panel10: TPanel;
    Image5: TImage;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure Image1MouseEnter(Sender: TObject);

    procedure Image2Click(Sender: TObject);
    procedure Image2MouseLeave(Sender: TObject);
    procedure Image3MouseEnter(Sender: TObject);
    procedure Image4MouseLeave(Sender: TObject);
    procedure SpbSairClick(Sender: TObject);
    procedure ActEmpresaExecute(Sender: TObject);
    procedure ActProdutoExecute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure ActVendaExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    FCarregaBase: TControllerCargaDados;
    procedure CriarArquivoConfig(const ABase, AUser, ASenha, AServer: string;
      APorta: Integer);
    procedure LerArquivoConfig(out ABase, AUser, ASenha, AServer: string;
      out APorta: Integer);

  public
    { Public declarations }
    FConn: TDBConnectionController;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

uses uPedido;

procedure TFrmMain.Image2Click(Sender: TObject);
begin
  if SplitView1.Opened then
    SplitView1.Close
  Else
    SplitView1.Open;
end;

procedure TFrmMain.Image2MouseLeave(Sender: TObject);
begin
  Image1.Visible := True;
  Image2.Visible := False;
end;

procedure TFrmMain.Image3MouseEnter(Sender: TObject);
begin
  Image3.Visible := False;
  Image4.Visible := True;
end;

procedure TFrmMain.Image4MouseLeave(Sender: TObject);
begin
  Image3.Visible := True;
  Image4.Visible := False;
end;

procedure TFrmMain.LerArquivoConfig(out ABase, AUser, ASenha, AServer: string;
  out APorta: Integer);
var
  Ini: TIniFile;
begin
  ABase := '';
  AUser := '';
  ASenha := '';
  AServer := '';
  APorta := 0;

  if FileExists(ExtractFilePath(ParamStr(0)) + 'config.ini') then
  begin
    Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
    try
      ABase := Ini.ReadString('Config', 'Base', '');
      AUser := Ini.ReadString('Config', 'User', '');
      ASenha := Ini.ReadString('Config', 'Senha', '');
      AServer := Ini.ReadString('Config', 'Server', '');
      APorta := Ini.ReadInteger('Config', 'Porta', 0);
    finally
      Ini.Free;
    end;
  end;

end;

procedure TFrmMain.SpbSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmMain.ActEmpresaExecute(Sender: TObject);
begin

  SplitView2.Close;
end;

procedure TFrmMain.Action1Execute(Sender: TObject);
begin
  SplitView2.Open;
end;

procedure TFrmMain.ActProdutoExecute(Sender: TObject);
begin

  SplitView2.Close;
end;

procedure TFrmMain.ActVendaExecute(Sender: TObject);
begin
  Application.CreateForm(TFrmPedido, FrmPedido);
  FrmPedido.ShowModal;
  FrmPedido.Release;
  FrmPedido := nil;
end;

procedure TFrmMain.CriarArquivoConfig(const ABase, AUser, ASenha,
  AServer: string; APorta: Integer);
var
  ConfigFile: TStringList;
begin
  ConfigFile := TStringList.Create;
  try
    ConfigFile.Add('[Config]');
    ConfigFile.Add('Base=' + ABase);
    ConfigFile.Add('User=' + AUser);
    ConfigFile.Add('Senha=' + ASenha);
    ConfigFile.Add('Server=' + AServer);
    ConfigFile.Add('Porta=' + IntToStr(APorta));

    ConfigFile.SaveToFile(ExtractFilePath(ParamStr(0)) + 'config.ini');
  finally
    ConfigFile.Free;
  end;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FConn);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  vBase, vUser, vSenha, vServer: string;
  vPorta: Integer;
  LCARGA: TControllerCargaDados;
begin
  vBase := '';
  vUser := '';
  vSenha := '';
  vServer := '';
  vPorta := 0;

  if not FileExists(ExtractFilePath(ParamStr(0)) + 'config.ini') then
    CriarArquivoConfig('teste', 'root', 'Powersolutions', 'localhost', 3306);

  LerArquivoConfig(vBase, vUser, vSenha, vServer, vPorta);

  FConn := TDBConnectionController.Create(vBase, vUser, vSenha,
    vServer, vPorta);

  LCARGA := TControllerCargaDados.Create;
  LCARGA.Carregar;
end;

procedure TFrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    Close;
end;

procedure TFrmMain.Image1MouseEnter(Sender: TObject);
begin
  Image1.Visible := False;
  Image2.Visible := True;
end;

end.
