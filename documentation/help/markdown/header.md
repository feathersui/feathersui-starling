---
title: How to use the Feathers Header component  
author: Josh Tynjala

---
# How to use the Feathers `Header` component

The [`Header`](../api-reference/feathers/controls/Header.html) component displays an optional title and a region on the left and right sides for extra controls (usually buttons for navigation).

## The Basics

First, let's create a `Header` control, give it a title, and add it to the display list.

``` code
var header:Header = new Header();
header.title = "Settings";
this.addChild( header );
```

Next, we'll add a back button to the left side of the header.

``` code
var backButton:Button = new Button();
backButton.label = "Back";
backButton.addEventListener( Event.TRIGGERED, backButton_triggeredHandler );
 
header.leftItems = new <DisplayObject>[ backButton ];
```

Notice that we create our button just like we would any regular button, including adding an event listener, except we don't add it to the display list. We pass it to the [`leftItems`](../api-reference/feathers/controls/Header.html#leftItems) property in a `Vector.<DisplayObject>` and the header manages adding it as a child and keeping it in the header's layout.

We could add additional buttons or controls to the [`rightItems`](../api-reference/feathers/controls/Header.html#rightItems) region or the [`centerItems`](../api-reference/feathers/controls/Header.html#centerItems) region, if desired.

<aside class="warn">Normally, the title text renderer is displayed in the center region of the `Header`. If the `centerItems` property is used, the title will be hidden. The [`titleAlign`](../api-reference/feathers/controls/Header.html#titleAlign) property, which we'll learn how to use in a moment, may be used to reposition the title on the left or right side so that it doesn't conflict with the center items.</aside>

## Skinning a `Header`

A headers offers a number of properties that may be used to customize its appearance. For full details about what skin and style properties are available, see the [`Header` API reference](../api-reference/feathers/controls/Header.html). We'll look at a few of the most common properties below.

The header has [`backgroundSkin`](../api-reference/feathers/controls/Header.html#backgroundSkin) and [`backgroundDisabledSkin`](../api-reference/feathers/controls/Header.html#backgroundDisabledSkin) properties:

``` code
header.backgroundSkin = new Scale9Image( textures );
```

The background stretches to fill the entire width and height of the header.

By default, the header's title text renderer appears in the center. The `titleAlig` property may be set to [`Header.TITLE_ALIGN_PREFER_LEFT`](../api-reference/feathers/controls/Header.html#TITLE_ALIGN_PREFER_LEFT) to position the title on the left, if the `leftItems` property is `null`. Similarly, we can use [`Header.TITLE_ALIGN_PREFER_RIGHT`](../api-reference/feathers/controls/Header.html#TITLE_ALIGN_PREFER_RIGHT) to align the title to the right side of the header.

We don't have any items on the right side of the header, so we can align the title to the right:

``` code
header.titleAlign = Header.TITLE_ALIGN_PREFER_RIGHT;
```

Similar to many Feathers components, the `Header` provides [`gap`](../api-reference/feathers/controls/Header.html#gap) and various padding values for layouts.

``` code
header.gap = 10;
header.paddingTop = 15;
header.paddingRight = 20;
header.paddingBottom = 15;
header.paddingLeft = 20;
```

If all four padding values should be the same, you may use the [`padding`](../api-reference/feathers/controls/Header.html#padding) property to set them all at once:

``` code
header.padding = 20;
```

#### Styling a Header's title text renderer

You can customize the header's title [text renderer](text-renderers.html) in two ways. You might create a custom [`titleFactory`](../api-reference/feathers/controls/Header.html#titleFactory):

``` code
header.titleFactory = function():ITextRenderer
{
    var titleRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
 
    //styles here
    titleRenderer.textFormat = new BitmapFontTextFormat( bitmapFont );
 
    return titleRenderer;
}
```

Alternatively, you can pass in the title's styles through the header's [`titleProperties`](../api-reference/feathers/controls/Header.html#titleProperties) property:

``` code
header.titleProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
```

In general, you should only pass skins to the header's title text renderer with `titleProperties` if you need to change styles after the text renderer is created. Using `titleFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Targeting a `Header` in a theme

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

-   [`feathers.controls.Header` API Documentation](../api-reference/feathers/controls/Header.html)

For more tutorials, return to the [Feathers Documentation](index.html).


