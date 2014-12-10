# How to use the Feathers Screen Component

The `ScreenNavigator` component can display any Feathers control as a screen. However, using the `Screen` class as your base class for a new screen is recommended because it provides a number of convenient properties.

## Accessing the ScreenNavigator

The [owner](http://feathersui.com/documentation/feathers/controls/Screen.html#owner) property provides access to the `ScreenNavigator` that is currently displaying the screen. You might want to use this property to manually navigate to another screen by calling `showScreen()`. You might also use it to listen to events like `FeathersEventType.TRANSITION_START` and `FeathersEventType.TRANSITION_COMPLETE` to determine when the screen has fully transitioned in or out.

## Screen ID

The `screenID` property refers to the string that the `ScreenNavigator` uses to identify the current screen when calling functions like `showScreen()`

## Scaling

Many Feathers [themes](themes.html) automatically scale skins to the current device's DPI. Screens have a similar `dpiScale` property which may be used for adjusting pixel-based measurements for layout. It is calculated using the current DPI and an `originalDPI`, which is generally set by the theme. If it is not provided, the current DPI will be used, and the `dpiScale` will be `1`. Ideally, you would add layout properties like gaps or padding to your screen so that the theme can pass them in instead of calculating them yourself inside the screen.

Similarly, screens have a `pixelScale` property. If you pass in values for `originalWidth` and `originalHeight`, the `pixelScale` will be calculated to provide a value that allows your content to be scaled up or down and still fit inside the current `actualWidth` and `actualHeight` bounds. Similarly, the default value is `1`, which provides no scaling.

In both cases, `dpiScale` and `pixelScale` are simply numeric values. No actual scaling is done to your content. They're simply helpful values that you might consider using when laying out children.

## Hardware Key Handlers

Some devices, such as Android phones and tablets, have hardware keys. These may include a back button, a search button, and a menu button. The `Screen` class provides a way to provide callbacks for when each of these keys is pressed. These are shortcuts to avoid needing to listen to the keyboard events manually and prevent the default behavior.

Screen provides `backButtonHandler`, `menuButtonHandler`, and `searchButtonHandler`.

``` code
this.backButtonHandler = function():void
{
    trace( "the back button has been pressed." );
}
```

## Skinning a Screen

For full details about what skin and style properties are available, see the [Screen API reference](http://feathersui.com/documentation/feathers/controls/Screen.html).

As mentioned above, `Screen` is a subclass of `LayoutGroup`. For more detailed information about the skinning options available to `Screen`, see [How to use the LayoutGroup component](layout-group.html).

### Targeting a Screen in a theme

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

If you aren't using a theme, then you may set any of the screen's properties directly. For full details about what skin and style properties are available, see the [Screen API reference](http://feathersui.com/documentation/feathers/controls/Screen.html).

## Related Links

-   [Screen API Documentation](http://feathersui.com/documentation/feathers/controls/Screen.html)

For more tutorials, return to the [Feathers Documentation](index.html).


