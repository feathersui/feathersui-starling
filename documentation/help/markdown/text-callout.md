---
title: How to use the Feathers TextCallout component  
author: Josh Tynjala

---
# How to use the Feathers `TextCallout` component

The [`TextCallout`](../api-reference/feathers/controls/TextCallout.html) class is a special type of [callout](callout.html) that simply renders a string as its content.

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

Callouts have a number of skin and style properties to let you customize their appearance. For full details about what skin and style properties are available, see the [`TextCallout` API reference](../api-reference/feathers/controls/TextCallout.html). 

As mentioned above, `TextCallout` is a subclass of `Callout`. For more detailed information about the skinning options available to `TextCallout`, see [How to use the Feathers `Callout` component](callout.html).

### Targeting a `TextCallout` in a theme

If you are creating a [theme](themes.html), you can specify a function for the default styles like this:

``` code
getStyleProviderForClass( TextCallout ).defaultStyleFunction = setTextCalloutStyles;
```

If you want to customize a specific callout to look different than the default, you may use a custom style name to call a different function:

``` code
callout.styleNameList.add( "custom-text-callout" );
```

You can specify the function for the custom style name like this:

``` code
getStyleProviderForClass( TextCallout )
    .setFunctionForStyleName( "custom-text-callout", setCustomTextCalloutStyles );
```

Trying to change the callout's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the callout was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the callout's properties directly.

### Skinning a `TextCallout` without a theme

If you're not using a theme, you can specify a factory to create the callout, including setting skins, in a couple of different ways. The first is to set the [`TextCallout.calloutFactory`](../api-reference/feathers/controls/TextCallout.html#calloutFactory) static property to a function that provides skins for the callout. This factory will be called any time that [`TextCallout.show()`](../api-reference/feathers/controls/TextCallout.html#show()) is used to create a callout.

``` code
function skinnedTextCalloutFactory():TextCallout
{
    var callout:TextCallout = new TextCallout();
    callout.textRendererFactory = function():ITextRenderer
    {
        var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
        // set font styles here...
        return textRenderer;
    }
    callout.backgroundSkin = new Image( myBackgroundTexture );
    callout.topArrowSkin = new Image( myTopTexture );
    // etc...
    return callout;
};
TextCallout.calloutFactory = skinnedTextCalloutFactory;
```

Another option is to pass a callout factory to `TextCallout.show()`. This allows you to create a specific callout differently than the default global `TextCallout.calloutFactory`.

``` code
function skinnedTextCalloutFactory():Callout
{
    var callout:TextCallout = new TextCallout();
    callout.textRendererFactory = function():ITextRenderer
    {
        var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
        // set font styles here...
        return textRenderer;
    }
    callout.backgroundSkin = new Image( myBackgroundTexture );
    callout.topArrowSkin = new Image( myTopTexture );
    // etc...
    return callout;
};
Callout.show( text, origin, directions, isModal, skinnedTextCalloutFactory );
```

You should generally always skin the callouts with a factory or with a theme instead of passing the skins to the `TextCallout` instance returned by calling `TextCallout.show()`. If you skin an callout after `TextCallout.show()` is called, it may not be positioned or sized correctly.

### Skinning the text renderer

This section explains how to access the text renderer sub-component to set font styles.

<aside class="info">In the example code below, we'll display the callout's text using [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html), which draws text using [Flash Text Engine](http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html). Different text renderers may not use the same properties names to customize their font styles. Please read [Introduction to Feathers text renderers](text-renderers.html) for more information about the different text renderers that Feathers supports, and how to use each of them.</aside>

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`TextCallout.DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER`](../api-reference/feathers/controls/TextCallout.html#DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER) style name.

``` code
getStyleProviderForClass( TextBlockTextRenderer )
    .setFunctionForStyleName( TextCallout.DEFAULT_CHILD_STYLE_NAME_TEXT_RENDERER, setTextCalloutTextRendererStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
slider.customTextRendererStyleName = "custom-text-callout-text-renderer";
```

You can set the function for the [`customTextRendererStyleName`](../api-reference/feathers/controls/TextCallout.html#customTextRendererStyleName) like this:

``` code
getStyleProviderForClass( TextBlockTextRenderer )
    .setFunctionForStyleName( "custom-text-callout-text-renderer", setTextCalloutCustomTextRendererStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`textRendererFactory`](../api-reference/feathers/controls/TextCallout.html#textRendererFactory) to provide skins for the callout's text renderer:

``` code
callout.textRendererFactory = function():ITextRenderer
{
    var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
    var font:FontDescription = new FontDescription( "_sans" );
    textRenderer.elementFormat = new ElementFormat( font, 20, 0x444444 );
    return textRenderer;
}
```

## Related Links

-   [`feathers.controls.TextCallout` API Documentation](../api-reference/feathers/controls/TextCallout.html)
-   [How to use the Feathers `Callout` component](callout.html)