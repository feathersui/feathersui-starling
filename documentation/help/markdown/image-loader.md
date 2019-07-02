---
title: How to use the Feathers Image Loader component  
author: Josh Tynjala

---
# How to use the Feathers `ImageLoader` component

The [`ImageLoader`](../api-reference/feathers/controls/ImageLoader.html) class wraps [`starling.display.Image`](http://doc.starling-framework.org/core/starling/display/Image.html) inside a Feathers component to add additional features. For instance, you can easily load an image from a URL and automatically convert it to a texture that is fully managed by the `ImageLoader`. The texture will be disposed when the `ImageLoader` is disposed. A number of other useful properties have been added to `ImageLoader`. See below for more details.

## The Basics

First, let's create an `ImageLoader` control, pass in a texture to display, and add it to the display list:

``` actionscript
var loader:ImageLoader = new ImageLoader();
loader.source = texture;
this.addChild( loader );
```

Alternatively, you can pass a URL to the [`source`](../api-reference/feathers/controls/ImageLoader.html#source) property to load an external image:

``` actionscript
loader.source = "http://www.example.com/image.png";
```

The URL may point to any image file that may be loaded by [`flash.display.Loader`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Loader.html) to create a [`flash.display.BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) object. The loaded image will be converted to a [`starling.textures.Texture`](http://doc.starling-framework.org/core/starling/textures/Texture.html).

<aside class="warn">At this time, ATF files cannot be loaded by `ImageLoader` using a URL.</aside>

### Events

You can listen for [`Event.COMPLETE`](../api-reference/feathers/controls/ImageLoader.html#event:complete) to know when the image is fully loaded:

``` actionscript
loader.addEventListener( Event.COMPLETE, loader_completeHandler );
```

The listener might look like this:

``` actionscript
function loader_completeHandler( event:Event ):void
{
    // image loaded and texture ready
}
```

You can also listen for errors to know if the `ImageLoader` is unable to load the texture:

``` actionscript
loader.addEventListener( Event.IO_ERROR, loader_ioErrorHandler );
```

The listener for [`Event.IO_ERROR`](../api-reference/feathers/controls/ImageLoader.html#event:ioError) might look like this:

``` actionscript
function loader_ioErrorHandler( event:Event, data:IOErrorEvent ):void
{
    // loader error
}
```

The `data` parameter in the function signature is optional, as always. It is a [`flash.events.IOErrorEvent`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/IOErrorEvent.html) that is dispatched by the internal [`flash.display.Loader`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Loader.html) used internally by the `ImageLoader`.

Similarly, you may listen for [`Event.SECURITY_ERROR`](../api-reference/feathers/controls/ImageLoader.html#event:securityError). The `data` property of the event is a [`flash.events.SecurityErrorEvent`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/SecurityErrorEvent.html) dispatched by the internal `Loader`.

### Caching Textures

By default, the `ImageLoader` will always create a new texture every time that it loads a source from a URL. In components like [`List`](list.html), [`Tree`](tree.html), and [`GroupedList`](grouped-list.html), it's common for the same URL to be loaded multiple times by one or more `ImageLoader` components. This can use extra bandwidth and affect performance.

If enough memory is available, it's possible to store the loaded textures without disposing them. An instance of the [`feathers.utils.textures.TextureCache`](../api-reference/feathers/utils/textures/TextureCache.html) class can be shared by multiple `ImageLoader` components, and if a URL has already been loaded, the texture will be taken from the cache instead of reloading the image file and creating a new texture.

To use, simply pass the same `TextureCache` instance to the [`textureCache`]() property of multiple `ImageLoader` components:

``` actionscript
var cache:TextureCache = new TextureCache( 30 );

var loader1:ImageLoader = new ImageLoader();
loader1.textureCache = cache;

var loader2:ImageLoader = new ImageLoader();
loader2.textureCache = cache;
```

The parameter passed to the `TextureCache` constructor specifies how many textures should be stored in the cache. This limit affects only textures that are not currently displayed by any `ImageLoader` using the cache. The parameter defaults to `int.MAX_VALUE`, but a smaller value is recommended to avoid using too much memory and crashing your application. In this case, we've chosen `30`.

For a `List`, we might use a `TextureCache` for icons or accessories that are loaded from URLs:

``` actionscript
var cache:TextureCache = new TextureCache( 15 );
list.itemRendererFactory = function():IListItemRenderer
{
	var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
	itemRenderer.iconLoaderFactory = function():ImageLoader
	{
		var loader:ImageLoader = new ImageLoader();
		loader.textureCache = cache;
		return loader;
	};
	return itemRenderer;
};
```

The [`dispose()`](../api-reference/feathers/utils/textures/TextureCache.html#dispose()) method of the `TextureCache` should be called when the `List` or other component using the cache is disposed. The `TextureCache` does not automatically know when it should dispose its stored textures, much like how a `starling.display.Image` will never dispose its own `texture` property because the texture may still be needed elsewhere.

<aside class="warn">Failing to dispose a `TextureCache` will cause a pretty serious memory leak because the cache may have stored a large number of textures. Don't forget!</aside>

In the following example, let's assume that we stored a `TextureCache` instance in a `savedTextures` member variable in one of our screens:

``` actionscript
override public function dispose():void
{
	if( this.savedTextures )
	{
		this.savedTextures.dispose();
		this.savedTextures = null;
	}
	super.dispose();
}
```

When the screen is disposed, we'll simply dispose the `TextureCache`.

### Other Properties

You can snap the position of an `ImageLoader` to the nearest whole pixel using the [`pixelSnapping`](../api-reference/feathers/controls/ImageLoader.html#pixelSnapping) property:

``` actionscript
loader.pixelSnapping = true;
```

Pixel snapping is most useful for icons where crisp edges are especially important.

When images are loaded in a component like a [`List`](list.html), it's often more desirable to avoid creating new textures on the GPU while the list is scrolling. Since texture uploads are expensive, this keeps the list feeling smooth and responsive.

``` actionscript
loader.delayTextureCreation = true;
```

Set the [`delayTextureCreation`](../api-reference/feathers/controls/ImageLoader.html#delayTextureCreation) property to `true` when the container starts scrolling and set it back to `false` after scrolling finishes. While this property is `true`, the image may load from a URL, but the [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) will be kept in memory without being converted to a texture on the GPU. Once the property is set back to `false`, the texture will be created immediately.

If desired, we can set the [`textureQueueDuration`](../api-reference/feathers/controls/ImageLoader.html#textureQueueDuration) property to a specific number of seconds. When `delayTextureCreation` is `true`, the loaded image will be converted to a `Texture` after a short delay instead of waiting for `delayTextureCreation` to be set back to `false`.

When you resize a regular [`starling.display.Image`](http://doc.starling-framework.org/core/starling/display/Image.html), it may distort. `ImageLoader` allows you control whether the image maintains its aspect ratio within the dimensions of the `ImageLoader`:

``` actionscript
loader.maintainAspectRatio = true;
```

When the [`maintainAspectRatio`](../api-reference/feathers/controls/ImageLoader.html#maintainAspectRatio) property is `true`, the image may be letter-boxed inside the `ImageLoader`, adding transparent edges on the top and bottom or on the left and right.

You can use the [`isLoaded`](../api-reference/feathers/controls/ImageLoader.html#isLoaded) getter to know if a texture is fully loaded (in addition to listening for [`Event.COMPLETE`](../api-reference/feathers/controls/ImageLoader.html#event:complete), mentioned above):

``` actionscript
if( loader.isLoaded )
{
    // ready
}
else
{
    // not loaded
}
```

You may set the scale factor of the loaded texture:

``` actionscript
loader.scaleFactor = 0.5;
```

Using this value, the texture will be scaled to an appropriate size for Starling's current `contentScaleFactor`.

Finally, just like `starling.display.Image`, `ImageLoader` allows you to customize the [`color`](../api-reference/feathers/controls/ImageLoader.html#color) and [`smoothing`](../api-reference/feathers/controls/ImageLoader.html#smoothing) properties:

``` actionscript
loader.color = 0xff0000;
loader.smoothing = TextureSmoothing.NONE;
```

## Related Links

-   [`feathers.controls.ImageLoader` API Documentation](../api-reference/feathers/controls/ImageLoader.html)