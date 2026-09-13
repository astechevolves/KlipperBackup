#!/usr/bin/env python3
"""
CP2112 HID visibility/open test.

This checks the exact thing Klipper/Moonraker helper scripts need:
- Python hidapi module imports
- CP2112 enumerates
- CP2112 opens as the current user

Run with:
~/klippy-env/bin/python /home/goofballtech/printer_data/config/helpers/cp2112_hid_check.py
"""

import os
import sys

VID = 0x10C4
PID = 0xEA90

try:
    import hid
except ModuleNotFoundError:
    print("FAIL: Python module 'hid' is missing.")
    print("Fix: ~/klippy-env/bin/python -m pip install hidapi")
    sys.exit(1)

print(f"Running as UID={os.getuid()} GID={os.getgid()}")
print(f"Checking CP2112 VID:PID {VID:04x}:{PID:04x}")

devices = hid.enumerate(VID, PID)

print(f"CP2112 devices found: {len(devices)}")

for index, dev_info in enumerate(devices, start=1):
    print(f"\nDevice {index}:")
    print(f"  path: {dev_info.get('path')}")
    print(f"  manufacturer: {dev_info.get('manufacturer_string')}")
    print(f"  product: {dev_info.get('product_string')}")
    print(f"  serial: {dev_info.get('serial_number')}")
    print(f"  interface_number: {dev_info.get('interface_number')}")

if not devices:
    print("\nFAIL: CP2112 did not enumerate.")
    print("Check USB cable, USB port, and lsusb output.")
    sys.exit(2)

try:
    dev = hid.device()
    dev.open(VID, PID)
    print("\nPASS: CP2112 opened successfully as the current user.")
    dev.close()
except OSError as exc:
    print("\nFAIL: CP2112 enumerated but could not be opened.")
    print(f"Error: {exc}")
    print("\nLikely cause: USB/hidraw permissions.")
    print("If this works with sudo but not as normal user, apply the udev fix.")
    sys.exit(3)
