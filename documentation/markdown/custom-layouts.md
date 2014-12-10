# Introduction to Custom Layouts for Feathers Components

Several Feathers components support the ability to customize layouts. [Several layouts](start.html#layouts) are provided by Feathers out of the box. However, if those don't quite fit your needs, you can create custom layouts by implementing the `ILayout` interface. This interface provides the most basic API required to use a custom layout with a Feathers component. A number of other interfaces are available with more advanced functionality, and we'll look at those below.

## A Simple Example Layout

Let's start by looking at the complete source code for a custom layout. Don't worry, we'll look at more closely it in smaller, digestible chunks in a moment.

This custom layout will be similar to `VerticalLayout`, but it won't offer so many options available to the built-in version. This `SimpleVerticalLayout` class will position items from top to bottom, aligned to the top and left. We'll offer one customizable property, a gap between items, to show how to implement something like that.

``` code
package feathersx.layout
{
    import feathers.core.IFeathersControl;
    import feathers.layout.ILayout;
    import feathers.layout.LayoutBoundsResult;
    import feathers.layout.ViewPortBounds;
 
    import flash.geom.Point;
 
    import starling.display.DisplayObject;
    import starling.events.Event;
    import starling.events.EventDispatcher;
 
    public class SimpleVerticalLayout extends EventDispatcher implements ILayout
    {
        public function SimpleVerticalLayout()
        {
        }
 
        protected var _gap:Number = 0;
 
        public function get gap():Number
        {
            return this._gap;
        }
 
        public function set gap(value:Number):void
        {
            if(this._gap == value)
            {
                return;
            }
            this._gap = value;
            this.dispatchEventWith(Event.CHANGE);
        }
 
        public function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
        {
            // initialize the view port's position and dimensions
            var startX:Number = 0;
            var startY:Number = 0;
            var explicitWidth:Number = NaN;
            var explicitHeight:Number = NaN;
            var minWidth:Number = 0;
            var minHeight:Number = 0;
            var maxWidth:Number = Number.POSITIVE_INFINITY;
            var maxHeight:Number = Number.POSITIVE_INFINITY;
            if(viewPortBounds)
            {
                startX = viewPortBounds.x;
                startY = viewPortBounds.y;
                explicitWidth = viewPortBounds.explicitWidth;
                explicitHeight = viewPortBounds.explicitHeight;
                minWidth = viewPortBounds.minWidth;
                minHeight = viewPortBounds.minHeight;
                maxWidth = viewPortBounds.maxWidth;
                maxHeight = viewPortBounds.maxHeight;
            }
 
            // loop through the items and position them
            var positionY:Number = startY;
            var maxItemWidth:Number = 0;
            var itemCount:int = items.length;
            for(var i:int = 0; i < itemCount; i++)
            {
                var item:DisplayObject = items[i];
                // skip items that aren't included in the layout
                var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
                if(layoutItem && !layoutItem.includeInLayout)
                {
                    continue;
                }
                // special case for Feathers components
                if(item is IFeathersControl)
                {
                    IFeathersControl(item).validate();
                }
                item.x = startX;
                item.y = positionY;
                positionY += item.height + this._gap;
 
                // used for the final content width below
                maxItemWidth = Math.max(maxItemWidth, item.width);
            }
 
            // used for the final content height below
            positionY -= (startY + this._gap);
 
            // prepare the result object and return it
            if(!result)
            {
                result = new LayoutBoundsResult();
            }
            var viewPortWidth:Number = explicitWidth;
            var viewPortHeight:Number = explicitHeight;
            if(isNaN(viewPortWidth))
            {
                viewPortWidth = Math.max(minWidth, Math.min(maxWidth, maxItemWidth));
            }
            if(isNaN(explicitHeight))
            {
                viewPortHeight = Math.max(minHeight, Math.min(maxHeight, positionY));
            }
            var contentWidth:Number = Math.max(maxItemWidth, viewPortWidth);
            var contentHeight:Number = Math.max(positionY, viewPortHeight);
            result.viewPortWidth = viewPortWidth;
            result.viewPortHeight = viewPortHeight;
            result.contentWidth = contentWidth;
            result.contentHeight = contentHeight;
            return result;
        }
 
        public function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, viewPortWidth:Number, viewPortHeight:Number, result:Point = null):Point
        {
            // loop through the items to calculate the scroll position
            var positionY:Number = 0;
            for(var i:int = 0; i < index; i++)
            {
                var item:DisplayObject = items[i];
                var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
                if(layoutItem && !layoutItem.includeInLayout)
                {
                    continue;
                }
                if(item is IFeathersControl)
                {
                    IFeathersControl(item).validate();
                }
                positionY += item.height + this._gap;
            }
 
            // prepare the result object and return it
            if(!result)
            {
                result = new Point();
            }
            result.x = 0;
            result.y = positionY;
            return result;
        }
    }
}
```

We'll go into the low-level details in a moment, but let's look at a couple of important parts of the `SimpleVerticalLayout` class first.

-   The class implements `feathers.layout.ILayout`. This interface defines two functions that all layouts need, which we'll be digging into next. There are some other interfaces for more advanced layout capabilities, but `ILayout` is the bare minimum.

-   The class extends the standard Starling `starling.events.EventDispatcher` because ILayout specifies that layouts should dispatch `Event.CHANGE` when their properties change. This will allow components that use layouts to properly invalidate when they need to call the `layout()` function again.

## The layout() function

The first function defined by the `ILayout` interface is `layout()`. Please take a moment to review its signature below:

``` code
layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult
```

This function's main purpose is to set the final transformations on the items in the layout, such as position and dimensions. If the final dimensions of the view port aren't specified, it will also calculate those values and return them.

The first argument is a `Vector.<DisplayObject>` of the items to layout. A layout implementation can loop through these items and transform them as needed. Below, you can see a this exact loop from our class:

``` code
var itemCount:int = items.length;
for(var i:int = 0; i < itemCount; i++)
{
    var item:DisplayObject = items[i];
    // skip items that aren't included in the layout
    if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
    {
        continue;
    }
    if(item is IFeathersControl)
    {
        IFeathersControl(item).validate();
    }
    item.x = startX;
    item.y = positionY;
    positionY += item.height + this._gap;
    maxItemWidth = Math.max(maxItemWidth, item.width);
}
```

In this loop, we set the item's position. If this were a more advanced layout, we might perform other transformations, like setting the width or height, or even rotating the item. We're also tracking the total width of each item, which we may use later to calculate the final view port width, if required.

Notice that we check the datatype of each item two times using the `is` keyword.

First, we check if the item is an `ILayoutDisplayObject`. If so, we want to check if the `includeInLayout` property has been set to `false`. If so, we will skip that item.

For more information about the `ILayoutDisplayObject` interface and related layout features, please take a look at the [ILayoutDisplayObject and ILayoutData](layout-data.html) article.

Next, we check if an item is a Feathers component. If we encounters one, we need to call `validate()`. If a Feathers component is in an invalid state, it may not report the correct dimensions, so this function call is required for accurate bounds calculations and positioning.

The second argument is an optional `ViewPortBounds` object. This object specifies restrictions on the layout, such as dimensions, starting position, and scroll position (for scrolling containers). If the `ViewPortBounds` object is not provided, the layout is expected to assume that it has no restrictions on dimensions, the container has not scrolled, and item positioning should start at the standard origin `(0,0)`. The code below will use `viewPortBounds`, if it is not `null`, or it will select sensible defaults for all values:

``` code
var startX:Number = 0;
var startY:Number = 0;
var explicitWidth:Number = NaN;
var explicitHeight:Number = NaN;
var minWidth:Number = 0;
var minHeight:Number = 0;
var maxWidth:Number = Number.POSITIVE_INFINITY;
var maxHeight:Number = Number.POSITIVE_INFINITY;
if(viewPortBounds)
{
    startX = viewPortBounds.x;
    startY = viewPortBounds.y;
    explicitWidth = viewPortBounds.explicitWidth;
    explicitHeight = viewPortBounds.explicitHeight;
    minWidth = viewPortBounds.minWidth;
    minHeight = viewPortBounds.minHeight;
    maxWidth = viewPortBounds.maxWidth;
    maxHeight = viewPortBounds.maxHeight;
}
```

In a moment, we'll spend some time looking at [every property defined by ViewPortBounds](#viewportbounds_properties), including those interesting `NaN` values.

The final argument is an optional `LayoutBoundsResult` object. This object is used to specify the final view port dimensions and the dimensions of the content within the view port. The content may be larger than the view port, and a component like `ScrollContainer` will use that to determine if it needs to scroll.

This argument actually becomes the return value of the `layout()` function. By passing in (and reusing) a pre-created `LayoutBoundsResult` object, Feathers can avoid unnecessary garbage collection. It is optional, though, so the layout is expected to create a new instance of `LayoutBoundsResult` if the argument is `null`.

Below, we see how the dimensions of the content and some of the values from `ViewPortBounds` are used to calculate the properties on the `LayoutBoundsResult` object:

``` code
if(!result)
{
    result = new LayoutBoundsResult();
}
var viewPortWidth:Number = explicitWidth;
var viewPortHeight:Number = explicitHeight;
if(isNaN(viewPortWidth))
{
    viewPortWidth = Math.max(minWidth, Math.min(maxWidth, maxItemWidth));
}
if(isNaN(explicitHeight))
{
    viewPortHeight = Math.max(minHeight, Math.min(maxHeight, positionY));
}
var contentWidth:Number = Math.max(maxItemWidth, viewPortWidth);
var contentHeight:Number = Math.max(positionY, viewPortHeight);
result.viewPortWidth = viewPortWidth;
result.viewPortHeight = viewPortHeight;
result.contentWidth = contentWidth;
result.contentHeight = contentHeight;
return result;
```

Notice that if the view port's dimensions are not explicitly specified by the `ViewPortBounds` argument (in other words, if they're `NaN`), we calculate the view port dimensions manually, using the combined height of all items and the maximum width of the items. In that case, we also need to take into account the minimum and maximum dimensions. Finally, the content dimensions should either be equal to or larger than the view port dimensions.

