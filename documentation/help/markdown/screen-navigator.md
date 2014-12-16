---
title: How to use the Feathers ScreenNavigator component  
author: Josh Tynjala

---
# How to use the Feathers ScreenNavigator component

The [`ScreenNavigator`](../api-reference/feathers/controls/StackScreenNavigator.html) class offers a powerful system for displaying screens or menus in your application and navigating between them. It supports navigation based on events (or [as3-signals](https://github.com/robertpenner/as3-signals), if you prefer), and it can inject properties into screens as they are shown.

If you want a screen navigator that keeps a history that allows you to navigate backwards to previous screens, you should use [`StackScreenNavigator`](stack-screen-navigator.html) instead.

## The Basics

Create a `ScreenNavigator` like this:

``` code
this._navigator = new ScreenNavigator();
this.addChild( this._navigator );
```

You may also set its `width` and `height`, but that's optional because the `ScreenNavigator` will automatically resize itself to fill the entire stage, if you don't provide explicit dimensions.

To add a new screen to the navigator, call [`addScreen()`](../api-reference/feathers/controls/StackScreenNavigator.html#addScreen()) and pass in a `String` indentifier for the screen along with a [`ScreenNavigatorItem`](../api-reference/feathers/controls/ScreenNavigatorItem.html):

``` code
this._navigator.addScreen( "mainMenu", new ScreenNavigatorItem( MainMenuScreen ) );
```

This screen's identifier is `"mainMenu"`. We'll use this `String` later when we ask the screen navigator to display this screen. There are a number of other APIs that require this identifier too.

The first argument required by the `ScreenNavigatorItem` constructor is either a `Class` to instantiate, a display object that has already been instantiated, or a `Function` that returns a display object. In most cases, a `Class` is recommended.

In the example above, `MainMenuScreen` is another class in our project. In general, your screen class should extend a class that implements the `IScreen` interface, like [`Screen`](screen.html), [`PanelScreen`](panel-screen.html), or [`ScrollScreen`](scroll-screen.html). This is not required, though.

There are a couple of optional arguments that the `ScreenNavigator` constructor supports, and we'll look at them in more detail later.

To show a specific screen, call [`showScreen()`](../api-reference/feathers/controls/ScreenNavigator.html#showScreen()) and pass in the screen's identifier. We'll use the `"mainMenu"` string that we passed to `addScreen()` earlier:

``` code
this._navigator.showScreen( "mainMenu" );
```

To access the currently visible screen, use the `activeScreen` property.

``` code
var mainMenu:MainMenuScreen = MainMenuScreen( this._navigator.activeScreen );
```

You can also use `activeScreenID` to get the `String` identifier of the active screen. In this case, again, it would be `"mainMenu"`.

To make the `ScreenNavigator` remove the active screen, call `clearScreen()`.

``` code
this._navigator.clearScreen();
```

## Navigation

If a particular screen dispatches an event, the `ScreenNavigator` can listen for it to automatically navigate to another screen.

Before we get to that, let's make a couple of changes to our existing code. First, let's move the main menu screen's identifier into a constant. Then, let's add a second screen.

``` code
private static const MAIN_MENU:String = "mainMenu";
private static const OPTIONS:String = "options";
```

The constants will help us avoid typing mistakes that the compiler can easily catch. Let's use the `MAIN_MENU` constant in the call to `addScreen()`:

``` code
this._navigator.addScreen( MAIN_MENU, new StackScreenNavigatorItem( MainMenuScreen ) );
```

You probably noticed that we defined an `OPTIONS` constant too. Let's add the options screen that goes with it:

``` code
this._navigator.addScreen( OPTIONS, new ScreenNavigatorItem( OptionsScreen ) );
```

Now that we have a second screen, let's look at ways that the main menu can navigate to the options screen.

### Dispatch events from the screen

The second argument to the `ScreenNavigatorItem` constructor is an event map. We can map event types to screen identifiers so that the `ScreenNavigator` will navigate to a different screen when a specific event is dispatched by the current screen. Let's change the call where we added the main menu screen to the `ScreenNavigator`:

``` code
this._navigator.addScreen( MAIN_MENU, new ScreenNavigatorItem( MainMenuScreen,
{
    showOptions: OPTIONS
}));
```

Inside `MainMenuScreen`, we can add a constant named `SHOW_OPTIONS` that we'll use as an event type:

``` code
public static const SHOW_OPTIONS:String = "showOptions";
```

The `MainMenuScreen` might dispatch the event when a button is triggered:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this.dispatchEventWith( SHOW_OPTIONS );
}
```

Next, let's repeat the process to add a "complete" event to the event map for `OptionsScreen` so that we can navigate back to the `MainMenuScreen`:

``` code
this._navigator.addScreen( OPTIONS, new ScreenNavigatorItem( OptionsScreen,
{
    complete: MAIN_MENU
}));
```

Inside `OptionsScreen`, we'll dispatch an event when a button is triggered. This time, we'll just use the built in `Event.COMPLETE` constant instead of defining a new one:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this.dispatchEventWith( Event.COMPLETE );
}
```

Now we can navigate back and forth between the two screens.

### Call `pushScreen()` or `popScreen()` on the `owner` property

Classes like `Screen` and `PanelScreen` define an `owner` property that references the parent `ScreenNavigator`. You can use `owner` to call `showScreen()` directly, if you prefer not to use events.

For example, in `MainMenuScreen`, we might change the button's `Event.TRIGGERED` listener:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this.owner.showScreen( "options" );
}
```

However, this approach of using the `owner` property is not recommended. In general, dispatching events is a best practice that will keep your classes decoupled.

## Transitions

As we learned above, we can either show a screen or we can clear the currently active screen. Each of these actions can be animated, improving the user experience and adding a little bit of life to our games and apps. This animation during navigation is called a *transition*.

We can find a number of useful transition classes in the `feathers.motion.transitions` package. One example is the [`Fade`](../api-reference/feathers/motion/transitions/Slide.Fade) class, which fades a screen by animating its `alpha` property.

Each of the built-in transition classes has one or more static methods that you can call to create a *transition function* that screen navigator calls when navigating to a different screen. In this case, we want to call [`Fade.createFadeInTransition()`](../api-reference/feathers/motion/transitions/Fade.html#createFadeInTransition()).

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

`StackScreenNavigator` offers a number of advanced features to customize navigation behavior.

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

Alternatively, you may use the [as3-signals](https://github.com/robertpenner/as3-signals) library instead of events to trigger navigation. Feathers doesn't actually require as3-signals as a dependency, but at runtime, Feathers will check to see if as3-signals is compiled into the SWF. If it is, then the screen navigator will enable special behavior to listen for signals. Signals are always optional.

If as3-signals has been detected, the `ScreenNavigator` will first check a screen for a signal that's a public property before falling back to adding an event listener. For example, if the event map defines an `"complete"` key, the `ScreenNavigator` will check of the screen has a property named `complete`. If the property exists, in must implement the `ISignal` interface. If both of these conditions are true, a listener will be added to the signal. If either condition is false, then the `ScreenNavigator` will fall back to adding a listener for the "complete" event instead.

Let's rework the example above to use signals instead of events. Let's start with changing how `MainMenuScreen` is added to the `ScreenNavigator`:

``` code
this._navigator.addScreen( MAIN_MENU, new ScreenNavigatorItem( MainMenuScreen,
{
    onOptions: OPTIONS
}));
```

Inside `MainMenuScreen`, we add a signal called `onOptions` that will automatically be detected when the `ScreenNavigator` reads the event map:

``` code
protected var _onOptions:Signal = new Signal( MainMenuScreen );
 
public function get onOptions():ISignal
{
    return this._onOptions;
}
```

The `MainMenuScreen` might dispatch `onOptions` when a button is triggered:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this._onOptions.dispatch( this );
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


