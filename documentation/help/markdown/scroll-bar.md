---
title: How to use the Feathers ScrollBar component  
author: Josh Tynjala

---
# How to use the Feathers ScrollBar component

The `ScrollBar` component displays a numeric value between a minimum and maximum. The value may be changed by sliding a thumb along a track in either a horizontal or a vertical direction. A scroll bar also has a button on each side of the track that adjusts the value by a small step when triggered. This component is designed to be used with subclasses of the `Scroller` class like the `ScrollContainer` and `List` components.

Additionally, Feathers offers a `SimpleScrollBar` component. This is a mobile-style scroll bar that only has a thumb to visually indicate the scroll position and range. It has no visible track nor buttons for stepping the scroll position.

## The Basics

You can use the `ScrollBar` with a `Scroller` by instantiating it in the `horizontalScrollBarFactory` or the `verticalScrollBarFactory`.

``` code
list.horizontalScrollBarFactory = function():IScrollBar
{
    var scrollBar:ScrollBar = new ScrollBar();
    scrollBar.direction = ScrollBar.DIRECTION_HORIZONTAL;
    return scrollBar;
}
```

Make sure that you set the `direction` property to an appropriate value. However, the `Scroller` will handle setting properties like `minimum`, `maximum`, and `step`, and it will automatically listen for `Event.CHANGE` to know when the `value` property changes.

If, for some reason, you want to use a `ScrollBar` outside of a subclass of `Scroller`, the values like `minimum`, `maximum`, `step` and `value` that the `Scroller` normally handles work similarly to a `Slider` component.

## Skinning a ScrollBar

The skins for a `ScrollBar` control are divided into several parts, including the thumb, the track(s), and the increment and decrement buttons. For full details about what skin and style properties are available, see the [ScrollBar API reference](../api-reference/feathers/controls/ScrollBar.html).

