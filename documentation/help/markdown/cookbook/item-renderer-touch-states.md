---
title: How to support multiple touch states in a custom item renderer 
author: Josh Tynjala

---
# How to support multiple touch states in a custom item renderer

You've already [added a background skin](item-renderer-background-skin.html), but maybe you want to display different background skins depending on if the user is touching your item renderer or not. You might also be interested in displaying different icons or changing the text styles on different touch phases. Let's listen to `TouchEvent.TOUCH` and start tracking which touch phase is active. We'll map the touch phases to states, and then we can choose a background skin (or anything else) based on the current state.

## Up and Down States

Let's start out by tracking whether the user is touching the item renderer or not. If we use terms that you might associate with a button, this will require a default “up” state and a “down” state for when it is pressed.

First, let's define a `currentState` property:

``` code
private var _currentState = STATE_UP;
 
public function get currentState():String
{
    return this._currentState;
}
 
public function set currentState( value:String ):void
{
    if( this._currentState == value )
    {
        return;
    }
    this._currentState = value;
    this.invalidate( INVALIDATION_FLAG_STATE );
}
```

Notice the `STATE_UP` default value. We're going to add some constants that represent different states:

``` code
public static const STATE_UP:String = "up";
public static const STATE_DOWN:String = "down";
```

Later, we'll set this `currentState` property in a `TouchEvent.TOUCH` listener.

Next, let's make sure that we're only tracking a single touch ID:

``` code
protected var touchID:int = -1;
```

There's no reason to support multi-touch here, so if a touch begins, we'll ignore new touches and continue to track the original touch until it ends.

Inside our constructor, or in the component's `initialize()` function, we can listen for `TouchEvent.TOUCH`:

``` code
override protected function initialize():void
{
    this.addEventListener(TouchEvent.TOUCH, touchHandler);
 
    // you may be initializing other things here too
}
```

For more information about the `initialize()` function and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](http://wiki.starling-framework.org/feathers/component-properties-methods).

Now, let's create our `TouchEvent.TOUCH` listener. Comments appear inline to explain each step of the process. To see where a touch begins, look at the `else` block near the bottom.

``` code
private function touchHandler(event:TouchEvent):void
{
    if(!this._isEnabled)
    {
        // if we were disabled while tracking touches, clear the touch id.
        this.touchID = -1;
 
        // the button should return to the up state, if it is disabled.
        // you may also use a separate disabled state, if you prefer.
        this.currentState = STATE_UP;
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
            this.currentState = STATE_UP;
 
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
 
        this.currentState = STATE_DOWN;
 
        // save the touch ID so that we can track this touch's phases.
        this.touchID = touch.id;
    }
}
```

It's a little complicated, but it will ensure that we are only tracking a single touch ID at a time. In multi-touch environments, this is essential.

Finally, add a listener for `Event.REMOVED_FROM_STAGE` inside the constructor or in the `initialize()` function:

``` code
this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
```

The listener will clear the `touchID` to `-1` just we did in `TouchPhase.ENDED`:

``` code
private function removedFromStageHandler(event:Event):void
{
    this.touchID = -1;
}
```

This ensures that if a component is reused later, it won't be trying to track a touch that doesn't exist anymore.

## Hover State

On mobile, Starling doesn't dispatch touch events for `TouchPhase.HOVER`. However, on devices with a mouse, you may want to support a separate background skin (or icon or label styles) when the mouse hovers over your item renderer.

Let's start by adding a new state for `TouchPhase.HOVER`:

``` code
public static const STATE_HOVER:String = "hover";
```

Next, we'll modify the `else` block in the `TouchEvent.TOUCH` listener we created previously:

``` code
else
{
    // we aren't tracking another touch, so let's look for a new one.
 
    touch = event.getTouch( this, TouchPhase.BEGAN );
    if( touch )
    {
        this.currentState = STATE_DOWN;
 
        // save the touch ID so that we can track this touch's phases.
        this.touchID = touch.id;
        return;
    }
 
    // this touch didn't begin, so maybe it's a hover.
 
    touch = event.getTouch( this, TouchPhase.HOVER );
    if( touch )
    {
        this.currentState = STATE_HOVER;
        return;
    }
 
    // the only remaining possibility: the hover has ended.
 
    this.currentState = STATE_UP;
}
```

Now, if we don't find a touch for `TouchPhase.BEGAN`, we also check for `TouchPhase.HOVER`. This puts us into the hover state. If we check for `TouchPhase.BEGAN` and `TouchPhase.HOVER`, and we still don't find a touch, that means that a hover has ended, and we can return to `STATE_UP`.

That's not all we need to do, though. When a touch ends, we need to figure out if the mouse is still hovering over our item renderer or if the touch ended outside of the item renderer to decide if we want to change to `STATE_UP` or `STATE_HOVER`:

``` code
if( touch.phase == TouchPhase.ENDED )
{
    touch.getLocation( this.stage, HELPER_POINT );
    var isInBounds:Boolean = this.contains( this.stage.hitTest( HELPER_POINT, true ) );
    if( isInBounds )
    {
        this.currentState = STATE_HOVER;
    }
    else
    {
        this.currentState = STATE_UP;
    }
 
    // the touch has ended, so now we can start watching for a new one.
    this.touchID = -1;
}
```

Notice the `isInBounds` local variable. What we're doing there with the call to `contains()` and `hitTest()` is ensuring two things: 1) the touch hasn't moved outside the bounds of the item renderer and 2) nothing else on the display list has moved above the item renderer to block the touch.

