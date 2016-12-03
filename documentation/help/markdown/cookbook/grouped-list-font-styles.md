---
title: How to change font styles in a GroupedList component  
author: Josh Tynjala

---
# How to change font styles in a `GroupedList` component

A [`GroupedList`](../grouped-list.html) component contains a number of [item renderers](../default-item-renderers.html) and header or footer renderers that display some text. Let's look at how to change the font styles in these renderers outside of the theme.

## The item renderer font styles

We can customize the item renderers inside the grouped list's [`itemRendererFactory`](../../api-reference/feathers/controls/GroupedList.html#itemRendererFactory). As long as we aren't setting any advanced font styles on the item renderer's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly to the item renderer's [`fontStyles`](../../api-reference/feathers/controls/Button.html#fontStyles) property.

``` code
var list:GroupedList = new GroupedList();
list.itemRendererFactory = function():IGroupedListItemRenderer
{
	var itemRenderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
	itemRenderer.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
	return itemRenderer;
};
```

If we wanted to change the item renderer's font styles inside the theme, we could set the grouped list's [`customItemRendererStyleName`](../../api-reference/feathers/controls/GroupedList.html#customItemRendererStyleName) property and [extend the theme](../extending-themes.html).

## The header renderer font styles

We can customize the header renderers inside the grouped list's [`headerRendererFactory`](../../api-reference/feathers/controls/GroupedList.html#headerRendererFactory). As long as we aren't setting any advanced font styles on the header renderer's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly to the header renderer's [`fontStyles`](../../api-reference/feathers/controls/renderers/DefaultGroupedListHeaderOrFooterRenderer.html#fontStyles) property.

``` code
var list:GroupedList = new GroupedList();
list.headerRendererFactory = function():IGroupedListHeaderRenderer
{
	var headerRenderer:DefaultGroupedListHeaderOrFooterRenderer = new DefaultGroupedListHeaderOrFooterRenderer();
	headerRenderer.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
	return headerRenderer;
};
```

If we wanted to change the header renderer's font styles inside the theme, we could set the grouped list's [`customHeaderRendererStyleName`](../../api-reference/feathers/controls/GroupedList.html#customHeaderRendererStyleName) property and [extend the theme](../extending-themes.html).

## The footer renderer font styles

We can customize the footer renderers inside the grouped list's [`footerRendererFactory`](../../api-reference/feathers/controls/GroupedList.html#footerRendererFactory). As long as we aren't setting any advanced font styles on the footer renderer's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly to the footer renderer's [`fontStyles`](../../api-reference/feathers/controls/renderers/DefaultGroupedListHeaderOrFooterRenderer.html#fontStyles) property.

``` code
var list:GroupedList = new GroupedList();
list.footerRendererFactory = function():IGroupedListFooterRenderer
{
	var footerRenderer:DefaultGroupedListHeaderOrFooterRenderer = new DefaultGroupedListHeaderOrFooterRenderer();
	footerRenderer.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
	return footerRenderer;
};
```

If we wanted to change the footer renderer's font styles inside the theme, we could set the grouped list's [`customFooterRendererStyleName`](../../api-reference/feathers/controls/GroupedList.html#customFooterRendererStyleName) property and [extend the theme](../extending-themes.html).

## Related Links

-   [How to use the Feathers `GroupedList` component](../grouped-list.html)

-   [How to use the Feathers default item renderers](../default-item-renderers.html)