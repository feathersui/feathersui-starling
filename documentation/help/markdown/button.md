---
title: How to use the Feathers Button component  
author: Josh Tynjala

---
# How to use the Feathers `Button` component

The [`Button`](../api-reference/feathers/controls/Button.html) class displays a touchable button. It can display an optional label and an optional icon with a variety of layout options. Buttons have states for each of the different touch phases and the skin, label, and icon can all be customized for each state.

## The Basics

First, let's create a `Button` control, give it a label, and add it to the display list:

``` code
var button:Button = new Button();
button.label = "Click Me";
this.addChild( button );
```

If we want to know when the button is tapped or clicked, we can listen for [`Event.TRIGGERED`](../api-reference/feathers/controls/Button.html#event:triggered):

``` code
button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
```

This event is dispatched when the touch ends *and* the touch was not dragged outside of the button's bounds. In other words, the button is only triggered when the touch both begins and ends over the button.

The listener function might look like this:

``` code
function button_triggeredHandler( event:Event ):void
{
    trace( "button triggered" );
}
```

## Skinning a `Button`

A number of skins and styles may be customized on a button, including the background skin, the label text format, and the icon. For full details about what skin and style properties are available, see the [`Button` API reference](../api-reference/feathers/controls/Button.html). We'll look at a few of the most common properties below.

### Background Skins

We'll start the skinning process by giving our button appropriate background skins.

``` code
button.defaultSkin = new Image( myUpTexture );
button.downSkin = new Image( myDownTexture );
```

Above, we add background skins for a couple of different states. The [`defaultSkin`](../api-reference/feathers/controls/Button.html#defaultSkin) is a skin that is used for any state where a specific skin isn't provided. We provided a skin for the down state, using the [`downSkin`](../api-reference/feathers/controls/Button.html#downSkin) property, and that will take precedence over the default skin when the button is pressed down. However, other states like up and hover don't have skins, so they'll use the default skin. If we wanted to, we could provide an [`upSkin`](../api-reference/feathers/controls/Button.html#upSkin) and a [`hoverSkin`](../api-reference/feathers/controls/Button.html#hoverSkin) for these states. The skin for the up state of a button almost always makes a good `defaultSkin`.

For a button that can be disabled, we can provide a [`disabledSkin`](../api-reference/feathers/controls/Button.html#disabledSkin) too.

See the [Advanced Skinning](#advanced-skinning) section below for additional button skinning techniques that can be used for optimized performance.

### Labels

Next, let's ensure that the text is displayed. By default, Feathers uses Starling's [bitmap font capabilities](http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts).

To style the text, we pass in a [`BitmapFontTextFormat`](../api-reference/feathers/text/BitmapFontTextFormat.html) which allows us to pass in a [`BitmapFont`](http://doc.starling-framework.org/core/starling/text/BitmapFont.html) instance or a String name for a BitmapFont that has been registered with [`TextField.registerBitmapFont()`](http://doc.starling-framework.org/core/starling/text/TextField.html#registerBitmapFont()).

``` code
button.defaultLabelProperties.textFormat = new BitmapFontTextFormat( myBitmapFont );
```

Notice that we refer to [`defaultLabelProperties`](../api-reference/feathers/controls/Button.html#defaultLabelProperties) in much the same way that we refer to `defaultSkin` above. Just like with skins, labels may be styled differently depending on which state the button is in. If you want all states to use the same label styles, then you only need to pass your properties to `defaultLabelProperties`. Label styles for other states, like [`downLabelProperties`](../api-reference/feathers/controls/Button.html#downLabelProperties) exist too. See the [`Button`](../api-reference/feathers/controls/Button.html) documentation for full details.

If you don't want to use bitmap font rendering, and you'd prefer to use Flash's traditional font rendering for device or embedded fonts, you can tell Feathers to use the [`TextFieldTextRenderer`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html) instead. This renderer can use the classic `flash.text.TextFormat`. For more information about using device or embedded fonts, see the [Text Renderers](text-renderers.html) tutorial.

### Icons

Finally, let's add an icon to the `Button`. Icons may be customized for all states, but let's simply use one icon.

``` code
button.defaultIcon = new Image( myIcon );
button.iconPosition = Button.ICON_POSITION_TOP;
```

Again, the `Button` class provides a default option to supply an icon for all of the button's states, the [`defaultIcon`](../api-reference/feathers/controls/Button.html#defaultIcon) property. Icons for all other states, like [`downIcon`](../api-reference/feathers/controls/Button.html#downIcon) and [`hoverIcon`](../api-reference/feathers/controls/Button.html#hoverIcon) are available too.

We also set the [`iconPosition`](../api-reference/feathers/controls/Button.html#iconPosition) property so that the icon appears above the label. We can position the icon to the top, right, bottom, or left of the label. There are various other useful layout options too:

``` code
button.gap = 10;
button.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
button.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
```

The [`gap`](../api-reference/feathers/controls/Button.html#gap) refers to the space, measured in pixels, between the icon and the label. The [`horizontalAlign`](../api-reference/feathers/controls/Button.html#horizontalAlign) and [`verticalAlign`](../api-reference/feathers/controls/Button.html#verticalAlign) properties will adjust the alignment of the icon and label inside the button, allowing you to anchor them at the edges or in the center.

See the [Advanced Skinning](#advanced-skinning) section below for additional techniques to optimize performance when providing multiple icons to a button.

### Targeting a `Button` in a theme

If you are creating a [theme](themes.html), you can specify a function for the default styles like this:

``` code
getStyleProviderForClass( Button ).defaultStyleFunction = setButtonStyles;
```

If you want to customize a specific button to look different than the default, you may use a custom style name to call a different function:

``` code
button.styleNameList.add( "custom-button" );
```

You can specify the function for the custom style name like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( "custom-button", setCustomButtonStyles );
```

Trying to change the button's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the button was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the button's properties directly.

## Advanced Skinning

For optimal performance, the same display object may be shared among different button states while simply changing properties. For instance, you might want to share a [`starling.display.Image`](http://doc.starling-framework.org/core/starling/display/Image.html) instance between multiple states while changing the value of [`texture`](http://doc.starling-framework.org/core/starling/display/Image.html#texture) property, or maybe you'd prefer to use a Feathers [`ImageLoader`](image-loader.html) instance and simply change the value of the [`source`](../api-reference/feathers/controls/ImageLoader.html#source) property.

When using this technique, the standard `defaultSkin`, `downSkin`, and similar properties are ignored. Instead, the `Function` passed to the [`stateToSkinFunction`](../api-reference/feathers/controls/Button.html#stateToSkinFunction) property is always used. This function has the following signature:

``` code
function( target:Button, state:Object, oldSkin:DisplayObject = null ):DisplayObject
```

This function receives the `Button` instance, the current state, and the skin used for the button's previous state.

The following state constants are used by the `Button` class:

-   [`Button.STATE_UP`](../api-reference/feathers/controls/Button.html#STATE_UP)

-   [`Button.STATE_HOVER`](../api-reference/feathers/controls/Button.html#STATE_HOVER)

-   [`Button.STATE_DOWN`](../api-reference/feathers/controls/Button.html#STATE_DOWN)

-   [`Button.STATE_DISABLED`](../api-reference/feathers/controls/Button.html#STATE_DISABLED)

The old skin passed in as the final argument may be `null`. If so, a new skin must be created. If it is not `null`, and its datatype matches the expected datatype, then it may be reused. If it's a different datatype, then a new skin must be created.

Let's look at an example of a simple `stateToSkinFunction` implementation:

``` code
function( target:Button, state:Object, oldSkin:DisplayObject = null ):DisplayObject
{
    var skin:ImageLoader = oldSkin as ImageLoader;
    if( !skin )
    {
        skin = new ImageLoader();
    }
 
    switch( state )
    {
        case Button.STATE_DISABLED:
        {
            skin.source = disabledButtonSkinTexture;
            break;
        }
        case Button.STATE_DOWN:
        {
            skin.source = downButtonSkinTexture;
            break;
        }
        case Button.STATE_HOVER:
        {
            skin.source = hoverButtonSkinTexture;
            break;
        }
        default:
        {
            skin.source = upButtonSkinTexture;
        }
    }
    return skin;
}
```

In the example above, the button skins are [`ImageLoader`](image-loader.html) components. If the old skin is an `ImageLoader`, it is reused. If it is `null` or another datatype, then a new `ImageLoader` is created. The `source` property is updated to use a different [`starling.textures.Texture`](http://doc.starling-framework.org/core/starling/textures/Texture.html) instance depending on the value of the `Button` instance's current state.

### Skin Value Selectors

The [`SmartDisplayObjectStateValueSelector`](../api-reference/feathers/skins/SmartDisplayObjectStateValueSelector.html) class provides an implementation of [`stateToSkinFunction`](../api-reference/feathers/controls/Button.html#stateToIconFunction) that smartly selects the correct display object based on the values passed in. For instance, if you pass in a `Texture` instance, it will return an `Image` as the skin. If you pass in a `Scale9Textures` object, it will return a `Scale9Image` as the skin. If you pass in a `Scale3Textures` object, it will return a `Scale3Image` as the skin. Finally, if you pass in a `uint` color value, it will return a `Quad` as the skin.

The following `SmartDisplayObjectStateValueSelector` provides an implementation similar to the example above.

``` code
var skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
skinSelector.defaultValue = upButtonSkinTexture;
skinSelector.setValueForState( downSkinTexture, Button.STATE_DOWN );
skinSelector.setValueForState( hoverSkinTexture, Button.STATE_HOVER );
skinSelector.setValueForState( disabledSkinTextures, Button.STATE_DISABLED );
button.stateToSkinFunction = skinSelector.updateValue;
```

Simply pass a reference to the [`updateValue`](../api-reference/feathers/skins/StateWithToggleValueSelector.html#updateValue()) function to the button's `stateToSkinFunction` property.

In your own custom `stateToSkinFunction`, you could even provide skins for states when the button is focused (if you're making a desktop app and the [focus manager](focus.html) is enabled) by using `button.focusManager.focus == button`.

### Icons

Similar to `stateToSkinFunction`, button also provides [`stateToIconFunction`](../api-reference/feathers/controls/Button.html#stateToIconFunction) to share a display object between multiple states for the button's icon.

## Related Links

-   [`feathers.controls.Button` API Documentation](../api-reference/feathers/controls/Button.html)