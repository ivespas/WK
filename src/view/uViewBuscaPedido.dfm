object FrmBuscaPedido: TFrmBuscaPedido
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Busca de Pedidos'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 57
    Align = alTop
    TabOrder = 0
    object SpeedButton3: TSpeedButton
      Left = 461
      Top = 28
      Width = 108
      Height = 23
      Caption = 'Busca'
      OnClick = SpeedButton3Click
    end
    object ComboBox1: TComboBox
      Left = 1
      Top = 28
      Width = 150
      Height = 23
      Style = csDropDownList
      CharCase = ecUpperCase
      ItemIndex = 0
      TabOrder = 0
      Text = 'NUMERO PEDIDO'
      Items.Strings = (
        'NUMERO PEDIDO'
        'CLIENTE'
        'EMISSAO')
    end
    object EdtBusca: TEdit
      Left = 157
      Top = 28
      Width = 298
      Height = 23
      CharCase = ecUpperCase
      TabOrder = 1
      OnKeyDown = EdtBuscaKeyDown
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 624
    Height = 319
    Align = alClient
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 622
      Height = 317
      Align = alClient
      DataSource = DataSource
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 376
    Width = 624
    Height = 65
    Align = alBottom
    TabOrder = 2
    object SpeedButton1: TSpeedButton
      Left = 520
      Top = 1
      Width = 103
      Height = 63
      Align = alRight
      Caption = 'Voltar'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 416
      Top = 1
      Width = 104
      Height = 63
      Align = alRight
      Caption = 'Selecionar'
      OnClick = SpeedButton2Click
      ExplicitLeft = 410
      ExplicitTop = 5
    end
  end
  object DataSource: TDataSource
    Left = 320
    Top = 193
  end
end
