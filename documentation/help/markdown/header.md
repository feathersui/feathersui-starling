---
title: How to use the Feathers Header component  
author: Josh Tynjala

---
# How to use the Feathers Header component

The `Header` component displays an optional title and a region on the left and right sides for extra controls (usually buttons for navigation).

## The Basics

Let's start by creating a header with a title.

``` code
var header:Header = new Header();
header.title = "Settings";
this.addChild( header );
```

Next, we'll add a back button to the `left items` region.

``` code
var backButton:Button = new Button();
backButton.label = "Back";
backButton.addEventListener( Event.TRIGGERED, backButton_triggeredHandler );
 
header.leftItems = new <DisplayObject>[ backButton ];
```

Notice that we create our button just like we would any regular button, including adding an event listener, except we don't add it to the display list. We pass it to the `leftItems` property in a `Vector.<DisplayObject>` and the header manages adding it as a child and keeping it in the header's layout.

We could add additional buttons or controls to the [right items](../api-reference/feathers/controls/Header.html#rightItems) region, if we wanted.

## Skinning a Header

A headers offers a number of properties that may be used to customize its appearance. For full details about what skin and style properties are available, see the [Header API reference](../api-reference/feathers/controls/Header.html). We'll look at a few of the most common properties below.

The header has a `backgroundSkin` and `backgroundDisabledSkin`. If the header is disabled, the `backgroundDisabledSkin` will be used. However, if the `backgroundDisabledSkin` isn't provided, the header will fall back to the `backgroundSkin`.

``` code
header.backgroundSkin = new Scale9Image( textures );
```

The background stretches to fill the entire width and height of the header.

By default the header's title appears in the center. There are special alignment options named `TITLE_ALIGN_PREFER_LEFT` and `TITLE_ALIGN_PREFER_RIGHT` which will align the title to the left or right side of the header, but *only* when there are no items on the left or right side respectively.

In this case, we don't have any items on the right, so we can align the title to the right, if we'd like:

``` code
header.titleAlign = Header.TITLE_ALIGN_PREFER_RIGHT;
```

Similar to many Feathers components, the `Header` provides gap and padding values for layouts.

``` code
header.gap = 10;
header.paddingTop = 15;
header.paddingRight = 20;
header.paddingBottom = 15;
header.paddingLeft = 20;
```

If all four padding values should be the same, you may use the `padding` property to set them all at once:

``` code
header.padding = 20;
```

#### Styling a Header's Title

You can customize the header's title in two ways. You might create a custom title [text renderer](text-renderers.html) factory:

``` code
header.titleFactory = function():ITextRenderer
{
    var titleRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
 
    //styles here
    titleRenderer.textFormat = new BitmapFontTextFormat( bitmapFont );
 
    return titleRenderer;
}
```

Alternatively, you can pass in the title's styles through the header's `titleProperties` property:

``` code
header.titleProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
```

Using a custom factory is better for performance and it will allow you to use code hinting in your IDE, if available.

### Targeting a Header in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( Header ).defaultStyleFunction = setHeaderStyles;
```

If you want to customize a specific header to look different than the default, you may use a custom style name to call a different function:

``` code
header.styleNameList.add( "custom-header" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( Header )
    .setFunctionForStyleName( "custom-header", setCustomHeaderStyles );
```

Trying to change the header's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the header was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the header's properties directly.

## Related Links

-   [Header API Documentation](../api-reference/feathers/controls/Header.html)

For more tutorials, return to the [Feathers Documentation](index.html).


