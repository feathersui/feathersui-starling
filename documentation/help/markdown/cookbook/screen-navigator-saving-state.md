---
title: How to save the state of a screen and restore it later 
author: Josh Tynjala

---
# How to save the state of a screen and restore it later

Many times, when a user navigates away from a screen, they may return to the same screen in the future. In these cases, it is often desirable to restore the state of the screen as it was when the user navigated away. For instance, you might restore the scroll position of a list that appears on the screen.

`ScreenNavigatorItem` offers a simple system for setting properties on a screen when it is created. We can take advantage of this feature to store additional properties. In the following code, we store the vertical scroll position of a list in a property named `savedVerticalScrollPosition`:

``` code
var screenItem:ScreenNavigatorItem = this.owner.getScreen(this.screenID);
screenItem.properties.savedVerticalScrollPosition = this._list.verticalScrollPosition;
```

We can add that code at the point when we are leaving the screen. Perhaps when selecting an item from the list component.

Then, in our screen class, we can simply add a new property of the same name:

``` code
public var savedVerticalScrollPosition:Number = 0;
```

Finally, we can pass that property to the list when we initialize the screen:

``` code
override protected function initialize():void
{
    super.initialize();
    this._list.verticalScrollPosition = this._savedVerticalScrollPosition;
}
```

## Related Links

-   [How to use the ScreenNavigator component](../screen-navigator.html)

This is a recipe in the [Feathers Cookbook](index.html). For more information about Feathers, return to the [Feathers Documentation](../index.html).


