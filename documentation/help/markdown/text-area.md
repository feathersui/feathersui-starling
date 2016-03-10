---
title: How to use the Feathers TextArea component  
author: Josh Tynjala

---
# How to use the Feathers `TextArea` Component

The [`TextArea`](../api-reference/feathers/controls/TextArea.html) class supports the editing of multiline, uniformly-formatted text.

<aside class="info">`TextArea` is designed specifically for desktop apps, and it is *not* recommended for use in mobile touchscreen apps. Instead, on mobile, you should use a [`TextInput`](text-input.html) component with a [`StageTextTextEditor`](../api-reference/feathers/controls/text/StageTextTextEditor.html) with its [`multiline`](../api-reference/feathers/controls/text/StageTextTextEditor.html#multiline) property set to `true`. The underlying `StageText` will provide its own native scroll bar.</aside>

## The Basics

First, let's create a `TextArea` control and add it to the display list:

``` code
var textArea:TextArea = new TextArea();
this.addChild( textArea );
```

### Changing text programmatically

Text may be changed programatically by setting the [`text`](../api-reference/feathers/controls/TextArea.html#text) property:

``` code
textArea.text = "Hello\nWorld";
```

### Focus and Selection

You may programmatically set focus to the text area by calling [`setFocus()`](../api-reference/feathers/controls/TextArea.html#setFocus()):

``` code
textArea.setFocus();
```

You can select part of the text too:

``` code
textArea.selectRange(0, textArea.text.length);
```

If you simply want to set the position of the cursor, you can omit the second argument to [`selectRange()`](../api-reference/feathers/controls/TextArea.html#selectRange()):

``` code
textArea.selectRange(0);
```

### Events

Text areas provide some useful events. One of the most common requirements is knowing, in real time, when the value of the [`text`](../api-reference/feathers/controls/TextArea.html#text) property has changed:

``` code
textArea.addEventListener( Event.CHANGE, textArea_changeHandler );
```

We can listen for [`Event.CHANGE`](../api-reference/feathers/controls/TextArea.html#event:change).

You might also want to know when the text area receives and loses focus:

``` code
textArea.addEventListener( FeathersEventType.FOCUS_IN, textArea_focusInHandler );
textArea.addEventListener( FeathersEventType.FOCUS_OUT, textArea_focusOutHandler );
```

The [`FeathersEventType.FOCUS_IN`](../api-reference/feathers/controls/TextArea.html#event:focusIn) and [`FeathersEventType.FOCUS_OUT`](../api-reference/feathers/controls/TextArea.html#event:focusOut) events are specially dispatched by the `TextArea`, even if the [focus manager](focus.html) is not enabled.

## Customizing Input Behavior

Several properties allow you to customize a text area's behavior.

Set the [`isEditable`](../api-reference/feathers/controls/TextArea.html#isEditable) property to false to make the text uneditable, without giving the text area a disabled appearance:

``` code
textArea.isEditable = false;
```

To limit the number of characters that may be entered, use the [`maxChars`](../api-reference/feathers/controls/TextArea.html#maxChars) property:

``` code
textArea.maxChars = 16;
```

The [`restrict`](../api-reference/feathers/controls/TextArea.html#restrict) property limits the set of characters that can be entered into the text area. It works like the `restrict` property on `flash.text.TextField`.

``` code
textArea.restrict = "0-9";
```

In the example above, we restrict to numeric values only.

## Skinning a `TextArea`

A text area provides a number of properties to customize its appearance. For full details about what skin and style properties are available, see the [`TextArea` API reference](../api-reference/feathers/controls/TextArea.html). We'll look at a few of the most common properties below.

### Font Styles

The font styles of a text area may be changed through the [text editor](text-editors.html). Each text editor displays fonts differently and has different properties, so the way to make changes to the font styles depends on each text editor.

Currently, Feathers comes with only one text editor view port, [`TextFieldTextEditorViewPort`](../api-reference/feathers/controls/text/TextFieldTextEditorViewPort.html). However, it's possible to create custom implementations too.

`TextFieldTextEditorViewPort` places a [`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) with its [`type`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#type) property set to [`TextFieldType.INPUT`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFieldType.html#INPUT) on the native stage. This text editor accepts a [`flash.text.TextFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html) object to pass to the `TextField` to style the text.

The text editor may be styled using the [`textEditorFactory`](../api-reference/feathers/controls/TextArea.html#textEditorFactory):

``` code
textArea.textEditorFactory = function():ITextEditorViewPOrt
{
    var textEditor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
    textEditor.styleProvider = null;
    textEditor.textFormat = new TextFormat( "_sans", 12, 0x333333 );
    return textEditor;
}
```

You may also pass properties to the text editor through [`textEditorProperties`](../api-reference/feathers/controls/TextArea.html#textEditorProperties):

``` code
textArea.textEditorProperties.textFormat = new TextFormat( "_sans", 12, 0x333333 );
```

Using the `textEditorProperties` hash is a bit slower, so if the font styles do not change, you should always use the `textEditorFactory`. The `textEditorProperties` is best for when the font styles change after the editor is initially created.

### Background and Layout

In addition to changing font styles on the text editor, you can change the text area's background skin and padding. Text area has three separate background skins, but two of them are optional.

``` code
textArea.backgroundSkin = new Image( backgroundSkinTexture );
textArea.backgroundDisabledSkin = new Image( disabledBackgroundSkinTexture );
textArea.backgroundFocusedSkin = new Image( focusedBackgroundSkinTexture );
```

The default [`backgroundSkin`](../api-reference/feathers/controls/Scroller.html#backgroundSkin) is displayed when the text area doesn't have focus and is enabled. The [`backgroundDisabledSkin`](../api-reference/feathers/controls/Scroller.html#backgrounDisabledSkin) is displayed when the text area is not enabled, but if you don't provide a disabled background skin, the default background skin will be used. Similarly, the [`backgroundFocusedSkin`](../api-reference/feathers/controls/TextArea.html#backgroundFocusedSkin) is displayed when the text area has focus. Again, text area will fall back to the default background skin if there is no focused background skin.

You can change the padding values on each side:

``` code
textArea.paddingTop = 10;
textArea.paddingRight = 10;
textArea.paddingBottom = 10;
textArea.paddingLeft = 10;
```

The dimensions of the text editor will be affected by the padding to show more of the background skin around the edges. This can allow you to reveal a border.

### Targeting a `TextArea` in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( TextArea ).defaultStyleFunction = setTextAreaStyles;
```

If you want to customize a specific text area to look different than the default, you may use a custom style name to call a different function:

``` code
textArea.styleNameList.add( "custom-text-area" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( TextArea )
    .setFunctionForStyleName( "custom-text-area", setCustomTextAreaStyles );
```

Trying to change the text area's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the text area was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the text area's properties directly.

### Skinning the Scroll Bars

This section only explains how to access the horizontal scroll bar and vertical scroll bar sub-components. Please read [How to use the Feathers `ScrollBar` component](scroll-bar.html) (or [`SimpleScrollBar`](simple-scroll-bar.html)) for full details about the skinning properties that are available on scroll bar components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`Scroller.DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR`](../api-reference/feathers/controls/Scroller.html#DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR) style name for the horizontal scroll bar and the [`Scroller.DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR`](../api-reference/feathers/controls/Scroller.html#DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR) style name for the vertical scroll bar.

``` code
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( Scroller.DEFAULT_CHILD_STYLE_NAME_HORIZONTAL_SCROLL_BAR, setHorizontalScrollBarStyles );
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( Scroller.DEFAULT_CHILD_STYLE_NAME_VERTICAL_SCROLL_BAR, setVerticalScrollBarStyles );
```

You can override the default style names to use different ones in your theme, if you prefer:

``` code
textArea.customHorizontalScrollBarStyleName = "custom-horizontal-scroll-bar";
textArea.customVerticalScrollBarStyleName = "custom-vertical-scroll-bar";
```

You can set the funciton for the [`customHorizontalScrollBarStyleName`](../api-reference/feathers/controls/Scroller.html#customHorizontalScrollBarStyleName) and the [`customVerticalScrollBarStyleName`](../api-reference/feathers/controls/Scroller.html#customVerticalScrollBarStyleName) like this:

``` code
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-horizontal-scroll-bar", setCustomHorizontalScrollBarStyles );
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-vertical-scroll-bar", setCustomVerticalScrollBarStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`horizontalScrollBarFactory`](../api-reference/feathers/controls/Scroller.html#horizontalScrollBarFactory) and [`verticalScrollBarFactory`](../api-reference/feathers/controls/Scroller.html#verticalScrollBarFactory) to provide skins for the text area's scroll bars:

``` code
textArea.horizontalScrollBarFactory = function():ScrollBar
{
    var scrollBar:ScrollBar = new ScrollBar();
    scrollBar.direction = Direction.HORIZONTAL;
    //skin the scroll bar here
    scrollBar.trackLayoutMode = TrackLayoutMode.SINGLE;
    return scrollBar;
}
```

Alternatively, or in addition to the `horizontalScrollBarFactory` and `verticalScrollBarFactory`, you may use the [`horizontalScrollBarProperties`](../api-reference/feathers/controls/Scroller.html#horizontalScrollBarProperties) and the [`verticalScrollBarProperties`](../api-reference/feathers/controls/Scroller.html#verticalScrollBarProperties) to pass skins to the scroll bars.

``` code
textArea.horizontalScrollBarProperties.trackLayoutMode = TrackLayoutMode.SINGLE;
```

In general, you should only pass skins to the text area's scroll bars through `horizontalScrollBarProperties` and `verticalScrollBarProperties` if you need to change skins after the scroll bar is created. Using `horizontalScrollBarFactory` and `verticalScrollBarFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

## Customizing Scrolling Behavior

A number of properties are available to customize scrolling behavior and the scroll bars.

### Interaction Modes

Scrolling containers provide two main interaction modes, which can be changed using the [`interactionMode`](../api-reference/feathers/controls/Scroller.html#interactionMode) property.

By default, you can scroll using touch, just like you would on many mobile devices including smartphones and tablets. This mode allows you to grab the container anywhere within its bounds and drag it around to scroll. This mode is defined by the constant, [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH).

Alternatively, you can set `interactionMode` to [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE). This mode allows you to scroll using the horizontal or vertical scroll bar sub-components. You can also use the mouse wheel to scroll vertically.

Finally, you can set `interactionMode` to [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS). This mode allows you to scroll both by dragging the container's content and by using the scroll bars.

### Scroll Bar Display Mode

The [`scrollBarDisplayMode`](../api-reference/feathers/controls/Scroller.html#scrollBarDisplayMode) property controls how and when scroll bars are displayed. This value may be overridden by the scroll policy, as explained below.

The default value is [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT), which displays the scroll bars as an overlay above the view port's content, rather than affecting the size of the view port. When the scroll bars are floating, they fade out when the container is not actively scrolling. This is a familiar behavior for scroll bars in the touch interaction mode. In the mouse interaction mode, the scroll bars will appear when the mouse hovers over them and then disappear when the hover ends.

To completely hide the scroll bars, but still allow scrolling, you can set `scrollBarDisplayMode` to [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE).

If you want the scroll bars to always be visible outside of the content in a fixed position, you can set `scrollBarDisplayMode` to [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED). This is best for traditional desktop scrollable content.

Finally, you can set `scrollBarDisplayMode` to [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED_FLOAT) to display the scroll bar as an overlay above the view port's content, but it does not fade away.

### Scroll Policies

The two previous properties control how scrolling works. The [`horizontalScrollPolicy`](../api-reference/feathers/controls/Scroller.html#horizontalScrollPolicy) and [`verticalScrollPolicy`](../api-reference/feathers/controls/Scroller.html#verticalScrollPolicy) properties control whether scrolling is enabled or not.

The default scroll policy for both directions is [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO). If the content's width is greater than the view port's width, the panel may scroll horizontally (same for height and vertical scrolling). If not, then the panel will not scroll in that direction. In addition to the `scrollBarDisplayMode`, this can affect whether the scroll bar is visible or not.

You can completely disable scrolling in either direction, set the scroll policy to [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF). The scroll bar will not be visible, and the panel won't scroll, even if the content is larger than the view port.

Finally, you can ensure that scrolling is always enabled by setting the scroll policy to [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON). If combined with `hasElasticEdges` in the touch interaction mode, it will create a playful edge that always bounces back, even when the content is smaller than the view port. If using the mouse interaction mode, the scroll bar may always be visible under the same circumstances, though it may be disabled if the content is smaller than the view port.

## Related Links

-   [`feathers.controls.TextArea` API Documentation](../api-reference/feathers/controls/TextArea.html)

-   [How to Use the Feathers `TextInput` Component](text-input.html)

-   [Introduction to Feathers Text Editors](text-editors.html)