---
title: How to use the Feathers ScreenNavigator component  
author: Josh Tynjala

---
# How to use the Feathers ScreenNavigator component

The `ScreenNavigator` class offers a powerful system for displaying screens or menus in your application and navigating between them. It supports navigation based on events (or [as3-signals](https://github.com/robertpenner/as3-signals), if you prefer), and it can inject properties into screens as they are shown.

## The Basics

Create a `ScreenNavigator` like this:

``` code
this._navigator = new ScreenNavigator();
this.addChild( this._navigator );
```

You may also set its `width` and `height`, but that's optional because the `ScreenNavigator` will automatically resize itself to fill the entire stage if you don't provide explicit dimensions.

To add a new screen to the navigator, call `addScreen()` and pass in a `String` indentifier for the screen along with a `ScreenNavigatorItem`:

``` code
this._navigator.addScreen( "mainMenu", new ScreenNavigatorItem( MainMenuScreen ) );
```

The first argument required by the `ScreenNavigatorItem` constructor is either a `Class` to instantiate or a `DisplayObject` that has already been instantiated. In general, your screen class, whether you instantiate it directly or allow the `ScreenNavigatorItem` to instantiate it, should extend `Screen`. This is not required, though.

In this case, `MainMenuScreen` is another class in our project. There are a couple more arguments that the constructor supports, and we'll look at them later.

To show a specific screen, call `showScreen()` and pass in the screen's identifier:

``` code
this._navigator.showScreen( "mainMenu" );
```

To access the currently visible screen, use the `activeScreen` property.

``` code
var mainMenu:MainMenuScreen = MainMenuScreen( _navigator.activeScreen );
```

You can also use `activeScreenID` to get the `String` identifier for the active screen.

To make the `ScreenNavigator` show nothing, call `clearScreen()`.

``` code
this._navigator.clearScreen();
```

## Navigation

If a particular screen dispatches an event or a signal, the `ScreenNavigator` can use it to automatically navigate to another screen.

Before we get to that, let's make a couple of changes. First, let's move the main menu screen's identifier to a constant. Then, let's add a second screen.

``` code
private static const MAIN_MENU:String = "mainMenu";
private static const OPTIONS:String = "options";
```

The constants will help us avoid typing mistakes. Now, let's add the options screen.

``` code
this._navigator.addScreen( OPTIONS, new ScreenNavigatorItem( OptionsScreen ) );
```

Now that we have a second screen, let's allow the main menu to navigate to it.

### With Events

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

### With the owner property

Classes like `Screen` and `PanelScreen` define an `owner` property that references the parent `ScreenNavigator`. You can use `owner` to call `showScreen()` directly, if you prefer not to use events.

For example, in `MainMenuScreen`, we might change the button's `Event.TRIGGERED` listener:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this.owner.showScreen( "options" );
}
```

However, this approach of using the `owner` property is not recommended. In general, dispatching events is a best practice that will keep your classes decoupled.

### Optional: With Signals

Alternatively, you may use the [as3-signals](https://github.com/robertpenner/as3-signals) library to trigger navigation. Feathers doesn't actually require as3-signals as a dependency. At runtime, Feathers will check to see if as3-signals is compiled into the SWF. If it is, then it will enable special behavior to listen for signals, if they're defined.

If as3-signals has been detected, the `ScreenNavigator` will first check a screen for a signal that's a public property before falling back to adding an event listener. For example, if the event map defines a "complete" key, the `ScreenNavigator` will check of the screen has a property named `complete`. If it does, then it will check if that value of that property implements the `ISignal` interface. If both of these conditions are true, a listener will be added to the signal. If either condition is false, then the `ScreenNavigator` will fall back to adding a listener for the "complete" event instead.

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

## Transitions

See [ScreenNavigator Transitions](transitions.html) for a more detailed look at transitions.

The `ScreenNavigator` class supports transition animations when changing screens. A number of useful transition "manager" classes are pre-defined in the `feathers.motion.transitions` package. Some of these track the history of screens to add a little extra context to their animations. For instance, the `ScreenSlidingStackTransitionManager` stores a stack of recent screens to intelligently choose the direction a screen slides in from when it is shown (either the left side or the right side).

To use the `ScreenSlidingStackTransitionManager`, we simply need to pass a `ScreenNavigator` instance to the constructor.

``` code
this._transitionManager = new ScreenSlidingStackTransitionManager( _navigator );
```

Many of the transition managers expose some properties that can be used to adjust the animation. For instance, the `ScreenSlidingStackTransitionManager` exposes the duration of the animation and the easing function.

``` code
this._transitionManager.duration = 0.4;
this._transitionManager.ease = Transitions.EASE_OUT_BACK;
```

### Transition Events

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

## Advanced Functionality

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

## Related Links

-   [ScreenNavigator API Documentation](http://feathersui.com/documentation/feathers/controls/ScreenNavigator.html)

-   [ScreenNavigator Transitions](transitions.html)

-   [How to use the Feathers Screen component](screen.html)

-   [How to use the Feathers PanelScreen component](panel-screen.html)

For more tutorials, return to the [Feathers Documentation](index.html).


