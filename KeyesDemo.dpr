program KeyesDemo;

uses
  Vcl.Forms,
  keyesdemomain in 'keyesdemomain.pas' {frmMain},
  usb_relay_device in 'usb_relay_device.pas',
  UsbRelay in 'UsbRelay.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