The second case may be a little confusing, so let's go into a bit more detail. When Starling handles a touch, it will dispatch `TouchEvent.TOUCH` to the original target for every single phase of the touch, regardless of whether other objects may be blocking the touch. It's our responsibility to ensure that a touch is still valid for the original target. We'll always receive the event for `TouchPhase.ENDED`, but the call to the `hitTest()` on the stage may not return the item renderer or any of its children. If that's the case, then we go back to `STATE_UP` instead of `STATE_HOVER`.

Also, you may have seen the `HELPER_POINT` object we passed to `getLocation()`. We're going to add a static constant that we can pass into that function so that it doesn't need to create a new `flash.geom.Point` for its return value. This will help us avoid some unnecessary garbage collection when we check a touch's location to help performance a bit:

``` code
private static const HELPER_POINT:Point = new Point();
```

It's static to avoid creating a different `Point` object for every item renderer. We simply need to ensure that multiple item renderers won't be modifying it at the same time. Since the item renderer isn't dispatching any events between the call to `getLocation()` and the call to `hitTest()`, we know that only one item renderer may be using `HELPER_POINT` at any given time.

## Selecting a Background Skin

[Previously](item-renderer-background-skin.html), we added a single `backgroundSkin` property. If we want to show different background skins based on the touch phases, we'll need to add more properties like `backgroundSkin` for each touch phase. In the following source code, we'll assume that a `downBackgroundSkin` property has been added. We can copy the implementation from `backgroundSkin` to `downBackgroundSkin`, but for both properties, we need to make one change. When we add the child, we also set its `visible` property to `false`:

``` code
if( this._downBackgroundSkin )
{
    this._downBackgroundSkin.visible = false;
    this.addChildAt( this._downBackgroundSkin, 0 );
}
```

Don't forget to add that line in the setters for both `backgroundSkin` and `downBackgroundSkin` properties. Later, we'll ensure that the `visible` property is to `true` on only the current background skin that is chosen.

Now, let's add the following member variable to our class to hold the currently chosen background skin:

``` code
private var _currentBackgroundSkin:DisplayObject;
```

We'll update this value in a new function that we're also adding to our class:

``` code
private function updateCurrentBackground():void
{
    var newBackground:DisplayObject = this._backgroundSkin;
    if( this._currentState == STATE_DOWN )
    {
        newBackground = this._downBackgroundSkin;
    }
    // if you have additional states, you can add else ifs here.
 
    // check if the background is different than last time.
    if( this._currentBackgroundSkin == newBackground )
    {
        return;
    }
 
    if( this._currentBackgroundSkin )
    {
        // if we have an old background, make it invisible again.
        this._currentBackgroundSkin.visible = false;
    }
    this._currentBackgroundSkin = newBackground;
    if( this._currentBackgroundSkin )
    {
        // if we have a new background, make it visible.
        this._currentBackgroundSkin.visible = true;
    }
}
```

In this simple example code, we're only checking for `STATE_DOWN`. We could check for `STATE_HOVER` by adding an appropriate `else if` at the end. We could also use a `switch` statement instead, if preferred. The point here is simply to select the most appropriate background skin for the current state.

### In LayoutGroup Item Renderers

If you have a [custom item renderer created with LayoutGroup](../layout-group-item-renderers.html), you can call this function in your `preLayout()` function:

``` code
override protected function preLayout():void
{
    this.updateCurrentBackground();
 
    // you may have other code to place here
}
```

If you are resetting the width and height of the backgroundSkin to `0` in `preLayout()`, you should do it for all background skins, since they are still considered by the layout, even if they're invisible.

In the `postLayout()` function, instead of resizing `_backgroundSkin`, you should resize `_currentBackgroundSkin`:

``` code
override protected function postLayout():void
{
    if( this._currentBackgroundSkin )
    {
        this._currentBackgroundSkin.width = this.actualWidth;
        this._currentBackgroundSkin.height = this.actualHeight;
    }
}
```

### In FeathersControl Item Renderers

If you have a [custom item renderer created with FeathersControl and IListItemRenderer](../feathers-control-item-renderers.html), you can call this function in your `draw()` function. First, check for the appropriate flag:

``` code
var stateInvalid:Boolean = this.isInvalid( INVALIDATION_FLAG_STATE );
var skinInvalid:Boolean = this.isInvalid( INVALIDATION_FLAG_SKIN );
```

Then, call the `updateBackgroundSkin()` function if either of the flags is set:

``` code
if( stateInvalid || skinInvalid )
{
    this.updateBackgroundSkin();
}
```

You should do this before you call `autoSizeIfNeeded()` so that the `_currentBackgroundSkin` can be used for measurement.

In `layoutChildren()`, instead of resizing `_backgroundSkin`, you should resize `_currentBackgroundSkin`:

``` code
protected function layoutChildren():void
{
    if(this._currentBackgroundSkin)
    {
        this._currentBackgroundSkin.width = this.actualWidth;
        this._currentBackgroundSkin.height = this.actualHeight;
    }
 
    // position and resize other children here
}
```

Similarly, if you measure `_backgroundSkin` in `autoSizeIfNeeded()`, you should switch to measuring `_currentBackgroundSkin` instead.

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)

This is a recipe in the [Feathers Cookbook](index.html). For more information about Feathers, return to the [Feathers Documentation](../index.html).


