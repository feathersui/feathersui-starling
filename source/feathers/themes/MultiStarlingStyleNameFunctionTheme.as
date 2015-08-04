/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.themes
{
	import feathers.skins.AddOnFunctionStyleProvider;
	import feathers.skins.StyleNameFunctionStyleProvider;
	import feathers.skins.StyleProviderRegistry;

	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.errors.AbstractMethodError;

	/**
	 * Base class for themes that need to skin components in multiple instances
	 * of Starling. Intended for use in desktop apps with multiple native
	 * windows where each window has its own Starling instance.
	 * 
	 * @see ../../../help/skinning.html Skinning Feathers components
	 * @see ../../../help/custom-themes.html Creating custom Feathers themes
	 */
	public class MultiStarlingStyleNameFunctionTheme extends StyleNameFunctionTheme
	{
		/**
		 * Constructor.
		 */
		public function MultiStarlingStyleNameFunctionTheme()
		{
			super();
			this.addStarling(Starling.current);
		}

		/**
		 * @private
		 */
		protected var _lastStarling:Starling;

		/**
		 * @private
		 */
		protected var _starlings:Vector.<Starling> = new <Starling>[];

		/**
		 * @private
		 */
		protected var _starlingData:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		override public function getStyleProviderForClass(type:Class):StyleNameFunctionStyleProvider
		{
			var addOnStyleProvider:AddOnFunctionStyleProvider = AddOnFunctionStyleProvider(this._registry.getStyleProvider(type));
			//subclasses shouldn't need to know that we've wrapped the
			//StyleNameFunctionStyleProvider in an AddOnFunctionStyleProvider
			return StyleNameFunctionStyleProvider(addOnStyleProvider.originalStyleProvider);
		}

		/**
		 * Adds a Starling instance to the theme. Call when creating a new
		 * <code>NativeWindow</code> that has its own Starling instance.
		 */
		public function addStarling(starling:Starling):void
		{
			var index:int = this._starlings.indexOf(starling);
			if(index >= 0)
			{
				throw new ArgumentError("Cannot add a Starling instance to a theme more than once.");
			}
			this._starlings[this._starlings.length] = starling;
		}

		/**
		 * Removes a Starling instance from the theme. Call when closing a
		 * <code>NativeWindow</code> and its Starling instance.
		 */
		public function removeStarling(starling:Starling):void
		{
			var index:int = this._starlings.indexOf(starling);
			if(index < 0)
			{
				throw new ArgumentError("Cannot remove a Starling instance that has not been added.");
			}
			this._starlings.splice(index, 1);
			//clear any stored data associated with this starling instance
			this.setStarlingData(starling, null);
		}

		/**
		 * @private
		 */
		override protected function createRegistry():void
		{
			this._registry = new StyleProviderRegistry(true, this.styleProviderFactory);
		}

		/**
		 * Gets stored data associated with the specified Starling instance.
		 */
		protected function getStarlingData(starling:Starling):Object
		{
			return this._starlingData[starling];
		}

		/**
		 * Stores data associated with the specified Starling instance. To clear
		 * data, pass <code>null</code>.
		 */
		protected function setStarlingData(starling:Starling, data:Object):void
		{
			if(data === null)
			{
				delete this._starlingData[starling];
				return;
			}
			this._starlingData[starling] = data;
		}

		/**
		 * Subclasses must override this function to switch assets to the
		 * specified Starling instance.
		 */
		protected function changeStarling(starling:Starling, data:Object):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * @private
		 * This function ensures that the correct textures are loaded for the
		 * current Starling instance.
		 */
		protected function verifyCurrentStarling(target:DisplayObject):void
		{
			var stage:Stage = target.stage;
			if(!stage)
			{
				stage = Starling.current.stage;
			}
			if(this._lastStarling && stage == this._lastStarling.stage)
			{
				//the current Starling instance hasn't changed, so no need to
				//update anything.
				return;
			}
			for each(var starling:Starling in Starling.all)
			{
				if(starling.stage == stage)
				{
					if(this._starlings.indexOf(starling) < 0)
					{
						throw new IllegalOperationError("The Starling instance has not been added to the theme.");
					}
					this._lastStarling = starling;
					var data:Object = this.getStarlingData(starling);
					this.changeStarling(starling, data);
					return;
				}
			}
		}

		/**
		 * @private
		 */
		protected function styleProviderFactory():AddOnFunctionStyleProvider
		{
			var originalStyleProvider:StyleNameFunctionStyleProvider = new StyleNameFunctionStyleProvider();
			var addOnStyleProvider:AddOnFunctionStyleProvider = new AddOnFunctionStyleProvider(originalStyleProvider, this.verifyCurrentStarling);
			addOnStyleProvider.callBeforeOriginalStyleProvider = true;
			return addOnStyleProvider;
		}
	}
}
