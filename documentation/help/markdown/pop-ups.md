---
title: Displaying pop-ups above other content in Feathers  
author: Josh Tynjala

---
# Displaying pop-ups above other content in Feathers

Feathers includes a [`PopUpManager`](../api-reference/feathers/core/PopUpManager.html) that allows you to display content above the rest of your application. It provides options to make the pop-up modal and to center it on screen. You can customize the modal overlay to create any display object to block interaction with the content below the modal pop-up. You can even customize where pop-ups will appear on the display list.

If the [focus management](focus.html) is enabled, modal pop-ups will be given their own focus manager so that focus cannot be given to components below the modal overlay.

## Adding pop-ps

[`PopUpManager.addPopUp()`](../api-reference/feathers/core/PopUpManager.html#addPopUp()) is used to add a display object as a pop up. You must create the display object beforehand:

``` code
var popUp:Image = new Image( texture );
PopUpManager.addPopUp( popUp, true, true );
```

The first argument is simply the pop-up to add. It may be any Starling display object.

The second argument, `isModal`, tells the `PopUpManager` whether the pop-up is modal or not. Modal pop-ups include an overlay that blocks touches and other interaction below the pop-up. Non-modal pop-ups allow you to continue interacting with anything below the pop-up while it is displayed.

`isCentered`, the third argument, tells the `PopUpManager` if it should center the pop-up on the stage or not. If the stage or the pop-up resizes, it will remain centered. The second and third arguments are optional. If omitted, the pop-up will be modal and centered.

A fourth argument, also optional, allows you to pass in a custom factory for the modal overlay. By default, [`PopUpManager.overlayFactory`](../api-reference/feathers/core/PopUpManager.html#overlayFactory) is used to create the overlay, but you can customize it for individual pop-ups, if needed. We'll look at custom overlay factories further below.

## Removing pop-ups

There are two ways to remove pop-ups. The first is by calling [`PopUpManager.removePopUp()`](../api-reference/feathers/core/PopUpManager.html#removePopUp()):

``` code
PopUpManager.removePopUp( popUp, true );
```

The first argument is the pop-up to remove. If the object passed in is not a pop-up, a runtime error will be thrown. The second argument is whether to dispose the pop-up or not.

If you prefer, you may also use the standard [`removeFromParent()`](http://doc.starling-framework.org/core/starling/display/DisplayObject.html#removeFromParent()) function available to all Starling display objects:

``` code
popUp.removeFromParent( true );
```

The `PopUpManager` will automatically detect that the pop-up was removed. If modal, the overlay will be removed too.

## Centering pop-ups

There are two ways to center pop-ups, with different behavior.

The first way to center a pop-up is to pass a value of `true` to the third argument of `PopUpManager.addPopUp()`, named `isCentered`. In this case, the pop-up will be centered immediately when it is added to the display list. Then, if the stage resizes or the pop-up itself resizes, the pop-up will be repositioned in order to remain centered. The pop-up manager can only detect when the pop-up resizes if it is a Feathers component. Normal Starling display objects do not dispatch an appropriate event to indicate if they have been resized.

If you choose not to center a pop-up when you call `PopUpManager.addPopUp()`, you can center it manually by calling [`PopUpManager.centerPopUp()`](../api-reference/feathers/core/PopUpManager.html#centerPopUp()) and passing the pop-up as the only argument. This will center the pop-up only once. If the pop-up resizes or the stage resizes, you will need to call `PopUpManager.centerPopUp()` again to reposition it so that it remains centered.

## Customizing the `PopUpManager`

By customizing [`PopUpManager.overlayFactory`](../api-reference/feathers/core/PopUpManager.html#overlayFactory) you can change the appearance of the modal overlay. By default, this overlay is a fully transparent [`Quad`](http://doc.starling-framework.org/core/starling/display/Quad.html). It will block touches to the content below, but it has no appearance.

If you wanted to use a semi-transparent, colored Quad or another Starling display object for overlays, you can pass in a new `overlayFactory`:

``` code
PopUpManager.overlayFactory = function():DisplayObject
{
    var quad:Quad = new Quad(100, 100, 0x000000);
    quad.alpha = 0.75;
    return quad;
};
```

In the example above, the modal overlay is a black `Quad` with 75% opacity.

As mentioned above, you can customize the modal overlay for a specific pop-up only by passing in a custom overlay factory to [`PopUpManager.addPopUp()`](../api-reference/feathers/core/PopUpManager.html#addPopUp()):

``` code
PopUpManager.addPopUp( popUp, true, true, function():DisplayObject
{
    var quad:Quad = new Quad(100, 100, 0x000000);
    quad.alpha = 0.75;
    return quad;
});
```

You may customize the [`root`](../api-reference/feathers/core/PopUpManager.html#root) property of `PopUpManager`. This is the display object where pop-ups are added. By default, `PopUpManager` adds all pop-ups directly to the Starling stage.

``` code
var popUpContainer:Sprite = new Sprite();
this.stage.addChild( popUpContainer );
PopUpManager.root = popUpContainer;
```

In this case, we move pop-ups into a dedicated container on the stage. This might be useful for ensuring that other content always appears on top of all Feathers content, including the `PopUpManager`.

## Related Links

-   [`feathers.core.PopUpManager` API Documentation](../api-reference/feathers/core/PopUpManager.html)