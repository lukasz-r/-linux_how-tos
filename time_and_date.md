
\define{time_and_date}{time and date}
# \time_and_date operations

\define{time_and_date_NTP}{__NTP (Network Time Protocol)__<a name="time_and_date_NTP"></a>}
\define{time_and_date_NTP_linked}{[NTP](#time_and_date_NTP)}

\makedef{time_and_date_stratum}{stratum}{stratum}

## setting \time_and_date over \time_and_date_NTP_linked

\time_and_date_NTP

: a networking protocol for clock synchronization between computers

\time_and_date_stratum

: a layer

## printing \time_and_date

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

+ convert date from `01.06.2018` into `2018-06-01`:

	```bash
	dateconv -i "%d.%m.%Y" -f "%Y-%m-%d" 01.06.2018
	```
