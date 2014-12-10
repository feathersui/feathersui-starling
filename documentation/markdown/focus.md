# Focus Management in Feathers

In desktop apps, users expect to be able to use the Tab key to navigate between UI controls, and they expect to be able to use the keyboard to do things like press buttons or adjust sliders. Feathers provides completely optional focus management support when your app needs these capabilities.

In general, you should only enable focus management in desktop apps. Some mobile components are not optimized for focus management.

## Enabling the Focus Manager

To enable focus management, only one line is required when your app first starts up:

``` code
FocusManager.setEnabledForStage( this.stage, true );
```

That's it! You will be able to use Tab and Shift+Tab to navigate between controls in your app.

If you are building an AIR desktop app with multiple Starling instances in multiple windows, you will need to enable focus management for each stage separately.

## Changing Focus Programmatically

You can manually change focus, if you desire:

``` code
button.focusManager.focus = button;
```

To clear focus, set it to `null`:

``` code
button.focusManager.focus = null;
```

## Customizing Focus Behavior

By default, when the user changes focus with the keyboard, Feathers will pass focus using display list ordering. Using `getChildIndex()` and other standard display list APIs, the focus manager will search the display list in a relatively intuitive order to find the next (or previous) child that can receive focus.

If things end up a bit out of the ordering that you expected, you can customize the focus order using the `nextTabFocus` and `previousTabFocus` properties:

``` code
var button1:Button = new Button();
this.addChild( button1 );
 
var button2:Button = new Button();
this.addChild( button2 );
 
button1.nextTabFocus = button2;
button2.previousTabFocus = button1;
```

## Focus and Pop-Ups

The focus manager and the [pop-up manager](pop-ups.html) know how to communicate. If a pop-up is modal, a new focus manager will be created and it will gain exclusive control over keyboard focus. Until the modal pop-up is closed, nothing below the modal overlay will be able to receive focus. Multiple modal pop-ups will add additional focus managers to the stack that will ensure that each modal layer blocks keyboard focus to anything below.

If a pop-up is not modal, then the same focus manager will remain active and everything will be able to receive focus, including the pop-up and everything below the pop-up.

## Related Links

-   [FocusManager API Documentation](http://feathersui.com/documentation/feathers/core/FocusManager.html)

For more tutorials, return to the [Feathers Documentation](start.html).


