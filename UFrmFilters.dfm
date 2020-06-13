object FrmFilters: TFrmFilters
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1092#1080#1083#1100#1090#1088#1086#1074
  ClientHeight = 597
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object GrBoxRestricLengrh: TsGroupBox
    Left = 8
    Top = 8
    Width = 465
    Height = 75
    Caption = #1053#1077' '#1076#1086#1073#1072#1074#1083#1103#1090#1100' '#1089#1083#1086#1074#1072' '#1086#1087#1088#1077#1076#1077#1083#1077#1085#1085#1086#1081' '#1076#1083#1080#1085#1099
    TabOrder = 0
    object lblRestricMinLength: TsLabel
      Left = 192
      Top = 35
      Width = 28
      Height = 16
      Caption = #1052#1080#1085'.'
    end
    object lblRestricMaxLength: TsLabel
      Left = 295
      Top = 35
      Width = 33
      Height = 16
      Caption = #1052#1072#1082#1089'.'
    end
    object ChBoxRestricLength: TsCheckBox
      Left = 27
      Top = 34
      Width = 158
      Height = 20
      Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1086' '#1076#1083#1080#1085#1077
      TabOrder = 0
    end
    object SpEdMinLength: TsSpinEdit
      Left = 226
      Top = 32
      Width = 55
      Height = 24
      TabOrder = 1
      Text = '1'
      OnChange = SpEdMinLengthChange
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clBlack
      BoundLabel.Font.Height = -13
      BoundLabel.Font.Name = 'Tahoma'
      BoundLabel.Font.Style = []
      MaxValue = 64
      MinValue = 1
      Value = 1
    end
    object SpEdMaxLength: TsSpinEdit
      Left = 334
      Top = 32
      Width = 53
      Height = 24
      TabOrder = 2
      Text = '64'
      OnChange = SpEdMaxLengthChange
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clBlack
      BoundLabel.Font.Height = -13
      BoundLabel.Font.Name = 'Tahoma'
      BoundLabel.Font.Style = []
      MaxValue = 64
      MinValue = 2
      Value = 64
    end
  end
  object GrBoxConvertCase: TsGroupBox
    Left = 8
    Top = 89
    Width = 465
    Height = 120
    Caption = #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1075#1080#1089#1090#1088#1072
    TabOrder = 1
    object ChBoxConvertCase: TsCheckBox
      Left = 45
      Top = 45
      Width = 82
      Height = 20
      Caption = #1042#1082#1083#1102#1095#1077#1085#1086
      TabOrder = 0
    end
    object RdGrpConvertCase: TsRadioGroup
      Left = 134
      Top = 23
      Width = 300
      Height = 82
      TabOrder = 1
      TabStop = True
      ItemIndex = 0
      Items.Strings = (
        #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1085#1080#1078#1085#1080#1081' '#1088#1077#1075#1080#1089#1090#1088
        #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1074#1077#1088#1093#1085#1080#1081' '#1088#1077#1075#1080#1089#1090#1088' ')
    end
  end
  object GrBoxExclude: TsGroupBox
    Left = 8
    Top = 215
    Width = 465
    Height = 330
    Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1089#1080#1084#1074#1086#1083#1099' '#1080' '#1089#1083#1086#1074#1072
    TabOrder = 2
    object mmExcludeWords: TsMemo
      Left = 17
      Top = 232
      Width = 304
      Height = 81
      ScrollBars = ssVertical
      TabOrder = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clBlack
      BoundLabel.Font.Height = -13
      BoundLabel.Font.Name = 'Tahoma'
      BoundLabel.Font.Style = []
    end
    object BtnOpenList: TsButton
      Left = 336
      Top = 233
      Width = 113
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      TabOrder = 1
      OnClick = BtnOpenListClick
    end
    object ChBoxNoDuplicat: TsCheckBox
      Left = 17
      Top = 32
      Width = 171
      Height = 20
      Caption = #1053#1077' '#1076#1086#1073#1072#1074#1083#1103#1090#1100' '#1076#1091#1073#1083#1080#1082#1072#1090#1099
      TabOrder = 2
    end
    object GrBoxExclude2: TsGroupBox
      Left = 17
      Top = 50
      Width = 432
      Height = 145
      TabOrder = 3
      object EdExcludeSymbolsOf: TsEdit
        Left = 117
        Top = 52
        Width = 293
        Height = 24
        TabOrder = 0
        Text = '!@#$%^&*()-_+=~`[]{}|\:;"'#39'<>,.?/'
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clBlack
        BoundLabel.Font.Height = -13
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
      end
      object EdExcludeSymbolsIn: TsEdit
        Left = 117
        Top = 108
        Width = 293
        Height = 24
        TabOrder = 1
        Text = '!@#$%^&*()-_+=~`[]{}|\:;"'#39'<>,.?/'
        BoundLabel.Font.Charset = DEFAULT_CHARSET
        BoundLabel.Font.Color = clBlack
        BoundLabel.Font.Height = -13
        BoundLabel.Font.Name = 'Tahoma'
        BoundLabel.Font.Style = []
      end
      object RdBtnExcludeSymbolsOf: TsRadioButton
        Left = 117
        Top = 26
        Width = 276
        Height = 20
        Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1089#1083#1086#1074#1072' '#1085#1077' '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1077' '#1089#1080#1084#1074#1086#1083#1099
        Checked = True
        TabOrder = 2
        TabStop = True
      end
      object RdBtnExcludeSymbolsIn: TsRadioButton
        Left = 117
        Top = 82
        Width = 258
        Height = 20
        Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1089#1083#1086#1074#1072' '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1077' '#1089#1080#1084#1074#1086#1083#1099
        TabOrder = 3
      end
      object ChBoxExcludeSymbolsEnabled: TsCheckBox
        Left = 28
        Top = 52
        Width = 76
        Height = 20
        Caption = #1042#1083#1102#1095#1077#1085#1086
        TabOrder = 4
      end
    end
    object ChBoxExcludeWords: TsCheckBox
      Left = 21
      Top = 206
      Width = 257
      Height = 20
      Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1089#1083#1086#1074#1072' '#1089#1086' '#1089#1083#1086#1074#1072#1084#1080' (c'#1083#1086#1075#1072#1084#1080')'
      TabOrder = 4
    end
  end
  object BtnOk: TsButton
    Left = 208
    Top = 559
    Width = 105
    Height = 30
    Caption = 'OK'
    TabOrder = 3
    OnClick = BtnOkClick
  end
  object sSkinProvider: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 424
    Top = 32
  end
  object sOpenDialog: TsOpenDialog
    Filter = 
      #1058#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083' (*.txt) |*.txt|'#1060#1072#1081#1083' '#1089#1083#1086#1074#1072#1088#1103' (*.dic)|*.dic|'#1051#1102#1073#1099#1077' '#1092 +
      #1072#1081#1083#1099' (*.*)|*.*'
    Left = 408
    Top = 487
  end
end
