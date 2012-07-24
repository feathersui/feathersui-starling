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
package org.josht.starling.foxhole.skins
{
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * Values for each state are Texture instances, and the manager attempts to
	 * reuse the existing Image instance that is passed in to getValueForState()
	 * as the old value by swapping the texture.
	 */
	public class ImageStateValueManager extends StateValueManager
	{
		/**
		 * Constructor.
		 */
		public function ImageStateValueManager()
		{
		}

		/**
		 * Optional properties to set on the Image instance.
		 */
		public var imageProperties:Object;

		/**
		 * @private
		 */
		override public function setValueForState(state:Object, value:Object):void
		{
			if(!(value is Texture))
			{
				throw new ArgumentError("Value for state must be a Texture instance.");
			}
			super.setValueForState(state, value);
		}

		/**
		 * @private
		 */
		override public function updateValue(target:Object, state:Object, oldValue:Object = null):Object
		{
			const texture:Texture = super.updateValue(target, state) as Texture;
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

			if(this.imageProperties)
			{
				for(var propertyName:String in this.imageProperties)
				{
					if(image.hasOwnProperty(propertyName))
					{
						var propertyValue:Object = this.imageProperties[propertyName];
						image[propertyName] = propertyValue;
					}
				}
			}

			return image;
		}
	}
}
