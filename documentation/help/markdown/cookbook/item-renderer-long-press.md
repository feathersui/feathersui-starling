---
title: How to dispatch a long press event from a custom item renderer  
author: Josh Tynjala

---
# How to dispatch a long press event from a custom item renderer

A [custom item renderer](../item-renderers.html) may optionally dispatch [`FeathersEventType.LONG_PRESS`](../../api-reference/feathers/events/FeathersEventType.html#LONG_PRESS), similar to a [`Button`](../button.html). 

Using the [`LongPress`](../../api-reference/feathers/utils/touch/LongPress.html) class, it's easy to dispatch `FeathersEventType.LONG_PRESS`:

``` actionscript
public class CustomItemRenderer extends LayoutGroupListItemRenderer
{
    public function CustomItemRenderer()
    {
        super();
        this._longPress = new LongPress(this);
    }

    private var _longPress:LongPress;
}
```

That's it! The `TouchEvent.TOUCH` listeners will be added automatically, and your item renderer will dispatch `FeathersEventType.LONG_PRESS` like a button.

## Combined with Event.TRIGGERED or Event.CHANGE

If you plan to combine, `LongPress` with [`TapToTrigger`](../../api-reference/feathers/utils/touch/TapToTrigger.html) or [`TapToSelect`](../../api-reference/feathers/utils/touch/LongPress.html), you should ensure that the other two events aren't dispatched after a long press.

First, always create the `LongPress` instance before the `TapToTrigger` and `TapToSelect` instances. This ensures that the `TouchEvent.TOUCH` listener in `LongPress` gets a higher priority.

``` actionscript
this._longPress = new LongPress(this);
this._trigger = new TapToTrigger(this);
this._select = new TapToSelect(this);
```

Then, pass the `TapToTrigger` and `TapToSelect` instances to the `LongPress` so that it can disable them temporarily after a long press.

``` actionscript
this._longPress.tapToTrigger = this._trigger;
this._longPress.tapToSelect = this._select;
```

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)

-   [Feathers Cookbook: How to select (or deselect) a custom item renderer on tap or click](item-renderer-select-on-tap.html)

-   [Feathers Cookbook: How to dispatch a triggered event from a custom item renderer](item-renderer-triggered-on-tap.html)