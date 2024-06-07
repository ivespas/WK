program WK;

uses
  Vcl.Forms,
  Src.Model.Cliente in 'src\model\Src.Model.Cliente.pas',
  Src.Model.Produto in 'src\model\Src.Model.Produto.pas',
  Src.Model.Pedido in 'src\model\Src.Model.Pedido.pas',
  Src.Model.Item in 'src\model\Src.Model.Item.pas',
  Src.Controller.Cliente in 'src\controller\Src.Controller.Cliente.pas',
  Src.Controller.Produto in 'src\controller\Src.Controller.Produto.pas',
  Src.Controller.Pedido in 'src\controller\Src.Controller.Pedido.pas',
  Src.Controller.Item in 'src\controller\Src.Controller.Item.pas',
  Src.Model.Conexao in 'src\model\Src.Model.Conexao.pas',
  Src.Controller.Conexao in 'src\controller\Src.Controller.Conexao.pas',
  uView.Main in 'src\view\uView.Main.pas' {FrmMain},
  uPedido in 'src\view\uPedido.pas' {FrmPedido},
  Src.Controller.CargaBase in 'src\controller\Src.Controller.CargaBase.pas',
  uViewBuscaPedido in 'src\view\uViewBuscaPedido.pas' {FrmBuscaPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
