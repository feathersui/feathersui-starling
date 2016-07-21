---
title: How to use the Feathers PageIndicator component  
author: Josh Tynjala

---
# How to use the Feathers `PageIndicator` component

The [`PageIndicator`](../api-reference/feathers/controls/PageIndicator.html) component displays a series of symbols, with one being highlighted, to show the user which index among a limited set is selected. Typically, it is paired with a [`List`](list.html) or a similar component that supports scrolling and paging. The user can tap the `PageIndicator` to either side of the selected symbol to navigate forward or backward.

<figure>
<img src="images/page-indicator.png" srcset="images/page-indicator@2x.png 2x" alt="Screenshot of a Feathers PageIndicator component" />
<figcaption>A `PageIndicator` component skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

-   [The Basics](#the-basics)

-   [Skinning a `PageIndicator`](#skinning-a-pageindicator)

## The Basics

First, let's create a `PageIndicator` control, give it a number of pages, and add it to the display list.

``` code
var pages:PageIndicator = new PageIndicator();
pages.pageCount = 5;
this.addChild( pages );
```

The number of symbols that a page indicator displays is controlled by the [`pageCount`](../api-reference/feathers/controls/PageIndicator.html#pageCount) property. You'll see that the first symbol is automatically selected. If you tap the page indicator on the right side, it will advance to the next index.

If we want to react to the selected index changing, we can add a listener for [`Event.CHANGE`](../api-reference/feathers/controls/PageIndicator.html#event:change):

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

## Skinning a `PageIndicator`

You can customize the layout of a page indicator, and you can customize the appearance of a its "normal" and "selected" symbols. For full details about which properties are available, see the [`PageIndicator` API reference](../api-reference/feathers/controls/PageIndicator.html). We'll look at a few of the most common ways of styling a list below.

### Using a theme? Some tips for customizing an individual page indicator's styles

A [theme](themes.html) does not style a component until the component initializes. This is typically when the component is added to stage. If you try to pass skins or font styles to the component before the theme has been applied, they may be replaced by the theme! Let's learn how to avoid that.

As a best practice, when you want to customize an individual component, you should add a custom value to the component's [`styleNameList`](../api-reference/feathers/core/FeathersControl.html#styleNameList) and [extend the theme](extending-themes.html). However, it's also possible to use an [`AddOnFunctionStyleProvider`](../api-reference/feathers/skins/AddOnFunctionStyleProvider.html) outside of the theme, if you prefer. This class will call a function after the theme has applied its styles, so that you can make a few tweaks to the default styles.

In the following example, we customize the page indicator's `gap` with an `AddOnFunctionStyleProvider`:

``` code
var pages:PageIndicator = new PageIndicator();
function setExtraPageIndicatorStyles( pages:PageIndicator ):void
{
    pages.gap = 10;
}
pages.styleProvider = new AddOnFunctionStyleProvider(
    pages.styleProvider, setExtraPageIndicatorStyles );
```

Our changes only affect the gap between symbols. The page indicator will continue to use the theme's other layout styles like `gap` and alignment values.

### Layout

You may set the [`direction`](../api-reference/feathers/controls/PageIndicator.html#direction) of a page indicator to [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL) or [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL). The default layout direction is horizontal. Below, we change it to vertical:

``` code
pages.direction = Direction.VERTICAL;
```

We can set other layout properies, such as the [`gap`](../api-reference/feathers/controls/PageIndicator.html#gap) between symbols, the padding around the edges, and the alignment, both [`horizontalAlign`](../api-reference/feathers/controls/PageIndicator.html#horizontalAlign) and [`verticalAlign`](../api-reference/feathers/controls/PageIndicator.html#verticalAlign):

``` code
pages.gap = 4;
pages.paddingTop = 4;
pages.paddingRight = 4;
pages.paddingBottom = 4;
pages.paddingLeft = 10;
pages.horizontalAlign = HorizontalAlign.CENTER;
pages.verticalAlign = VerticalAlign.MIDDLE;
```

### Symbol Skins

The symbols may be created using the [`normalSymbolFactory`](../api-reference/feathers/controls/PageIndicator.html#normalSymbolFactory) and [`selectedSymbolFactory`](../api-reference/feathers/controls/PageIndicator.html#selectedSymbolFactory) for normal and selected symbols, respectively. These functions may return any type of Starling display object. Below, we return Starling Images with different textures for normal and selected states:

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

## Related Links

-   [`feathers.controls.PageIndicator` API Documentation](../api-reference/feathers/controls/PageIndicator.html)