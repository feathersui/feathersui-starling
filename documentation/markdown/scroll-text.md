# How to use the Feathers ScrollText Component

The `ScrollText` is designed for displaying long passages of text. With longer text, `TextFieldTextRenderer` may run into the maximum texture size limits. `BitmapFontTextRenderer` may be a good alternative, but with enough characters, then it may begin to affect performance. `ScrollText` provides the workaround of displaying text on the runtime's classic software-rendered display list.

A disadvantage of displaying text on the classic display list is that the text will **always** appear above Stage 3D content, including regular Starling display objects. There is no way to overlay Starling content above `ScrollText`.

## The Basics

Let's create a `ScrollText` instance, give it some text, and add it to the display list.

``` code
var scrollText:ScrollText = new ScrollText();
scrollText.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
this.addChild( scrollText );
```

As you can see, the `ScrollText` is added to the Starling display list. This is merely an abstraction. Behind the scenes, a `flash.text.TextField` is created and added to the classic display list. As you move and scale the `ScrollText` instance on the Starling display list, the `TextField` will be manipulated on the classic display list.

If we set the `width` property, the `ScrollText` content will automatically word wrap, and the height will grow.

``` code
scrollText.width = 200;
```

If we set both the `width` and `height` properties, the `ScrollText` content will automatically allow scrolling if the content is taller than the height of the `ScrollText`.

``` code
scrollText.width = 200;
scrollText.height = 200;
```

## Skinning a Scroll Text

For full details about what skin and style properties are available, see the [ScrollText API reference](http://feathersui.com/documentation/feathers/controls/ScrollText.html). We'll look at a few of the most common properties below.

### Font Styles

`ScrollText` may be styled with a `flash.text.TextFormat`. You may use fonts installed on the target device or you may embed a font.

``` code
scrollText.textFormat = new TextFormat( "SomeEmbeddedFont", 12, true );
scrollText.embedFonts = true;
```

Use the `isHTML` property to display the text as HTML, with the same capabilities as the `htmlText` property of `flash.text.TextField`.

``` code
scrollText.isHTML = true;
scrollText.text = "<font color=\"#ff0000\">Hello world</font>";
```

A number of other styling properties from `flash.text.TextField` are available to use with `ScrollText`, including `antiAliasType`, `backgroundColor`, `borderColor`, `gridFitType`, `styleSheet`, `sharpness`, `thickness`, and others. See the [ScrollText API documentation](http://feathersui.com/documentation/feathers/controls/ScrollText.html) for full details.

### Targeting a ScrollText in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( ScrollText ).defaultStyleFunction = setScrollTextStyles;
```

If you want to customize a specific scroll text to look different than the default, you may use a custom style name to call a different function:

``` code
text.styleNameList.add( "custom-scroll-text" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( ScrollText )
    .setFunctionForStyleName( "custom-scroll-text", setCustomScrollTextStyles );
```

Trying to change the scroll text's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the scroll text was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the scroll text's properties directly.

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
scrollText.customHorizontalScrollBarName = "custom-horizontal-scroll-bar";
scrollText.customVerticalScrollBarName = "custom-vertical-scroll-bar";
```

You can set the function for the `customHorizontalScrollBarName` and the `customVerticalScrollBarName` like this:

``` code
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-horizontal-scroll-bar", setCustomHorizontalScrollBarStyles,  );
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-vertical-scroll-bar", setCustomVerticalScrollBarStyles );
```

#### Without a Theme

If you are not using a theme, you can use `horizontalScrollBarFactory` and `verticalScrollBarFactory` to provide skins for the scroll bars:

``` code
scrollText.horizontalScrollBarFactory = function():ScrollBar
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
scrollText.horizontalScrollBarProperties.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
```

In general, you should only pass skins to the scroll bars through `horizontalScrollBarProperties` and `verticalScrollBarProperties` if you need to change skins after the scroll bar is created. Using `horizontalScrollBarFactory` and `verticalScrollBarFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

## Customizing Scrolling Behavior

A number of properties are available to customize scrolling behavior and the scroll bars.

### Interaction Modes

`ScrollText` provides two main interaction modes, which can be changed using the `interactionMode` property.

By default, you can scroll using touch, just like you would on many mobile devices including smartphones and tablets. This mode allows you to grab the `ScrollText` anywhere within its bounds and drag it around to scroll. This mode is defined by the constant, `INTERACTION_MODE_TOUCH`.

Alternatively, you can set `interactionMode` to `INTERACTION_MODE_MOUSE`. This mode allows you to scroll using the horizontal or vertical scroll bar sub-components. You can also use the mouse wheel to scroll vertically.

### Scroll Bar Display Mode

The `scrollBarDisplayMode` property controls how and when scroll bars are displayed. This value may be overridden by the scroll policy, as explained below.

The default value is `SCROLL_BAR_DISPLAY_MODE_FLOAT`, which displays the scroll bars above the view port's content, rather than affecting the size of the view port. Since a `TextField` appears above the Starling stage, you should set appropriate padding values so that the text does not appear above the floating scroll bar. When the scroll bars are floating, they fade out when the `ScrollText` is not actively scrolling. This is a familiar behavior for scroll bars in the touch interaction mode. In the mouse interaction mode, the scroll bars will appear when the mouse hovers over them and then disappear when the hover ends.

To completely hide the scroll bars, but still allow scrolling, you can set `scrollBarDisplayMode` to `SCROLL_BAR_DISPLAY_MODE_NONE`.

Finally, if you want the scroll bars to always be visible outside of the content in a fixed position, you can set `scrollBarDisplayMode` to `SCROLL_BAR_DISPLAY_MODE_FIXED`. This is best for traditional desktop scrollable content.

### Scroll Policies

The two previous properties control how scrolling works. The `horizontalScrollPolicy` and `verticalScrollPolicy` properties control whether scrolling is enabled or not.

The default scroll policy for both directions is `SCROLL_POLICY_AUTO`. If the content's width is greater than the view port's width, the `ScrollText` may scroll horizontally (same for height and vertical scrolling). If not, then the `ScrollText` will not scroll in that direction. In addition to the `scrollBarDisplayMode`, this can affect whether the scroll bar is visible or not.

You can completely disable scrolling in either direction, set the scroll policy to `SCROLL_POLICY_OFF`. The scroll bar will not be visible, and the `ScrollText` won't scroll, even if the content is larger than the view port.

Finally, you can ensure that scrolling is always enabled by setting the scroll policy to `SCROLL_POLICY_ON`. If combined with `hasElasticEdges` in the touch interaction mode, it will create a playful edge that always bounces back, even when the content is smaller than the view port. If using the mouse interaction mode, the scroll bar may always be visible under the same circumstances, though it may be disabled if the content is smaller than the view port.

## Related Links

-   [ScrollText API Documentation](http://feathersui.com/documentation/feathers/controls/ScrollText.html)

For more tutorials, return to the [Feathers Documentation](index.html).


