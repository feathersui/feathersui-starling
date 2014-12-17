---
title: How to use the Feathers ScreenNavigator component  
author: Josh Tynjala

---
# How to use the Feathers ScreenNavigator component

The [`ScreenNavigator`](../api-reference/feathers/controls/ScreenNavigator.html) class supports navigation between screens or pages. It is best suited for working with a set of screens in a flat hierarchy. For instance, each screen might be associated with a tab in a [`TabBar`](tab-bar.html).

Events dispatched from the active screen can be used to trigger navigation. Navigation can be enhanced with animation, called a [transition](transitions.html). Feathers provides a number of transitions out of the box, and a simple API lets you create custom transitions.

<aside class="info">For a screen navigator that keeps a history that allows you to navigate back to previous screens, see [`StackScreenNavigator`](stack-screen-navigator.html) instead.</aside>

## The Basics

Create a `ScreenNavigator` like this:

``` code
this._navigator = new ScreenNavigator();
this.addChild( this._navigator );
```

You may also set its `width` and `height`, but that's optional because the `ScreenNavigator` will automatically resize itself to fill the entire stage, if you don't provide explicit dimensions.

To add a new screen that the navigator can show, call [`addScreen()`](../api-reference/feathers/controls/ScreenNavigator.html#addScreen()) and pass in an ID string to associate with the screen along with a [`ScreenNavigatorItem`](../api-reference/feathers/controls/ScreenNavigatorItem.html):

``` code
var mainMenuItem:ScreenNavigatorItem = new ScreenNavigatorItem( MainMenuScreen );
this._navigator.addScreen( "mainMenu", mainMenuItem );
```

This screen's ID is `"mainMenu"`. We'll use this ID later when we ask the screen navigator to display this screen. There are a number of other APIs that require this ID too.

The first argument required by the `ScreenNavigatorItem` constructor may be one of three types. We can pass in a `Class` to instantiate, a display object that has already been instantiated, or a `Function` that returns a display object. In most cases, a `Class` is recommended. For more details, see the [`screen`](http://feathersui.com/beta/api-reference/feathers/controls/ScreenNavigatorItem.html#screen) property.

<aside class="info">In the example above, `MainMenuScreen` is another class that we create in our project that extends the [`Screen`](screen.html) class. In general, it's best to extend a class that implements the `IScreen` interface, like [`Screen`](screen.html), [`PanelScreen`](panel-screen.html), or [`ScrollScreen`](scroll-screen.html). Each offers different features. For instance, `Screen` is the most basic with optional support for layouts, while `PanelScreen` offers layouts, scrolling, and a customizable header and footer.</aside>

To show a specific screen, call [`showScreen()`](../api-reference/feathers/controls/ScreenNavigator.html#showScreen()), and pass in the screen's ID. We'll use the `"mainMenu"` string that we registered with `addScreen()` earlier:

``` code
this._navigator.showScreen( "mainMenu" );
```

To access the currently visible screen, use the `activeScreen` property.

``` code
var mainMenu:MainMenuScreen = MainMenuScreen( this._navigator.activeScreen );
```

You can also use `activeScreenID` to get the ID of the active screen. In this case, again, it would be `"mainMenu"`.

To make the `ScreenNavigator` remove the active screen, call `clearScreen()`.

``` code
this._navigator.clearScreen();
```

## Navigation

If the active screen dispatches an event, the `ScreenNavigator` can listen for it to automatically navigate to another screen.

Before we get to that, let's make a couple of changes to our existing code. First, let's move the main menu screen's ID into a constant. Then, let's add a second screen.

``` code
private static const MAIN_MENU:String = "mainMenu";
private static const OPTIONS:String = "options";
```

The constants will help us avoid typing mistakes that the compiler can easily catch. Let's use the `MAIN_MENU` constant in the call to `addScreen()`:

``` code
var mainMenuItem:ScreenNavigatorItem = new ScreenNavigatorItem( MainMenuScreen );
this._navigator.addScreen( MAIN_MENU, mainMenuItem );
```

You probably noticed that we defined an `OPTIONS` constant too. Let's add the options screen that goes with it:

``` code
var optionsItem:ScreenNavigatorItem = new ScreenNavigatorItem( OptionsScreen );
this._navigator.addScreen( OPTIONS, optionsItem );
```

Now that we have a second screen, let's look at how we can navigate from the main menu to the options screen.

### Dispatch events from the screen

The best way to navigate from one screen to another is to dispatch an event from the currently active screen. Using the `ScreenNavigatorItem`, we can map an event to a screen indentifier. The `ScreenNavigator` will automatically navigate to a different screen when one of these events is dispatched. Let's map an event from the main menu screen that will navigate to the options screen:

``` code
var mainMenuItem:ScreenNavigatorItem = new ScreenNavigatorItem( MainMenuScreen );
mainMenuItem.setScreenIDForEvent( MainMenuScreen.SHOW_OPTIONS, OPTIONS );
this._navigator.addScreen( MAIN_MENU, mainMenuItem );
```

Using [`setScreenIDForEvent()`](../api-reference/feathers/controls/ScreenNavigatorItem.html#setScreenIDForEvent()), we tell the `ScreenNavigatorItem` that the screen navigator should navigate to the screen with the `OPTIONS` ID when `MainMenuScreen.SHOW_OPTIONS` is dispatched by the `MainMenuScreen`.

Inside `MainMenuScreen`, we can add a constant named `SHOW_OPTIONS` that we'll use as an event type:

``` code
public static const SHOW_OPTIONS:String = "showOptions";
```

Then, we might dispatch this event when a button is triggered:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this.dispatchEventWith( SHOW_OPTIONS );
}
```

Next, let's repeat the process with the options screen to navigate back to the main menu screen when an event is dispatched.

``` code
var optionsItem:ScreenNavigatorItem = new ScreenNavigatorItem( OptionsScreen );
optionsItem.setScreenIDForEvent( Event.COMPLETE, MAIN_MENU );
this._navigator.addScreen( OPTIONS, optionsItem );
```

Inside `OptionsScreen`, we might dispatch an event when a button is triggered, similar to how we did it in `MainMenuScreen`. This time, we'll just use the built in `Event.COMPLETE` constant instead of defining a new one:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this.dispatchEventWith( Event.COMPLETE );
}
```

Now, we can navigate back and forth between the two screens.

We can call `setScreenIDForEvent()` as many times as needed to listen for multiple events.

## Transitions

As we learned above, we can either show a screen or we can clear the currently active screen. Each of these actions can be animated, improving the user experience and adding a little bit of life to our games and apps. This animation during navigation is called a *transition*.

We can find a number of useful transition classes in the [`feathers.motion.transitions`](../api-reference/feathers/motion/transitions/package-detail.html) package. One example is the [`Fade`](../api-reference/feathers/motion/transitions/Slide.Fade) class, which fades a screen by animating its `alpha` property.

Each of the built-in transition classes has one or more static methods that you can call to create a *transition function* that screen navigator calls when navigating to a different screen. In this case, let's call [`Fade.createFadeInTransition()`](../api-reference/feathers/motion/transitions/Fade.html#createFadeInTransition()).

We can pass the result to the screen navigator's [`transition`](../api-reference/feathers/controls/ScreenNavigator.html#transition) property:

``` code
this._navigator.transition = Fade.createFadeInTransition();
```

In the code above, we didn't pass any arguments to `Fade.createFadeInTransition()`. However, this function exposes some optional parameters that we can customize, if desired. For instance, we might want to customize the duration of the animation (in seconds) and the easing function:

``` code
this._navigator.transition = Fade.createFadeInTransition( 0.75, Transitions.EASE_IN_OUT );
```

Now, the animation will last a little longer while easing in and out.

See [Transitions for Feathers screen navigators](transitions.html) for a more detailed look at the available transitions, including instructions for creating custom transitions.

### Events when transitions start and complete

The `ScreenNavigator` dispatches `FeathersEventType.TRANSITION_START` and `FeathersEventType.TRANSITION_COMPLETE` events when the transition starts and ends. You might listen to `FeathersEventType.TRANSITION_COMPLETE` to delay the initialization of your screen until the transition has completed. For instance, you might have other animations that need to play, but once the screen is fully visible.

``` code
this.owner.addEventListener( FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler );
```

The event listener might look like this:

``` code
private function owner_transitionCompleteHandler( event:Event ):void
{
    this.owner.removeEventListener( FeathersEventType.TRANSITION_COMPLETE, owner_transitionCompleteHandler );
 
    // finish initialization here
}
```

Note that the `ScreenNavigator` will dispatch the `FeathersEventType.TRANSITION_START` and `FeathersEventType.TRANSITION_COMPLETE` events when a screen is being removed too. You will need to remove event listeners meant to be called only when the screen is added if you don't want them to run again when the screen is removed.

## Property Injection

The third argument you can pass to the `ScreenNavigatorItem` constructor is an initializer object. This is a set of key-value pairs that map to properties on the screen being defined. When the screen is shown, each of these properties will be passed to the screen. If you have multiple screens that need to share some data, this is a useful way to ensure that they each have access to it. For instance, you might have an `OptionsData` class that stores things like audio volume and other common options.

In our main app, we store the `OptionsData` instance.

``` code
this._optionsData = new OptionsData();
```

Then, when we add our `OptionsScreen`, we pass it the `OptionsData` instance in using the initializer.

``` code
this._navigator.addScreen( OPTIONS, new ScreenNavigatorItem( OptionsScreen,
{
    complete: MAIN_MENU
},
{
    optionsData: _optionsData
}));
```

In `OptionsScreen`, we need to add a variable or a getter and setter for this data:

``` code
protected var _optionsData:OptionsData;
 
public function get optionsData():OptionsData
{
    return this._optionsData;
}
 
public function set optionsData( value:OptionsData ):void
{
    this._optionsData = value;
}
```

If you want to redraw when `optionsData` changes, you should invalidate the screen, and the `draw()` function will be called again:

``` code
public function set optionsData( value:OptionsData ):void
{
    if(this._optionsData == value)
    {
        return;
    }
    this._optionsData = value;
    this.invalidate( INVALIDATION_FLAG_DATA );
}
```

## Advanced Functionality

`ScreenNavigator` offers a number of advanced features to customize navigation behavior.

### Call a function instead of navigating to a different screen

The `ScreenNavigatorItem` event map can be used for more than just navigation. You can also call a function when an event or signal is dispatched. Let's add a new signal to the main menu that will be dispatched when a "About Our Product" button is clicked. We want it to open a website in the browser.

``` code
this._navigator.addScreen( MAIN_MENU, new ScreenNavigatorItem( MainMenuScreen,
{
    onOptions: OPTIONS,
    onHomePage: mainMenuScreen_onHomePage
}));
```

The function receives the signal or event listener arguments.

``` code
protected function mainMenuScreen_onHomePage( sender:MainMenuScreen ):void
{
    navigateToURL( new URLRequest( "http://www.example.com/" ), "_blank" );
}
```

### Listen to signals instead of events

Alternatively, you may use the [as3-signals](https://github.com/robertpenner/as3-signals) library instead of events to trigger navigation. Feathers doesn't actually require as3-signals as a dependency, but at runtime, Feathers will check to see if as3-signals is compiled into the SWF. If it is, then the screen navigator will enable special behavior to check if the event map is referring to an event or a signal.

If as3-signals has been detected, the `ScreenNavigator` will first check a screen for a signal that's a public property before falling back to adding an event listener. For example, if the event map defines an `"complete"` key, the `ScreenNavigator` will check of the screen has a property named `complete`. If the property exists, in must implement the `ISignal` interface. If both of these conditions are true, a listener will be added to the signal. If either condition is false, then the `ScreenNavigator` will fall back to adding a listener for the "complete" event instead.

Let's rework the example above to use signals instead of events. Let's start with changing how `MainMenuScreen` is added to the `ScreenNavigator`:

``` code
var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( MainMenuScreen );
mainMenuItem.setScreenIDForEvent( "onOptions", OPTIONS );
this._navigator.addScreen( MAIN_MENU, mainMenuItem );
```

Inside `MainMenuScreen`, we add a signal called `onOptions` that will automatically be detected when the `ScreenNavigator` reads the event map:

``` code
protected var _onOptions:Signal = new Signal();
 
public function get onOptions():ISignal
{
    return this._onOptions;
}
```

The `MainMenuScreen` might dispatch `onOptions` when a button is triggered:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this._onOptions.dispatch();
}
```

Modifying `OptionsScreen` to use signals instead of events would be the same.

## Related Links

-   [ScreenNavigator API Documentation](../api-reference/feathers/controls/ScreenNavigator.html)

-   [ScreenNavigator Transitions](transitions.html)

-   [How to use the Feathers StackScreenNavigator component](stack-screen-navigator.html)

-   [How to use the Feathers Screen component](screen.html)

-   [How to use the Feathers ScrollScreen component](panel-screen.html)

-   [How to use the Feathers PanelScreen component](panel-screen.html)

For more tutorials, return to the [Feathers Documentation](index.html).


