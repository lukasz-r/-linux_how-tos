
\define{wget}{__wget__}
# \wget

\define{wget_URL_linked}{[URL](#wget_URL)}
__URL (uniform resource locator)__<a name="wget_URL"></a>

: a web address

+ download GIF files from the given website to a current directory:
```bash
wget -c -r -nd -A gif www.example.com
```

+ download \wget_URL_linked destinations listed in the `links.dat` file in the background:
```bash
wget -b --content-disposition -i links.dat
```

+ download image files, i.e. files in a wiki webpage (possibly for further processing):
```bash
wget -q --spider -r "$base_url/index.php?title=$gallery_title" -O "$links_file"
```

+ non-greedy search with sed
```bash
sed -n "s#.*src=\"\(/images\)\(/thumb\)\([^\"]*\)\".*#\1\3#p" links.html > test
sed -n "s#.*src=\"\(/images\)\(/thumb\)\([^\.png]*\)\.png.*#\1\3.png#p" links.html
```