### Targeting a ScrollBar in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( ScrollBar ).defaultStyleFunction = setScrollBarStyles;
```

If you want to customize a specific scroll bar to look different than the default, you may use a custom style name to call a different function:

``` code
scrollBar.styleNameList.add( "custom-scroll-bar" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( ScrollBar )
    .setFunctionForStyleName( "custom-scroll-bar", setCustomScrollBarStyles );
```

Trying to change the scroll bar's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the scroll bar was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the scroll bar's properties directly.

### Skinning the Thumb

This section only explains how to access the thumb sub-component. Please read [How to use the Feathers Button component](button.html) for full details about the skinning properties that are available on `Button` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the `ScrollBar.DEFAULT_CHILD_NAME_THUMB` style name.

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( ScrollBar.DEFAULT_CHILD_NAME_THUMB, setScrollBarThumbStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
scrollBar.customThumbName = "custom-thumb";
```

You can set the function for the `customThumbName` like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( "custom-thumb", setScrollBarCustomThumbStyles );
```

#### Without a Theme

If you are not using a theme, you can use `thumbFactory` to provide skins for the scroll bar's thumb:

``` code
scrollBar.thumbFactory = function():Button
{
    var button:Button = new Button();
    //skin the thumb here
    button.defaultSkin = new Image( upTexture );
    button.downSkin = new Image( downTexture );
    return button;
}
```

Alternatively, or in addition to the `thumbFactory`, you may use the `thumbProperties` to pass skins to the thumb.

``` code
scrollBar.thumbProperties.defaultSkin = new Image( upTexture );
scrollBar.thumbProperties.downSkin = new Image( downTexture );
```

In general, you should only pass skins to the scroll bar's thumb through `thumbProperties` if you need to change skins after the thumb is created. Using `thumbFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Track(s) and Layout

The scroll bar's track is made from either one or two buttons, depending on the value of the `trackLayoutMode` property. The default value of this property is `ScrollBar.TRACK_LAYOUT_MODE_SINGLE`, which creates a single track that fills the entire width and height of the scroll bar.

If we'd like to have separate buttons for both sides of the track (one for the minimum side and another for the maximum side), we can set `trackLayoutMode` to `ScrollBar.TRACK_LAYOUT_MODE_MIN_MAX`. In this mode, the width or height of each track (depending on the direction of the scroll bar) is adjusted as the thumb moves to ensure that the two tracks always meet at the center of the thumb.

`ScrollBar.TRACK_LAYOUT_MODE_SINGLE` is often best for cases where the track's appearance is mostly static. When you want down or hover states for the track, `ScrollBar.TRACK_LAYOUT_MODE_MIN_MAX` works better because the state will only change on one side of the thumb, making it more visually clear to the user what is happening.

When the value of `trackLayoutMode` is `ScrollBar.TRACK_LAYOUT_MODE_SINGLE`, the scroll bar will have a minimum track, but it will not have a maximum track. The minimum track will fill the entire region that is scrollable.

### Skinning the Minimum Track

This section only explains how to access the minimum track sub-component. Please read [How to use the Feathers Button component](button.html) for full details about the skinning properties that are available on `Button` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the `ScrollBar.DEFAULT_CHILD_NAME_MINIMUM_TRACK` style name.

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( ScrollBar.DEFAULT_CHILD_NAME_MINIMUM_TRACK, setScrollBarMinimumTrackStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
scrollBar.customMinimumTrackName = "custom-minimum-track";
```

You can set the function for the `customMinimumTrackName` like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( "custom-minimum-track", setScrollBarCustomMinimumTrackStyles );
```

#### Without a Theme

If you are not using a theme, you can use `minimumTrackFactory` to provide skins for the scroll bar's minimum track:

``` code
scrollBar.minimumTrackFactory = function():Button
{
    var button:Button = new Button();
    //skin the minimum track here
    button.defaultSkin = new Image( upTexture );
    button.downSkin = new Image( downTexture );
    return button;
}
```

Alternatively, or in addition to the `minimumTrackFactory`, you may use the `minimumTrackProperties` to pass skins to the minimum track.

``` code
scrollBar.minimumTrackProperties.defaultSkin = new Image( upTexture );
scrollBar.minimumTrackProperties.downSkin = new Image( downTexture );
```

In general, you should only pass properties to the scroll bar's minimum track through `minimumTrackProperties` if you need to change these values after the minimum track is created. Using `minimumTrackFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Skinning the Maximum Track

This section only explains how to access the maximum track sub-component. Please read [How to use the Feathers Button component](button.html) for full details about the skinning properties that are available on `Button` components.

The scroll bar's maximum track may be skinned similarly to the minimum track. The name to use with [themes](themes.html) is `ScrollBar.DEFAULT_CHILD_NAME_MAXIMUM_TRACK` or you can customize the name with `customMaximumTrackName`. If you aren't using a theme, then you can use `maximumTrackFactory` and `maximumTrackProperties`.

### Skinning the Decrement Button

This section only explains how to access the decrement button sub-component. Please read [How to use the Feathers Button component](button.html) for full details about the skinning properties that are available on `Button` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the `ScrollBar.DEFAULT_CHILD_NAME_DECREMENT_BUTTON` style name.

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( ScrollBar.DEFAULT_CHILD_NAME_DECREMENT_BUTTON, setScrollBarDecrementButtonStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
scrollBar.customDecrementButtonName = "custom-decrement-button";
```

You can set the function for the `customDecrementButtonName` like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( "custom-decrement-button", setScrollBarCustomDecrementButtonStyles );
```

#### Without a Theme

If you are not using a theme, you can use `decrementButtonFactory` to provide skins for the scroll bar's decrement button:

``` code
scrollBar.decrementButtonFactory = function():Button
{
    var button:Button = new Button();
    //skin the decrement button here
    button.defaultSkin = new Image( upTexture );
    button.downSkin = new Image( downTexture );
    return button;
}
```

Alternatively, or in addition to the `decrementButtonFactory`, you may use the `decrementButtonProperties` to pass skins to the decrement button.

``` code
scrollBar.decrementButtonProperties.defaultSkin = new Image( upTexture );
scrollBar.decrementButtonProperties.downSkin = new Image( downTexture );
```

In general, you should only pass properties to the scroll bar's decrement button through `decrementButtonProperties` if you need to change these values after the decrement button is created. Using `decrementButtonFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Skinning the Increment Button

This section only explains how to access the increment button sub-component. Please read [How to use the Feathers Button component](button.html) for full details about the skinning properties that are available on `Button` components.

The scroll bar's increment button may be skinned similarly to the decrement button. The name to use with [themes](themes.html) is `ScrollBar.DEFAULT_CHILD_NAME_INCREMENT_BUTTON` or you can customize the name with `customIncrementButtonName`. If you aren't using a theme, then you can use `incrementButtonFactory` and `incrementButtonProperties`.

## Related Links

-   [ScrollBar API Documentation](../api-reference/feathers/controls/ScrollBar.html)

-   [How to use the Feathers SimpleScrollBar Component](simple-scroll-bar.html)

For more tutorials, return to the [Feathers Documentation](index.html).


