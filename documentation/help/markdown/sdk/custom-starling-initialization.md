---
title: Customize the initialization of Starling in a Feathers MXML application  
author: Josh Tynjala

---
# Customize the initialization of Starling in a Feathers MXML application

When you create a new Feathers application in MXML, Starling is initialized automatically by the compiler, behind the scenes. The default settings will work well for most Feathers apps to support common requirements — like stage and view port resizing, high DPI displays on desktop, and creating a theme. However, advanced developers may wish to customize some of these settings.

In your project's application, you can add `[Frame]` metadata to provide your own custom class that initializes Starling:

``` xml
<f:Application xmlns:fx="http://ns.adobe.com/mxml/2009"
	xmlns:f="library://ns.feathersui.com/mxml">

	<fx:Metadata>
		[Frame(factoryClass="com.example.CustomBootstrap")]
	</fx:Metadata>
</f:Application>
```

A simple startup class might look something like this:

``` actionscript
package com.example
{
	import flash.display.Sprite;

	import starling.core.Starling;

	public class CustomBootstrap extends Sprite
	{
		public function CustomBootstrap()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;

			// we need to instantiate the theme before the root is created,
			// so we pass null to the Starling constructor
			this._starling = new Starling( null, this.stage );

			// configure any other Starling properties here

			// let's wait for the Stage 3D context to be created
			this._starling.addEventListener( Event.CONTEXT3D_CREATE, starling_context3DCreateHandler );
		}

		private var _starling:Starling;

		private function starling_context3DCreateHandler( event:Event ):void
		{
			//this listener shouldn't be called again if context is lost
			this._starling.removeEventListener( Event.CONTEXT3D_CREATE, starling_context3DCreateHandler );

			// the context is ready, so the theme can create its textures
			new MetalWorksMobileTheme();

			// finally, pass Starling the root class and get things started!
			this._starling.rootClass = MyApp;
			this._starling.start();
		}
	}
}
```

You'll notice that we're manually instantiating the theme in our custom bootstrap class, rather than specifying it using the `theme` property in the main MXML application. Since we're replacing the default bootstrap code with our own, it becomes our responsibility to configure Starling and the theme.

<aside class="warn">The convenience properties available on the `Application` class, including `theme` and `context3DProfile`, will not work with a custom bootstrap class.</aside>

## Pre-loading Assets

One reason to use a custom bootstrap is to preload your assets before starting your app. Let's expand the previous example by loading some files using the Starling `AssetManager`:

``` actionscript
private var _assets:AssetManager;

private function starling_context3DCreateHandler( event:Event ):void
{
	// the context is ready, so the AssetManager can create textures
	this._assets = new AssetManager();
	this._assets.enqueue( "file1.png" );
	this._assets.enqueue( "file2.xml" );
	this._assets.loadQueue( assets_onProgress );
}
```

Similar to before, we wait until the Stage 3D context is ready. This time, we create the `AssetManager`, enqueue our assets, and start loading. We'll wait for the assets to load before we start Starling.

<aside class="info">At this point, we might consider displaying some kind of loading indicator on the native stage. A splash screen or a progress bar are both good options.</aside>

Next, let's implement the `assets_onProgress` function to track the loading progress of our assets:

``` actionscript
private function assets_onProgress( ratio:Number ):void
{
	if( ratio < 1 )
	{
		// you could update some kind of simple progress bar here
		return;
	}

	this._starling.rootClass = MyApp;
	this._starling.start();
}
```

Once the assets are fully loaded, we can start Starling. If the app has a theme, we can instantiate it immediately before setting the `rootClass`, just like before.

<aside class="info">Any asynchronous task can be added to a custom bootstrap class, and it's easy to defer the instantiation of the root MXML application until everything is ready.</aside>

## Related Links

-   [Starling Manual: Asset Management](http://wiki.starling-framework.org/manual/asset_management)
-   [The `rootClass` property API documentation](http://doc.starling-framework.org/current/starling/core/Starling.html#rootClass)