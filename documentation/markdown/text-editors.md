# Introduction to Feathers Text Editors

The Flash runtimes provide more than one way to edit text. In order to allow you to choose the method that works best in your app, Feathers provides the `ITextEditor` interface that is used by the [TextInput component](text-input.html). Each method of entering text has its own advantages and disadvantages, and it's best to understand how each works.

By default, Feathers allows entering text using a text editor that wraps around `flash.text.StageText`. Since Starling and Feathers are most often used on mobile, and because `StageText` is more optimized for mobile, it is often the best choice.

When using a [theme](themes.html), you should check which text editor is the default. Themes may choose a text editor that is optimized for their specific needs. For instance, desktop themes often choose a text editor that uses `flash.text.TextField` instead of `flash.text.StageText` because a `StageText` is more suited for mobile and has some restrictions on desktop.

## Stage Text

The `StageTextTextEditor` implementation uses `flash.text.StageText`. `StageText` is optimized to use the native text input controls on mobile platforms. `StageText` supports native copy/paste, auto-correction, auto-completion, text selection, and other advanced text input capabilities.

One limitation of `StageText` is that it appears above all other displayed content in the Flash runtime. This includes both the native display list and the Starling display list. This means that `StageText` is always on top and nothing can be placed above it. In order to make `StageText` feel more integrated with Starling, this text editor takes a bitmap snapshot of the `StageText` instance and displays the snapshot when the editing field does not have focus. This allows you to easily put a `TextInput` or other control that uses this text editor into a scrolling container, and it will be properly clipped without the `StageText` appearing on top where it should be hidden.

`StageText` does not support embedded or bitmap fonts. It may only use fonts that are installed on the target mobile device.

Features of `StageText` vary both in availability and behavior per platform. On some platforms, some properties may be completely ignored. Check the [StageText API documentation](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html) for full details.

## Text Field

The `TextFieldTextEditor` implementation uses `flash.text.TextField` with its `type` property set to `TextFieldType.INPUT`. This is the classic way that the Flash runtimes allow the user to enter text. However, it provides a limited set of features on mobile, and advanced capabilities like copy and paste may not be available.

`TextField` always appears on the Flash runtime's native display list. This means that `TextField` is always above Starling content, and you cannot place Starling content above the `TextField`. In order to make this `TextField` feel more integrated with Starling, this text editor takes a bitmap snapshot of the `TextField` instance and displays the snapshot when the editing field does not have focus. This allows you to easily put a `TextInput` or other control that uses this text editor into a scrolling container, and it will be properly clipped without the `TextField` appearing on top where it should be hidden.

`TextField` supports embedded vector fonts and fonts installed on the target device. It does not support bitmap fonts.

## Custom Text Editors

By implementing the `ITextEditor` interface, you can provide a custom text editor. For instance, you might want to create a text editor that supports bitmap fonts.

## Multiline Text Editors

The `TextArea` component introduced in 1.1 allows you edit multiline text in desktop apps. It supports text editors with an extended the `ITextEditorViewPort` interface. Currently, the only supported text editor for `TextArea` is `TextFieldTextEditorViewPort`. Similar to `TextFieldTextEditor`, it uses a `flash.display.TextField`.

On mobile, you generally should not use `TextArea`. It is designed specifically for desktop, and it may not behave as expected on mobile. Instead, use the `TextInput` component with a `StageTextTextEditor`. Set its `multiline` property to `true`.

## Related Links

-   [ITextEditor API Documentation](http://feathersui.com/documentation/feathers/core/text/ITextEditor.html)

-   [StageTextTextEditor API Documentation](http://feathersui.com/documentation/feathers/controls/text/StageTextTextEditor.html)

-   [TextFieldTextEditor API Documentation](http://feathersui.com/documentation/feathers/controls/text/TextFieldTextEditor.html)

-   [TextFieldTextEditorViewPort API Documentation](http://feathersui.com/documentation/feathers/controls/text/TextFieldTextEditorViewPort.html)

-   [How to use the Feathers TextInput component](text-input.html)

-   [How to use the Feathers TextArea component](text-area.html)

-   [Introduction to Feathers Text Renderers](text-renderers.html)

For more tutorials, return to the [Feathers Documentation](index.html).


