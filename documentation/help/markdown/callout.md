---
title: How to use the Feathers Callout component  
author: Josh Tynjala

---
# How to use the Feathers `Callout` component

The [`Callout`](../api-reference/feathers/controls/Callout.html) class renders content as a [pop-up](pop-ups.html) over all other content. Typically, a callout displays a rectangular border with an arrow or tail that points to an origin display object, such as a button. The arrow may appear on any of the callout's edges. The callout will close automatically when a touch is detected outside of the callout's bounds.

<figure>
<img src="images/callout.png" srcset="images/callout@2x.png 2x" alt="Screenshot of Feathers a Callout component" />
<figcaption>A `Callout` component skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

-   [The Basics](#the-basics)

-   [Skinning a `Callout`](#skinning-a-callout)

-   [Closing and Disposal](#closing-and-disposal)

## The Basics

We create a `Callout` a bit differently than other components. Rather than calling a constructor, we call the static function [`Callout.show()`](../api-reference/feathers/controls/Callout.html#show()). Let's see how this works by displaying a [`starling.display.Image`](http://doc.starling-framework.org/core/starling/display/Image.html) in a `Callout` when we touch a button. First, let's create the button:

``` code
var button:Button = new Button();
button.label = "Click Me";
button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
this.addChild( button );
```

Then, in the listener for the `Event.TRIGGERED` event, we create the callout:

``` code
function button_triggeredHandler( event:Event ):void
{
    var button:Button = Button( event.currentTarget );
    var content:Image = new Image( myTexture );
    var callout:Callout = Callout.show( content, button );
}
```

Two arguments are required. The first is the callout's content. This may be any Starling display object. The callout will be automatically resized to fit its content, unless you set `width` or `height` manually. The second argument is the origin of the callout. When the callout is shown, it will be automatically positioned so that its arrow points at the origin.

A callout may be closed manually by calling the [`close()`](../api-reference/feathers/controls/Callout.html#close()) function.

Additional arguments are available for `Callout.show()`. Let's take a look at those.

### Position

The next is the callout's position, which is where the callout appears relative to its origin. By default, if this value is `null`, the callout may open on any of the four sides of the origin.

The positions should be passed in as a `Vector.<String>`, so the following value could be used instead of `null` to get the same behavior: 

``` code
new <String>[RelativePosition.TOP, RelativePosition.RIGHT, RelativePosition.BOTTOM, RelativePosition.LEFT]
```

The exact position will be chosen automatically based on a number of factors to place the callout in an ideal location. You can change this argument to allow fewer positions if you never want the callout to open on certain sides of the origin. For instance, if you always wanted the callout to appear to the top of the origin, you would pass in the following value:

``` code
new <String>[RelativePosition.TOP]
```

Use the following constants on the [`feathers.layout.RelativePosition`](../api-reference/feathers/layout/RelativePosition.html) class to position the callout.

* [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
* [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
* [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
* [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)

### Modality

Following the position is the `isModal` parameter. This determines whether there is an overlay between the callout and the rest of the display list. When a callout is modal, the overlay blocks touches to everything that appears under the callout. The callout may be closed by touching outside the bounds of the callout, or by calling `close()` on the `Callout` instance. If the callout isn't modal, the callout will still close when the user touches something outside of the callout (the same as a modal callout), but there will be no overlay to block the touch, and anything below the callout will remain interactive.

Callouts are displayed using the [`PopUpManager`](pop-ups.html). By default, modal overlays are managed by the `PopUpManager`, but you can give a custom overlay to callouts (that will be different from other modal pop-ups) when you set the static property, [`calloutOverlayFactory`](../api-reference/feathers/controls/Callout.html#calloutOverlayFactory):

``` code
Callout.calloutOverlayFactory = function():DisplayObject
{
    var tiledBackground:Image = new Image( texture );
    tiledBackground.tileGrid = new Rectangle();
    return tiledBackground;
};
```

When [`PopUpManager.addPopUp()`](../api-reference/feathers/core/PopUpManager.html#addPopUp()) is called to show the callout, the custom overlay factory will be passed in as an argument.

### Custom Callout Factory

When a callout is created with `Callout.show()`, the function stored by the [`Callout.calloutFactory()`](../api-reference/feathers/controls/Callout.html#calloutFactory) property is called to instantiate a `Callout` instance. The final argument of `Callout.show()` allows you to specify a custom callout factory. This let's you customize an individual callout to be different than other callouts. For instance, let's say that a particular callout should have different skins than others. We might create a callout factory function like this:

``` code
function customCalloutFactory():Callout
{
    var callout:Callout = new Callout();
    callout.styleNameList.add( "custom-callout" );
    return callout;
};
Callout.show( content, origin, null, true, customCalloutFactory );
```

If you've created a [custom theme](custom-themes.html), you can set a styling function for a `Callout` with the style name `"custom-callout"` to provide different skins for this callout.

## Skinning a `Callout`

Callouts have a number of skin and style properties to let you customize their appearance. For full details about which properties are available, see the [`Callout` API reference](../api-reference/feathers/controls/Callout.html). We'll look at a few of the most common ways of styling a callout below.

### Background and arrow skins

Let's give the callout a background skin that appears behind the content and stretches to fill the entire width and height of the callout. In the following example, we pass in a `starling.display.Image`, but the skin may be any Starling display object:

``` code
var skin:Image = new Image( enabledTexture );
skin.scale9Grid = new Rectangle( 2, 4, 3, 8 );
callout.backgroundSkin = skin;
```

It's as simple as setting the [`backgroundSkin`](../api-reference/feathers/controls/Callout.html#backgroundSkin) property.

You may also skin the callout's arrow that points to its origin. Depending on which position the callout opens relative to the origin, the arrow may be on any of the callout's four sides.

``` code
callout.topArrowSkin = new Image( topArrowTexture );
callout.rightArrowSkin = new Image( rightArrowTexture );
callout.bottomArrowSkin = new Image( bottomArrowTexture );
callout.leftArrowSkin = new Image( leftArrowTexture );
```

If you know that the callout will always open in one position, you can provide a single arrow skin. Otherwise, it's a good idea to provide all four.

### Layout

The callout can have a gap in between the background skin and the arrow skin. In fact, this "gap" can be negative, meaning that the arrow skin will overlap the background skin. This will allow the arrow skins to seamlessly transition into the background while covering up part of the background's border:

``` code
callout.topArrowGap = -2;
```

Above, we set the [`topArrowGap`](../api-reference/feathers/controls/Callout.html#topArrowGap), but you can also set [`rightArrowGap`](../api-reference/feathers/controls/Callout.html#rightArrowGap), [`bottomArrowGap`](../api-reference/feathers/controls/Callout.html#bottomArrowGap), and [`leftArrowGap`](../api-reference/feathers/controls/Callout.html#leftArrowGap).

Speaking of borders, you can use padding styles to ensure that the callout's edges are visible around the callout's content.

``` code
callout.paddingTop = 6;
callout.paddingRight = 8;
callout.paddingBottom = 6;
callout.paddingLeft = 8;
```

If all four padding values should be the same, you may use the [`padding`](../api-reference/feathers/controls/Callout.html#padding) property to quickly set them all at once:

``` code
button.padding = 6;
```

Finally, there are static properties for the stage's padding. These ensure that callouts are positioned a certain number of pixels away from the edges of the stage.

``` code
Callout.stagePaddingTop = 8;
Callout.stagePaddingRight = 10;
Callout.stagePaddingBottom = 8;
Callout.stagePaddingLeft = 10;
```

### Using a factory to skin a `Callout` without a theme

If you're not using a theme, you can specify a factory to create the callout, including setting skins, in a couple of different ways. The first is to set the [`Callout.calloutFactory`](../api-reference/feathers/controls/Callout.html#calloutFactory) static property to a function that provides skins for the callout. This factory will be called any time that [`Callout.show()`](../api-reference/feathers/controls/Callout.html#show()) is used to create a callout.

``` code
function skinnedCalloutFactory():Callout
{
    var callout:Callout = new Callout();
    callout.backgroundSkin = new Image( myBackgroundTexture );
    callout.topArrowSkin = new Image( myTopTexture );
    // etc...
    return callout;
};
Callout.calloutFactory = skinnedCalloutFactory;
```

Another option is to pass a callout factory to `Callout.show()`. This allows you to create a specific callout differently than the default global `Callout.calloutFactory`.

``` code
function skinnedCalloutFactory():Callout
{
    var callout:Callout = new Callout();
    callout.backgroundSkin = new Image( myBackgroundTexture );
    callout.topArrowSkin = new Image( myTopTexture );
    // etc...
    return callout;
};
Callout.show( content, origin, positions, isModal, skinnedCalloutFactory );
```

You should generally always skin the callouts with a factory or with a theme instead of passing the skins to the `Callout` instance returned by calling `Callout.show()`. If you skin an callout after `Callout.show()` is called, it may not necessarily be positioned or sized correctly.

## Closing and Disposal

When manually closing the callout, you may call the [`close()`](../api-reference/feathers/controls/Callout.html#close()) function and pass in `true` or `false` for the `dispose` argument.

It's possible that the callout will close itself automatically. Properties like [`closeOnTouchBeganOutside`](../api-reference/feathers/controls/Callout.html#closeOnTouchBeganOutside), [`closeOnTouchEndedOutside`](../api-reference/feathers/controls/Callout.html#closeOnTouchEndedOutside), and [`closeOnKeys`](../api-reference/feathers/controls/Callout.html#closeOnKeys) allow this behavior to be customized.

By default, when the callout closes itself, it will also dispose itself. Set the [`disposeOnSelfClose`](../api-reference/feathers/controls/Callout.html#disposeOnSelfClose) property to `false` if you intend to reuse the callout. Simply add it to the [`PopUpManager`](pop-ups.html) again to reuse it.

Finally, you may want to reuse the callout's content. By default, the callout will also dispose its content when it is disposed. Set the [`disposeContent`](../api-reference/feathers/controls/Callout.html#disposeContent) property to `false` to allow your code to reuse the callout's content in another callout or elsewhere on the display list after the original callout is disposed.

## Related Links

-   [`feathers.controls.Callout` API Documentation](../api-reference/feathers/controls/Callout.html)

-   [How to use the Feathers `TextCallout` component](text-callout.html)