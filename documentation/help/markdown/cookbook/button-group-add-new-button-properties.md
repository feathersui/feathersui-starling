---
title: How to set additional properties on the buttons in a ButtonGroup  
author: Josh Tynjala

---
# How to set additional properties on the buttons in a `ButtonGroup`

[`ButtonGroup`](../button-group.html) supports setting a number of properties on its buttons through its [`dataProvider`](../../api-reference/feathers/controls/ButtonGroup.html#dataProvider) property, like [`label`](../../api-reference/feathers/controls/Button.html#label) and [`isEnabled`](../../api-reference/feathers/core/FeathersControl.html#isEnabled). Sometimes, we may need to set additional properties on the buttons. `ButtonGroup` makes it easy to customize how its `dataProvider` is interpreted with the [`buttonInitializer`](../../api-reference/feathers/controls/ButtonGroup.html#dataProvider) property.

The `buttonInitializer` is a function that is called for each item in the data provider. The `ButtonGroup` passes in a [`Button`](../button.html) and an item from the data provider. The function signature looks like this:

``` actionscript
function( button:Button, item:Object ):void
```

If we want the `ButtonGroup` to support additional properties on its buttons, we can pass in a custom `buttonInitializer`. First, though, let's save a reference to the default `buttonInitializer` in a variable because we want to preserve the default behavior:

``` actionscript
var group:ButtonGroup = new ButtonGroup();
var defaultButtonInitializer:Function = group.buttonInitializer;
```

Now, we can create our own custom `buttonInitializer` function that sets additional properties:

``` actionscript
function customButtonInitializer( button:Button, item:Object ):void
{
	// keep the default behavior
	defaultButtonInitializer( button, item );
 
	// then add new properties!
	button.scaleWhenDown = item.scaleWhenDown;
}

group.buttonInitializer = customButtonInitializer;
```

Notice that we call the `defaultButtonInitializer` first. We still want to set properties like `label` and `isEnabled` and add listeners like `Event.TRIGGERED`.

Afterwards, we've also chosen to copy the `scaleWhenDown` property from the item to the button.

If we wanted to make some properties optional, we could call `hasOwnProperty()` before setting them, like this:

``` actionscript
if( item.hasOwnProperty( "scaleWhenDown" ) )
{
	button.scaleWhenDown = item.scaleWhenDown;
}
```

## Related Links

-   [How to use the Feathers `ButtonGroup` component](../button-group.html)