---
title: How to use the Feathers TextBlockTextRenderer component  
author: Josh Tynjala

---
# How to use the Feathers `TextBlockTextRenderer` component

The [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) class displays text using [Flash Text Engine](http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html), a software-based vector font renderer with many advanced features. Text may be rendered with either device fonts (the fonts installed on a user's operating system) or embedded fonts (in TTF or OTF formats). A [`flash.text.engine.TextBlock`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html) is drawn to `BitmapData` and converted to a Starling `Texture` to display as a snapshot within the Starling display list.

<aside class="info">`TextBlockTextRenderer` is one of many different [text renderers](text-renderers.html) supported by Feathers. Since no method of rendering text on the GPU is considered definitively better than the others, Feathers allows you to choose the best text renderer for your project's requirements. See [Introduction to Feathers text renderers](text-renderers.html) for complete details about all of the text rendering options supported by Feathers.</aside>

## Advantages and disadvantages

Flash Text Engine may render text using device fonts, which are the fonts installed on the user's operating system. For some languages with many glyphs and ligatures, device fonts may be the only option when embedded fonts would require too much memory.

Similarly, since embedded vector fonts often require less memory than embedded bitmap fonts, you may still be able to use embedded vector fonts when bitmap fonts would require too much memory.

Flash Text Engine has the best support for right-to-left languages and bi-directional text, which `flash.text.TextField` may not render correctly.

Changing vector-based text on the GPU is slower than with bitmap fonts because the text needs to be redrawn to `BitmapData` and then it needs to be uploaded to a texture on the GPU. However, once this texture is on the GPU, performance will be very smooth as long as the text doesn't change again. For text that changes often, the texture upload time may become a bottleneck.

Because each passage of vector text needs to be drawn to `BitmapData`, each separate renderer requires its own separate texture on the GPU. This results in more [state changes](http://wiki.starling-framework.org/manual/performance_optimization#minimize_state_changes) and [draw calls](faq/draw-calls.html), which can create more work for the GPU, and it might hurt performance if you have many different instances of `TextBlockTextRenderer` on screen at the same time.

Flash Text Engine may render a bit slower than `flash.text.TextField` sometimes. In general, this performance difference is negligible, and the more advanced capabilities of FTE are often more compelling than a minor risk of reduced performance.

`TextBlockTextRenderer` optionally supports rich text, but it needs to be constructed manually adding multiple [`TextElement`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextElement.html) objects, each with different [`ElementFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html) values, to a [`GroupElement`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/GroupElement.html) object. You may pass the `GroupElement` to the text renderer's [`content`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#content) property. `TextBlockTextRenderer` does not support the simple subset of HTML that `TextFieldTextRenderer` can display.

### Advanced font styles

<aside class="info">In general, you should customize font styles on the parent component of a text renderer using a [`starling.text.TextFormat`](http://doc.starling-framework.org/current/starling/text/TextFormat.html) object. For example, to customize the font styles on a [`Button`](button.html) component, you'd set the button's [`fontStyles`](../api-reference/feathers/controls/Button.html#fontStyles) property.

``` actionscript
button.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );
```

However, `starling.text.TextFormat` object does not always expose every unique font styling feature that a text renderer supports. The next section demostrates how to set advanced font styles that may not be exposed through this class.</aside>

To render text with Flash Text Engine, create a [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) in the appropriate factory exposed by the parent component. In the following example, we'll use the [`labelFactory`](../api-reference/feathers/controls/Button.html#labelFactory) of a [`Button`](button.html) component:

``` actionscript
var button:Button = new Button();
button.label = "Click Me";
button.labelFactory = function():ITextRenderer
{
	var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
	textRenderer.styleProvider = null;
	
	//set advanced font styles here
	
	return textRenderer;
};
```

<aside class="info">You may need to remove the text renderer's style provider in the factory before changing font styles to avoid conflicts with the default styles set by a theme. That's why the `styleProvider` property is set to `null` in the code above.</aside>

Advanced font styles may be customized by passing a [`flash.text.engine.ElementFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html) instance to the text renderer's [`elementFormat`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#elementFormat) property:

``` actionscript
var font:FontDescription = new FontDescription(
	"Source Sans Pro", FontWeight.BOLD, FontPosture.ITALIC );
textRenderer.elementFormat = new ElementFormat( font, 16, 0xcccccc );
```

The first parameter to the `ElementFormat` constructor is a [`FontDescription`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontDescription.html) object. This class is provided by Flash Text Engine to handle font lookup, including name, weight (whether it is bold or normal), posture (whether it is italicized or not), and whether the font is embedded or installed on the device.

The `ElementFormat` allows you to customize font size, color, alpha, and more.

``` actionscript
var format:ElementFormat = new ElementFormat( fontDescription );
format.fontSize = 20;
format.color = 0xc4c4c4;
format.alpha = 0.5;
```

Text alignment is not included in the `FontDescription` or the `ElementFormat`. Instead, we can set the [`textAlign`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#textAlign) property directly on the text renderer:

``` actionscript
textRenderer.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;
```

The `TextBlockTextRenderer` defines [`TEXT_ALIGN_CENTER`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#TEXT_ALIGN_CENTER) and some other constants that the `textAlign` property accepts.

`TextBlockTextRenderer` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`TextBlockTextRenderer` API reference](../api-reference/feathers/controls/text/TextBlockTextRenderer.html).

### How to change advanced font styles when a parent component has multiple states

Some components, like [`Button`](button.html) and [`TextInput`](text-input.html), have multiple states. It's possible to pass more than one `ElementFormat` to the `TextBlockTextRenderer` so that the font styles change when the parent component's state changes.

For instance, we can provide a different font style for the down state of a `Button` by calling [`setElementFormatForState()`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#setElementFormatForState())

``` actionscript
var defaultFormat:ElementFormat = new ElementFormat( fontDescription, 20, 0xc4c4c4 );
textRenderer.elementFormat = defaultFormat;

var downFormat:ElementFormat = new ElementFormat( fontDescription, 20, 0x343434 );
textRenderer.setElementFormatForState( ButtonState.DOWN, downFormat );
```

We didn't provide separate font styles for other states, like `ButtonState.HOVER` or `ButtonState.DISABLED`. When the `Button` is in one of these states, the `TextBlockTextRenderer` will fall back to using the value we passed to the `elementFormat` property.

### Using embedded fonts

To embed a TTF or OTF font for `TextBlockTextRenderer`, use `[Embed]` metadata, like this:

``` actionscript
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

To use an embedded font with `TextBlockTextRenderer`, pass the name specified in the `fontFamily` parameter of the `[Embed]` metadata to the `FontDescription` object.

``` actionscript
var font:FontDescription = new FontDescription(
	"My Font Name", FontWeight.BOLD, FontPosture.ITALIC );
font.fontLookup = FontLookup.EMBEDDED_CFF;
```

Be sure to set the [`fontLookup`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontDescription.html#fontLookup) property to [`FontLookup.EMBEDDED_CFF`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontLookup.html#EMBEDDED_CFF).

<aside class="info">When setting font styles with `starling.text.TextFormat`, the `TextBlockTextRenderer` automatically detects if a font is embedded. The `fontLookup` property only needs to be set when using `flash.text.engine.ElementFormat` to provide advanced font styles.</aside>

## Related Links

-   [`feathers.controls.text.TextBlockTextRenderer` API Documentation](../api-reference/feathers/controls/text/TextBlockTextRenderer.html)

-   [Introduction to Feathers text renderers](text-renderers.html)