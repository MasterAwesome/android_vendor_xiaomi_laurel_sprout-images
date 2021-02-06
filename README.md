# android_vendor_xiaomi_laurel_sprout-images

## update vendor images
```bash
$ ./obtain_vendor.sh "<fastbootrompath>/images"
```

## upstream contribution rules
The source is hosted on GitHub this means you can't just upload your images directly. Run the python script to generate gzip files.

```bash
$ ./split.sh
$ git add <insert_files_changed>
$ git commit -s 
```

