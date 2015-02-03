---
title: How to use the Feathers StackScreenNavigator component  
author: Josh Tynjala

---
# How to use the Feathers `StackScreenNavigator` component

The [`StackScreenNavigator`](../api-reference/feathers/controls/StackScreenNavigator.html) class supports navigation between screens or menus, with a history stack that makes it simple to return to the previous screen. Events dispatched from the active screen can be used to push a new screen onto the stack, to pop the active screen, or even to call a function. When a new screen is pushed onto the stack, the previous screen may save its current state to be restored later.

Navigation can be enhanced with animation, called a [*transition*](transitions.html). Feathers provides a number of transitions out of the box, and a simple API allows anyone to create custom transitions. Separate transitions may be defined on a `StackScreenNavigator` for both push and pop actions, but an individual screen may also define its own unique transitions that are different from these defaults.

## The Basics

First, let's create a `StackScreenNavigator` component and add it to the display list:

``` code
this._navigator = new StackScreenNavigator();
this.addChild( this._navigator );
```

You may set its `width` and `height`, but that's optional because the `StackScreenNavigator` will automatically resize itself to fill the entire stage, if you don't provide explicit dimensions.

To add a new screen that the navigator can show, call [`addScreen()`](../api-reference/feathers/controls/StackScreenNavigator.html#addScreen()) and pass in an ID string to associate with the screen along with a [`StackScreenNavigatorItem`](../api-reference/feathers/controls/StackScreenNavigatorItem.html):

``` code
var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( MainMenuScreen );
this._navigator.addScreen( "mainMenu", mainMenuItem );
```

This screen's ID is `"mainMenu"`. We'll use this ID later when we ask the screen navigator to display this screen. There are a number of other APIs that require this ID too.

The first argument required by the `StackScreenNavigatorItem` constructor may be one of three types. We can pass in a `Class` to instantiate, a display object that has already been instantiated, or a `Function` that returns a display object. In most cases, a `Class` is recommended. For more details, see the [`screen`](../api-reference/feathers/controls/StackScreenNavigatorItem.html#screen) property.

<aside class="info">In the example above, `MainMenuScreen` is another class that we create in our project that extends the [`Screen`](screen.html) class. In general, it's best to extend a class that implements the `IScreen` interface, like [`Screen`](screen.html), [`PanelScreen`](panel-screen.html), or [`ScrollScreen`](scroll-screen.html). Each offers different features. For instance, `Screen` is the most basic with optional support for layouts, while `PanelScreen` offers layouts, scrolling, and a customizable header and footer.</aside>

To show the first screen, called the *root screen*, set the [`rootScreenID`](../api-reference/feathers/controls/StackScreenNavigator.html#rootScreenID) property. We'll set it to the `"mainMenu"` string that we registered with `addScreen()` earlier:

``` code
this._navigator.rootScreenID = "mainMenu";
```

To access the currently visible screen, use the [`activeScreen`](../api-reference/feathers/controls/supportClasses/BaseScreenNavigator.html#activeScreen) property.

``` code
var mainMenu:MainMenuScreen = MainMenuScreen( this._navigator.activeScreen );
```

We can also use [`activeScreenID`](../api-reference/feathers/controls/supportClasses/BaseScreenNavigator.html#activeScreenID) to get the ID of the active screen. In this case, again, it would be `"mainMenu"`.

## Navigation

If the active screen dispatches an event, the `StackScreenNavigator` can listen for it to automatically navigate to another screen.

Before we get to that, let's make a couple of changes to our existing code. First, let's move the main menu screen's ID into a constant. Then, let's add a second screen.

``` code
private static const MAIN_MENU:String = "mainMenu";
private static const OPTIONS:String = "options";
```

The constants will help us avoid typing mistakes that the compiler can easily catch. Let's use the `MAIN_MENU` constant in the call to `addScreen()`:

``` code
var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( MainMenuScreen );
this._navigator.addScreen( MAIN_MENU, mainMenuItem );
```

You probably noticed that we defined an `OPTIONS` constant too. Let's add the options screen that goes with it:

``` code
var optionsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( OptionsScreen );
this._navigator.addScreen( OPTIONS, optionsItem );
```

Now that we have a second screen, let's look at how we can navigate from the main menu to the options screen.

### Dispatch events from the screen

The best way to navigate from one screen to another is to dispatch an event from the currently active screen. Using the `StackScreenNavigatorItem`, we can associate an event with either a push or a pop action. The `StackScreenNavigator` will automatically navigate to a different screen when one of these events is dispatched.

#### Pushing a new screen onto the stack

Let's map an event from the main menu screen that will push the options screen onto the stack:

``` code
var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( MainMenuScreen );
mainMenuItem.setScreenIDForPushEvent( MainMenuScreen.SHOW_OPTIONS, OPTIONS );
this._navigator.addScreen( MAIN_MENU, mainMenuItem );
```

Using [`setScreenIDForPushEvent()`](../api-reference/feathers/controls/StackScreenNavigatorItem.html#setScreenIDForPushEvent()), we tell the `StackScreenNavigatorItem` that the screen navigator should push the screen with the `OPTIONS` ID onto the stack when `MainMenuScreen.SHOW_OPTIONS` is dispatched by the `MainMenuScreen`.

Inside the `MainMenuScreen` class, we can add the constant named `SHOW_OPTIONS` for the event:

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

Sometimes, when we push a new screen onto the stack, we want to save the state of the old screen so that we can restore it later when we pop the new screen and return to the old screen again. We can include some extra data with the event that we dispatch, and the `StackScreenNavigator` will automatically restore that data later.

As an example, let's say that we want to save the scroll position of a `List` so that the user doesn't lose their place when they return to this screen. Let's add a property to the screen for this saved scroll position:

``` code
public var savedVerticalScrollPosition:Number = 0;
```

When we initially create the `List`, we can set its `verticalScrollPosition` property.

``` code
this.list.verticalScrollPosition = this.savedVerticalScrollPosition;
```

We've set the default value to `0`, which is the same default that the `List` would start with normally. At this point, everything should behave the same as it did previously.

When we push a new screen, we can create a set of key-value pairs (an `Object`) to map a property names to values. We'll save the `verticalScrollPosition` property of the `List` as one of these values. When we dispatch the event to push a new screen, we'll pass the `Object` to the event's `data` property:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    var savedProperties:Object =
    {
        savedVerticalScrollPosition: this.list.verticalScrollPosition
    };
    this.dispatchEventWith( SHOW_OPTIONS, false, savedProperties );
}
```

Notice that we store the value using the name `savedVerticalScrollPosition` to match up with the `public` property that we defined a moment ago. The `StackScreenNavigator` will automatically use this property name to restore the value later when the new screen is popped and this screen is restored.

#### Popping the active screen from the stack

Next, let's add an event to pop the options screen from the top of the stack and return to the main menu screen:

``` code
var optionsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( OptionsScreen );
optionsItem.addPopEvent( Event.COMPLETE );
```

To register an event that should pop the active screen, we call [`addPopEvent()`](../api-reference/feathers/controls/StackScreenNavigatorItem.html#addPopEvent()) on the `StackScreenNavigatorItem`. In this case, we simply pass in the `Event.COMPLETE` constant. We don't need to pass in the ID for the main menu screen because `StackScreenNavigator` keeps track of its own history.

Inside `OptionsScreen`, we might dispatch an event when a button is triggered, similar to how we did it in `MainMenuScreen`:

``` code
protected function optionsButton_triggeredHandler( event:Event ):void
{
    this.dispatchEventWith( Event.COMPLETE );
}
```

Now, we can navigate back and forth between the two screens.

We can call `setScreenIDForPushEvent()` and `addPopEvent()` as many times as needed to listen for multiple events.

## Transitions

As we learned above, we can either push a new screen onto the top of the stack to show it, or we can pop a screen from the stack to hide it. Each of these actions can be animated, improving the user experience and adding a little bit of life to our games and apps. This animation during navigation is called a [*transition*](transitions.html), and we can specify transitions for both push and pop actions.

We can find a number of useful transition classes in the [`feathers.motion`](../api-reference/feathers/motion/package-detail.html) package. One example is the [`Slide`](../api-reference/feathers/motion/Slide.html) class, which slides the old screen out of view by animating its `x` or `y` property, while simultaneously animating the new screen into view.

`StackScreenNavigator` supports separate transitions for push and pop actions. This lets us clearly show, visually, that a screen is being added or removed from the stack. Using the `Slide` transition, we might want a new screen to slide to the left when it is pushed, and a screen being popped should slide in the opposite direction -- to the right.

Each of the built-in transition classes has one or more static methods that you can call to create the *transition function* that the screen navigator calls when pushing or poping a screen. In this case, let's call [`Slide.createSlideLeftTransition()`](../api-reference/feathers/motion/Slide.html#createSlideLeftTransition()) and [`Slide.createSlideRightTransition()`](../api-reference/feathers/motion/Slide.html#createSlideRightTransition()).

We can pass the results to the [`pushTransition`](../api-reference/feathers/controls/StackScreenNavigator.html#pushTransition) and [`popTransition`](../api-reference/feathers/controls/StackScreenNavigator.html#popTransition) properties on the screen navigator:

``` code
this._navigator.pushTransition = Slide.createSlideLeftTransition();
this._navigator.popTransition = Slide.createSlideRightTransition();
```

In the code above, we don't need to pass any arguments to `Slide.createSlideLeftTransition()` or `Slide.createSlideRightTransition()`. However, these functions expose some optional parameters that we can customize, if desired. For instance, we might want to customize the duration of the animation (in seconds) and the easing function:

``` code
this._navigator.pushTransition = Slide.createSlideLeftTransition( 0.75, Transitions.EASE_IN_OUT );
```

Now, the animation will last a little longer while easing in and out.

<aside class="info">See [Transitions for Feathers screen navigators](transitions.html) for a more detailed look at the available transitions, including instructions for creating custom transitions.</aside>

### Custom transitions for individual screens

Let's say that we want the push and pop transitions for most screens to be the same throughout our app. However, we have a screen for quick settings changes that we want to slide in from the bottom to cover up the existing screen. Then, when the quick settings panel is closed, it should slide down to reveal the previous screen below.

``` code
var quickSettingsItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( QuickSettingsScreen );
quickSettingsItem.addPopEvent( Event.COMPLETE );
quickSettingsItem.pushTransition = Cover.createCoverUpTransition();
quickSettingsItem.popTransition = Reveal.createRevealDownTransition();
```

It's as easy as setting the [`pushTransition`](../api-reference/feathers/controls/StackScreenNavigatorItem.html#pushTransition) and [`popTransition`](../api-reference/feathers/controls/StackScreenNavigatorItem.html#popTransition) properties on the `StackScreenNavigatorItem`.

### Events when transitions start and complete

A `StackScreenNavigator` dispatches [`FeathersEventType.TRANSITION_START`](../api-reference/feathers/controls/supportClasses/BaseScreenNavigator.html#event:transitionStart) when a new screen is being shown and the transition animation begins. Similarly, it dispatches [`FeathersEventType.TRANSITION_COMPLETE`](../api-reference/feathers/controls/supportClasses/BaseScreenNavigator.html#event:transitionComplete) when the transition animation has ended.

<aside class="info">If a specific screen needs to know when its transition in (or out) starts or completes, we can listen for different events that provide more control. See [How to use the Feathers `Screen` component](screen.html) (or [`ScrollScreen`](scroll-screen.html) or [`PanelScreen`](panel-screen.html)) for details.</aside>

Let's listen for `FeathersEventType.TRANSITION_COMPLETE`:

``` code
this._navigator.addEventListener( FeathersEventType.TRANSITION_COMPLETE, navigator_transitionCompleteHandler );
```

The event listener might look like this:

``` code
private function navigator_transitionCompleteHandler( event:Event ):void
{
    // do something after the transition animation
}
```

## Property Injection

Optionally, we can pass properties to the screen before it is shown. If we have multiple screens that need to share some data, this is a useful way to ensure that each screen has access to it. For instance, we might have an `OptionsData` class that stores things like audio volume and other common options. We'd want to pass that to the `OptionsScreen` to let the user change the volume, obviously. We'd also want to pass it to other screens that play audio so that it plays at the correct volume.

In the class where we create the `StackScreenNavigator`, let's create an `OptionsData` instance too. In a moment, we'll pass it to each screen that needs it.

``` code
this._optionsData = new OptionsData();
```

Now, when we add our `OptionsScreen` to the `StackScreenNavigator`, we pass it the `OptionsData` instance in using the [`properties`](../api-reference/feathers/controls/StackScreenNavigatorItem.html#properties) property on the `StackScreenNavigatorItem`:

``` code
var optionsItem:StackScreenNavivatorItem = new StackScreenNavigatorItem( OptionsScreen );
optionsItem.properties.options = this._optionsData;
```

In `OptionsScreen`, we need to add a variable or a getter and setter named `options` to match up with `optionsItem.properties.options`:

``` code
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

``` code
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

## Advanced Functionality

`StackScreenNavigator` offers a number of advanced features to customize navigation behavior.

### Call a function instead of navigating to a different screen

The `StackScreenNavigatorItem` event map can be used for more than simply navigating from one screen to another. You can also call a function when an event or signal is dispatched. Let's add a new event to the main menu that will be dispatched when an "About Our Product" button is clicked. We want it to open a website in the browser.

``` code
var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( MainMenuScreen );
mainMenuItem.setScreenIDForPushEvent( MainMenuScreen.SHOW_OPTIONS, OPTIONS );
mainMenuItem.setFunctionForPushEvent( MainMenuScreen.LINK_TO_HOME_PAGE, openHomePageLink );
```

The function may optionally receives the event listener arguments.

``` code
protected function openHomePageLink():void
{
    navigateToURL( new URLRequest( "http://www.example.com/" ), "_blank" );
}
```

Optionally, the function may receive the listener arguments for the event dispatched by the screen, if needed:

``` code
protected function openHomePageLink( event:Event ):void
```

### Listen to signals instead of events

Alternatively, you may use the [as3-signals](https://github.com/robertpenner/as3-signals) library instead of events to trigger navigation. Feathers doesn't actually require as3-signals as a dependency, but at runtime, Feathers will check to see if as3-signals is compiled into the SWF. If it is, then the screen navigator will enable special behavior to check if the event map is referring to an event or a signal.

If as3-signals has been detected, the `StackScreenNavigator` will first check a screen for a signal that's a public property before falling back to adding an event listener. For example, if the event map defines an `"complete"` key, the `StackScreenNavigator` will check of the screen has a property named `complete`. If the property exists, in must implement the `ISignal` interface. If both of these conditions are true, a listener will be added to the signal. If either condition is false, then the `StackScreenNavigator` will fall back to adding a listener for the `"complete"` event instead.

Let's rework the example above to use signals instead of events. Let's start with changing how `MainMenuScreen` is added to the `StackScreenNavigator`:

``` code
var mainMenuItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( MainMenuScreen );
mainMenuItem.setScreenIDForPushEvent( "onOptions", OPTIONS );
this._navigator.addScreen( MAIN_MENU, mainMenuItem );
```

Inside `MainMenuScreen`, we add a signal called `onOptions` that will automatically be detected when the `StackScreenNavigator` reads the event map:

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

-   [`feathers.controls.StackScreenNavigator` API Documentation](../api-reference/feathers/controls/StackScreenNavigator.html)

-   [Transitions for Feathers screen navigators](transitions.html)

-   [How to use the Feathers `Screen` component](screen.html)

-   [How to use the Feathers `ScrollScreen` component](panel-screen.html)

-   [How to use the Feathers `PanelScreen` component](panel-screen.html)

For more tutorials, return to the [Feathers Documentation](index.html).


