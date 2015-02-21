---
title: How to use the Feathers Image Loader component  
author: Josh Tynjala

---
# How to use the Feathers `ImageLoader` component

The [`ImageLoader`](../api-reference/feathers/controls/ImageLoader.html) class wraps [`starling.display.Image`](http://doc.starling-framework.org/core/starling/display/Image.html) inside a Feathers component to add additional features. For instance, you can easily load an image from a URL and automatically convert it to a texture that is fully managed by the `ImageLoader`. The texture will be disposed when the `ImageLoader` is disposed. A number of other useful properties have been added to `ImageLoader`. See below for more details.

## The Basics

First, let's create an `ImageLoader` control, pass in a texture to display, and add it to the display list:

``` code
var loader:ImageLoader = new ImageLoader();
loader.source = texture;
this.addChild( loader );
```

Alternatively, you can pass a URL to the [`source`](../api-reference/feathers/controls/ImageLoader.html#source) property to load an external image:

``` code
loader.source = "http://www.example.com/image.png";
```

The URL may point to any image file that may be loaded by [`flash.display.Loader`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Loader.html) to create a [`flash.display.BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) object. The loaded image will be converted to a [`starling.textures.Texture`](http://doc.starling-framework.org/core/starling/textures/Texture.html).

<aside class="warn">At this time, ATF files cannot be loaded by `ImageLoader` using a URL.</aside>

### Events

You can listen for [`Event.COMPLETE`](../api-reference/feathers/controls/ImageLoader.html#event:complete) to know when the image is fully loaded:

``` code
loader.addEventListener( Event.COMPLETE, loader_completeHandler );
```

The listener might look like this:

``` code
function loader_completeHandler( event:Event ):void
{
    // image loaded and texture ready
}
```

You can also listen for errors to know if the `ImageLoader` is unable to load the texture:

``` code
loader.addEventListener( FeathersEventType.ERROR, loader_errorHandler );
```

The listener for [`FeathersEventType.ERROR`](../api-reference/feathers/events/FeathersEventType.html#ERROR) might look like this:

``` code
function loader_errorHandler( event:Event, data:ErrorEvent ):void
{
    // loader error
}
```

The `data` parameter in the function signature is optional, as always. It is a [`flash.events.ErrorEvent`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/ErrorEvent.html) that is dispatched by the internal [`flash.display.Loader`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Loader.html) used internally by the `ImageLoader`. It may be of type [`IOErrorEvent.IO_ERROR`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/IOErrorEvent.html#IO_ERROR) or of type [`SecurityErrorEvent.SECURITY_ERROR`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/SecurityErrorEvent.html#SECURITY_ERROR).

### Other Properties

You can snap the position of an `ImageLoader` to the nearest whole pixel using the [`snapToPixels`](../api-reference/feathers/controls/ImageLoader.html#snapToPixels) property:

``` code
loader.snapToPixels = true;
```

Pixel snapping is most useful for icons where crisp edges are especially important.

When images are loaded in a component like a [`List`](list.html), it's often more desirable to avoid creating new textures on the GPU while the list is scrolling. Since texture uploads are expensive, this keeps the list feeling smooth and responsive.

``` code
loader.delayTextureCreation = true;
```

Set the [`delayTextureCreation`](../api-reference/feathers/controls/ImageLoader.html#delayTextureCreation) property to `true` when the container starts scrolling and set it back to `false` after scrolling finishes. While this property is `true`, the image may load from a URL, but the [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) will be kept in memory without being converted to a texture on the GPU. Once the property is set back to `false`, the texture will be created immediately.

If desired, we can set the [`textureQueueDuration`](../api-reference/feathers/controls/ImageLoader.html#textureQueueDuration) property to a specific number of seconds. When `delayTextureCreation` is `true`, the loaded image will be converted to a `Texture` after a short delay instead of waiting for `delayTextureCreation` to be set back to `false`.

When you resize a regular [`starling.display.Image`](http://doc.starling-framework.org/core/starling/display/Image.html), it may distort. `ImageLoader` allows you control whether the image maintains its aspect ratio within the dimensions of the `ImageLoader`:

``` code
loader.maintainAspectRatio = true;
```

When the [`maintainAspectRatio`](../api-reference/feathers/controls/ImageLoader.html#maintainAspectRatio) property is `true`, the image may be letter-boxed inside the `ImageLoader`, adding transparent edges on the top and bottom or on the left and right.

You can use the [`isLoaded`](../api-reference/feathers/controls/ImageLoader.html#isLoaded) getter to know if a texture is fully loaded (in addition to listening for [`Event.COMPLETE`](../api-reference/feathers/controls/ImageLoader.html#event:complete), mentioned above):

``` code
if( loader.isLoaded )
{
    // ready
}
else
{
    // not loaded
}
```

You can scale the original dimensions of the loaded texture:

``` code
loader.textureScale = 0.5;
```

This value is mainly used when the `ImageLoader` needs to resize after loading a new [`source`](../api-reference/feathers/controls/ImageLoader.html#source). The original width and height of the loaded texture are multiplied by the [`textureScale`](../api-reference/feathers/controls/ImageLoader.html#textureScale) and that's the width and height of the `ImageLoader`.

Finally, just like `starling.display.Image`, `ImageLoader` allows you to customize the [`color`](../api-reference/feathers/controls/ImageLoader.html#color) and [`smoothing`](../api-reference/feathers/controls/ImageLoader.html#smoothing) properties:

``` code
loader.color = 0xff0000;
loader.smoothing = TextureSmoothing.NONE;
```

## Related Links

-   [`feathers.controls.ImageLoader` API Documentation](../api-reference/feathers/controls/ImageLoader.html)