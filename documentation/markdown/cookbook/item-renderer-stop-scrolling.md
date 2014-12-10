# Feathers Cookbook: Prevent a List from scrolling when a child of a custom item renderer is touched

Sometimes, when you interact with the child of a custom item renderer, you want to ensure that the list won't start scrolling at the same time. For instance, if the child is a slider or another component that requires dragging, you don't want that drag to simultaneously scroll the list.

How you implement this depends on the sub-component's type. Some components may dispatch useful events that indicate that the user has started dragging or scrolling something. For instance, some components, like sliders, will dispatch `FeathersEventType.BEGIN_INTERACTION` to indicate when the users begins interacting with them in a meaningful way. Others, like lists or scroll containers may dispatch `FeathersEventType.SCROLL_START`.

For most display objects, you can usually simply listen for `TouchEvent.TOUCH` on the child:

``` code
child.addEventListener( TouchEvent.TOUCH, child_touchHandler );
```

In the listener, we'll track the ID of the touch and then wait to see if the list starts scrolling:

``` code
protected function child_touchHandler( event:TouchEvent ):void
{
    if(!this._isEnabled)
    {
        this.childTouchID = -1;
        return;
    }
 
    var child:DisplayObject = DisplayObject( event.currentTarget );
    if(this.childTouchID >= 0)
    {
        var touch:Touch = event.getTouch(child, TouchPhase.ENDED, this.childTouchID);
        if(!touch)
        {
            return;
        }
        this._owner.removeEventListener( FeathersEventType.SCROLL_START, owner_scrollStartHandler );
        this.childTouchID = -1;
    }
    else
    {
        touch = event.getTouch(child, TouchPhase.BEGAN);
        if(!touch)
        {
            return;
        }
        this.childTouchID = touch.id;
        this._owner.addEventListener( FeathersEventType.SCROLL_START, owner_scrollStartHandler );
    }
}
```

If the list attempts to start scrolling, it will dispatch `FeathersEventType.SCROLL_START`. If we call `stopScrolling()` right away, this will tell the list that it should not scroll right now because we're busy with the touch:

``` code
protected function owner_scrollStartHandler( event:Event ):void
{
    if(this.childTouchID < 0)
    {
        return;
    }
    // no need to listen anymore. the list won't try to scroll again with this touch.
    this._owner.removeEventListener( FeathersEventType.SCROLL_START, owner_scrollStartHandler );
 
    // no scrolling right now, please!
    this._owner.stopScrolling();
}
```

Scrolling will be stopped only when touches originate on the child. If touches originate elsewhere in the item renderer, the list will still be able to detect those touches and scroll by dragging, like mobile users expect.

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)

This is a recipe in the [Feathers Cookbook](start.html). For more information about Feathers, return to the [Feathers Documentation](../start.html).


