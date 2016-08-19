---
title: How to use the Feathers TabNavigator component  
author: Josh Tynjala

---
# How to use the Feathers `TabNavigator` component

The [`TabNavigator`](../api-reference/feathers/controls/TabNavigator.html) class supports navigation between screens or pages using a [`TabBar`](tab-bar.html) sub-component.

-   [The Basics](#the-basics)

## The Basics

First, let's create a `TabNavigator` component and add it to the display list:

``` code
this._navigator = new TabNavigator();
this.addChild( this._navigator );
```

You may set its `width` and `height`, but that's optional because the `TabNavigator` will automatically resize itself to fill the entire stage, if you don't provide explicit dimensions.

To add a new screen that the navigator can show, call [`addScreen()`](../api-reference/feathers/controls/TabNavigator.html#addScreen()) and pass in an ID string to associate with the screen along with a [`TabNavigatorItem`](../api-reference/feathers/controls/TabNavigatorItem.html):

``` code
var newsFeedItem:TabNavigatorItem = new TabNavigatorItem( NewsFeedTab, "News" );
this._navigator.addScreen( "newsFeed", newsFeedItem );
```

This screen's ID is `"newsFeed"`. We can use use this ID later to programatically show the screen.

The first argument required by the `TabNavigatorItem` constructor may be one of three types. We can pass in a `Class` to instantiate, a display object that has already been instantiated, or a `Function` that returns a display object. In most cases, a `Class` is recommended. For more details, see the [`screen`](../api-reference/feathers/controls/StackScreenNavigatorItem.html#screen) property.

<aside class="info">In the example above, `NewsFeedTab` is another class that we create in our project that extends the [`Screen`](screen.html) class. In general, it's best to extend a class that implements the `IScreen` interface, like [`Screen`](screen.html), [`PanelScreen`](panel-screen.html), or [`ScrollScreen`](scroll-screen.html). Each offers different features. For instance, `Screen` is the most basic with optional support for layouts, while `PanelScreen` offers layouts, scrolling, and a customizable header and footer.</aside>

The second argument required by the `TabNavigatorItem` is the label to display on the tab associated with the screen. In this case, we've set it to `"News"`. 

Finally, we can also pass in an icon to be displayed on the tab. However, this is optional, and we've skipped it in the example above.

## Related Links

-   [`feathers.controls.TabNavigator` API Documentation](../api-reference/feathers/controls/TabNavigator.html)

-   [Transitions for Feathers screen navigators](transitions.html)

-   [How to use the Feathers `Screen` component](screen.html)

-   [How to use the Feathers `ScrollScreen` component](panel-screen.html)

-   [How to use the Feathers `PanelScreen` component](panel-screen.html)