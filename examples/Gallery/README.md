# Gallery Example for Feathers

Displays a simple gallery of images from the [Flickr API](http://www.flickr.com/services/api/) using [Feathers](http://feathersui.com/). This example shows how to create lists with `SlideShowLayout` and `HorizontalLayout` with custom item renderers.

## Requirements

In addition to Starling Framework and Feathers, this example project requires the `MetalWorksMobileTheme` example theme. You can find the SWC file for this theme at the following location in the Feathers release build:

	themes/MetalWorksMobileTheme/swc/MetalWorksMobileTheme.swc

Additionally, you will need a [Flickr API key](https://www.flickr.com/services/apps/create/apply/). Pass in this API key by defining a conditional constant named `CONFIG::FLICKR_API_KEY`. If you are compiling with an IDE, conditional constants are usually defined somewhere in your project's settings. On the command line, you may use the `-define` compiler argument:

	-define+=CONFIG::FLICKR_API_KEY,'your flickr api key'