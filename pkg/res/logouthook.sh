#!/bin/sh
set -ex

BOOTKC="$(mktemp -d)/BootKernelExtensions.kc"

sed 's/com.apple.driver.usb.AppleUSBVHCIRSM/& com.apple.driver.usb.AppleUSBVHCICommonRSM/' "${VOLUME}/System/Library/KernelCollections/BootKernelExtensions.kc.elides" > "${BOOTKC}.elides"
kmutil create -n boot aux -k "${VOLUME}/System/Library/Kernels/kernel" -B "${BOOTKC}"
