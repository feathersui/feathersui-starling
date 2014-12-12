---
title: How to use the Feathers PageIndicator component  
author: Josh Tynjala

---
# How to use the Feathers PageIndicator component

The `PageIndicator` component displays a series of symbols, with one being highlighted, to show the user which index among a limited set is selected. Typically, it is paired with a `List` or a similar component that supports paging. The user can tap the `PageIndicator` to either side of the selected symbol to navigate forward or backward.

## The Basics

First, let's create a page indicator and give it a number of symbols.

``` code
var pages:PageIndicator = new PageIndicator();
pages.pageCount = 5;
this.addChild( pages );
```

The `pageCount` property. You'll see that the first symbol is automatically selected. If you tap the page indicator on the right side, it will advance to the next index.

If we want to react to the selected index changing, we can add a listener for `Event.CHANGE`:

``` code
pages.addEventListener( Event.CHANGE, pageIndicator_changeHandler );
```

The listener might look something like this:

``` code
function pageIndicator_changeHandler( event:Event ):void
{
    var pages:PageIndicator = PageIndicator( event.currentTarget );
    trace( "selected index:", pages.selectedIndex );
}
```

## Skinning a Page Indicator

You can customize the layout of a page indicator, and you can customize the appearance of a its "normal" and "selected" symbols. For full details about what skin and style properties are available, see the [PageIndicator API reference](../api-reference/feathers/controls/PageIndicator.html). We'll look at a few of the most common properties below.

### Layout

You may set the `direction` of a page indicator to `DIRECTION_HORIZONTAL` or `DIRECTION_VERTICAL`. The default layout direction is horizontal. Below, we change it to vertical:

``` code
pages.direction = PageIndicator.DIRECTION_VERTICAL;
```

We can set other layout properies, such as the [gap between symbols](../api-reference/feathers/controls/PageIndicator.html#gap), the padding around the edges, and the alignment, both [horizontally](../api-reference/feathers/controls/PageIndicator.html#horizontalAlign) and [vertically](../api-reference/feathers/controls/PageIndicator.html#verticalAlign):

``` code
pages.gap = 4;
pages.paddingTop = 4;
pages.paddingRight = 4;
pages.paddingBottom = 4;
pages.paddingLeft = 10;
pages.horizontalAlign = PageIndicator.HORIZONTAL_ALIGN_CENTER;
pages.verticalAlign = PageIndicator.VERTICAL_ALIGN_MIDDLE;
```

### Symbol Skins

The symbols may be created using the `normalSymbolFactory` and `selectedSymbolFactory` for normal and selected symbols respectively. These functions are expected to return any Starling display objects. Below, we return Starling Images with different textures for normal and selected states:

``` code
pages.normalSymbolFactory = function():DisplayObject
{
    return new Image( normalSymbolTexture );
};
 
pages.selectedSymbolFactory = function():DisplayObject
{
    return new Image( selectedSymbolTexture );
};
```

The page indicator will automatically reuse symbols if the page count or the selected index changes.

### Targeting a PageIndicator in a theme

If you are creating a [theme](themes.html), you can specify a function for the default styles like this:

``` code
getStyleProviderForClass( PageIndicator ).defaultStyleFunction = setPageIndicatorStyles;
```

If you want to customize the style of a specific page indicator to look different than the default, you may use a custom style name to call a different function:

``` code
pages.styleNameList.add( "custom-page-indicator" );
```

You can specify the function for the custom style name like this:

``` code
getStyleProviderForClass( PageIndicator )
    .setFunctionForStyleName( "custom-page-indicator", setCustomPageIndicatorStyles );
```

Trying to change the page indicator's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the page indicator was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the page indicator's properties directly.

## Related Links

-   [PageIndicator API Documentation](../api-reference/feathers/controls/PageIndicator.html)

For more tutorials, return to the [Feathers Documentation](index.html).


