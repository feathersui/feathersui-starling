/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.textures
{
	import flash.geom.Rectangle;

	import starling.textures.Texture;

	/**
	 * Slices a Starling Texture into three regions to be used by <code>Scale3Image</code>.
	 *
	 * @see feathers.display.Scale3Image
	 */
	public final class Scale3Textures
	{
		/**
		 * @private
		 */
		private static const SECOND_REGION_ERROR:String = "The size of the second region must be greater than zero.";

		/**
		 * @private
		 */
		private static const SUM_X_REGIONS_ERROR:String = "The combined height of the first and second regions must be less than or equal to the width of the texture.";

		/**
		 * @private
		 */
		private static const SUM_Y_REGIONS_ERROR:String = "The combined width of the first and second regions must be less than or equal to the height of the texture.";

		/**
		 * If the direction is horizontal, the layout will start on the left and continue to the right.
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * If the direction is vertical, the layout will start on the top and continue to the bottom.
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * @private
		 */
		private static const HELPER_RECTANGLE:Rectangle = new Rectangle();

		/**
		 * Constructor.
		 *
		 * @param texture			A Starling Texture to slice up into three regions. It is recommended to turn of mip-maps for best rendering results.
		 * @param firstRegionSize	The size, in pixels, of the first of the three regions. This value should be based on the original texture dimensions, with no adjustments for scale factor.
		 * @param secondRegionSize	The size, in pixels, of the second of the three regions. This value should be based on the original texture dimensions, with no adjustments for scale factor.
		 * @param direction			Indicates if the regions should be positioned horizontally or vertically.
		 */
		public function Scale3Textures(texture:Texture, firstRegionSize:Number, secondRegionSize:Number, direction:String = DIRECTION_HORIZONTAL)
		{
			if(secondRegionSize <= 0)
			{
				throw new ArgumentError(SECOND_REGION_ERROR);
			}
			var textureFrame:Rectangle = texture.frame;
			if(!textureFrame)
			{
				textureFrame = HELPER_RECTANGLE;
				textureFrame.setTo(0, 0, texture.width, texture.height);
			}
			var sumRegions:Number = firstRegionSize + secondRegionSize;
			if(direction == DIRECTION_HORIZONTAL)
			{
				if(sumRegions > textureFrame.width)
				{
					throw new ArgumentError(SUM_X_REGIONS_ERROR);
				}
			}
			else if(sumRegions > textureFrame.height) //vertical
			{
				throw new ArgumentError(SUM_Y_REGIONS_ERROR);
			}
			this._texture = texture;
			this._firstRegionSize = firstRegionSize;
			this._secondRegionSize = secondRegionSize;
			this._direction = direction;
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
		private var _firstRegionSize:Number;

		/**
		 * The size of the first region, in pixels.
		 */
		public function get firstRegionSize():Number
		{
			return this._firstRegionSize;
		}

		/**
		 * @private
		 */
		private var _secondRegionSize:Number;

		/**
		 * The size of the second region, in pixels.
		 */
		public function get secondRegionSize():Number
		{
			return this._secondRegionSize;
		}

		/**
		 * @private
		 */
		private var _direction:String;

		/**
		 * The direction of the sub-texture layout.
		 *
		 * @default Scale3Textures.DIRECTION_HORIZONTAL
		 *
		 * @see #DIRECTION_HORIZONTAL
		 * @see #DIRECTION_VERTICAL
		 */
		public function get direction():String
		{
			return this._direction;
		}

		/**
		 * @private
		 */
		private var _first:Texture;

		/**
		 * The texture for the first region.
		 */
		public function get first():Texture
		{
			return this._first;
		}

		/**
		 * @private
		 */
		private var _second:Texture;

		/**
		 * The texture for the second region.
		 */
		public function get second():Texture
		{
			return this._second;
		}

		/**
		 * @private
		 */
		private var _third:Texture;

		/**
		 * The texture for the third region.
		 */
		public function get third():Texture
		{
			return this._third;
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
			var thirdRegionSize:Number;
			if(this._direction == DIRECTION_VERTICAL)
			{
				thirdRegionSize = textureFrame.height - this._firstRegionSize - this._secondRegionSize;
			}
			else
			{
				thirdRegionSize = textureFrame.width - this._firstRegionSize - this._secondRegionSize;
			}

			if(this._direction == DIRECTION_VERTICAL)
			{
				var regionTopHeight:Number = this._firstRegionSize + textureFrame.y;
				var regionBottomHeight:Number = thirdRegionSize - (textureFrame.height - this._texture.height) - textureFrame.y;

				var hasTopFrame:Boolean = regionTopHeight != this._firstRegionSize;
				var hasRightFrame:Boolean = (textureFrame.width - textureFrame.x) != this._texture.width;
				var hasBottomFrame:Boolean = regionBottomHeight != thirdRegionSize;
				var hasLeftFrame:Boolean = textureFrame.x != 0;

				var firstRegion:Rectangle = new Rectangle(0, 0, this._texture.width, regionTopHeight);
				var firstFrame:Rectangle = (hasLeftFrame || hasRightFrame || hasTopFrame) ? new Rectangle(textureFrame.x, textureFrame.y, textureFrame.width, this._firstRegionSize) : null;
				this._first = Texture.fromTexture(texture, firstRegion, firstFrame);

				var secondRegion:Rectangle = new Rectangle(0, regionTopHeight, this._texture.width, this._secondRegionSize);
				var secondFrame:Rectangle = (hasLeftFrame || hasRightFrame) ? new Rectangle(textureFrame.x, 0, textureFrame.width, this._secondRegionSize) : null;
				this._second = Texture.fromTexture(texture, secondRegion, secondFrame);

				var thirdRegion:Rectangle = new Rectangle(0, regionTopHeight + this._secondRegionSize, this._texture.width, regionBottomHeight);
				var thirdFrame:Rectangle = (hasLeftFrame || hasRightFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, textureFrame.width, thirdRegionSize) : null;
				this._third = Texture.fromTexture(texture, thirdRegion, thirdFrame);
			}
			else //horizontal
			{
				var regionLeftWidth:Number = this._firstRegionSize + textureFrame.x;
				var regionRightWidth:Number = thirdRegionSize - (textureFrame.width - this._texture.width) - textureFrame.x;

				hasTopFrame = textureFrame.y != 0;
				hasRightFrame = regionRightWidth != thirdRegionSize;
				hasBottomFrame = (textureFrame.height - textureFrame.y) != this._texture.height;
				hasLeftFrame = regionLeftWidth != this._firstRegionSize;

				firstRegion = new Rectangle(0, 0, regionLeftWidth, this._texture.height);
				firstFrame = (hasLeftFrame || hasTopFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, textureFrame.y, this._firstRegionSize, textureFrame.height) : null;
				this._first = Texture.fromTexture(texture, firstRegion, firstFrame);

				secondRegion = new Rectangle(regionLeftWidth, 0, this._secondRegionSize, this._texture.height);
				secondFrame = (hasTopFrame || hasBottomFrame) ? new Rectangle(0, textureFrame.y, this._secondRegionSize, textureFrame.height) : null;
				this._second = Texture.fromTexture(texture, secondRegion, secondFrame);

				thirdRegion = new Rectangle(regionLeftWidth + this._secondRegionSize, 0, regionRightWidth, this._texture.height);
				thirdFrame = (hasTopFrame || hasBottomFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, thirdRegionSize, textureFrame.height) : null;
				this._third = Texture.fromTexture(texture, thirdRegion, thirdFrame);
			}
		}
	}
}
