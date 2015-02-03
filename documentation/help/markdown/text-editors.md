---
title: Introduction to Feathers text editors  
author: Josh Tynjala

---
# Introduction to Feathers text editors

The Flash runtimes provide more than one way to edit text. In order to allow you to choose the method that works best in your app, Feathers provides the `ITextEditor` interface that is used by the [`TextInput`](text-input.html) component. Each method of entering text has its own advantages and disadvantages, and it's best to understand how each works.

By default, Feathers allows entering text using a text editor that wraps around [`flash.text.StageText`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html). Since Starling and Feathers are most often used on mobile, and because `StageText` is more optimized for mobile, it is often the best choice. We'll look at this default text editor in more detail in a moment.

When using a [theme](themes.html), you should check which text editor is the default. Themes may choose a text editor that is optimized for their specific needs. For instance, desktop themes often choose a text editor that uses `flash.text.TextField` instead of `flash.text.StageText` because a `StageText` is more suited for mobile, and it has some restrictions on desktop.

## Stage Text

The [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html) implementation uses [`flash.text.StageText`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html). `StageText` is optimized to use the native text input controls on mobile platforms. `StageText` supports native copy/paste, auto-correction, auto-completion, text selection, and other advanced text input capabilities.

One limitation of `StageText` is that it appears above all other displayed content in the Flash runtime. This includes both the native display list and the Starling display list. This means that `StageText` is always on top and nothing can be placed above it. In order to make `StageText` feel more integrated with Starling, this text editor takes a bitmap snapshot of the `StageText` instance and displays the snapshot when the editing field does not have focus. This allows you to easily put a `TextInput` or other control that uses this text editor into a scrolling container, and it will be properly clipped without the `StageText` appearing on top where it should be hidden.

`StageText` does not support embedded or bitmap fonts. It may only use fonts that are installed on the target mobile device.

Features of `StageText` vary both in availability and behavior per platform. On some platforms, some properties may be completely ignored. Check the [`StageText` API documentation](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html) for full details.

## Text Field

The [`TextFieldTextEditor`](../api-reference/feathers/controls/text/TextFieldTextEditor.html) implementation uses [`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) with its [`type`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#type) property set to [`TextFieldType.INPUT`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFieldType.html#INPUT). This is the classic way that the Flash runtimes allow the user to enter text. However, it provides a limited set of features on mobile, and advanced capabilities like copy and paste may not be available.

`TextField` always appears on the Flash runtime's native display list. This means that `TextField` is always above Starling content, and you cannot place Starling content above the `TextField`. In order to make this `TextField` feel more integrated with Starling, this text editor takes a bitmap snapshot of the `TextField` instance and displays the snapshot when the editing field does not have focus. This allows you to easily put a `TextInput` or other control that uses this text editor into a scrolling container, and it will be properly clipped without the `TextField` appearing on top where it should be hidden.

`TextField` supports embedded vector fonts and fonts installed on the target device. It does not support bitmap fonts.

## Custom Text Editors

By implementing the [`ITextEditor`](../api-reference/feathers/core/ITextEditor.html) interface, you can provide a custom text editor. For instance, you might want to create a text editor that supports bitmap fonts.

## Multiline Text Editors

The [`TextArea`](text-area.html) component introduced in 1.1 allows you edit multiline text in desktop apps. It supports text editors with an extended the [`ITextEditorViewPort`](../api-reference/feathers/controls/text/ITextEditorViewPort.html) interface. Currently, the only supported text editor for `TextArea` is [`TextFieldTextEditorViewPort`](../api-reference/feathers/controls/text/TextFieldTextEditorViewPort.html). Similar to `TextFieldTextEditor`, it uses a [`flash.display.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html).

On mobile, you generally should not use `TextArea`. It is designed specifically for desktop, and it may not behave as expected on mobile. Instead, use the [`TextInput`](text-input.html) component with a [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html). Set its [`multiline`](../api-reference/feathers/controls/text/StageTextTextEditor.html#multiline) property to `true`. The underlying `StageText` will provide its own native scroll bar.

## Related Links

-   [`ITextEditor` API Documentation](../api-reference/feathers/core/text/ITextEditor.html)

-   [`StageTextTextEditor` API Documentation](../api-reference/feathers/controls/text/StageTextTextEditor.html)

-   [`TextFieldTextEditor` API Documentation](../api-reference/feathers/controls/text/TextFieldTextEditor.html)

-   [`BitmapFontTextEditor` API Documentation](../api-reference/feathers/controls/text/BitmapFontTextEditor.html)

-   [`TextBlockTextEditor` API Documentation](../api-reference/feathers/controls/text/TextBlockTextEditor.html)

-   [`TextFieldTextEditorViewPort` API Documentation](../api-reference/feathers/controls/text/TextFieldTextEditorViewPort.html)

-   [How to use the Feathers TextInput component](text-input.html)

-   [How to use the Feathers TextArea component](text-area.html)

-   [Introduction to Feathers Text Renderers](text-renderers.html)