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
		public function Scale9Image(texture:Texture, scale9Grid:Rectangle, textureScale:Number = 1)
		{
			super();
			this._hitArea = new Rectangle();
			this._scale9Grid = scale9Grid;
			this._textureScale = textureScale;
			this.saveRegions(texture);
			this.initializeWidthAndHeight();
			this.createTextures(texture);

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

		private var _scale9Grid:Rectangle;
		private var _leftWidth:Number;
		private var _centerWidth:Number;
		private var _rightWidth:Number;
		private var _topHeight:Number;
		private var _middleHeight:Number;
		private var _bottomHeight:Number;
		
		private var _hitArea:Rectangle;

		private var _batch:QuadBatch;
		private var _topLeft:Texture;
		private var _topCenter:Texture;
		private var _topRight:Texture;
		private var _middleLeft:Texture;
		private var _middleCenter:Texture;
		private var _middleRight:Texture;
		private var _bottomLeft:Texture;
		private var _bottomCenter:Texture;
		private var _bottomRight:Texture;
		
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
		private function saveRegions(texture:Texture):void
		{
			const textureFrame:Rectangle = texture.frame;
			this._leftWidth = this._scale9Grid.x;
			this._centerWidth = this._scale9Grid.width;
			this._rightWidth = textureFrame.width - this._scale9Grid.width - this._scale9Grid.x;
			this._topHeight = this._scale9Grid.y;
			this._middleHeight = this._scale9Grid.height;
			this._bottomHeight = textureFrame.height - this._scale9Grid.height - this._scale9Grid.y;
		}
		
		/**
		 * @private
		 */
		private function createTextures(texture:Texture):void
		{
			const textureFrame:Rectangle = texture.frame;
			
			const regionLeftWidth:Number = this._leftWidth + textureFrame.x;
			const regionTopHeight:Number = this._topHeight + textureFrame.y;
			const regionRightWidth:Number = this._rightWidth - (textureFrame.width - texture.width) - textureFrame.x;
			const regionBottomHeight:Number = this._bottomHeight - (textureFrame.height - texture.height) - textureFrame.y;
			
			const hasLeftFrame:Boolean = regionLeftWidth != this._leftWidth;
			const hasTopFrame:Boolean = regionTopHeight != this._topHeight;
			const hasRightFrame:Boolean = regionRightWidth != this._rightWidth;
			const hasBottomFrame:Boolean = regionBottomHeight != this._bottomHeight;
			
			const topLeftRegion:Rectangle = new Rectangle(0, 0, regionLeftWidth, regionTopHeight);
			const topLeftFrame:Rectangle = (hasLeftFrame || hasTopFrame) ? new Rectangle(textureFrame.x, textureFrame.y, this._leftWidth, this._topHeight) : null;
			this._topLeft = Texture.fromTexture(texture, topLeftRegion, topLeftFrame);
			
			const topCenterRegion:Rectangle = new Rectangle(regionLeftWidth, 0, this._centerWidth, regionTopHeight);
			const topCenterFrame:Rectangle = hasTopFrame ? new Rectangle(0, textureFrame.y, this._centerWidth, this._topHeight) : null;
			this._topCenter = Texture.fromTexture(texture, topCenterRegion, topCenterFrame);
			
			const topRightRegion:Rectangle = new Rectangle(regionLeftWidth + this._centerWidth, 0, regionRightWidth, regionTopHeight);
			const topRightFrame:Rectangle = (hasTopFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, this._rightWidth, this._topHeight) : null;
			this._topRight = Texture.fromTexture(texture, topRightRegion, topRightFrame);
			
			const middleLeftRegion:Rectangle = new Rectangle(0, regionTopHeight, regionLeftWidth, this._middleHeight);
			const middleLeftFrame:Rectangle = hasLeftFrame ? new Rectangle(textureFrame.x, 0, this._leftWidth, this._middleHeight) : null;
			this._middleLeft = Texture.fromTexture(texture, middleLeftRegion, middleLeftFrame);
			
			const middleCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight, this._centerWidth, this._middleHeight);
			this._middleCenter = Texture.fromTexture(texture, middleCenterRegion);
			
			const middleRightRegion:Rectangle = new Rectangle(regionLeftWidth + this._centerWidth, regionTopHeight, regionRightWidth, this._middleHeight);
			const middleRightFrame:Rectangle = hasRightFrame ? new Rectangle(0, 0, this._rightWidth, this._middleHeight) : null;
			this._middleRight = Texture.fromTexture(texture, middleRightRegion, middleRightFrame);
			
			const bottomLeftRegion:Rectangle = new Rectangle(0, regionTopHeight + this._middleHeight, regionLeftWidth, regionBottomHeight);
			const bottomLeftFrame:Rectangle = (hasLeftFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, this._leftWidth, this._bottomHeight) : null;
			this._bottomLeft = Texture.fromTexture(texture, bottomLeftRegion, bottomLeftFrame);
			
			const bottomCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight + this._middleHeight, this._centerWidth, regionBottomHeight);
			const bottomCenterFrame:Rectangle = hasBottomFrame ? new Rectangle(0, 0, this._centerWidth, this._bottomHeight) : null;
			this._bottomCenter = Texture.fromTexture(texture, bottomCenterRegion, bottomCenterFrame);
			
			const bottomRightRegion:Rectangle = new Rectangle(regionLeftWidth + this._centerWidth, regionTopHeight + this._middleHeight, regionRightWidth, regionBottomHeight);
			const bottomRightFrame:Rectangle = (hasBottomFrame || hasRightFrame) ? new Rectangle(0, 0, this._rightWidth, this._bottomHeight) : null;
			this._bottomRight = Texture.fromTexture(texture, bottomRightRegion, bottomRightFrame);
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if(this._propertiesChanged || this._layoutChanged)
			{
				this._batch.reset();

				if(!helperImage)
				{
					helperImage = new starling.display.Image(this._topLeft);
				}
				helperImage.smoothing = this._smoothing;
				helperImage.color = this._color;

				const scaledLeftWidth:Number = this._leftWidth * this._textureScale;
				const scaledTopHeight:Number = this._topHeight * this._textureScale;
				const scaledRightWidth:Number = this._rightWidth * this._textureScale;
				const scaledBottomHeight:Number = this._bottomHeight * this._textureScale;
				const scaledCenterWidth:Number = this._width - scaledLeftWidth - scaledRightWidth;
				const scaledMiddleHeight:Number = this._height - scaledTopHeight - scaledBottomHeight;

				if(scaledTopHeight > 0)
				{
					helperImage.texture = this._topLeft;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth - helperImage.width;
					helperImage.y = scaledTopHeight - helperImage.height;
					if(scaledLeftWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._topCenter;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth;
					helperImage.y = scaledTopHeight - helperImage.height;
					helperImage.width = scaledCenterWidth;
					if(scaledCenterWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._topRight;
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
					helperImage.texture = this._middleLeft;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth - helperImage.width;
					helperImage.y = scaledTopHeight;
					helperImage.height = scaledMiddleHeight;
					if(scaledLeftWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._middleCenter;
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

					helperImage.texture = this._middleRight;
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
					helperImage.texture = this._bottomLeft;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth - helperImage.width;
					helperImage.y = this._height - scaledBottomHeight;
					if(scaledLeftWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._bottomCenter;
					helperImage.readjustSize();
					helperImage.scaleX = helperImage.scaleY = this._textureScale;
					helperImage.x = scaledLeftWidth;
					helperImage.y = this._height - scaledBottomHeight;
					helperImage.width = scaledCenterWidth;
					if(scaledCenterWidth > 0)
					{
						this._batch.addImage(helperImage);
					}

					helperImage.texture = this._bottomRight;
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
			super.render(support, parentAlpha);
		}

		/**
		 * @private
		 */
		private function initializeWidthAndHeight():void
		{
			this.width = (this._leftWidth + this._centerWidth + this._rightWidth) * this._textureScale;
			this.height = (this._topHeight + this._middleHeight + this._bottomHeight) * this._textureScale;
		}
	}
}