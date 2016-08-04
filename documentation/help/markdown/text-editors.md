---
title: Introduction to Feathers text editors  
author: Josh Tynjala

---
# Introduction to Feathers text editors

The Adobe Flash runtimes provide more than one way to edit text, and there are multiple different approaches to rendering text on the GPU. None of these approaches are ultimately better than the others. To allow you to choose the method that works best in your app, Feathers provides APIs that allow you to choose the appropriate *text editor* for the [`TextInput`](text-input.html) component based on your project's requirements.

Different text editors may be more appropriate for some situations than others. You should keep a number of factors in mind when choosing a text editor, including (but not necessarily limited to) the following:

-   whether the app is running on mobile or desktop

-   whether you need to use embedded fonts or not

-   the language of the text that needs to be displayed

These factors may impact things like performance and memory usage, depending on which text editor that you choose. Additionally, some text editors are better suited to mobile or desktop, and they may not work well on other platforms. What works for one app may be very inappropriate for another.

Feathers provides four different text editors. We'll learn the capabilities of each, along with their advantages and disadvantages. These text editors are listed below:

-   [`StageTextTextEditor`](stage-text-text-editor.html) uses [`flash.text.StageText`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html) to natively support entering text on all platforms, but especially on mobile. When the `TextInput` has focus, the `StageText` is displayed above Starling. Without focus, the `TextField` is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU.

-   [`TextFieldTextEditor`](text-field-text-editor.html) uses [`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) to natively support entering text on all platforms. When the `TextInput` has focus, it is added to the classic display list above Starling. Without focus, the `TextField` is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU.

-   [`TextBlockTextEditor`](text-block-text-editor.html) uses [Flash Text Engine](http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html) to render text in software and the result is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU. This text editor is not compatible with mobile apps.

-   [`BitmapFontTextEditor`](bitmap-font-text-editor.html) uses [bitmap fonts](http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts) to display characters as separate textured quads. This text editor is not compatible with mobile apps.

Each text renderer has different capabilities, so be sure to study each one in detail to choose the best one for your project.

## The default text editor factory

In many cases, most of the `TextInput` components in your app will use the same type of text editor. To keep from repeating yourself by passing the same factory (a function that creates the text editor) to each `TextInput` separately, you can specify a global *default text editor factory* to tell all `TextInput` components in your app how to create a new text editor. Then, if some of your `TextInput` components need a different text editor, you can pass them a separate factory that will override the default one.

If you don't replace it, the default text editor factory returns a [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html). `StageTextTextEditor` provides the best native experience on mobile devices, and it generally works well on desktop too. However, when using a [theme](themes.html), you should check which text editor the theme sets as the default. Themes will often embed a custom font, or they may have special font rendering requirements that require a different text editor. It is completely up to the theme which text editor it wants to use by default with `TextInput`.

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

You can even customize advanced font properties in the factory before returning the text editor:

``` code
input.textEditorFactory = function():ITextEditor
{
    var textEditor:TextFieldTextEditor = new TextFieldTextEditor();
    textEditor.antiAliasType = AntiAliasType.NORMAL;
    textEditor.gridFitType = GridFitType.SUBPIXEL;
    return textEditor;
}
```

<aside class="warn">Be careful, if you're using a theme. When changing any styles in `textEditorFactory`, you may need to set the `styleProvider` property of the text editor to `null`. The theme applies styles after the factory returns, and there is a chance that the theme could replace those styles.</aside>

## Custom Text Editors

If you'd like to use a different approach to rendering text, you may implement the [`ITextEditor`](../api-reference/feathers/core/ITextEditor.html) interface. This interface provides a simple API for communicating with the `TextInput` component.

Unless your custom editor is capable of drawing directly to the GPU, chances are that you will need to implement some form of texture snapshots, similar to the `StageTextTextEditor` or `TextFieldTextEditor`. Since Feathers is open source, feel free to look through the source code for one of these text editor classes for inspiration.

Please note that unless you find a way to take advantage of `StageText` or `TextField` in your custom text editor, you will not be able to access the native soft keyboard on mobile. Without the soft keyboard, the text editor may be limited to desktop, unless you can provide an alternate keyboard.

## Multiline Text Editors

On mobile, `StageTextTextEditor` can be used to edit text with multiple word-wrapped lines. The underlying `StageText` instance will provide its own scrolling capabilities. Simply set its [`multiline`](../api-reference/feathers/controls/text/StageTextTextEditor.html#multiline) property to `true`.

For desktop apps, the [`TextArea`](text-area.html) component may be used. It will work on mobile, in a pinch, but it only recommended for desktop. `TextArea` supports special text editors with an extended the [`ITextEditorViewPort`](../api-reference/feathers/controls/text/ITextEditorViewPort.html) interface. Currently, Feathers provides one text editor for `TextArea`:

-   [`TextFieldTextEditorViewPort`](../api-reference/feathers/controls/text/TextFieldTextEditorViewPort.html) is similar to `TextFieldTextEditor`. It renders text using a [`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html). This is the default text editor used by `TextArea`.

## Related Links

-   [How to use the Feathers `StageTextTextEditor` component](stage-text-text-editor.html)

-   [How to use the Feathers `TextFieldTextEditor` component](text-field-text-editor.html)

-   [How to use the Feathers `TextBlockTextEditor` component](text-block-text-editor.html)

-   [How to use the Feathers `BitmapFontTextEditor` component](bitmap-font-text-editor.html)

-   [How to use the Feathers `TextInput` component](text-input.html)

-   [How to use the Feathers `TextArea` component](text-area.html)

-   [`ITextEditor` API Documentation](../api-reference/feathers/core/ITextEditor.html)

-   [`ITextEditorViewPort` API Documentation](../api-reference/feathers/controls/text/ITextEditorViewPort.html)

-   [Introduction to Feathers Text Renderers](text-renderers.html)