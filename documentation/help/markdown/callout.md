---
title: How to use the Feathers Callout component  
author: Josh Tynjala

---
# How to use the Feathers `Callout` component

The [`Callout`](../api-reference/feathers/controls/Callout.html) class renders content as a [pop-up](pop-ups.html) over all other content. Typically, a callout displays a rectangular border with an arrow or tail that points to an origin display object, such as a button. The arrow may appear on any of the callout's edges. The callout will close automatically when a touch is detected outside of the callout's bounds.

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

### Direction

The next is the callout's direction, which is where the callout appears relative to its origin. By default, this is [`Callout.DIRECTION_ANY`](../api-reference/feathers/controls/Callout.html#DIRECTION_ANY) which means that the callout may open [above](../api-reference/feathers/controls/Callout.html#DIRECTION_UP), [below](../api-reference/feathers/controls/Callout.html#DIRECTION_DOWN), to the [left](../api-reference/feathers/controls/Callout.html#DIRECTION_LEFT), or to the [right](../api-reference/feathers/controls/Callout.html#DIRECTION_RIGHT) of the origin. The exact direction will be chosen automatically based on a number of factors to place the callout in an ideal location. You can change this argument to select a specific direction if you never want the callout to open in one of the other directions.

### Modality

Following the direction is the `isModal` parameter. This determines whether there is an overlay between the callout and the rest of the display list. When a callout is modal, the overlay blocks touches to everything that appears under the callout. The callout may be closed by touching outside the bounds of the callout, or by calling `close()` on the `Callout` instance. If the callout isn't modal, the callout will still close when the user touches something outside of the callout (the same as a modal callout), but there will be no overlay to block the touch, and anything below the callout will remain interactive.

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
Callout.show( content, origin, Callout.DIRECTION_ANY, true, customCalloutFactory );
```

If you've created a [custom theme](custom-themes.html), you can set a styling function for a `Callout` with the style name `"custom-callout"` to provide different skins for this callout.

## Skinning a `Callout`

Callouts have a number of skin and style properties to let you customize their appearance. For full details about what skin and style properties are available, see the [`Callout` API reference](../api-reference/feathers/controls/Callout.html). We'll look at a few of the most common properties below.

Let's look at the skins first.

``` code
callout.backgroundSkin = new Image( backgroundTexture );
callout.topArrowSkin = new Image( topArrowTexture );
callout.rightArrowSkin = new Image( rightArrowTexture );
callout.bottomArrowSkin = new Image( bottomArrowTexture );
callout.leftArrowSkin = new Image( leftArrowTexture );
```

The background and each of the directional arrows have separate skins. If your arrow skins need to seamlessly transition into the background while covering up part of the background's border, you might use a negative gap for each of the arrows:

``` code
callout.topArrowGap = callout.rightArrowGap = callout.bottomArrowGap =
    callout.leftArrowGap = -2;
```

Speaking of borders, you can use padding styles to ensure that the callout's edges are visible around the callout's content.

``` code
callout.topArrowGap = 6;
callout.rightArrowGap = 8;
callout.bottomArrowGap = 6;
callout.leftArrowGap = 8;
```

Finally, there are static properties for the stage's padding. These ensure that callouts are positioned a certain number of pixels away from the edge of the stage.

``` code
Callout.stagePaddingTop = Callout.stagePaddingRight = Callout.stagePaddingBottom =
    Callout.stagePaddingLeft = 10;
```

### Targeting a `Callout` in a theme

If you are creating a [theme](themes.html), you can specify a function for the default styles like this:

``` code
getStyleProviderForClass( Callout ).defaultStyleFunction = setCalloutStyles;
```

If you want to customize a specific callout to look different than the default, you may use a custom style name to call a different function:

``` code
callout.styleNameList.add( "custom-callout" );
```

You can specify the function for the custom style name like this:

``` code
getStyleProviderForClass( Callout )
    .setFunctionForStyleName( "custom-callout", setCustomCalloutStyles );
```

Trying to change the callout's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the callout was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the callout's properties directly.

### Skinning a `Callout` without a theme

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
Callout.show( content, origin, directions, isModal, skinnedCalloutFactory );
```

You should generally always skin the callouts with a factory or with a theme instead of passing the skins to the `Callout` instance returned by calling `Callout.show()`. If you skin an callout after `Callout.show()` is called, it may not be positioned or sized correctly.

## Disposal

When manually closing the callout, you may call the [`close()`](../api-reference/feathers/controls/Callout.html#close()) function and pass in `true` or `false` for the `dispose` argument.

It's possible that the callout will close itself automatically. Properties like [`closeOnTouchBeganOutside`](../api-reference/feathers/controls/Callout.html#closeOnTouchBeganOutside), [`closeOnTouchEndedOutside`](../api-reference/feathers/controls/Callout.html#closeOnTouchEndedOutside), and [`closeOnKeys`](../api-reference/feathers/controls/Callout.html#closeOnKeys) allow this behavior to be customized.

By default, when the callout closes itself, it will also dispose itself. Set the [`disposeOnSelfClose`](../api-reference/feathers/controls/Callout.html#disposeOnSelfClose) property to `false` if you intend to reuse the callout. Simply add it to the [`PopUpManager`](pop-ups.html) again to reuse it.

Finally, you may want to reuse the callout's content. By default, the callout will also dispose its content when it is disposed. Set the [`disposeContent`](../api-reference/feathers/controls/Callout.html#disposeContent) property to `false` to allow your code to reuse the callout's content in another callout or elsewhere on the display list after the original callout is disposed.

## Related Links

-   [`feathers.controls.Callout` API Documentation](../api-reference/feathers/controls/Callout.html)