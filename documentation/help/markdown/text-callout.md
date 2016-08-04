---
title: How to use the Feathers TextCallout component  
author: Josh Tynjala

---
# How to use the Feathers `TextCallout` component

The [`TextCallout`](../api-reference/feathers/controls/TextCallout.html) class is a special type of [callout](callout.html) that simply renders a string as its content.

<figure>
<img src="images/text-callout.png" srcset="images/text-callout@2x.png 2x" alt="Screenshot of a Feathers TextCallout component" />
<figcaption>A `TextCallout` component skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

-   [The Basics](#the-basics)

-   [Skinning a `TextCallout`](#skinning-a-textcallout)

## The Basics

We create a `TextCallout` a bit differently than other components. Rather than calling a constructor, we call the static function [`TextCallout.show()`](../api-reference/feathers/controls/TextCallout.html#show()). Let's see how this works by displaying message in a `TextCallout` when we touch a button. First, let's create the button:

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
    var callout:TextCallout = TextCallout.show( "Hello World", button );
}
```

Two arguments are required. The first is the callout's text. This is a simple `String`. The callout will be automatically resized to fit its content, unless you set `width` or `height` manually. The second argument is the origin of the callout. When the callout is shown, it will be automatically positioned so that its arrow points at the origin display object.

A text callout may be closed manually by calling the [`close()`](../api-reference/feathers/controls/Callout.html#close()) function.

Additional arguments are available for `TextCallout.show()`, including the direction, whether the callout is modal, and factories for the callout and the modal overlay. See [How to use the Feathers `Callout` component](callout.html) for full details.

## Skinning a `TextCallout`

Callouts have a number of skin and style properties to let you customize their appearance. For full details about what skin and style properties are available, see the [`TextCallout` API reference](../api-reference/feathers/controls/TextCallout.html). We'll look at a few of the most common ways of styling a text input below.

<aside class="info">As mentioned above, `TextCallout` is a subclass of `Callout`. For more detailed information about the skinning options available to `TextCallout`, see [How to use the Feathers `Callout` component](callout.html).</aside>

### Font Styles

The input's callout styles may be customized using the [`fontStyles`](../api-reference/feathers/controls/TextCallout.html#fontStyles) property.

``` code
callout.fontStyles = new TextFormat( "Helvetica", 20, 0x3c3c3c );
```

Pass in a [`starling.text.TextFormat`](http://doc.starling-framework.org/current/starling/text/TextFormat.html) object, which will work with any type of [text renderer](text-renderers.html).

### Skinning a `TextCallout` without a theme

If you're not using a theme, you can specify a factory to create the callout, including setting skins, in a couple of different ways. The first is to set the [`TextCallout.calloutFactory`](../api-reference/feathers/controls/TextCallout.html#calloutFactory) static property to a function that provides skins for the callout. This factory will be called any time that [`TextCallout.show()`](../api-reference/feathers/controls/TextCallout.html#show()) is used to create a callout.

``` code
function skinnedTextCalloutFactory():TextCallout
{
    var callout:TextCallout = new TextCallout();

    //set the styles here, if not using a theme
    callout.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );
    callout.backgroundSkin = new Image( myBackgroundTexture );
    callout.topArrowSkin = new Image( myTopTexture );
    
    return callout;
};
TextCallout.calloutFactory = skinnedTextCalloutFactory;
```

Another option is to pass a callout factory to `TextCallout.show()`. This allows you to create a specific callout differently than the default global `TextCallout.calloutFactory`.

``` code
function skinnedTextCalloutFactory():Callout
{
    var callout:TextCallout = new TextCallout();

    callout.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );
    callout.backgroundSkin = new Image( myBackgroundTexture );
    callout.topArrowSkin = new Image( myTopTexture );

    return callout;
};
Callout.show( text, origin, directions, isModal, skinnedTextCalloutFactory );
```

You should generally always skin the callouts with a factory or with a theme instead of passing the skins to the `TextCallout` instance returned by calling `TextCallout.show()`. If you skin an callout after `TextCallout.show()` is called, it may not be positioned or sized correctly.

## Related Links

-   [`feathers.controls.TextCallout` API Documentation](../api-reference/feathers/controls/TextCallout.html)
-   [How to use the Feathers `Callout` component](callout.html)