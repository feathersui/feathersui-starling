---
title: How to use the Feathers TextArea component  
author: Josh Tynjala

---
# How to use the Feathers TextArea Component

The `TextArea` class supports the editing of multiline, uniformly-formatted text.

`TextArea` is designed specifically for desktop apps, and it is *not* recommended for use in mobile touchscreen apps. Instead, on mobile, you should use a `TextInput` component with a `StageTextTextEditor` with its `multiline` property set to `true`. The underlying `StageText` will provide its own native scroll bar.

## The Basics

Let's start by creating a text area and giving it some default text:

``` code
var textArea:TextArea = new TextArea();
textArea.text = "Hello\nWorld";
this.addChild( textArea );
```

### Focus and Selection

You may programmatically set focus to the text area:

``` code
textArea.setFocus();
```

You can select part of the text too:

``` code
textArea.selectRange(0, textArea.text.length);
```

If you simply want to set the position of the cursor, you can omit the second argument to `selectRange()`:

``` code
textArea.selectRange(0);
```

### Events

Text areas provide some useful events. One of the most common requirements is knowing, in real time, when the value of the `text` property has changed:

``` code
textArea.addEventListener( Event.CHANGE, textArea_changeHandler );
```

You might also want to know when the text area receives and loses focus:

``` code
textArea.addEventListener( FeathersEventType.FOCUS_IN, textArea_focusInHandler );
textArea.addEventListener( FeathersEventType.FOCUS_OUT, textArea_focusOutHandler );
```

## Customizing Input Behavior

Several properties allow you to customize a text area's behavior.

Set the `isEditable` property to false to make the text uneditable, without giving the text area a disabled appearance:

``` code
textArea.isEditable = false;
```

To limit the number of characters that may be entered, use the `maxChars` property:

``` code
textArea.maxChars = 16;
```

The `restrict` property limits the set of characters that can be entered into the text area. It works like the `restrict` property on `flash.text.TextField`.

``` code
textArea.restrict = "0-9";
```

In the example above, we restrict to numeric values only.

## Skinning a Text Area

A text area provides a number of properties to customize its appearance. For full details about what skin and style properties are available, see the [TextArea API reference](../api-reference/feathers/controls/TextArea.html). We'll look at a few of the most common properties below.

### Font Styles

The font styles of a text area may be changed through the [text editor view port](text-editors.html). Each text editor displays fonts differently and has different properties, so the way to make changes to the font styles depends on each text editor.

Currently, Feathers comes with only one text editor view port, `TextFieldTextEditorViewPort`, but it's possible to create custom implementations to replace it.

`TextFieldTextEditorViewPort` places a `flash.text.TextField` with its `type` set to `TextFieldType.INPUT` on the native stage. This text editor accepts a `flash.text.TextFormat` object to pass to the `TextField` to style the text.

The text editor may be styled using the `textEditorFactory`:

``` code
textArea.textEditorFactory = function():ITextEditorViewPOrt
{
    var editor:TextFieldTextEditorViewPort = new TextFieldTextEditorViewPort();
    editor.textFormat = new TextFormat( "_sans", 12, 0x333333 );
    return editor;
}
```

You may also pass properties to the text editor through `textEditorProperties`:

``` code
textArea.textEditorProperties.textFormat = new TextFormat( "_sans", 12, 0x333333 );
```

Using the `textEditorProperties` hash is a bit slower, so if the font styles do not change, you should always use the `textEditorFactory`. The `textEditorProperties` is best for when the font styles change after the editor is initially created.

### Background and Layout

In addition to changing font styles on the text editor, you can change the text area's background skin and padding. Text area has three separate background skins, but two of them are optional.

``` code
textArea.backgroundSkin = new Scale9Image( backgroundSkinTextures );
textArea.backgroundDisabledSkin = new Scale9Image( disabledBackgroundSkinTextures );
textArea.backgroundFocusedSkin = new Scale9Image( focusedBackgroundSkinTextures );
```

The default background skin is displayed when the text area doesn't have focus and is enabled. The disabled background skin is displayed when the text area is not enabled, but if you don't provide a disabled background skin, the default background skin will be used. Similarly, the focused background skin is displayed when the text area has focus. Again, text area will fall back to the default background skin if there is no focused background skin.

You can change the padding values on each side:

``` code
textArea.paddingTop = 10;
textArea.paddingRight = 10;
textArea.paddingBottom = 10;
textArea.paddingLeft = 10;
```

The dimensions of the text editor will be affected by the padding to show more of the background skin around the edges. This can allow you to reveal a border.

### Targeting a TextArea in a theme

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

This section only explains how to access the horizontal scroll bar and vertical scroll bar sub-components. Please read [How to use the Feathers ScrollBar component](scroll-bar.html) (or [SimpleScrollBar](simple-scroll-bar.html)) for full details about the skinning properties that are available on scroll bar components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the `Scroller.DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR` style name for the horizontal scroll bar and the `Scroller.DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR` style name for the vertical scroll bar.

