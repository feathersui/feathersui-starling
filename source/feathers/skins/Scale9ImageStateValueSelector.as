/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
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
			const textures:Scale9Textures = super.updateValue(target, state) as Scale9Textures;
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
				if(image.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._imageProperties[propertyName];
					image[propertyName] = propertyValue;
				}
			}

			return image;
		}
	}
}
