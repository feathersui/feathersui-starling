/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.themes
{
	import feathers.core.IFeathersControl;
	import feathers.skins.ConditionalStyleProvider;
	import feathers.skins.IStyleProvider;
	import feathers.skins.StyleNameFunctionStyleProvider;
	import feathers.skins.StyleProviderRegistry;

	import starling.core.Starling;
	import starling.events.EventDispatcher;

	/**
	 * Base class for themes that pass a <code>StyleNameFunctionStyleProvider</code>
	 * to each component class.
	 *
	 * @see feathers.skins.StyleNameFunctionStyleProvider
	 * @see ../../../help/skinning.html Skinning Feathers components
	 * @see ../../../help/custom-themes.html Creating custom Feathers themes
	 *
	 * @productversion Feathers 2.0.0
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
			if(this.starling === null)
			{
				this.starling = Starling.current;
			}
			this.createRegistry();
			this._conditionalRegistry = new StyleProviderRegistry(true, createConditionalStyleProvider);
		}

		/**
		 * The Starling instance associated with this theme.
		 */
		protected var starling:Starling;

		/**
		 * @private
		 */
		protected var _registry:StyleProviderRegistry;

		/**
		 * @private
		 */
		protected var _conditionalRegistry:StyleProviderRegistry;

		/**
		 * Disposes the theme.
		 */
		public function dispose():void
		{
			if(this._registry !== null)
			{
				this._registry.dispose();
				this._registry = null;
			}
			if(this._conditionalRegistry !== null)
			{
				this.disposeConditionalRegistry();
			}
		}

		/**
		 * Returns a <code>StyleNameFunctionStyleProvider</code> to be passed to
		 * the specified class.
		 */
		public function getStyleProviderForClass(type:Class):StyleNameFunctionStyleProvider
		{
			var existingGlobalStyleProvider:IStyleProvider = IStyleProvider(type[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME]);
			var conditional:ConditionalStyleProvider = ConditionalStyleProvider(this._conditionalRegistry.getStyleProvider(type));
			if(conditional.trueStyleProvider === null)
			{
				var styleProvider:StyleNameFunctionStyleProvider = StyleNameFunctionStyleProvider(this._registry.getStyleProvider(type));
				conditional.trueStyleProvider = styleProvider;
				conditional.falseStyleProvider = existingGlobalStyleProvider;
			}
			return StyleNameFunctionStyleProvider(conditional.trueStyleProvider);
		}

		/**
		 * @private
		 */
		protected function createRegistry():void
		{
			this._registry = new StyleProviderRegistry(false);
		}

		/**
		 * @private
		 */
		protected function starlingConditional(target:IFeathersControl):Boolean
		{
			var starling:Starling = target.stage !== null ? target.stage.starling : Starling.current;
			return starling === this.starling;
		}

		/**
		 * @private
		 */
		protected function createConditionalStyleProvider():ConditionalStyleProvider
		{
			return new ConditionalStyleProvider(starlingConditional);
		}

		/**
		 * @private
		 */
		protected function disposeConditionalRegistry():void
		{
			var classes:Vector.<Class> = this._conditionalRegistry.getRegisteredClasses();
			var classCount:int = classes.length;
			for(var i:int = 0; i < classCount; i++)
			{
				var forClass:Class = classes[i];
				var globalStyleProvider:IStyleProvider = IStyleProvider(forClass[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME]);
				var styleProviderInRegistry:ConditionalStyleProvider = ConditionalStyleProvider(this._conditionalRegistry.clearStyleProvider(forClass));

				var currentStyleProvider:ConditionalStyleProvider = globalStyleProvider as ConditionalStyleProvider;
				var previousStyleProvider:ConditionalStyleProvider = null;
				do
				{
					if(currentStyleProvider === null)
					{
						//worse case scenario is that we don't know how to
						//remove this style provider from the chain, so we leave
						//it in but always pass to the falseStyleProvider.
						styleProviderInRegistry.conditionalFunction = null;
						styleProviderInRegistry.trueStyleProvider = null;
						break;
					}
					var nextStyleProvider:IStyleProvider = currentStyleProvider.falseStyleProvider;
					if(currentStyleProvider === styleProviderInRegistry)
					{
						if(previousStyleProvider !== null)
						{
							previousStyleProvider.falseStyleProvider = nextStyleProvider;
						}
						else //currentStyleProvider === globalStyleProvider
						{
							forClass[GLOBAL_STYLE_PROVIDER_PROPERTY_NAME] = nextStyleProvider;
						}
						break;
					}
					previousStyleProvider = currentStyleProvider;
					currentStyleProvider = nextStyleProvider as ConditionalStyleProvider;
				}
				while(true)
			}
			this._conditionalRegistry = null;
		}
	}
}