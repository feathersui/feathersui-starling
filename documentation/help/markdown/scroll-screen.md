---
title: How to use the Feathers ScrollScreen component  
author: Josh Tynjala

---
# How to use the Feathers `ScrollScreen` component

A [`ScrollScreen`](../api-reference/feathers/controls/ScrollScreen.html) component is meant to be a base class for custom screens to be displayed by [`StackScreenNavigator`](stack-screen-navigator.html) and [`ScreenNavigator`](screen-navigator.html). `ScrollScreen` is based on the [`ScrollContainer`](scroll-container.html) component, and it provides scrolling and optional layout.

<aside class="info">If you don't need scrolling at all, you should use [`Screen`](screen.html) instead. If you need a header or a footer, you should use [`PanelScreen`](panel-screen.html) instead.</aside>

## The Basics

Just like [`ScrollContainer`](scroll-container.html), you can add children and use layouts. Typically, you would override `initialize()` in a subclass of `ScrollScreen` and add children there:

``` code
protected function initialize():void
{
	// never forget to call this!
	super.initialize();

	// use a layout
	var layout:HorizontalLayout = new HorizontalLayout();
	layout.gap = 10;
	this.layout = layout;

	// add children
	for(var i:int = 0; i < 5; i++)
	{
	    var quad:Quad = new Quad( 100, 100, 0xff0000 );
	    group.addChild( quad );
	}
}
```

## Hardware Key Handlers

Some devices, such as Android phones and tablets, have hardware keys. These may include a back button, a search button, and a menu button. The `ScrollScreen` class provides a way to provide callbacks for when each of these keys is pressed. These are shortcuts to avoid needing to listen to the keyboard events manually and prevent the default behavior.

