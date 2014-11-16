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
2. Copy the usb_relay_device.pas file into the source dir of your project.
3. Copy the usb_relay_device.dll file to the output directory of your project.

1. call usb_relay_init() to init the lib.
2. call usb_relay_device_enumerate() to get all the device pluged into pc
3. call usb_relay_device_open() open the device you need
4. other operation funcation:
call sb_relay_device_open_one_relay_channel() to open one way relay
call usb_relay_device_open_all_relay_channel() to open all relays
call usb_relay_device_close_one_relay_channel()to close one way relay
call usb_relay_device_close_all_relay_channel()to close all relays

See the demo application 