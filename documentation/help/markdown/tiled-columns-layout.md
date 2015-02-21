---
title: Using TiledColumnsLayout in Feathers containers  
author: Josh Tynjala

---
# Using `TiledColumnsLayout` in Feathers containers

The [`TiledColumnsLayout`](../api-reference/feathers/layout/TiledColumnsLayout.html) class may be used by components that support layout, such as [`List`](list.html), [`LayoutGroup`](layout-group.html) and [`ScrollContainer`](scroll-container.html), to display items from top to bottom in multiple columns. It supports paging horizontally or vertically, and you can modify a number of useful options for the spacing and alignment.

## The Basics

First, let's create a `TiledColumnsLayout` and pass it to a [`ScrollContainer`](scroll-container.html):

``` code
var layout:TiledColumnsLayout = new TiledColumnsLayout();
 
var container:ScrollContainer = new ScrollContainer();
container.layout = layout;
this.addChild( container );
```

There are a number of simple properties that may be used to affect the layout. The most common are padding and gap.

If you don't want perfectly *square tiles*, you can set [`useSquareTiles`](../api-reference/feathers/layout/TiledColumnsLayout.html#useSquareTiles) to `false`. When this is enabled, all tiles will have the same width and height, but the width and height don't need to be equal.

The *padding* is the space around the content that the layout positions and sizes. You may set padding on each side of the container separately. Below, we set the [`paddingTop`](../api-reference/feathers/layout/TiledColumnsLayout.html#paddingTop) and [`paddingBottom`](../api-reference/feathers/layout/TiledColumnsLayout.html#paddingBottom) to `10` pixels, and we set the [`paddingLeft`](../api-reference/feathers/layout/TiledColumnsLayout.html#paddingLeft) and [`paddingRight`](../api-reference/feathers/layout/TiledColumnsLayout.html#paddingRight) to `15` pixels:

``` code
layout.paddingTop = 10;
layout.paddingRight = 15;
layout.paddingBottom = 10;
layout.paddingLeft = 15;
```

The *gap* is the space between items, both horizontally or vertically. Let's set the [`gap`](../api-reference/feathers/layout/TiledColumnsLayout.html#gap) property to `5` pixels:

``` code
layout.gap = 5;
```

We can *align* the items in the layout [horizontally](../api-reference/feathers/layout/TiledColumnsLayout.html#horizontalAlign) and [vertically](../api-reference/feathers/layout/TiledColumnsLayout.html#hverticalAlign). Horizontal alignment may be used in two cases. In the first case, it will always apply when the tiles are divided into pages. Second, it will also apply when the total width of the content (including padding and gap values) is less than or equal to the width of the container that uses the layout, regardless of whether the layout uses paging. Otherwise, the container will need to scroll. Let's adjust the alignments so that the content will be aligned to the top left:

``` code
layout.horizontalAlign = TiledColumnsLayout.HORIZONTAL_ALIGN_LEFT;
layout.verticalAlign = TiledColumnsLayout.VERTICAL_ALIGN_TOP;
```

Since items may be smaller than the tile dimensions, you can align items within their tiles separately from the alignment of the columns. We'll align the items in the horizontal center and the vertical middle of their tiles:

``` code
layout.tileHorizontalAlign = TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
layout.tileVerticalAlign = TiledColumnsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
```

## Paging

Pages can organize the content of the layout into more manageable pieces. You can enable [`paging`](../api-reference/feathers/layout/TiledColumnsLayout.html#paging) in either the horizontal direction or the vertical direction. In the example below, we'll enable horizontal paging:

``` code
layout.paging = TiledColumnsLayout.PAGING_HORIZONTAL;
```

If you set padding values on a layout that has paging enabled, each page will individually use those padding values around its edges. Similarly, horizontal alignment will apply to all pages because a page will never display more content than is visible before breaking to the next page.

On your [`ScrollContainer`](scroll-container.html) or [`List`](list.html), you should also enable page snapping:

``` code
container.snapToPages = true;
```

You can combine the component with a [`PageIndicator`](page-indicator.html) to navigate between pages and to visually display which page is currently visible.

## Virtual Tiled Columns Layout

In a [`List`](list.html) or [`GroupedList`](grouped-list.html), the layout may be *virtualized*, meaning that some items in the layout will not actually exist if they are not visible. This helps to improve performance of a scrolling list because only a limited number of item renderers will be created at any given moment. If the list's data provider is very large, a virtual layout is essential, even on desktop computers that have incredible processing power compared to mobile devices.

A virtualized layout will need as estimate about how big a "virtual" item renderer should be. You should set the [`typicalItem`](../api-reference/feathers/controls/List.html#typicalItem) property of the list to have it determine the *typical* width and height of an item renderer to use as this estimated value. If you don't pass in a typical item, the first item in the data provider is used for this estimate.

By default [`useVirtualLayout`](../api-reference/feathers/layout/TiledColumnsLayout.html#useVirtualLayout) is `true` for containers that support it. You may disable virtual layouts by setting it to `false`. When a layout is not virtualized, every single item renderer must be created by the component. If a list has thousands of items, this means that thousands of item renderers need to be created. This can lead to significant performance issues, especially on mobile. In general, you should rarely disable `useVirtualLayout`.

``` code
layout.useVirtualLayout = false;
```

The [`LayoutGroup`](layout-group.html) and [`ScrollContainer`](scroll-container.html) components never use virtual layouts.

## Related Links

-   [`feathers.layout.TiledColumnsLayout` API Documentation](../api-reference/feathers/layout/TiledColumnsLayout.html)