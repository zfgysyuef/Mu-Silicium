#!/bin/bash

# Package UEFI Image as Android Kernel
cat ./BootShim/BootShim.bin "./Build/vermeerPkg/${TARGET_BUILD_MODE}_CLANGPDB/FV/VERMEER_UEFI.fd" > "./Build/vermeerPkg/${TARGET_BUILD_MODE}_CLANGPDB/FV/VERMEER_UEFI.fd-bootshim"||exit 1
gzip -c < "./Build/vermeerPkg/${TARGET_BUILD_MODE}_CLANGPDB/FV/VERMEER_UEFI.fd-bootshim" > "./Build/vermeerPkg/${TARGET_BUILD_MODE}_CLANGPDB/FV/VERMEER_UEFI.fd-bootshim.gz"||exit 1
cat "./Build/vermeerPkg/${TARGET_BUILD_MODE}_CLANGPDB/FV/VERMEER_UEFI.fd-bootshim.gz" ./Resources/DTBs/vermeer.dtb > ./Resources/bootpayload.bin||exit 1

# Create Android boot.img
python3 ./Resources/Scripts/mkbootimg.py \
  --kernel ./Resources/bootpayload.bin \
  --ramdisk ./Resources/ramdisk \
  --os_version 16.0.0 \
  --os_patch_level "$(date '+%Y-%m')" \
  --header_version 1 \
  -o Mu-vermeer.img \
  ||_error "\nFailed to create Android Boot Image!\n"
