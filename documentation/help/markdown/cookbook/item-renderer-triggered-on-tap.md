---
title: How to dispatch a triggered event from a custom item renderer  
author: Josh Tynjala

---
# How to dispatch a triggered event from a custom item renderer

A [custom item renderer](../item-renderers.html) should dispatch [`Event.TRIGGERED`](http://doc.starling-framework.org/core/starling/events/Event.html#TRIGGERED) when it is tapped or clicked, similar to a [`Button`](../button.html). 

Using the [`TapToTrigger`](../../api-reference/feathers/utils/touch/TapToTrigger.html) class, it's easy to dispatch `Event.TRIGGERED` on tap or click:

``` code
public class CustomItemRenderer extends LayoutGroupListItemRenderer
{
    public function CustomItemRenderer()
    {
        super();
        this._trigger = new TapToTrigger(this);
    }

    private var _trigger:TapToTrigger;
}
```

That's it! The `TouchEvent.TOUCH` listeners will be added automatically, and your item renderer will dispatch `Event.TRIGGERED` like a button.

You should also [learn how to use `TapToSelect`](item-renderer-select-on-tap.html) to change `isSelected` and dispatch `Event.CHANGE` when tapped or clicked.

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)

-   [Feathers Cookbook: Selecting a custom item renderer on tap or click](item-renderer-select-on-tap.html)

-   [Feathers Cookbook: Dispatching a long press event from a custom item renderer](item-renderer-long-press.html)