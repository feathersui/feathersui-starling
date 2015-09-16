---
title: How to use the Feathers Button component  
author: Josh Tynjala

---
# How to use the Feathers `Button` component

The [`Button`](../api-reference/feathers/controls/Button.html) class displays a button that may be triggered by pressing and releasing. It can display an optional label and an optional icon with a variety of layout options. Buttons have separate states for each of the different touch phases. The skin and icon can be customized for each state, and the label [text renderer](text-renderers.html) may display different font styles for each state too.

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

## Styling a `Button`

A number of styling properties may be customized on a button, including the background skin, the label text renderer's font styles, and the icon. For full details about which properties are available, see the [`Button` API reference](../api-reference/feathers/controls/Button.html). We'll look at a few of the most common styling scenarios below.

<aside class="warn"><strong>Important:</strong> If you're using a theme, and you want to customize a specific button's styles, you must either [extend the theme with a new *style name*](extending-themes.html), or you may use an [`AddOnFunctionStyleProvider`](../api-reference/feathers/skins/AddOnFunctionStyleProvider.html) to set properties outside of the theme.</aside>

### Background Skins

We'll start the skinning process by giving our button its background skin.

``` code
button.defaultSkin = new Image( myUpTexture );
button.setSkinForState( Button.STATE_DOWN, new Image( myDownTexture ) );
```

Above, we add background skins for a couple of different states. The [`defaultSkin`](../api-reference/feathers/controls/Button.html#defaultSkin) is a used for any state where a specific skin isn't provided. We provided a skin specfically for the down state, using the [`setSkinForState()`](../api-reference/feathers/controls/Button.html#setSkinForState()) method, and that will take precedence over the default skin when the button is pressed down. However, other states (like up, hover, and disabled) don't have skins in our example code, so the button will use the default skin for these states.

Buttons may display separate skins for the following states:

* [`Button.STATE_UP`](../api-reference/feathers/controls/Button.html#STATE_UP)
* [`Button.STATE_DOWN`](../api-reference/feathers/controls/Button.html#STATE_DOWN)
* [`Button.STATE_HOVER`](../api-reference/feathers/controls/Button.html#STATE_HOVER)
* [`Button.STATE_DISABLED`](../api-reference/feathers/controls/Button.html#STATE_DISABLED)

<aside class="info">In general, it's better to pass the skin for the up state to the `defaultSkin` property instead of calling `setSkinForState()` with `Button.STATE_UP`. The up skin often makes the best default for any other states that don't have a specific skin.</aside>

See the [Advanced Skinning](#advanced-skinning) section below for additional button skinning techniques that can be used for optimized performance.

### Label font styles

Next, let's customize the font styles of the button's label [text renderer](text-renderers.html).

<aside class="info">In the example code below, we'll display the button's label text using [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html), which draws text using [Flash Text Engine](http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html). Different text renderers may not use the same properties names to customize their font styles. Please read [Introduction to Feathers text renderers](text-renderers.html) for more information about the different text renderers that Feathers supports, and how to use each of them.</aside>

Let's customize the font styles in the [`labelFactory`](../api-reference/feathers/controls/Button.html#labelFactory):

``` code
button.labelFactory = function():ITextRenderer
{
	var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
	textRenderer.styleProvider = null;
	var font:FontDescription = new FontDescription( "_sans" );
	textRenderer.elementFormat = new ElementFormat( font, 20, 0x444444 );
	return textRenderer;
}
```

After we create the `TextBlockTextRenderer`, we set its `styleProvider` property to `null`. This ensures that our font styles cannot be replaced by a theme.

Then, we set the [`elementFormat`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#elementFormat) property. This is how the font styles of a `TextBlockTextRenderer` may be customized.

Often, the color of a button's label, or other font styles, should change when the button's state changes. We can pass different font styles to the `TextBlockTextRenderer` for each state, if needed:

```code
var downFormat:ElementFormat = new ElementFormat( font, 20, 0x343434 );
textRenderer.setElementFormatForState( Button.STATE_DOWN, downFormat );

var disabledFormat:ElementFormat = new ElementFormat( font, 20, 0x969696 );
textRenderer.setElementFormatForState( Button.STATE_DISABLED, disabledFormat );
```

### Icons

Finally, let's add an icon to the `Button`. Icons may be customized for each of the button's states (just like the background skin), but let's simply use one icon.

``` code
button.defaultIcon = new Image( myIcon );
button.iconPosition = Button.ICON_POSITION_TOP;
```

Again, the `Button` class provides a default option to supply an icon for all of the button's states, the [`defaultIcon`](../api-reference/feathers/controls/Button.html#defaultIcon) property. Icons for all other states may be defined by calling [`setIconForState()`](../api-reference/feathers/controls/Button.html#setIconForState()).

We also set the [`iconPosition`](../api-reference/feathers/controls/Button.html#iconPosition) property so that the icon appears above the label. We can position the icon to the top, right, bottom, or left of the label. There are various other useful layout options too.

The [`gap`](../api-reference/feathers/controls/Button.html#gap) refers to the space, measured in pixels, between the icon and the label:

``` code
button.gap = 10;
```

The [`horizontalAlign`](../api-reference/feathers/controls/Button.html#horizontalAlign) and [`verticalAlign`](../api-reference/feathers/controls/Button.html#verticalAlign) properties will adjust the alignment of the icon and label inside the button, allowing you to anchor them at the edges or in the center.

``` code
button.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
button.verticalAlign = Button.VERTICAL_ALIGN_MIDDLE;
```

See the [Advanced Skinning](#advanced-skinning) section below for additional techniques to optimize performance when providing icons for multiple button states.

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