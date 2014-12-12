---
title: Using TiledRowsLayout in Feathers containers  
author: Josh Tynjala

---
# Using TiledRowsLayout in Feathers containers

The `TiledRowsLayout` class may be used by components that support layout, such as `List` and `ScrollContainer`, to display items from left to right in multiple rows. It supports paging horizontally or vertically, and you can modify a number of useful options for the spacing and alignment.

## The Basics

Let's create a tiled rows layout and add it to a [scroll container](scroll-container.html):

``` code
var layout:TiledRowsLayout = new TiledRowsLayout();
 
var container:ScrollContainer = new ScrollContainer();
container.layout = layout;
this.addChild( container );
```

There are a number of simple properties that may be used to affect the layout. The most common are padding and gap.

If you don't want perfectly *square tiles*, you can set `useSquareTiles` to `false`. When this is enabled, all tiles will have the same width and height, but the width and height don't need to be equal.

The *padding* is the space around the content that the layout positions and sizes. You may set padding on each side of the container separately. Below, we make the top and bottom padding 10 pixels and the left and right padding 15 pixels:

``` code
layout.paddingTop = 10;
layout.paddingRight = 15;
layout.paddingBottom = 10;
layout.paddingLeft = 15;
```

The *gap* is the space between items, both horizontally or vertically. Let's set the gap to 5 pixels:

``` code
layout.gap = 5;
```

We can *align* the items in the layout horizontally and vertically. Vertical alignment may be used in two cases. In the first case, it will always apply when the tiles are divided into pages. Second, it will apply when the total height of the content (including padding and gap values) is less than or equal to the height of the container that uses the layout, regardless of whether the layout uses paging. Otherwise, the container will need to scroll. Let's adjust the alignments so that the content will be aligned to the top left:

``` code
layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
layout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
```

Since items may be smaller than the tile dimensions, you can align items within their tiles separately from the alignment of the rows. We'll align the items in the horizontal center and the vertical middle of their tiles:

``` code
layout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
layout.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
```

## Paging

Pages can organize the content of the layout into more manageable pieces. You can enable `paging` in either the horizontal direction or the vertical direction. In the example below, we'll enable horizontal paging:

``` code
layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
```

If you set padding values on a layout that has paging enabled, each page will individually use those padding values around its edges. Similarly, vertical alignment will apply to all pages because a page will never display more content than is visible before breaking to the next page.

On your `ScrollContainer` or `List`, you should also enable page snapping:

``` code
container.snapToPages = true;
```

You can combine the `ScrollContainer` with a `PageIndicator` to navigate between pages and to visually display which page is currently visible.

## Virtual Tiled Rows Layout

In a `List` or `GroupedList`, the layout may be *virtualized*, meaning that some items in the layout will not actually exist if they are not visible. This helps to improve performance of a scrolling list because only a limited number of item renderers will be created at any given moment. If the list's data provider is very large, a virtual layout is essential, even on desktop computers that have incredible processing power compared to mobile devices.

A virtualized layout will need as estimate about how big a "virtual" item renderer should be. You should set the `typicalItem` property of the list to have it determine the *typical* width and height of an item renderer to use as this estimated value. If you don't pass in a typical item, the first item in the data provider is used for this estimate.

You should not manually set the `typicalItemWidth` and `typicalItemHeight` properties on a `TiledRowsLayout`. If you do, the list will simply replace your values with its own values calculated from its `typicalItem`!

By default `useVirtualLayout` is `true`. You may disable virtual layouts by setting it to `false`. When a layout is not virtualized, every single item renderer must be created by the component. If a list has thousands of items, this means that thousands of item renderers need to be created. This can lead to significant performance issues, especially on mobile. In general, you should rarely disable `useVirtualLayout`.

``` code
layout.useVirtualLayout = false;
```

The `LayoutGroup` and `ScrollContainer` components never use virtual layouts.

## Related Links

-   [TiledRowsLayout API Documentation](../api-reference/feathers/layout/TiledRowsLayout.html)

For more tutorials, return to the [Feathers Documentation](index.html).


