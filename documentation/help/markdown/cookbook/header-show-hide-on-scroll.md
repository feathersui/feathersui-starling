---
title: How to show or hide a header when scrolling a list or container 
author: Josh Tynjala

---
# How to show or hide a header when scrolling a list or container

In order to show as much content as possible, some mobile UIs will only reveal a header when it is required, and the header will slide out of view when scrolling. Most commonly, you might recognize this behavior in a mobile web browser.

## The Layout

Let's start by defining the [`Header`](../header.html) and [`List`](../list.html) components as member variables:

``` code
private var _header:Header;
private var _list:List;
```

Next, we'll instantiate them and set some basic properties:

``` code
this._header = new Header();
this._header.title = "Test";
this.addChild(this._header);
 
//some basic sample data for the list
var items:Array = [];
for(var i:int = 0; i < 100; i++)
{
    items.push( { label: i.toString() } );
}
this._list = new List();
this._list.dataProvider = new ListCollection( items );
this.addChild(this._list);
```

Now, we're ready to add the layout code. We'll use [`AnchorLayout`](../anchor-layout.html) to position a header and a list, with the list's position relative to the header. The header and list should be placed inside a container that supports layouts, such as [`LayoutGroup`](../layout-group.html).

``` code
this.layout = new AnchorLayout();
 
var headerLayoutData:AnchorLayoutData = new AnchorLayoutData();
headerLayoutData.top = 0;
headerLayoutData.right = 0;
headerLayoutData.left = 0;
this._header.layoutData = headerLayoutData;
 
var listLayoutData:AnchorLayoutData = new AnchorLayoutData();
listLayoutData.top = 0;
listLayoutData.topAnchorDisplayObject = this._header;
listLayoutData.right = 0;
listLayoutData.bottom = 0;
listLayoutData.left = 0;
this._list.layoutData = listLayoutData;
```

Notice that the top, right, and left edges of the header are anchored to its parent. We're going to change the value of the [`top`](../../api-reference/feathers/layout/AnchorLayoutData.html#top) anchor later when we want to change the header's `y` position, but to start out, the header will be fully visible.

The top of the list is anchored to the header. When the header moves, the list will move too. The other edges of the list are anchored to the edges of its parent. Since the list's bottom edge is anchored to its parent, and the top edge is anchored to the header, when the header moves, the list will not only move, but it will resize too.

## Showing or hiding the header on drag

Let's add a listener to handle touches:

``` code
this._list.addEventListener( TouchEvent.TOUCH, list_touchHandler );
```

Before we implement the listener, we'll need a couple of member variables to track the state of the touch that is dragging the list:

``` code
private var _touchID:int = -1;
private var _previousGlobalTouchY:Number;
```

Finally, let's write the listener that will reposition the header when the list is dragged:

``` code
private function list_touchHandler(event:TouchEvent):void
{
    if(this._touchID >= 0)
    {
        var touch:Touch = event.getTouch(this._list, null, this._touchID);
        if(!touch)
        {
            return;
        }
        if(touch.phase == TouchPhase.MOVED)
        {
            this.dragHeader(touch);
        }
        else if(touch.phase == TouchPhase.ENDED)
        {
            this._touchID = -1;
        }
    }
    else
    {
        var touch:Touch = event.getTouch(this._list, TouchPhase.BEGAN);
        if(!touch)
        {
            return;
        }
        this._touchID = touch.id;
        this._previousGlobalTouchY = touch.globalY;
    }
}
```

It's mostly boilerplate for tracking the appropriate touch ID. There are two important things to note. First, in the section for [`TouchPhase.BEGAN`](http://doc.starling-framework.org/core/starling/events/TouchPhase.html#BEGAN), we initialize the value of the `_previousGlobalTouchY` variable. Second, in the section for [`TouchPhase.MOVED`](http://doc.starling-framework.org/core/starling/events/TouchPhase.html#BEGAN), we call another function named `dragHeader()`. Let's implement that function now.

``` code
private function dragHeader(touch:Touch):void
{
    var currentGlobalTouchY:Number = touch.globalY;
    var newPosition:Number = this._header.y + currentGlobalTouchY - this._previousGlobalTouchY;
    var minHeaderPosition:Number = -this._header.height;
    if(newPosition < minHeaderPosition)
    {
        newPosition = minHeaderPosition;
    }
    if(newPosition > 0)
    {
        newPosition = 0;
    }
    this._previousGlobalTouchY = currentGlobalTouchY;
 
    var headerLayoutData:AnchorLayoutData = AnchorLayoutData(this._header.layoutData);
    headerLayoutData.top = newPosition;
}
```

The math is pretty simple here. The difference between the current `globalY` position of the touch, and the `_previousGlobalTouchY` variable is calculated and added to the `y` position of the header. The value is clamped so that the header can only be dragged over a range equal to its height and no higher than `0`. We then replace the value of `_previousGlobalTouchY` with the current `globalY` position of the touch.

The final calculated value replaces the `top` property of the `AnchorLayoutData` associated with the header. This drags the header, and because the list is positioned relative to the header, the list is dragged too.

------------------------------------------------------------------------

This is a recipe in the [Feathers Cookbook](index.html). For more information about Feathers, return to the [Feathers Documentation](../index.html).


