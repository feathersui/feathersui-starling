---
title: ILayoutDisplayObject and ILayoutData  
author: Josh Tynjala

---
# `ILayoutDisplayObject` and `ILayoutData`

Some layouts may allow developers to customize individual display objects by adding optional *layout data*. All Feathers components have a [`layoutData`](../api-reference/feathers/layout/ILayoutDisplayObject.html#layoutData) property that can be used to specify additional information about the component that the parent container's layout can use for measurement and positioning.

<aside class="info">This document explains advanced layout features. It builds on the basics explained in [Introduction to Custom Feathers Layouts](custom-layouts.html).</aside>

## ILayoutDisplayObject

Any display object that may implement the [`ILayoutDisplayObject`](../api-reference/feathers/layout/ILayoutDisplayObject.html) interface to support more advanced layout features when added as children of Feathers containers. The base [`FeathersControl`](../api-reference/feathers/core/FeathersControl.html) class implements this interface, so most custom components will automatically support the ability to specify layout data.

The `ILayoutDisplayObject` interface defines two properties and an event.

The [`includeInLayout`](../api-reference/feathers/layout/ILayoutDisplayObject.html#includeInLayout) property may be set to `false` to tell a layout to completely ignore a display object. The object won't affect the measurement of the container and the layout won't position, resize, or otherwise transform the display object. This can be used to position a display object manually, but to keep it in the same container as other display objects that need to be in a layout.

The [`layoutData`](../api-reference/feathers/layout/ILayoutDisplayObject.html#layoutData) property is used to set additional properties on the display object that are specific to the layout.

[`FeathersEventType.LAYOUT_DATA_CHANGE`](../api-reference/feathers/events/FeathersEventType.html#LAYOUT_DATA_CHANGE) should be dispatched by the display object when a property of the `ILayoutData` object is changed. This is to inform the container that the layout may be affected by this change to the layout data. The display object should listen for [`Event.CHANGE`](../api-reference/feathers/layout/ILayoutData.html#event:change) on the layout data to know when this event should be dispatched.

## ILayoutData

The [`ILayoutData`](../api-reference/feathers/layout/ILayoutData.html) interface defines one required event and no properties or methods. Other properties will be specific to the layout.

[`Event.CHANGE`](../api-reference/feathers/layout/ILayoutData.html#event:change) should be dispatched when the value any property of the layout data changes.

## Example

Let's expand on the example layout presented in [Introduction to Custom Feathers Layouts](custom-layouts.html). We'd like to provide an `ILayoutData` implementation that allows us to set a `percentWidth` property for each item.

To begin, we'll implement `ILayoutData` with a new `SimpleVerticalLayoutData` class:

``` code
package feathersx.layout
{
    import feathers.layout.ILayoutData;
    import starling.events.EventDispatcher;
 
    [Event(name="change",type="starling.events.Event")]
 
    public class SimpleVerticalLayoutData extends EventDispatcher implements ILayoutData
    {
        public function SimpleVerticalLayoutData()
        {
 
        }
 
        protected var _percentWidth:Number = NaN;
 
        public function get percentWidth():Number
        {
            return this._percentWidth;
        }
 
        public function set percentWidth(value:Number):void
        {
            if(this._percentWidth == value)
            {
                return;
            }
            this._percentWidth = value;
            this.dispatchEventWidth( Event.CHANGE );
        }
    }
}
```

The class needs to extend [`starling.events.EventDispatcher`](http://doc.starling-framework.org/core/starling/events/EventDispatcher.html) in order to be able to dispatch `Event.CHANGE` when its `percentWidth` property changes. The metadata for this event appears above the class definition. Obviously, we implement the `ILayoutData` interface.

The `percentWidth` getter and setter are also defined. The getter simply returns the `_percentWidth` member variable used to store the value. The setter checks if the value has changed. If so, it stores the new value in the `_percentWidth` member variable and then dispatches `Event.CHANGE`.

Notice that the member variable is initialized to `NaN`. We're going to use `isNaN()` in our layout to check if a display object's width should be set using `percentWidth` or if the existing width should be used as-is, like it is in the original class. We'll specify percentages in the range `0` to `100`.

If we want to pass this layout data to a Feathers component, we might do it like this:

``` code
var buttonLayoutData:SimpleVerticalLayoutData = new SimpleVerticalLayoutData();
buttonLayoutData.percentWidth = 100;
 
var button:Button = new Button();
button.label = "Click Me";
button.layoutData = buttonLayoutData;
this.addChild( button );
```

Next, let's make some modifications to the `SimpleVerticalLayout` class in order to support this new layout data. We'll start by changing the `layout()` function a bit:

``` code
var maxItemWidth:Number = 0;
var itemCount:int = items.length;
for(var i:int = 0; i < itemCount; i++)
{
    var item:DisplayObject = items[i];
    // skip items that aren't included in the layout
    if(item is ILayoutDisplayObject && !ILayoutDisplayObject(item).includeInLayout)
    {
        continue;
    }
    // special case for Feathers components
    if(item is IFeathersControl)
    {
        IFeathersControl(item).validate();
    }
 
    // used for the final content width below
    maxItemWidth = Math.max(maxItemWidth, item.width);
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
 
var positionY:Number = startY;
for(i = 0; i < itemCount; i++)
{
    item = items[i];
    var layoutItem:ILayoutDisplayObject = item as ILayoutDisplayObject;
 
    if(layoutItem)
    {
        if(!layoutItem.includeInLayout)
        {
            continue;
        }
 
        var layoutData:SimpleVerticalLayoutData = layoutItem.layoutData as SimpleVerticalLayoutData;
        if(layoutData)
        {
            var percentWidth:Number = layoutData.percentWidth;
            if(!isNaN(percentWidth))
            {
                // change the item's width if percent width is a valid number
                item.width = viewPortWidth * percentWidth / 100;
            }
        }
    }
    if(item is IFeathersControl)
    {
        IFeathersControl(item).validate();
    }
    item.x = startX;
    item.y = positionY;
    positionY += item.height + this._gap;
}
```

There are a number of changes, which might be a bit intimidating, but they're easier to digest individually.

First, you'll probably notice that the loop over the items has been changed into two loops. As before, in order to properly measure the width of the container, if the `explicitWidth` has not been specified in the `ViewPortBounds`, we first need to get the maximum width of an item. However, now we have the `percentWidth` values in each item's layout data. In order to calculate the width of each item as a percentage of the view port width, we need to split the loop into two and calculate `viewPortWidth` as soon as possible so that we can use it in the second loop.

In the second loop, in addition to checking `includeInLayout` if the item is an `ILayoutDisplayObject`, we now also try to use the `layoutData` property. We cast its value as `SimpleVerticalLayoutData`, the class we defined previously. If the item has layout data, we check the value of `percentWidth` using `isNaN()`. If it's a valid numeric value, we change the display object's width by multiplying the `viewPortWidth` variable by `percentWidth` and dividing by `100`. Once the width is set, we continue on with positioning like we did in the old version of this class. As we noted previously, we moved the calculation of `minItemWidth` to the first loop.

The `getScrollPositionForIndex()` function does not need to be changed. It is meant to be called after the `layout()` function, so the `percentWidth` values are already processed.

## Related Links

-   [`feathers.layout.ILayoutDisplayObject` API Reference](../api-reference/feathers/layout/ILayoutDisplayObject.html)

-   [`feathers.layout.ILayoutData` API Reference](../api-reference/feathers/layout/ILayoutData.html)

-   [Introduction to Custom Feathers Layouts](custom-layouts.html)

For more tutorials, return to the [Feathers Documentation](index.html).


