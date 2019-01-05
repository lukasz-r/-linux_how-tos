
# \raw_image_development_anchor

+ \raw_image_anchor file records image data captured by the camera's image sensor without any processing

+ things editable only with \raw_image_link\plural{s}:

	+ white balance (thus don't worry about a white balance setting when shooting raw)

	+ overexposed highlights which hid the details

## colour channels

+ a camera sensor determines the colour of light through sensor cells with either red, green or blue colour filters organized in a specific pattern: they make red, green and blue colour channels

	+ each colour channel senses how much light entered it, but only up to a specific maximum value, the \clipping_value_anchor

	+ if a channel reading is at the \clipping_value_link, the channel is ___clipped___

	+ if a channel reading is below the \clipping_value_link, the channel is ___valid___

	+ channel readings affecting the pixels:

		+ all three channel are:

			+ ___valid___: no correction needed, colour information correct

			+ ___clipped___: nothing can be done, they must represent a very bright highlight

		+ one or two channels are ___clipped___: no correct colour information, but a ___valid___ channel reading can be used to restore the correct tonal information

## an idiot's guide to \raw_image processing workflow with \digiKam

+ of course, first and foremost you need to enable \raw_image_link format in the camera before taking pictures

+ set the \key{Settings}→\key{Configure}→\key{Image Editor}→\key{RAW Behavior}→\key{Using the default settings, in 16 bit} option in \digiKam_link

+ after downloading the \raw_image_link\plural{s} to a \digiKam_link album, choose a \raw_image_link to edit, and open an \key{Image Editor}

+ use the following chain of tools:

	+ \key{Enhance}→\key{Lens} to fix a lens distortion, choosing the appropriate lens, but make sure the final results is without artifacts at the edges, otherwise don't apply the correction

	+ \key{Enhance}→\key{Local Contrast} to correct the underexposed areas

	+ \key{Color}→\key{Auto-Correction}, \key{Color}→\key{Hue/Saturation/Lightness} to apply tonal adjustments

	+ \key{Enhance}→\key{Noise Reduction}

	+ \key{Enhance}→\key{Sharpen}→\key{Refocus} (the most advanced sharpening method in \digiKam_link):

		+ \key{Circular Sharpness}: the default value of $1$ might not yield visible results, you can increase it, but increase the \key{Correlation} as well

		+ \key{Correlation}: use $0.5$ with the \key{Circular Sharpness} of $1$, for the higher vaules of the former, increase the latter to a value close to $1$, e.g. $0.95$, to reduce artifacts

	+ save the changes, e.g. as the `JPEG` image

	+ the original \raw_image_link disappears from the album, but is still available from the \key{Image Editor}, should the final result be unsatisfactory
