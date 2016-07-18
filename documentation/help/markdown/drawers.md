---
title: How to use the Feathers Drawers component  
author: Josh Tynjala

---
# How to use the Feathers `Drawers` component

The [`Drawers`](../api-reference/feathers/controls/Drawers.html) class provides a container that supports main content in the center with "drawers", or slide-out menus, that may be opened and closed with a gesture around all four edges. Drawers may also be docked to remain open at all times, or based on the stage orientation. Drawers may be opened by listening to an event from the main content, such as one triggered by a button press.

-   [The Basics](#the-basics)

-   [Open drawers with events](#open-drawers-with-events)

-   [Open or close drawers programatically](#open-or-close-drawers-programatically)

-   [Docked drawers](#docked-drawers)

## The Basics

First, let's create a `Drawers` component and add it to the display list:

``` code
var drawers:Drawers = new Drawers();
this.addChild( drawers );
```

You may also set its width and height, but that's optional because the `Drawers` will automatically resize itself to fill the entire stage if you don't provide explicit dimensions.

First, we'll want to set its main content:

``` code
var navigator:ScreenNavigator = new ScreenNavigator();
drawers.content = navigator;
```

The main content will always fill the entire width and height of the `Drawers` container. In this case, we've created a [`ScreenNavigator`](screen-navigator.html) component. To properly demonstrate the capabilities of the `Drawers` component, we need a bit of boilerplate code. Let's quickly add some screens to the `ScreenNavigator`:

``` code
navigator.addScreen( "start", new ScreenNavigatorItem( StartScreen ) );
navigator.addScreen( "options", new ScreenNavigatorItem( OptionsScreen ) );
navigator.showScreen( "start" );
```

The `StartScreen` and `OptionsScreen` classes extend [`PanelScreen`](panel-screen.html). We'll simply start out by displaying a title, and we'll add a bit more later:

``` code
package
{
    import feathers.controls.PanelScreen;
 
    public class StartScreen extends PanelScreen
    {
        public function StartScreen()
        {
        }
 
        override protected function initialize():void
        {
            super.initialize();
            this.title = "Start";
        }
    }
}
```

The initial code for these two classes is almost identical, so the `OptionScreen` class is not shown. To create the `OptionsScreen`, copy the code from the `StartScreen` and change the class and constructor names to `OptionsScreen` and change the title to `"Options"`. That's it!

Next, we'll want to add some content to a drawer. Let's add a [`List`](list.html) component to act as a menu.

``` code
var list:List = new List();
list.dataProvider = new ListCollection(
[
    { screen: "start", label: "Start" },
    { screen: "options", label: "Options" },
]);
list.selectedIndex = 0;
list.addEventListener( Event.CHANGE, list_changeHandler );
```

The list's [`Event.CHANGE`](../api-reference/feathers/controls/List.html#event:change) listener looks like this:

``` code
function list_changeHandler( event:Event ):void
{
     var screen:String = list.selectedItem.screen;
     navigator.showScreen( screen );
}
```

To use the list as a drawer, simply set the [`leftDrawer`](../api-reference/feathers/controls/Drawers.html#leftDrawer) property:

``` code
drawers.leftDrawer = list;
```

For simplicity, we'll only focus on the left drawer in these code examples. However, drawers may be placed on all four sides of the main content, so every property or method with the word `left` in the name will have a cousin with `top`, `right`, or `bottom` in the name.

If you run the code right now, you will see the `StartScreen` displayed and nothing else. If you touch near the left edge of the `StartScreen`, you can drag to the right to reveal the list with the two screens. Select the Options item in the list, and the options screen will be displayed. Tap the main content to close the drawer.

## Open Drawers with Events

It's often common to open a drawer with a [button](button.html). Let's add a button to header in our `StartScreen` and dispatch an event when it is triggered:

``` code
this.headerFactory = function():Header
{
    var header:Header = new Header();

    var menuButton:Button = new Button();
    menuButton.label = "Menu";
    menuButton.addEventListener( Event.TRIGGERED, menuButton_triggeredHandler );
    header.leftItems = new <DisplayObject>
    [
        menuButton
    ];

    return header;
};
```

The button's [`Event.TRIGGERED`](../api-reference/feathers/controls/Button.html#event:triggered) listener looks like this:

``` code
private function menuButton_triggeredHandler(event:Event):void
{
    this.dispatchEventWith( "showMenu" );
}
```

Now, the `Drawers` container can listen for that event to open a drawer:

``` code
drawers.leftDrawerToggleEventType = "showMenu";
```

In production code, you probably want to make the `"showMenu"` event type into a constant somewhere that various classes can access it.

Now, when you press the new menu button in the `StartScreen` header, the left drawer will open.

## Open or close drawers programatically

If you want to programmatically open or close a drawer, you can simply call a function:

``` code
drawers.toggleLeftDrawer();
```

[`toggleLeftDrawer()`](../api-reference/feathers/controls/Drawers.html#toggleLeftDrawer()) takes one argument, to specify a duration in seconds of the open or close animation. You can omit this argument, like the code above, and it will use the value of the [`openOrCloseDuration`](../api-reference/feathers/controls/Drawers.html#openOrCloseDuration) property instead.

In our example above, we might want to modify the listener for the list's `Event.CHANGE` to close the drawer after telling the [`ScreenNavigator`](screen-navigator.html) to show a different screen:

``` code
function list_changeHandler( event:Event ):void
{
     var screen:String = list.selectedItem.screen;
     navigator.showScreen( screen );
     drawers.toggleLeftDrawer();
}
```

You may easily check the [`isLeftDrawerOpen`](../api-reference/feathers/controls/Drawers.html#isLeftDrawerOpen) property to see if a drawer is open:

``` code
if( drawers.isLeftDrawerOpen )
{
    // do something
}
```

## Docked Drawers

If you would prefer that a drawer is open all of the time, you can "dock" it. When a drawer is docked, it cannot be closed. Think of it like a permanent side bar, rather than a menu that you can show and hide. Let's dock the drawer:

``` code
drawers.leftDrawerDockMode = Drawers.DOCK_MODE_BOTH;
```

When using [`Drawers.DOCK_MODE_BOTH`](../api-reference/feathers/controls/Drawers.html#DOCK_MODE_BOTH), you will not need a gesture or an event to open a drawer. It will remain open in all orientations.

There are three other options. [`Drawers.DOCK_MODE_PORTRAIT`](../api-reference/feathers/controls/Drawers.html#DOCK_MODE_PORTRAIT) and [`Drawers.DOCK_MODE_LANDSCAPE`](../api-reference/feathers/controls/Drawers.html#DOCK_MODE_LANDSCAPE) allow you to dock a drawer, depending on the stage orientation. In one orientation, the drawer will be docked. In the other, it can be opened with a gesture or an event. The default docking value is [`Drawers.DOCK_MODE_NONE`](../api-reference/feathers/controls/Drawers.html#DOCK_MODE_NONE) where a drawer is not docked at all and must be opened with a gesture or an event.

If needed, you may check the [`isLeftDrawerDocked`](../api-reference/feathers/controls/Drawers.html#isLeftDrawerDocked) property to see if a drawer is docked:

``` code
if( drawers.isLeftDrawerDocked )
{
    // do something
}
```

## Related Links

-   [`feathers.controls.Drawers` API Documentation](../api-reference/feathers/controls/Drawers.html)