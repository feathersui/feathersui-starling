---
title: Introduction to Feathers text editors  
author: Josh Tynjala

---
# Introduction to Feathers text editors

The Flash runtimes provide more than one way to edit text, and there are multiple different approaches to rendering text on the GPU. None of these approaches are ultimately better than the others. To allow you to choose the method that works best in your app, Feathers provides APIs that allow you to choose the appropriate *text editor* for the [`TextInput`](text-input.html) component based on your project's requirements.

Different text editors may be more appropriate for some situations than others. You should keep a number of factors in mind when choosing a text editor, including (but not necessarily limited to) the following:

-   whether the app is running on mobile or desktop

-   whether you need to use embedded fonts or not

-   the language of the text that needs to be displayed

These factors may impact things like performance and memory usage, depending on which text editor that you choose. Additionally, some text editors are better suited to mobile or desktop, and they may not work well on other platforms. What works for one app may be very inappropriate for another.

Feathers provides four different text editors. We'll learn the capabilities of each, along with their advantages and disadvantages. These text editors are listed below:

-   [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html) uses [`flash.text.StageText`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html) to natively support entering text on all platforms, but especially on mobile. When the `TextInput` has focus, the `StageText` is displayed above Starling. Without focus, the `TextField` is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU.

-   [`TextFieldTextEditor`](../api-reference/feathers/controls/text/TextFieldTextEditor.html) uses [`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) to natively support entering text on all platforms. When the `TextInput` has focus, it is added to the classic display list above Starling. Without focus, the `TextField` is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU.

-   [`TextBlockTextEditor`](../api-reference/feathers/controls/text/TextBlockTextEditor.html) uses [`flash.text.engine.TextBlock`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html) to render text in software and the result is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU. This text editor is not compatible with mobile apps.

-   [`BitmapFontTextEditor`](../api-reference/feathers/controls/text/BitmapFontTextEditor.html) uses [bitmap fonts](http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts) to display characters as separate textured quads. This text editor is not compatible with mobile apps.

We'll look at the capabilities of each text editor in more detail a bit later, and we'll even consider options for creating custom text editors.

## The default text editor factory

In many cases, most of the `TextInput` components in your app will use the same type of text editor. To keep from repeating yourself by passing the same factory (a function that creates the text editor) to each `TextInput` separately, you can specify a global *default text editor factory* to tell all `TextInput` components in your app how to create a new text editor. Then, if some of your `TextInput` components need a different text editor, you can pass them a separate factory that will override the default one.

If you don't replace it, the default text editor factory returns a [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html). However, when using a [theme](themes.html), you should check which text editor is selected as the default. Themes may be targeted at desktop, where there are better alternatives to `StageText`, or they may have special font requirements that require a different text editor. It is completely up to the theme which text editor it wants to use by default with `TextInput`.

When an individual component doesn't have a custom text editor factory specified, it calls the function [`FeathersControl.defaultTextEditorFactory()`](../api-reference/feathers/core/FeathersControl.html#defaultTextEditorFactory()). This is a static variable that references a `Function`, and it can be changed to a different function, as needed. The default implementation of this function looks like this:

``` code
function():ITextEditor
{
    return new StageTextTextEditor();
}
```

If you would prefer to use a different text editor as the default in your app, you can easily change the variable to point to a different function. For instance, you might want to add this code to your application to use the [`TextFieldTextEditor`](../api-reference/feathers/controls/text/TextFieldTextEditor.html) instead:

``` code
FeathersControl.defaultTextEditorFactory = function():ITextEditor
{
    return new TextFieldTextEditor();
};
```

## Using a different text editor on an individual `TextInput`

You can tell a specific `TextInput` not to use the default text editor. For instance, you can pass in a custom [`textEditorFactory`](../api-reference/feathers/controls/TextInput.html#textEditorFactory) that will be used to create the input's text editor:

``` code
input.textEditorFactory = function():ITextEditor
{
    return new TextFieldTextEditor();
}
```

You can even apply font styles and other properties in the factory before returning the text editor:

``` code
input.textEditorFactory = function():ITextEditor
{
    var editor:TextFieldTextEditor = new TextFieldTextEditor();
    editor.textFormat = new TextFormat( "Source Sans Pro", 16, 0xffffff );
    editor.embedFonts = true;
    return editor;
}
```

Be careful, if you're using a theme. The theme applies its styles after this function returns. That means that the theme may end up replacing any properties that you set in the factory. See [Extending Feathers Themes](extending-themes.html) for details about how to customize an existing theme's styles.

## `StageTextTextEditor`

The [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html) implementation uses [`flash.text.StageText`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html). `StageText` is optimized to use the native text input controls on mobile platforms. `StageText` supports native copy/paste, auto-correction, auto-completion, text selection, and other advanced text input capabilities.  When the `TextInput` has focus, the `StageText` instance is displayed on the classic display list above other Starling content. When focus is lost, the `StageText` is drawn to `BitmapData` and converted to a Starling `Texture` to display as a snapshot within the Starling display list. This allows the `TextInput` to be added to a scrolling container, and it will be properly clipped without the `StageText` appearing above the other Starling content.

`StageTextTextEditor` may use *device fonts* (the fonts installed on the user's operating system), but embedded fonts are not supported. If you need embedded fonts on mobile, you should use `TextFieldTextEditor` instead.

`StageTextTextEditor` may be used in desktop apps, but other text editors are recommended because they provide more features.

Features of `StageText` vary both in availability and behavior per platform. On some platforms, some properties may be completely ignored. Check the [`StageText` API documentation](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html) for full details.

### Using `StageTextTextEditor`

To edit text with `flash.text.StageText`, use the [`TextFieldTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html) class.

