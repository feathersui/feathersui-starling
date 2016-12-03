---
title: How to change font styles in a AutoComplete component  
author: Josh Tynjala

---
# How to change font styles in a `AutoComplete` component

A [`AutoComplete`](../auto-complete.html) component displays its own text like a `TextInput`, and it has a pop-up list sub-component. The pop-up list contains item renderers that typically display some text. Both the `AutoComplete` and the item renderers may have different font styles, and we'll look at how to change those outside of the theme.

## The main input font styles

We can customize the main input font styles directly on the `AutoComplete`. As long as we aren't setting any advanced font styles on the [text editor](../text-editors.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly to the [`fontStyles`](../../api-reference/feathers/controls/TextInput.html#fontStyles) property.

``` code
var input:AutoComplete = new AutoComplete();
input.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
```

If we wanted to change the main input font styles inside the theme, we could [extend the theme](../extending-themes.html).

## The item renderer font styles

Using the [`listFactory`](../../api-reference/feathers/controls/AutoComplete.html#listFactory) property that creates the pop-up list for the `AutoComplete`, we can access the pop-up list's [`itemRendererFactory`](../../api-reference/feathers/controls/List.html#itemRendererFactory) to customize the item renderers. As long as we aren't setting any advanced font styles on the item renderer's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly the item renderer's [`fontStyles`](../../api-reference/feathers/controls/Button.html#fontStyles) property.

``` code
var input:AutoComplete = new AutoComplete();
input.listFactory = function():List
{
	var list:List = new List();
	list.itemRendererFactory = function():IListItemRenderer
	{
		var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
		itemRenderer.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
		return itemRenderer;
	};
	return list;
};
```

If we wanted to change the item renderer's font styles inside the theme, we could set the [`customItemRendererStyleName`](../../api-reference/feathers/controls/List.html#customItemRendererStyleName) property on the pop-up `List` and [extend the theme](../extending-themes.html).

## Related Links

-   [How to use the Feathers `AutoComplete` component](../auto-complete.html)