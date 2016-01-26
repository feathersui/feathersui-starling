---
title: How to use the Feathers TextFieldTextRenderer component  
author: Josh Tynjala

---
# How to use the Feathers `TextFieldTextRenderer` component

The [`TextFieldTextRenderer`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html) class renders text using the classic [flash.text.TextField](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) a software-based vector font renderer. Text may be rendered with either device fonts (the fonts installed on a user's operating system) or embedded fonts (in TTF or OTF formats). The [`TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html) is drawn to `BitmapData` and converted to a Starling `Texture` to display as a snapshot within the Starling display list.

<aside class="info">`TextFieldTextRenderer` is one of many different [text renderers](text-renderers.html) supported by Feathers. Since no method of rendering text on the GPU is considered definitively better than the others, Feathers allows you to choose the best text renderer for your project's requirements. See [Introduction to Feathers text renderers](text-renderers.html) for complete details about all of the text rendering options supported by Feathers.</aside>

## Advantages and disadvantages

The classic Flash `TextField` may render text using device fonts, which are the fonts installed on the user's operating system. For some languages with many glyphs and ligatures, device fonts may be the only option when embedded fonts would require too much memory.

Similarly, since embedded vector fonts often require less memory than embedded bitmap fonts, you may still be able to use embedded vector fonts when bitmap fonts would require too much memory.

Changing vector-based text on the GPU is slower than with bitmap fonts because the text needs to be redrawn to `BitmapData` and then it needs to be uploaded to a texture on the GPU. However, once this texture is on the GPU, performance will be very smooth as long as the text doesn't change again. For text that changes often, the texture upload time may become a bottleneck.

Because each passage of vector text needs to be drawn to `BitmapData`, each separate renderer requires its own separate texture on the GPU. This results in more [state changes](http://wiki.starling-framework.org/manual/performance_optimization#minimize_state_changes) and [draw calls](faq/draw-calls.html), which can create more work for the GPU, and it might hurt performance if you have many different instances of `TextFieldTextRenderer` on screen at the same time.

`flash.text.TextField` can sometimes render a bit faster than Flash Text Engine. However, this performance difference is generally negligible.

[`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) has some known issues and limitations:

-   `TextField` may render incorrectly when drawn to `BitmapData` immediately after its properties have been changed. As a workaround, `TextFieldTextRenderer` can wait one frame before drawing to `BitmapData` and uploading as a texture when the text or font styles are changed. Often, this delay will not be an issue, but it can be seen if watching closely.

-   `TextField` offers limited support for some languages, including right-to-left languages and bi-directional text, and Flash Text Engine is recommended for these languages.

`TextFieldTextRenderer` supports [a limited subset of HTML](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText) courtesy of `flash.text.TextField`. This may be used to render richer text with multiple font styles.

### How to customize font styles

To render text with the classic Flash `TextField`, use the [`TextFieldTextRenderer`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html) class.

``` code
var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
textRenderer.text = "About binomial theorem I'm teeming with a lot o' news";
```

Font styles may be customized using the native [`flash.text.TextFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html) class. Pass an instance of `TextFormat` to the [`textFormat`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html#textFormat) property:

``` code
textRenderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0xcccccc );
```

The `TextFormat` allows you to customize font size, color, alignment, and more.

``` code
var format:TextFormat = new TextFormat( "Helvetica" );
format.size = 20;
format.color = 0xc4c4c4;
format.align = TextFormatAlign.CENTER;
```

To render the `text` property of the `TextFieldTextRenderer` using [a limited subset of HTML](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText), set the `isHTML` property to `true`:

``` code
textRenderer.text = "<span class='heading'>hello</span> world!";
textRenderer.isHTML = true;
```

`TextFieldTextRenderer` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`TextFieldTextRenderer` API reference](../api-reference/feathers/controls/text/TextFieldTextRenderer.html).

### How to change font styles when a parent component has multiple states

Some components, like [`Button`](button.html) and [`TextInput`](text-input.html), have multiple states. It's possible topass more than one `TextFormat` to the `TextFieldTextRenderer` so that the font styles change when the parent component's state changes.

For instance, we can provide a different font style for the down state of a `Button` by calling [`setTextFormatForState()`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html#setTextFormatForState()):

```code
var defaultFormat:TextFormat = new TextFormat( "Helvetica", 20, 0xc4c4c4 );
textRenderer.textFormat = defaultFormat;

var downFormat:TextFormat = new TextFormat( "Helvetica", 20, 0x343434 );
textRenderer.setTextFormatForState( ButtonState.DOWN, downFormat );
```

We didn't provide separate font styles for other states, like `ButtonState.HOVER` or `ButtonState.DISABLED`. When the `Button` is in one of these states, the `TextFieldTextRenderer` will fall back to using the value we passed to the `textFormat` property.

### Using embedded fonts

To embed a TTF or OTF font for `TextFieldTextRenderer`, use `[Embed]` metadata, like this:

``` code
[Embed(source="my-font.ttf",fontFamily="My Font Name",fontWeight="normal",fontStyle="normal",mimeType="application/x-font",embedAsCFF="false")]
private static const MY_FONT:Class;
```

Here are the parameters:

-   The `source` parameter is the path to the TTF or OTF font file.
-   `fontFamily` gives a name to the font. This name will be passed to the `TextFormat` object.
-   The `fontWeight` parameter controls which weight is embedded.
-   The `fontStyle` parameter controls whether the font is italic or not.
-   The `mimeType` parameter must be set to `application/x-font`.
-   The `embedAsCFF` parameter must be set to `false` to use a font with the classic Flash `TextField`.

To use an embedded font with `TextFieldTextRenderer`, pass the name specified in the `fontFamily` parameter of the `[Embed]` metadata to the `TextFormat` object.

``` code
textRenderer.textFormat = new TextFormat( "My Font Name", 16, 0xcccccc );
textRenderer.embedFonts = true;
```

Be sure to set the [`embedFonts`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html#embedFonts) property to `true`.

## Related Links

-   [`feathers.controls.text.TextFieldTextRenderer` API Documentation](../api-reference/feathers/controls/text/TextFieldTextRenderer.html)

-   [Introduction to Feathers text renderers](text-renderers.html)