/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * Values for each state are Texture instances, and the manager attempts to
	 * reuse the existing Image instance that is passed in to getValueForState()
	 * as the old value by swapping the texture.
	 */
	public class ImageStateValueSelector extends StateWithToggleValueSelector
	{
		/**
		 * Constructor.
		 */
		public function ImageStateValueSelector()
		{
		}

		/**
		 * @private
		 */
		protected var _imageProperties:Object;

		/**
		 * Optional properties to set on the Image instance.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/Image.html starling.display.Image
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
			if(!(value is Texture))
			{
				throw new ArgumentError("Value for state must be a Texture instance.");
			}
			super.setValueForState(value, state, isSelected);
		}

		/**
		 * @private
		 */
		override public function updateValue(target:Object, state:Object, oldValue:Object = null):Object
		{
			var texture:Texture = super.updateValue(target, state) as Texture;
			if(!texture)
			{
				return null;
			}

			if(oldValue is Image)
			{
				var image:Image = Image(oldValue);
				image.texture = texture;
				image.readjustSize();
			}
			else
			{
				image = new Image(texture);
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
