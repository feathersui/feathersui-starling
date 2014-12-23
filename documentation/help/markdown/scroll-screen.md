---
title: How to use the Feathers ScrollScreen component  
author: Josh Tynjala

---
# How to use the Feathers `ScrollScreen` component

The [`ScrollScreen`](../api-reference/feathers/controls/ScrollScreen.html) component is meant to be a base class for custom screens to be displayed by [`StackScreenNavigator`](stack-screen-navigator.html) and [`ScreenNavigator`](screen-navigator.html). `ScrollScreen` is based on the [`ScrollContainer`](scroll-container.html) component, and it provides scrolling and optional layout.

## Hardware Key Handlers

Some devices, such as Android phones and tablets, have hardware keys. These may include a back button, a search button, and a menu button. The `ScrollScreen` class provides a way to provide callbacks for when each of these keys is pressed. These are shortcuts to avoid needing to listen to the keyboard events manually and prevent the default behavior.

Screen provides [`backButtonHandler`](../api-reference/feathers/controls/ScrollScreen.html#backButtonHandler), [`menuButtonHandler`](../api-reference/feathers/controls/ScrollScreen.html#menuButtonHandler), and [`searchButtonHandler`](../api-reference/feathers/controls/ScrollScreen.html#searchButtonHandler).

``` code
this.backButtonHandler = function():void
{
    trace( "the back button has been pressed." );
}
```

## Screen ID

The [`screenID`](../api-reference/feathers/controls/ScrollScreen.html#screenID) property refers to the string that the screen navigator uses to identify the current screen when calling functions like [`pushScreen()`](../api-reference/feathers/controls/StackScreenNavigator.html#pushScreen()) on a `StackScreenNavigator` or [`showScreen()`](../api-reference/feathers/controls/ScreenNavigator.html#showScreen()) on a `ScreenNavigator`.

## Accessing the screen navigator

The [`owner`](../api-reference/feathers/controls/ScrollScreen.html#owner) property provides access to the `StackScreenNavigator` or `ScreenNavigator` that is currently displaying the screen. You might want to use this property to manually navigate to another screen by calling [`showScreen()`](../api-reference/feathers/controls/ScreenNavigator.html#showScreen()). You might also use it to listen to events like `FeathersEventType.TRANSITION_START` and `FeathersEventType.TRANSITION_COMPLETE` to determine when the screen has fully transitioned in or out.

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

## Related Links

-   [`feathers.controls.ScrollScreen` API Documentation](../api-reference/feathers/controls/ScrollScreen.html)

-   [How to use the Feathers `ScrollContainer` component](scroll-container.html)

-   [How to use the Feathers `Screen` component](screen.html)

For more tutorials, return to the [Feathers Documentation](index.html).