``` code
input.textEditorFactory = function():ITextEditor
{
	var editor:StageTextTextEditor = new StageTextTextEditor();
	return editor;
};
```

Font styles may be customized using properties like [`fontFamily`](../api-reference/feathers/controls/text/StageTextTextEditor.html#fontFamily), [`fontSize`](../api-reference/feathers/controls/text/StageTextTextEditor.html#fontSize), and [`color`](../api-reference/feathers/controls/text/StageTextTextEditor.html#color). Many of the property names defined by `StageText` are duplicated on `StageTextTextEditor`:

``` code
editor.fontFamily = "Arial";
editor.fontSize = 16;
editor.color = 0xcccccc;
```

`StageTextTextEditor` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`StageTextTextEditor` API reference](../api-reference/feathers/controls/text/StageTextTextEditor.html).

## `TextFieldTextEditor`

The [`TextFieldTextEditor`](../api-reference/feathers/controls/text/TextFieldTextEditor.html) implementation uses [`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) with its [`type`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#type) property set to [`TextFieldType.INPUT`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFieldType.html#INPUT). When the `TextInput` has focus, the `TextField` instance is displayed on the classic display list above other Starling content. When focus is lost, the `TextField` is drawn to `BitmapData` and converted to a Starling `Texture` to display as a snapshot within the Starling display list. This allows the `TextInput` to be added to a scrolling container, and it will be properly clipped without the `TextField` appearing above the other Starling content.

`TextFieldTextEditor` may use *device fonts* (the fonts installed on the user's operating system), and it supports embedded fonts in TTF or OTF formats. For some languages with many characters, device fonts may be the only option if the number of characters would require too much memory to embedding a custom font.

`TextFieldTextEditor` provides a slightly less native experience on mobile than `StageTextTextEditor`. More advanced capabilities like copy and paste may not be available on all platforms when using `TextFieldTextEditor`. `TextFieldTextEditor` is best suited for situations where `StageTextTextEditor` lacks capabilities that your app requires.

`TextField` offers limited support for some languages, including right-to-left and bidirectional languages, and `StageText` or Flash Text Engine is recommended for these languages.

### Using `TextFieldTextEditor`

To edit text with `flash.text.TextField`, use the [`TextFieldTextEditor`](../api-reference/feathers/controls/text/TextFieldTextEditor.html) class.

``` code
input.textEditorFactory = function():ITextEditor
{
	var editor:TextFieldTextEditor = new TextFieldTextEditor();
	return editor;
};
```

Font styles may be customized using the native [`flash.text.TextFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html) class. Many of the property names defined by `TextField` are duplicated on `TextFieldTextEditor`, including (but not limited to) [`textFormat`](../api-reference/feathers/controls/text/TextFieldTextEditor.html#textFormat) and [`embedFonts`](../api-reference/feathers/controls/text/TextFieldTextEditor.html#embedFonts):

``` code
editor.textFormat = new TextFormat( "Source Sans Pro", 16, 0xcccccc );
editor.embedFonts = true;
```

`TextFieldTextEditor` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`TextFieldTextEditor` API reference](../api-reference/feathers/controls/text/TextFieldTextEditor.html).