Screen provides [`backButtonHandler`](../api-reference/feathers/controls/ScrollScreen.html#backButtonHandler), [`menuButtonHandler`](../api-reference/feathers/controls/ScrollScreen.html#menuButtonHandler), and [`searchButtonHandler`](../api-reference/feathers/controls/ScrollScreen.html#searchButtonHandler).

``` code
this.backButtonHandler = function():void
{
    trace( "the back button has been pressed." );
}
```

## Events when transitions start and complete

The `ScrollScreen` dispatches a number of events when the screen navigator shows and hides it with a [transition](transitions.html). To avoid long delays and to keep the transition animation smooth, it's often a good idea to postpone certain actions during initialization until after the transition has completed. We can listen for these events to know when to continue initializing the screen.

When the screen is shown by the screen navigator, the screen dispatches [`FeathersEventType.TRANSITION_IN_START`](../api-reference/feathers/controls/Screen.html#event:transitionInStart) at the beginning of a transition, and it dispatches [`FeathersEventType.TRANSITION_IN_COMPLETE`](../api-reference/feathers/controls/Screen.html#event:transitionInComplete) when the transition has finished. Similarly, when the screen navigator shows a different screen and the active screen is hidden, we can listen for [`FeathersEventType.TRANSITION_OUT_START`](../api-reference/feathers/controls/Screen.html#event:transitionOutStart) and [`FeathersEventType.TRANSITION_OUT_COMPLETE`](../api-reference/feathers/controls/Screen.html#event:transitionOutComplete).

Let's listen for `FeathersEventType.TRANSITION_IN_COMPLETE`:

``` code
this.addEventListener( FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler );
```

The event listener might look like this:

``` code
private function transitionInCompleteHandler( event:Event ):void
{
    // do something after the screen transitions in
}
```

## Screen ID

The [`screenID`](../api-reference/feathers/controls/ScrollScreen.html#screenID) property refers to the string that the screen navigator uses to identify the current screen when calling functions like [`pushScreen()`](../api-reference/feathers/controls/StackScreenNavigator.html#pushScreen()) on a `StackScreenNavigator` or [`showScreen()`](../api-reference/feathers/controls/ScreenNavigator.html#showScreen()) on a `ScreenNavigator`.

## Accessing the screen navigator

The [`owner`](../api-reference/feathers/controls/ScrollScreen.html#owner) property provides access to the `StackScreenNavigator` or `ScreenNavigator` that is currently displaying the screen.

## Skinning a `ScrollScreen`

For full details about what skin and style properties are available, see the [`ScrollScreen` API reference](../api-reference/feathers/controls/ScrollScreen.html).

<aside class="info">As mentioned above, `ScrollScreen` is a subclass of `ScrollContainer`. For more detailed information about the skinning options available to `ScrollScreen`, see [How to use the `ScrollContainer` component](scroll-container.html).</aside>

### Targeting a `ScrollScreen` in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( ScrollScreen ).defaultStyleFunction = setScrollScreenStyles;
```

If you want to customize a specific scroll screen to look different than the default, you may use a custom style name to call a different function:

``` code
screen.styleNameList.add( "custom-scroll-screen" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( ScrollScreen )
    .setFunctionForStyleName( "custom-scroll-screen", setCustomScrollScreenStyles );
```

Trying to change the screen's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the screen was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the screen's properties directly.

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
screen.customHorizontalScrollBarStyleName = "custom-horizontal-scroll-bar";
screen.customVerticalScrollBarStyleName = "custom-vertical-scroll-bar";
```

You can set the function for the [`customHorizontalScrollBarStyleName`](../api-reference/feathers/controls/Scroller.html#customHorizontalScrollBarStyleName) and the [`customVerticalScrollBarStyleName`](../api-reference/feathers/controls/Scroller.html#customVerticalScrollBarStyleName) like this:

``` code
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-horizontal-scroll-bar", setCustomHorizontalScrollBarStyles );
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-vertical-scroll-bar", setCustomVerticalScrollBarStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`horizontalScrollBarFactory`](../api-reference/feathers/controls/Scroller.html#horizontalScrollBarFactory) and [`verticalScrollBarFactory`](../api-reference/feathers/controls/Scroller.html#verticalScrollBarFactory) to provide skins for the container's scroll bars:

``` code
screen.horizontalScrollBarFactory = function():ScrollBar
{
    var scrollBar:ScrollBar = new ScrollBar();
    scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
    //skin the scroll bar here
    scrollBar.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
    return scrollBar;
}
```

Alternatively, or in addition to the `horizontalScrollBarFactory` and `verticalScrollBarFactory`, you may use [`horizontalScrollBarProperties`](../api-reference/feathers/controls/Scroller.html#horizontalScrollBarProperties) and [`verticalScrollBarProperties`](../api-reference/feathers/controls/Scroller.html#verticalScrollBarProperties) to pass skins to the scroll bars.

``` code
screen.horizontalScrollBarProperties.trackLayoutMode = ScrollBar.TRACK_LAYOUT_MODE_SINGLE;
```

In general, you should only pass skins to the container's scroll bars through `horizontalScrollBarProperties` and `verticalScrollBarProperties` if you need to change skins after the scroll bar is created. Using `horizontalScrollBarFactory` and `verticalScrollBarFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

## Customizing Scrolling Behavior

A number of properties are available to customize scrolling behavior and the scroll bars.

### Interaction Modes

Scrolling containers provide two main interaction modes, which can be changed using the [`interactionMode`](../api-reference/feathers/controls/Scroller.html#interactionMode) property.

By default, you can scroll using touch, just like you would on many mobile devices including smartphones and tablets. This mode allows you to grab the panel anywhere within its bounds and drag it around to scroll. This mode is defined by the constant, [`INTERACTION_MODE_TOUCH`](../api-reference/feathers/controls/Scroller.html#INTERACTION_MODE_TOUCH).

Alternatively, you can set `interactionMode` to [`INTERACTION_MODE_MOUSE`](../api-reference/feathers/controls/Scroller.html#INTERACTION_MODE_MOUSE). This mode allows you to scroll using the horizontal or vertical scroll bar sub-components. You can also use the mouse wheel to scroll vertically.

### Scroll Bar Display Mode

The [`scrollBarDisplayMode`](../api-reference/feathers/controls/Scroller.html#scrollBarDisplayMode) property controls how and when scroll bars are displayed. This value may be overridden by the scroll policy, as explained below.

The default value is [`SCROLL_BAR_DISPLAY_MODE_FLOAT`](../api-reference/feathers/controls/Scroller.html#SCROLL_BAR_DISPLAY_MODE_FLOAT), which displays the scroll bars above the view port's content, rather than affecting the size of the view port. When the scroll bars are floating, they fade out when the panel is not actively scrolling. This is a familiar behavior for scroll bars in the touch interaction mode. In the mouse interaction mode, the scroll bars will appear when the mouse hovers over them and then disappear when the hover ends.

To completely hide the scroll bars, but still allow scrolling, you can set `scrollBarDisplayMode` to [`SCROLL_BAR_DISPLAY_MODE_NONE`](../api-reference/feathers/controls/Scroller.html#SCROLL_BAR_DISPLAY_MODE_NONE).

Finally, if you want the scroll bars to always be visible outside of the content in a fixed position, you can set `scrollBarDisplayMode` to [`SCROLL_BAR_DISPLAY_MODE_FIXED`](../api-reference/feathers/controls/Scroller.html#SCROLL_BAR_DISPLAY_MODE_FIXED). This is best for traditional desktop scrollable content.

### Scroll Policies

The two previous properties control how scrolling works. The [`horizontalScrollPolicy`](../api-reference/feathers/controls/Scroller.html#horizontalScrollPolicy) and [`verticalScrollPolicy`](../api-reference/feathers/controls/Scroller.html#verticalScrollPolicy) properties control whether scrolling is enabled or not.

The default scroll policy for both directions is [`SCROLL_POLICY_AUTO`](../api-reference/feathers/controls/Scroller.html#SCROLL_POLICY_AUTO). If the content's width is greater than the view port's width, the panel may scroll horizontally (same for height and vertical scrolling). If not, then the panel will not scroll in that direction. In addition to the `scrollBarDisplayMode`, this can affect whether the scroll bar is visible or not.

You can completely disable scrolling in either direction, set the scroll policy to [`SCROLL_POLICY_OFF`](../api-reference/feathers/controls/Scroller.html#SCROLL_POLICY_OFF). The scroll bar will not be visible, and the panel won't scroll, even if the content is larger than the view port.

Finally, you can ensure that scrolling is always enabled by setting the scroll policy to [`SCROLL_POLICY_ON`](../api-reference/feathers/controls/Scroller.html#SCROLL_POLICY_ON). If combined with `hasElasticEdges` in the touch interaction mode, it will create a playful edge that always bounces back, even when the content is smaller than the view port. If using the mouse interaction mode, the scroll bar may always be visible under the same circumstances, though it may be disabled if the content is smaller than the view port.

### Paging

Set the [`snapToPages`](../api-reference/feathers/controls/Scroller.html#snapToPages) property to true to make the scroll position snap to the nearest full page. A page is defined as a multiple of the view ports width or height. If the view port is 100 pixels wide, then the first horizontal page starts at 0 pixels, the second at 100, and the third at 200.

The [`pageWidth`](../api-reference/feathers/controls/Scroller.html#pageWidth) and [`pageHeight`](../api-reference/feathers/controls/Scroller.html#pageHeight) properties may be used to customize the size of a page. Rather than using the full view port width or height, any pixel value may be specified for page snapping.

## Related Links

-   [`feathers.controls.ScrollScreen` API Documentation](../api-reference/feathers/controls/ScrollScreen.html)

-   [How to use the Feathers `ScrollContainer` component](scroll-container.html)

For more tutorials, return to the [Feathers Documentation](index.html).


