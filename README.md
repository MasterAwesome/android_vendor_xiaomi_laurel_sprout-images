# laurel_sprout prebuilt images

## update vendor images
```bash
$ ./obtain_vendor.sh "<fastbootrompath>/images"
```

## upstream contribution rules
The source is hosted on GitHub this means you can't just upload your images directly. Run the python script to generate gzip files.

```bash
$ python3 split.py
$ git add <insert_files_changed>
$ git commit -s 
```

