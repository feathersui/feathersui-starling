---
title: How to change font styles in a TabBar component  
author: Josh Tynjala

---
# How to change font styles in a `TabBar` component

A [`TabBar`](../tab-bar.html) component contains one or more [`ToggleButton`](../toggle-button.html) sub-components that display some text. Let's look at how to change the font styles in the tabs outside of the theme.

## The tab font styles

We can customize the tabs inside the tab bar's [`tabFactory`](../../api-reference/feathers/controls/TabBar.html#tabFactory). As long as we aren't setting any advanced font styles on the tab's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly to the tab's [`fontStyles`](../../api-reference/feathers/controls/Button.html#fontStyles) property.

``` code
var tabs:TabBar = new TabBar();
tabs.tabFactory = function():ToggleButton
{
	var tab:ToggleButton = new ToggleButton();
	tab.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
	return tab;
};
```

If we wanted to change the tab's font styles inside the theme, we could set the [`customTabStyleName`](../../api-reference/feathers/controls/TabBar.html#customTabStyleName) property on the `TabBar` and [extend the theme](../extending-themes.html).

## Related Links

-   [How to use the Feathers `TabBar` component](../tab-bar.html)