---
title: How to change font styles in a List component  
author: Josh Tynjala

---
# How to change font styles in a `List` component

A [`List`](../list.html) component contains a number of [item renderers](../default-item-renderers.html) that display some text. Let's look at how to change the font styles in the item renderers outside of the theme.

## The item renderer font styles

We can customize the item renderers inside the list's [`itemRendererFactory`](../../api-reference/feathers/controls/List.html#itemRendererFactory). As long as we aren't setting any advanced font styles on the item renderer's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly to the item renderer's [`fontStyles`](../../api-reference/feathers/controls/Button.html#fontStyles) property.

``` code
var list:List = new List();
list.itemRendererFactory = function():IListItemRenderer
{
	var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
	itemRenderer.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
	return itemRenderer;
};
```

If we wanted to change the item renderer's font styles inside the theme, we could set the list's [`customItemRendererStyleName`](../../api-reference/feathers/controls/List.html#customItemRendererStyleName) property and [extend the theme](../extending-themes.html).

## Related Links

-   [How to use the Feathers `List` component](../list.html)

-   [How to use the Feathers default item renderers](../default-item-renderers.html)