---
title: How to use the Feathers SimpleScrollBar component  
author: Josh Tynjala

---
# How to use the Feathers `SimpleScrollBar` Component

The `SimpleScrollBar` component displays a numeric value between a minimum and maximum. The value may be changed by sliding a thumb along an invisible track in either a horizontal or a vertical direction. This component is designed to be used with components that support scrolling, like [`ScrollContainer`](scroll-container.html) and [`List`](list.html).

<aside class="info">Additionally, Feathers offers a [`ScrollBar`](scroll-bar.html) component. This is a desktop-style scroll bar that offers a thumb, track, and two buttons for adjusting the value by a small step.</aside>

## The Basics

You can use the `SimpleScrollBar` with a class like `ScrollContainer` or `List` by instantiating it in the `horizontalScrollBarFactory` or the `verticalScrollBarFactory`.

``` code
list.horizontalScrollBarFactory = function():IScrollBar
{
    return new SimpleScrollBar();
}
```

The container will automatically handle setting properties like [`direction`](../api-reference/feathers/controls/ScrollBar.html#direction), [`minimum`](../api-reference/feathers/controls/ScrollBar.html#minimum), [`maximum`](../api-reference/feathers/controls/ScrollBar.html#maximum), and [`step`](../api-reference/feathers/controls/ScrollBar.html#step), and it will automatically listen for [`Event.CHANGE`](../api-reference/feathers/controls/ScrollBar.html#event:change) to know when the [`value`](../api-reference/feathers/controls/ScrollBar.html#value) property changes.

<aside class="info">If, for some reason, you want to use a `SimpleScrollBar` outside of a container, the values like `minimum`, `maximum`, `step` and `value` that are normally handled by the container work similarly to the same properties on a [`Slider`](slider.html) component.</aside>

## Skinning a `SimpleScrollBar`

The `SimpleScrollBar` has one part that may be skinned, its thumb. A SimpleScrollBar's track is invisible. That's where the "simple" part comes from. For full details about what skin and style properties are available, see the [`SimpleScrollBar` API reference](../api-reference/feathers/controls/SimpleScrollBar.html).

### Targeting a `SimpleScrollBar` in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( SimpleScrollBar ).defaultStyleFunction = setSimpleScrollBarStyles;
```

If you want to customize a specific simple scroll bar to look different than the default, you may use a custom style name to call a different function:

``` code
scrollBar.styleNameList.add( "custom-simple-scroll-bar" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( SimpleScrollBar )
    .setFunctionForStyleName( "custom-simple-scroll-bar", setCustomSimpleScrollBarStyles );
```

Trying to change the scroll bar's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the scroll bar was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the simple scroll bar's properties directly.

### Skinning the Thumb

This section only explains how to access the thumb sub-component. Please read [How to use the Feathers `Button` component](button.html) for full details about the skinning properties that are available on `Button` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the `ScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB` style name.

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( ScrollBar.DEFAULT_CHILD_STYLE_NAME_THUMB, setScrollBarThumbStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
scrollBar.customThumbStyleName = "custom-thumb";
```

You can set the function for the `customThumbStyleName` like this:

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

## Related Links

-   [`feathers.controls.SimpleScrollBar` API Documentation](../api-reference/feathers/controls/SimpleScrollBar.html)

For more tutorials, return to the [Feathers Documentation](index.html).


