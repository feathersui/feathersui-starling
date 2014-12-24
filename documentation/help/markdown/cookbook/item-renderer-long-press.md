---
title: How to dispatch a long press event from a custom item renderer 
author: Josh Tynjala

---
# How to dispatch a long press event from a custom item renderer

A long press event isn't built into Starling or Feathers. Starling provides only low-level touch events, and Feathers implements long press only on [buttons](../button.html). Let's take a look at how to implement long press using low-level touch events to provide the same functionality as a button in an item renderer.

First, let's make sure that we're only tracking a single touch ID:

``` code
protected var touchID:int = -1;
```

There's no reason to support multi-touch here, so if a touch begins, we'll ignore new touches and continue to track the original touch until it ends.

Next, we want to remember the time when the touch began:

``` code
protected var touchBeganTime:int;
```

We'll use this value to calculate the duration of the touch, which will determine if we should dispatch the long press event yet.

Inside our constructor, or in the component's `initialize()` function, we can listen for [`TouchEvent.TOUCH`](http://doc.starling-framework.org/core/starling/display/DisplayObject.html#event:touch):

``` code
override protected function initialize():void
{
    this.addEventListener( TouchEvent.TOUCH, touchHandler );
 
    // you may be initializing other things here too
}
```

<aside class="info">For more information about the `initialize()` function and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](../component-properties-methods.html).</aside>

Now, let's create our `TouchEvent.TOUCH` listener. Comments appear inline to explain each step of the process. To see where a touch begins, look at the `else` block near the bottom.

``` code
private function touchHandler( event:TouchEvent ):void
{
    if( !this._isEnabled )
    {
        // if we were disabled while tracking touches, clear the touch id.
        this.touchID = -1;
        return;
    }
 
    if( this.touchID >= 0 )
    {
        // a touch has begun, so we'll ignore all other touches.
 
        var touch:Touch = event.getTouch( this, null, this.touchID );
        if( !touch )
        {
            // this should not happen.
            return;
        }
 
        if( touch.phase == TouchPhase.ENDED )
        {
            // stop checking the duration every frame because the touch ended.
            this.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
 
            // the touch has ended, so now we can start watching for a new one.
            this.touchID = -1;
        }
        return;
    }
    else
    {
        // we aren't tracking another touch, so let's look for a new one.
 
        touch = event.getTouch( this, TouchPhase.BEGAN );
        if( !touch )
        {
            // we only care about the began phase. ignore all other phases.
            return;
        }
 
        // save the touch ID so that we can track this touch's phases.
        this.touchID = touch.id;
 
        // save the start time, and we'll use it later
        this.touchBeganTime = getTimer();
 
        // we'll check the duration of the touch every frame
        this.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
    }
}
```

The structure is a little complicated, but it will ensure that we are only tracking a single touch ID at a time. In multi-touch environments, this is essential.

There are two sections that specifically apply to our long press event. In the section for TouchPhase.BEGAN, we call `getTimer()` to save the time that the touch began. Then, we listen for [`Event.ENTER_FRAME`](http://doc.starling-framework.org/core/starling/display/DisplayObject.html#event:enterFrame) to track how much time has passed since the touch began. We'll look at this listener in a moment. In [`TouchPhase.ENDED`](http://doc.starling-framework.org/core/starling/events/TouchPhase.html#ENDED), we remove that listener because the touch ends.

We need to add one more thing to properly handle touch events before moving on. Let's add a listener for [`Event.REMOVED_FROM_STAGE`](http://doc.starling-framework.org/core/starling/display/DisplayObject.html#event:removedFromStage) inside the constructor or in the `initialize()` function:

``` code
this.addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler );
```

The listener will clear the `touchID` to `-1` and remove the `Event.ENTER_FRAME` listener, just we did in `TouchPhase.ENDED`:

``` code
private function removedFromStageHandler( event:Event ):void
{
    this.removeEventListener( Event.ENTER_FRAME, longPress_enterFrameHandler );
    this.touchID = -1;
}
```

This ensures that if a component is removed and reused later, it won't remember a touch that doesn't exist anymore.

Finally, let's add the `Event.ENTER_FRAME` listener to dispatch the long press event:

``` code
private function enterFrameHandler( event:Event ):void
{
    var accumulatedTime:Number = (getTimer() - this._touchBeginTime) / 1000;
    if( accumulatedTime >= 0.5 )
    {
        this.removeEventListener( Event.ENTER_FRAME, longPress_enterFrameHandler );
        this.dispatchEventWith( FeathersEventType.LONG_PRESS );
    }
}
```

We calculate the duration of the touch in seconds. If it's greater than half a second, then it's time to dispatch our event.

You can change the duration to any number of seconds that you prefer. Similar to `Button`, you might consider adding a property to your class to make the duration customizable.

Be sure to remove the `Event.ENTER_FRAME` listener. We'll wait to set `touchID` to `-1` when the touch actually ends. Then, dispatch the [`FeathersEventType.LONG_PRESS`](../../api-reference/feathers/events/FeathersEventType.html#LONG_PRESS) constant defined by Feathers.

## Combined with Event.TRIGGERED or Event.CHANGE

If you plan to combine, `FeathersEventType.LONG_PRESS` with [`Event.TRIGGERED`](http://doc.starling-framework.org/core/starling/events/Event.html#TRIGGERED) or [`Event.CHANGE`](http://doc.starling-framework.org/core/starling/events/Event.html#CHANGE), you will want to add a couple extra things to ensure that the other two events aren't dispatched after a long press.

First, let's add a member variable to track whether a long press has happened:

``` code
protected var hasLongPressed:Boolean = false;
```

Next, when we add the `Event.ENTER_FRAME` listener on [`TouchPhase.BEGAN`](http://doc.starling-framework.org/core/starling/events/TouchPhase.html#BEGAN), we should always reset it to `false`:

``` code
// we haven't long pressed yet because the touch just began
this.hasLongPressed = false;
 
// save the start time, and we'll use it later
this.touchBeganTime = getTimer();
 
// we'll check the duration of the touch every frame
this.addEventListener( Event.ENTER_FRAME, enterFrameHandler );
```

In the `Event.ENTER_FRAME` listener, we need to set `hasLongPressed` to `true` when we dispatch the event:

``` code
if( accumulatedTime >= 0.5 )
{
    this.hasLongPressed = true;
    this.removeEventListener( Event.ENTER_FRAME, longPress_enterFrameHandler );
    this.dispatchEventWith( FeathersEventType.LONG_PRESS );
}
```

Finally, on [`TouchPhase.ENDED`](http://doc.starling-framework.org/core/starling/events/TouchPhase.html#ENDED), when we check the bounds before dispatching `Event.TRIGGERED` or setting `isSelected`, we should also check if we've long pressed:

``` code
if( !this.hasLongPressed && isInBounds )
{
    this.dispatchEventWith( Event.TRIGGERED );
    this.isSelected = true;
}
```

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)

-   [Feathers Cookbook: How to select (or deselect) a custom item renderer on tap or click](item-renderer-select-on-tap.html)

-   [Feathers Cookbook: How to dispatch a triggered event from a custom item renderer](item-renderer-triggered-on-tap.html)

This is a recipe in the [Feathers Cookbook](index.html). For more information about Feathers, return to the [Feathers Documentation](../index.html).