## `TextBlockTextEditor`

The [`TextBlockTextEditor`](../api-reference/feathers/controls/text/TextBlockTextEditor.html) implementation uses [`flash.text.engine.TextBlock`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html). This text editor is fully integrated with the Starling display list. The `TextBlock` is drawn to `BitmapData` and converted to a Starling `Texture` to display as a snapshot within the Starling display list. When the `TextInput` has focus, nothing is added to the classic display list above Starling.

<aside class="warn">`TextBlockTextEditor` is intended for use in desktop applications only, and it does not provide support for software keyboards on mobile devices.</aside>

`TextFieldBlockEditor` may use *device fonts* (the fonts installed on the user's operating system), and it supports embedded fonts in TTF or OTF formats. For some languages with many characters, device fonts may be the only option if the number of characters would require too much memory to embedding a custom font.

### Using `TextBlockTextEditor`

To edit text with `flash.text.engine.TextBlock`, use the [`TextBlockTextEditor`](../api-reference/feathers/controls/text/TextBlockTextEditor.html) class.

``` code
input.textEditorFactory = function():ITextEditor
{
	var editor:TextBlockTextEditor = new TextBlockTextEditor();
	return editor;
};
```

Many font styles may be customized using the native [`flash.text.engine.ElementFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html) class. Pass an instance of `ElementFormat` to the [`elementFormat`](../api-reference/feathers/controls/text/TextBlockTextEditor.html) property:

``` code
var fontDescription:FontDescription = new FontDescription( "Source Sans Pro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE );
editor.elementFormat = new ElementFormat( fontDescription, 16, 0xcccccc );
```

The first parameter to the `ElementFormat` constructor is a [`FontDescription`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontDescription.html) object. This class is provided by Flash Text Engine to handle font lookup, including name, weight, posture, whether the font is embedded or not, and how the font is rendered.

`TextBlockTextEditor` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`TextBlockTextEditor` API reference](../api-reference/feathers/controls/text/TextBlockTextEditor.html).

## `BitmapFontTextEditor`

The [`BitmapFontTextEditor`](../api-reference/feathers/controls/text/BitmapFontTextEditor.html) implementation uses [bitmap fonts](http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts). This text editor is fully integrated with the Starling display list. When the `TextInput` has focus, nothing is added to the classic display list above Starling.

<aside class="warn">`BitmapFontTextEditor` is intended for use in desktop applications only, and it does not provide support for software keyboards on mobile devices.</aside>

Bitmap fonts separate each character into sub-textures inside an atlas. These sub-textures are displayed as images placed next to each other to form words and paragraphs. If the text has a particularly stylized appearance, such as gradients and outlines, bitmap fonts provide the best performance because the styles can be calculated at design time rather than runtime.

While the English language has only 26 letters in the alphabet (in addition to any punctuation and other supporting characters that you might need), some languages require many hundreds of characters. A texture that contains all of those characters may be impossible to use with bitmap fonts because it hits texture memory limits imposed by the Flash runtime or the GPU. In these situations, you may have no choice but to use device fonts.

Bitmap fonts may be scaled, but because they use bitmaps, only scaling down is recommended. Even then, you may lose out on text hinting that would make vector fonts more readable at smaller sizes. It's common to include separate font sizes as separate textures for bitmap fonts to achieve the best looking results, and that can require a lot of memory.

`BitmapFontTextEditor` does not support multiple font styles. A `BitmapFontTextEditor` must use a single bitmap font to render its entire text.

### Using `BitmapFontTextEditor`

To edit text using bitmap fonts, use the [`BitmapFontTextEditor`](../api-reference/feathers/controls/text/BitmapFontTextEditor.html) class.

``` code
input.textEditorFactory = function():ITextEditor
{
	var editor:BitmapFontTextEditor = new BitmapFontTextEditor();
	return editor;
};
```

Font styles may be customized by passing a [`BitmapFontTextFormat`](../api-reference/feathers/text/BitmapFontTextFormat.html) instance to the [`textFormat`](../api-reference/feathers/controls/text/BitmapFontTextEditor.html#textFormat) property. The first parameter of the constructor accepts either name of a font registered with [`TextField.registerBitmapFont()`](http://doc.starling-framework.org/core/starling/text/TextField.html#registerBitmapFont()) or any [`BitmapFont`](http://doc.starling-framework.org/starling/text/core/BitmapFont.html) instance, regardless of whether it has been registered or not. Additionally, you may specify the font size (or set it to `NaN` to use the original font size) and the color of the text. The text color is applied using Starling's tinting capabilities.

``` code
editor.textFormat = new BitmapFontTextFormat( "FontName", 14, 0xcccccc );
```

`BitmapFontTextEditor` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`BitmapFontTextEditor` API reference](../api-reference/feathers/controls/text/BitmapFontTextEditor.html).

## Custom Text Editors

If you'd like to use a different approach to rendering text, you may implement the [`ITextEditor`](../api-reference/feathers/core/ITextEditor.html) interface. This interface provides a simple API for communicating with the `TextInput` component.

Unless your custom editor is capable of drawing directly to the GPU, chances are that you will need to implement some form of texture snapshots, similar to the `StageTextTextEditor` or `TextFieldTextEditor`. Since Feathers is open source, feel free to look through the source code for one of these text editor classes for inspiration.

Please note that unless you find a way to take advantage of `StageText` or `TextField` in your custom text editor, you will not be able to access the native soft keyboard on mobile. Without the soft keyboard, the text editor may be limited to desktop, unless you can provide an alternate keyboard.

## Multiline Text Editors

The [`TextArea`](text-area.html) component introduced in Feathers 1.1 allows you edit multiline text in desktop apps. It supports text editors with an extended the [`ITextEditorViewPort`](../api-reference/feathers/controls/text/ITextEditorViewPort.html) interface. Currently, the only supported text editor for `TextArea` is [`TextFieldTextEditorViewPort`](../api-reference/feathers/controls/text/TextFieldTextEditorViewPort.html). Similar to `TextFieldTextEditor`, it uses a [`flash.display.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html).

On mobile, you generally should not use `TextArea`. It is designed specifically for desktop, and it may not behave as expected on mobile. Instead, use the [`TextInput`](text-input.html) component with a [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html). Set its [`multiline`](../api-reference/feathers/controls/text/StageTextTextEditor.html#multiline) property to `true`. The underlying `StageText` will provide its own native scroll bar.

## Related Links

-   [`ITextEditor` API Documentation](../api-reference/feathers/core/text/ITextEditor.html)

-   [`StageTextTextEditor` API Documentation](../api-reference/feathers/controls/text/StageTextTextEditor.html)

-   [`TextFieldTextEditor` API Documentation](../api-reference/feathers/controls/text/TextFieldTextEditor.html)

-   [`BitmapFontTextEditor` API Documentation](../api-reference/feathers/controls/text/BitmapFontTextEditor.html)

-   [`TextBlockTextEditor` API Documentation](../api-reference/feathers/controls/text/TextBlockTextEditor.html)

-   [`TextFieldTextEditorViewPort` API Documentation](../api-reference/feathers/controls/text/TextFieldTextEditorViewPort.html)

-   [How to use the Feathers `TextInput` component](text-input.html)

-   [How to use the Feathers `TextArea` component](text-area.html)

-   [Introduction to Feathers Text Renderers](text-renderers.html)