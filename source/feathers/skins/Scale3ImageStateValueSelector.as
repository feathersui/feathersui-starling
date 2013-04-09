package feathers.skins
{
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;

	/**
	 * Values for each state are Scale3Textures instances, and the manager
	 * attempts to reuse the existing Scale3Image instance that is passed in to
	 * getValueForState() as the old value by swapping the textures.
	 */
	public class Scale3ImageStateValueSelector extends StateWithToggleValueSelector
	{
		/**
		 * Constructor.
		 */
		public function Scale3ImageStateValueSelector()
		{
		}

		/**
		 * @private
		 */
		protected var _imageProperties:Object;

		/**
		 * Optional properties to set on the Scale3Image instance.
		 *
		 * @see feathers.display.Scale3Image
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
			if(!(value is Scale3Textures))
			{
				throw new ArgumentError("Value for state must be a Scale3Textures instance.");
			}
			super.setValueForState(value, state, isSelected);
		}

		/**
		 * @private
		 */
		override public function updateValue(target:Object, state:Object, oldValue:Object = null):Object
		{
			const textures:Scale3Textures = super.updateValue(target, state) as Scale3Textures;
			if(!textures)
			{
				return null;
			}

			if(oldValue is Scale3Image)
			{
				var image:Scale3Image = Scale3Image(oldValue);
				image.textures = textures;
				image.readjustSize();
			}
			else
			{
				image = new Scale3Image(textures);
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