### ViewPortBounds properties

Let's look in more detail at the properties on a `ViewPortBounds` object. This object specifies dimensions, starting position, and scroll position values of the container's view port.

The `explicitWidth` and `explicitHeight` properties may specify that the view port has an exact width and height that cannot change. The layout may position its items beyond these dimensions, but it should expect that the container will be required to scroll if any items are positioned beyond the explicit dimensions. If the value of one of these properties is `NaN` (which can be checked by passing the value to the `isNaN()` function), the view port dimension in question is not restricted to an exact value.

The `minWidth`, `minHeight`, `maxWidth`, and `maxHeight` properties specify restrictions on view port dimensions that should be taken into account if `explicitWidth` or `explicitHeight` is not specified (if they are `NaN`, as explained above). The layout should take these values into account when it calculates its preferred width and height.

The `scrollX` and `scrollY` properties specify the scroll position of the container that is using the layout. If the container has not been scrolled, or it cannot scroll, the value will be `0`.

The `x` and `y` properties specify the starting position of the layout. The layout should consider the point `(x,y)` as its origin, instead of `(0,0)`.

Again, this is an optional argument. If the layout receives `null`, it may assume the following defaults, which we've previously pointed out in the source code:

-   `explicitWidth = NaN`

-   `explicitHeight = NaN`

