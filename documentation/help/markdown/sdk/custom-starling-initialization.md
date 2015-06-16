---
title: Customize the initialization of Starling in a Feathers MXML application  
author: Josh Tynjala

---
# Customize the initialization of Starling in a Feathers MXML application

When you create a new Feathers application in MXML, Starling is initialized automatically by the compiler, behind the scenes. The default settings will work well for most Feathers apps to support common requirements like stage and view port resizing, high DPI displays on desktop, and creating a theme. However, advanced developers may wish to customize some of these settings.

In your project's application, you can provide your own `[Frame]` metadata to use a custom class to initialize Starling:

``` xml
<f:Application xmlns:fx="http://ns.adobe.com/mxml/2009"
	xmlns:f="library://ns.feathersui.com/mxml">

	<fx:Metadata>
		[Frame(factoryClass="com.example.CustomBootstrap")]
	</fx:Metadata>
</f:Application>
```

A very simple startup class might look something like this:

``` code
package com.example
{
	import flash.display.Sprite;

	import starling.core.Starling;

	public class CustomBootstrap extends Sprite
	{
		public function CustomBootstrap()
		{
			this._starling = new Starling( MyApp, this.stage );
			this._starling.start();
		}

		private var _starling:Starling;
	}
}
```