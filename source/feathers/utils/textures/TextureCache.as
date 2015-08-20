/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.textures
{
	import starling.textures.Texture;

	/**
	 * Caches textures in memory. Each texture may be saved with its own key,
	 * such as the URL where the original image file is located.
	 */
	public class TextureCache
	{
		/**
		 * Constructor.
		 */
		public function TextureCache(maxCachedItems:int = int.MAX_VALUE)
		{
			this._maxCachedItems = maxCachedItems;
		}

		/**
		 * @private
		 */
		protected var _keys:Vector.<String> = new <String>[];
		
		/**
		 * @private
		 */
		protected var _textures:Vector.<Texture> = new <Texture>[];

		/**
		 * @private
		 */
		protected var _maxCachedItems:int;

		/**
		 * Limits the number of textures that may be stored in memory. If too
		 * many textures have been saved, the oldest textures will be disposed.
		 */
		public function get maxCachedItems():int
		{
			return this._maxCachedItems;
		}

		/**
		 * @private
		 */
		public function set maxCachedItems(value:int):void
		{
			if(this._maxCachedItems === value)
			{
				return;
			}
			this._maxCachedItems = value;
			if(this._keys.length > value)
			{
				this.trimCache();
			}
		}

		/**
		 * Disposes all cached textures.
		 */
		public function dispose():void
		{
			this._keys.length = 0;
			for each(var texture:Texture in this._textures)
			{
				texture.dispose();
			}
			this._textures.length = 0;
		}
		
		/**
		 * Gets the texture associated with the specified key. Returns
		 * <code>null</code> if no texture has been associated with the key.
		 *
		 * @see #setTexture()
		 */
		public function getTexture(key:String):Texture
		{
			var index:int = this._keys.indexOf(key);
			if(index < 0)
			{
				return null;
			}
			return this._textures[index];
		}

		/**
		 * Saves a texture using a specific key. Pass in <code>null</code> for
		 * the texture to remove it from the cache.
		 * 
		 * @see #getTexture()
		 */
		public function setTexture(key:String, texture:Texture):void
		{
			var index:int = this._keys.indexOf(key);
			if(index < 0)
			{
				index = this._keys.length;
				this._keys[index] = key;
				this._textures[index] = texture;
				if(index > this._maxCachedItems)
				{
					this.trimCache();
				}
			}
			else
			{
				this._textures[index] = texture;
			}
		}

		/**
		 * @private
		 */
		protected function trimCache():void
		{
			var currentCount:int = this._keys.length;
			var maxCount:int = this._maxCachedItems;
			while(currentCount > maxCount)
			{
				this._keys.shift();
				var texture:Texture = this._textures.shift();
				texture.dispose();
				currentCount--;
			}
		}
	}
}
