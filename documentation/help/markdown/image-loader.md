---
title: How to use the Feathers Image Loader component  
author: Josh Tynjala

---
# How to use the Feathers ImageLoader component

The `ImageLoader` class wraps `starling.display.Image` inside a Feathers component to add additional features. For instance, you can easily load an image from a URL and automatically convert it to a texture that is fully managed by the `ImageLoader`. The texture will be disposed when the `ImageLoader` is disposed. A number of other useful properties have been added to `ImageLoader`. See below for more details.

## The Basics

Let's create an `ImageLoader` and pass in a texture:

``` code
var loader:ImageLoader = new ImageLoader();
loader.source = texture;
this.addChild( loader );
```

Alternatively, you can pass a URL to the `source` property to load an external image:

``` code
loader.source = "http://www.example.com/image.png";
```

The URL may point to any image file that may be loaded by `flash.display.Loader` and converted to a `starling.display.Texture`. At this time, ATF files cannot be loaded by `ImageLoader` using a URL.

### Events

You can listen for an event to know when the image is fully loaded:

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

The listener for `FeathersEventType.ERROR` might look like this:

``` code
function loader_errorHandler( event:Event, data:ErrorEvent ):void
{
    // loader error
}
```

The `data` argument is optional, as always. It is a `flash.events.ErrorEvent` that is dispatched by the internal `flash.display.Loader` used by the `ImageLoader`. It may be of type `IOErrorEvent.IO_ERROR` or of type `SecurityErrorEvent.SECURITY_ERROR`.

### Other Properties

You can snap the position of an `ImageLoader` to the nearest whole pixel:

``` code
loader.snapToPixels = true;
```

Pixel snapping is most useful for icons where crisp edges are especially important.

When images are loaded in a scrolling container, such as a `List`, it may be desirable to avoid creating a new texture on the GPU until the scrolling stops to improve performance.

``` code
loader.delayTextureCreation = true;
```

Set the `delayTextureCreation` property to `true` when the container starts scrolling and set it back to `false` after scrolling finishes. While this property is `true`, the image may load, but the `BitmapData` will be kept in memory until the property is set back to `false`. Then, the Starling texture will be created.

When you resize a regular `starling.display.Image`, it distorts. `ImageLoader` allows you control whether the image maintains its aspect ratio within the dimensions of the `ImageLoader`:

``` code
loader.maintainAspectRatio = true;
```

When aspect ratio is maintained, the image may be letter-boxed inside the `ImageLoader`, adding transparent edges on the top and bottom or on the left and right.

You can use the `isLoaded` getter to know if a texture is fully loaded (in addition to listening to Event.COMPLETE, mentioned above):

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

You can scale the texture to match the *dpi scale* of the Feathers theme:

``` code
loader.textureScale = 0.5;
```

This value is mainly used when the `ImageLoader` needs to resize after loading a new `source`. The original width and height of the loaded texture are multiplied by the `textureScale` and that's the width and height of the `ImageLoader`.

Finally, just like `starling.display.Image`, `ImageLoader` allows you to customize the color and smoothing:

``` code
loader.color = 0xff0000;
loader.smoothing = TextureSmoothing.NONE;
```

## Related Links

-   [ImageLoader API Documentation](http://feathersui.com/documentation/feathers/controls/ImageLoader.html)

For more tutorials, return to the [Feathers Documentation](index.html).


