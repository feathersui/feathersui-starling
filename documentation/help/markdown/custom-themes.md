---
title: Creating custom Feathers themes  
author: Josh Tynjala

---
# Creating custom Feathers themes

<aside class="warn">This document is incomplete. It will be updated for the final build of Feathers 2.1.</aside>

Many apps, including games, require heavy branding that involves styling every Feathers component with custom skins and fonts. In these cases, the example themes included with Feathers won't offer enough customization options to match the designer's vision. We will need a custom theme, built from scratch.

<aside class="info">If you haven't read [Skinning Feathers components](skinning.html) yet, start there first to learn about how to do basic skinning without themes. You'll get an introduction to style providers, which are the foundation of a theme's architecture.</aside>

## Creating a theme class

Let's create a new theme from scratch. We'll create a subclass of [`StyleNameFunctionTheme`](../api-reference/feathers/themes/StyleNameFunctionTheme.html):

``` code
package
{
	public class CustomTheme extends StyleNameFunctionTheme
	{
		public function CustomTheme()
		{
			super();
		}

		protected function initialize():void
		{

		}
	}
}
```

We've added a function named `initialize()`. We'll soon fill this function with calls to other functions that get different parts of the theme ready to use. However, before we can call `initialize()`, we need to decide how we're going to manage our assets like textures and fonts. We don't want to call this function until all assets are fully loaded.

## Managing assets

There are two ways to include assets with a theme. Each has its own advantages and disadvantages, and we'll need to pick which one works best for the specific app that we're building.

### Embedded assets

The simplest way to include assets to *embed* the assets at compile time. This approach lets us simply instantiate the classes when they are needed, and we don't need to wait for an event to indicate that they are ready. However, embedding files will increase the memory that our app requires at runtime. On mobile, memory can be limited, and this approach will restrict how many textures that we can keep in memory simultaneously. For a small set of assets, that may be a small price to pay for convenience. For multiple texture atlases, using up memory that we might need at runtime is often unacceptable.

Let's start by embedding a [texture atlas](http://wiki.starling-framework.org/manual/textures_and_images#texture_atlases) in our `CustomTheme` class:

``` code
[Embed(source="/../assets/images/atlas.png")]
private static const ATLAS_BITMAP:Class;

[Embed(source="/../assets/images/atlas.xml",mimeType="application/octet-stream")]
private static const ATLAS_XML:Class;
```

A texture atlas requires of two files, an image and an XML file. Let's add a member variable to our theme to hold the [`TextureAtlas`](http://doc.starling-framework.org/core/starling/textures/TextureAtlas.html) once it is created:

``` code
private var atlas:TextureAtlas;
```

Now, we'll add a function named `createTextureAtlas()` that will instantiate the `TextureAtlas` using our embedded assets:

``` code
private function createTextureAtlas():void
{
	var atlasTexture:Texture = Texture.fromEmbeddedAsset( ATLAS_BITMAP );
	var atlasXML:XML = XML( new ATLAS_XML() );
	this.atlas = new TextureAtlas( atlasTexture, atlasXML );
}
```

In the `CustomTheme` constructor, we'll call `createTextureAtlas()`, and then we can immediately call `initialize()`:

``` code
public function CustomTheme()
{
	super();
	this.createTextureAtlas();
	this.initialize();
}
```

If our theme requires other embedded assets, such as bitmap fonts or additional texture atlases, we simply need to instantiate these assets before we call `initialize()`.

### Loading assets at runtime

Another approach to including assets with a theme is to load them from external files at runtime. Starling's [`AssetManager`](http://doc.starling-framework.org/core/starling/utils/AssetManager.html) supports loading a set of multiple files at runtime, and it provides conveniences like automatically converting bitmaps to textures and registering bitmap fonts. Once everything is loaded, our assets will use less memory than if they were embedded, meaning that we can pack in more textures and things. Loading assets doesn't happen instantaneously, though, and we cannot initialize the theme until the `AssetManager` finishes loading our assets. Additionally, our app will need to wait before it can instantiate Feathers components.

Similar to the previous example that used embedded assets, we want to load a [texture atlas](http://wiki.starling-framework.org/manual/textures_and_images#texture_atlases) to be used by our `CustomTheme` class. We'll need two files for the texture atlas, we'll call them `atlas.png` and `atlas.xml`.

<aside class="info">When packaging an AIR application, we need to manually add each of the files that we want to include with our app to our project's settings. They will not be included automatically, even if we put them into the same folder as our source code. Every development environment provides a different UI for including files with an AIR application, so please refer to the appropriate IDE documentation for details.</aside>

Let's define a couple of member variables, one for the texture atlas, and one for the `AssetManager` that will load the required files:

``` code
private var atlas:TextureAtlas;
private var assets:AssetManager;
```

Now, we'll add a function named `loadAssets()` that will instantiate the `AssetManager` and enqueue the asset files:

``` code
private function loadAssets():void
{
	this.assets = new AssetManager();
	this.assets.enqueue( "atlas.png" );
	this.assets.enqueue( "atlas.xml" );
	this.assets.loadQueue( this.assets_onProgress );
}
```

At the end, we call `loadQueue()` on the `AssetManager` to load our assets. We need to pass a callback to this function so that we know when the assets finish loading. The callback accepts a single parameter, a variable with a value between `0.0` and `1.0`. Once this value is equal to `1.0`, our assets have fully loaded:

``` code
private function assets_onProgress( progress:Number ):void
{
	if( progress < 1.0 )
	{
		return;
	}
	this.atlas = this.assets.getTextureAtlas( "atlas" );
	this.initialize();
	this.dispatchEventWith( Event.COMPLETE );
}
```

If the assets aren't loaded, we simply return. Once the assets are ready, we can access the `TextureAtlas` from the `AssetManager`. We pass the name of the texture atlas to the [`getTextureAtlas()`](http://doc.starling-framework.org/core/starling/utils/AssetManager.html#getTextureAtlas()) function. The name of a texture atlas is the image's file name, without the extension. In this case, our file is named `atlas.png`, so we pass `"atlas"` to `getTextureAtlas()`.

Once we've set the `atlas` member variable, we can call `initialize()`. If our custom theme needed to load more assets, we'd want to get them all from the `AssetManager` before calling `initialize()`.

Finally, we want to inform the rest of our app that it can proceed, so we'll dispatch `Event.COMPLETE`. The app can listen for this event very easily:

``` code
this.theme = new CustomTheme();
this.theme.addEventListener( Event.COMPLETE, theme_completeHandler );
```

Once the listener is called, the app is free to start instantiating components, and the theme will style them automatically.

## Styling components

Once our assets are loaded, we can start setting up the code to style each component in our app.

``` code
private function setButtonStyles( button:Button ):void
{
	button.defaultSkin = new Scale9Image( this.atlas.getTexture( "button-up" ) );
	button.downSkin = new Scale9Image( this.atlas.getTexture( "button-down" ) );

	button.padding = 20;
	button.gap = 15;

	button.defaultLabelProperties.elementFormat = this.buttonElementFormat;
}
```

``` code
this.getStyleProviderForClass( Button ).defaultStyleProvider = this.setButtonStyles;
```

## Related Links

-   [Introduction to Feathers themes](themes.html)

-   [Extending Feathers example themes](extending-themes.html)

-   [Migrating legacy themes to Feathers 2.0](migrating-themes.html)