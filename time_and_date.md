
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
## \remind

variables | function
----------|---------
`$T`{.bash} | `trigdate()`{.bash}
`$Ty`{.bash} | `year(trigdate())`{.bash}
`$U`{.bash} | `today()`{.bash}
`$Uy`{.bash} | `year(today())`{.bash}

: useful system variables

+ set a string variable:

	```bash
	SET title "\"Poirot\""
	REM 10 Jul 2017 ++2 MSG Watch [title] %a.
	REM 10 Aug 2017 ++2 MSG Watch [title] %a.
	```

+ define a string function with a string argument:

	```bash
	FSET taxes_msg(country) "Tax return in " + country + " due %a."
	REM 15 Apr +5 OMIT Sat Sun AFTER MSG [taxes_msg("the United States")]
	REM 1 May --1 +5 OMIT Sat Sun AFTER MSG [taxes_msg("Poland")]
	```

	\remind_lnk doesn't support \floating_point_number_lnk_pl, use \string_lnk_pl instead:

	```bash
	FSET invoice_info(number, price) "Invoice number " + number + ", price: $" + price + " due %a."
	REM 2019-10-15 +5 MSG [invoice_info("N221024913", "374.52")]
	```

# report the previous month in a reminder message:
REM 10 +4 MSG Tax for [mon($T - 30)] %a.

# the global omits influence the counting of "+" delta and "-" back forms
# no omits influence the counting of "++" delta and "--" back forms

# the following script:
-------------------------------------------------------
$HOME/test.rem
-------------------------------------------------------
OMIT 1 Jan MSG New Year
OMIT 24 Dec MSG Christmas Eve
OMIT 25 Dec MSG 1st day of Christmas
OMIT 26 Dec MSG 2nd day of Christmas
REM 25 MSG Backup
REM 3 +4 MSG Rent
REM 1 -7 MSG Meeting
# Jan 3rd - 4 days = Dec 30th
# Jan 1st - 7 days = Dec 25th
-------------------------------------------------------
# which can be tested with e.g.
remind test.rem 2015-12-22
# in December/January issues the reminder for:
## "Backup" on Dec 25th, since global omits influence the counting of the "+" delta and "-" back forms only, and there is none here, so it doesn't matter that Dec 25th is omitted (to actually omit it, use the "SKIP"/"BEFORE"/"AFTER" commands)
## "Rent" on Jan 3rd, with the advance warning starting already on Dec 29th (instead of Dec 30th), since on the way there is one omitted day (Jan 1st):
### Jan 3rd - 4 days (from "+4") - 1 day (from omits) = Dec 29th (not omitted, don't move further back)
## "Meeting" on Dec 22nd (instead of Dec 25th), since on the way there are three omitted days (Dec 25th, Dec 26th and Jan 1st):
### Jan 1st - 7 days (from "-7") - 3 days (from omits) = Dec 22th (not omitted, don't move further back)

# but the following script:
-------------------------------------------------------
(...)
REM 3 ++4 MSG Rent
REM 1 --7 +1 MSG Meeting
-------------------------------------------------------
# in December/January issues the reminder for:
## "Rent" on Jan 3rd, with the advance warning starting on Dec 30th
## "Meeting" on Dec 25th, with the advance warning starting already on Dec 23rd (instead of Dec 24th) since for "+1" delta there is one omitted day (Dec 24th):
### Dec 25th - 1 day (from "+1") - 1 day (from omits) = Dec 23rd (not omitted, don't move further back)

