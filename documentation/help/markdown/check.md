---
title: How to use the Feathers Check component  
author: Josh Tynjala

---
# How to use the Feathers `Check` component

The `Check` component is actually a [`ToggleButton`](toggle-button.html) component, but it is given a different visual appearance.

## The Basics

A `Check` component can be created much like a `ToggleButton`:

``` code
var check:Check = new Check();
check.label = "Click Me";
check.isSelected = true;
this.addChild( check );
```

See [How to use the Feathers `ToggleButton` component](toggle-button.html) for a more detailed look at this component's capabilities.

## Skinning a Check

A skinned `Check` component usually has no background (or a transparent one) and the touch states of the check are displayed through the icon skins. For full details about what skin and style properties are available, see the [Check API reference](../api-reference/feathers/controls/Check.html).

As mentioned above, `Check` is a subclass of `Button`. For more detailed information about the skinning options available to `Check`, see [How to use the Feathers `ToggleButton` component](toggle-button.html).

### Targeting a Check in a theme

If you are creating a [theme](themes.html), you can specify a function for the default styles like this:

``` code
getStyleProviderForClass( Check ).defaultStyleFunction = setCheckStyles;
```

If you want to customize a specific check to look different than the default, you may use a custom style name to call a different function:

``` code
check.styleNameList.add( "custom-check" );
```

You can specify the function for the custom style name like this:

``` code
getStyleProviderForClass( Check )
    .setFunctionForStyleName( "custom-check", setCustomCheckStyles );
```

Trying to change the check's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the check was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the check's properties directly.

## Related Links

-   [`feathers.controls.Check` API Documentation](../api-reference/feathers/controls/Check.html)

-   [How to use the Feathers `ToggleButton` component](toggle-button.html)

For more tutorials, return to the [Feathers Documentation](index.html).


