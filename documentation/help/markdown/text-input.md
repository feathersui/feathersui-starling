---
title: How to use the Feathers TextInput component  
author: Josh Tynjala

---
# How to use the Feathers `TextInput` component

The [`TextInput`](../api-reference/feathers/controls/TextInput.html) class supports the editing of text. It displays a background skin and uses a [text editor](text-editors.html) to allow the user to modify the text.

## The Basics

First, let's create a `TextInput` control and add it to the display list:

``` code
var input:TextInput = new TextInput();
this.addChild( input );
```

### Changing text programmatically

Text may be changed programatically by setting the [`text`](../api-reference/feathers/controls/TextInput.html#text) property:

``` code
input.text = "Hello World";
```

### Prompt

A prompt or hint may be displayed to describe the purpose of the text input when the text input does not contain any text.

``` code
input.prompt = "Password";
```

Simply set the [`prompt`](../api-reference/feathers/controls/TextInput.html#prompt) property to any `String` to display it inside the text input.

The prompt is a standard [text renderer](text-renderers.html), and it may be customized with the [`promptFactory`](../api-reference/feathers/controls/TextInput.html#promptFactory) property:

``` code
input.promptFactory = function():ITextRenderer
{
    var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
 
    // customize properties and styleshere
    textRenderer.textFormat = new BitmapFontTextFormat( bitmapFont );
 
    return textRenderer;
}
```

If you aren't using a theme, you can customize the prompt's text format in the factory. Alternatively, you can use the [`promptProperties`](../api-reference/feathers/controls/TextInput.html#promptProperties) object to customize properties:

``` code
input.promptProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
```

Using a custom factory is better for performance and it will allow you to use code hinting in your IDE, if available.

### Focus and Selection

You may programmatically set focus to the text input by calling [`setFocus()`](../api-reference/feathers/controls/TextInput.html#setFocus()):

``` code
input.setFocus();
```

You can select part of the text too:

``` code
input.selectRange(0, input.text.length);
```

If you simply want to set the position of the cursor, you can omit the second argument to [`selectRange()`](../api-reference/feathers/controls/TextInput.html#selectRange()):

``` code
input.selectRange(0);
```

### Events

Text inputs provide a number of useful events. One of the most common requirements is knowing, in real time, when the value of the [`text`](../api-reference/feathers/controls/TextInput.html#text) property has changed:

``` code
input.addEventListener( Event.CHANGE, input_changeHandler );
```

We can listen for [`Event.CHANGE`](../api-reference/feathers/controls/TextArea.html#event:change).

We might also want to know when the user presses [`Keyboard.ENTER`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/ui/Keyboard.html#ENTER):

``` code
input.addEventListener( FeathersEventType.ENTER, input_enterHandler );
```

Simply listen for [`FeathersEventType.ENTER`](../api-reference/feathers/controls/TextInput.html#event:enter).

<aside class="warn">On some mobile platforms, the `FeathersEventType.ENTER` event may not always be dispatched by certain text editors. For complete details, please refer to the API reference for the specific text editor that you are using.</aside>

Finally, you might also want to know when the text input receives and loses focus:

``` code
input.addEventListener( FeathersEventType.FOCUS_IN, input_focusInHandler );
input.addEventListener( FeathersEventType.FOCUS_OUT, input_focusOutHandler );
```

The [`FeathersEventType.FOCUS_IN`](../api-reference/feathers/controls/TextInput.html#event:focusIn) and [`FeathersEventType.FOCUS_OUT`](../api-reference/feathers/controls/TextInput.html#event:focusOut) events are specially dispatched by the `TextInput`, even if the [focus manager](focus.html) is not enabled.

### Customizing Behavior

The [`displayAsPassword`](../api-reference/feathers/controls/TextInput.html#displayAsPassword) property may be enabled to mask a text input's text:

``` code
input.displayAsPassword = true;
```

Set the [`isEditable`](../api-reference/feathers/controls/TextInput.html#isEditable) property to false to make the text uneditable, without giving the text input a disabled appearance:

``` code
input.isEditable = false;
```

To limit the number of characters that may be entered, use the [`maxChars`](../api-reference/feathers/controls/TextInput.html#maxChars) property:

``` code
input.maxChars = 16;
```

The [`restrict`](../api-reference/feathers/controls/TextInput.html#restrict) property limits the set of characters that can be entered into the text input. It works like the `restrict` property on `flash.text.TextField`.

``` code
input.restrict = "0-9";
```

In the example above, we restrict to numeric values only.

## Skinning a `TextInput`

A text input provides a number of properties to customize its appearance. For full details about what skin and style properties are available, see the [`TextInput` API reference](../api-reference/feathers/controls/TextInput.html). We'll look at a few of the most common properties below.

### Font Styles


This section explains how to customize the font styles used by the [text editor](text-editors.html) sub-component. Feathers provides multiple text editors to choose from, and each one will have different properties that may be set to customize font styles and other capabilities. For more information about text editors, including which ones are available, please read [Introduction to Feathers Text Editors](text-editors.html).

The font styles of a text input may be changed through the . Each text editor displays fonts differently and has different properties, so the way to make changes to the font styles depends on each text editor.

<aside class="info">In the examples below, we'll be setting properties on a `StageTextTextEditor`. Other [text editors](text-editors.html) may have properties with different names. To determine which properties to use instead, please refer to the API reference for the specific text editor that you are using.</aside>

The text editor may be styled using the [`textEditorFactory`](../api-reference/feathers/controls/TextInput.html#textEditorFactory):

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

You may also pass properties to the text editor through [`textEditorProperties`](../api-reference/feathers/controls/TextInput.html#textEditorProperties):

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

The default [`backgroundSkin`](../api-reference/feathers/controls/TextInput.html#backgroundSkin) is displayed when the text input doesn't have focus and is enabled. The [`backgroundDisabledSkin`](../api-reference/feathers/controls/TextInput.html#backgroundDisabledSkin) is displayed when the text input is not enabled, but if you don't provide a disabled background skin, the default background skin will be used. Similarly, the [`backgroundFocusedSkin`](../api-reference/feathers/controls/TextInput.html#backgroundFocusedSkin) is displayed when the text input has focus. Again, text input will fall back to the default background skin if there is no focused background skin.

You can change the padding values on each side:

``` code
input.paddingTop = 10;
input.paddingRight = 10;
input.paddingBottom = 10;
input.paddingLeft = 10;
```

The dimensions of the text editor will be affected by the padding to show more of the background skin around the edges. This can allow you to reveal a border.

The [`typicalText`](../api-reference/feathers/controls/TextInput.html#typicalText) property may be used to help the text input calculate its dimensions based on the dimensions of a specific rendered string:

``` code
input.typicalText = "The quick brown fox jumps over the lazy dog";
```

By default, the text input uses only its background skin for measurement. `typicalText` is useful when there is a width or height that must be based on the font styles. For instance, the [`NumericStepper`](numeric-stepper.html) component uses this property to provide the text input with a string that represents the largest possible string it might display.

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


