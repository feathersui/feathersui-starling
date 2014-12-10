# Managing Assets in Feathers Themes

There are two primary approaches to managing assets (such as textures or bitmap fonts) in Feathers themes. You can embed assets in the SWF or you can load assets at runtime.

## Embedded Assets

The first approach packages everything up in one place by embedded the assets into the final SWF (or SWC) with the compiled code. The assets are preloaded and ready to instantiate and use as needed.

It's the easiest way for beginners to get started with the Feathers example themes. Just drop a SWC into your project, and instantiate the theme:

``` code
new MetalWorksMobileTheme();
```

However, this approach requires more memory. The Flash runtimes store the full running SWF in memory at all times. When an embedded asset is instantiated, the memory for that asset is duplicated from the SWF, essentially doubling the memory.

The example themes have small texture atlases, so this impact will be low, but more advanced custom themes may require a much larger amount of memory.

## Loading Assets at Runtime

The second approach keeps the assets separate from the code by using the Starling `AssetManager` to load assets at rutnime. The assets can be loaded from a URL, and in AIR, the assets can also be loaded from the file system. The memory usage is lower because the assets will only appear in memory once, unlike when they are embedded. However, setting up the theme to use an asset manager is a little more complicated.

First, you need to specify the location of the assets. In an AIR app, you need to include the asset files when packaging your app. `MetalWorksMobileThemeWithAssetManager` requires two files:

-   images/metalworks.xml

-   images/metalworks.png

In the following example, we tell the theme that the `images` folder (which contains the two files) are placed in `File.applicationDirectory`:

``` code
var theme:MetalWorksMobileThemeWithAssetManager =
    new MetalWorksMobileThemeWithAssetManager( File.applicationDirectory.url );
```

You don't necessarily need to add the assets directly to `File.applicationDirectory`. You might want to add them to a subdirectory instead. Flash Builder and other IDEs should allow you to specify the location of included files, and you can also specify the included files when packaging with the ADT command line tool.

Next, let's add a listener to the theme for `Event.COMPLETE`:

``` code
theme.addEventListener( Event.COMPLETE, theme_completeHandler );
```

This event will be dispatched when the asset manager has finished loading all of the assets, and the theme is ready to start skinning Feathers components. In other words, you should always wait until the theme dispatches this event before you start showing any of your app's user interface. Otherwise, the theme won't have textures and things ready to provide skins.

The listener for this event might look something like this:

``` code
private function theme_completeHandler( event:Event ):void
{
    // the theme is ready!
 
    this.button = new Button();
    this.button.label = "Click Me";
    this.addChild( button );
}
```

Other themes will require their own set of files. The main thing to keep in mind is that you need to point to what the theme considers the root directory of its assets. In the case of `MetalWorksMobileThemeWithAssetManager`, that isn't actually the `images` directory, but its parent directory instead.
In future versions of Feathers, this theme might require additional assets that are in a directory next to the `images` directory, so we want to keep it flexible. As an example, `MinimalMobileThemeWithAssetManager` requires these files:

-   images/minimal.xml

-   images/minimal.png

-   fonts/pf\_ronda\_seven.fnt

As you can see, the bitmap font file that `MinimalMobileThemeWithAssetManager` uses is in a separate directory from the image files. The parent directory of `images` and `fonts` is the real “root” directory for this theme's files.

### Loading assets with a custom asset manager

By default, the theme will create its own `AssetManager`. If you would like to load extra assets that the theme isn't aware of, you may optionally pass in your own asset manager to the example theme's constructor:

``` code
var assets:AssetManager = new AssetManager();
assets.enqueue( File.applicationDirectory.resolvePath( "./images/custom-asset.png" ) );
 
var theme:MetalWorksMobileThemeWithAssetManager =
    new MetalWorksMobileThemeWithAssetManager( File.applicationDirectory.url, assets );
 
theme.addEventListener( Event.COMPLETE, theme_completeHandler );
```

Add all of extra assets that you need before passing the asset manager to the theme.

Never call the `loadQueue()` function on the `AssetManager` that you pass to a theme. The theme must call it for you because the asset manager does not dispatch any kind of complete event that the theme can listen to, and the theme needs to know when its assets are ready. If you need to know when the assets are fully loaded, listen for `Event.COMPLETE` on the theme.

## Related Links

-   [Introduction to Feathers Themes](themes.html)

-   [Starling Framework: Asset Management](/manual/asset_management)

For more tutorials, return to the [Feathers Documentation](index.html).


