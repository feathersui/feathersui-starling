---
title: How to use the Feathers ToggleSwitch component  
author: Josh Tynjala

---
# How to use the Feathers `ToggleSwitch` component

The [`ToggleSwitch`](../api-reference/feathers/controls/ToggleSwitch.html) component switches between on and off states. It can be considered a stylized alternative to a [`Check`](check.html) control that is especially relevant when targeting touch screens. The thumb may be dragged from side to side, or it may be tapped to change selection.

## The Basics

First, let's create a toggle switch, select it, and add it to the display list.

``` code
var toggle:ToggleSwitch = new ToggleSwitch();
toggle.isSelected = true;
this.addChild( toggle );
```

The [`isSelected`](../api-reference/feathers/controls/ToggleSwitch.html#isSelected) property indicates if the toggle switch is on (`true`) or off (`false`). Add a listener to [`Event.CHANGE`](../api-reference/feathers/controls/ToggleSwitch.html#event:change) to know when the `isSelected` property changes:

``` code
toggle.addEventListener( Event.CHANGE, toggle_changeHandler );
```

The listener might look something like this:

``` code
function toggle_changeHandler( event:Event ):void
{
    var toggle:ToggleSwitch = ToggleSwitch( event.currentTarget );
    trace( "toggle.isSelected changed:", toggle.isSelected );
}
```

## Skinning a `ToggleSwitch`

The skins for a `ToggleSwitch` control are divided into the thumb, labels for off and on text, and one or two tracks. For full details about what skin and style properties are available, see the [`ToggleSwitch` API reference](../api-reference/feathers/controls/ToggleSwitch.html). We'll look at a few of the most common properties below.

### Targeting a `ToggleSwitch` in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( ToggleSwitch ).defaultStyleFunction = setToggleSwitchStyles;
```

If you want to customize a specific toggle switch to look different than the default, you may use a custom style name to call a different function:

``` code
toggle.styleNameList.add( "custom-toggle-switch" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( ToggleSwitch )
    .setFunctionForStyleName( "custom-toggle-switch", setCustomToggleSwitchStyles );
```

Trying to change the toggle switch's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the toggle switch was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the toggle switch's properties directly.

### Skinning the Labels

The on and off skins are text renderers that may be skinned separately or using default properties for both.

``` code
toggle.defaultLabelProperties.textFormat = new BitmapFontTextFormat( myBitmapFont );
```

If you wanted the on label to be different, you could use different properties for each label:

``` code
toggle.defaultLabelProperties.textFormat = new BitmapFontTextFormat( myBitmapFont );
toggle.onLabelProperties.textFormat = new BitmapFontTextFormat( myBitmapFont, myBitmapFont.size, 0xff9900 );
```

### Skinning the Thumb

This section only explains how to access the thumb sub-component. Please read [How to use the Feathers `Button` component](button.html) for full details about the skinning properties that are available on `Button` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB`](../api-reference/feathers/controls/ToggleSwitch.html#DEFAULT_CHILD_STYLE_NAME_THUMB) style name.

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB, setToggleSwitchThumbStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
toggle.customThumbStyleName = "custom-thumb";
```

You can set the function for the [`customThumbStyleName`](../api-reference/feathers/controls/ToggleSwitch.html#customThumbStyleName) like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName("custom-thumb", setToggleSwitchCustomThumbStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`thumbFactory`](../api-reference/feathers/controls/ToggleSwitch.html#thumbFactory) to provide skins for the toggle switch's thumb:

``` code
toggle.thumbFactory = function():Button
{
    var button:Button = new Button();
    //skin the thumb here
    button.defaultSkin = new Image( upTexture );
    button.downSkin = new Image( downTexture );
    return button;
}
```

Alternatively, or in addition to the `thumbFactory`, you may use the [`thumbProperties`](../api-reference/feathers/controls/ToggleSwitch.html#thumbProperties) to pass skins to the thumb.

``` code
toggle.thumbProperties.defaultSkin = new Image( upTexture );
toggle.thumbProperties.downSkin = new Image( downTexture );
```

In general, you should only skins to the toggle switch's thumb through `thumbProperties` if you need to change skins after the thumb is created. Using `thumbFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Track(s) and Layout

The toggle switch's track is made from either one or two buttons, depending on the value of the [`trackLayoutMode`](../api-reference/feathers/controls/ToggleSwitch.html#trackLayoutMode) property. The default value of this property is [`TrackLayoutMode.SINGLE`](../api-reference/feathers/controls/TrackLayoutMode.html#SINGLE), which creates a single track that fills the entire width and height of the toggle switch.

If we'd like to have separate buttons for both sides of the track (one for the on side and another for the off side), we can set `trackLayoutMode` to [`TrackLayoutMode.SPLIT`](../api-reference/feathers/controls/TrackLayoutMode.html#SPLIT). In this mode, the width or height of each track (depending on the direction of the toggle switch) is adjusted as the thumb moves to ensure that the two tracks always meet at the center of the thumb.

`TrackLayoutMode.SINGLE` is often best for cases where the track's appearance is mostly static. When you want down or hover states for the track, `TrackLayoutMode.SPLIT` works better because the state will only change on one side of the thumb, making it more visually clear to the user what is happening.

When the value of `trackLayoutMode` is `TrackLayoutMode.SINGLE`, the toggle switch will have a on track, but it will not have a off track. The on track will fill the entire region that is draggable.

### Skinning the On Track

This section only explains how to access the on track sub-component. Please read [How to use the Feathers `Button` component](button.html) for full details about the skinning properties that are available on `Button` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK`](../api-reference/feathers/controls/ToggleSwitch.html#DEFAULT_CHILD_STYLE_NAME_ON_TRACK) style name.

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK, setToggleSwitchOnTrackStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
toggle.customOnTrackStyleName = "custom-on-track";
```

You can set the function for the [`customOnTrackStyleName`](../api-reference/feathers/controls/ToggleSwitch.html#customOnTrackStyleName) like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( "custom-on-track", setToggleSwitchCustomOnTrackStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`onTrackFactory`](../api-reference/feathers/controls/ToggleSwitch.html#onTrackFactory) to provide skins for the toggle switch's on track:

``` code
toggle.onTrackFactory = function():Button
{
    var button:Button = new Button();
    //skin the on track here
    button.defaultSkin = new Image( upTexture );
    button.downSkin = new Image( downTexture );
    return button;
}
```

Alternatively, or in addition to the `onTrackFactory`, you may use the [`onTrackProperties`](../api-reference/feathers/controls/ToggleSwitch.html#onTrackProperties) to pass skins to the on track.

``` code
toggle.onTrackProperties.defaultSkin = new Image( upTexture );
toggle.onTrackProperties.downSkin = new Image( downTexture );
```

In general, you should only pass properties to the toggle switch's on track through `onTrackProperties` if you need to change these values after the on track is created. Using `onTrackFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Skinning the Off Track

This section only explains how to access the off track sub-component. Please read [How to use the Feathers `Button` component](button.html) for full details about the skinning properties that are available on `Button` components.

The toggle switch's off track may be skinned similarly to the on track. The style name to use with [themes](themes.html) is [`ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_TRACK`](../api-reference/feathers/controls/ToggleSwitch.html#DEFAULT_CHILD_STYLE_NAME_OFF_TRACK) or you can customize the style name with [`customOffTrackStyleName`](../api-reference/feathers/controls/ToggleSwitch.html#customOffTrackStyleName). If you aren't using a theme, then you can use [`offTrackFactory`](../api-reference/feathers/controls/ToggleSwitch.html#offTrackFactory) and [`offTrackProperties`](../api-reference/feathers/controls/ToggleSwitch.html#offTrackProperties).

## Related Links

-   [`feathers.controls.ToggleSwitch` API Documentation](../api-reference/feathers/controls/ToggleSwitch.html)