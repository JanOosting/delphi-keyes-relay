delphi-keyes-relay
==================

Delphi interface to Keyes usb relay

Devices
-------

http://www.dx.com/p/keyes-1-channel-usb-control-switch-relay-module-for-pc-red-5v-308292
http://www.dx.com/p/keyes-2-way-5v-free-drive-usb-control-switch-relay-module-red-307714

Description
-----------

Translated the file usb_relay_device.h from the rar file found at https://app.box.com/s/0v2dprnozmry05luxopv

Usage
-----

1. Create a new Delphi Project
2. Copy the `usb_relay_device.pas` and `UsbRelay.pas` files into the source dir of your project or add the directory to your project options.
3. Copy the `usb_relay_device.dll` file to the output directory of your project.
4. Put UsbRelay in the `Uses` section
5. `FindUsbRelays` retrieves a list of relays and stores the in a Stringlist `UsbRelays` that has the serials in the `Strings` and `TUsbRelay` in the accompanying `Objects`.
6. After setting 'TUsbRelay.open' to `true` individual relays on the device can be controlled with the property `TUsbRelay.state[index]`. Note that `index` here is 1-based.
7. The 'TUsbRelay.devicetype` is actually the number of relays on the device.
8. All relays on a device can be set or unset by 'TUsbRelay.openallchannels` and `TUsbRelay.closeallchannels`.


See the demo application 