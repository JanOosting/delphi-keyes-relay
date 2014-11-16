unit keyesdemomain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UsbRelay, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    btnFindDevices: TButton;
    tcUsbRelayDevices: TTabControl;
    btnOpenDevice: TButton;
    btnCloseDevice: TButton;
    pnlDeviceOpen: TPanel;
    cbRelay1: TCheckBox;
    cbRelay2: TCheckBox;
    cbRelay3: TCheckBox;
    cbRelay4: TCheckBox;
    cbRelay5: TCheckBox;
    cbRelay6: TCheckBox;
    cbRelay7: TCheckBox;
    cbRelay8: TCheckBox;
    procedure btnFindDevicesClick(Sender: TObject);
    procedure tcUsbRelayDevicesChange(Sender: TObject);
    procedure btnOpenDeviceClick(Sender: TObject);
    procedure btnCloseDeviceClick(Sender: TObject);
    procedure cbRelayClick(Sender: TObject);
  private
    FDeviceState: boolean;
    CurrentRelay : TUsbRelay;
    procedure SetDeviceState(const Value: boolean);
    procedure ShowRelays;
    procedure SetCheckbox(cb:TCheckBox);
    { Private declarations }
    property DeviceState:boolean read FDeviceState write SetDeviceState;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCloseDeviceClick(Sender: TObject);
begin
  CurrentRelay.open:=False;
  DeviceState:=CurrentRelay.open;
end;

procedure TfrmMain.btnFindDevicesClick(Sender: TObject);
begin
  CurrentRelay:=nil;
  tcUsbRelayDevices.Tabs.Clear;
  FindUsbRelays;
  if UsbRelays.Count>0 then
  begin
    tcUsbRelayDevices.Visible:=true;
    tcUsbRelayDevices.Tabs.Addstrings(UsbRelays);
    tcUsbRelayDevicesChange(self);
  end
  else begin
    tcUsbRelayDevices.Visible:=false;
  end;
end;

procedure TfrmMain.btnOpenDeviceClick(Sender: TObject);
begin
  CurrentRelay.open:=True;
  DeviceState:=CurrentRelay.open;
end;

procedure TfrmMain.cbRelayClick(Sender: TObject);
begin
  CurrentRelay.state[TCheckbox(Sender).Tag]:=TCheckbox(Sender).Checked;
  //ShowRelays;
end;

procedure TfrmMain.SetCheckbox(cb: TCheckBox);
begin
  if (cb.Tag>CurrentRelay.devicetype) or (not CurrentRelay.open) then
  begin
    cb.Checked:=false;
    cb.Enabled:=false;
  end
  else begin
    cb.Checked:=CurrentRelay.state[cb.Tag];
    cb.Enabled:=True;
  end;
end;

procedure TfrmMain.SetDeviceState(const Value: boolean);
begin
  if Value then
    pnlDeviceOpen.Color:=clGreen
  else
    pnlDeviceOpen.Color:=clRed;
  FDeviceState := Value;
  ShowRelays;
end;

procedure TfrmMain.ShowRelays;
begin
  SetCheckBox(cbRelay1);
  SetCheckBox(cbRelay2);
  SetCheckBox(cbRelay3);
  SetCheckBox(cbRelay4);
  SetCheckBox(cbRelay5);
  SetCheckBox(cbRelay6);
  SetCheckBox(cbRelay7);
  SetCheckBox(cbRelay8);
end;

procedure TfrmMain.tcUsbRelayDevicesChange(Sender: TObject);
begin
  CurrentRelay:=TUsbRelay(UsbRelays.Objects[tcUsbRelayDevices.TabIndex]);
  DeviceState:=CurrentRelay.open;
  ShowRelays;
end;

end.
