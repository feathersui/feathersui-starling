---
title: How to use the Feathers LayoutGroup component  
author: Josh Tynjala

---
# How to use the Feathers `LayoutGroup` component

The [`LayoutGroup`](../api-reference/feathers/controls/LayoutGroup.html) class provides a generic container for layout, without scrolling. By default, you can position children manually, but you can also pass in a layout implementation, like [`HorizontalLayout`](horizontal-layout.html) or [`VerticalLayout`](vertical-layout.html) to position the children automatically.

<aside class="info">If you need scrolling, you should use the [`ScrollContainer`](scroll-container.html) component instead.</aside>

## The Basics

First, let's create a `LayoutGroup` container and add it to the display list:

``` code
var group:LayoutGroup = new LayoutGroup();
this.addChild( group );
```

A `LayoutGroup` works a lot like any [`DisplayObjectContainer`](http://doc.starling-framework.org/core/starling/display/DisplayObjectContainer.html), so you can use the standard `addChild()`, `removeChild()` and other display list manipulation functions.

``` code
var xPosition:Number = 0;
for(var i:int = 0; i < 5; i++)
{
    var quad:Quad = new Quad( 100, 100, 0xff0000 );
    quad.x = xPosition;
    group.addChild( quad );
    xPosition += quad.width + 10;
}
```

The children of a `LayoutGroup` do not need to be Feathers UI controls. As you can see above, we've added some Starling [`Quad`](http://doc.starling-framework.org/core/starling/display/Quad.html) instances.

By default, the `LayoutGroup` will automatically resize itself to fit the area that the children occupy. We can set the width and height manually, if desired, to override this behavior:

``` code
group.width = 200;
group.height = 200;
```

You'll notice that the children are still visible. By default, clipping is disabled on `LayoutGroup` to maximize rendering performance. Set the [`clipContent`](../api-reference/feathers/controls/LayoutGroup.html#clipContent) property to `true` to enable clipping, if desired.

## Layout

We manually positioned the quads in the example code above. Instead, let's pass a [`HorizontalLayout`](../api-reference/feathers/layout/HorizontalLayout.html) to the [`layout`](../api-reference/feathers/controls/LayoutGroup.html#layout) property of the `LayoutGroup`. This layout will calculate the positioning of children for us automatically:

``` code
var layout:HorizontalLayout = new HorizontalLayout();
layout.gap = 10;
group.layout = layout;
```

Here, we've set the [`gap`](../api-reference/feathers/layout/HorizontalLayout.html#gap) property, but `HorizontalLayout` provides many more useful features. See [How to use `HorizontalLayout` with Feathers containers](horizontal-layout.html) for complete details.

<aside class="info">Feathers comes with a number of different [layouts](index.html#layouts), in addition to `HorizontalLayout`.</aside>

## Skinning a `LayoutGroup`

The skins for a `LayoutGroup` control are mainly the background skins. For full details about what skin and style properties are available, see the [`LayoutGroup` API reference](../api-reference/feathers/controls/LayoutGroup.html). We'll look at a few of the most common properties below.

### Background Skins and Basic Styles

We'll start the skinning process by giving our group appropriate background skins.

``` code
container.backgroundSkin = new Image( enabledTexture );
container.backgroundDisabledSkin = new Image( disabledTexture );
```

The [`backgroundSkin`](../api-reference/feathers/controls/LayoutGroup.html#backgroundSkin) property provides the default background for when the container is enabled. The [`backgroundDisabledSkin`](../api-reference/feathers/controls/LayoutGroup.html#backgroundDisabledSkin) is displayed when the group is disabled.

## Related Links

-   [`feathers.controls.LayoutGroup` API Documentation](../api-reference/feathers/controls/LayoutGroup.html)