# but for the following script:
-------------------------------------------------------
(...)
REM 25 SKIP MSG Backup
REM 1 --7 +1 SKIP MSG Meeting
-------------------------------------------------------
# no reminder for "Backup" is issued because of "SKIP"
# in December no reminder is issued for neither "Backup" nor "Meeting", since the Dec 25th is excluded by the "SKIP" command
# if we use "BEFORE" instead of "SKIP", the reminders are issued on Dec 23rd, with the advance warning for "Meeting" starting on Dec 22nd
# if we use "AFTER" instead of "SKIP", the reminders are issued on Dec 27th, with the advance warning for "Meeting" starting already on Dec 23rd (instead of Dec 26th) since "+1" delta moves the advance warning past the omitted days:
## Dec 27th - 1 day (from "+1") =
	Dec 26th (omitted, move back) →
	Dec 25th (omitted, move back) →
	Dec 24th (omitted, move back) →
	Dec 23rd (not omitted, don't move further back)

# note that the following script:
-------------------------------------------------------
(...)
REM 1 -7 +1 SKIP Meeting
-------------------------------------------------------
# is not influenced at all by the "SKIP" command as the global omits influence "-7" back form and move the date back past the omitted days so that the "Meeting" reminder is issued on Dec 22nd, with the advance warning starting on Dec 21st
# thus
REM 1 -7 +1 Meeting
# yields the same results

# obviously, the "SKIP"/"BEFORE"/"AFTER" commands shouldn't be used with "-" back form only which always moves the trigger date past the omitted days, so they serve no purpose

# the following script:
-------------------------------------------------------
$HOME/.reminders
-------------------------------------------------------
OMIT 11 Nov MSG Independence Day
REM Wed +1 AFTER MSG Meeting
-------------------------------------------------------
# in November 2015 (Nov 11th = Wednesday) issues the "Meeting" reminder on Nov 12th, but with the advance warning starting already on Nov 10th (instead of Nov 11th) since for "+1" delta there is one omitted day (Nov 11th), and:
## Nov 12th - 1 day (from "+1") - 1 day (from omits) = Nov 10th

# the following script:
-------------------------------------------------------
$HOME/.reminders
-------------------------------------------------------
FSET omitJulAug(x) isomitted(x) || (monnum(x) == 7) || (monnum(x) == 8)
REM Fri +1 OMITFUNC omitJulAug SKIP AT 19:00 +45 MSG Lesson
-------------------------------------------------------
# in 2018 doesn't issue any "Lesson" advance warnings in July nor August, but in 2017 issues that each day in July and August since Sep 1st = Friday, so "+1" moves the warning past the omitted days, which results in triggering the warning every day in those months
# it's better to use the "++1" delta form:
REM Fri ++1 OMITFUNC omitJulAug SKIP AT 19:00 +45 MSG Lesson
# resulting in the advance warning issued on last day in August 2017

# an event occurring on first Saturday of a month with the exception of July and August, moved back one week for each omitted Saturday:
REM Sat 1 --7 SATISFY ($Tm != 7 && $Tm != 8)
REM [$T] ++1 OMIT Sun Mon Tue Wed Thu Fri BEFORE AT 18:00 MSG Meeting %a %3.

# use "SCANFROM" with floating events, so that the event is still seen after it occurred:
REM Mon 1 Sep SCANFROM [$U - 7] SATISFY 1
OMIT [$T]
REM Mon AFTER MSG Meeting
# the "Mon 1 Sep" reminder is triggered every first Monday in September (Labour Day), which can move over a range of 7 days
# without "SCANFROM", on first Tuesday in September remind wouldn't count the previous Monday as omitted (we assume there no other omits) as it by default scans starting with the current date, so "Meeting" wouldn't be at all triggered that Tuesday
# with "SCANFROM" the "Meeting" is properly triggered on first Tuesday in September, but as there might be other omits, it's safer to use 7 days with "SCANFROM"

# Easter date:
## easterdate($U) = the date of the next Easter Sunday on or after $U
## easterdate($Uy) = the date of Easter Sunday for the current year
# so the following
SET edate easterdate($U)
REM [edate + 1] MSG Easter Monday
# wouldn't trigger "Easter Monday" reminder at all, since on Easter Monday "easterdate($U)" already yields the date of the Easter Sunday in the following year, so use
SET edate easterdate($Uy)
REM [edate + 1] MSG Easter Monday.
# instead
