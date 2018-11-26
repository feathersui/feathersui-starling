---
title: How to select (or deselect) a custom item renderer on tap or click  
author: Josh Tynjala

---
# How to select (or deselect) a custom item renderer on tap or click

[Custom item renderers](../item-renderers.html) should dispatch `Event.CHANGE` when their [`isSelected`](../../api-reference/feathers/controls/renderers/IToggle.html#isSelected) property changes. The list does not select an item renderer on tap or click because some item renderers might be selected with a different interaction, like a long press or a swipe. The item renderer needs to implement this behavior.

Using the [`TapToSelect`](../../api-reference/feathers/utils/touch/TapToSelect.html) class, it's easy to change the `isSelected` property on tap or click:

``` actionscript
public class CustomItemRenderer extends LayoutGroupListItemRenderer
{
    public function CustomItemRenderer()
    {
        super();
        this._select = new TapToSelect(this);
    }

    private var _select:TapToSelect;
}
```

## Deselect on Tap or Click

You may notice that the item renderer is selected on tap, but not deselected when you tap again. Generally, that's how you want a list to behave. The item renderer will be deselected when another item renderer is selected. However, sometimes the list supports multiple selection, and you want to deselect the item renderer on tap or click. Simply set the [`tapToDeselect`](../../api-reference/feathers/utils/touch/TapToSelect.html#tapToDeselect) property of the `TapToSelect` instance to `true`:

``` actionscript
this._select.tapToDeselect = true;
```

Set the [`allowMultipleSelection`](../../api-reference/feathers/controls/List.html#allowMultipleSelection) property on the `List` to `true` to allow multiple item renderers to be selected.

## Dispatch `Event.TRIGGERED` when tapped or clicked

All item renderers should also dispatch [`Event.TRIGGERED`](../../api-reference/feathers/controls/renderers/IListItemRenderer.html#event:triggered) when tapped.

Similar to `TapToSelect`, you can use [`TapToTrigger`](../../api-reference/feathers/utils/touch/TapToTrigger.html) to set this up automatically:

``` actionscript
public class CustomItemRenderer extends LayoutGroupListItemRenderer
{
    public function CustomItemRenderer()
    {
        super();
        this._trigger = new TapToTrigger(this);
        this._select = new TapToSelect(this);
    }

    private var _trigger:TapToTrigger;
    private var _select:TapToSelect;
}
```

Always be sure to create the `TapToTrigger` instance before the `TapToSelect` instance so that the `Event.TRIGGERED` and `Event.CHANGE` events are dispatched in the correct order.

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)

-   [Feathers Cookbook: Dispatching a triggered event from a custom item renderer](item-renderer-triggered-on-tap.html)

-   [Feathers Cookbook: Dispatching a long press event from a custom item renderer](item-renderer-long-press.html)