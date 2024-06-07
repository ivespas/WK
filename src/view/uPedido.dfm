object FrmPedido: TFrmPedido
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Pedido'
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
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 618
    Height = 41
    Align = alTop
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      AlignWithMargins = True
      Left = 70
      Top = 16
      Width = 23
      Height = 23
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object EdtCodCli: TLabeledEdit
      AlignWithMargins = True
      Left = 3
      Top = 16
      Width = 65
      Height = 23
      EditLabel.Width = 90
      EditLabel.Height = 15
      EditLabel.Caption = 'Busca de Cliente:'
      TabOrder = 0
      Text = ''
      OnKeyDown = EdtCodCliKeyDown
      OnKeyPress = EdtCodCliKeyPress
    end
    object EdtNome: TEdit
      AlignWithMargins = True
      Left = 96
      Top = 16
      Width = 329
      Height = 23
      TabStop = False
      CharCase = ecUpperCase
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 50
    Width = 618
    Height = 41
    Align = alTop
    TabOrder = 1
    object SpeedButton2: TSpeedButton
      Left = 70
      Top = 16
      Width = 23
      Height = 23
      Caption = '...'
      OnClick = SpeedButton2Click
    end
    object SpeedButton6: TSpeedButton
      Left = 578
      Top = 16
      Width = 23
      Height = 23
      Caption = '+'
      OnClick = SpeedButton6Click
    end
    object EdtCodPro: TLabeledEdit
      Left = 3
      Top = 16
      Width = 65
      Height = 23
      EditLabel.Width = 96
      EditLabel.Height = 15
      EditLabel.Caption = 'Busca de Produto:'
      TabOrder = 0
      Text = ''
      OnEnter = EdtCodProEnter
      OnKeyDown = EdtCodProKeyDown
      OnKeyPress = EdtCodProKeyPress
    end
    object EdtDescr: TEdit
      Left = 96
      Top = 16
      Width = 329
      Height = 23
      TabStop = False
      CharCase = ecUpperCase
      ReadOnly = True
      TabOrder = 1
    end
    object EdtQtd: TLabeledEdit
      Left = 429
      Top = 16
      Width = 49
      Height = 23
      EditLabel.Width = 25
      EditLabel.Height = 15
      EditLabel.Caption = 'QTD:'
      TabOrder = 2
      Text = ''
      OnKeyPress = EdtQtdKeyPress
    end
    object EdtVlr: TLabeledEdit
      Left = 483
      Top = 16
      Width = 86
      Height = 23
      EditLabel.Width = 29
      EditLabel.Height = 15
      EditLabel.Caption = 'Valor:'
      TabOrder = 3
      Text = ''
      OnKeyDown = EdtVlrKeyDown
      OnKeyPress = EdtVlrKeyPress
    end
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 97
    Width = 618
    Height = 270
    Align = alClient
    TabOrder = 2
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 251
      Width = 610
      Height = 15
      Align = alBottom
      Alignment = taRightJustify
      Caption = 'Total:                '
      Color = clSkyBlue
      ParentColor = False
      Transparent = False
      ExplicitLeft = 538
      ExplicitWidth = 76
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 616
      Height = 247
      Align = alClient
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnKeyDown = DBGrid1KeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'Codigo'
          Title.Caption = 'C'#243'digo'
          Width = 49
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Descr'
          Title.Caption = 'Descri'#231#227'o'
          Width = 308
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Qtd'
          Title.Caption = 'QTD'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Valor'
          Width = 82
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Total'
          Width = 78
          Visible = True
        end>
    end
  end
  object Panel4: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 373
    Width = 618
    Height = 65
    Align = alBottom
    TabOrder = 3
    object SpeedButton3: TSpeedButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 89
      Height = 57
      Align = alLeft
      Caption = 'Novo'
      Flat = True
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      AlignWithMargins = True
      Left = 99
      Top = 4
      Width = 89
      Height = 57
      Align = alLeft
      Caption = 'Cancelar'
      Enabled = False
      Flat = True
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 520
      Top = 1
      Width = 97
      Height = 63
      Align = alRight
      Caption = 'Voltar'
      Flat = True
      OnClick = SpeedButton5Click
    end
    object SpeedButton7: TSpeedButton
      AlignWithMargins = True
      Left = 280
      Top = 4
      Width = 89
      Height = 57
      Align = alLeft
      Caption = 'Gravar'
      Enabled = False
      Flat = True
      OnClick = SpeedButton7Click
      ExplicitLeft = 283
      ExplicitTop = 0
    end
    object SpeedButton8: TSpeedButton
      Left = 191
      Top = 1
      Width = 86
      Height = 63
      Align = alLeft
      Caption = 'Busca Pedido'
      Flat = True
      OnClick = SpeedButton8Click
      ExplicitLeft = 188
      ExplicitTop = 0
    end
    object SpeedButton9: TSpeedButton
      Left = 372
      Top = 1
      Width = 93
      Height = 63
      Align = alLeft
      Caption = 'Deletar'
      Enabled = False
      Flat = True
      OnClick = SpeedButton9Click
      ExplicitLeft = 375
      ExplicitTop = 0
    end
  end
  object DataSource: TDataSource
    DataSet = Cds
    Left = 435
    Top = 257
  end
  object Cds: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 427
    Top = 169
    object CdsCodigo: TIntegerField
      FieldName = 'Codigo'
    end
    object CdsDescr: TStringField
      FieldName = 'Descr'
      Size = 60
    end
    object CdsQtd: TIntegerField
      FieldName = 'Qtd'
    end
    object CdsValor: TFloatField
      FieldName = 'Valor'
      DisplayFormat = '#,##0.00'
    end
    object CdsTotal: TFloatField
      FieldName = 'Total'
      DisplayFormat = '#,##0.00'
    end
  end
end
