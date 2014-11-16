object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Keyes USB Relay demo'
  ClientHeight = 329
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    319
    329)
  PixelsPerInch = 96
  TextHeight = 13
  object btnFindDevices: TButton
    Left = 8
    Top = 8
    Width = 97
    Height = 25
    Caption = 'Find Devices'
    TabOrder = 0
    OnClick = btnFindDevicesClick
  end
  object tcUsbRelayDevices: TTabControl
    Left = 8
    Top = 39
    Width = 303
    Height = 282
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    Visible = False
    OnChange = tcUsbRelayDevicesChange
    object btnOpenDevice: TButton
      Left = 3
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Open Device'
      TabOrder = 0
      OnClick = btnOpenDeviceClick
    end
    object btnCloseDevice: TButton
      Left = 144
      Top = 32
      Width = 75
      Height = 25
      Caption = 'Close Device'
      TabOrder = 1
      OnClick = btnCloseDeviceClick
    end
    object pnlDeviceOpen: TPanel
      Left = 88
      Top = 32
      Width = 50
      Height = 25
      Color = clRed
      ParentBackground = False
      TabOrder = 2
    end
    object cbRelay1: TCheckBox
      Tag = 1
      Left = 32
      Top = 72
      Width = 97
      Height = 17
      Caption = 'Relay 1'
      TabOrder = 3
      OnClick = cbRelayClick
    end
    object cbRelay2: TCheckBox
      Tag = 2
      Left = 32
      Top = 95
      Width = 97
      Height = 17
      Caption = 'Relay 2'
      TabOrder = 4
      OnClick = cbRelayClick
    end
    object cbRelay3: TCheckBox
      Tag = 3
      Left = 32
      Top = 118
      Width = 97
      Height = 17
      Caption = 'Relay 3'
      TabOrder = 5
      OnClick = cbRelayClick
    end
    object cbRelay4: TCheckBox
      Tag = 4
      Left = 32
      Top = 141
      Width = 97
      Height = 17
      Caption = 'Relay 4'
      TabOrder = 6
      OnClick = cbRelayClick
    end
    object cbRelay5: TCheckBox
      Tag = 5
      Left = 32
      Top = 164
      Width = 97
      Height = 17
      Caption = 'Relay 5'
      TabOrder = 7
      OnClick = cbRelayClick
    end
    object cbRelay6: TCheckBox
      Tag = 6
      Left = 32
      Top = 187
      Width = 97
      Height = 17
      Caption = 'Relay 6'
      TabOrder = 8
      OnClick = cbRelayClick
    end
    object cbRelay7: TCheckBox
      Tag = 7
      Left = 32
      Top = 210
      Width = 97
      Height = 17
      Caption = 'Relay 7'
      TabOrder = 9
      OnClick = cbRelayClick
    end
    object cbRelay8: TCheckBox
      Tag = 8
      Left = 32
      Top = 233
      Width = 97
      Height = 17
      Caption = 'Relay 8'
      TabOrder = 10
      OnClick = cbRelayClick
    end
  end
end
