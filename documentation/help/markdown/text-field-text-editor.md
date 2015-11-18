---
title: How to use the Feathers TextFieldTextEditor component  
author: Josh Tynjala

---
# How to use the Feathers `TextFieldTextEditor` component

The [`TextFieldTextEditor`](../api-reference/feathers/controls/text/TextFieldTextEditor.html) class renders text using the classic [flash.text.TextField](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html), a software-based vector font renderer. Text may be rendered with either device fonts (the fonts installed on a user's operating system) or embedded fonts (in TTF or OTF formats). The [`type`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#type) property of the `TextField` is set to [`TextFieldType.INPUT`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFieldType.html#INPUT).

When the `TextInput` has focus, the `TextField` instance is displayed on the classic display list above other Starling content. When focus is lost, the `TextField` is drawn to `BitmapData` and converted to a Starling `Texture` to display as a snapshot within the Starling display list. This snapshot allows the `TextInput` to be added to a scrolling container, and it will be properly clipped without the `TextField` appearing above the other Starling content when it is not in focus.

<aside class="info">`TextFieldTextEditor` is one of many different [text editors](text-editors.html) supported by the Feathers [`TextInput`](text-input.html) component. Since no method of editing text is considered definitively better than the others, Feathers allows you to choose the best text editor for your project's requirements. See [Introduction to Feathers text editors](text-editors.html) for complete details about all of the text editing options supported by Feathers.</aside>

## Advantages and disadvantages

The classic Flash `TextField` may render text using device fonts, which are the fonts installed on the user's operating system. For some languages with many glyphs and ligatures, device fonts may be the only option when embedded fonts would require too much memory.

This text editor displays the classic Flash `TextField` on the display list above Starling when the `TextInput` has focus. When focused, this `TextField` will not appear below other Starling display objects that might cover up the `TextInput` when it is not focused. Generally, this situation does not happen frequently.

Because each passage of vector text needs to be drawn to `BitmapData`, each separate renderer requires its own separate texture on the GPU. This results in more [state changes](http://wiki.starling-framework.org/manual/performance_optimization#minimize_state_changes) and [draw calls](faq/draw-calls.html), which can create more work for the GPU, and it might hurt performance if you have many different instances of `TextFieldTextEditor` on screen at the same time.

`flash.text.TextField` can sometimes render a bit faster than Flash Text Engine. However, this performance difference is generally negligible.

`TextFieldTextEditor` provides a slightly less native experience on mobile than `StageTextTextEditor`. More advanced capabilities like copy and paste may not be available on all platforms when using `TextFieldTextEditor`. `TextFieldTextEditor` is best suited for situations where `StageTextTextEditor` lacks other capabilities that your app requires, such as using embedded fonts.

`TextField` offers limited support right-to-left languages and bi-directional text, and `StageText` or Flash Text Engine is recommended for these languages.

### How to customize font styles

To use the classic Flash `TextField` with `TextInput`, create an instance of the [`TextFieldTextEditor`](../api-reference/feathers/controls/text/TextFieldTextEditor.html) class.

``` code
input.textEditorFactory = function():ITextEditor
{
	var textEditor:TextFieldTextEditor = new TextFieldTextEditor();
	textEditor.styleProvider = null;
	return textEditor;
};
```

<aside class="info">You may need to remove the text editor's style provider in the factory before changing font styles to avoid conflicts with the default styles set by a theme. That's why the `styleProvider` property is set to `null` in the code above.</aside>

Font styles may be customized using the native [`flash.text.TextFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html) class. Pass an instance of `TextFormat` to the [`textFormat`](../api-reference/feathers/controls/text/TextFieldTextEditor.html#textFormat) property:

``` code
textEditor.textFormat = new TextFormat( "Source Sans Pro", 16, 0xcccccc );
```

The `TextFormat` allows you to customize font size, color, alignment, and more.

``` code
var format:TextFormat = new TextFormat( "Helvetica" );
format.size = 20;
format.color = 0xc4c4c4;
format.align = TextFormatAlign.CENTER;
```

`TextFieldTextEditor` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`TextFieldTextEditor` API reference](../api-reference/feathers/controls/text/TextFieldTextEditor.html).

### How to change font styles when a parent component has multiple states

[`TextInput`](text-input.html) has multiple states, and it's possible to pass a different `TextFormat` to the `TextFieldTextEditor` for each state. When the parent component's state changes, the font styles of the text editor will update automatically.

For instance, we can provide a different font style for the focused state of a `TextInput` by calling [`setTextFormatForState()`](../api-reference/feathers/controls/text/TextFieldTextEditor.html#setTextFormatForState()):

```code
var defaultFormat:TextFormat = new TextFormat( "Helvetica", 20, 0xc4c4c4 );
textEditor.textFormat = defaultFormat;

var focusedFormat:TextFormat = new TextFormat( "Helvetica", 20, 0x343434 );
textEditor.setTextFormatForState( TextInput.STATE_FOCUSED, focusedFormat );
```

We didn't provide separate font styles for other states, like `TextInput.STATE_DISABLED`. When the `TextInput` is in one of these states, the `TextFieldTextEditor` will fall back to using the value we passed to the `textFormat` property.

### Using embedded fonts

To embed a TTF or OTF font for `TextFieldTextEditor`, use `[Embed]` metadata, like this:

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

To use an embedded font with `TextFieldTextEditor`, pass the name specified in the `fontFamily` parameter of the `[Embed]` metadata to the `TextFormat` object.

``` code
textEditor.textFormat = new TextFormat( "My Font Name", 16, 0xcccccc );
textEditor.embedFonts = true;
```

Be sure to set the [`embedFonts`](../api-reference/feathers/controls/text/TextFieldTextEditor.html#embedFonts) property to `true`.

## Related Links

-   [`feathers.controls.text.TextFieldTextEditor` API Documentation](../api-reference/feathers/controls/text/TextFieldTextEditor.html)

-   [Introduction to Feathers text editors](text-editors.html)