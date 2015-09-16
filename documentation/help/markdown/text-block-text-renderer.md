---
title: How to use the Feathers TextBlockTextRenderer component  
author: Josh Tynjala

---
# How to use the Feathers `TextBlockTextRenderer` component

The [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) class renders text using [Flash Text Engine](http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html).

<aside class="info">`TextBlockTextRenderer` is one of many different [text renderers](text-renderers.html) supported by Feathers. Since no method of rendering text on the GPU is considered definitively better than the others, Feathers allows you to choose the best text renderer for your project's requirements. See [Introduction to Feathers text renderers](text-renderers.html) for complete details about all of the text rendering options supported by Feathers.</aside>

## Advantages and disadvantages

[Flash Text Engine](http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html) displays device fonts or embedded fonts using a software-based vector renderer. Feathers draws the rendered text to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html), and a texture is uploaded to the GPU. This text renderer may use device fonts (the fonts installed on the user's operating system), and it also supports embedded fonts in both TTF or OTF formats.

Since embedded vector fonts require less memory than embedded bitmap fonts, you may be able to use embedded vector fonts for languages with too many characters or ligatures to be rendered with bitmap fonts. However, even when the embedded vector glyphs require too much memory, you can always fall back to using *device fonts* (the fonts installed on the user's operating system) to draw your text. For some languages, device fonts may be the only option.

Changing vector-based text on the GPU is slower than with bitmap fonts because the text needs to be redrawn to `BitmapData` and then it needs to be uploaded to a texture on the GPU. However, once this texture is on the GPU, performance will be very smooth as long as the text doesn't change again. For text that changes often, the texture upload time may become a bottleneck.

Because each passage of vector text needs to be drawn to `BitmapData`, each separate renderer requires its own separate texture on the GPU. This results in more [state changes](http://wiki.starling-framework.org/manual/performance_optimization#minimize_state_changes) and [draw calls](faq/draw-calls.html), which can create more work for the GPU, and it might hurt performance if you have many different instances of `TextBlockTextRenderer` on screen at the same time.

Flash Text Engine may render a bit slower than `flash.text.TextField` sometimes. In general, this performance difference is negligible, and the more advanced capabilities of FTE are often more compelling than a minor risk of reduced performance.

Flash Text Engine has the best support for right-to-left languages, which `flash.text.TextField` may not render correctly.

`TextBlockTextRenderer` optionally supports rich text, but it needs to be constructed manually adding multiple [`TextElement`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextElement.html) objects, each with different [`ElementFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html) values, to a [`GroupElement`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/GroupElement.html) object. You may pass the `GroupElement` to the text renderer's [`content`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#content) property. `TextBlockTextRenderer` does not support the simple subset of HTML that `TextFieldTextRenderer` can display.

### How to customize font styles

To render text with Flash Text Engine, use the [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) class.

``` code
var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
textRenderer.text = "I understand equations, both the simple and quadratical";
```

Font styles may be customized by passing a [`flash.text.engine.ElementFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html) instance to the [`elementFormat`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) property:

``` code
var font:FontDescription = new FontDescription(
	"Source Sans Pro", FontWeight.BOLD, FontPosture.ITALIC );
textRenderer.elementFormat = new ElementFormat( font, 16, 0xcccccc );
```

The first parameter to the `ElementFormat` constructor is a [`FontDescription`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontDescription.html) object. This class is provided by Flash Text Engine to handle font lookup, including name, weight (whether it is bold or normal), posture (whether it is italicized or not), and whether the font is embedded or installed on the device.

The `ElementFormat` allows you to customize font size, color, alpha, and a huge variety of more advanced options.

``` code
var format:ElementFormat = new ElementFormat( "Helvetica" );
format.size = 20;
format.color = 0xc4c4c4;
format.alpha = 0.5;
```

Text alignment is not included in the `FontDescription` or the `ElementFormat`. Instead, we can set the [`textAlign`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#textAlign) property:

``` code
textRenderer.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;
```

The `TextBlockTextRenderer` defines [`TEXT_ALIGN_CENTER`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#TEXT_ALIGN_CENTER) and some other constants that the `textAlign` property accepts.

`TextBlockTextRenderer` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`TextBlockTextRenderer` API reference](../api-reference/feathers/controls/text/TextBlockTextRenderer.html).

### Using embedded fonts

To embed a TTF or OTF font for `TextBlockTextRenderer`, use `[Embed]` metadata, like this:

``` code
[Embed(source="my-font.ttf",fontFamily="My Font Name",fontWeight="normal",fontStyle="normal",mimeType="application/x-font",embedAsCFF="true")]
private static const MY_FONT:Class;
```

Here are the parameters:

-   The `source` parameter is the path to the TTF or OTF font file.
-   `fontFamily` gives a name to the font. This name will be passed to the `FontDescription` object.
-   The `fontWeight` parameter controls which weight is embedded.
-   The `fontStyle` parameter controls whether the font is italic or not.
-   The `mimeType` parameter must be set to `application/x-font`.
-   The `embedAsCFF` parameter must be set to `true` to use a font with Flash Text Engine.

To use an embedded font with `TextBlockTextRenderer`, pass the name specified in the `fontFamily` parameter of the `[Embed]` metadata to the the `FontDescription` object.

``` code
var font:FontDescription = new FontDescription(
	"My Font Name", FontWeight.BOLD, FontPosture.ITALIC );
font.fontLookup = FontLookup.EMBEDDED_CFF;
```

Be sure to set the [`fontLookup`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontDescription.html#fontLookup) property to [`FontLookup.EMBEDDED_CFF`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontLookup.html#EMBEDDED_CFF).

## Related Links

-   [`feathers.controls.text.TextBlockTextRenderer` API Documentation](../api-reference/feathers/controls/text/TextBlockTextRenderer.html)

-   [Introduction to Feathers text renderers](text-renderers.html)