---
title: How to change font styles in a TabNavigator component  
author: Josh Tynjala

---
# How to change font styles in a `TabNavigator` component

A [`TabNavigator`](../tab-navigator.html) component displays text in its tabs, which are sub-components of the [`TabBar`](../tab-bar.html). Let's look at how to change the font styles of the tabs outside of the theme.

## The tab font styles

Using the [`tabBarFactory`](../../api-reference/feathers/controls/TabNavigator.html#tabBarFactory) property that creates the `TabBar` for the `TabNavigator`, we can access the tab bar's [`tabFactory`](../../api-reference/feathers/controls/TabBar.html#tabFactory) to customize the tabs. As long as we aren't setting any advanced font styles on the tab's [text renderer](../text-renderers.html) (and the theme isn't either), we can pass a `starling.text.TextFormat` directly the tab's [`fontStyles`](../../api-reference/feathers/controls/Button.html#fontStyles) property.

``` actionscript
var navigator:TabNavigator = new TabNavigator();
navigator.tabBarFactory = function():TabBar
{
	var tabBar:TabBar = new TabBar();
	tabBar.tabFactory = function():ToggleButton
	{
		var tab:ToggleButton = new ToggleButton();
		tab.fontStyles = new TextFormat( "Arial", 20, 0x3c3c3c );
		return tab;
	};
	return tabBar;
};
```

If we wanted to change the tab's font styles inside the theme, we could set the [`customTabStyleName`](../../api-reference/feathers/controls/TabBar.html#customTabStyleName) property on the `TabBar` and [extend the theme](../extending-themes.html).

## Related Links

-   [How to use the Feathers `TabNavigator` component](../tab-navigator.html)
-   [How to use the Feathers `TabBar` component](../tab-navigator.html)