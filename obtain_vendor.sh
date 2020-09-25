#!/bin/bash
# Copyright (C) 2020 Arvind Mukund <armu30@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

IMAGES="$1"
 
FINGERPRINT="$(strings $IMAGES/vendor.img | grep "ro.vendor.build.fingerprint" | cut -d'=' -f2-)"
DESC="$(strings $IMAGES/system.img | grep "ro.build.display.id=" | cut -d'=' -f2)"
DEVICE_MAKEFILE="../../../device/xiaomi/laurel_sprout/lineage_laurel_sprout.mk"

echo "Found fingerprint $FINGERPRINT"
echo "Found qssi image $DESC"

echo "[+] Updating device tree fingerprint and description"
sed "s#BUILD_FINGERPRINT :=.*#BUILD_FINGERPRINT :=\ \"$FINGERPRINT\"#g" $DEVICE_MAKEFILE -i
sed "s#PRIVATE_BUILD_DESC=.*#PRIVATE_BUILD_DESC=\"$DESC\" \\\#g" $DEVICE_MAKEFILE -i
echo "[-] Updated device tree at $DEVICE_MAKEFILE"

cat << EOF > vendor-image.mk
# Copyright (C) 2020 The PixelExperience Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

BOARD_PREBUILT_VENDORIMAGE := vendor/xiaomi/laurel_sprout-images/vendor.img

CUSTOM_DEVICE_FINGERPRINT := "$FINGERPRINT"
CUSTOM_DEVICE_DESC := "$DESC"

EOF

echo "[*] Cleaning up!"
rm images/*
rm vendor.img
rm vendor.img.gz

echo "[*] Copying images"
cp $IMAGES/abl.elf images/abl.img
cp $IMAGES/BTFM.bin images/bluetooth.img
cp $IMAGES/cmnlib.mbn images/cmnlib.img
cp $IMAGES/cmnlib64.mbn images/cmnlib64.img
cp $IMAGES/devcfg.mbn images/devcfg.img
cp $IMAGES/dspso.bin images/dsp.img
cp $IMAGES/hyp.mbn images/hyp.img
cp $IMAGES/imagefv.elf images/imagefv.img
cp $IMAGES/km4.mbn images/keymaster.img
cp $IMAGES/NON-HLOS.bin images/modem.img
cp $IMAGES/qupv3fw.elf images/qupfw.img
cp $IMAGES/rpm.mbn images/rpm.img
cp $IMAGES/storsec.mbn images/storsec.img
cp $IMAGES/tz.mbn images/tz.img
cp $IMAGES/uefi_sec.mbn images/uefisecapp.img
cp $IMAGES/xbl_config.elf images/xbl_config.img
cp $IMAGES/xbl.elf images/xbl.img
echo "[*] Done copying radio images"

echo "[*] Copying vendor.img"
cp $IMAGES/vendor.img vendor.img
echo "[!] All files copied, run split.py to make it GitHub compliant"


