---
title: How to change font styles in a PickerList component  
author: Josh Tynjala

---
# How to change font styles in a `PickerList` component

A [`PickerList`](../picker-list.html) component contains two sub-components, a button and a pop-up list. The pop-up list contains item renderers that typically display some text. Both the button and the item renderers may have different font styles, and we'll look at how to change those outside of the theme.

## The button's font styles

We can customize the button inside the picker list's [`buttonFactory`](../../api-reference/feathers/controls/PickerList.html#buttonFactory). As long as we aren't setting any advanced font styles on the button's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly to the button's [`fontStyles`](../../api-reference/feathers/controls/Button.html#fontStyles) property.

``` actionscript
var pickerList:PickerList = new PickerList();
pickerList.buttonFactory = function():Button
{
	var button:Button = new Button();
	button.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
	return button;
};
```

If we wanted to change the button's font styles inside the theme, we could set the [`customButtonStyleName`](../../api-reference/feathers/controls/PickerList.html#customButtonStyleName) property on the `PickerList` and [extend the theme](../extending-themes.html).

## The item renderer font styles

Using the picker list's [`listFactory`](../../api-reference/feathers/controls/PickerList.html#listFactory) that creates the pop-up list, we can access the pop-up list's [`itemRendererFactory`](../../api-reference/feathers/controls/List.html#itemRendererFactory) to customize the item renderers. As long as we aren't setting any advanced font styles on the item renderer's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly the item renderer's [`fontStyles`](../../api-reference/feathers/controls/Button.html#fontStyles) property.

``` actionscript
var pickerList:PickerList = new PickerList();
pickerList.itemRendererFactory = function():IListItemRenderer
{
	var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
	itemRenderer.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
	return itemRenderer;
};
```

If we wanted to change the item renderer's font styles inside the theme, we could set the [`customItemRendererStyleName`](../../api-reference/feathers/controls/List.html#customItemRendererStyleName) property on the pop-up `List` and [extend the theme](../extending-themes.html).

## Related Links

-   [How to use the Feathers `PickerList` component](../picker-list.html)