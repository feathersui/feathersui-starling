---
title: Keyboard focus management in Feathers  
author: Josh Tynjala

---
# Keyboard focus management in Feathers

In desktop apps, users expect to be able to use the Tab key to navigate between UI controls, and they expect to be able to use the keyboard to do things like press buttons or adjust sliders. Feathers provides completely optional focus management support with the [`FocusManager`](../api-reference/feathers/core/FocusManager.html) class, if your app needs these capabilities.

<aside class="info">In general, you should only enable focus management in desktop apps. Some mobile components are not optimized for focus management.</aside>

## Enabling the Focus Manager

To enable focus management, only one line is required when your app first starts up:

``` code
FocusManager.setEnabledForStage( this.stage, true );
```

That's it! You will be able to use Tab and Shift+Tab to navigate between controls in your app.

If you are building an AIR desktop app with multiple Starling instances in multiple windows, you will need to enable focus management for each stage with separate calls to [`setEnabledForStage()`](../api-reference/feathers/core/FocusManager.html#setEnabledForStage()).

## Changing Focus Programmatically

You can manually updated the focused component, if you desire:

``` code
var focusManager:IFocusManager = FocusManager.getFocusManagerForStage( this.stage );
focusManager.focus = button;
```

It's as simple as setting the [`focus`](../api-reference/feathers/core/IFocusManager.html#focus) property on the [`IFocusManager`](../api-reference/feathers/core/IFocusManager.html).

To clear focus, set this property to `null`:

``` code
var focusManager:IFocusManager = FocusManager.getFocusManagerForStage( this.stage );
focusManager.focus = null;
```

## Customizing focus order

By default, when the user changes focus with the keyboard, Feathers will pass focus using display list ordering. Using [`getChildIndex()`](http://doc.starling-framework.org/core/starling/display/DisplayObjectContainer.html#getChildIndex()) and other standard display list APIs, the focus manager will search the display list in a relatively intuitive order to find the next (or previous) child that can receive focus.

If things end up a bit out of the ordering that you expected, you can customize the focus order using the [`nextTabFocus`](../api-reference/feathers/core/IFocusDisplayObject.html#nextTabFocus) and [`previousTabFocus`](../api-reference/feathers/core/IFocusDisplayObject.html#previousTabFocus) properties:

``` code
var button1:Button = new Button();
this.addChild( button1 );
 
var button2:Button = new Button();
this.addChild( button2 );
 
button1.nextTabFocus = button2;
button2.previousTabFocus = button1;
```

## Focus and pop-Ups

The focus manager and the [pop-up manager](pop-ups.html) know how to communicate. If a pop-up is modal, a new focus manager will be created and it will gain exclusive control over keyboard focus. Until the modal pop-up is closed, nothing below the modal overlay will be able to receive focus. Multiple modal pop-ups will add additional focus managers to the stack that will ensure that each modal layer blocks keyboard focus to anything below.

If a pop-up is not modal, then the same focus manager will remain active and everything will be able to receive focus, including the pop-up and everything below the pop-up.

## Related Links

-   [`feathers.core.FocusManager` API Documentation](../api-reference/feathers/core/FocusManager.html)