
# time and date operations

+ print a current date in a standard format:

	```bash
	date -I
	```

+ print date and time relative to a current date:

	```bash
	date -d "last Fri"
	date -d "3 days ago"
	date -d "3 hours ago"
	date -d "now + 4 days"
	date -d "today + 4 days"
	```

+ print the date in a standard format a specific amount of time into the future:

	```bash
	date -I -d "2 months 13 days"
	```
