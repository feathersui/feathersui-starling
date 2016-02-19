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

If we want to know when the button is tapped or clicked, we can listen for [`Event.TRIGGERED`](../api-reference/feathers/controls/BasicButton.html#event:triggered):

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
button.setSkinForState( ButtonState.DOWN, new Image( myDownTexture ) );
```

Above, we add background skins for a couple of different states. The [`defaultSkin`](../api-reference/feathers/controls/BasicButton.html#defaultSkin) is a used when a skin isn't provided for the button's current skin. In the code above, we provided a skin specfically for the down state, using the [`setSkinForState()`](../api-reference/feathers/controls/BasicButton.html#setSkinForState()) method, and that will take precedence over the default skin when the button is pressed down. However, other states (like up, hover, and disabled) don't have skins in our example code, so the button will use the default skin for these states.

<aside class="info">In general, it's better to pass the skin for the up state to the `defaultSkin` property instead of calling `setSkinForState()` with `ButtonState.UP`. The up skin often makes the best default for any other states that don't have a specific skin.</aside>

Buttons may display separate skins for the following states:

* [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
* [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
* [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
* [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)

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
textRenderer.setElementFormatForState( ButtonState.DOWN, downFormat );

var disabledFormat:ElementFormat = new ElementFormat( font, 20, 0x969696 );
textRenderer.setElementFormatForState( ButtonState.DISABLED, disabledFormat );
```

### Icons

Finally, let's add an icon to the `Button`. Icons may be customized for each of the button's states (just like the background skin), but let's simply use one icon.

``` code
button.defaultIcon = new Image( myIcon );
button.iconPosition = RelativePosition.TOP;
```

Again, the `Button` class provides a default option to supply an icon for all of the button's states, the [`defaultIcon`](../api-reference/feathers/controls/Button.html#defaultIcon) property. Icons for all other states may be defined by calling [`setIconForState()`](../api-reference/feathers/controls/Button.html#setIconForState()).

We also set the [`iconPosition`](../api-reference/feathers/controls/Button.html#iconPosition) property so that the icon appears above the label. We can position the icon to the top, right, bottom, or left of the label. There are various other useful layout options too.

The [`gap`](../api-reference/feathers/controls/Button.html#gap) refers to the space, measured in pixels, between the icon and the label:

``` code
button.gap = 10;
```

The [`horizontalAlign`](../api-reference/feathers/controls/Button.html#horizontalAlign) and [`verticalAlign`](../api-reference/feathers/controls/Button.html#verticalAlign) properties will adjust the alignment of the icon and label inside the button, allowing you to anchor them at the edges or in the center.

``` code
button.horizontalAlign = HorizontalAlign.CENTER;
button.verticalAlign = VerticalAlign.MIDDLE;
```

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

## Related Links

-   [`feathers.controls.Button` API Documentation](../api-reference/feathers/controls/Button.html)