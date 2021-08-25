/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.textures
{
	import flash.errors.IllegalOperationError;

	import starling.textures.Texture;

	/**
	 * Caches textures in memory. Each texture may be saved with its own key,
	 * such as the URL where the original image file is located.
	 * 
	 * <p><strong>Note:</strong> Most developers will only need to create a
	 * <code>TextureCache</code>, pass it to multiple <code>ImageLoader</code>
	 * components, and dispose the cache when finished. APIs to retain and
	 * release textures are meant to be used by <code>ImageLoader</code>.</p>
	 * 
	 * <p>A single <code>TextureCache</code> may be passed to multiple
	 * <code>ImageLoader</code> components using the <code>textureCache</code>
	 * property:</p>
	 * 
	 * <listing version="3.0">
	 * var cache:TextureCache = new TextureCache();
	 * loader1.textureCache = cache;
	 * loader2.textureCache = cache;</listing>
	 *
	 * <p>Don't forget to dispose the <code>TextureCache</code> when it is no
	 * longer needed -- to avoid memory leaks:</p>
	 *
	 * <listing version="3.0">
	 * cache.dispose();</listing>
	 * 
	 * <p>To use a TextureCache in a <code>List</code> or
	 * <code>GroupedList</code> with the default item renderer, pass the cache
	 * to the <code>ImageLoader</code> components using the
	 * <code>iconLoaderFactory</code> or
	 * <code>accessoryLoaderFactory</code>:</p>
	 * 
	 * <listing version="3.0">
	 * var cache:TextureCache = new TextureCache();
	 * list.itemRendererFactory = function():IListItemRenderer
	 * {
	 *     var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
	 *     itemRenderer.iconLoaderFactory = function():ImageLoader
	 *     {
	 *         var loader:ImageLoader = new ImageLoader();
	 *         loader.textureCache = cache;
	 *         return loader;
	 *     };
	 *     return itemRenderer;
	 * };</listing>
	 * 
	 * @see feathers.controls.ImageLoader#textureCache
	 *
	 * @productversion Feathers 2.3.0
	 */
	public class TextureCache
	{
		/**
		 * Constructor.
		 */
		public function TextureCache(maxUnretainedTextures:int = int.MAX_VALUE)
		{
			this._maxUnretainedTextures = maxUnretainedTextures;
		}

		/**
		 * @private
		 */
		protected var _unretainedKeys:Vector.<String> = new <String>[];

		/**
		 * @private
		 */
		protected var _unretainedTextures:Object = {};

		/**
		 * @private
		 */
		protected var _retainedTextures:Object = {};

		/**
		 * @private
		 */
		protected var _retainCounts:Object = {};

		/**
		 * @private
		 */
		protected var _maxUnretainedTextures:int;

		/**
		 * Limits the number of unretained textures that may be stored in
		 * memory. The textures retained least recently will be disposed if
		 * there are too many.
		 */
		public function get maxUnretainedTextures():int
		{
			return this._maxUnretainedTextures;
		}

		/**
		 * @private
		 */
		public function set maxUnretainedTextures(value:int):void
		{
			if(this._maxUnretainedTextures == value)
			{
				return;
			}
			this._maxUnretainedTextures = value;
			if(this._unretainedKeys.length > value)
			{
				this.trimCache();
			}
		}

		/**
		 * Disposes the texture cache, including all textures (even if they are
		 * retained).
		 */
		public function dispose():void
		{
			for each(var texture:Texture in this._unretainedTextures)
			{
				texture.dispose();
			}
			for each(texture in this._retainedTextures)
			{
				texture.dispose();
			}
			this._retainedTextures = null;
			this._unretainedTextures = null;
			this._retainCounts = null;
		}

		/**
		 * Saves a texture, and associates it with a specific key.
		 * 
		 * @see #removeTexture()
		 * @see #hasTexture()
		 */
		public function addTexture(key:String, texture:Texture, retainTexture:Boolean = true):void
		{
			if(!this._retainedTextures)
			{
				throw new IllegalOperationError("Cannot add a texture after the cache has been disposed.")
			}
			if(key in this._unretainedTextures || key in this._retainedTextures)
			{
				throw new ArgumentError("Key \"" + key + "\" already exists in the cache.");
			}
			if(retainTexture)
			{
				this._retainedTextures[key] = texture;
				this._retainCounts[key] = 1 as int;
				return;
			}
			this._unretainedTextures[key] = texture;
			this._unretainedKeys[this._unretainedKeys.length] = key;
			if(this._unretainedKeys.length > this._maxUnretainedTextures)
			{
				this.trimCache();
			}
		}

		/**
		 * Removes a specific key from the cache, and optionally disposes the
		 * texture associated with the key.
		 *
		 * @see #addTexture()
		 */
		public function removeTexture(key:String, dispose:Boolean = false):void
		{
			if(!this._unretainedTextures)
			{
				return;
			}
			var texture:Texture = this._unretainedTextures[key] as Texture;
			if(texture)
			{
				this.removeUnretainedKey(key);
			}
			else
			{
				texture = this._retainedTextures[key] as Texture;
				delete this._retainedTextures[key];
				delete this._retainCounts[key];
			}
			if(dispose && texture)
			{
				texture.dispose();
			}
		}

		/**
		 * Indicates if a texture is associated with the specified key.
		 */
		public function hasTexture(key:String):Boolean
		{
			if(!this._retainedTextures)
			{
				return false;
			}
			return key in this._retainedTextures || key in this._unretainedTextures;
		}

		/**
		 * Returns how many times the texture associated with the specified key
		 * has currently been retained.
		 */
		public function getRetainCount(key:String):int
		{
			if(this._retainCounts && (key in this._retainCounts))
			{
				return this._retainCounts[key] as int;
			}
			return 0;
		}

		/**
		 * Gets the texture associated with the specified key, and increments
		 * the retain count for the texture. Always remember to call
		 * <code>releaseTexture()</code> when finished with a retained texture.
		 * 
		 * @see #releaseTexture()
		 */
		public function retainTexture(key:String):Texture
		{
			if(!this._retainedTextures)
			{
				throw new IllegalOperationError("Cannot retain a texture after the cache has been disposed.")
			}
			if(key in this._retainedTextures)
			{
				var count:int = this._retainCounts[key] as int;
				count++;
				this._retainCounts[key] = count;
				return Texture(this._retainedTextures[key]);
			}
			
			if(!(key in this._unretainedTextures))
			{
				throw new ArgumentError("Texture with key \"" + key + "\" cannot be retained because it has not been added to the cache.");
			}
			var texture:Texture = Texture(this._unretainedTextures[key]);
			this.removeUnretainedKey(key);
			this._retainedTextures[key] = texture;
			this._retainCounts[key] = 1 as int;
			return texture;
		}

		/**
		 * Releases a retained texture.
		 *
		 * @see #retainTexture()
		 */
		public function releaseTexture(key:String):void
		{
			if(!this._retainedTextures || !(key in this._retainedTextures))
			{
				return;
			}
			var count:int = this._retainCounts[key] as int;
			count--;
			if(count == 0)
			{
				//get the existing texture
				var texture:Texture = Texture(this._retainedTextures[key]);
				
				//remove from retained
				delete this._retainCounts[key];
				delete this._retainedTextures[key];

				this._unretainedTextures[key] = texture;
				this._unretainedKeys[this._unretainedKeys.length] = key;
				if(this._unretainedKeys.length > this._maxUnretainedTextures)
				{
					this.trimCache();
				}
			}
			else
			{
				this._retainCounts[key] = count;
			}
		}

		/**
		 * @private
		 */
		protected function removeUnretainedKey(key:String):void
		{
			var index:int = this._unretainedKeys.indexOf(key);
			if(index < 0)
			{
				return;
			}
			this._unretainedKeys.removeAt(index);
			delete this._unretainedTextures[key];
		}

		/**
		 * @private
		 */
		protected function trimCache():void
		{
			var currentCount:int = this._unretainedKeys.length;
			var maxCount:int = this._maxUnretainedTextures;
			while(currentCount > maxCount)
			{
				var key:String = this._unretainedKeys.shift();
				var texture:Texture = Texture(this._unretainedTextures[key]);
				texture.dispose();
				delete this._unretainedTextures[key];
				currentCount--;
			}
		}
	}
}
