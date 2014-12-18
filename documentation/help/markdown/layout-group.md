---
title: How to use the Feathers LayoutGroup component  
author: Josh Tynjala

---
# How to use the Feathers `LayoutGroup` component

The `LayoutGroup` class provides a generic container for layout without scrolling. By default, you can position children manually, but you can also pass in a layout implementation to position the children automatically.

If you need scrolling, you should use the `ScrollContainer` component instead.

## The Basics

First, let's create a `LayoutGroup` container and add it to the display list:

``` code
var group:LayoutGroup = new LayoutGroup();
this.addChild( group );
```

A `LayoutGroup` works a lot like any `DisplayObjectContainer`, so you can use the standard `addChild()`, `removeChild()` and other display list manipulation functions.

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

The children of a `LayoutGroup` do not need to be Feathers UI controls. As you can see above, we've added some Starling `Quad` instances.

By default, the `LayoutGroup` will automatically resize itself to fit the area that the children occupy. We can set the width and height manually, if desired, to override this behavior:

``` code
group.width = 200;
group.height = 200;
```

You'll notice that the children are still visible. By default, clipping is disabled on `LayoutGroup` to maximize rendering performance. Set `clipContent` to `true` to enable clipping, if desired.

## Layout

We manually positioned the quads in the example code above. Instead, let's apply a [HorizontalLayout](../api-reference/feathers/layout/HorizontalLayout.html) to the children of a `LayoutGroup` to do the positioning manually:

``` code
var layout:HorizontalLayout = new HorizontalLayout();
layout.gap = 10;
group.layout = layout;
```

We can set a number of other properties on the layout too. In the case of `HorizontalLayout` (and `VerticalLayout` too), we can customize things like padding around the edges along with horizontal and vertical alignment. Other layouts may expose more or completely different properties that may be customized. Check their API documentation for complete details.

## Skinning a Layout Group

The skins for a `LayoutGroup` control are mainly the background skins. For full details about what skin and style properties are available, see the [LayoutGroup API reference](../api-reference/feathers/controls/LayoutGroup.html). We'll look at a few of the most common properties below.

### Background Skins and Basic Styles

We'll start the skinning process by giving our group appropriate background skins.

``` code
container.backgroundSkin = new Scale9Image( enabledTextures );
container.backgroundDisabledSkin = new Image( disabledTextures );
```

The `backgroundSkin` property provides the default background for when the container is enabled. The `backgroundDisabledSkin` is displayed when the group is disabled. If the `backgroundDisabledSkin` isn't provided to a disabled group, it will fall back to using the `backgroundSkin` in the disabled state.

### Targeting a LayoutGroup in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( LayoutGroup ).defaultStyleFunction = setLayoutGroupStyles;
```

If you want to customize a specific group to look different than the default, you may use a custom style name to call a different function:

``` code
group.styleNameList.add( "custom-layout-group" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( LayoutGroup )
    .setFunctionForStyleName( "custom-layout-group", setCustomLayoutGroupStyles );
```

Trying to change the group's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the group was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the group's properties directly.

## Related Links

-   [`feathers.controls.LayoutGroup` API Documentation](../api-reference/feathers/controls/LayoutGroup.html)

For more tutorials, return to the [Feathers Documentation](index.html).


