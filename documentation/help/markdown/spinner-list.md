---
title: How to use the Feathers SpinnerList component  
author: Josh Tynjala

---
# How to use the Feathers `SpinnerList` component

The [`SpinnerList`](../api-reference/feathers/controls/SpinnerList.html) class extends the [`List`](.html) component to allow the user to change the selected item by scrolling. Typically, the selected item is positioned in the center of the list, and it may be visually highlighted in some way. A `SpinnerList` will often loop infinitely, repeating its items as the user scrolls.

## The Basics

First, let's create a `SpinnerList` control and add it to the display list:

``` code
var list:SpinnerList = new SpinnerList();
this.addChild( list );
```

## Skinning an `SpinnerList`

A spinner list provides a number of properties to customize its appearance. For full details about what skin and style properties are available, see the [`SpinnerList` API reference](../api-reference/feathers/controls/SpinnerList.html). We'll look at a few of the most common properties below.

### Targeting an `SpinnerList` in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( SpinnerList ).defaultStyleFunction = setSpinnerListStyles;
```

If you want to customize a specific `SpinnerList` to look different than the default, you may use a custom style name to call a different function:

``` code
list.styleNameList.add( "custom-spinner-list" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( SpinnerList )
    .setFunctionForStyleName( "custom-spinner-list", setCustomSpinnerListStyles );
```

Trying to change the spinner list's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the spinner list was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the spinner list's properties directly.

## Related Links

-   [`feathers.controls.SpinnerList` API Documentation](../api-reference/feathers/controls/SpinnerList.html)

-   [How to Use the Feathers `List` Component](list.html)

For more tutorials, return to the [Feathers Documentation](index.html).


