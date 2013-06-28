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
	 * A set of three textures used by <code>Scale3Image</code>.
	 *
	 * @see org.josht.starling.display.Scale3Image
	 */
	public final class Scale3Textures
	{
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
		public function Scale3Textures(texture:Texture, firstRegionSize:Number, secondRegionSize:Number, direction:String = DIRECTION_HORIZONTAL)
		{
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
			const textureFrame:Rectangle = texture.frame;
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
				const regionTopHeight:Number = this._firstRegionSize + textureFrame.y;
				const regionBottomHeight:Number = thirdRegionSize - (textureFrame.height - texture.height) - textureFrame.y;

				var hasTopFrame:Boolean = regionTopHeight != this._firstRegionSize;
				var hasRightFrame:Boolean = (textureFrame.width - textureFrame.x) != texture.width;
				var hasBottomFrame:Boolean = regionBottomHeight != thirdRegionSize;
				var hasLeftFrame:Boolean = textureFrame.x != 0;

				var firstRegion:Rectangle = new Rectangle(0, 0, texture.width, regionTopHeight);
				var firstFrame:Rectangle = (hasLeftFrame || hasRightFrame || hasTopFrame) ? new Rectangle(textureFrame.x, textureFrame.y, textureFrame.width, this._firstRegionSize) : null;
				this._first = Texture.fromTexture(texture, firstRegion, firstFrame);

				var secondRegion:Rectangle = new Rectangle(0, regionTopHeight, texture.width, this._secondRegionSize);
				var secondFrame:Rectangle = (hasLeftFrame || hasRightFrame) ? new Rectangle(textureFrame.x, 0, textureFrame.width, this._secondRegionSize) : null;
				this._second = Texture.fromTexture(texture, secondRegion, secondFrame);

				var thirdRegion:Rectangle = new Rectangle(0, regionTopHeight + this._secondRegionSize, texture.width, regionBottomHeight);
				var thirdFrame:Rectangle = (hasLeftFrame || hasRightFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, 0, textureFrame.width, thirdRegionSize) : null;
				this._third = Texture.fromTexture(texture, thirdRegion, thirdFrame);
			}
			else //horizontal
			{
				const regionLeftWidth:Number = this._firstRegionSize + textureFrame.x;
				const regionRightWidth:Number = thirdRegionSize - (textureFrame.width - texture.width) - textureFrame.x;

				hasTopFrame = textureFrame.y != 0;
				hasRightFrame = regionRightWidth != thirdRegionSize;
				hasBottomFrame = (textureFrame.height - textureFrame.y) != texture.height;
				hasLeftFrame = regionLeftWidth != this._firstRegionSize;

				firstRegion = new Rectangle(0, 0, regionLeftWidth, texture.height);
				firstFrame = (hasLeftFrame || hasTopFrame || hasBottomFrame) ? new Rectangle(textureFrame.x, textureFrame.y, this._firstRegionSize, textureFrame.height) : null;
				this._first = Texture.fromTexture(texture, firstRegion, firstFrame);

				secondRegion = new Rectangle(regionLeftWidth, 0, this._secondRegionSize, texture.height);
				secondFrame = (hasTopFrame || hasBottomFrame) ? new Rectangle(0, textureFrame.y, this._secondRegionSize, textureFrame.height) : null;
				this._second = Texture.fromTexture(texture, secondRegion, secondFrame);

				thirdRegion = new Rectangle(regionLeftWidth + this._secondRegionSize, 0, regionRightWidth, texture.height);
				thirdFrame = (hasTopFrame || hasBottomFrame || hasRightFrame) ? new Rectangle(0, textureFrame.y, thirdRegionSize, textureFrame.height) : null;
				this._third = Texture.fromTexture(texture, thirdRegion, thirdFrame);
			}
		}
	}
}
