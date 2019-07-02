---
title: How to use the Feathers TabNavigator component  
author: Josh Tynjala

---
# How to use the Feathers `TabNavigator` component

The [`TabNavigator`](../api-reference/feathers/controls/TabNavigator.html) class supports navigation between screens or pages using a [`TabBar`](tab-bar.html) sub-component.

-   [The Basics](#the-basics)

-   [Navigation](#navigation)

-   [Animated Transitions](#animated-transitions)

-   [Property Injection](#property-injection)

## The Basics

First, let's create a `TabNavigator` component and add it to the display list:

``` actionscript
var navigator:TabNavigator = new TabNavigator();
this.addChild( navigator );
```

You may set its `width` and `height`, but that's optional because the `TabNavigator` will automatically resize itself to fill the entire stage, if you don't provide explicit dimensions.

To add a new screen that the navigator can show, call [`addScreen()`](../api-reference/feathers/controls/TabNavigator.html#addScreen()) and pass in an ID string to associate with the screen along with a [`TabNavigatorItem`](../api-reference/feathers/controls/TabNavigatorItem.html):

``` actionscript
var newsFeedItem:TabNavigatorItem = new TabNavigatorItem( NewsFeedTab, "News" );
navigator.addScreen( "newsFeed", newsFeedItem );
```

This screen's ID is `"newsFeed"`. We can use use this ID later to programatically show the screen.

The first argument required by the `TabNavigatorItem` constructor may be one of three types. We can pass in a `Class` to instantiate, a display object that has already been instantiated, or a `Function` that returns a display object. In most cases, a `Class` is recommended. For more details, see the [`screen`](../api-reference/feathers/controls/TabNavigatorItem.html#screen) property.

<aside class="info">In the example above, `NewsFeedTab` is another class that we create in our project that extends the [`Screen`](screen.html) class. In general, it's best to extend a class that implements the `IScreen` interface, like [`Screen`](screen.html), [`PanelScreen`](panel-screen.html), or [`ScrollScreen`](scroll-screen.html). Each offers different features. For instance, `Screen` is the most basic with optional support for layouts, while `PanelScreen` offers layouts, scrolling, and a customizable header and footer.</aside>

The second argument required by the `TabNavigatorItem` is the label to display on the tab associated with the screen. In this case, we've set it to `"News"`. 

Finally, we can also pass in an icon to be displayed on the tab. However, this is optional, and we've skipped it in the example above.

## Navigation

The active screen changes when the user selects a tab. When the first tab is added to a `TabNavigator`, it is automatically selected.

To show a specific screen programatically, we can set the [`selectedIndex`](../api-reference/feathers/controls/TabNavigator.html#selectedIndex):

``` actionscript
navigator.selectedIndex = 1;
```

Alternatively, call [`showScreen()`](../api-reference/feathers/controls/TabNavigator.html#showScreen()), and pass in the screen's ID. For this example, we'll use the `"newsFeed"` string that we registered with `addScreen()` earlier:

``` actionscript
navigator.showScreen( "newsFeed" );
```

The `showScreen()` method supports an additional arugment that allows a custom animated transition between screens. We'll look at transitions in a moment.

To access the currently visible screen, use the [`activeScreen`](../api-reference/feathers/controls/supportClasses/BaseScreenNavigator.html#activeScreen) property.

``` actionscript
var screen:NewsFeedTab = NewsFeedTab( navigator.activeScreen );
```

You can also use [`activeScreenID`](../api-reference/feathers/controls/supportClasses/BaseScreenNavigator.html#activeScreenID) to get the ID of the active screen. In this case, again, it would be `"newsFeed"`.

## Animated Transitions

As we learned above, we can change to a new screen in a couple of different ways. The transition between two screens can also be animated, improving the user experience and adding a little bit of life to our games and apps. This animation during navigation is called a [*transition*](transitions.html).

We can find a number of useful transition classes in the [`feathers.motion`](../api-reference/feathers/motion/package-detail.html) package. One example is the [`Fade`](../api-reference/feathers/motion/Fade.html) class, which fades a screen by animating its `alpha` property.

Each of the built-in transition classes has one or more static methods that you can call to create a *transition function* that tab navigator calls when navigating to a different screen. In this case, let's call [`Fade.createFadeInTransition()`](../api-reference/feathers/motion/Fade.html#createFadeInTransition()).

We can pass the result to the tab navigator's [`transition`](../api-reference/feathers/controls/TabNavigator.html#transition) property:

``` actionscript
navigator.transition = Fade.createFadeInTransition();
```

In the code above, we didn't pass any arguments to `Fade.createFadeInTransition()`. However, this function exposes some optional parameters that we can customize, if desired. For instance, we might want to customize the duration of the animation (in seconds) and the easing function:

``` actionscript
navigator.transition = Fade.createFadeInTransition( 0.75, Transitions.EASE_IN_OUT );
```

Now, the animation will last a little longer while easing in and out.

<aside class="info">See [Transitions for Feathers screen navigators](transitions.html) for a more detailed look at the available transitions, including instructions for creating custom transitions.</aside>

### Events when transitions start and complete

A `TabNavigator` dispatches [`FeathersEventType.TRANSITION_START`](../api-reference/feathers/controls/supportClasses/BaseScreenNavigator.html#event:transitionStart) when a new screen is being shown and the transition animation begins. Similarly, it dispatches [`FeathersEventType.TRANSITION_COMPLETE`](../api-reference/feathers/controls/supportClasses/BaseScreenNavigator.html#event:transitionComplete) when the transition animation has ended.

<aside class="info">If a specific screen needs to know when its transition in (or out) starts or completes, we can listen for different events that provide a little more control. See [How to use the Feathers `Screen` component](screen.html) (or [`ScrollScreen`](scroll-screen.html) or [`PanelScreen`](panel-screen.html)) for details.</aside>

Let's listen for `FeathersEventType.TRANSITION_COMPLETE`:

``` actionscript
navigator.addEventListener( FeathersEventType.TRANSITION_COMPLETE, navigator_transitionCompleteHandler );
```

The event listener might look like this:

``` actionscript
private function navigator_transitionCompleteHandler( event:Event ):void
{
    // do something after the transition animation
}
```

## Property Injection

Optionally, we can pass properties to the screen before it is shown. If we have multiple screens that need to share some data, this is a useful way to ensure that each screen has access to it. For instance, we might have an `OptionsData` class that stores things like audio volume and other common options. We'd want to pass that to the `OptionsScreen` to let the user change the volume, obviously. We'd also want to pass it to other screens that play audio so that it plays at the correct volume.

When we create the `TabNavigator`, let's create an `OptionsData` instance too. In a moment, we'll pass it to each screen that needs it.

``` actionscript
var optionsData:OptionsData = new OptionsData();
```

Now, when we add our `OptionsScreen` to the `TabNavigator`, we pass it the `OptionsData` instance in using the [`properties`](../api-reference/feathers/controls/TabNavigatorItem.html#properties) property on the `TabNavigatorItem`:

``` actionscript
var optionsItem:TabNavigatorItem = new TabNavigatorItem( OptionsScreen );
optionsItem.properties.options = optionsData;
```

In `OptionsScreen`, we need to add a variable or a getter and setter named `options` to match up with `optionsItem.properties.options`:

``` actionscript
protected var _options:OptionsData;
 
public function get options():OptionsData
{
    return this._options;
}
 
public function set options( value:OptionsData ):void
{
    this._options = value;
}
```

We want to update the screen when the `options` property changes, so we should invalidate the screen, and the `draw()` function will be called again:

``` actionscript
public function set options( value:OptionsData ):void
{
    if(this._options == value)
    {
        return;
    }
    this._options = value;
    this.invalidate( INVALIDATION_FLAG_DATA );
}
```

<aside class="warn">Objects that are passed by value (like `Number`, `Boolean`, and `int`) should not be used directly with property injection. Each screen will get a copy instead of a reference, so if one screen changes the value, another won't see the change. Always combine simple values like this together into a custom class that can be passed by reference.</aside>

## Related Links

-   [`feathers.controls.TabNavigator` API Documentation](../api-reference/feathers/controls/TabNavigator.html)

-   [Transitions for Feathers screen navigators](transitions.html)

-   [How to use the Feathers `Screen` component](screen.html)

-   [How to use the Feathers `ScrollScreen` component](panel-screen.html)

-   [How to use the Feathers `PanelScreen` component](panel-screen.html)