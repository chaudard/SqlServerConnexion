object ApplicationGUIForm: TApplicationGUIForm
  Left = 0
  Top = 0
  Caption = 'Connexion with sql server'
  ClientHeight = 566
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbUseNavigator: TLabel
    Left = 8
    Top = 232
    Width = 292
    Height = 13
    Caption = 'Use this navigator to make change in the table and validate :'
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 265
    Width = 649
    Height = 293
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 309
    Top = 229
    Width = 350
    Height = 19
    TabOrder = 1
  end
  object btnConnectAndDisplayTable: TButton
    Left = 8
    Top = 191
    Width = 649
    Height = 25
    Caption = 'clic to see the table'
    TabOrder = 2
    OnClick = btnConnectAndDisplayTableClick
  end
  object gbDatasConnexion: TGroupBox
    Left = 8
    Top = 8
    Width = 649
    Height = 177
    Caption = 'datas connexion'
    TabOrder = 3
    object rgSecurity: TRadioGroup
      Left = 272
      Top = 16
      Width = 361
      Height = 142
      Caption = 'security'
      ItemIndex = 0
      Items.Strings = (
        'integrated security of Windows NT'
        'user and password')
      TabOrder = 0
      OnClick = rgSecurityClick
    end
    object gbUserPassword: TGroupBox
      Left = 410
      Top = 85
      Width = 209
      Height = 68
      TabOrder = 1
      object lbUser: TLabel
        Left = 10
        Top = 13
        Width = 31
        Height = 13
        Caption = 'user : '
      end
      object lbPassWord: TLabel
        Left = 12
        Top = 37
        Width = 56
        Height = 13
        Caption = 'password : '
      end
      object edUser: TEdit
        Left = 74
        Top = 10
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object edPassword: TEdit
        Left = 74
        Top = 37
        Width = 121
        Height = 21
        TabOrder = 1
      end
    end
    object gbTarget: TGroupBox
      Left = 16
      Top = 16
      Width = 250
      Height = 142
      Caption = 'target'
      TabOrder = 2
      object lbDataSource: TLabel
        Left = 16
        Top = 24
        Width = 96
        Height = 13
        Caption = 'server name or IP : '
      end
      object lbCatalog: TLabel
        Left = 16
        Top = 65
        Width = 84
        Height = 13
        Caption = 'database name : '
      end
      object lbTable: TLabel
        Left = 16
        Top = 106
        Width = 63
        Height = 13
        Caption = 'table name : '
      end
      object edDataSource: TEdit
        Left = 119
        Top = 21
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object edCatalog: TEdit
        Left = 119
        Top = 62
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object edTable: TEdit
        Left = 119
        Top = 103
        Width = 121
        Height = 21
        TabOrder = 2
      end
    end
  end
  object ADOConnection1: TADOConnection
    Left = 184
    Top = 512
  end
  object ADOTable1: TADOTable
    Left = 104
    Top = 512
  end
  object DataSource1: TDataSource
    Left = 32
    Top = 512
  end
end
