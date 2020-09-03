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

cd $(dirname $0) # This fixes path restriction
PARTS="./parts/"

function decompress {
	xz -d "$1"
}

if test -f "./vendor.img"; then
    echo "File exists; not regenerating..."
    exit 0
fi

for part in $(find $PARTS -type f | sort); do
    echo "Concatinating $part"
	cat $part >> ./vendor.img.xz
done

for compressed_image in ./images/*.xz; do
    echo "Decompressing $compressed_image"
    decompress "$compressed_image"
done

decompress "./vendor.img.xz"

echo "[*] Verifying image checksums"
md5sum -c md5sums.txt
RET=$?
if [ $RET -ne 0 ]; then
    echo -e "[!!!] FILE CORRUPTION DETECTED\nRedownload sources"
    exit $RET
fi