``` code
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( Scroller.DEFAULT_CHILD_NAME_HORIZONTAL_SCROLL_BAR, setHorizontalScrollBarStyles );
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( Scroller.DEFAULT_CHILD_NAME_VERTICAL_SCROLL_BAR, setVerticalScrollBarStyles );
```

You can override the default style names to use different ones in your theme, if you prefer:

``` code
textArea.customHorizontalScrollBarName = "custom-horizontal-scroll-bar";
textArea.customVerticalScrollBarName = "custom-vertical-scroll-bar";
```

You can set the funciton for the `customHorizontalScrollBarName` and the `customVerticalScrollBarName` like this:

``` code
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-horizontal-scroll-bar", setCustomHorizontalScrollBarStyles );
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-vertical-scroll-bar", setCustomVerticalScrollBarStyles );
```

#### Without a Theme

If you are not using a theme, you can use `horizontalScrollBarFactory` and `verticalScrollBarFactory` to provide skins for the text area's scroll bars:

``` code
textArea.horizontalScrollBarFactory = function():ScrollBar
{
    var scrollBar:ScrollBar = new ScrollBar();
    scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
    //skin the scroll bar here
    scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
    return scrollBar;
}
```

Alternatively, or in addition to the `horizontalScrollBarFactory` and `verticalScrollBarFactory`, you may use the `horizontalScrollBarProperties` and the `verticalScrollBarProperties` to pass skins to the scroll bars.

``` code
textArea.horizontalScrollBarProperties.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
```

In general, you should only pass skins to the text area's scroll bars through `horizontalScrollBarProperties` and `verticalScrollBarProperties` if you need to change skins after the scroll bar is created. Using `horizontalScrollBarFactory` and `verticalScrollBarFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

## Customizing Scrolling Behavior

A number of properties are available to customize scrolling behavior and the scroll bars.

### Interaction Modes

Text areas provide two main scrolling interaction modes, which can be changed using the `interactionMode` property.

By default, you can scroll using touch, just like you would on many mobile devices including smartphones and tablets. This mode allows you to grab the text area anywhere within its bounds and drag it around to scroll. This mode is defined by the constant, `INTERACTION_MODE_TOUCH`.

Alternatively, you can set `interactionMode` to `INTERACTION_MODE_MOUSE`. This mode allows you to scroll using the horizontal or vertical scroll bar sub-components. You can also use the mouse wheel to scroll vertically.

### Scroll Bar Display Mode

The `scrollBarDisplayMode` property controls how and when scroll bars are displayed. This value may be overridden by the scroll policy, as explained below.

The default value is `SCROLL_BAR_DISPLAY_MODE_FLOAT`, which displays the scroll bars above the view port's content, rather than affecting the size of the view port. When the scroll bars are floating, they fade out when the text area is not actively scrolling. This is a familiar behavior for scroll bars in the touch interaction mode. In the mouse interaction mode, the scroll bars will appear when the mouse hovers over them and then disappear when the hover ends.

To completely hide the scroll bars, but still allow scrolling, you can set `scrollBarDisplayMode` to `SCROLL_BAR_DISPLAY_MODE_NONE`.

Finally, if you want the scroll bars to always be visible outside of the content in a fixed position, you can set `scrollBarDisplayMode` to `SCROLL_BAR_DISPLAY_MODE_FIXED`. This is best for traditional desktop scrollable content.

### Scroll Policies

The two previous properties control how scrolling works. The `horizontalScrollPolicy` and `verticalScrollPolicy` properties control whether scrolling is enabled or not.

The default scroll policy for both directions is `SCROLL_POLICY_AUTO`. If the content's width is greater than the view port's width, the text area may scroll horizontally (same for height and vertical scrolling). If not, then the text area will not scroll in that direction. In addition to the `scrollBarDisplayMode`, this can affect whether the scroll bar is visible or not.

You can completely disable scrolling in either direction, set the scroll policy to `SCROLL_POLICY_OFF`. The scroll bar will not be visible, and the text area won't scroll, even if the content is larger than the view port.

Finally, you can ensure that scrolling is always enabled by setting the scroll policy to `SCROLL_POLICY_ON`. If combined with `hasElasticEdges` in the touch interaction mode, it will create a playful edge that always bounces back, even when the content is smaller than the view port. If using the mouse interaction mode, the scroll bar may always be visible under the same circumstances, though it may be disabled if the content is smaller than the view port.

## Related Links

-   [TextArea API Documentation](../api-reference/feathers/controls/TextArea.html)

-   [How to Use the Feathers Text Input Component](text-input.html)

-   [Introduction to Feathers Text Editors](text-editors.html)

For more tutorials, return to the [Feathers Documentation](index.html).


