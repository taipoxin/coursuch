object Form1: TForm1
  Left = 837
  Top = 188
  Width = 561
  Height = 469
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label2: TLabel
    Left = 128
    Top = 136
    Width = 132
    Height = 16
    Caption = #1054#1090#1082#1088#1099#1090#1099#1081' '#1082#1083#1102#1095' {e;n}'
    Visible = False
  end
  object Label1: TLabel
    Left = 120
    Top = 48
    Width = 3
    Height = 16
  end
  object Label3: TLabel
    Left = 19
    Top = 72
    Width = 3
    Height = 16
  end
  object Button1: TButton
    Left = 96
    Top = 104
    Width = 217
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    TabOrder = 0
    Visible = False
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 144
    Top = 160
    Width = 121
    Height = 24
    TabOrder = 1
    Visible = False
  end
  object Button2: TButton
    Left = 96
    Top = 200
    Width = 217
    Height = 25
    Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    TabOrder = 2
    Visible = False
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 160
    Top = 8
    Width = 121
    Height = 25
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
    TabOrder = 3
    Visible = False
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
  end
  object MainMenu1: TMainMenu
    Left = 32
    object N1: TMenuItem
      Caption = #1052#1077#1085#1102
      object N2: TMenuItem
        Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1086#1076#1087#1080#1089#1100
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1100
        OnClick = N3Click
      end
      object N4: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N4Click
      end
    end
  end
end
