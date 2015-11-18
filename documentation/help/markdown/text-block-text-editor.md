---
title: How to use the Feathers TextBlockTextEditor component  
author: Josh Tynjala

---
# How to use the Feathers `TextBlockTextEditor` component

The [`TextBlockTextEditor`](../api-reference/feathers/controls/text/TextBlockTextEditor.html) class displays text using [Flash Text Engine](http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html), a software-based vector font renderer with many advanced features. Text may be rendered with either device fonts (the fonts installed on a user's operating system) or embedded fonts (in TTF or OTF formats). A [`flash.text.engine.TextBlock`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html) is drawn to `BitmapData` and converted to a Starling `Texture` to display as a snapshot within the Starling display list. This text editor is fully integrated with the Starling display list, which means that nothing appears as an overlay when the text editor is focused. The texture snapshot is updated in real time as the the user types.

<aside class="warn">`TextBlockTextEditor` is intended for use in desktop applications only, and it does not provide support for software keyboards on mobile devices.</aside>

<aside class="info">`TextBlockTextEditor` is one of many different [text editors](text-editors.html) supported by the Feathers [`TextInput`](text-input.html) component. Since no method of editing text is considered definitively better than the others, Feathers allows you to choose the best text editor for your project's requirements. See [Introduction to Feathers text editors](text-editors.html) for complete details about all of the text editing options supported by Feathers.</aside>

## Advantages and disadvantages

Flash Text Engine may render text using device fonts, which are the fonts installed on the user's operating system. For some languages with many glyphs and ligatures, device fonts may be the only option when embedded fonts would require too much memory.

Flash Text Engine has the best support for right-to-left languages and bi-directional text, which `flash.text.TextField` may not render correctly.

Due to limitations in the Adobe AIR runtime, this text editor cannot be used on mobile. Adobe AIR does not offer an API for displaying the soft keyboard on iOS when the text editor receives focus. This text editor should only be used in desktop apps.

Changing vector-based text on the GPU is slower than with bitmap fonts because the text needs to be redrawn to `BitmapData` and then it needs to be uploaded to a texture on the GPU. For text editors where the user is expected to enter longer passages of text, the texture upload time may become a bottleneck on slower devices.

Because each passage of vector text needs to be drawn to `BitmapData`, each separate renderer requires its own separate texture on the GPU. This results in more [state changes](http://wiki.starling-framework.org/manual/performance_optimization#minimize_state_changes) and [draw calls](faq/draw-calls.html), which can create more work for the GPU, and it might hurt performance if you have many different instances of `TextBlockTextEditor` on screen at the same time.

Flash Text Engine may render a bit slower than `flash.text.TextField` sometimes. In general, this performance difference is negligible, and the more advanced capabilities of FTE are often more compelling than a minor risk of reduced performance.

### How to customize font styles

To use Flash Text Engine with `TextInput`, create an instance of the [`TextBlockTextEditor`](../api-reference/feathers/controls/text/TextBlockTextEditor.html) class.

``` code
input.textEditorFactory = function():ITextEditor
{
	var textEditor:TextBlockTextEditor = new TextBlockTextEditor();
	textEditor.styleProvider = null;
	return textEditor;
};
```

<aside class="info">You may need to clear the text editor's style provider in the factory before changing font styles to avoid conflicts with the default styles set by a theme. That's why the `styleProvider` property is set to `null` in the code above.</aside>

Many font styles may be customized using the native [`flash.text.engine.ElementFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html) class. Pass an instance of `ElementFormat` to the [`elementFormat`](../api-reference/feathers/controls/text/TextBlockTextEditor.html#elementFormat) property:

``` code
var fontDescription:FontDescription = new FontDescription( "Source Sans Pro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE );
textEditor.elementFormat = new ElementFormat( fontDescription, 16, 0xcccccc );
```

The first parameter to the `ElementFormat` constructor is a [`FontDescription`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontDescription.html) object. This class is provided by Flash Text Engine to handle font lookup, including name, weight, posture, whether the font is embedded or not, and how the font is rendered.

The `ElementFormat` allows you to customize font size, color, alpha, and more.

``` code
var format:ElementFormat = new ElementFormat( fontDescription );
format.fontSize = 20;
format.color = 0xc4c4c4;
format.alpha = 0.5;
```

`TextBlockTextEditor` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`TextBlockTextEditor` API reference](../api-reference/feathers/controls/text/TextBlockTextEditor.html).

### How to change font styles when a parent component has multiple states

[`TextInput`](text-input.html) has multiple states, and it's possible to pass a different `ElementFormat` to the `TextBlockTextEditor` for each state. When the parent component's state changes, the font styles of the text editor will update automatically.

We can provide a different font style for the focused state of a `TextInput` by calling [`setElementFormatForState()`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#setElementFormatForState())

```code
var defaultFormat:ElementFormat = new ElementFormat( fontDescription, 20, 0xc4c4c4 );
textEditor.elementFormat = defaultFormat;

var focusedFormat:ElementFormat = new ElementFormat( fontDescription, 20, 0x343434 );
textEditor.setElementFormatForState( TextInput.STATE_FOCUSED, focusedFormat );
```

We didn't provide separate font styles for other states, like `TextInput.STATE_DISABLED`. When the `TextInput` is in one of these states, the `TextBlockTextEditor` will fall back to using the value we passed to the `elementFormat` property.

### Using embedded fonts

To embed a TTF or OTF font for `TextBlockTextEditor`, use `[Embed]` metadata, like this:

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

To use an embedded font with `TextBlockTextEditor`, pass the name specified in the `fontFamily` parameter of the `[Embed]` metadata to the `FontDescription` object.

``` code
var font:FontDescription = new FontDescription(
	"My Font Name", FontWeight.BOLD, FontPosture.ITALIC );
font.fontLookup = FontLookup.EMBEDDED_CFF;
```

Be sure to set the [`fontLookup`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontDescription.html#fontLookup) property to [`FontLookup.EMBEDDED_CFF`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontLookup.html#EMBEDDED_CFF).

## Related Links

-   [`feathers.controls.text.TextBlockTextEditor` API Documentation](../api-reference/feathers/controls/text/TextBlockTextEditor.html)

-   [Introduction to Feathers text editors](text-editors.html)