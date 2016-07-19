---
title: How to use the Feathers LayoutGroup component  
author: Josh Tynjala

---
# How to use the Feathers `LayoutGroup` component

The [`LayoutGroup`](../api-reference/feathers/controls/LayoutGroup.html) class provides a generic container for layout, without scrolling. By default, you can position children manually, but you can also pass in a layout implementation, like [`HorizontalLayout`](horizontal-layout.html) or [`VerticalLayout`](vertical-layout.html) to position the children automatically.

<aside class="info">If you need scrolling, you should use the [`ScrollContainer`](scroll-container.html) component instead.</aside>

-   [The Basics](#the-basics)

-   [Layout](#layout)

-   [Skinning a `LayoutGroup`](#skinning-a-layoutgroup)

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

The `LayoutGroup` control are mainly the background skins. For full details about which properties are available, see the [`LayoutGroup` API reference](../api-reference/feathers/controls/LayoutGroup.html). We'll look at a few of the most common ways of styling a `LayoutGroup` below.

### Using a theme? Some tips for customizing styles of an individual `LayoutGroup`

A [theme](themes.html) does not style a component until the component initializes. This is typically when the component is added to stage. If you try to pass skins or font styles to the component before the theme has been applied, they may be replaced by the theme! Let's learn how to avoid that.

As a best practice, when you want to customize an individual component, you should add a custom value to the component's [`styleNameList`](../api-reference/feathers/core/FeathersControl.html#styleNameList) and [extend the theme](extending-themes.html). However, it's also possible to use an [`AddOnFunctionStyleProvider`](../api-reference/feathers/skins/AddOnFunctionStyleProvider.html) outside of the theme, if you prefer. This class will call a function after the theme has applied its styles, so that you can make a few tweaks to the default styles.

In the following example, we customize the group's `backgroundSkin` with an `AddOnFunctionStyleProvider`:

``` code
var group:LayoutGroup = new LayoutGroup();
function setExtraLayoutGroupStyles( group:LayoutGroup ):void
{
	var skin:Image = new Image( texture );
	skin.scale9Grid = new Rectangle( 2, 1, 3, 6 );
	group.backgroundSkin = skin;
}
group.styleProvider = new AddOnFunctionStyleProvider(
	group.styleProvider, setExtraLayoutGroupStyles );
```

Our changes only affect the background skin. The group will continue to use any other styles from the theme.

### Background skins

As we saw above, we can give the `LayoutGroup` a background skin that stretches to fill the entire width and height of the group. In the following example, we pass in a `starling.display.Image`, but the skin may be any Starling display object:

``` code
var skin:Image = new Image( texture );
skin.scale9Grid = new Rectangle( 2, 2, 1, 6 );
group.backgroundSkin = skin;
```

It's as simple as setting the [`backgroundSkin`](../api-reference/feathers/controls/LayoutGroup.html#backgroundSkin) property.

We can give the `LayoutGroup` a different background when it is disabled:

``` code
var skin:Image = new Image( texture );
skin.scale9Grid = new Rectangle( 1, 3, 2, 6 );
group.backgroundDisabledSkin = skin;
```

The [`backgroundDisabledSkin`](../api-reference/feathers/controls/LayoutGroup.html#backgroundDisabledSkin) is displayed when the group is disabled. If the `backgroundDisabledSkin` isn't provided to a disabled group, it will fall back to using the `backgroundSkin` in the disabled state.

## Related Links

-   [`feathers.controls.LayoutGroup` API Documentation](../api-reference/feathers/controls/LayoutGroup.html)