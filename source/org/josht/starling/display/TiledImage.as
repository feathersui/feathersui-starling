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
	
	import starling.display.DisplayObject;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.transformCoords;

	/**
	 * Tiles a texture to fill, and possibly overflow, the specified bounds. May
	 * be clipped.
	 */
	public class TiledImage extends Sprite
	{
		private static var helperPoint:Point = new Point();
		private static var helperMatrix:Matrix = new Matrix();
		
		/**
		 * Constructor.
		 */
		public function TiledImage(texture:Texture)
		{
			super();
			this._hitArea = new Rectangle();
			this.texture = texture;
		}
		
		private var _hitArea:Rectangle;
		
		private var _imageContainer:Sprite;
		private var _images:Vector.<Image> = new <Image>[];
		
		/**
		 * @private
		 */
		private var _width:Number = 100;
		
		/**
		 * @inheritDoc
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
			this.refreshImages();
		}
		
		/**
		 * @private
		 */
		private var _height:Number = 100;
		
		/**
		 * @inheritDoc
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
			this.refreshImages();
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
			else if(value != this._texture)
			{
				this._texture = value;
				this.refreshImages();
			}
		}
		
		/**
		 * @private
		 */
		private var _smoothing:String = TextureSmoothing.BILINEAR;
		
		/**
		 * The smoothing value to pass to the tiled images.
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
				throw new ArgumentError("Invalid smoothing mode: " + smoothing);
			}
			this.refreshImageProperties();
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
			this.refreshImages();
		}
		
		/**
		 * @private
		 */
		private var _clipContent:Boolean = false;
		
		/**
		 * Determines if the tiled content should be clipped to the width and
		 * height.
		 */
		public function get clipContent():Boolean
		{
			return this._clipContent;
		}
		
		/**
		 * @private
		 */
		public function set clipContent(value:Boolean):void
		{
			if(this._clipContent == value)
			{
				return;
			}
			this._clipContent = value;
			this.refreshScrollRect();
		}
		
		/**
		* @inheritDoc
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
				maxX = this._hitArea.width;
				maxY = this._hitArea.height;
			}
			else
			{
				getTransformationMatrix(targetSpace, helperMatrix);
				
				transformCoords(helperMatrix, this._hitArea.x, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
				
				transformCoords(helperMatrix, this._hitArea.x, this._hitArea.height, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
				
				transformCoords(helperMatrix, this._hitArea.width, this._hitArea.y, helperPoint);
				minX = minX < helperPoint.x ? minX : helperPoint.x;
				maxX = maxX > helperPoint.x ? maxX : helperPoint.x;
				minY = minY < helperPoint.y ? minY : helperPoint.y;
				maxY = maxY > helperPoint.y ? maxY : helperPoint.y;
				
				transformCoords(helperMatrix, this._hitArea.width, this._hitArea.height, helperPoint);
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
		 * @inheritDoc
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
			this._width = width;
			this._height = height;
			this.refreshImages();
		}
		
		/**
		 * @private
		 */
		private function refreshImages():void
		{
			const scaledTextureWidth:Number = this._texture.width * this._textureScale;
			const scaledTextureHeight:Number = this._texture.height * this._textureScale;
			const xImageCount:int = Math.ceil(this._width / scaledTextureWidth);
			const yImageCount:int = Math.ceil(this._height / scaledTextureHeight);
			const imageCount:int = xImageCount * yImageCount;
			const loopCount:int = Math.max(this._images.length, imageCount);
			
			for(var i:int = 0; i < loopCount; i++)
			{
				if(i < imageCount && this._images.length < imageCount)
				{
					var image:Image = new Image(this._texture);
					image.touchable = false;
					this.addChild(image);
					this._images.push(image);
				}
				else if(i >= imageCount)
				{
					image = this._images.pop();
					image.removeFromParent(true);
				}
				else
				{
					image = this._images[i];
					image.texture = this._texture;
				}
			}
			
			this.refreshImageProperties();
			this.refreshLayout();
		}
		
		/**
		 * @private
		 */
		private function refreshImageProperties():void
		{
			for each(var image:Image in this._images)
			{
				image.smoothing = this._smoothing;
			}
		}
		
		/**
		 * @private
		 */
		private function refreshLayout():void
		{
			const scaledTextureWidth:Number = this._texture.width * this._textureScale;
			const scaledTextureHeight:Number = this._texture.height * this._textureScale;
			var xPosition:Number = 0;
			var yPosition:Number = 0;
			const imageCount:int = this._images.length;
			for(var i:int = 0; i < imageCount; i++)
			{
				var image:Image = this._images[i];
				image.x = xPosition;
				image.y = yPosition;
				image.scaleX = image.scaleY = this._textureScale;
				xPosition += scaledTextureWidth;
				if(xPosition >= this._width)
				{
					xPosition = 0;
					yPosition += scaledTextureHeight;
				}
			}
			
			this.refreshScrollRect();
		}
		
		/**
		 * @private
		 */
		private function refreshScrollRect():void
		{
			if(this._clipContent)
			{
				var scrollRect:Rectangle = this.scrollRect;
				if(!scrollRect)
				{
					scrollRect = new Rectangle();
				}
				scrollRect.width = this._width;
				scrollRect.height = this._height;
				this.scrollRect = scrollRect;
			}
			else
			{
				this.scrollRect = null;
			}
		}
	}
}