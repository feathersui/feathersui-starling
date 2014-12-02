/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.themes
{
	import feathers.skins.StyleNameFunctionStyleProvider;
	import feathers.skins.StyleProviderRegistry;

	import starling.events.EventDispatcher;

	/**
	 * Base class for themes that pass a <code>StyleNameFunctionStyleProvider</code>
	 * to each component class.
	 *
	 * @see feathers.skins.StyleNameFunctionStyleProvider
	 * @see http://wiki.starling-framework.org/feathers/skinning Skinning Feathers Components
	 * @see http://wiki.starling-framework.org/feathers/extending-themes Extending Feathers Themes
	 */
	public class StyleNameFunctionTheme extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function StyleNameFunctionTheme()
		{
			this._registry = new StyleProviderRegistry();
		}

		/**
		 * @private
		 */
		protected var _registry:StyleProviderRegistry;

		/**
		 * Disposes the theme.
		 */
		public function dispose():void
		{
			if(this._registry)
			{
				this._registry.dispose();
				this._registry = null;
			}
		}

		/**
		 * Returns a <code>StyleNameFunctionStyleProvider</code> to be passed to
		 * the specified class.
		 */
		public function getStyleProviderForClass(type:Class):StyleNameFunctionStyleProvider
		{
			return StyleNameFunctionStyleProvider(this._registry.getStyleProvider(type));
		}
	}
}
