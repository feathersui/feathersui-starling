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
	import flash.geom.Rectangle;
	
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class Scale9Image extends Sprite
	{
		public function Scale9Image(texture:Texture, scale9Grid:Rectangle)
		{
			super();
			this._scale9Grid = scale9Grid;
			this.saveWidthAndHeight(texture);
			this.createImages(texture);
			
			this.refreshLayout();
		}
		
		private var _width:Number = NaN;
		
		override public function get width():Number
		{
			return this._width;
		}
		
		override public function set width(value:Number):void
		{
			if(this._width == value)
			{
				return;
			}
			this._width = value;
			this.refreshLayout();
		}
		
		private var _height:Number = NaN;
		
		override public function get height():Number
		{
			return this._height;
		}
		
		override public function set height(value:Number):void
		{
			if(this._height == value)
			{
				return;
			}
			this._height = value;
			this.refreshLayout();
		}
		
		private var _textureScale:Number = 1;

		public function get textureScale():Number
		{
			return this._textureScale;
		}

		public function set textureScale(value:Number):void
		{
			if(this._textureScale == value)
			{
				return;
			}
			this._textureScale = value;
			this.refreshLayout();
		}
		
		private var _scale9Grid:Rectangle;
		private var _leftWidth:Number;
		private var _centerWidth:Number;
		private var _rightWidth:Number;
		private var _topHeight:Number;
		private var _middleHeight:Number;
		private var _bottomHeight:Number;
		
		private var _topLeftImage:Image;
		private var _topCenterImage:Image;
		private var _topRightImage:Image;
		
		private var _middleLeftImage:Image;
		private var _middleCenterImage:Image;
		private var _middleRightImage:Image;
		
		private var _bottomLeftImage:Image;
		private var _bottomCenterImage:Image;
		private var _bottomRightImage:Image;
		
		private function saveWidthAndHeight(texture:Texture):void
		{
			const textureFrame:Rectangle = texture.frame;
			this._leftWidth = this._scale9Grid.x;
			this._centerWidth = this._scale9Grid.width;
			this._rightWidth = textureFrame.width - this._scale9Grid.width - this._scale9Grid.x;
			this._topHeight = this._scale9Grid.y;
			this._middleHeight = this._scale9Grid.height;
			this._bottomHeight = textureFrame.height - this._scale9Grid.height - this._scale9Grid.y;
		}
		
		private function createImages(texture:Texture):void
		{
			//start by creating the subtextures
			
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
			const topLeft:Texture = Texture.fromTexture(texture, topLeftRegion, topLeftFrame);
			
			const topCenterRegion:Rectangle = new Rectangle(regionLeftWidth, 0, this._centerWidth, regionTopHeight);
			const topCenterFrame:Rectangle = hasTopFrame ? new Rectangle(0, textureFrame.y, this._centerWidth, this._topHeight) : null;
			const topCenter:Texture = Texture.fromTexture(texture, topCenterRegion, topCenterFrame);
			
			const topRightRegion:Rectangle = new Rectangle(regionLeftWidth + this._centerWidth, 0, regionRightWidth, regionTopHeight);
			const topRightFrame:Rectangle = (hasTopFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, this._rightWidth, this._topHeight) : null;
			const topRight:Texture = Texture.fromTexture(texture, topRightRegion, topRightFrame);
			
			const middleLeftRegion:Rectangle = new Rectangle(0, regionTopHeight, regionLeftWidth, this._middleHeight);
			const middleLeftFrame:Rectangle = hasLeftFrame ? new Rectangle(textureFrame.x, 0, this._leftWidth, this._middleHeight) : null;
			const middleLeft:Texture = Texture.fromTexture(texture, middleLeftRegion, middleLeftFrame);
			
			const middleCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight, this._centerWidth, this._middleHeight);
			const middleCenter:Texture = Texture.fromTexture(texture, middleCenterRegion);
			
			const middleRightRegion:Rectangle = new Rectangle(regionLeftWidth + this._centerWidth, regionTopHeight, regionRightWidth, this._middleHeight);
			const middleRightFrame:Rectangle = hasRightFrame ? new Rectangle(0, 0, this._rightWidth, this._middleHeight) : null;
			const middleRight:Texture = Texture.fromTexture(texture, middleRightRegion, middleRightFrame);
			
			const bottomLeftRegion:Rectangle = new Rectangle(0, regionTopHeight + this._middleHeight, regionLeftWidth, regionBottomHeight);
			const bottomLeftFrame:Rectangle = (hasLeftFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, this._leftWidth, this._bottomHeight) : null;
			const bottomLeft:Texture = Texture.fromTexture(texture, bottomLeftRegion, bottomLeftFrame);
			
			const bottomCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight + this._middleHeight, this._centerWidth, regionBottomHeight);
			const bottomCenterFrame:Rectangle = hasBottomFrame ? new Rectangle(0, 0, this._centerWidth, this._bottomHeight) : null;
			const bottomCenter:Texture = Texture.fromTexture(texture, bottomCenterRegion, bottomCenterFrame);
			
			const bottomRightRegion:Rectangle = new Rectangle(regionLeftWidth + this._centerWidth, regionTopHeight + this._middleHeight, regionRightWidth, regionBottomHeight);
			const bottomRightFrame:Rectangle = (hasBottomFrame || hasRightFrame) ? new Rectangle(0, 0, this._rightWidth, this._bottomHeight) : null;
			const bottomRight:Texture = Texture.fromTexture(texture, bottomRightRegion, bottomRightFrame);
			
			//then pass them to the images
			this._topLeftImage = new Image(topLeft);
			this._topLeftImage.smoothing = TextureSmoothing.NONE;
			this.addChild(this._topLeftImage);
			this._topCenterImage = new Image(topCenter);
			this._topCenterImage.smoothing = TextureSmoothing.NONE;
			this.addChild(this._topCenterImage);
			this._topRightImage = new Image(topRight);
			this._topRightImage.smoothing = TextureSmoothing.NONE;
			this.addChild(this._topRightImage);
			
			this._middleLeftImage = new Image(middleLeft);
			this._middleLeftImage.smoothing = TextureSmoothing.NONE;
			this.addChild(this._middleLeftImage);
			this._middleCenterImage = new Image(middleCenter);
			this._middleCenterImage.smoothing = TextureSmoothing.NONE;
			this.addChild(this._middleCenterImage);
			this._middleRightImage = new Image(middleRight);
			this._middleRightImage.smoothing = TextureSmoothing.NONE;
			this.addChild(this._middleRightImage);
			
			this._bottomLeftImage = new Image(bottomLeft);
			this._bottomLeftImage.smoothing = TextureSmoothing.NONE;
			this.addChild(this._bottomLeftImage);
			this._bottomCenterImage = new Image(bottomCenter);
			this._bottomCenterImage.smoothing = TextureSmoothing.NONE;
			this.addChild(this._bottomCenterImage);
			this._bottomRightImage = new Image(bottomRight);
			this._bottomRightImage.smoothing = TextureSmoothing.NONE;
			this.addChild(this._bottomRightImage);
		}

		private function refreshLayout():void
		{
			const scaledLeftWidth:Number = this._leftWidth * this._textureScale;
			const scaledTopHeight:Number = this._topHeight * this._textureScale;
			const scaledRightWidth:Number = this._rightWidth * this._textureScale;
			const scaledBottomHeight:Number = this._bottomHeight * this._textureScale;
			if(isNaN(this._width))
			{
				this._width = this._leftWidth + this._centerWidth + this._rightWidth * this._textureScale;
			}
			
			if(isNaN(this._height))
			{
				this._height = this._topHeight + this._middleHeight + this._bottomHeight * this._textureScale;
			}
			
			this._topLeftImage.scaleX = this._topLeftImage.scaleY = this._textureScale;
			this._topLeftImage.x = scaledLeftWidth - this._topLeftImage.width;
			this._topLeftImage.y = scaledTopHeight - this._topLeftImage.height;
			this._topCenterImage.scaleX = this._topCenterImage.scaleY = this._textureScale;
			this._topCenterImage.x = scaledLeftWidth;
			this._topCenterImage.y = scaledTopHeight - this._topCenterImage.height;
			this._topCenterImage.width = Math.max(0, this._width - scaledLeftWidth - scaledRightWidth);
			this._topRightImage.scaleX = this._topRightImage.scaleY = this._textureScale;
			this._topRightImage.x = this._width - scaledRightWidth;
			this._topRightImage.y = scaledTopHeight - this._topRightImage.height;
			
			this._middleLeftImage.scaleX = this._middleLeftImage.scaleY = this._textureScale;
			this._middleLeftImage.x = scaledLeftWidth - this._middleLeftImage.width;
			this._middleLeftImage.y = scaledTopHeight;
			this._middleLeftImage.height = Math.max(0, this._height - scaledTopHeight - scaledBottomHeight);
			this._middleCenterImage.scaleX = this._middleCenterImage.scaleY = this._textureScale;
			this._middleCenterImage.x = scaledLeftWidth;
			this._middleCenterImage.y = scaledTopHeight;
			this._middleCenterImage.width = Math.max(0, this._width - scaledLeftWidth - scaledRightWidth);
			this._middleCenterImage.height = Math.max(0, this._height - scaledTopHeight - scaledBottomHeight);
			this._middleRightImage.x = this._width - scaledRightWidth;
			this._middleRightImage.scaleX = this._middleRightImage.scaleY = this._textureScale;
			this._middleRightImage.y = scaledTopHeight;
			this._middleRightImage.height = Math.max(0, this._height - scaledTopHeight - scaledBottomHeight);
			
			this._bottomLeftImage.scaleX = this._bottomLeftImage.scaleY = this._textureScale;
			this._bottomLeftImage.x = scaledLeftWidth - this._bottomLeftImage.width;
			this._bottomLeftImage.y = this._height - scaledBottomHeight;
			this._bottomCenterImage.scaleX = this._bottomCenterImage.scaleY = this._textureScale;
			this._bottomCenterImage.x = scaledLeftWidth;
			this._bottomCenterImage.y = this._height - scaledBottomHeight;
			this._bottomCenterImage.width = Math.max(0, this._width - scaledLeftWidth - scaledRightWidth);
			this._bottomRightImage.scaleX = this._bottomRightImage.scaleY = this._textureScale;
			this._bottomRightImage.x = this._width - scaledRightWidth;
			this._bottomRightImage.y = this._height - scaledBottomHeight;
		}
	}
}