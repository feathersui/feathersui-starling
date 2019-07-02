---
title: Keyboard focus management in Feathers  
author: Josh Tynjala

---
# Keyboard focus management in Feathers

In desktop apps, users expect to be able to use the Tab key to navigate between focusable UI components, and they expect to be able to use the keyboard to do things like press buttons or adjust sliders. On smart TVs, the remote typically provides a d-pad or another input method for passing focus up, down, to the left, or to the right.

Feathers provides optional focus management support with the [`FocusManager`](../api-reference/feathers/core/FocusManager.html) class. Typically, you can enable the `FocusManager` when your app starts up, and it will "just work". However, there are ways to customize the focus behavior if your app has special requirements.

<aside class="info">The example themes enable focus management automatically on both desktop and mobile.</aside>

## Enabling the Focus Manager

To enable focus management, only one line is required when your app first starts up:

``` actionscript
FocusManager.setEnabledForStage( this.stage, true );
```

That's it! You will be able to use Tab and Shift+Tab to navigate between focusable components in your app when using a keyboard, or you can use the d-pad on a smart TV remote. Some platforms will also dispatch appropriate d-pad events when using a game controller.

If you are building an AIR desktop app with multiple Starling instances in multiple windows, you will need to enable focus management for each stage with separate calls to [`setEnabledForStage()`](../api-reference/feathers/core/FocusManager.html#setEnabledForStage()).

## Changing Focus Programmatically

You can manually tell the <code>FocusManager</code> to change which component is current focused:

``` actionscript
var focusManager:IFocusManager = FocusManager.getFocusManagerForStage( this.stage );
focusManager.focus = button;
```

It's as simple as setting the [`focus`](../api-reference/feathers/core/IFocusManager.html#focus) property on the [`IFocusManager`](../api-reference/feathers/core/IFocusManager.html).

To clear focus so that no component is focused, set this property to `null`:

``` actionscript
var focusManager:IFocusManager = FocusManager.getFocusManagerForStage( this.stage );
focusManager.focus = null;
```

## Customizing focus order

By default, when the user changes focus with Tab or Shift+Tab on the keyboard, Feathers will pass focus using display list ordering. With [`getChildIndex()`](http://doc.starling-framework.org/core/starling/display/DisplayObjectContainer.html#getChildIndex()) and other standard display list APIs, the focus manager will search the display list in a generally intuitive order to find the next (or previous) child that can receive focus.

If things end up a bit out of the ordering that you expected, you can customize the focus order using the [`nextTabFocus`](../api-reference/feathers/core/IFocusDisplayObject.html#nextTabFocus) and [`previousTabFocus`](../api-reference/feathers/core/IFocusDisplayObject.html#previousTabFocus) properties:

``` actionscript
var button1:Button = new Button();
this.addChild( button1 );
 
var button2:Button = new Button();
this.addChild( button2 );
 
button1.nextTabFocus = button2;
button2.previousTabFocus = button1;
```

When using a d-pad to change focus, the focus manager uses special heuristics to determine which component should be given focus next, based on which direction is chosen (up, down, left, or right).

If needed, you may customize the focus order for d-pad using the [`nextUpFocus`](../api-reference/feathers/core/IFocusDisplayObject.html#nextUpFocus), [`nextDowbFocus`](../api-reference/feathers/core/IFocusDisplayObject.html#nextDownFocus), [`nextLeftFocus`](../api-reference/feathers/core/IFocusDisplayObject.html#nextLeftFocus), and [`nextRightFocus`](../api-reference/feathers/core/IFocusDisplayObject.html#nextRightFocus) properties.

## Focus and pop-Ups

The focus manager and the [pop-up manager](pop-ups.html) know how to communicate. If a pop-up is modal, a new focus manager will be created and it will gain exclusive control over keyboard focus. Until the modal pop-up is closed, nothing below the modal overlay will be able to receive focus. Multiple modal pop-ups will add additional focus managers to the stack that will ensure that each modal layer blocks keyboard focus to anything below.

If a pop-up is not modal, then the same focus manager will remain active and everything will be able to receive focus, including the pop-up and everything below the pop-up.

## Related Links

-   [`feathers.core.FocusManager` API Documentation](../api-reference/feathers/core/FocusManager.html)