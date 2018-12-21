
# \raw_image_development_anchor

+ \raw_image_anchor file records image data captured by the camera's image sensor without any processing

+ things editable only with \raw_image_link\plural{s}:

	+ white balance (thus don't worry about white balance setting when shooting raw)

	+ overexposed highlights which hid the details

+ a camera sensor determines the colour of light through sensor cells with either red, green or blue colour filters organized in a specific pattern: they make red, green and blue colour channels

	+ each channel senses how much light entered it, but only up to a specific maximum value, the \clipping_value_anchor

	+ if a channel reading is at the \clipping_value_link, the channel is ___clipped___

	+ if a channel reading is below the \clipping_value_link, the channel is ___valid___

	+ channel readings affecting the pixels:

		+ all channel readings are valid: no correction needed, colour information correct

		+ all three channels are clipped: nothing can be done, they must represent a very bright highlight

		+ one or two channels are clipped: no correct colour information, but a valid channel reading can be used to restore the correct tonal information

## an idiot's guide to \raw_image_link processing with \digiKam

+ of course, first and foremost you need to enable \raw_image_link format in the camera before taking pictures

+ after downloading the \raw_image_link\plural{s} to a \digiKam album, choose a \raw_image_link to edit, and open an \key{Image Editor}

+ use \key{Color}→\key{Auto-Correction}, \key{Enhance}→\key{Sharpen}, and \key{Enhance}→\key{Lens}, and save the changes

+ the original \raw_image_link disappears from the album, but is still available from the \key{Image Editor}
