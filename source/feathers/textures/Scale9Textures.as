/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.textures
{
	import flash.geom.Rectangle;

	import starling.textures.Texture;

	/**
	 * Slices a Starling Texture into nine regions to be used by <code>Scale9Image</code>.
	 *
	 * @see feathers.display.Scale9Image
	 */
	public final class Scale9Textures
	{
		/**
		 * @private
		 */
		private static const ZERO_WIDTH_ERROR:String = "The width of the scale9Grid must be greater than zero.";

		/**
		 * @private
		 */
		private static const ZERO_HEIGHT_ERROR:String = "The height of the scale9Grid must be greater than zero.";

		/**
		 * @private
		 */
		private static const SUM_X_REGIONS_ERROR:String = "The sum of the x and width properties of the scale9Grid must be less than or equal to the width of the texture.";

		/**
		 * @private
		 */
		private static const SUM_Y_REGIONS_ERROR:String = "The sum of the y and height properties of the scale9Grid must be less than or equal to the height of the texture.";

		/**
		 * @private
		 */
		private static const HELPER_RECTANGLE:Rectangle = new Rectangle();

		/**
		 * Constructor.
		 *
		 * @param texture		A Starling Texture to slice up into nine regions. It is recommended to turn of mip-maps for best rendering results.
		 * @param scale9Grid	The rectangle defining the region in the horizontal center and vertical middle, with other regions being calculated automatically. This value should be based on the original texture dimensions, with no adjustments for scale factor.
		 */
		public function Scale9Textures(texture:Texture, scale9Grid:Rectangle)
		{
			if(scale9Grid.width <= 0)
			{
				throw new ArgumentError(ZERO_WIDTH_ERROR);
			}
			if(scale9Grid.height <= 0)
			{
				throw new ArgumentError(ZERO_HEIGHT_ERROR);
			}
			var textureFrame:Rectangle = texture.frame;
			if(!textureFrame)
			{
				textureFrame = HELPER_RECTANGLE;
				textureFrame.setTo(0, 0, texture.width, texture.height);
			}
			if((scale9Grid.x + scale9Grid.width) > textureFrame.width)
			{
				throw new ArgumentError(SUM_X_REGIONS_ERROR);
			}
			if((scale9Grid.y + scale9Grid.height) > textureFrame.height)
			{
				throw new ArgumentError(SUM_Y_REGIONS_ERROR);
			}
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
			var textureFrame:Rectangle = this._texture.frame;
			if(!textureFrame)
			{
				textureFrame = HELPER_RECTANGLE;
				textureFrame.setTo(0, 0, this._texture.width, this._texture.height);
			}
			var leftWidth:Number = this._scale9Grid.x;
			var centerWidth:Number = this._scale9Grid.width;
			var rightWidth:Number = textureFrame.width - this._scale9Grid.width - this._scale9Grid.x;
			var topHeight:Number = this._scale9Grid.y;
			var middleHeight:Number = this._scale9Grid.height;
			var bottomHeight:Number = textureFrame.height - this._scale9Grid.height - this._scale9Grid.y;

			var regionLeftWidth:Number = leftWidth + textureFrame.x;
			var regionTopHeight:Number = topHeight + textureFrame.y;
			var regionRightWidth:Number = rightWidth - (textureFrame.width - this._texture.width) - textureFrame.x;
			var regionBottomHeight:Number = bottomHeight - (textureFrame.height - this._texture.height) - textureFrame.y;

			var hasLeftFrame:Boolean = regionLeftWidth != leftWidth;
			var hasTopFrame:Boolean = regionTopHeight != topHeight;
			var hasRightFrame:Boolean = regionRightWidth != rightWidth;
			var hasBottomFrame:Boolean = regionBottomHeight != bottomHeight;

			var topLeftRegion:Rectangle = new Rectangle(0, 0, regionLeftWidth, regionTopHeight);
			var topLeftFrame:Rectangle = (hasLeftFrame || hasTopFrame) ? new Rectangle(textureFrame.x, textureFrame.y, leftWidth, topHeight) : null;
			this._topLeft = Texture.fromTexture(this._texture, topLeftRegion, topLeftFrame);

			var topCenterRegion:Rectangle = new Rectangle(regionLeftWidth, 0, centerWidth, regionTopHeight);
			var topCenterFrame:Rectangle = hasTopFrame ? new Rectangle(0, textureFrame.y, centerWidth, topHeight) : null;
			this._topCenter = Texture.fromTexture(this._texture, topCenterRegion, topCenterFrame);

			var topRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, 0, regionRightWidth, regionTopHeight);
			var topRightFrame:Rectangle = (hasTopFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, rightWidth, topHeight) : null;
			this._topRight = Texture.fromTexture(this._texture, topRightRegion, topRightFrame);

			var middleLeftRegion:Rectangle = new Rectangle(0, regionTopHeight, regionLeftWidth, middleHeight);
			var middleLeftFrame:Rectangle = hasLeftFrame ? new Rectangle(textureFrame.x, 0, leftWidth, middleHeight) : null;
			this._middleLeft = Texture.fromTexture(this._texture, middleLeftRegion, middleLeftFrame);

			var middleCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight, centerWidth, middleHeight);
			this._middleCenter = Texture.fromTexture(this._texture, middleCenterRegion);

			var middleRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight, regionRightWidth, middleHeight);
			var middleRightFrame:Rectangle = hasRightFrame ? new Rectangle(0, 0, rightWidth, middleHeight) : null;
			this._middleRight = Texture.fromTexture(this._texture, middleRightRegion, middleRightFrame);

			var bottomLeftRegion:Rectangle = new Rectangle(0, regionTopHeight + middleHeight, regionLeftWidth, regionBottomHeight);
			var bottomLeftFrame:Rectangle = (hasLeftFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, leftWidth, bottomHeight) : null;
			this._bottomLeft = Texture.fromTexture(this._texture, bottomLeftRegion, bottomLeftFrame);

			var bottomCenterRegion:Rectangle = new Rectangle(regionLeftWidth, regionTopHeight + middleHeight, centerWidth, regionBottomHeight);
			var bottomCenterFrame:Rectangle = hasBottomFrame ? new Rectangle(0, 0, centerWidth, bottomHeight) : null;
			this._bottomCenter = Texture.fromTexture(this._texture, bottomCenterRegion, bottomCenterFrame);

			var bottomRightRegion:Rectangle = new Rectangle(regionLeftWidth + centerWidth, regionTopHeight + middleHeight, regionRightWidth, regionBottomHeight);
			var bottomRightFrame:Rectangle = (hasBottomFrame || hasRightFrame) ? new Rectangle(0, 0, rightWidth, bottomHeight) : null;
			this._bottomRight = Texture.fromTexture(this._texture, bottomRightRegion, bottomRightFrame);
		}
	}
}
