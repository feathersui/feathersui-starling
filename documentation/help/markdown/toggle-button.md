---
title: How to use the Feathers ToggleButton component  
author: Josh Tynjala

---
# How to use the Feathers `ToggleButton` component

The [`ToggleButton`](../api-reference/feathers/controls/ToggleButton.html) class is a [button](button.html) that may be selected and deselected when triggered. Like a button, a toggle button's skin, label, and icon can all be customized for each state, including separate styles for when the toggle button is selected and deselected.

## The Basics

First, let's create a `ToggleButton` control, give it a label, and add it to the display list:

``` code
var toggle:ToggleButton = new ToggleButton();
toggle.label = "Click Me";
this.addChild( toggle );
```

A toggle button may be selected and deselected when it is triggered, or we can change the button's selection programatically by setting the [`isSelected`](../api-reference/feathers/controls/ToggleButton.html#isSelected) property:

``` code
button.isSelected = true;
```

If we listen to the [`Event.CHANGE`](../api-reference/feathers/controls/ToggleButton.html#event:change) event, we can track whether the user has triggered the button to change the selection:

``` code
toggle.addEventListener( Event.CHANGE, toggle_changeHandler );
```

Check for the new value of `isSelected` in the listener:

``` code
function toggle_changeHandler( event:Event ):void
{
    var toggle:ToggleButton = ToggleButton( event.currentTarget );
    trace( "toggle.isSelected has changed:", toggle.isSelected );
}
```

## Skinning a `ToggleButton`

A number of skins and styles may be customized on a toggle button, expanding on the options provided by [buttons](button.html). For full details about what skin and style properties are available, see the [`ToggleButton` API reference](../api-reference/feathers/controls/ToggleButton.html). We'll look at a few of the most common properties below.

### Background skins, labels, and icons

In addition to the skin properties provided by the `Button` class, like `defaultSkin` and `downSkin`, a `ToggleButton` has additional skins for its states when selected. You can use [`defaultSelectedSkin`](../api-reference/feathers/controls/ToggleButton.html#defaultSelectedSkin), [`selectedUpSkin`](../api-reference/feathers/controls/ToggleButton.html#selectedUpSkin), [`selectedDownSkin`](../api-reference/feathers/controls/ToggleButton.html#selectedDownSkin), [`selectedHoverSkin`](../api-reference/feathers/controls/ToggleButton.html#selectedHoverSkin), and [`selectedDisabledSkin`](../api-reference/feathers/controls/ToggleButton.html#selectedDisabledSkin).

Similarly, a `ToggleButton` provides similar properties for styling the label text renderer when selected, like [`defaultSelectedLabelProperties`](../api-reference/feathers/controls/ToggleButton.html#defaultSelectedLabelProperties), [`selectedUpLabelProperties`](../api-reference/feathers/controls/ToggleButton.html#selectedUpLabelProperties), [`selectedDownLabelProperties`](../api-reference/feathers/controls/ToggleButton.html#selectedDownLabelProperties), [`selectedHoverLabelProperties`](../api-reference/feathers/controls/ToggleButton.html#selectedHoverLabelProperties), and [`selectedDisabledLabelProperties`](../api-reference/feathers/controls/ToggleButton.html#selectedDisabledLabelProperties).

Likewise, a `ToggleButton` provides similar properties for styling the licon when selected, like [`defaultSelectedIcon`](../api-reference/feathers/controls/ToggleButton.html#defaultSelectedIcon), [`selectedUpIcon`](../api-reference/feathers/controls/ToggleButton.html#selectedUpIcon), [`selectedDownIcon`](../api-reference/feathers/controls/ToggleButton.html#selectedDownIcon), [`selectedHoverIcon`](../api-reference/feathers/controls/ToggleButton.html#selectedHoverIcon), and [`selectedDisabledIcon`](../api-reference/feathers/controls/ToggleButton.html#selectedDisabledIcon).

### Targeting a `ToggleButton` in a theme

If you are creating a [theme](themes.html), you can specify a function for the default styles like this:

``` code
getStyleProviderForClass( ToggleButton ).defaultStyleFunction = setToggleButtonStyles;
```

If you want to customize a specific toggle button to look different than the default, you may use a custom style name to call a different function:

``` code
toggle.styleNameList.add( "custom-toggle-button" );
```

You can specify the function for the custom style name like this:

``` code
getStyleProviderForClass( ToggleButton )
    .setFunctionForStyleName( "custom-toggle-button", setCustomToggleButtonStyles );
```

Trying to change the toggle button's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the button was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the btoggle utton's properties directly.

### Advanced Skinning: Skin Value Selectors

The following [`SmartDisplayObjectStateValueSelector`](../api-reference/feathers/skins/SmartDisplayObjectStateValueSelector.html) provides skins for states, including selected states, similar to the example from [How to use the Feathers `Button` component](button.html).

``` code
var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
skinSelector.defaultValue = upButtonSkinTexture;
skinSelector.defaultSelectedValue = selectedUpButtonSkinTexture;
skinSelector.setValueForState( downSkinTexture, Button.STATE_DOWN, false);
skinSelector.setValueForState( hoverSkinTexture, Button.STATE_HOVER, false);
skinSelector.setValueForState( disabledSkinTextures, Button.STATE_DISABLED, false);
skinSelector.setValueForState( selectedDownSkinTexture, Button.STATE_DOWN, true);
skinSelector.setValueForState( selectedHoverSkinTexture, Button.STATE_HOVER, true);
skinSelector.setValueForState( selectedDisabledSkinTextures, Button.STATE_DISABLED, true);
toggle.stateToSkinFunction = skinSelector.updateValue;
```

Notice that we added a third argument when calling [`setValueForState()`](../api-reference/feathers/skins/StateWithToggleValueSelector.html#setValueForState()) in this example. This argument specifies whether a skin should be used if the toggle button's `isSelected` property is `true` or `false`.

Obviously, you could check `target.isSelected` in your own custom [`stateToSkinFunction`](../api-reference/feathers/controls/Button.html#stateToSkinFunction) to provide skins for states when the button is selected. Similarly, you could go even further to check whether the button has focus (if you're making a desktop app and the [focus manager](focus.html) is enabled) by using `button.focusManager.focus == button`.

## Related Links

-   [`feathers.controls.ToggleButton` API Documentation](../api-reference/feathers/controls/ToggleButton.html)

-   [How to use the Feathers `Button` component](button.html)