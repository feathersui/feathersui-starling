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
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;

	import flash.display.Bitmap;

	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;

	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.RectangleUtil;

	/**
	 * Displays an image, either from a <code>Texture</code> or loaded from a
	 * URL.
	 */
	public class ImageLoader extends FeathersControl
	{
		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * @private
		 */
		private static const HELPER_RECTANGLE:Rectangle = new Rectangle();

		/**
		 * @private
		 */
		private static const LOADER_CONTEXT:LoaderContext = new LoaderContext(true);
		LOADER_CONTEXT.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;

		/**
		 * Constructor.
		 */
		public function ImageLoader()
		{
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * The internal <code>starling.display.Image</code> child.
		 */
		protected var image:Image;

		/**
		 * The internal <code>flash.display.Loader</code> used to load textures
		 * from URLs.
		 */
		protected var loader:Loader;

		/**
		 * @private
		 */
		protected var _lastURL:String;

		/**
		 * @private
		 */
		protected var _texture:Texture;

		/**
		 * @private
		 */
		protected var _source:Object;

		/**
		 * The texture to display, or a URL to load the image from to create the
		 * texture.
		 */
		public function get source():Object
		{
			return this._source;
		}

		/**
		 * @private
		 */
		public function set source(value:Object):void
		{
			if(this._source == value)
			{
				return;
			}
			this._source = value;
			this._isLoaded = false;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _isLoaded:Boolean = false;

		/**
		 * Indicates if the source has fully loaded.
		 */
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}

		/**
		 * @private
		 */
		private var _snapToPixels:Boolean = false;

		/**
		 * Determines if the image should be snapped to the nearest global whole
		 * pixel when rendered. Turning this on helps to avoid blurring.
		 */
		public function get snapToPixels():Boolean
		{
			return _snapToPixels;
		}

		/**
		 * @private
		 */
		public function set snapToPixels(value:Boolean):void
		{
			if(this._snapToPixels == value)
			{
				return;
			}
			this._snapToPixels = value;
		}

		/**
		 * @private
		 */
		private var _maintainAspectRatio:Boolean = true;

		/**
		 * Determines if the aspect ratio of the texture is maintained when the
		 * aspect ratio of the component is different.
		 */
		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio;
		}

		/**
		 * @private
		 */
		public function set maintainAspectRatio(value:Boolean):void
		{
			if(this._maintainAspectRatio == value)
			{
				return;
			}
			this._maintainAspectRatio = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if(this._snapToPixels)
			{
				this.getTransformationMatrix(this.stage, HELPER_MATRIX);
				support.translateMatrix(Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx, Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty);
			}
			super.render(support, parentAlpha);
			if(this._snapToPixels)
			{
				support.translateMatrix(-(Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx), -(Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty));
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(dataInvalid)
			{
				this.commitData();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(dataInvalid || layoutInvalid || sizeInvalid)
			{
				this.layout();
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				if(this._texture)
				{
					newWidth = this._texture.width;
				}
				else
				{
					newWidth = 0;
				}
			}

			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				if(this._texture)
				{
					newHeight = this._texture.height;
				}
				else
				{
					newHeight = 0;
				}
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function commitData():void
		{
			if(this._source is Texture)
			{
				this._lastURL = null;
				this._texture = Texture(this._source);
				this.commitTexture();
				this._isLoaded = true;
			}
			else
			{
				const sourceURL:String = this._source as String;
				if(!sourceURL)
				{
					this._lastURL = null;
					this._texture = null;
					this.commitTexture();
					return;
				}

				if(sourceURL == this._lastURL)
				{
					//if it's not loaded yet, we'll come back later
					if(!this.loader)
					{
						this.commitTexture();
					}
				}
				else
				{
					if(this.image)
					{
						//hide the image for now. we'll dispose the old texture
						//and make it visible again once the content is loaded.
						this.image.visible = false;
					}
					this._lastURL = sourceURL;

					if(this.loader)
					{
						this.loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
						this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
						this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
						try
						{
							this.loader.close();
						}
						catch(error:Error)
						{
							//no need to do anything in response
						}
					}
					else
					{
						this.loader = new Loader();
					}
					this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
					this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
					this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
					this.loader.load(new URLRequest(sourceURL), LOADER_CONTEXT);
				}
			}
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			if(!this.image || !this._texture)
			{
				return;
			}
			if(this._maintainAspectRatio)
			{
				RectangleUtil.fit(this._texture.frame, this.bounds, true, HELPER_RECTANGLE);
				this.image.x = HELPER_RECTANGLE.x;
				this.image.y = HELPER_RECTANGLE.y;
				this.image.width = HELPER_RECTANGLE.width;
				this.image.height = HELPER_RECTANGLE.height;
			}
			else
			{
				this.image.x = 0;
				this.image.y = 0;
				this.image.width = this.actualWidth;
				this.image.height = this.actualHeight;
			}
		}

		/**
		 * @private
		 */
		protected function commitTexture():void
		{
			if(!this._texture)
			{
				if(this.image)
				{
					this.removeChild(this.image, true);
					this.image = null;
				}
				return;
			}

			if(!this.image)
			{
				this.image = new Image(this._texture);
				this.addChild(this.image);
			}
			else
			{
				if(this.image.texture)
				{
					this.image.texture.dispose();
				}
				this.image.texture = this._texture;
				this.image.readjustSize();
			}
		}

		/**
		 * @private
		 */
		protected function loader_completeHandler(event:flash.events.Event):void
		{
			const bitmap:Bitmap = Bitmap(this.loader.content);
			this.loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
			this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
			this.loader = null;

			this._texture = Texture.fromBitmap(bitmap);
			this.commitTexture();
			this._isLoaded = true;
			this.invalidate(INVALIDATION_FLAG_SIZE);
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}

		/**
		 * @private
		 */
		protected function loader_errorHandler(event:ErrorEvent):void
		{
			this.loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
			this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
			this.loader = null;

			this._texture = null;
			this.commitTexture();
			this.invalidate(INVALIDATION_FLAG_SIZE);
			this.dispatchEventWith(FeathersEventType.ERROR, false, event);
		}
	}
}
