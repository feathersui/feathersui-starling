/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.themes
{
	import feathers.skins.IStyleProvider;
	import feathers.skins.StyleNameFunctionStyleProvider;

	import flash.errors.IllegalOperationError;

	import flash.utils.Dictionary;

	import starling.events.EventDispatcher;

	/**
	 * Base class for themes that pass a <code>StyleNameFunctionStyleProvider</code>
	 * to each component class.
	 *
	 * @see feathers.skins.StyleNameFunctionStyleProvider
	 */
	public class StyleNameFunctionTheme extends EventDispatcher
	{
		/**
		 * @private
		 */
		protected static const GLOBAL_STYLE_PROVIDER_PROPERTY_NAME:String = "globalStyleProvider";

		/**
		 * Constructor.
		 */
		public function StyleNameFunctionTheme()
		{
		}

		/**
		 * @private
		 */
		protected var _classToStyleProvider:Dictionary = new Dictionary(true);

		/**
		 * Returns a <code>StyleNameFunctionStyleProvider</code> to be passed to
		 * the specified class.
		 */
		protected function getStyleProviderForClass(type:Class):StyleNameFunctionStyleProvider
		{
			if(!Object(type).hasOwnProperty(GLOBAL_STYLE_PROVIDER_PROPERTY_NAME))
			{
				throw ArgumentError("Class " + type + " does not have a " + GLOBAL_STYLE_PROVIDER_PROPERTY_NAME + " static property.");
			}
			var styleProvider:StyleNameFunctionStyleProvider = StyleNameFunctionStyleProvider(this._classToStyleProvider[type]);
			if(!styleProvider)
			{
				styleProvider = new StyleNameFunctionStyleProvider();
				this._classToStyleProvider[type] = styleProvider;
				type[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME] = styleProvider;
			}
			return styleProvider;
		}
	}
}
