
# text file operations

+ sort a file and delete duplicate lines:
```bash
sort -u file.txt
```

+ print duplicate lines in a file:

	+ irrespective of the case:
	```bash
	sort file.txt | uniq -d
	```

	+ ignoring the case:
	```bash
	sort file.txt | uniq -id
	```
