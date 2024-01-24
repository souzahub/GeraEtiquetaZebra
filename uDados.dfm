object dmDados: TdmDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 374
  Width = 537
  object FDAuxiliar: TFDQuery
    Connection = SqlConexao
    Left = 116
    Top = 29
  end
  object SqlConexao: TFDConnection
    Params.Strings = (
      'Database=D:\GIT_PROJETOS\GeraEtiquetaZebra\bin\BD.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey')
    LoginPrompt = False
    Left = 36
    Top = 29
  end
  object FDEtq: TFDQuery
    Connection = SqlConexao
    SQL.Strings = (
      'Select * from ETIQUETAS order by NOME')
    Left = 44
    Top = 112
    object FDEtqID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      Required = True
    end
    object FDEtqNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 50
    end
    object FDEtqFONTE: TIntegerField
      FieldName = 'FONTE'
      Origin = 'FONTE'
    end
    object FDEtqLARGURA: TIntegerField
      FieldName = 'LARGURA'
      Origin = 'LARGURA'
    end
    object FDEtqALTURA: TIntegerField
      FieldName = 'ALTURA'
      Origin = 'ALTURA'
    end
    object FDEtqCADASTRO: TSQLTimeStampField
      FieldName = 'CADASTRO'
      Origin = 'CADASTRO'
    end
    object FDEtqMODELO: TIntegerField
      FieldName = 'MODELO'
      Origin = 'MODELO'
      OnGetText = FDEtqMODELOGetText
    end
    object FDEtqCOMPRIMENTO_V: TIntegerField
      FieldName = 'COMPRIMENTO_V'
      Origin = 'COMPRIMENTO_V'
    end
    object FDEtqALTURA_V: TIntegerField
      FieldName = 'ALTURA_V'
      Origin = 'ALTURA_V'
    end
    object FDEtqCOMPRIMENTOT_V: TIntegerField
      FieldName = 'COMPRIMENTOT_V'
      Origin = 'COMPRIMENTOT_V'
    end
    object FDEtqALTURAT_V: TIntegerField
      FieldName = 'ALTURAT_V'
      Origin = 'ALTURAT_V'
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrHourGlass
    Left = 56
    Top = 197
  end
end