-   `minWidth = 0`

-   `minHeight = 0`

-   `maxWidth = Number.POSITIVE_INFINITY`

-   `maxHeight = Number.POSITIVE_INFINITY`

-   `scrollX = 0`

-   `scrollY = 0`

-   `x = 0`

-   `y = 0`

### LayoutBoundsResult properties

Let's look in more detail at the properties on a `LayoutBoundsResult` object. This object is returned by the `layout()` function and “fills in the blanks” from the `ViewPortBounds` object passed as one of the arguments to the `layout()` function.

The `viewPortWidth` and `viewPortHeight` properties specify the final width and height of the container's view port. If the `ViewPortBounds` object specifies an `explicitWidth` or `explicitHeight`, those values should **always** be used. If not, then these values must be calculated by the layout (how they are calculated depends on the layout algorithm), using `minWidth`, `minHeight`, `maxWidth`, and `maxHeight` as restrictions.

The `contentWidth` and `contentHeight` properties specify the width and height of the content. They may be the same as `viewPortWidth` and `viewPortHeight`, but if the view port contains content that goes beyond its bounds, these values may be larger, which allows a layout to tell the container that its view port should scroll, if the container supports scrolling.

The `contentX` and `contentY` properties specify where the content begins for scrolling containers to set the minimum scroll positions. These values are typically set to `0` (zero), but they may also be negative.

