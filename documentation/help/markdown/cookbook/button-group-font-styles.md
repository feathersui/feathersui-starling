---
title: How to change font styles in a ButtonGroup component  
author: Josh Tynjala

---
# How to change font styles in a `ButtonGroup` component

A [`ButtonGroup`](../button-group.html) component contains one or more [`Button`](../button.html) sub-components that display some text. Let's look at how to change the font styles in the buttons outside of the theme.

## The button font styles

We can customize the buttons inside the button group's [`buttonFactory`](../../api-reference/feathers/controls/ButtonGroup.html#buttonFactory). As long as we aren't setting any advanced font styles on the button's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly to the button's [`fontStyles`](../../api-reference/feathers/controls/Button.html#fontStyles) property.

``` code
var group:ButtonGroup = new ButtonGroup();
group.buttonFactory = function():Button
{
	var button:Button = new Button();
	button.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
	return button;
};
```

If we wanted to change the button's font styles inside the theme, we could set the [`customButtonStyleName`](../../api-reference/feathers/controls/ButtonGroup.html#customButtonStyleName) property on the `ButtonGroup` and [extend the theme](../extending-themes.html).

## Related Links

-   [How to use the Feathers `ButtonGroup` component](../button-group.html)