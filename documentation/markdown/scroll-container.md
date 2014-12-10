# How to use the Feathers ScrollContainer component

The `ScrollContainer` class provides a generic container for display object layout and scrolling a view port. By default, you can position components manually, but you can also pass in a layout to position the children automatically. Scrolling is vertical or horizontal, and is enabled when the width or height of the content exceeds the width or height of the container. You can also disable scrolling completely, if desired.

You may also be interested in the `LayoutGroup` component. This container lightweight container doesn't support scrolling, and it is often much better for performance when you don't need content to scroll.

## The Basics

Let's start by creating a `ScrollContainer` and adding it to the display list:

``` code
var container:ScrollContainer = new ScrollContainer();
this.addChild( container );
```

A `ScrollContainer` works a lot like any `DisplayObjectContainer`, so you can use the standard `addChild()`, `removeChild()` and other display list manipulation functions.

``` code
var xPosition:Number = 0;
for(var i:int = 0; i < 5; i++)
{
    var quad:Quad = new Quad( 100, 100, 0xff0000 );
    quad.x = xPosition;
    container.addChild( quad );
    xPosition += quad.width + 10;
}
```

The children of a `ScrollContainer` do not need to be Feathers UI controls. As you can see above, we've added some Starling `Quad` instances.

By default, the `ScrollContainer` will automatically resize itself to fit the area that the children occupy. We can set the width and height manually, if desired, to override this behavior:

``` code
container.width = 200;
container.height = 200;
```

## Layout

We manually positioned the quads in the example code above. Instead, let's apply a [HorizontalLayout](http://feathersui.com/documentation/feathers/layout/HorizontalLayout.html) to the children of a `ScrollContainer` to do the positioning manually:

``` code
var layout:HorizontalLayout = new HorizontalLayout();
layout.gap = 10;
container.layout = layout;
```

We can set a number of other properties on the layout too. In the case of `HorizontalLayout` (and `VerticalLayout` too), we can customize things like padding around the edges along with horizontal and vertical alignment. Other layouts may expose more or completely different properties that may be customized. Check their API documentation for complete details.

## Skinning a Scroll Container

