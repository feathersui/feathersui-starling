---
title: How to use the Feathers StackScreenNavigator component  
author: Josh Tynjala

---
# How to use the Feathers StackScreenNavigator component

The [`StackScreenNavigator`](../api-reference/feathers/controls/StackScreenNavigator.html) class supports navigation between screens or menus, with a history stack that makes it simple to display a new screen or to return to a previous screen. Navigation can be enhanced with animations (called [transitions](transitions.html)) for pushing a new screen or popping the active screen from the top of the stack. Feathers provides a number of transitions out of the box, and a simple API lets you create custom transitions.

Navigation may be triggered by events dispatched from the active screen. If you prefer, you can call the `pushScreen()` or `popScreen()` methods directly.

## The Basics

Create a `StackScreenNavigator` like this:

``` code
this._navigator = new StackScreenNavigator();
this.addChild( this._navigator );
```

You may set its `width` and `height`, but that's optional because the `StackScreenNavigator` will automatically resize itself to fill the entire stage, if you don't provide explicit dimensions.

To add a new screen to the navigator, call [`addScreen()`](../api-reference/feathers/controls/StackScreenNavigator.html#addScreen()) and pass in a `String` indentifier for the screen along with a [`StackScreenNavigatorItem`](../api-reference/feathers/controls/StackScreenNavigatorItem.html):

``` code
this._navigator.addScreen( "mainMenu", new StackScreenNavigatorItem( MainMenuScreen ) );
```

This screen's identifier is `"mainMenu"`. We'll use this `String` later when we ask the screen navigator to display this screen. There are a number of other APIs that require this identifier too.

The first argument required by the `StackScreenNavigatorItem` constructor is either a `Class` to instantiate, a display object that has already been instantiated, or a `Function` that returns a display object. In most cases, a `Class` is recommended.

In the example above, `MainMenuScreen` is another class in our project. In general, your screen class should extend a class that implements the `IScreen` interface, like [`Screen`](screen.html), [`PanelScreen`](panel-screen.html), or [`ScrollScreen`](scroll-screen.html). This is not required, though.

There are a couple of optional arguments that the `StackScreenNavigatorItem` constructor supports, and we'll look at them later.

To show the first screen, called the *root screen*, set the [`rootScreenID`](../api-reference/feathers/controls/StackScreenNavigator.html#rootScreenID) property. We'll set it to the `"mainMenu"` string that we passed to `addScreen()` earlier:

``` code
this._navigator.rootScreenID = "mainMenu";
```

To access the currently visible screen, use the `activeScreen` property.

``` code
var mainMenu:MainMenuScreen = MainMenuScreen( this._navigator.activeScreen );
```

You can also use `activeScreenID` to get the `String` identifier of the active screen. In this case, again, it would be `"mainMenu"`.

## Navigation

If a particular screen dispatches an event, the `StackScreenNavigator` can listen for it to automatically navigate to another screen.

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
this._navigator.addScreen( OPTIONS, new StackScreenNavigatorItem( OptionsScreen ) );
```

Now that we have a second screen, let's look at ways that the main menu can navigate to the options screen.

### Dispatch events from the screen

The second argument to the `StackScreenNavigatorItem` constructor is an event map. We can map event types to screen identifiers so that the `StackScreenNavigator` will navigate to a different screen when a specific event is dispatched by the current screen. Let's change the call where we added the main menu screen to the `StackScreenNavigator`:

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

Classes like `Screen` and `PanelScreen` define an `owner` property that references the parent `StackScreenNavigator`. You can use `owner` to call `pushScreen()` or `popScreen()` directly, if you prefer not to use events or if you want to use a custom transition.

For example, in `MainMenuScreen`, we might change the button's `Event.TRIGGERED` listener:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this.owner.pushScreen( "options" );
}
```

However, this approach of using the `owner` property is not usually recommended. In general, dispatching events is a best practice that will keep your classes decoupled.

## Transitions

As we learned above, we can either push a new screen onto the top of the stack to show it, or we can pop a screen from the stack to hide it. Each of these actions can be animated, improving the user experience and adding a little bit of life to our games and apps. This animation during navigation is called a *transition*, and we can specify transitions for both push and pop actions.

We can find a number of useful transition classes in the `feathers.motion.transitions` package. One example is the [`Slide`](../api-reference/feathers/motion/transitions/Slide.html) class, which slides the old screen out of view by animating its `x` or `y` property, while simultaneously animating the new screen into view.

`StackScreenNavigator` supports separate transitions for push and pop actions. This lets us clearly show, visually, that a screen is being added or removed from the stack. Using the `Slide` transition, we might want a new screen to slide to the left when it is pushed, and a screen being popped should slide in the opposite direction -- to the right.

Each of the built-in transition classes has one or more static methods that you can call to create the *transition function* that the screen navigator calls when pushing or poping a screen. In this case, we want to call [`Slide.createSlideLeftTransition()`](../api-reference/feathers/motion/transitions/Slide.html#createSlideLeftTransition()) and [`Slide.createSlideRightTransition()`](../api-reference/feathers/motion/transitions/Slide.html#createSlideRightTransition()).

We can pass the results to the [`pushTransition`](../api-reference/feathers/controls/StackScreenNavigator#pushTransition) and [`popTransition`](../api-reference/feathers/controls/StackScreenNavigator#popTransition) properties on the screen navigator:

``` code
this._navigator.pushTransition = Slide.createSlideLeftTransition();
this._navigator.popTransition = Slide.createSlideRightTransition();
```

In the code above, we don't need to pass any arguments to `Slide.createSlideLeftTransition()` or `Slide.createSlideRightTransition()`. However, these functions expose some optional parameters that we can customize, if desired. For instance, we might want to customize the duration of the animation (in seconds) and the easing function:

``` code
this._navigator.pushTransition = Slide.createSlideLeftTransition( 0.75, Transitions.EASE_IN_OUT );
```
Now, the animation will last a little longer while easing in and out.

See [Transitions for Feathers screen navigators](transitions.html) for a more detailed look at the available transitions, including instructions for creating custom transitions.

### Events when transitions start and complete

The `StackScreenNavigator` dispatches `FeathersEventType.TRANSITION_START` and `FeathersEventType.TRANSITION_COMPLETE` events when the transition starts and ends. You might listen to `FeathersEventType.TRANSITION_COMPLETE` to delay the initialization of your screen until the transition has completed. For instance, you might have other animations that need to play, but once the screen is fully visible.

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

Note that the `StackScreenNavigator` will dispatch the `FeathersEventType.TRANSITION_START` and `FeathersEventType.TRANSITION_COMPLETE` events when a screen is being removed too. You will need to remove event listeners meant to be called only when the screen is added if you don't want them to run again when the screen is removed.

## Property Injection

The third argument you can pass to the `StackScreenNavigatorItem` constructor is an initializer object. This is a set of key-value pairs that map to properties on the screen being defined. When the screen is shown, each of these properties will be passed to the screen. If you have multiple screens that need to share some data, this is a useful way to ensure that they each have access to it. For instance, you might have an `OptionsData` class that stores things like audio volume and other common options.

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

The `StackScreenNavigatorItem` event map can be used for more than just navigation. You can also call a function when an event or signal is dispatched. Let's add a new signal to the main menu that will be dispatched when a "About Our Product" button is clicked. We want it to open a website in the browser.

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

If as3-signals has been detected, the `StackScreenNavigator` will first check a screen for a signal that's a public property before falling back to adding an event listener. For example, if the event map defines an `"complete"` key, the `StackScreenNavigator` will check of the screen has a property named `complete`. If the property exists, in must implement the `ISignal` interface. If both of these conditions are true, a listener will be added to the signal. If either condition is false, then the `StackScreenNavigator` will fall back to adding a listener for the `"complete"` event instead.

Let's rework the example above to use signals instead of events. Let's start with changing how `MainMenuScreen` is added to the `StackScreenNavigator`:

``` code
this._navigator.addScreen( MAIN_MENU, new ScreenNavigatorItem( MainMenuScreen,
{
    onOptions: OPTIONS
}));
```

Inside `MainMenuScreen`, we add a signal called `onOptions` that will automatically be detected when the `StackScreenNavigator` reads the event map:

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

-   [StackScreenNavigator API Documentation](../api-reference/feathers/controls/StackScreenNavigator.html)

-   [Transitions for Feathers screen navigators](transitions.html)

-   [How to use the Feathers Screen component](screen.html)

-   [How to use the Feathers ScrollScreen component](panel-screen.html)

-   [How to use the Feathers PanelScreen component](panel-screen.html)

For more tutorials, return to the [Feathers Documentation](index.html).


