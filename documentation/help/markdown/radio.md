---
title: How to use the Feathers Radio component  
author: Josh Tynjala

---
# How to use the Feathers `Radio` component

The `Radio` component is a [`ToggleButton`](toggle-button.html) component that integrates with a `ToggleGroup` so that only one `Radio` in the group is selected at a time.

A skinned `Radio` component usually has no background (or a transparent one) and the touch states of the radio are displayed through the icon skins. For more detailed information about the skinning options available to `Radio`, see [How to use the Feathers `ToggleButton` component](toggle-button.html).

## Using `ToggleGroup`

If no `ToggleGroup` is provided, a `Radio` will automatically add itself to `Radio.defaultToggleGroup`. In general, though, you should always create a `ToggleGroup` for a distinct set of radio buttons.

``` code
var group:ToggleGroup = new ToggleGroup();
 
var radio1:Radio = new Radio();
radio1.label = "One";
radio1.toggleGroup = group;
this.addChild( radio1 );
 
var radio2:Radio = new Radio();
radio2.label = "Two";
radio2.toggleGroup = group;
this.addChild( radio2 );
 
var radio3:Radio = new Radio();
radio3.label = "Three";
radio3.toggleGroup = group;
this.addChild( radio3 );
```

Simply pass the `ToggleGroup` instance to the `toggleGroup` property of a `Radio` instance.

Listen for the `Event.CHANGE` event of the toggle group to know when the selected radio button has changed.

``` code
group.addEventListener( Event.CHANGE, group_changeHandler );
```

A listener might look like this:

``` code
function group_changeHandler( event:Event ):void
{
    var group:ToggleGroup = ToggleGroup( event.currentTarget );
    trace( "group.selectedIndex:", group.selectedIndex );
}
```

Use the `selectedIndex` to get the numeric index of the selected radio button (based on the order that the radio buttons were added to the toggle group). The `selectedItem` will reference the selected radio button directly:

``` code
var radio:Radio = Radio( group.selectedItem );
trace( "radio.label:", radio.label );
```

## Skinning a Radio

A skinned `Radio` component usually has no background (or a transparent one) and the touch states of the radio are displayed through the icon skins. For full details about what skin and style properties are available, see the [Radio API reference](../api-reference/feathers/controls/Radio.html).

As mentioned above, `Radio` is a subclass of `Button`. For more detailed information about the skinning options available to `Radio`, see [How to use the Feathers `ToggleButton` component](toggle-button.html).

### Targeting a Radio in a theme

If you are creating a [theme](themes.html), you can set an function for the default styles like this:

``` code
getStyleProviderForClass( Radio ).defaultStyleFunction = setRadioStyles;
```

If you want to customize a specific radio to look different than the default, you may use a custom style name to call a different function:

``` code
radio.styleNameList.add( "custom-radio" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( Radio )
    .setFunctionForStyleName( "custom-radio", setCustomRadioStyles );
```

Trying to change the radio's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the radio was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the radio's properties directly.

## User Experience

In general, a set of `Radio` controls should be used only when there are three or more choices that a user must make. If there are only two choices, a `Check` or a `ToggleSwitch` may be more appropriate. If there are so many choices that a set of `Radio` controls will fill a significant amount of space on screen, a `PickerList` is probably a better choice. The default item renderer of a `PickerList` is also a subclass of `Button`, so it's possible to style the list's items to look like radio buttons, if you prefer.

## Related Links

-   [`feathers.controls.Radio` API Documentation](../api-reference/feathers/controls/Radio.html)

-   [`feathers.core.ToggleGroup` API Documentation](../api-reference/feathers/core/ToggleGroup.html)

-   [How to use the Feathers `ToggleButton` component](toggle-button.html)

For more tutorials, return to the [Feathers Documentation](index.html).


