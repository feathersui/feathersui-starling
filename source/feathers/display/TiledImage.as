/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.display
{
	import feathers.core.IValidating;
	import feathers.core.ValidationQueue;
	import feathers.utils.display.getDisplayObjectDepthFromStage;

	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MeshBatch;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.rendering.Painter;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.MatrixUtil;

	[Exclude(name="numChildren",kind="property")]
	[Exclude(name="addChild",kind="method")]
	[Exclude(name="addChildAt",kind="method")]
	[Exclude(name="broadcastEvent",kind="method")]
	[Exclude(name="broadcastEventWith",kind="method")]
	[Exclude(name="contains",kind="method")]
	[Exclude(name="getChildAt",kind="method")]
	[Exclude(name="getChildByName",kind="method")]
	[Exclude(name="getChildIndex",kind="method")]
	[Exclude(name="removeChild",kind="method")]
	[Exclude(name="removeChildAt",kind="method")]
	[Exclude(name="removeChildren",kind="method")]
	[Exclude(name="setChildIndex",kind="method")]
	[Exclude(name="sortChildren",kind="method")]
	[Exclude(name="swapChildren",kind="method")]
	[Exclude(name="swapChildrenAt",kind="method")]

	/**
	 * Tiles a texture to fill the specified bounds.
	 */
	public class TiledImage extends Sprite implements IValidating
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * Constructor.
		 */
		public function TiledImage(texture:Texture, textureScale:Number = 1)
		{
			super();
			this._hitArea = new Rectangle();
			this._textureScale = textureScale;
			this.texture = texture;
			this.initializeWidthAndHeight();

			this._batch = new MeshBatch();
			this._batch.touchable = false;
			this.addChild(this._batch);

			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private var _propertiesChanged:Boolean = true;
		private var _layoutChanged:Boolean = true;

		private var _hitArea:Rectangle;

		private var _batch:MeshBatch;
		private var _image:Image;

		private var _originalImageWidth:Number;
		private var _originalImageHeight:Number;

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
			this.invalidate();
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
			this.invalidate();
		}

		/**
		 * @private
		 */
		private var _texture:Texture;

		/**
		 * The texture to tile.
		 *
		 * <p>In the following example, the texture is changed:</p>
		 *
		 * <listing version="3.0">
		 * image.texture = Texture.fromBitmapData( bitmapData );</listing>
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
			if(this._texture == value)
			{
				return;
			}
			this._texture = value;
			if(!this._image)
			{
				this._image = new Image(value);
				this._image.touchable = false;
			}
			else
			{
				this._image.texture = value;
				this._image.readjustSize();
			}
			var frame:Rectangle = value.frame;
			if(!frame)
			{
				this._originalImageWidth = value.width;
				this._originalImageHeight = value.height;
			}
			else
			{
				this._originalImageWidth = frame.width;
				this._originalImageHeight = frame.height;
			}
			this._layoutChanged = true;
			this.invalidate();
		}

		/**
		 * @private
		 */
		private var _textureSmoothing:String = TextureSmoothing.BILINEAR;

		/**
		 * The texture smoothing value to pass to the tiled images.
		 *
		 * <p>In the following example, the smoothing is changed:</p>
		 *
		 * <listing version="3.0">
		 * image.textureSmoothing = TextureSmoothing.NONE;</listing>
		 *
		 * @default starling.textures.TextureSmoothing.BILINEAR
		 *
		 * @see http://doc.starling-framework.org/core/starling/textures/TextureSmoothing.html starling.textures.TextureSmoothing
		 */
		public function get textureSmoothing():String
		{
			return this._textureSmoothing;
		}

		/**
		 * @private
		 */
		public function set textureSmoothing(value:String):void
		{
			if(TextureSmoothing.isValid(value))
			{
				this._textureSmoothing = value;
			}
			else
			{
				throw new ArgumentError("Invalid texture smoothing mode: " + value);
			}
			this._propertiesChanged = true;
			this.invalidate();
		}

		/**
		 * @private
		 */
		private var _color:uint = 0xffffff;

		/**
		 * The color value to pass to the tiled images.
		 *
		 * <p>In the following example, the color is changed:</p>
		 *
		 * <listing version="3.0">
		 * image.color = 0xff00ff;</listing>
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
			this.invalidate();
		}

		/**
		 * @private
		 */
		private var _useSeparateBatch:Boolean = true;

		/**
		 * Determines if the tiled images are batched normally by Starling or if
		 * they're batched separately.
		 *
		 * <p>In the following example, separate batching is disabled:</p>
		 *
		 * <listing version="3.0">
		 * image.useSeparateBatch = false;</listing>
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
			this._propertiesChanged = true;
			this.invalidate();
		}

		/**
		 * @private
		 */
		private var _textureScale:Number = 1;

		/**
		 * Scales the texture dimensions during measurement. Useful for UI that
		 * should scale based on screen density or resolution.
		 *
		 * <p>In the following example, the texture scale is changed:</p>
		 *
		 * <listing version="3.0">
		 * image.textureScale = 2;</listing>
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
			this.invalidate();
		}

		/**
		 * @private
		 */
		private var _isValidating:Boolean = false;

		/**
		 * @private
		 */
		private var _isInvalid:Boolean = false;

		/**
		 * @private
		 */
		private var _validationQueue:ValidationQueue;

		/**
		 * @private
		 */
		private var _depth:int = -1;

		/**
		 * @copy feathers.core.IValidating#depth
		 */
		public function get depth():int
		{
			return this._depth;
		}

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
		override public function hitTest(localPoint:Point):DisplayObject
		{
			if(!this.visible || !this.touchable)
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
			this.width = width;
			this.height = height;
		}

		/**
		 * @private
		 */
		override public function render(painter:Painter):void
		{
			if(this._isInvalid)
			{
				this.validate();
			}
			super.render(painter);
		}

		/**
		 * @copy feathers.core.IValidating#validate()
		 */
		public function validate():void
		{
			if(!this._isInvalid)
			{
				return;
			}
			if(this._isValidating)
			{
				if(this._validationQueue)
				{
					//we were already validating, and something else told us to
					//validate. that's bad.
					this._validationQueue.addControl(this, true);
				}
				return;
			}
			this._isValidating = true;
			if(this._propertiesChanged)
			{
				this._image.textureSmoothing = this._textureSmoothing;
				this._image.color = this._color;
			}
			if(this._propertiesChanged || this._layoutChanged)
			{
				this._batch.batchable = !this._useSeparateBatch;
				this._batch.clear();
				this._image.scaleX = this._image.scaleY = this._textureScale;
				var scaledTextureWidth:Number = this._originalImageWidth * this._textureScale;
				var scaledTextureHeight:Number = this._originalImageHeight * this._textureScale;
				var xImageCount:int = Math.ceil(this._width / scaledTextureWidth);
				var yImageCount:int = Math.ceil(this._height / scaledTextureHeight);
				var imageCount:int = xImageCount * yImageCount;
				var xPosition:Number = 0;
				var yPosition:Number = 0;
				var nextXPosition:Number = xPosition + scaledTextureWidth;
				var nextYPosition:Number = yPosition + scaledTextureHeight;
				for(var i:int = 0; i < imageCount; i++)
				{
					this._image.x = xPosition;
					this._image.y = yPosition;

					var imageWidth:Number = (nextXPosition >= this._width) ? (this._width - xPosition) : scaledTextureWidth;
					var imageHeight:Number = (nextYPosition >= this._height) ? (this._height - yPosition) : scaledTextureHeight;
					this._image.width = imageWidth;
					this._image.height = imageHeight;

					var xCoord:Number = imageWidth / scaledTextureWidth;
					var yCoord:Number = imageHeight / scaledTextureHeight;
					this._image.setTexCoords(1, xCoord, 0);
					this._image.setTexCoords(3, xCoord, yCoord);
					this._image.setTexCoords(2, 0, yCoord);

					this._batch.addMesh(this._image);

					if(nextXPosition >= this._width)
					{
						xPosition = 0;
						nextXPosition = scaledTextureWidth;
						yPosition = nextYPosition;
						nextYPosition += scaledTextureHeight;
					}
					else
					{
						xPosition = nextXPosition;
						nextXPosition += scaledTextureWidth;
					}
				}
			}
			this._layoutChanged = false;
			this._propertiesChanged = false;
			this._isInvalid = false;
			this._isValidating = false;
		}

		/**
		 * @private
		 */
		protected function invalidate():void
		{
			if(this._isInvalid)
			{
				return;
			}
			this._isInvalid = true;
			if(!this._validationQueue)
			{
				return;
			}
			this._validationQueue.addControl(this, false);
		}

		/**
		 * @private
		 */
		private function initializeWidthAndHeight():void
		{
			this.width = this._originalImageWidth * this._textureScale;
			this.height = this._originalImageHeight * this._textureScale;
		}

		/**
		 * @private
		 */
		private function addedToStageHandler(event:Event):void
		{
			this._depth = getDisplayObjectDepthFromStage(this);
			this._validationQueue = ValidationQueue.forStarling(Starling.current);
			if(this._isInvalid)
			{
				this._validationQueue.addControl(this, false);
			}
		}

	}
}