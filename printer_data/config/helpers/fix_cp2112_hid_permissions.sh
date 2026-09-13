#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-$HOME/klippy-env/bin/python}"
HELPER_DIR="$HOME/printer_data/config/helpers"
CHECK_SCRIPT="$HELPER_DIR/cp2112_hid_check.py"

echo "Installing HID dependencies..."
sudo apt update
sudo apt install -y libhidapi-hidraw0 libhidapi-dev

echo "Installing hidapi into Klipper Python env..."
"$PYTHON_BIN" -m pip install hidapi

echo "Writing CP2112 udev rules..."
sudo tee /etc/udev/rules.d/99-cp2112.rules >/dev/null <<'EOF'
# Silicon Labs CP2112 USB HID-to-I2C bridge.
# Needed because hidapi may open the USB bus node directly.
SUBSYSTEM=="usb", ATTR{idVendor}=="10c4", ATTR{idProduct}=="ea90", MODE="0666", TAG+="uaccess"

# Also allow access if hidapi uses the hidraw backend.
KERNEL=="hidraw*", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea90", MODE="0666", TAG+="uaccess"
EOF

echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Applying permission fix to currently connected CP2112 USB node..."
CP2112_NODE="$(lsusb | awk 'tolower($0) ~ /10c4:ea90/ {gsub(":", "", $4); printf "/dev/bus/usb/%03d/%03d\n", $2, $4; exit}')"

if [[ -n "${CP2112_NODE}" && -e "${CP2112_NODE}" ]]; then
    echo "Found CP2112 USB node: ${CP2112_NODE}"
    sudo chmod 666 "${CP2112_NODE}"
else
    echo "WARNING: Could not find CP2112 USB node from lsusb."
fi

echo "Applying permission fix to matching hidraw nodes if present..."
for H in /sys/class/hidraw/hidraw*; do
    [[ -e "$H" ]] || continue

    NODE="/dev/$(basename "$H")"
    UEVENT="$(cat "$H/device/uevent" 2>/dev/null || true)"

    if echo "$UEVENT" | grep -qi "10C4.*EA90"; then
        echo "Found CP2112 hidraw node: ${NODE}"
        sudo chmod 666 "${NODE}"
    fi
done

echo
echo "Running CP2112 check as normal user..."
"$PYTHON_BIN" "$CHECK_SCRIPT"
