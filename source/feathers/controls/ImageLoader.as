/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	/**
	 * Dispatched when the source content finishes loading.
	 *
	 * @eventType starling.events.Event.COMPLETE
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * Dispatched if an error occurs while loading the source content.
	 *
	 * @eventType feathers.events.FeathersEventType.ERROR
	 */
	[Event(name="error",type="starling.events.Event")]

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
		private static const HELPER_RECTANGLE2:Rectangle = new Rectangle();

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
		protected var _textureFrame:Rectangle;

		/**
		 * @private
		 */
		protected var _texture:Texture;
		
		/**
		 * @private
		 */
		protected var _textureBitmapData:BitmapData;

		/**
		 * @private
		 */
		protected var _isTextureOwner:Boolean = false;

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
			this.cleanupTexture();
			if(this.image)
			{
				this.image.visible = false;
			}
			this._lastURL = null;
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
		private var _textureScale:Number = 1;

		/**
		 * The scale of the texture.
		 */
		public function get textureScale():Number
		{
			return this._textureScale;
		}

		/**
		 * @private
		 */
		public function set textureScale(value:Number):void
		{
			if(this._textureScale == value)
			{
				return;
			}
			this._textureScale = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _smoothing:String = TextureSmoothing.BILINEAR;

		/**
		 * The smoothing value to use on the internal <code>Image</code>.
		 *
		 * @see starling.textures.TextureSmoothing
		 * @see starling.display.Image#smoothing
		 */
		public function get smoothing():String
		{
			return this._smoothing;
		}

		/**
		 * @private
		 */
		public function set smoothing(value:String):void
		{
			if(this._smoothing == value)
			{
				return;
			}
			this._smoothing = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _color:uint = 0xffffff;

		/**
		 * The tint value to use on the internal <code>Image</code>.
		 *
		 * @see starling.display.Image#color
		 */
		public function get color():uint
		{
			return this._color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if(this._color == value)
			{
				return;
			}
			this._color = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
			return this._snapToPixels;
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
			return this._maintainAspectRatio;
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
		override public function dispose():void
		{
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
				this.loader = null;
			}
			this.cleanupTexture();
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(dataInvalid)
			{
				this.commitData();
			}

			if(dataInvalid || stylesInvalid)
			{
				this.commitStyles();
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
					newWidth = this._textureFrame.width * this._textureScale;
					if(!needsHeight)
					{
						const heightScale:Number = this.explicitHeight / (this._textureFrame.height * this._textureScale);
						newWidth *= heightScale;
					}
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
					newHeight = this._textureFrame.height * this._textureScale;
					if(!needsWidth)
					{
						const widthScale:Number = this.explicitWidth / (this._textureFrame.width * this._textureScale);
						newHeight *= widthScale;
					}
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
					this._lastURL = sourceURL;
					this.commitTexture();
					return;
				}

				if(sourceURL == this._lastURL)
				{
					//if it's not loaded yet, we'll come back later
					if(this._isLoaded)
					{
						this.commitTexture();
					}
				}
				else
				{
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
		protected function commitStyles():void
		{
			if(!this.image)
			{
				return;
			}
			this.image.smoothing = this._smoothing;
			this.image.color = this._color;
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
				HELPER_RECTANGLE.x = 0;
				HELPER_RECTANGLE.y = 0;
				HELPER_RECTANGLE.width = this._textureFrame.width * this._textureScale;
				HELPER_RECTANGLE.height = this._textureFrame.height * this._textureScale;
				HELPER_RECTANGLE2.x = 0;
				HELPER_RECTANGLE2.y = 0;
				HELPER_RECTANGLE2.width = this.actualWidth;
				HELPER_RECTANGLE2.height = this.actualHeight;
				RectangleUtil.fit(HELPER_RECTANGLE, HELPER_RECTANGLE2, ScaleMode.SHOW_ALL, false, HELPER_RECTANGLE);
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

			//save the texture's frame so that we don't need to create a new
			//rectangle every time that we want to access it.
			this._textureFrame = this._texture.frame;
			if(!this.image)
			{
				this.image = new Image(this._texture);
				this.addChild(this.image);
			}
			else
			{
				this.image.texture = this._texture;
				this.image.readjustSize();
			}
			this.image.visible = true;
		}
		
		/**
		 * @private
		 */
		protected function cleanupTexture():void
		{
			if(this._isTextureOwner)
			{
				if(this._textureBitmapData)
				{
					this._textureBitmapData.dispose();
				}
				if(this._texture)
				{
					this._texture.dispose();
				}
			}
			this._textureBitmapData = null;
			this._texture = null;
			this._isTextureOwner = false;
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
			
			this.cleanupTexture();
			const bitmapData:BitmapData = bitmap.bitmapData;
			this._texture = Texture.fromBitmapData(bitmapData, false);
			if(Starling.handleLostContext)
			{
				this._textureBitmapData = bitmapData;
			}
			else
			{
				//since Starling isn't handling the lost context, we don't need
				//to save the texture bitmap data.
				bitmapData.dispose();
			}
			this._isTextureOwner = true;
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
			
			this.cleanupTexture();
			this.commitTexture();
			this.invalidate(INVALIDATION_FLAG_SIZE);
			this.dispatchEventWith(FeathersEventType.ERROR, false, event);
		}
	}
}
