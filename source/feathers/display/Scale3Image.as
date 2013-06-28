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
		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
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

			this.addEventListener(Event.FLATTEN, flattenHandler);
		}

		/**
		 * @private
		 */
		private var _propertiesChanged:Boolean = true;

		/**
		 * @private
		 */
		private var _renderingChanged:Boolean = true;

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
			this._renderingChanged = true;
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
		private var _smoothing:String = TextureSmoothing.BILINEAR;

		/**
		 * The smoothing value to pass to the images.
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
		private var _useSeparateBatch:Boolean = true;

		/**
		 * Determines if the regions are batched normally by Starling or if
		 * they're batched separately.
		 *
		 * @default true
		 */
		public function get useSeparateBatch():Boolean
		{
			return this._useSeparateBatch;
		}

		/**
		 * @private
		 */
		public function set useSeparateBatch(value:Boolean):void
		{
			if(this._useSeparateBatch == value)
			{
				return;
			}
			this._useSeparateBatch = value;
			this._renderingChanged = true;
		}

		/**
		 * @private
		 */
		private var _hitArea:Rectangle;

		/**
		 * @private
		 */
		private var _batch:QuadBatch;

		/**
		 * @private
		 */
		private var _firstRegionImage:Image;

		/**
		 * @private
		 */
		private var _secondRegionImage:Image;

		/**
		 * @private
		 */
		private var _thirdRegionImage:Image;

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
		private function validate():void
		{
			this.refreshImages();
			if(this._propertiesChanged || this._layoutChanged || this._renderingChanged)
			{
				this.refreshBatch();

				var image:Image;
				if(this._textures.direction == Scale3Textures.DIRECTION_VERTICAL)
				{
					var scaledOppositeEdgeSize:Number = this._width;
					var oppositeEdgeScale:Number = scaledOppositeEdgeSize / this._frame.width;
					var scaledFirstRegionSize:Number = this._textures.firstRegionSize * oppositeEdgeScale;
					var scaledThirdRegionSize:Number = (this._frame.height - this._textures.firstRegionSize - this._textures.secondRegionSize) * oppositeEdgeScale;
					var scaledSecondRegionSize:Number = this._height - scaledFirstRegionSize - scaledThirdRegionSize;
					if(scaledSecondRegionSize < 0)
					{
						var firstAndThirdOffset:Number = scaledSecondRegionSize / 2;
						scaledFirstRegionSize += firstAndThirdOffset;
						scaledThirdRegionSize += firstAndThirdOffset;
					}

					if(scaledOppositeEdgeSize > 0)
					{
						if(this._useSeparateBatch)
						{
							image = helperImage;
							helperImage.texture = this._textures.first;
							helperImage.readjustSize();
						}
						else
						{
							image = this._firstRegionImage;
							image.smoothing = this._smoothing;
							image.color = this._color;
						}
						image.x = 0;
						image.y = 0;
						image.width = scaledOppositeEdgeSize;
						image.height = scaledFirstRegionSize;
						if(this._useSeparateBatch && scaledFirstRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						if(scaledSecondRegionSize > 0)
						{
							if(this._useSeparateBatch)
							{
								image = helperImage;
								helperImage.texture = this._textures.second;
								helperImage.readjustSize();
							}
							else
							{
								image = this._secondRegionImage;
								image.smoothing = this._smoothing;
								image.color = this._color;
								image.visible = true;
							}
							image.x = 0;
							image.y = scaledFirstRegionSize;
							image.width = scaledOppositeEdgeSize;
							image.height = scaledSecondRegionSize;
							if(this._useSeparateBatch)
							{
								this._batch.addImage(helperImage);
							}
						}
						else if(!this._useSeparateBatch)
						{
							this._secondRegionImage.visible = false;
						}

						if(this._useSeparateBatch)
						{
							image = helperImage;
							helperImage.texture = this._textures.third;
							helperImage.readjustSize();
						}
						else
						{
							image = this._thirdRegionImage;
							image.smoothing = this._smoothing;
							image.color = this._color;
						}
						image.x = 0;
						image.y = this._height - scaledThirdRegionSize;
						image.width = scaledOppositeEdgeSize;
						image.height = scaledThirdRegionSize;
						if(this._useSeparateBatch && scaledThirdRegionSize > 0)
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
					if(scaledSecondRegionSize < 0)
					{
						firstAndThirdOffset = scaledSecondRegionSize / 2;
						scaledFirstRegionSize += firstAndThirdOffset;
						scaledThirdRegionSize += firstAndThirdOffset;
					}

					if(scaledOppositeEdgeSize > 0)
					{
						if(this._useSeparateBatch)
						{
							image = helperImage;
							helperImage.texture = this._textures.first;
							helperImage.readjustSize();
						}
						else
						{
							image = this._firstRegionImage;
							image.smoothing = this._smoothing;
							image.color = this._color;
						}
						image.x = 0;
						image.y = 0;
						image.width = scaledFirstRegionSize;
						image.height = scaledOppositeEdgeSize;
						if(this._useSeparateBatch && scaledFirstRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}

						if(scaledSecondRegionSize > 0)
						{
							if(this._useSeparateBatch)
							{
								image = helperImage;
								helperImage.texture = this._textures.second;
								helperImage.readjustSize();
							}
							else
							{
								image = this._secondRegionImage
								image.smoothing = this._smoothing;
								image.color = this._color;
								image.visible = true;
							}
							image.x = scaledFirstRegionSize;
							image.y = 0;
							image.width = scaledSecondRegionSize;
							image.height = scaledOppositeEdgeSize;
							if(this._useSeparateBatch)
							{
								this._batch.addImage(helperImage);
							}
						}
						else if(!this._useSeparateBatch)
						{
							this._secondRegionImage.visible = false;
						}

						if(this._useSeparateBatch)
						{
							image = helperImage;
							helperImage.texture = this._textures.third;
							helperImage.readjustSize();
						}
						else
						{
							image = this._thirdRegionImage;
							image.smoothing = this._smoothing;
							image.color = this._color;
						}
						image.x = this._width - scaledThirdRegionSize;
						image.y = 0;
						image.width = scaledThirdRegionSize;
						image.height = scaledOppositeEdgeSize;
						if(this._useSeparateBatch && scaledThirdRegionSize > 0)
						{
							this._batch.addImage(helperImage);
						}
					}
				}
			}
			this._propertiesChanged = false;
			this._layoutChanged = false;
			this._renderingChanged = false;
		}

		/**
		 * @private
		 */
		private function refreshImages():void
		{
			if(!this._renderingChanged || this._useSeparateBatch)
			{
				return;
			}
			if(this._firstRegionImage)
			{
				this._firstRegionImage.texture = this._textures.first;
				this._firstRegionImage.readjustSize();
			}
			else
			{
				this._firstRegionImage = new Image(this._textures.first);
				this.addChild(this._firstRegionImage);
			}
			if(this._secondRegionImage)
			{
				this._secondRegionImage.texture = this._textures.second;
				this._secondRegionImage.readjustSize();
			}
			else
			{
				this._secondRegionImage = new Image(this._textures.second);
				this.addChild(this._secondRegionImage);
			}
			if(this._thirdRegionImage)
			{
				this._thirdRegionImage.texture = this._textures.third;
				this._thirdRegionImage.readjustSize();
			}
			else
			{
				this._thirdRegionImage = new Image(this._textures.third);
				this.addChild(this._thirdRegionImage);
			}
		}

		/**
		 * @private
		 */
		private function refreshBatch():void
		{
			if(this._useSeparateBatch)
			{
				if(!this._batch)
				{
					this._batch = new QuadBatch();
					this._batch.touchable = false;
					this.addChild(this._batch);
				}
				if(this._firstRegionImage)
				{
					this._firstRegionImage.removeFromParent(true);
					this._firstRegionImage = null;
				}
				if(this._secondRegionImage)
				{
					this._secondRegionImage.removeFromParent(true);
					this._secondRegionImage = null;
				}
				if(this._thirdRegionImage)
				{
					this._thirdRegionImage.removeFromParent(true);
					this._thirdRegionImage = null;
				}
				this._batch.reset();

				if(!helperImage)
				{
					helperImage = new Image(this._textures.first);
				}
				helperImage.smoothing = this._smoothing;
				helperImage.color = this._color;
			}
			else if(this._batch)
			{
				this._batch.removeFromParent(true);
				this._batch = null;
			}
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
