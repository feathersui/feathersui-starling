---
title: Slide Show Layout in Feathers containers   
author: Josh Tynjala

---
# Using `SlideShowLayout` in Feathers containers

The [`SlideShowLayout`](../api-reference/feathers/layout/SlideShowLayout.html) class may be used by containers that support layout, such as [`List`](list.html) and [`ScrollContainer`](scroll-container.html), to display one item at a time and scroll page by page.

## The Basics

First, let's create a slide show layout and pass it to a [`ScrollContainer`](scroll-container.html):

``` actionscript
var layout:SlideShowLayout = new SlideShowLayout();
 
var container:ScrollContainer = new ScrollContainer();
container.layout = layout;
this.addChild( container );
```

There are a number of simple properties that may be used to affect positioning and sizing of items in the layout. Let's look at some of the most common.

### Direction

A `SlideShowLayout` positions items horizontally, from left to right, by default. Alternatively, you can tell the layout to position items vertically, from top to bottom, instead:

``` actionscript
layout.direction = Direction.VERTICAL;
```

The [`direction`](../api-reference/feathers/layout/SlideShowLayout.html#direction) property may be set to [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL) or [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL).

### Spacing

The *padding* is the minimum space around the edges of each item in container. Let's set the [`padding`](../api-reference/feathers/layout/SlideShowLayout.html#padding) property to `12` pixels:

``` actionscript
layout.padding = 12;
```

If needed, the padding on each side of the container may be set separately. Below, we set the [`paddingTop`](../api-reference/feathers/layout/SlideShowLayout.html#paddingTop) and [`paddingBottom`](../api-reference/feathers/layout/SlideShowLayout.html#paddingBottom) properties to `10` pixels, and we set the [`paddingLeft`](../api-reference/feathers/layout/SlideShowLayout.html#paddingLeft) and [`paddingRight`](../api-reference/feathers/layout/SlideShowLayout.html#paddingRight) to `15` pixels:

``` actionscript
layout.paddingTop = 10;
layout.paddingRight = 15;
layout.paddingBottom = 10;
layout.paddingLeft = 15;
```

### Alignment

We can *align* each item within its own page using the [`horizontalAlign`](../api-reference/feathers/layout/SlideShowLayout.html#horizontalAlign) and [`verticalAlign`](../api-reference/feathers/layout/SlideShowLayout.html#verticalAlign) properties. Alignment only applies when the item does not fill the entire width or height of the page.

Let's adjust the alignments so that the content will be aligned to the top and left:

``` actionscript
layout.horizontalAlign = HorizontalAlign.LEFT;
layout.verticalAlign = VerticalAlign.TOP;
```

## Related Links

-   [`feathers.layout.SlideShowLayout` API Documentation](../api-reference/feathers/layout/SlideShowLayout.html)