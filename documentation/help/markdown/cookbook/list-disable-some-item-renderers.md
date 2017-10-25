---
title: How to disable some item renderers in a Feathers List component  
author: Josh Tynjala

---
# How to disable some item renderers in a Feathers `List` component

In your data provider, add a new property to the items that will indicate whether the item renderer should be enabled or not. In this example, we call it `enabled`, but you can choose any name:

``` code
list.dataProvider = new ArrayCollection(
[
	{ text: "Some Item", enabled: true },
	{ text: "Another One", enabled: false },
]);
```

In your `itemRendererFactory`, set the `itemHasEnabled` property of the item renderer to `true`. Then, pass the name of the new property to the `enabledField` property:

``` code
list.itemRendererFactory = function():IListItemRenderer
{
	var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
	itemRenderer.labelField = "text";

	itemRenderer.itemHasEnabled = true;
	itemRenderer.enabledField = "enabled";
	
	return itemRenderer;
};
```

To update whether an item renderer is enabled or not after the `List` has been created, change the property in the data provider:

``` code
var item:Object = list.dataProvider.getItemAt(4);
item.enabled = false;
```

Then, call `updateItemAt()` with the item's index to update the item renderer with the new data:

``` code
list.dataProvider.updateItemAt(4);
```

## Related Links

-   [How to use the Feathers `List` component](../list.html)
-   [How to use the default Feathers item renderer with `List`, `DataGrid`, `Tree`, and `GroupedList`](../default-item-renderers.html)