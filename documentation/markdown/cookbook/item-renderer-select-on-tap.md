# Feathers Cookbook: Selecting a custom item renderer on tap or click

The example [custom item renderers](../item-renderers.html) have an `isSelected` property, but they don't offer any way to change it. This is because some item renderers may support a variety of interactions to select, such as a long-press, a swipe, or a tap/click. Since it's the simplest interaction, let's take a look at how to select a custom item renderer on tap or click.

First, let's make sure that we're only tracking a single touch ID:

``` code
protected var touchID:int = -1;
```

There's no reason to track more than one touch here, so if a touch begins, we'll ignore other touches that begin before the original touch ends.

Inside our constructor, or in the component's `initialize()` function, we can listen for `TouchEvent.TOUCH`:

``` code
override protected function initialize():void
{
    this.addEventListener( TouchEvent.TOUCH, touchHandler );
 
    // you may be initializing other things here too
}
```

For more information about the `initialize()` function and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](http://wiki.starling-framework.org/feathers/component-properties-methods).

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
            touch.getLocation( this.stage, HELPER_POINT );
            var isInBounds:Boolean = this.contains( this.stage.hitTest( HELPER_POINT, true ) );
            if( isInBounds )
            {
                this.isSelected = true;
            }
 
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
    }
}
```

It's a little complicated, but it will ensure that we are only tracking a single touch ID at a time. In multi-touch environments, this is essential.

The key part is the line with the `isInBounds` local variable. What we're doing there with the call to `contains()` and `hitTest()` is ensuring two things: 1) the touch hasn't moved outside the bounds of the item renderer and 2) nothing else on the display list has moved above the item renderer to block the touch.

Also, you may have seen the `HELPER_POINT` object we passed to `getLocation()`. We're going to add a static constant that we can pass into that function so that it doesn't need to create a new `flash.geom.Point` for its return value. This will help us avoid some unnecessary garbage collection when we check a touch's location to help performance a bit:

``` code
private static const HELPER_POINT:Point = new Point();
```

It's static to avoid creating a different `Point` object for every item renderer. We simply need to ensure that multiple item renderers won't be modifying it at the same time. Since the item renderer isn't dispatching any events between the call to `getLocation()` and the call to `hitTest()`, we know that only one item renderer may be using `HELPER_POINT` at any given time.

Finally, add a listener for `Event.REMOVED_FROM_STAGE` inside the constructor or in the `initialize()` function:

``` code
this.addEventListener( Event.REMOVED_FROM_STAGE, removedFromStageHandler );
```

The listener will clear the `touchID` to `-1` just we did in `TouchPhase.ENDED`:

``` code
private function removedFromStageHandler( event:Event ):void
{
    this.touchID = -1;
}
```

This ensures that if a component is reused later, it won't be trying to track a touch that doesn't exist anymore.

## Deselect on Tap or Click

You may have noticed in the code above that the `isSelected` property is set to `true` on tap or click. If you want it to be possible to deselect an item renderer by tapping it again, it's very easy to change that line:

``` code
this.isSelected = !this.isSelected;
```

By default, the `List` component may select only one item at a time. If you select one item by tapping it, and then select another item by tapping it, the first item will be deselected automatically. If you wish to keep both the first item and the second item selected at the same time, set the `allowMultipleSelection` property on the `List` to `true`.

## Event.TRIGGERED in PickerList

The `PickerList` component additionally listens for `Event.TRIGGERED` to know when to close its pop-up list. If you tap or click an item that is already selected, it may not change the selection, so an additional event is required.

Before you set `isSelected`, simply dispatch `Event.TRIGGERED`:

``` code
if( isInBounds )
{
    this.dispatchEventWith( Event.TRIGGERED );
    this.isSelected = true;
}
```

The `TouchEvent.TOUCH` listener is exactly the same everywhere else.

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)

-   [Feathers Cookbook: Dispatching a triggered event from a custom item renderer](item-renderer-triggered-on-tap.html)

-   [Feathers Cookbook: Dispatching a long press event from a custom item renderer](item-renderer-long-press.html)

This is a recipe in the [Feathers Cookbook](index.html). For more information about Feathers, return to the [Feathers Documentation](../index.html).


