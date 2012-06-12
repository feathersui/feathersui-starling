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
package org.josht.starling.display
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.QuadBatch;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.transformCoords;

	/**
	 * Scales an image like a "pill" shape with three regions, either
	 * horizontally or vertically. The edge regions scale while maintaining
	 * aspect ratio, and the middle region stretches to fill the remaining
	 * space.
	 */
	public class Scale3Image extends Sprite
	{
		private static const helperMatrix:Matrix = new Matrix();
		private static const helperPoint:Point = new Point();
		private static var helperImage:starling.display.Image;

		/**
		 * If the direction is horizontal, the layout will start on the left and continue to the right.
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * If the direction is vertical, the layout will start on the top and continue to the bottom.
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * Constructor.
		 */
		public function Scale3Image(texture:Texture, firstRegionSize:Number, secondRegionSize:Number, direction:String = DIRECTION_HORIZONTAL, textureScale:Number = 1)
		{
			super();
			this._hitArea = new Rectangle();
			this._firstRegionSize = firstRegionSize;
			this._secondRegionSize = secondRegionSize;
			this._direction = direction;
			this._textureScale = textureScale;
			this.createImages(texture);
			this.initializeWidthAndHeight();

			this._batch = new QuadBatch();
			this._batch.touchable = false;
			this.addChild(this._batch);
		}

		private var _propertiesChanged:Boolean = true;
		private var _layoutChanged:Boolean = true;

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
		private var _firstRegionSize:Number;
		private var _secondRegionSize:Number;
		private var _thirdRegionSize:Number;
		private var _oppositeEdgeSize:Number;
		private var _direction:String;

		private var _batch:QuadBatch;
		private var _first:Texture;
		private var _second:Texture;
		private var _third:Texture;

		/**
		 * @private
		 */
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if(this.scrollRect)
			{
				return super.getBounds(targetSpace, resultRect);
			}

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
				this.getTransformationMatrix(targetSpace, helperMatrix);

				transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;

				transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y + this._hitArea.height, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;

				transformCoords(helperMatrix, this._hitArea.x + this._hitArea.width, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;

				transformCoords(helperMatrix, this._hitArea.x + this._hitArea.width, this._hitArea.y + this._hitArea.height, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
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
		private function createImages(texture:Texture):void
		{
			const textureFrame:Rectangle = texture.frame;
			if(this._direction == DIRECTION_VERTICAL)
			{
				this._thirdRegionSize = textureFrame.height - this._firstRegionSize - this._secondRegionSize;
				this._oppositeEdgeSize = textureFrame.width;
			}
			else
			{
				this._thirdRegionSize = textureFrame.width - this._firstRegionSize - this._secondRegionSize;
				this._oppositeEdgeSize = textureFrame.height;
			}

			if(this._direction == DIRECTION_VERTICAL)
			{
				const regionTopHeight:Number = this._firstRegionSize + textureFrame.y;
				const regionBottomHeight:Number = this._thirdRegionSize - (textureFrame.height - texture.height) - textureFrame.y;

				var hasTopFrame:Boolean = regionTopHeight != this._firstRegionSize;
				var hasRightFrame:Boolean = (textureFrame.width - textureFrame.x) != texture.width;
				var hasBottomFrame:Boolean = regionBottomHeight != this._thirdRegionSize;
				var hasLeftFrame:Boolean = textureFrame.x != 0;

				var firstRegion:Rectangle = new Rectangle(0, 0, texture.width, regionTopHeight);
				var firstFrame:Rectangle = (hasLeftFrame || hasRightFrame || hasTopFrame) ? new Rectangle(textureFrame.x, textureFrame.y, this._oppositeEdgeSize, this._firstRegionSize) : null;
				this._first = Texture.fromTexture(texture, firstRegion, firstFrame);

				var secondRegion:Rectangle = new Rectangle(0, regionTopHeight, texture.width, this._secondRegionSize);
				var secondFrame:Rectangle = (hasLeftFrame || hasRightFrame) ? new Rectangle(textureFrame.x, 0, this._oppositeEdgeSize, this._secondRegionSize) : null;
				this._second = Texture.fromTexture(texture, secondRegion, secondFrame);

				var thirdRegion:Rectangle = new Rectangle(0, regionTopHeight + this._secondRegionSize, texture.width, regionBottomHeight);
				var thirdFrame:Rectangle = (hasLeftFrame || hasRightFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, this._oppositeEdgeSize, this._thirdRegionSize) : null;
				this._third = Texture.fromTexture(texture, thirdRegion, thirdFrame);
			}
			else //horizontal
			{
				const regionLeftWidth:Number = this._firstRegionSize + textureFrame.x;
				const regionRightWidth:Number = this._thirdRegionSize - (textureFrame.width - texture.width) - textureFrame.x;

				hasTopFrame = textureFrame.y != 0;
				hasRightFrame = regionRightWidth != this._thirdRegionSize;
				hasBottomFrame = (textureFrame.height - textureFrame.y) != texture.height;
				hasLeftFrame = regionLeftWidth != this._firstRegionSize;

				firstRegion = new Rectangle(0, 0, regionLeftWidth, texture.height);
				firstFrame = (hasLeftFrame || hasTopFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, textureFrame.y, this._firstRegionSize, this._oppositeEdgeSize) : null;
				this._first = Texture.fromTexture(texture, firstRegion, firstFrame);

				secondRegion = new Rectangle(regionLeftWidth, 0, this._secondRegionSize, texture.height);
				secondFrame = (hasTopFrame || hasBottomFrame) ? new Rectangle(0, textureFrame.y, this._secondRegionSize, this._oppositeEdgeSize) : null;
				this._second = Texture.fromTexture(texture, secondRegion, secondFrame);

				thirdRegion = new Rectangle(regionLeftWidth + this._secondRegionSize, 0, regionRightWidth, texture.height);
				thirdFrame = (hasTopFrame || hasBottomFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, this._thirdRegionSize, this._oppositeEdgeSize) : null;
				this._third = Texture.fromTexture(texture, thirdRegion, thirdFrame);
			}
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, alpha:Number):void
		{
			if(this._propertiesChanged || this._layoutChanged)
			{
				this._batch.reset();

				if(!helperImage)
				{
					helperImage = new starling.display.Image(this._first);
				}
				helperImage.smoothing = this._smoothing;
				helperImage.color = this._color;

				if(this._direction == DIRECTION_VERTICAL)
				{
					var scaledOppositeEdgeSize:Number = this._width;
					var oppositeEdgeScale:Number = scaledOppositeEdgeSize / this._oppositeEdgeSize;
					var scaledFirstRegionSize:Number = this._firstRegionSize * oppositeEdgeScale;
					var scaledThirdRegionSize:Number = this._thirdRegionSize * oppositeEdgeScale;
					var scaledSecondRegionSize:Number = this._height - scaledFirstRegionSize - scaledThirdRegionSize;

					if(scaledOppositeEdgeSize > 0)
					{
						helperImage.texture = this._first;
						helperImage.readjustSize();
						helperImage.x = 0;
						helperImage.y = 0;
						helperImage.width = scaledOppositeEdgeSize;
						helperImage.height = scaledFirstRegionSize;
						if(scaledFirstRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						helperImage.texture = this._second;
						helperImage.readjustSize();
						helperImage.x = 0;
						helperImage.y = scaledFirstRegionSize;
						helperImage.width = scaledOppositeEdgeSize;
						helperImage.height = scaledSecondRegionSize;
						if(scaledSecondRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						helperImage.texture = this._third;
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
					oppositeEdgeScale = scaledOppositeEdgeSize / this._oppositeEdgeSize;
					scaledFirstRegionSize = this._firstRegionSize * oppositeEdgeScale;
					scaledThirdRegionSize = this._thirdRegionSize * oppositeEdgeScale;
					scaledSecondRegionSize = this._width - scaledFirstRegionSize - scaledThirdRegionSize;

					if(scaledOppositeEdgeSize > 0)
					{
						helperImage.texture = this._first;
						helperImage.readjustSize();
						helperImage.x = 0;
						helperImage.y = 0;
						helperImage.width = scaledFirstRegionSize;
						helperImage.height = scaledOppositeEdgeSize;
						if(scaledFirstRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						helperImage.texture = this._second;
						helperImage.readjustSize();
						helperImage.x = scaledFirstRegionSize;
						helperImage.y = 0;
						helperImage.width = scaledSecondRegionSize;
						helperImage.height = scaledOppositeEdgeSize;
						if(scaledSecondRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						helperImage.texture = this._third;
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
			super.render(support, alpha);
		}

		/**
		 * @private
		 */
		private function initializeWidthAndHeight():void
		{
			if(this._direction == DIRECTION_VERTICAL)
			{
				this.width = this._oppositeEdgeSize * this._textureScale;
				this.height = (this._firstRegionSize + this._secondRegionSize + this._thirdRegionSize) * this._textureScale;
			}
			else //horizontal
			{
				this.width = (this._firstRegionSize + this._secondRegionSize + this._thirdRegionSize) * this._textureScale;
				this.height = this._oppositeEdgeSize * this._textureScale;
			}
		}
	}
}
