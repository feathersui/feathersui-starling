---
title: How to use the Feathers TextInput component  
author: Josh Tynjala

---
# How to use the Feathers `TextInput` component

The `TextInput` class supports the editing of text. It displays a background skin and uses a [text editor](text-editors.html) to allow the user to modify the text.

## The Basics

First, let's create a `TextInput` control, give it some text to display, and add it to the display list:

``` code
var input:TextInput = new TextInput();
input.text = "Hello World";
this.addChild( input );
```

### Prompt

A prompt or hint may be displayed to describe the purpose of the text input when the text input does not have focus or when it contains no text.

``` code
input.prompt = "Password";
```

Simply set the `prompt` property to any String to display it inside the text input.

The prompt is a standard [text renderer](text-renderers.html), and it may be customized with the `promptFactory` property:

``` code
input.promptFactory = function():ITextRenderer
{
    var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
 
    // customize properties and styleshere
    textRenderer.textFormat = new BitmapFontTextFormat( bitmapFont );
 
    return textRenderer;
}
```

If you aren't using a theme, you can customize the prompt's text format in the factory. Alternatively, you can use the `promptProperties` object to customize properties:

``` code
input.promptProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
```

Using a custom factory is better for performance and it will allow you to use code hinting in your IDE, if available.

### Focus and Selection

You may programmatically set focus to the text input:

``` code
input.setFocus();
```

You can select part of the text too:

``` code
input.selectRange(0, input.text.length);
```

If you simply want to set the position of the cursor, you can omit the second argument to `selectRange()`:

``` code
input.selectRange(0);
```

### Events

Text inputs provide a number of useful events. One of the most common requirements is knowing, in real time, when the value of the `text` property has changed:

``` code
input.addEventListener( Event.CHANGE, input_changeHandler );
```

You might also want to know when the user presses `Keyboard.ENTER`:

``` code
input.addEventListener( FeathersEventType.ENTER, input_enterHandler );
```

Finally, you might also want to know when the text input receives and loses focus:

``` code
input.addEventListener( FeathersEventType.FOCUS_IN, input_focusInHandler );
input.addEventListener( FeathersEventType.FOCUS_OUT, input_focusOutHandler );
```

### Customizing Behavior

Several properties for customizing any text input's behavior have been added in 1.1. Most of these properties were previously available through `textEditorProperties`, but now they are available as first-class properties.

The `displayAsPassword` property may be enabled to mask a text input's text:

``` code
input.displayAsPassword = true;
```

Set the `isEditable` property to false to make the text uneditable, without giving the text input a disabled appearance:

``` code
input.isEditable = false;
```

To limit the number of characters that may be entered, use the `maxChars` property:

``` code
input.maxChars = 16;
```

The `restrict` property limits the set of characters that can be entered into the text input. It works like the `restrict` property on `flash.text.TextField`.

``` code
input.restrict = "0-9";
```

In the example above, we restrict to numeric values only.

## Skinning a `TextInput`

A text input provides a number of properties to customize its appearance. For full details about what skin and style properties are available, see the [`TextInput` API reference](../api-reference/feathers/controls/TextInput.html). We'll look at a few of the most common properties below.

### Font Styles

The font styles of a text input may be changed through the [text editor](text-editors.html). Each text editor displays fonts differently and has different properties, so the way to make changes to the font styles depends on each text editor.

The default text editor is `StageTextTextEditor`. The editor uses `flash.text.StageText` to provide an input field from the native operating system. Many of the font styles available to `StageText` (such as `fontFamily`, `fontSize`, and `color` among many others) are exposed through the `StageTextTextEditor` class. See the [API documentation](../api-reference/feathers/controls/text/StageTextTextEditor.html) for full details.

Another core text editor provided by Feathers is `TextFieldTextEditor`. This text editor places a `flash.text.TextField` with its `type` set to `TextFieldType.INPUT` on the native stage. This text editor accepts a `flash.text.TextFormat` object to pass to the `TextField` to style the text.

The text editor may be styled using the `textEditorFactory`:

``` code
input.textEditorFactory = function():ITextEditor
{
    var editor:StageTextTextEditor = new StageTextTextEditor();
    editor.fontFamily = "Helvetica";
    editor.fontSize = 12;
    editor.color = 0x333333;
    return editor;
}
```

You may also pass properties to the text editor through `textEditorProperties`:

``` code
input.textEditorProperties.fontFamily = "Helvetica";
input.textEditorProperties.fontSize = 12;
input.textEditorProperties.color = 0x333333;
```

Using the `textEditorProperties` hash is a bit slower, so if the font styles do not change, you should always use the `textEditorFactory`. The `textEditorProperties` is best for when the font styles change after the editor is initially created.

### Background and Layout

In addition to changing font styles on the text editor, you can change the text input's background skin and padding. Text input has three separate background skins, but two of them are optional.

``` code
input.backgroundSkin = new Scale9Image( backgroundSkinTextures );
input.backgroundDisabledSkin = new Scale9Image( disabledBackgroundSkinTextures );
input.backgroundFocusedSkin = new Scale9Image( focusedBackgroundSkinTextures );
```

The default background skin is displayed when the text input doesn't have focus and is enabled. The disabled background skin is displayed when the text input is not enabled, but if you don't provide a disabled background skin, the default background skin will be used. Similarly, the focused background skin is displayed when the text input has focus. Again, text input will fall back to the default background skin if there is no focused background skin.

You can change the padding values on each side:

``` code
input.paddingTop = 10;
input.paddingRight = 10;
input.paddingBottom = 10;
input.paddingLeft = 10;
```

The dimensions of the text editor will be affected by the padding to show more of the background skin around the edges. This can allow you to reveal a border.

The `typicalText` property may be used to help the text input calculate larger ideal dimensions:

``` code
input.typicalText = "The quick brown fox jumps over the lazy dog";
```

By default, the text input uses only its background skin for measurement. `typicalText` is useful when there is a maximum width based on the font size. For instance, the `NumericStepper` component uses this property to provide the text input with its maximum value.

### Targeting a `TextInput` in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( TextInput ).defaultStyleFunction = setTextInputStyles;
```

If you want to customize a specific text input to look different than the default, you may use a custom style name to call a different function:

``` code
input.styleNameList.add( "custom-text-input" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( TextInput )
    .setFunctionForStyleName( "custom-text-input", setCustomTextInputStyles );
```

Trying to change the text input's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the text input was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the text input's properties directly.

## Related Links

-   [`feathers.controls.TextInput` API Documentation](../api-reference/feathers/controls/TextInput.html)

-   [How to Use the Feathers `TextArea` Component](text-area.html)

-   [Introduction to Feathers Text Editors](text-editors.html)

For more tutorials, return to the [Feathers Documentation](index.html).


