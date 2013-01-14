/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.display
{
	import feathers.textures.Scale3Textures;

	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	import starling.utils.MatrixUtil;

	/**
	 * Scales an image like a "pill" shape with three regions, either
	 * horizontally or vertically. The edge regions scale while maintaining
	 * aspect ratio, and the middle region stretches to fill the remaining
	 * space.
	 */
	public class Scale3Image extends Sprite
	{
		private static const HELPER_MATRIX:Matrix = new Matrix();
		private static const HELPER_POINT:Point = new Point();
		private static var helperImage:Image;

		/**
		 * Constructor.
		 */
		public function Scale3Image(textures:Scale3Textures, textureScale:Number = 1)
		{
			super();
			this.textures = textures;
			this._textureScale = textureScale;
			this._hitArea = new Rectangle();
			this.readjustSize();

			this._batch = new QuadBatch();
			this._batch.touchable = false;
			this.addChild(this._batch);

			this.addEventListener(Event.FLATTEN, flattenHandler);
		}

		/**
		 * @private
		 */
		private var _propertiesChanged:Boolean = true;

		/**
		 * @private
		 */
		private var _layoutChanged:Boolean = true;
		
		/**
		 * @private
		 */
		private var _frame:Rectangle;

		/**
		 * @private
		 */
		private var _textures:Scale3Textures;

		/**
		 * The textures displayed by this image.
		 */
		public function get textures():Scale3Textures
		{
			return this._textures;
		}

		/**
		 * @private
		 */
		public function set textures(value:Scale3Textures):void
		{
			if(!value)
			{
				throw new IllegalOperationError("Scale3Image textures cannot be null.");
			}
			if(this._textures == value)
			{
				return;
			}
			this._textures = value;
			this._frame = this._textures.texture.frame;
			this._layoutChanged = true;
			this._propertiesChanged = true;
		}

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
		private var _textureScale:Number = 1;

		/**
		 * The amount to scale the texture. Useful for DPI changes.
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
		private var _smoothing:String = TextureSmoothing.BILINEAR;

		/**
		 * The smoothing value to pass to the images.
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
			if(this._smoothing == value)
			{
				return;
			}
			this._smoothing = value;
			this._propertiesChanged = true;
		}

		/**
		 * @private
		 */
		private var _color:uint = 0xffffff;

		/**
		 * The color value to pass to the images.
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

		private var _hitArea:Rectangle;
		private var _batch:QuadBatch;

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
		 * Readjusts the dimensions of the image according to its current
		 * textures. Call this method to synchronize image and texture size
		 * after assigning textures with a different size.
		 */
		public function readjustSize():void
		{
			this.width = this._frame.width * this._textureScale;
			this.height = this._frame.height * this._textureScale;
		}

		/**
		 * @private
		 */
		protected function validate():void
		{
			if(this._propertiesChanged || this._layoutChanged)
			{
				this._batch.reset();

				if(!helperImage)
				{
					helperImage = new Image(this._textures.first);
				}
				helperImage.smoothing = this._smoothing;
				helperImage.color = this._color;

				if(this._textures.direction == Scale3Textures.DIRECTION_VERTICAL)
				{
					var scaledOppositeEdgeSize:Number = this._width;
					var oppositeEdgeScale:Number = scaledOppositeEdgeSize / this._frame.width;
					var scaledFirstRegionSize:Number = this._textures.firstRegionSize * oppositeEdgeScale;
					var scaledThirdRegionSize:Number = (this._frame.height - this._textures.firstRegionSize - this._textures.secondRegionSize) * oppositeEdgeScale;
					var scaledSecondRegionSize:Number = this._height - scaledFirstRegionSize - scaledThirdRegionSize;

					if(scaledOppositeEdgeSize > 0)
					{
						helperImage.texture = this._textures.first;
						helperImage.readjustSize();
						helperImage.x = 0;
						helperImage.y = 0;
						helperImage.width = scaledOppositeEdgeSize;
						helperImage.height = scaledFirstRegionSize;
						if(scaledFirstRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						helperImage.texture = this._textures.second;
						helperImage.readjustSize();
						helperImage.x = 0;
						helperImage.y = scaledFirstRegionSize;
						helperImage.width = scaledOppositeEdgeSize;
						helperImage.height = scaledSecondRegionSize;
						if(scaledSecondRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						helperImage.texture = this._textures.third;
						helperImage.readjustSize();
						helperImage.x = 0;
						helperImage.y = this._height - scaledThirdRegionSize;
						helperImage.width = scaledOppositeEdgeSize;
						helperImage.height = scaledThirdRegionSize;
						if(scaledThirdRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}
					}
				}
				else //horizontal
				{
					scaledOppositeEdgeSize = this._height;
					oppositeEdgeScale = scaledOppositeEdgeSize / this._frame.height;
					scaledFirstRegionSize = this._textures.firstRegionSize * oppositeEdgeScale;
					scaledThirdRegionSize = (this._frame.width - this._textures.firstRegionSize - this._textures.secondRegionSize) * oppositeEdgeScale;
					scaledSecondRegionSize = this._width - scaledFirstRegionSize - scaledThirdRegionSize;

					if(scaledOppositeEdgeSize > 0)
					{
						helperImage.texture = this._textures.first;
						helperImage.readjustSize();
						helperImage.x = 0;
						helperImage.y = 0;
						helperImage.width = scaledFirstRegionSize;
						helperImage.height = scaledOppositeEdgeSize;
						if(scaledFirstRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						helperImage.texture = this._textures.second;
						helperImage.readjustSize();
						helperImage.x = scaledFirstRegionSize;
						helperImage.y = 0;
						helperImage.width = scaledSecondRegionSize;
						helperImage.height = scaledOppositeEdgeSize;
						if(scaledSecondRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						helperImage.texture = this._textures.third;
						helperImage.readjustSize();
						helperImage.x = this._width - scaledThirdRegionSize;
						helperImage.y = 0;
						helperImage.width = scaledThirdRegionSize;
						helperImage.height = scaledOppositeEdgeSize;
						if(scaledThirdRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}
					}
				}
			}
			this._propertiesChanged = false;
			this._layoutChanged = false;
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
