
# images tags (metadata)

# tag (metadata) − keyword or term assigned to a piece of information such as a file
# metadata standards:
## EXIF − exchangeable image file format
## IPTC − information interchange model (part of International Press Telecommunications Council, being replaced with XPM)
## XPM − extensible metadata platform (part of Adobe, the newest standard)
## the tag names between metadata standards overlap a lot, e.g. most of them contain the "City" tag
## list-type tags can contain many values
## keywords can be stored in "IPTC:Keywords" and "XMP:Subject" list-type tags

## exiftool

+ exiftool reads and writes metadata in a variety of file types, but doesn't alter the images

+ get info on tag names:

	```bash
	man Image::ExifTool::TagNames
	```

+ print tag names and values contained in a file:

	```bash
	exiftool -s image.jpg
	```

+ list tag names, including duplicates and unknowns, matching a specific pattern, together with their values:

	```bash
	exiftool -a -u -s image.jpg | grep -i date
	```

	or:

	```bash
	exiftool -a -u -s "-*date*" image.jpg
	```

	note that arguments containing wildcards must be quoted to prevent shell globbing

+ display the value of the `Orientation` tag:

	```bash
	exiftool -Orientation image.jpg
	```

+ display the `Orientation` tag's numerical value:

	```bash
	exiftool -n -Orientation image.jpg
	```

+ set the `Orientation` tag to `6` (right-top) preserving file modification time:

	```bash
	exiftool -P -n -Orientation=6 image.jpg
	```

### setting and shifting time and date tags

+ set the `DateTimeOriginal`, `CreateDate` and `ModifyDate` tags to the current time:

	```bash
	exiftool -AllDates=now image.jpg
	```

	`AllDates` is a shortcut for the three date tags

+ subtract one year from the date tags recursively for files created on or later than 2019-01-01 in a current directory:

	```bash
	exiftool -r -AllDates-="1:0:0 0" -if '$CreateDate ge "2019:01:01"' .
	```

+ add a keyword `My Family` to the current list of keywords in the IPTC group (IPTC is preferred by exiftool):

	```bash
	exiftool -iptc:Keywords+="My Family" image.jpg
	```

	or:

	```bash
	exiftool -Keywords+="My Family" image.jpg
	```

+ add a keyword `My Family` to the current list of keywords in the XPM group (`Subject` tag is only present in the XPM group):

	```bash
	exiftool -xmp:Subject+="My Family" image.jpg
	```

	or:

	```bash
	exiftool -Subject+="My Family" image.jpg
	```

+ delete a tag:

	```bash
	exiftool -DateTime= image.jpg
	```

+ erase all meta information from the `dst.jpg` file, then copy tags from the `src.jpg` file:

	```bash
	exiftool -All= -tagsFromFile src.jpg dst.jpg
	```

+ copy specific tag values from the `src.jpg` file:

	```bash
	exiftool -m -tagsFromFile src.jpg "-*date*" dst.jpg
	```

+ copy all but specific tag values from the `src.jpg` file:

	```bash
	exiftool -m -tagsFromFile src.jpg "--*date*" dst.jpg
	```

+ if there are duplicate tag names, e.g. `DateTime`, duplicate instances can be removed by:

	```bash
	exiftool -DateTime= image.jpg
	```

	and then the tag value may be copied from another tag, e.g. from the `CreateDate` tag:

	```bash
	exiftool "-DateTime<CreateDate" image.jpg
	```

+ if there are problems deleting some tags, try deleting all XMP tags not writable by exiftool:

	```bash
	exiftool -xmp:All= -tagsFromFile @@ "-All:All<xmp:All" image.jpg
	```

	+ `-tagsfromfile @@` refers to the `image.jpg` file

	+ if it doesn't help, change `-xmp:All=` into `-All=`

+ list specified meta information recursively for all files in a current directory in a tabular form:

	```bash
	exiftool -r -T -directory -filename -createdate -aperture -shutterspeed -iso .
	```

+ list specified meta information recursively for all files in a current directory using a formatted output:

	```bash
	exiftool -r -p '$directory/$filename $createdate $filecreatedate' -d "%Y-%m-%d %H:%M:%S" -q -q -f .
	```

	note that single, not double, quotes must be used with `-p` option, otherwise shell will expand `$directory` etc., in most cases to null strings, and you'll get rubbish results

+ move all files in `dir` into a directory hierarchy based on year, month and day of `DateTimeOriginal` tag:

	```bash
	exiftool "-Directory<DateTimeOriginal" -d %Y/%m/%d dir
	```
--------------------------------------------------------------------------------

# autorotate pictures based on the EXIF data:
jhead -ft -autorot ./*.jpg
