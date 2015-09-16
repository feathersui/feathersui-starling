---
title: How to use the Feathers TextFieldTextRenderer component  
author: Josh Tynjala

---
# How to use the Feathers `TextFieldTextRenderer` component

The [`TextFieldTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) class renders text using the classic [flash.text.TextField](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html).

<aside class="info">`TextFieldTextRenderer` is one of many different [text renderers](text-renderers.html) supported by Feathers. Since no method of rendering text on the GPU is considered definitively better than the others, Feathers allows you to choose the best text renderer for your project's requirements. See [Introduction to Feathers text renderers](text-renderers.html) for complete details about all of the text rendering options supported by Feathers.</aside>

## Advantages and disadvantages

[`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) displays device fonts or embedded fonts using a software-based vector renderer. Feathers draws the rendered text to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html), and a texture is uploaded to the GPU. This text renderer may use device fonts (the fonts installed on the user's operating system), and it supports embedded fonts in both TTF or OTF formats.

Since embedded vector fonts require less memory than embedded bitmap fonts, you may be able to use embedded vector fonts for languages with too many characters or ligatures to be rendered with bitmap fonts. However, even when the embedded vector glyphs require too much memory, you can always fall back to using *device fonts* (the fonts installed on the user's operating system) to draw your text. For some languages, device fonts may be the only option.

Changing vector-based text on the GPU is slower than with bitmap fonts because the text needs to be redrawn to `BitmapData` and then it needs to be uploaded to a texture on the GPU. However, once this texture is on the GPU, performance will be very smooth as long as the text doesn't change again. For text that changes often, the texture upload time may become a bottleneck.

Because each passage of vector text needs to be drawn to `BitmapData`, each separate renderer requires its own separate texture on the GPU. This results in more [state changes](http://wiki.starling-framework.org/manual/performance_optimization#minimize_state_changes) and [draw calls](faq/draw-calls.html), which can create more work for the GPU, and it might hurt performance if you have many different instances of `TextFieldTextRenderer` on screen at the same time.

[`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) has some known issues and limitations:

-   `TextField` may render incorrectly when drawn to `BitmapData` immediately after its properties have been changed. As a workaround, `TextFieldTextRenderer` can wait one frame before drawing to `BitmapData` and uploading as a texture when the text or font styles are changed. Often, this delay will not be an issue, but it can be seen if watching closely.

-   `TextField` offers limited support for some languages, including right-to-left and bidirectional languages, and Flash Text Engine is recommended for these languages.

`TextFieldTextRenderer` supports [a limited subset of HTML](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText) courtesy of `flash.text.TextField`. This may be used to render richer text with multiple font styles.

### How to customize font styles

To render text with the classic Flash `TextField`, use the [`TextFieldTextRenderer`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html) class.

``` code
var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
textRenderer.text = "About binomial theorem I'm teeming with a lot o' news";
```

Font styles may be customized using the native [`flash.text.TextFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html) class. Many of the property names defined by `TextField` are duplicated on `TextFieldTextRenderer`, most importantly [`textFormat`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html#textFormat):

``` code
textRenderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0xcccccc );
```

The `TextFormat` allows you to customize font size, color, alignment, and a huge variety of more advanced options.

``` code
var format:ElementFormat = new ElementFormat( "Helvetica" );
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

To use an embedded font with `TextFieldTextRenderer`, pass the name specified in the `fontFamily` parameter of the `[Embed]` metadata to the the `TextFormat` object.

``` code
textRenderer.textFormat = new TextFormat( "My Font Name", 16, 0xcccccc );
textRenderer.embedFonts = true;
```

Be sure to set the [`embedFonts`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html#embedFonts) property to `true`.

## Related Links

-   [`feathers.controls.text.TextFieldTextRenderer` API Documentation](../api-reference/feathers/controls/text/TextFieldTextRenderer.html)

-   [Introduction to Feathers text renderers](text-renderers.html)