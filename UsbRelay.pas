unit UsbRelay;

interface
uses
  System.Classes, System.SysUtils, usb_relay_device;
type

  TUsbRelay = class(Tobject)
  private
    hHandle: integer;
    Fdevicetype: integer;
    Fopen: boolean;
    FSerial: string;
    Fdevicepath: string;
    status:cardinal;
    function Getstate(index: integer): boolean;
    procedure refresh;
    procedure Setopen(const Value: boolean);
    procedure Setstate(index: integer; const Value: boolean);
  public
    constructor create(aSerial:string;aDevicetype:integer;aDevicepath:string);
    procedure openallchannels;
    procedure closeallchannels;
    property serial:string read FSerial;
    property devicetype: integer read Fdevicetype;
    property devicepath: string read Fdevicepath;
    property open: boolean read Fopen write Setopen;
    // !! index is 1-based !!
    property state[index: integer]: boolean read Getstate write Setstate;
  end;

var
  UsbRelays : TStringList;

procedure FindUsbRelays;

function GetUsbRelayType(id:string):integer;
function SetUsbRelayPort(id:string;port:integer;state:boolean):integer;

implementation
var
  UsbRelayOpened:boolean;

function GetUsbRelayType(id:string):integer;
var
  i:integer;
  UsbRelay:TUsbRelay;
begin
  if Not UsbRelayOpened then
    FindUsbRelays;
  i:=UsbRelays.IndexOf(id);
  if i>=0 then
  begin
    UsbRelay:=TUsbRelay(UsbRelays.Objects[i]);
    result:=UsbRelay.devicetype;
  end
  else begin
    result:=0;
  end;
end;

function SetUsbRelayPort(id:string;port:integer;state:boolean):integer;
var
  i:integer;
  UsbRelay:TUsbRelay;
begin
  if Not UsbRelayOpened then
    FindUsbRelays;
  i:=UsbRelays.IndexOf(id);
  if i>=0 then
  begin
    UsbRelay:=TUsbRelay(UsbRelays.Objects[i]);
    UsbRelay.open:=true;
    UsbRelay.state[port]:=state;
    UsbRelay.open:=false;
    result:=0;
  end
  else begin
    result:=-1;
  end;
end;

procedure ClearRelayDevices;
var
  I: Integer;
  UsbRelay:TUsbRelay;
begin
  for I := 0 to UsbRelays.Count-1 do
  begin
    UsbRelay:=TUsbRelay(UsbRelays.Objects[i]);
    UsbRelay.closeallchannels;
    UsbRelay.open:=False;
    UsbRelay.Free;
  end;
  UsbRelays.Clear;
end;

procedure ListDevices;
var
  origin, deviceinfo : pusb_relay_device_info;
  UsbRelay:TUsbRelay;
begin
  if UsbRelayOpened then
  begin
    origin:=usb_relay_device_enumerate;
    deviceinfo:=origin;
    while assigned(deviceinfo) do
    begin
      UsbRelay:=TUsbRelay.create(deviceinfo.serial_number,deviceinfo.device_type,deviceinfo.device_path);
      UsbRelays.AddObject(deviceinfo.serial_number,UsbRelay);
      deviceinfo:=deviceinfo^.next;
    end;
    usb_relay_device_free_enumerate(origin);
  end;
end;

procedure FindUsbRelays;
begin
  if UsbRelayOpened then
  begin
    ClearRelayDevices;
    ListDevices;
  end
  else begin
    if usb_relay_deviceDLLLoaded then
    begin
      if usb_relay_init=0 then
      begin
        UsbRelayOpened:=true;
        ListDevices;
      end;
    end;
  end;
end;

{ TUsbRelay }

procedure TUsbRelay.closeallchannels;
begin
  if hHandle<>0 then
    usb_relay_device_close_all_relay_channel(hHandle);
  refresh;
end;

constructor TUsbRelay.create(aSerial: string; aDevicetype: integer;
  aDevicepath: string);
begin
  FSerial:=aSerial;
  Fdevicetype:=aDevicetype;
  Fdevicepath:=aDevicepath;
end;

function TUsbRelay.Getstate(index: integer): boolean;
begin
  result:=((1 SHL (index-1)) and status)<> 0;
end;

procedure TUsbRelay.openallchannels;
begin
  if hHandle<>0 then
    usb_relay_device_open_all_relay_channel(hHandle);
  refresh;
end;

procedure TUsbRelay.refresh;
var
  tempstatus : cardinal;
begin
  if hHandle<>0 then
  begin
    usb_relay_device_get_status(hHandle,@tempstatus);
    status:=tempstatus;
  end
  else
    status:=0;
end;
{$X+}
procedure TUsbRelay.Setopen(const Value: boolean);
var
  buffer:array[0..5] of ansichar;
begin
  if UsbRelayOpened then
  begin
    if Value<>Fopen then
    begin
      if Value then
      begin
        StrPCopy(PansiChar(@buffer), AnsiString(Copy(Serial,1,5)));
        hHandle:=usb_relay_device_open_with_serial_number(@buffer,length(serial));
      end
      else begin
        usb_relay_device_close(hHandle);
        hHandle:=0;
        status:=0;
      end;
      Fopen := hHandle<>0;
    end;
    refresh;
  end;
end;

procedure TUsbRelay.Setstate(index: integer; const Value: boolean);
begin
  if hHandle<>0 then
  begin
    if Value then
      usb_relay_device_open_one_relay_channel(hHandle,index)
    else
      usb_relay_device_close_one_relay_channel(hHandle,index);
    refresh;
  end;
end;

initialization
  UsbRelays:=TStringList.Create;
finalization
  if UsbRelayOpened then
  begin
    ClearRelayDevices;
    usb_relay_exit;
  end;
  UsbRelays.Free;
end.
