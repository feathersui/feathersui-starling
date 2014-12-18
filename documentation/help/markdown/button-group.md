---
title: How to use the Feathers ButtonGroup component  
author: Josh Tynjala

---
# How to use the Feathers `ButtonGroup` component

The [`ButtonGroup`](../api-reference/feathers/controls/ButtonGroup.html) class displays a set of [buttons](button.html) displayed one after the other in a simple horizontal or vertical layout. It is best used for a set of related buttons that generally look the same and are meant to be displayed together meaningfully. For instance, an alert dialog might populate its OK/Cancel/Yes/No/etc. buttons using a `ButtonGroup`.

## The Basics

First, let's create a `ButtonGroup` control and add it to the display list:

``` code
var group:ButtonGroup = new ButtonGroup();
this.addChild(group);
```

This won't display anything because we haven't populated the data provider with information about the buttons we want. Let's do that next:

``` code
group.dataProvider = new ListCollection(
[
    { label: "One", triggered: oneButton_triggeredHandler },
    { label: "Two", triggered: twoButton_triggeredHandler },
    { label: "Three", triggered: threeButton_triggeredHandler },
]);
```

Like the [`List`](list.html) or [`TabBar`](tab-bar.html) components, the `ButtonGroup` uses a [`ListCollection`](../api-reference/feathers/data/ListCollection.html) as its data provider.

A number of fields in each item from the collection are automatically detected by the button group. For instance, we set the `label` on each button above. Each of a button's icon states may also be used here, along with `isToggle` and `isSelected` to make them into toggling buttons.

Additionally, we can add a few event listeners to each button, including `Event.TRIGGERED` and `Event.CHANGE` (using the `String` values, `triggered` and `change`). In the example above, we add a listener to `triggered`. The listener on the first item might look something like this:

``` code
function oneButton_triggeredHandler( event:Event ):void
{
    var button:Button = Button( event.currentTarget );
    trace( "button triggered:", button.label );
}
```

## Skinning a `ButtonGroup`

A button group's buttons may all be skinned, with the first and last buttons having optional custom styles. A few other properties exist to customize the layout. For full details about what skin and style properties are available, see the [`ButtonGroup` API reference](../api-reference/feathers/controls/ButtonGroup.html). We'll look at a few of the most common properties below.

### Layout

The `ButtonGroup` has a strict horizontal or vertical layout that you can customize using the [`direction`](../api-reference/feathers/controls/ButtonGroup.html#direction) property. Additionally, you can set the [`gap`](../api-reference/feathers/controls/ButtonGroup.html#gap) between buttons, including special gaps for the first and last buttons.

``` code
group.direction = ButtonGroup.DIRECTION_VERTICAL;
group.gap = 10;
group.lastGap = 20;
```

The [`firstGap`](../api-reference/feathers/controls/ButtonGroup.html#firstGap) and [`lastGap`](../api-reference/feathers/controls/ButtonGroup.html#lastGap) are completely optional, and if they are not defined, the regular `gap` value will be used.

With a vertical layout, each button's width will match the width of the button group. Similarly, with a horizontal layout, the buttons will fill the entire height.

### Targeting a `ButtonGroup` in a theme

If you are creating a [theme](themes.html), you can specify a function for the default styles like this:

``` code
getStyleProviderForClass( ButtonGroup ).defaultStyleFunction = setButtonGroupStyles;
```

If you want to customize a specific button group to look different than the default, you may use a custom style name to call a different function:

``` code
group.styleNameList.add( "custom-button-group" );
```

You can specify the function for the custom style name like this:

``` code
getStyleProviderForClass( ButtonGroup )
    .setFunctionForStyleName( "custom-button-group", setCustomButtonGroupStyles );
```

Trying to change the button group's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the button group was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the button group's properties directly.

### Skinning the Buttons

This section only explains how to access the button sub-components. Please read [How to use the Feathers `Button` component](button.html) for full details about the skinning properties that are available on `Button` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON`](../api-reference/feathers/controls/ButtonGroup.html#DEFAULT_CHILD_STYLE_NAME_BUTTON) style name.

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( ButtonGroup.DEFAULT_CHILD_STYLE_NAME_BUTTON, setButtonBarButtonStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
group.customButtonStyleName = "my-custom-button";
```

You can set the styling function for the [`customButtonStyleName`](../api-reference/feathers/controls/ButtonGroup.html#customButtonStyleName) like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( "my-custom-button", setButtonGroupCustomButtonStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`buttonFactory`](../api-reference/feathers/controls/ButtonGroup.html#buttonFactory) to provide skins for the buttons:

``` code
group.buttonFactory = function():Button
{
    var button:Button = new Button();
    button.defaultSkin = new Image( texture );
    button.downSkin = new Image( texture );
    button.defaultLabelProperties.textFormat = new TextFormat("Arial", 24, 0x323232, true );
    return button;
};
```

In addition to the `buttonFactory`, you may use the [`buttonProperties`](../api-reference/feathers/controls/ButtonGroup.html#buttonProperties) to pass properties to the buttons. The values of these properties are shared by *all* buttons, so display objects should never be passed in using `buttonProperties`. A display object may only have one parent, so passing in a display object as a skin to every button is impossible. Other types of styles, like gap and padding, can be passed in through `buttonProperties`:

``` code
group.buttonProperties.gap = 20;
```

In general, you should only pass properties to the button group's buttons through `buttonProperties` if you need to change these values after the buttons are created. Using `buttonFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Skinning the First and Last Buttons

This section only explains how to access the first and last button sub-components. Please read [How to use the Feathers `Button` component](button.html) for full details about the skinning properties that are available on `Button` components.

The button group's first and last buttons will have the same skins as the other buttons by default. However, their skins may be customized separately, if desired.

For the first button, you can customize the style name with [`customFirstButtonStyleName`](../api-reference/feathers/controls/ButtonGroup.html#customFirstButtonStyleName). If you aren't using a theme, then you can use [`firstButtonFactory`](../api-reference/feathers/controls/ButtonGroup.html#firstButtonFactory).

For the last button, you can customize the style name with [`customLastButtonStyleName`](../api-reference/feathers/controls/ButtonGroup.html#customLastButtonStyleName). If you aren't using a theme, then you can use [`lastButtonFactory`](../api-reference/feathers/controls/ButtonGroup.html#lastButtonFactory).

Separate skins for the first and last buttons are completely optional.

## Related Links

-   [`feathers.controls.ButtonGroup` API Documentation](../api-reference/feathers/controls/ButtonGroup.html)

For more tutorials, return to the [Feathers Documentation](index.html).


