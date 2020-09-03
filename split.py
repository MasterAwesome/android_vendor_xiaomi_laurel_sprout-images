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

import gzip
import shutil
import os

PARTS_PREFIX = "parts/"
IMAGES_PREFIX = "images/"
TARGET_GZIP = "vendor.img.gz"
TARGET_IMAGE = "vendor.img"
GITHUB_LIMIT = 50 * 1024 * 1024 # 50MiB

def compress(_in, _out):
    print(f"Compressing {_in}")
    with open(_in, 'rb') as f_in:
        with gzip.open(_out, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
    os.remove(_in)
    print(f"Compression successful, output at {_out}")


if __name__ == '__main__':
    shutil.rmtree(PARTS_PREFIX)
    os.mkdir(PARTS_PREFIX)
    compress(TARGET_IMAGE, TARGET_GZIP)

    all_images = os.listdir(IMAGES_PREFIX)
    all_images = [f"{IMAGES_PREFIX}/{x}" for x in all_images if ".img" in x]
    print(f"Compressing {all_images} as seperate gzips")
    for image in all_images:
        compress(image, f"{image}.gz")
    
    current_index = 0
    with open(TARGET_GZIP, 'rb') as fp:
        vendor_img = fp.read(GITHUB_LIMIT)
        while len(vendor_img) > 0:
            print(f"Read {len(vendor_img)} bytes")
            
            fixed_width_adjust = '{0:03}'.format(current_index)
            file_path = f"{PARTS_PREFIX}{TARGET_GZIP}.{fixed_width_adjust}"
            
            print(f"Writing to {file_path}")
            # Write out
            with open(file_path, 'wb') as wp:
                wp.write(vendor_img)
            
            current_index = current_index + 1
            vendor_img = fp.read(GITHUB_LIMIT)
    
    os.remove(TARGET_GZIP)
