---
title: How to use the Feathers StageTextTextEditor component  
author: Josh Tynjala

---
# How to use the Feathers `StageTextTextEditor` component

The [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html) class renders text using [`flash.text.StageText`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html). `StageText` is optimized to use the native text input controls on mobile platforms like iOS and Android. `StageText` supports native copy/paste, auto-correction, auto-completion, text selection, and other advanced text input capabilities.

When the `TextInput` has focus, the `StageText` instance is displayed on a layer above other Starling content. When focus is lost, the `StageText` is drawn to `BitmapData` and converted to a Starling `Texture` to display as a snapshot within the Starling display list. This allows the `TextInput` to be added to a scrolling container, and it will be properly clipped without the `StageText` appearing above the other Starling content when it is not in focus.

<aside class="info">`StageTextTextEditor` is one of many different [text editors](text-editors.html) supported by the Feathers [`TextInput`](text-input.html) component. Since no method of editing text is considered definitively better than the others, Feathers allows you to choose the best text editor for your project's requirements. See [Introduction to Feathers text editors](text-editors.html) for complete details about all of the text editing options supported by Feathers.</aside>

## Advantages and disadvantages

`StageTextTextEditor` may use *device fonts*, which are the fonts installed on the user's operating system. For some languages with many glyphs and ligatures, device fonts may be the only option when embedded fonts would require too much memory.

Embedded fonts are not officially supported. If you need embedded fonts on mobile, you should use `TextFieldTextEditor` instead.

`StageTextTextEditor` may be used in desktop apps, but other text editors are recommended because they provide more features and customizability.

Features of `StageText` vary both in availability and behavior per platform. On some platforms, some properties may be completely ignored. Check the [`StageText` API documentation](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html) for full details.

This text editor displays a `StageText` on a layer above Starling when the `TextInput` has focus. When focused, this `StageText` will not appear below other Starling display objects that might otherwise cover up the `TextInput` when it is not focused. Generally, this situation does not happen frequently.

Because each passage of vector text needs to be drawn to `BitmapData`, each separate renderer requires its own separate texture on the GPU. This results in more [state changes](http://wiki.starling-framework.org/manual/performance_optimization#minimize_state_changes) and [draw calls](faq/draw-calls.html), which can create more work for the GPU, and it might hurt performance if you have many different instances of `StageTextTextEditor` on screen at the same time.

### Advanced font styles

<aside class="info">In general, you should customize font styles on the parent component of a text editor using a [`starling.text.TextFormat`](http://doc.starling-framework.org/current/starling/text/TextFormat.html) object. For example, to customize the font styles on a [`TextInput`](text-input.html) component, you'd set the input's [`fontStyles`](../api-reference/feathers/controls/TextInput.html#fontStyles) property.

``` code
input.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );
```

However, `starling.text.TextFormat` object does not always expose the every font styling feature that a text editor supports. The next section demostrates how to set advanced font styles that may not be exposed through this class.</aside>

To use `flash.text.StageText` with `TextInput`, create a [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html) in the appropriate factory exposed by the parent component. In the following example, we'll use the [`textEditorFactory`](../api-reference/feathers/controls/TextInput.html#textEditorFactory) of a [`TextInput`](text-input.html) component:

``` code
var input:TextInput = new TextInput();
input.textEditorFactory = function():ITextEditor
{
	var textEditor:StageTextTextEditor = new StageTextTextEditor();
	textEditor.styleProvider = null;

	//set advanced font styles here

	return textEditor;
};
```

<aside class="info">You may need to remove the text editor's style provider in the factory before changing font styles to avoid conflicts with the default styles set by a theme. That's why the `styleProvider` property is set to `null` in the code above.</aside>

Advanced font styles may be customized using the text editor's properties like [`fontFamily`](../api-reference/feathers/controls/text/StageTextTextEditor.html#fontFamily), [`fontSize`](../api-reference/feathers/controls/text/StageTextTextEditor.html#fontSize), and [`color`](../api-reference/feathers/controls/text/StageTextTextEditor.html#color). Many of the property names defined by `StageText` are duplicated on `StageTextTextEditor`:

``` code
textEditor.fontFamily = "Arial";
textEditor.fontSize = 16;
textEditor.color = 0xcccccc;
```

`StageTextTextEditor` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`StageTextTextEditor` API reference](../api-reference/feathers/controls/text/StageTextTextEditor.html).

## Related Links

-   [`feathers.controls.text.StageTextTextEditor` API Documentation](../api-reference/feathers/controls/text/StageTextTextEditor.html)

-   [Introduction to Feathers text editors](text-editors.html)