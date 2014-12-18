---
title: Anchor Layout in Feathers containers   
author: Josh Tynjala

---
# Using `AnchorLayout` in Feathers containers

The `AnchorLayout` class may be used by containers that support layout, such as `LayoutGroup` and `ScrollContainer`, to constrain, or *anchor*, the edges of a component to the edges of its parent container. `AnchorLayout` is often used for *fluid* layouts that can automatically adjust themselves as the container is resized. For example, you might use it to display one or more sidebars next to a main view in an application. The main view can be anchored to the sidebars and the container to fill the remaining space.

`AnchorLayout` also provides the ability to anchor a component relative to the edges of its siblings in the parent container.

Supported anchors include `top`, `right`, `bottom`, `left`, `horizontalCenter`, and `verticalCenter`.

`AnchorLayout` is not officially supported by `List`, `GroupedList`, and other controls that support data providers and layouts. This layout is meant for more generic containers like `LayoutGroup` and `ScrollContainer`.

## Anchoring Relative to the Parent Container

Let's start out with the basic case of anchoring a component inside of its parent container. First we'll create a `ScrollContainer` and add a `Button` as a child:

``` code
var container:ScrollContainer = new ScrollContainer();
container.width = 400;
container.height = 400;
this.addChild( container );
 
var button:Button = new Button();
button.label = "Anchored Button";
container.addChild( button );
```

Since the container has no layout by default, the standard `x` and `y` properties will be used, so the button will appear at the top left. Let's give an `AnchorLayout` a try:

``` code
container.layout = new AnchorLayout();
```

Our anchors aren't stored in the `AnchorLayout`. Since each child in the container will be positioned separately, we associate `AnchorLayoutData` with each child using the `layoutData` property on any `ILayoutDisplayObject`:

``` code
var layoutData:AnchorLayoutData = new AnchorLayoutData();
layoutData.horizontalCenter = 0;
layoutData.verticalCenter = 0;
button.layoutData = layoutData;
```

With the code above, we center the button both horizontally or vertically inside the container. When the container resizes, the button's position will be updated so that it stays in the center. You can test this, if you like, by resizing the container when the button is triggered:

``` code
button.addEventListener( Event.TRIGGERED, function( event:Event ):void
{
    container.width = 500;
    container.height = 500;
}
```

`AnchorLayout` isn't simply for centering objects in a container. Let's try a couple of other anchors instead:

``` code
var layoutData:AnchorLayoutData = new AnchorLayoutData();
layoutData.right = 10;
layoutData.bottom = 10;
button.layoutData = layoutData;
```

In this case, we want to position the button 10 pixels from the right edge of the container and 10 pixels from the bottom edge. If the container is resized, the button will always be positioned 10 pixels from the bottom and from the right.

Let's say that we want the button to always fill the width of the container. We can anchor it to the left edge and the right edge at the same time:

``` code
var layoutData:AnchorLayoutData = new AnchorLayoutData();
layoutData.left = 10;
layoutData.right = 10;
layoutData.bottom = 10;
```

Now, when the container is resized, the button is always 10 pixels from the left edge of the container and 10 pixels from the right edge of the container. This means that that the button will be resized by the `AnchorLayout` whenever the width of the container changes.

## Anchor Relative to Siblings

Let's add a second button and anchor it both the parent container and to the first button.

``` code
var button2:Button = new Button();
button2.label = "Another Button";
container.addChild( button2 );
 
var layoutData2:AnchorLayoutData = new AnchorLayoutData();
layoutData2.right = 10;
layoutData2.bottom = 10;
layoutData2.bottomAnchorDisplayObject = button;
button2.layoutData = layoutData2;
```

Similar to our first example above, we've anchored the second button's bottom and right edges. However, as you can see, we've also specified a `bottomAnchorDisplayObject`. This tells the `AnchorLayout` to anchor our second button to the first button instead of to the parent container. When we resize the container, the second button's right edge will always be 10 pixels from the container's right edge and its bottom edge will always be 10 pixels from the first button.

Let's expand this example in the same way that we did above. We want the second button to fill the remaining height in the container, above the first button.

``` code
var layoutData2:AnchorLayoutData = new AnchorLayoutData();
layoutData2.right = 10;
layoutData2.bottom = 10;
layoutData2.bottomAnchorDisplayObject = button;
layoutData2.top = 10;
```

If we anchor the top edge of our second button to the top edge of the container, the second button's height will be updated as we resize the container. The second button's bottom edge will remain 10 pixels away from the first button.

## Related Links

-   [`feathers.layout.AnchorLayout` API Documentation](../api-reference/feathers/layout/AnchorLayout.html)

For more tutorials, return to the [Feathers Documentation](index.html).


