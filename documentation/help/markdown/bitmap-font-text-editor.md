---
title: How to use the Feathers BitmapFontTextEditor component  
author: Josh Tynjala

---
# How to use the Feathers `BitmapFontTextEditor` component

The [`BitmapFontTextEditor`](../api-reference/feathers/controls/text/BitmapFontTextEditor.html) class renders text using [bitmap fonts](http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts). This text editor is fully integrated with the Starling display list, which means that nothing appears as an overlay when the text editor is focused.

<aside class="warn">`BitmapFontTextEditor` is intended for use in desktop applications only, and it does not provide support for software keyboards on mobile devices.</aside>

<aside class="info">`BitmapFontTextEditor` is one of many different [text editors](text-editors.html) supported by the Feathers [`TextInput`](text-input.html) component. Since no method of editing text is considered definitively better than the others, Feathers allows you to choose the best text editor for your project's requirements. See [Introduction to Feathers text editors](text-editors.html) for complete details about all of the text editing options supported by Feathers.</aside>

## Advantages and disadvantages

Due to limitations in the Adobe AIR runtime, this text editor cannot be used on mobile. Adobe AIR does not offer an API for displaying the soft keyboard on iOS when the text editor receives focus. This text editor should only be used in desktop apps.

Bitmap fonts separate each character into sub-textures inside an atlas. These sub-textures are displayed as images placed next to each other to form words and paragraphs. If the text has a particularly stylized appearance, such as gradients and outlines, bitmap fonts provide the best performance because the styles can be calculated at design time rather than runtime.

While the English language has only 26 letters in the alphabet (in addition to any punctuation and other supporting characters that you might need), some languages require many hundreds of characters. A texture that contains all of those characters may be impossible to use with bitmap fonts because it hits texture memory limits imposed by the Flash runtime or the GPU. In these situations, you may have no choice but to use device fonts.

Bitmap fonts may be scaled, but because they use bitmaps, only scaling down is recommended. Even then, you may lose out on text hinting that would make vector fonts more readable at smaller sizes. It's common to include separate font sizes as separate textures for bitmap fonts to achieve the best looking results, and that can require a lot of memory.

`BitmapFontTextEditor` does not support multiple font styles. A `BitmapFontTextEditor` must use a single bitmap font to render its entire text.

### How to customize font styles

To use bitmap fonts with `TextInput`, create an instance of the [`BitmapFontTextEditor`](../api-reference/feathers/controls/text/BitmapFontTextEditor.html) class.

``` code
input.textEditorFactory = function():ITextEditor
{
	var textEditor:BitmapFontTextEditor = new BitmapFontTextEditor();
	textEditor.styleProvider = null;
	return textEditor;
};
```

<aside class="info">You may need to remove the text editor's style provider in the factory before changing font styles to avoid conflicts with the default styles set by a theme. That's why the `styleProvider` property is set to `null` in the code above.</aside>

Font styles may be customized by passing a [`BitmapFontTextFormat`](../api-reference/feathers/text/BitmapFontTextFormat.html) instance to the [`textFormat`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html#textFormat) property.

``` code
var format:BitmapFontTextFormat = new BitmapFontTextFormat( "FontName" );
```

Pass the font to display to the `BitmapFontTextFormat` constructor. It may be a `String` that matches the name of a font registered with [`TextField.registerBitmapFont()`](http://doc.starling-framework.org/core/starling/text/TextField.html#registerBitmapFont()), as in the example above. To use an unregistered bitmap font, we may pass in a [`starling.text.BitmapFont`](http://doc.starling-framework.org/core/starling/text/BitmapFont.html) instance instead.

The tint of the text can be customized with the [`color`](../api-reference/feathers/text/BitmapFontTextFormat.html#color) property:

``` code
format.color = 0xc4c4c4;
```

The RGB values of the tint color are multiplied with the RGB values of each of the font texture's pixels, similar to [`starling.display.BlendMode.MULTIPLY`](http://doc.starling-framework.org/current/starling/display/BlendMode.html#MULTIPLY).

<aside class="info">To support the maximum range of colors, the bitmap font should be exported with completely white pixels.</aside>

The alignment of the text can be customized with the [`align`](../api-reference/feathers/text/BitmapFontTextFormat.html#align) property:

``` code
format.align = TextFormatAlign.CENTER;
```

Bitmap fonts have one primary font size. They may be scaled, but scaled bitmap fonts may not render as nicely as scaled vector fonts. However, if needed, we can use the [`size`](../api-reference/feathers/text/BitmapFontTextFormat.html#size) property:

``` code
format.size = 18;
```

In most cases, it's not necessary to set the `size` property. The primary font size will be detected automatically.

`BitmapFontTextEditor` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`BitmapFontTextEditor` API reference](../api-reference/feathers/controls/text/BitmapFontTextEditor.html).

### How to change font styles when a parent component has multiple states

[`TextInput`](text-input.html) has multiple states, and it's possible to pass a different `BitmapFontTextFormat` to the `BitmapFontTextEditor` for each state. When the parent component's state changes, the font styles of the text editor will update automatically.

For instance, we can provide a different font style for the focused state of a `TextInput` by calling [`setTextFormatForState()`](../api-reference/feathers/controls/text/BitmapFontTextEditor.html#setTextFormatForState()):

```code
var defaultFormat:BitmapFontTextFormat = new BitmapFontTextFormat( "FontName", 20, 0xc4c4c4 );
textEditor.textFormat = defaultFormat;

var focusedFormat:BitmapFontTextFormat = new BitmapFontTextFormat( "FontName", 20, 0x343434 );
textEditor.setTextFormatForState( TextInput.STATE_FOCUSED, focusedFormat );
```

We didn't provide separate font styles for other states, like `TextInput.STATE_DISABLED`. When the `TextInput` is in one of these states, the `BitmapFontTextEditor` will fall back to using the value we passed to the `textFormat` property.

## Related Links

-   [`feathers.controls.text.BitmapFontTextEditor` API Documentation](../api-reference/feathers/controls/text/BitmapFontTextEditor.html)

-   [Introduction to Feathers text editors](text-editors.html)