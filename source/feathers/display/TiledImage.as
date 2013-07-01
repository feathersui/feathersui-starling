/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.MatrixUtil;

	/**
	 * Tiles a texture to fill the specified bounds.
	 */
	public class TiledImage extends Sprite
	{
		private static const HELPER_POINT:Point = new Point();
		private static const HELPER_MATRIX:Matrix = new Matrix();
		
		/**
		 * Constructor.
		 */
		public function TiledImage(texture:Texture, textureScale:Number = 1)
		{
			super();
			this._hitArea = new Rectangle();
			this._textureScale = textureScale;
			this.texture = texture;
			this.initializeWidthAndHeight();

			this._batch = new QuadBatch();
			this._batch.touchable = false;
			this.addChild(this._batch);

			this.addEventListener(Event.FLATTEN, flattenHandler);
		}

		private var _propertiesChanged:Boolean = true;
		private var _layoutChanged:Boolean = true;
		
		private var _hitArea:Rectangle;

		private var _batch:QuadBatch;
		private var _image:Image;

		private var _originalImageWidth:Number;
		private var _originalImageHeight:Number;
		
		/**
		 * @private
		 */
		private var _width:Number = NaN;
		
		/**
		 * @private
		 */
		override public function get width():Number
		{
			return this._width;
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			if(this._width == value)
			{
				return;
			}
			this._width = this._hitArea.width = value;
			this._layoutChanged = true;
		}
		
		/**
		 * @private
		 */
		private var _height:Number = NaN;
		
		/**
		 * @private
		 */
		override public function get height():Number
		{
			return this._height;
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			if(this._height == value)
			{
				return;
			}
			this._height = this._hitArea.height = value;
			this._layoutChanged = true;
		}
		
		/**
		 * @private
		 */
		private var _texture:Texture;
		
		/**
		 * The texture to tile.
		 */
		public function get texture():Texture
		{
			return this._texture;
		}
		
		/**
		 * @private
		 */
		public function set texture(value:Texture):void 
		{ 
			if(value == null)
			{
				throw new ArgumentError("Texture cannot be null");
			}
			if(this._texture == value)
			{
				return;
			}
			this._texture = value;
			if(!this._image)
			{
				this._image = new Image(value);
				this._image.touchable = false;
			}
			else
			{
				this._image.texture = value;
				this._image.readjustSize();
			}
			const frame:Rectangle = value.frame;
			this._originalImageWidth = frame.width;
			this._originalImageHeight = frame.height;
			this._layoutChanged = true;
		}
		
		/**
		 * @private
		 */
		private var _smoothing:String = TextureSmoothing.BILINEAR;
		
		/**
		 * The smoothing value to pass to the tiled images.
		 *
		 * @default starling.textures.TextureSmoothing.BILINEAR
		 *
		 * @see starling.textures.TextureSmoothing
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
			if(TextureSmoothing.isValid(value))
			{
				this._smoothing = value;
			}
			else
			{
				throw new ArgumentError("Invalid smoothing mode: " + value);
			}
			this._propertiesChanged = true;
		}

		/**
		 * @private
		 */
		private var _color:uint = 0xffffff;

		/**
		 * The color value to pass to the tiled images.
		 *
		 * @default 0xffffff
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
			this._propertiesChanged = true;
		}
		
		/**
		 * @private
		 */
		private var _textureScale:Number = 1;
		
		/**
		 * The amount to scale the texture. Useful for DPI changes.
		 *
		 * @default 1
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
			this._layoutChanged = true;
		}
		
		/**
		 * @private
		 */
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if(!resultRect)
			{
				resultRect = new Rectangle();
			}
			
			var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
			
			if (targetSpace == this) // optimization
			{
				minX = this._hitArea.x;
				minY = this._hitArea.y;
				maxX = this._hitArea.x + this._hitArea.width;
				maxY = this._hitArea.y + this._hitArea.height;
			}
			else
			{
				this.getTransformationMatrix(targetSpace, HELPER_MATRIX);

				MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x, this._hitArea.y, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x, this._hitArea.y + this._hitArea.height, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x + this._hitArea.width, this._hitArea.y, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;

				MatrixUtil.transformCoords(HELPER_MATRIX, this._hitArea.x + this._hitArea.width, this._hitArea.y + this._hitArea.height, HELPER_POINT);
				minX = minX < HELPER_POINT.x ? minX : HELPER_POINT.x;
				maxX = maxX > HELPER_POINT.x ? maxX : HELPER_POINT.x;
				minY = minY < HELPER_POINT.y ? minY : HELPER_POINT.y;
				maxY = maxY > HELPER_POINT.y ? maxY : HELPER_POINT.y;
			}
			
			resultRect.x = minX;
			resultRect.y = minY;
			resultRect.width  = maxX - minX;
			resultRect.height = maxY - minY;
			
			return resultRect;
		}
		
		/**
		 * @private
		 */
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			if(forTouch && (!this.visible || !this.touchable))
			{
				return null;
			}
			return this._hitArea.containsPoint(localPoint) ? this : null;
		}
		
		/**
		 * Set both the width and height in one call.
		 */
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}

		/**
		 * @private
		 */
		override public function flatten():void
		{
			this.validate();
			super.flatten();
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			this.validate();
			super.render(support, parentAlpha);
		}

		/**
		 * @private
		 */
		protected function validate():void
		{
			if(this._propertiesChanged)
			{
				this._image.smoothing = this._smoothing;
				this._image.color = this._color;
			}
			if(this._propertiesChanged || this._layoutChanged)
			{
				this._batch.reset();
				this._image.scaleX = this._image.scaleY = this._textureScale;
				const scaledTextureWidth:Number = this._originalImageWidth * this._textureScale;
				const scaledTextureHeight:Number = this._originalImageHeight * this._textureScale;
				const xImageCount:int = Math.ceil(this._width / scaledTextureWidth);
				const yImageCount:int = Math.ceil(this._height / scaledTextureHeight);
				const imageCount:int = xImageCount * yImageCount;
				var xPosition:Number = 0;
				var yPosition:Number = 0;
				var nextXPosition:Number = xPosition + scaledTextureWidth;
				var nextYPosition:Number = yPosition + scaledTextureHeight;
				for(var i:int = 0; i < imageCount; i++)
				{
					this._image.x = xPosition;
					this._image.y = yPosition;

					var imageWidth:Number = (nextXPosition >= this._width) ? (this._width - xPosition) : scaledTextureWidth;
					var imageHeight:Number = (nextYPosition >= this._height) ? (this._height - yPosition) : scaledTextureHeight;
					this._image.width = imageWidth;
					this._image.height = imageHeight;

					var xCoord:Number = imageWidth / scaledTextureWidth;
					var yCoord:Number = imageHeight / scaledTextureHeight;
					HELPER_POINT.x = xCoord;
					HELPER_POINT.y = 0;
					this._image.setTexCoords(1, HELPER_POINT);

					HELPER_POINT.y = yCoord;
					this._image.setTexCoords(3, HELPER_POINT);

					HELPER_POINT.x = 0;
					this._image.setTexCoords(2, HELPER_POINT);

					this._batch.addImage(this._image);

					if(nextXPosition >= this._width)
					{
						xPosition = 0;
						nextXPosition = scaledTextureWidth;
						yPosition = nextYPosition;
						nextYPosition += scaledTextureHeight;
					}
					else
					{
						xPosition = nextXPosition;
						nextXPosition += scaledTextureWidth;
					}
				}
			}

			this._layoutChanged = false;
			this._propertiesChanged = false;
		}

		/**
		 * @private
		 */
		private function initializeWidthAndHeight():void
		{
			this.width = this._originalImageWidth * this._textureScale;
			this.height = this._originalImageHeight * this._textureScale;
		}

		/**
		 * @private
		 */
		private function flattenHandler(event:Event):void
		{
			this.validate();
		}

	}
}