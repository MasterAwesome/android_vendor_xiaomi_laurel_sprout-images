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

PREFIX="vendor/xiaomi/laurel_sprout-images"
PARTS="$PREFIX/parts/"

if test -f "$PREFIX/vendor.img"; then
    echo "File exists; not regenerating..."
    exit 0
fi

for part in $(find $PARTS -name "vendor.img.gz.*" | sort); do
    echo "Concatinating $part"
	cat $part >> $PREFIX/vendor.img.gz
done

for compressed_image in $PREFIX/images/*.gz; do
    echo "Decompressing $compressed_image"
    gunzip $compressed_image
done

gunzip $PREFIX/vendor.img.gz



