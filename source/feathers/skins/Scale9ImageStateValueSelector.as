/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	/**
	 * Values for each state are Scale9Textures instances, and the manager
	 * attempts to reuse the existing Scale9Image instance that is passed in to
	 * getValueForState() as the old value by swapping the textures.
	 */
	public class Scale9ImageStateValueSelector extends StateWithToggleValueSelector
	{
		/**
		 * Constructor.
		 */
		public function Scale9ImageStateValueSelector()
		{
		}

		/**
		 * @private
		 */
		protected var _imageProperties:Object;

		/**
		 * Optional properties to set on the Scale9Image instance.
		 *
		 * @see feathers.display.Scale9Image
		 */
		public function get imageProperties():Object
		{
			if(!this._imageProperties)
			{
				this._imageProperties = {};
			}
			return this._imageProperties;
		}

		/**
		 * @private
		 */
		public function set imageProperties(value:Object):void
		{
			this._imageProperties = value;
		}

		/**
		 * @private
		 */
		override public function setValueForState(value:Object, state:Object, isSelected:Boolean = false):void
		{
			if(!(value is Scale9Textures))
			{
				throw new ArgumentError("Value for state must be a Scale9Textures instance.");
			}
			super.setValueForState(value, state, isSelected);
		}

		/**
		 * @private
		 */
		override public function updateValue(target:Object, state:Object, oldValue:Object = null):Object
		{
			var textures:Scale9Textures = super.updateValue(target, state) as Scale9Textures;
			if(!textures)
			{
				return null;
			}

			if(oldValue is Scale9Image)
			{
				var image:Scale9Image = Scale9Image(oldValue);
				image.textures = textures;
				image.readjustSize();
			}
			else
			{
				image = new Scale9Image(textures);
			}

			for(var propertyName:String in this._imageProperties)
			{
				var propertyValue:Object = this._imageProperties[propertyName];
				image[propertyName] = propertyValue;
			}

			return image;
		}
	}
}
