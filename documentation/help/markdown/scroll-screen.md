---
title: How to use the Feathers ScrollScreen component  
author: Josh Tynjala

---
# How to use the Feathers `ScrollScreen` component

The `ScrollScreen` component is meant to be a base class for custom screens to be displayed by `StackScreenNavigator` and `ScreenNavigator`. `ScrollScreen` is based on the `ScrollContainer` component, and it provides scrolling and optional layout.

## Skinning a `ScrollScreen`

For full details about what skin and style properties are available, see the [`ScrollScreen` API reference](../api-reference/feathers/controls/ScrollScreen.html).

As mentioned above, `ScrollScreen` is a subclass of `ScrollContainer`. For more detailed information about the skinning options available to `ScrollScreen`, see [How to use the `ScrollContainer` component](button.html).

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


