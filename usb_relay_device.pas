unit usb_relay_device;
interface
uses windows;


type
  usb_relay_device_type = (
    USB_RELAY_DEVICE_ONE_CHANNEL = 1,
    USB_RELAY_DEVICE_TWO_CHANNEL = 2,
    USB_RELAY_DEVICE_FOUR_CHANNEL = 4,
    USB_RELAY_DEVICE_EIGHT_CHANNEL = 8,
    USB_RELAY_DEVICE_LAST = $10000  // make sure sizeof is large enough in structures/records
  );
  //*usb relay board info structure*/
  pusb_relay_device_info = ^usb_relay_device_info;
  usb_relay_device_info = record
    serial_number : pansichar;
    device_path : pansichar;
    device_type: integer;
    next: pusb_relay_device_info;
  end;
  relay_device_serial = array[0..5] of ansichar;
var
  {*init the USB Relay Libary
    @returns: This function returns 0 on success and -1 on error.
  *}
  usb_relay_init: function:integer;cdecl;

  {*Finalize the USB Relay Libary.
  This function frees all of the static data associated with
  USB Relay Libary. It should be called at the end of execution to avoid
  memory leaks.
  @returns:This function returns 0 on success and -1 on error.
  *}
  usb_relay_exit: function:integer;cdecl;

  {*Enumerate the USB Relay Devices.*}
  usb_relay_device_enumerate: function: pusb_relay_device_info;cdecl;

  {*Free an enumeration Linked List*}
  usb_relay_device_free_enumerate: procedure(device_info: pusb_relay_device_info);cdecl;

  {*open device that serial number is serial_number*/
  /*@return: This funcation returns a valid handle to the device on success or NULL on failure.*/
  /*e.g: usb_relay_device_open_with_serial_number("abcde", 5")*}
  usb_relay_device_open_with_serial_number: function(serial_number:pansichar; len: cardinal):integer;cdecl;

  {*open a usb relay device
  @return: This funcation returns a valid handle to the device on success or NULL on failure.}
  usb_relay_device_open:function(device_info: pusb_relay_device_info):integer;cdecl;

  {*close a usb relay device*}
  usb_relay_device_close: procedure(hHandle:integer);cdecl;

  {*open a relay channel on the USB-Relay-Device
  @paramter: index -- which channel your want to open
  hHandle -- which usb relay device your want to operate
  @returns: 0 -- success; 1 -- error; 2 -- index is outnumber the number of the usb relay device}
  usb_relay_device_open_one_relay_channel: function(hHandle, index:integer):integer;cdecl;

  {*open all relay channel on the USB-Relay-Device
  @paramter: hHandle -- which usb relay device your want to operate
  @returns: 0 -- success; 1 -- error}
  usb_relay_device_open_all_relay_channel: function(hHandle: integer):integer;cdecl;

  {*close a relay channel on the USB-Relay-Device
  @paramter: index -- which channel your want to close
  hHandle -- which usb relay device your want to operate
  @returns: 0 -- success; 1 -- error; 2 -- index is outnumber the number of the usb relay device}
  usb_relay_device_close_one_relay_channel: function(hHandle, index: integer):integer;cdecl;

  {*close all relay channel on the USB-Relay-Device
  @paramter: hHandle -- which usb relay device your want to operate
  @returns: 0 -- success; 1 -- error}
  usb_relay_device_close_all_relay_channel:function(hHandle:integer):integer;cdecl;

  {*
  status bit: High --> Low 0000 0000 0000 0000 0000 0000 0000 0000, one bit indicate a relay status.
  the lowest bit 0 indicate relay one status, 1 -- means open status, 0 -- means closed status.
  bit 0/1/2/3/4/5/6/7/8 indicate relay 1/2/3/4/5/6/7/8 status
  @returns: 0 -- success; 1 -- error}
  usb_relay_device_get_status: function(hHandle:integer; status:pcardinal):integer;cdecl;

  usb_relay_deviceDLLLoaded: Boolean = False;

implementation
var
  DLLHandle: THandle;
  ErrorMode: Integer;


procedure LoadUsbRelayDeviceDLL;
begin
  if usb_relay_deviceDLLLoaded then Exit;
  ErrorMode := SetErrorMode($8000{SEM_NoOpenFileErrorBox});
  DLLHandle := LoadLibrary('usb_relay_device.dll');
  if DLLHandle >= 32 then
  begin
    usb_relay_deviceDLLLoaded := True;


    @usb_relay_init :=GetProcAddress(DLLHandle,'usb_relay_init');
    Assert(@usb_relay_init <> nil);

    @usb_relay_exit :=GetProcAddress(DLLHandle,'usb_relay_exit');
    Assert(@usb_relay_exit <> nil);

    @usb_relay_device_enumerate :=GetProcAddress(DLLHandle,'usb_relay_device_enumerate');
    Assert(@usb_relay_device_enumerate <> nil);

    @usb_relay_device_free_enumerate :=GetProcAddress(DLLHandle,'usb_relay_device_free_enumerate');
    Assert(@usb_relay_device_free_enumerate <> nil);

    @usb_relay_device_open_with_serial_number :=GetProcAddress(DLLHandle,'usb_relay_device_open_with_serial_number');
    Assert(@usb_relay_device_open_with_serial_number <> nil);

    @usb_relay_device_open :=GetProcAddress(DLLHandle,'usb_relay_device_open');
    Assert(@usb_relay_device_open <> nil);

    @usb_relay_device_close :=GetProcAddress(DLLHandle,'usb_relay_device_close');
    Assert(@usb_relay_device_close <> nil);

    @usb_relay_device_open_one_relay_channel :=GetProcAddress(DLLHandle,'usb_relay_device_open_one_relay_channel');
    Assert(@usb_relay_device_open_one_relay_channel <> nil);

    @usb_relay_device_open_all_relay_channel :=GetProcAddress(DLLHandle,'usb_relay_device_open_all_relay_channel');
    Assert(@usb_relay_device_open_all_relay_channel <> nil);

    @usb_relay_device_close_one_relay_channel :=GetProcAddress(DLLHandle,'usb_relay_device_close_one_relay_channel');
    Assert(@usb_relay_device_close_one_relay_channel <> nil);

    @usb_relay_device_close_all_relay_channel :=GetProcAddress(DLLHandle,'usb_relay_device_close_all_relay_channel');
    Assert(@usb_relay_device_close_all_relay_channel <> nil);

    @usb_relay_device_get_status :=GetProcAddress(DLLHandle,'usb_relay_device_get_status');
    Assert(@usb_relay_device_get_status <> nil);

  end
  else
  begin
    usb_relay_deviceDLLLoaded := False;
  end;
  SetErrorMode(ErrorMode)
end;


initialization
  LoadUsbRelayDeviceDLL

finalization
  if  usb_relay_deviceDLLLoaded then
    FreeLibrary(DLLHandle)
end.