The skins for a `ScrollContainer` control are mainly the background skins and some basic styles, and the scroll bars may be skinned too. For full details about what skin and style properties are available, see the [ScrollContainer API reference](http://feathersui.com/documentation/feathers/controls/ScrollContainer.html). We'll look at a few of the most common properties below.

### Background Skins and Basic Styles

We'll start the skinning process by giving our scroll container appropriate background skins.

``` code
container.backgroundSkin = new Scale9Image( enabledTextures );
container.backgroundDisabledSkin = new Image( disabledTextures );
```

The `backgroundSkin` property provides the default background for when the container is enabled. The `backgroundDisabledSkin` is displayed when the container is disabled. If the `backgroundDisabledSkin` isn't provided to a disabled container, it will fall back to using the `backgroundSkin` in the disabled state.

Padding may be added around the edges of the container's content. This padding is different than any type of padding that may be provided by the layout. The layout padding is applied inside the container's content, but the container's padding is applied outside of the content, and is generally used to show a bit of the background as a border around the content.

``` code
container.paddingTop = 15;
container.paddingRight = 20;
container.paddingBottom = 15;
container.paddingLeft = 20;
```

If all four padding values should be the same, you may use the `padding` property to quickly set them all at once:

``` code
container.padding = 20;
```

### Targeting a ScrollContainer in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( ScrollContainer ).defaultStyleFunction = setScrollContainerStyles;
```

If you want to customize a specific scroll container to look different than the default, you may use a custom style name to call a different function:

``` code
container.styleNameList.add( "custom-scroll-container" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( ScrollContainer )
    .setFunctionForStyleName( "custom-scroll-container", setCustomScrollContainerStyles );
```

Trying to change the scroll container's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the scroll container was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the scroll container's properties directly.

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
container.customHorizontalScrollBarName = "custom-horizontal-scroll-bar";
container.customVerticalScrollBarName = "custom-vertical-scroll-bar";
```

You can set the function for the `customHorizontalScrollBarName` and the `customVerticalScrollBarName` like this:

``` code
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-horizontal-scroll-bar", setCustomHorizontalScrollBarStyles );
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-vertical-scroll-bar", setCustomVerticalScrollBarStyles );
```

#### Without a Theme

If you are not using a theme, you can use `horizontalScrollBarFactory` and `verticalScrollBarFactory` to provide skins for the container's scroll bars:

``` code
container.horizontalScrollBarFactory = function():ScrollBar
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
container.horizontalScrollBarProperties.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
```

In general, you should only pass skins to the container's scroll bars through `horizontalScrollBarProperties` and `verticalScrollBarProperties` if you need to change skins after the scroll bar is created. Using `horizontalScrollBarFactory` and `verticalScrollBarFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

## Customizing Scrolling Behavior

A number of properties are available to customize scrolling behavior and the scroll bars.

### Interaction Modes

Scrolling containers provide two main interaction modes, which can be changed using the `interactionMode` property.

By default, you can scroll using touch, just like you would on many mobile devices including smartphones and tablets. This mode allows you to grab the container anywhere within its bounds and drag it around to scroll. This mode is defined by the constant, `INTERACTION_MODE_TOUCH`.

Alternatively, you can set `interactionMode` to `INTERACTION_MODE_MOUSE`. This mode allows you to scroll using the horizontal or vertical scroll bar sub-components. You can also use the mouse wheel to scroll vertically.

### Scroll Bar Display Mode

The `scrollBarDisplayMode` property controls how and when scroll bars are displayed. This value may be overridden by the scroll policy, as explained below.

The default value is `SCROLL_BAR_DISPLAY_MODE_FLOAT`, which displays the scroll bars above the view port's content, rather than affecting the size of the view port. When the scroll bars are floating, they fade out when the container is not actively scrolling. This is a familiar behavior for scroll bars in the touch interaction mode. In the mouse interaction mode, the scroll bars will appear when the mouse hovers over them and then disappear when the hover ends.

To completely hide the scroll bars, but still allow scrolling, you can set `scrollBarDisplayMode` to `SCROLL_BAR_DISPLAY_MODE_NONE`.

Finally, if you want the scroll bars to always be visible outside of the content in a fixed position, you can set `scrollBarDisplayMode` to `SCROLL_BAR_DISPLAY_MODE_FIXED`. This is best for traditional desktop scrollable content.

### Scroll Policies

The two previous properties control how scrolling works. The `horizontalScrollPolicy` and `verticalScrollPolicy` properties control whether scrolling is enabled or not.

The default scroll policy for both directions is `SCROLL_POLICY_AUTO`. If the content's width is greater than the view port's width, the container may scroll horizontally (same for height and vertical scrolling). If not, then the container will not scroll in that direction. In addition to the `scrollBarDisplayMode`, this can affect whether the scroll bar is visible or not.

You can completely disable scrolling in either direction, set the scroll policy to `SCROLL_POLICY_OFF`. The scroll bar will not be visible, and the container won't scroll, even if the content is larger than the view port.

Finally, you can ensure that scrolling is always enabled by setting the scroll policy to `SCROLL_POLICY_ON`. If combined with `hasElasticEdges` in the touch interaction mode, it will create a playful edge that always bounces back, even when the content is smaller than the view port. If using the mouse interaction mode, the scroll bar may always be visible under the same circumstances, though it may be disabled if the content is smaller than the view port.

### Paging

Set the `snapToPages` property to true to make the container snap to the nearest full page. A page is defined as a multiple of the view ports width or height. If the view port is 100 pixels wide, then the first horizontal page starts at 0 pixels, the second at 100, and the third at 200.

The `pageWidth` and `pageHeight` properties may be used to customize the size of a page. Rather than using the full view port width or height, any pixel value may be specified for page snapping.

## Performance Warning: ScrollContainer versus List

Many developers try to use ScrollContainer any time that they need to scroll some content. This will work for a small set of children, but especially on mobile, there are limits to what ScrollContainer can handle. If your layout contains many children that basically look the same, and maybe you're referring to them as “cells” or “items”, then ScrollContainer is probably not the correct component for this type of UI. Instead, you should probably use the [List component](list.html).

List is much better at supporting layouts with dozens or hundreds of items, and its [item renderers can be customized](item-renderers.html) to completely change their appearance. If you need headers or footers, [GroupedList](http://wiki.starling-framework.org/feathers/grouped-list) might be a better choice.

## Related Links

-   [ScrollContainer API Documentation](http://feathersui.com/documentation/feathers/controls/ScrollContainer.html)

-   [How to use the Feathers LayoutGroup component](layout-group.html)

For more tutorials, return to the [Feathers Documentation](start.html).


