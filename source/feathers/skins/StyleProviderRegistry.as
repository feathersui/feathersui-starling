/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import flash.utils.Dictionary;

	/**
	 * Used by themes to create and manage style providers for component classes.
	 */
	public class StyleProviderRegistry
	{
		/**
		 * @private
		 */
		protected static const GLOBAL_STYLE_PROVIDER_PROPERTY_NAME:String = "globalStyleProvider";

		/**
		 * @private
		 */
		protected static function defaultStyleProviderFactory():IStyleProvider
		{
			return new StyleNameFunctionStyleProvider();
		}

		/**
		 * Constructor.
		 *
		 * <p>If style providers are to be registered globally, they will be
		 * passed to the static <code>globalStyleProvider</code> property of the
		 * specified class. If the class does not define a
		 * <code>globalStyleProvider</code> property, an error will be thrown.</p>
		 *
		 * <p>The style provider factory function is expected to have the following
		 * signature:</p>
		 * <pre>function():IStyleProvider</pre>
		 *
		 * @param registerGlobally			Determines if the registry sets the static <code>globalStyleProvider</code> property.
		 * @param styleProviderFactory		An optional function that creates a new style provider. If <code>null</code>, a <code>StyleNameFunctionStyleProvider</code> will be created.
		 */
		public function StyleProviderRegistry(registerGlobally:Boolean = true, styleProviderFactory:Function = null)
		{
			this._registerGlobally = registerGlobally;
			if(styleProviderFactory === null)
			{
				this._styleProviderFactory = defaultStyleProviderFactory;
			}
			else
			{
				this._styleProviderFactory = styleProviderFactory;
			}

		}

		/**
		 * @private
		 */
		protected var _registerGlobally:Boolean;

		/**
		 * @private
		 */
		protected var _styleProviderFactory:Function;

		/**
		 * @private
		 */
		protected var _classToStyleProvider:Dictionary = new Dictionary(true);

		/**
		 * Disposes the theme.
		 */
		public function dispose():void
		{
			//clear the global style providers, but only if they still match the
			//ones that the theme created. a developer could replace the global
			//style providers with different ones.
			for(var untypedType:Object in this._classToStyleProvider)
			{
				var type:Class = Class(untypedType);
				this.clearStyleProvider(type);
			}
			this._classToStyleProvider = null;
		}

		/**
		 * Determines if an <code>IStyleProvider</code> for the specified
		 * component class has been created.
		 *
		 * @param forClass					The class that may have a style provider.
		 */
		public function hasStyleProvider(forClass:Class):Boolean
		{
			return forClass in this._classToStyleProvider;
		}

		/**
		 * Returns all classes that have been registered with a style provider.
		 */
		public function getRegisteredClasses(result:Vector.<Class> = null):Vector.<Class>
		{
			if(result !== null)
			{
				result.length = 0;
			}
			else
			{
				result = new <Class>[]; 
			}
			var index:int = 0;
			for(var forClass:Object in this._classToStyleProvider)
			{
				result[index] = forClass as Class;
				index++;
			}
			return result;
		}

		/**
		 * Creates an <code>IStyleProvider</code> for the specified component
		 * class, or if it was already created, returns the existing registered
		 * style provider. If the registry is global, a newly created style
		 * provider will be passed to the static <code>globalStyleProvider</code>
		 * property of the specified class.
		 *
		 * @param forClass					The style provider is registered for this class.
		 * @param styleProviderFactory		A factory used to create the style provider.
		 */
		public function getStyleProvider(forClass:Class):IStyleProvider
		{
			this.validateComponentClass(forClass);
			var styleProvider:IStyleProvider = IStyleProvider(this._classToStyleProvider[forClass]);
			if(!styleProvider)
			{
				styleProvider = this._styleProviderFactory();
				this._classToStyleProvider[forClass] = styleProvider;
				if(this._registerGlobally)
				{
					forClass[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME] = styleProvider;
				}
			}
			return styleProvider;
		}

		/**
		 * Removes the style provider for the specified component class. If the
		 * registry is global, and the static <code>globalStyleProvider</code>
		 * property contains the same value, it will be set to <code>null</code>.
		 * If it contains a different value, then it will be left unchanged to
		 * avoid conflicts with other registries or code.
		 *
		 * @param forClass		The style provider is registered for this class.
		 */
		public function clearStyleProvider(forClass:Class):IStyleProvider
		{
			this.validateComponentClass(forClass);
			if(forClass in this._classToStyleProvider)
			{
				var styleProvider:IStyleProvider = IStyleProvider(this._classToStyleProvider[forClass]);
				delete this._classToStyleProvider[forClass];
				if(this._registerGlobally &&
					forClass[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME] === styleProvider)
				{
					//something else may have changed the global style provider
					//after this registry set it, so we check if it's equal
					//before setting to null.
					forClass[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME] = null;
				}
				return styleProvider;
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function validateComponentClass(type:Class):void
		{
			if(!this._registerGlobally || Object(type).hasOwnProperty(GLOBAL_STYLE_PROVIDER_PROPERTY_NAME))
			{
				return;
			}
			throw ArgumentError("Class " + type + " must have a " + GLOBAL_STYLE_PROVIDER_PROPERTY_NAME + " static property to support themes.");
		}
	}
}
