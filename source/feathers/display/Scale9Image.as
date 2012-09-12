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
package feathers.display
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.textures.Scale9Textures;

	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.QuadBatch;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	import starling.utils.MatrixUtil;

	/**
	 * Scales an image with nine regions to maintain the aspect ratio of the
	 * corners regions. The top and bottom regions stretch horizontally, and the
	 * left and right regions scale vertically. The center region stretches in
	 * both directions to fill the remaining space.
	 */
	public class Scale9Image extends Sprite
	{
		private static const helperMatrix:Matrix = new Matrix();
		private static const helperPoint:Point = new Point();
		private static var helperImage:starling.display.Image;
		
		/**
		 * Constructor.
		 */
		public function Scale9Image(textures:Scale9Textures, textureScale:Number = 1)
		{
			super();
			this._textures = textures;
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
		private var _textures:Scale9Textures;

		/**
		 * The textures displayed by this image.
		 */
		public function get textures():Scale9Textures
		{
			return this._textures;
		}

		/**
		 * @private
		 */
		public function set textures(value:Scale9Textures):void
		{
			if(!value)
			{
				throw new IllegalOperationError("Scale9Image textures cannot be null.")
			}
			if(this._textures == value)
			{
				return;
			}
			this._textures = value;
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

				MatrixUtil.transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;

				MatrixUtil.transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y + this._hitArea.height, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;

				MatrixUtil.transformCoords(helperMatrix, this._hitArea.x + this._hitArea.width, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;

				MatrixUtil.transformCoords(helperMatrix, this._hitArea.x + this._hitArea.width, this._hitArea.y + this._hitArea.height, helperPoint);
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
			const frame:Rectangle = this._textures.texture.frame;
			this.width = frame.width * this._textureScale;
			this.height = frame.height * this._textureScale;
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
					helperImage = new starling.display.Image(this._textures.topLeft);
				}
				helperImage.smoothing = this._smoothing;
				helperImage.color = this._color;

				const frame:Rectangle = this._textures.texture.frame;
				const grid:Rectangle = this._textures.scale9Grid;
				const scaledLeftWidth:Number = grid.x * this._textureScale;
				const scaledTopHeight:Number = grid.y * this._textureScale;
				const scaledRightWidth:Number = (frame.width - grid.x - grid.width) * this._textureScale;
				const scaledBottomHeight:Number = (frame.height - grid.y - grid.height) * this._textureScale;
				const scaledCenterWidth:Number = this._width - scaledLeftWidth - scaledRightWidth;
				const scaledMiddleHeight:Number = this._height - scaledTopHeight - scaledBottomHeight;

				if(scaledTopHeight > 0)
				{
					helperImage.texture = this._textures.topLeft;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth - helperImage.width;
					helperImage.y = scaledTopHeight - helperImage.height;
					if(scaledLeftWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._textures.topCenter;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth;
					helperImage.y = scaledTopHeight - helperImage.height;
					helperImage.width = scaledCenterWidth;
					if(scaledCenterWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._textures.topRight;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = this._width - scaledRightWidth;
					helperImage.y = scaledTopHeight - helperImage.height;
					if(scaledRightWidth > 0)
					{
						this._batch.addImage(helperImage);
					}
				}

				if(scaledMiddleHeight > 0)
				{
					helperImage.texture = this._textures.middleLeft;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth - helperImage.width;
					helperImage.y = scaledTopHeight;
					helperImage.height = scaledMiddleHeight;
					if(scaledLeftWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._textures.middleCenter;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth;
					helperImage.y = scaledTopHeight;
					helperImage.width = scaledCenterWidth;
					helperImage.height = scaledMiddleHeight;
					if(scaledCenterWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._textures.middleRight;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = this._width - scaledRightWidth;
					helperImage.y = scaledTopHeight;
					helperImage.height = scaledMiddleHeight;
					if(scaledRightWidth > 0)
					{
						this._batch.addImage(helperImage);
					}
				}

				if(scaledBottomHeight > 0)
				{
					helperImage.texture = this._textures.bottomLeft;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth - helperImage.width;
					helperImage.y = this._height - scaledBottomHeight;
					if(scaledLeftWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._textures.bottomCenter;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth;
					helperImage.y = this._height - scaledBottomHeight;
					helperImage.width = scaledCenterWidth;
					if(scaledCenterWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._textures.bottomRight;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = this._width - scaledRightWidth;
					helperImage.y = this._height - scaledBottomHeight;
					if(scaledRightWidth > 0)
					{
						this._batch.addImage(helperImage);
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