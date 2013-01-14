/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.textures
{
	import flash.geom.Rectangle;

	import starling.textures.Texture;

	/**
	 * A set of nine textures used by <code>Scale9Image</code>.
	 *
	 * @see org.josht.starling.display.Scale9Image
	 */
	public final class Scale9Textures
	{
		/**
		 * Constructor.
		 */
		public function Scale9Textures(texture:Texture, scale9Grid:Rectangle)
		{
			this._texture = texture;
			this._scale9Grid = scale9Grid;
			this.initialize();
		}

		/**
		 * @private
		 */
		private var _texture:Texture;

		/**
		 * The original texture.
		 */
		public function get texture():Texture
		{
			return this._texture;
		}

		/**
		 * @private
		 */
		private var _scale9Grid:Rectangle;

		/**
		 * The grid representing the nine sub-regions of the texture.
		 */
		public function get scale9Grid():Rectangle
		{
			return this._scale9Grid;
		}

		/**
		 * @private
		 */
		private var _topLeft:Texture;

		/**
		 * The texture for the region in the top Left.
		 */
		public function get topLeft():Texture
		{
			return this._topLeft;
		}

		/**
		 * @private
		 */
		private var _topCenter:Texture;

		/**
		 * The texture for the region in the top center.
		 */
		public function get topCenter():Texture
		{
			return this._topCenter;
		}

		/**
		 * @private
		 */
		private var _topRight:Texture;

		/**
		 * The texture for the region in the top right.
		 */
		public function get topRight():Texture
		{
			return this._topRight;
		}

		/**
		 * @private
		 */
		private var _middleLeft:Texture;

		/**
		 * The texture for the region in the middle left.
		 */
		public function get middleLeft():Texture
		{
			return this._middleLeft;
		}

		/**
		 * @private
		 */
		private var _middleCenter:Texture;

		/**
		 * The texture for the region in the middle center.
		 */
		public function get middleCenter():Texture
		{
			return this._middleCenter;
		}

		/**
		 * @private
		 */
		private var _middleRight:Texture;

		/**
		 * The texture for the region in the middle right.
		 */
		public function get middleRight():Texture
		{
			return this._middleRight;
		}

		/**
		 * @private
		 */
		private var _bottomLeft:Texture;

		/**
		 * The texture for the region in the bottom left.
		 */
		public function get bottomLeft():Texture
		{
			return this._bottomLeft;
		}

		/**
		 * @private
		 */
		private var _bottomCenter:Texture;

		/**
		 * The texture for the region in the bottom center.
		 */
		public function get bottomCenter():Texture
		{
			return this._bottomCenter;
		}

		/**
		 * @private
		 */
		private var _bottomRight:Texture;

		/**
		 * The texture for the region in the bottom right.
		 */
		public function get bottomRight():Texture
		{
			return this._bottomRight;
		}

		/**
		 * @private
		 */
		private function initialize():void
		{
			const textureFrame:Rectangle = this._texture.frame;
			const leftWidth:Number = this._scale9Grid.x;
			const centerWidth:Number = this._scale9Grid.width;
			const rightWidth:Number = textureFrame.width - this._scale9Grid.width - this._scale9Grid.x;
			const topHeight:Number = this._scale9Grid.y;
			const middleHeight:Number = this._scale9Grid.height;
			const bottomHeight:Number = textureFrame.height - this._scale9Grid.height - this._scale9Grid.y;

			const regionLeftWidth:Number = leftWidth + textureFrame.x;
			const regionTopHeight:Number = topHeight + textureFrame.y;
			const regionRightWidth:Number = rightWidth - (textureFrame.width - this._texture.width) - textureFrame.x;
			const regionBottomHeight:Number = bottomHeight - (textureFrame.height - this._texture.height) - textureFrame.y;

			const hasLeftFrame:Boolean = regionLeftWidth != leftWidth;
			const hasTopFrame:Boolean = regionTopHeight != topHeight;
			const hasRightFrame:Boolean = regionRightWidth != rightWidth;
			const hasBottomFrame:Boolean = regionBottomHeight != bottomHeight;

			const topLeftRegion:Rectangle = new Rectangle(0, 0, regionLeftWidth, regionTopHeight);
			const topLeftFrame:Rectangle = (hasLeftFrame || hasTopFrame) ? new Rectangle(textureFrame.x, textureFrame.y, leftWidth, topHeight) : null;
			this._topLeft = Texture.fromTexture(this._texture, topLeftRegion, topLeftFrame);

			const topCenterRegion:Rectangle = new Rectangle(regionLeftWidth, 0, centerWidth, regionTopHeight);
			const topCenterFrame:Rectangle = hasTopFrame ? new Rectangle(0, textureFrame.y, centerWidth, topHeight) : null;
			this._topCenter = Texture.fromTexture(this._texture, topCenterRegion, topCenterFrame);

			const topRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, 0, regionRightWidth, regionTopHeight);
			const topRightFrame:Rectangle = (hasTopFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, rightWidth, topHeight) : null;
			this._topRight = Texture.fromTexture(this._texture, topRightRegion, topRightFrame);

			const middleLeftRegion:Rectangle = new Rectangle(0, regionTopHeight, regionLeftWidth, middleHeight);
			const middleLeftFrame:Rectangle = hasLeftFrame ? new Rectangle(textureFrame.x, 0, leftWidth, middleHeight) : null;
			this._middleLeft = Texture.fromTexture(this._texture, middleLeftRegion, middleLeftFrame);

			const middleCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight, centerWidth, middleHeight);
			this._middleCenter = Texture.fromTexture(this._texture, middleCenterRegion);

			const middleRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight, regionRightWidth, middleHeight);
			const middleRightFrame:Rectangle = hasRightFrame ? new Rectangle(0, 0, rightWidth, middleHeight) : null;
			this._middleRight = Texture.fromTexture(this._texture, middleRightRegion, middleRightFrame);

			const bottomLeftRegion:Rectangle = new Rectangle(0, regionTopHeight + middleHeight, regionLeftWidth, regionBottomHeight);
			const bottomLeftFrame:Rectangle = (hasLeftFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, leftWidth, bottomHeight) : null;
			this._bottomLeft = Texture.fromTexture(this._texture, bottomLeftRegion, bottomLeftFrame);

			const bottomCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight + middleHeight, centerWidth, regionBottomHeight);
			const bottomCenterFrame:Rectangle = hasBottomFrame ? new Rectangle(0, 0, centerWidth, bottomHeight) : null;
			this._bottomCenter = Texture.fromTexture(this._texture, bottomCenterRegion, bottomCenterFrame);

			const bottomRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight + middleHeight, regionRightWidth, regionBottomHeight);
			const bottomRightFrame:Rectangle = (hasBottomFrame || hasRightFrame) ? new Rectangle(0, 0, rightWidth, bottomHeight) : null;
			this._bottomRight = Texture.fromTexture(this._texture, bottomRightRegion, bottomRightFrame);
		}
	}
}
