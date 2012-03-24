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
			this.saveWidthAndHeight(texture, scale9Grid);
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
		
		private function saveWidthAndHeight(texture:Texture, scale9Grid:Rectangle):void
		{
			const textureFrame:Rectangle = texture.frame;
			this._leftWidth = scale9Grid.x;
			this._centerWidth = scale9Grid.width;
			this._rightWidth = textureFrame.width - scale9Grid.width - scale9Grid.x;
			this._topHeight = scale9Grid.y;
			this._middleHeight = scale9Grid.height;
			this._bottomHeight = textureFrame.height - scale9Grid.height - scale9Grid.y;
		}
		
		private function createImages(texture:Texture):void
		{
			//start by creating the subtextures
			const topLeftRegion:Rectangle = new Rectangle(0, 0, this._leftWidth, this._topHeight);
			const topLeft:Texture = Texture.fromTexture(texture, topLeftRegion);
			const topCenterRegion:Rectangle = new Rectangle(this._leftWidth, 0, this._centerWidth, this._topHeight);
			const topCenter:Texture = Texture.fromTexture(texture, topCenterRegion);
			const topRightRegion:Rectangle = new Rectangle(this._leftWidth + this._centerWidth, 0, this._rightWidth, this._topHeight);
			const topRight:Texture = Texture.fromTexture(texture, topRightRegion);
			
			const middleLeftRegion:Rectangle = new Rectangle(0, this._topHeight, this._leftWidth, this._middleHeight);
			const middleLeft:Texture = Texture.fromTexture(texture, middleLeftRegion);
			const middleCenterRegion:Rectangle = new Rectangle(this._leftWidth, this._topHeight, this._centerWidth, this._middleHeight);
			const middleCenter:Texture = Texture.fromTexture(texture, middleCenterRegion);
			const middleRightRegion:Rectangle = new Rectangle(this._leftWidth + this._centerWidth, this._topHeight, this._rightWidth, this._middleHeight);
			const middleRight:Texture = Texture.fromTexture(texture, middleRightRegion);
			
			const bottomLeftRegion:Rectangle = new Rectangle(0, this._topHeight + this._middleHeight, this._leftWidth, this._bottomHeight);
			const bottomLeft:Texture = Texture.fromTexture(texture, bottomLeftRegion);
			const bottomCenterRegion:Rectangle = new Rectangle(this._leftWidth, this._topHeight + this._middleHeight, this._centerWidth, this._bottomHeight);
			const bottomCenter:Texture = Texture.fromTexture(texture, bottomCenterRegion);
			const bottomRightRegion:Rectangle = new Rectangle(this._leftWidth + this._centerWidth, this._topHeight + this._middleHeight, this._rightWidth, this._bottomHeight);
			const bottomRight:Texture = Texture.fromTexture(texture, bottomRightRegion);
			
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
			if(isNaN(this._width))
			{
				this._width = this._leftWidth + this._centerWidth + this._rightWidth;
			}
			
			if(isNaN(this._height))
			{
				this._height = this._topHeight + this._middleHeight + this._bottomHeight;
			}
			
			this._topLeftImage.x = this._leftWidth - this._topLeftImage.width;
			this._topLeftImage.y = this._topHeight - this._topLeftImage.height;
			this._topCenterImage.x = this._leftWidth;
			this._topCenterImage.y = this._topHeight - this._topCenterImage.height;
			this._topCenterImage.width = Math.max(0, this._width - this._leftWidth - this._rightWidth);
			this._topRightImage.x = this._width - this._rightWidth;
			this._topRightImage.y = this._topHeight - this._topRightImage.height;
			
			this._middleLeftImage.x = this._leftWidth - this._middleLeftImage.width;
			this._middleLeftImage.y = this._topHeight;
			this._middleLeftImage.height = Math.max(0, this._height - this._topHeight - this._bottomHeight);
			this._middleCenterImage.x = this._leftWidth;
			this._middleCenterImage.y = this._topHeight;
			this._middleCenterImage.width = Math.max(0, this._width - this._leftWidth - this._rightWidth);
			this._middleCenterImage.height = Math.max(0, this._height - this._topHeight - this._bottomHeight);
			this._middleRightImage.x = this._width - this._rightWidth;
			this._middleRightImage.y = this._topHeight;
			this._middleRightImage.height = Math.max(0, this._height - this._topHeight - this._bottomHeight);
			
			this._bottomLeftImage.x = this._leftWidth - this._bottomLeftImage.width;
			this._bottomLeftImage.y = this._height - this._bottomHeight;
			this._bottomCenterImage.x = this._leftWidth;
			this._bottomCenterImage.y = this._height - this._bottomHeight;
			this._bottomCenterImage.width = Math.max(0, this._width - this._leftWidth - this._rightWidth);
			this._bottomRightImage.x = this._width - this._rightWidth;
			this._bottomRightImage.y = this._height - this._bottomHeight;
		}
	}
}