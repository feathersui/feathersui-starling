---
title: Using WaterfallLayout in Feathers containers  
author: Josh Tynjala

---
# Using `WaterfallLayout` in Feathers containers

The [`WaterfallLayout`](../api-reference/feathers/layout/WaterfallLayout.html) class may be used by components that support layout, such as [`List`](list.html), [`LayoutGroup`](layout-group.html) and [`ScrollContainer`](scroll-container.html), to display items with multiple columns of equal width where items may have variable heights. Items are added to the layout in order, but they may be added to any of the available columns. The layout selects the column where the column's height plus the item's height will result in the smallest possible total height.

`WaterfallLayout` supports a number of useful options for adjusting the number of columns, the spacing between items, and the alignment of the columns.

## The Basics

First, let's create a `WaterfallLayout` and pass it to a [`ScrollContainer`](scroll-container.html):

``` code
var layout:WaterfallLayout = new WaterfallLayout();
 
var container:ScrollContainer = new ScrollContainer();
container.layout = layout;
this.addChild( container );
```

There are a number of simple properties that may be used to affect the layout. The most common are padding and gap.

The *padding* is the space around the content that the layout positions and sizes. You may set padding on each side of the container separately. Below, we set the [`paddingTop`](../api-reference/feathers/layout/WaterfallLayout.html#paddingTop) and [`paddingBottom`](../api-reference/feathers/layout/WaterfallLayout.html#paddingBottom) to `10` pixels, and we set the [`paddingLeft`](../api-reference/feathers/layout/WaterfallLayout.html#paddingLeft) and [`paddingRight`](../api-reference/feathers/layout/WaterfallLayout.html#paddingRight) to `15` pixels:

``` code
layout.paddingTop = 10;
layout.paddingRight = 15;
layout.paddingBottom = 10;
layout.paddingLeft = 15;
```

The *gap* is the space between items. Let's set the [`gap`](../api-reference/feathers/layout/WaterfallLayout.html#gap) property to `5` pixels:

``` code
layout.gap = 5;
```

If needed, we can set the horizontal and vertical gaps separately. We'll set the [`horizontalGap`](../api-reference/feathers/layout/WaterfallLayout.html#horizontalGap) property to `4` pixels and the [`verticalGap`](../api-reference/feathers/layout/WaterfallLayout.html#verticalGap) property to `6` pixels:

``` code
layout.horizontalGap = 4;
layout.verticalGap = 6;
```

We can *align* the items in the layout [horizontally](../api-reference/feathers/layout/WaterfallLayout.html#horizontalAlign). Let's adjust the horizontal alignment so that the content will be pulled to the right:

``` code
layout.horizontalAlign = WaterfallLayout.HORIZONTAL_ALIGN_RIGHT;
```

## Related Links

-   [`feathers.layout.WaterfallLayout` API Documentation](../api-reference/feathers/layout/WaterfallLayout.html)