
# \Octave \Octave_anchor

## \getting_help

```bash
info octave
```

## \basic_operations

+ start \Octave_link \CLI_link:

	```bash
	octave-cli
	```

+ access physical constants:

	```bash
	sudo dnf install octave-miscellaneous
	octave-cli
	```

	```octave
	octave:1> pkg load miscellaneous
	octave:2> eps0 = physical_constant("electric constant")
	```
