---
title: How to support multiple touch states in a custom item renderer  
author: Josh Tynjala

---
# How to support multiple touch states in a custom item renderer

We've already [added a background skin to an item renderer](item-renderer-background-skin.html), but maybe we to display different background skins depending on if the user is touching the item renderer or not. We might also be interested in displaying different icons or changing the text styles on different touch phases.

Let's use the [`TouchToState`](../../api-reference/feathers/utils/TouchToState.html) utility to map the touch phases to states, and then we can choose a background skin (or anything else) based on the current state.

<aside class="info">Note: [Item renderers based on `LayoutGroup`](../layout-group-item-renderers) already have a background skin, but you may use `TouchToState` to support additional custom states.</aside>

## Background skins

Let's start by adding separate background skins for the up, down, and hover states to our custom item renderer:

``` actionscript
private var _backgroundUpSkin:DisplayObject;
 
public function get backgroundUpSkin():DisplayObject
{
    return this._backgroundUpSkin;
}
 
public function set backgroundUpSkin(value:DisplayObject):void
{
    if(this._backgroundUpSkin == value)
    {
        return;
    }
    this._backgroundUpSkin = value;
    this.invalidate(INVALIDATION_FLAG_SKIN);
}

private var _backgroundDownSkin:DisplayObject;
 
public function get backgroundDownSkin():DisplayObject
{
    return this._backgroundDownSkin;
}
 
public function set backgroundDownSkin(value:DisplayObject):void
{
    if(this._backgroundDownSkin == value)
    {
        return;
    }
    this._backgroundDownSkin = value;
    this.invalidate(INVALIDATION_FLAG_SKIN);
}

private var _backgroundHoverSkin:DisplayObject;
 
public function get backgroundHoverSkin():DisplayObject
{
    return this._backgroundHoverSkin;
}
 
public function set backgroundHoverSkin(value:DisplayObject):void
{
    if(this._backgroundHoverSkin == value)
    {
        return;
    }
    this._backgroundHoverSkin = value;
    this.invalidate(INVALIDATION_FLAG_SKIN);
}
```

Later, we'll see how to pass one of these to our original `backgroundSkin` property, depending on the current state.

## States

Let's start out by tracking whether the user is touching the item renderer or not. If we use terms that you might associate with a button, this will require a default "up" state and a "down" state for when it is pressed.

First, let's define a `_currentState` variable to keep track of which state the item renderer is in:

``` actionscript
private var _currentState = ButtonState.UP;
```

We'll borrow the values defined by the `feathers.controls.ButtonState` class. The default value will be `ButtonState.UP`. The `ButtonState` class defines a number of other constants like `ButtonState.DOWN`, `ButtonState.HOVER`, and `ButtonState.DISABLED`.

Next, let's create the `TouchToState` utility inside an override of `initialize()`:

``` actionscript
private var _touchToState:TouchToState;

override protected function initialize():void
{
    super.initialize(); //don't forget this!

    this._touchToState = new TouchToState(this, setCurrentState);
}
```

We'll need to add the `setCurrentState()` function that is used by `TouchToState` to notify us when the state should change:

``` actionscript
private function setCurrentState(newState:String):void
{
    this._currentState = newState;
    this.updateBackgroundSkin();
}
```

Inside the `updateBackgroundSkin()` function, we can choose the correct background skin based on the value of `_currentState`:

``` actionscript
private function updateBackgroundSkin():void
{
    if(this._currentState == ButtonState.DOWN &&
        this._backgroundDownSkin != null)
    {
        this.backgroundSkin = this._backgroundDownSkin;
    }
    else if(this._currentState == ButtonState.HOVER &&
        this._backgroundHoverSkin != null)
    {
        this.backgroundSkin = this._backgroundHoverSkin;
    }
    else
    {
        this.backgroundSkin = this._backgroundUpSkin;
    }
}
```

You'll notice that we check if `_backgroundDownSkin` and `_backgroundHoverSkin` are `null`. This will allow us to fall back to using the `_backgroundUpSkin`, if we decide that we don't need skins for every states.

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)