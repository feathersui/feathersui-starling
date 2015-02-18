---
title: How to use the Feathers Screen component  
author: Josh Tynjala

---
# How to use the Feathers `Screen` component

The [`Screen`](../api-reference/feathers/controls/Screen.html) component is meant to be a base class for custom screens to be displayed by [`StackScreenNavigator`](stack-screen-navigator.html) and [`ScreenNavigator`](screen-navigator). `Screen` is based on the [`LayoutGroup`](layout-group.html) component, and it provides optional layout.

<aside class="info">If you need scrolling, you should use [`ScrollScreen`](scroll-screen.html) or [`PanelScreen`](panel-screen.html) instead.</aside>

## The Basics

Just like [`LayoutGroup`](layout-group.html), you can add children and use layouts. Typically, you would override `initialize()` in a subclass of `Screen` and add children there:

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

Some devices, such as Android phones and tablets, have hardware keys. These may include a back button, a search button, and a menu button. The `Screen` class provides a way to provide callbacks for when each of these keys is pressed. These are shortcuts to avoid needing to listen to the keyboard events manually and prevent the default behavior.

Screen provides [`backButtonHandler`](../api-reference/feathers/controls/Screen.html#backButtonHandler), [`menuButtonHandler`](../api-reference/feathers/controls/Screen.html#menuButtonHandler), and [`searchButtonHandler`](../api-reference/feathers/controls/Screen.html#searchButtonHandler).

``` code
this.backButtonHandler = function():void
{
    trace( "the back button has been pressed." );
}
```

## Events when transitions start and complete

A `Screen` dispatches a number of events when the screen navigator shows and hides it with a [transition](transitions.html). To avoid long delays and to keep the transition animation smooth, it's often a good idea to postpone certain actions during initialization until after the transition has completed. We can listen for these events to know when to continue initializing the screen.

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

The [`screenID`](../api-reference/feathers/controls/Screen.html#screenID) property refers to the string that the screen navigator uses to identify the current screen when calling functions like [`pushScreen()`](../api-reference/feathers/controls/StackScreenNavigator.html#pushScreen()) on a `StackScreenNavigator` or [`showScreen()`](../api-reference/feathers/controls/ScreenNavigator.html#showScreen()) on a `ScreenNavigator`.

## Accessing the screen navigator

The [`owner`](../api-reference/feathers/controls/Screen.html#owner) property provides access to the `StackScreenNavigator` or `ScreenNavigator` that is currently displaying the screen.

## Skinning a `Screen`

For full details about what skin and style properties are available, see the [`Screen` API reference](../api-reference/feathers/controls/Screen.html).

<aside class="info">As mentioned above, `Screen` is a subclass of `LayoutGroup`. For more detailed information about the skinning options available to `Screen`, see [How to use the Feathers `LayoutGroup` component](layout-group.html).</aside>

### Targeting a `Screen` in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( Screen ).defaultStyleFunction = setScreenStyles;
```

If you want to customize a specific screen to look different than the default, you may use a custom style name to call a different function:

``` code
screen.styleNameList.add( "custom-screen" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( Screen )
    .setFunctionForStyleName( "custom-screen", setCustomScreenStyles );
```

Trying to change the screen's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the screen was added to the stage and initialized.

If you aren't using a theme, then you may set any of the screen's properties directly. For full details about what skin and style properties are available, see the [`Screen` API reference](../api-reference/feathers/controls/Screen.html).

## Related Links

-   [`feathers.controls.Screen` API Documentation](../api-reference/feathers/controls/Screen.html)