## The getScrollPositionForIndex() function

The second function defined by `ILayout` is `getScrollPositionForIndex()`. Please take a moment to review its signature below:

``` code
getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, viewPortWidth:Number, viewPortHeight:Number, result:Point = null):Point
```

This function may be called by a component that supports layout to calculate a scroll position that ensures that a specific item is fully visible in the view port. The item's exact position within the view port is determined entirely by the layout. A custom layout might consider aligning the item to the center, or it might align it to one of the edges. The only rule is that the item must be fully visible when the view port is scrolled to that position. If you're calling this function, you should make no other assumptions about the item's position.

The first argument is the zero-based index of the item that needs to be fully visible in the view port. You can see that this is used for the ending condition in the `for` loop:

``` code
for(var i:int = 0; i < index; i++)
```

In other words, we don't need to loop through every item to see where the final scroll position will be unless we need the final scroll position for the final item.

Next, the full list of items are passed in. In the code below, we loop through the items mentioned above, adding each item's height and the gap between the items, similar to the `layout()` function, except that we aren't setting the positions of items:

``` code
var positionY:Number = 0;
for(var i:int = 0; i < index; i++)
{
    var item:DisplayObject = items[i];
    if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
    {
        continue;
    }
    if(item is IFeathersControl)
    {
        IFeathersControl(item).validate();
    }
    positionY += item.height + this._gap;
}
```

As above, we need to check if the item is included in the layout or not, and we need to validate Feathers controls before we can access their correct dimensions.

For the next arguments, it's important to understand that `getScrollPositionForIndex()` must always be called after `layout()`. With that in mind, we don't pass a `ViewPortBounds` object to `getScrollPositionForIndex()` like we do for `layout()`. We know the final x, y, width and height values now, so minimum and maximum dimensions are irrelevant.

The third and fourth arguments are the x and y position of the view port. These values match up with the x and y values of the `ViewPortBounds` object passed to `layout()`. These values often are not needed.

The fifth and sixth arguments are the final dimensions of the view port. They're equivalent to the `viewPortWidth` and `viewPortHeight` properties of the `LayoutBoundsResult` object returned by `layout()`. We don't need these values in this example, but other layouts may use them if items need to be resized based on the width and height of the view port.

The seventh, and final, argument is an optional `flash.geom.Point` object where the `x` and `y` properties are equivalent, respectively, to `horizontalScrollPosition` and `verticalScrollPosition` values of a scrolling container.

If the result value isn't `null`, `getScrollPositionForIndex()` must use it as the return value. By passing in (and reusing) a pre-created `Point` object, Feathers can avoid unnecessary garbage collection. It is optional, though, so the layout is expected to create a new instance of `Point` if the argument is `null`.

Below, we can see how we check if the result is `null` or not, and the final scroll position is set before returning:

``` code
if(!result)
{
    result = new Point();
}
result.x = 0;
result.y = positionY;
return result;
```

## Related Links

-   [ILayoutDisplayObject and ILayoutData](layout-data.html)

-   [Virtualized Custom Layouts for Feathers Components](virtual-custom-layouts.html)

For more tutorials, return to the [Feathers Documentation](start.html).


