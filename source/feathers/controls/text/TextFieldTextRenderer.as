/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;

	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.utils.getNextPowerOfTwo;

	/**
	 * Renders text with a native <code>flash.text.TextField</code>.
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-renderers
	 * @see flash.text.TextField
	 */
	public class TextFieldTextRenderer extends FeathersControl implements ITextRenderer
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
		public function TextFieldTextRenderer()
		{
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * @private
		 */
		protected var _textField:TextField;

		/**
		 * @private
		 */
		protected var _textSnapshot:Image;

		/**
		 * @private
		 */
		protected var _textSnapshotBitmapData:BitmapData;

		/**
		 * @private
		 */
		protected var _previousTextFieldWidth:Number = 0;

		/**
		 * @private
		 */
		protected var _previousTextFieldHeight:Number = 0;

		/**
		 * @private
		 */
		protected var _snapshotWidth:int = 0;

		/**
		 * @private
		 */
		protected var _snapshotHeight:int = 0;

		/**
		 * @private
		 */
		protected var _needsNewBitmap:Boolean = false;

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * @inheritDoc
		 */
		public function get text():String
		{
			return this._text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if(this._text == value)
			{
				return;
			}
			if(value === null)
			{
				//flash.text.TextField won't accept a null value
				value = "";
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _textFormat:TextFormat;

		/**
		 * The font and styles used to draw the text.
		 */
		public function get textFormat():TextFormat
		{
			return this._textFormat;
		}

		/**
		 * @private
		 */
		public function set textFormat(value:TextFormat):void
		{
			if(this._textFormat == value)
			{
				return;
			}
			this._textFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			//2 is the gutter Flash Player adds
			return 2 + this._textField.getLineMetrics(0).ascent;
		}

		/**
		 * @private
		 */
		protected var _embedFonts:Boolean = false;

		/**
		 * Determines if the TextField should use an embedded font or not.
		 */
		public function get embedFonts():Boolean
		{
			return this._embedFonts;
		}

		/**
		 * @private
		 */
		public function set embedFonts(value:Boolean):void
		{
			if(this._embedFonts == value)
			{
				return;
			}
			this._embedFonts = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _wordWrap:Boolean = false;

		/**
		 * Determines if the TextField wraps text to the next line.
		 */
		public function get wordWrap():Boolean
		{
			return this._wordWrap;
		}

		/**
		 * @private
		 */
		public function set wordWrap(value:Boolean):void
		{
			if(this._wordWrap == value)
			{
				return;
			}
			this._wordWrap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isHTML:Boolean = false;

		/**
		 * Determines if the TextField should display the text as HTML or not.
		 */
		public function get isHTML():Boolean
		{
			return this._isHTML;
		}

		/**
		 * @private
		 */
		public function set isHTML(value:Boolean):void
		{
			if(this._isHTML == value)
			{
				return;
			}
			this._isHTML = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _snapToPixels:Boolean = true;

		/**
		 * Determines if the text should be snapped to the nearest whole pixel
		 * when rendered. When this is <code>false</code>, text may be displayed
		 * on sub-pixels, which often results in blurred rendering.
		 */
		public function get snapToPixels():Boolean
		{
			return this._snapToPixels;
		}

		/**
		 * @private
		 */
		public function set snapToPixels(value:Boolean):void
		{
			this._snapToPixels = value;
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if(this._textSnapshot)
			{
				if(this._snapToPixels)
				{
					this.getTransformationMatrix(this.stage, HELPER_MATRIX);
					this._textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
					this._textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
				}
				else
				{
					this._textSnapshot.x = this._textSnapshot.y = 0;
				}
			}
			super.render(support, parentAlpha);
		}

		/**
		 * @inheritDoc
		 */
		public function measureText(result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			if(!this._textField)
			{
				result.x = result.y = 0;
				return result;
			}

			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				result.x = this.explicitWidth;
				result.y = this.explicitHeight;
				return result;
			}

			this.commit();

			result = this.measure(result);

			return result;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._textField)
			{
				this._textField = new TextField();
				this._textField.mouseEnabled = this._textField.mouseWheelEnabled = false;
				this._textField.selectable = false;
				this._textField.multiline = true;
				this._textField.antiAliasType = AntiAliasType.ADVANCED;
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			this.commit();

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layout(sizeInvalid);
		}

		/**
		 * @private
		 */
		protected function commit():void
		{
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			if(dataInvalid || stylesInvalid)
			{
				this._textField.wordWrap = this._wordWrap;
				this._textField.embedFonts = this._embedFonts;
				if(this._textFormat)
				{
					this._textField.defaultTextFormat = this._textFormat;
				}
				if(this._isHTML)
				{
					this._textField.htmlText = this._text;
				}
				else
				{
					this._textField.text = this._text;
				}
			}
		}

		/**
		 * @private
		 */
		protected function measure(result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);

			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.wordWrap = false;

			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = Math.max(this._minWidth, Math.min(this._maxWidth, this._textField.width));
			}

			this._textField.width = newWidth;
			this._textField.wordWrap = this._wordWrap;
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = Math.max(this._minHeight, Math.min(this._maxHeight, this._textField.height));
			}

			this._textField.autoSize = TextFieldAutoSize.NONE;

			//put the width and height back just in case we measured without
			//a full validation
			this._textField.width = this.actualWidth;
			this._textField.height = this.actualHeight;

			result.x = newWidth;
			result.y = newHeight;

			return result;
		}

		/**
		 * @private
		 */
		protected function layout(sizeInvalid:Boolean):void
		{
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			if(sizeInvalid)
			{
				this._textField.width = this.actualWidth;
				this._textField.height = this.actualHeight;
				this._snapshotWidth = getNextPowerOfTwo(this.actualWidth * Starling.contentScaleFactor);
				this._snapshotHeight = getNextPowerOfTwo(this.actualHeight * Starling.contentScaleFactor);
				this._needsNewBitmap = this._needsNewBitmap || !this._textSnapshotBitmapData || this._snapshotWidth != this._textSnapshotBitmapData.width || this._snapshotHeight != this._textSnapshotBitmapData.height;
			}

			//instead of checking sizeInvalid, which will often be triggered by
			//changing maxWidth or something for measurement, we check against
			//the previous actualWidth/Height used for the snapshot.
			if(stylesInvalid || dataInvalid || this._needsNewBitmap ||
				this.actualWidth != this._previousTextFieldWidth ||
				this.actualHeight != this._previousTextFieldHeight)
			{
				this._previousTextFieldWidth = this.actualWidth;
				this._previousTextFieldHeight = this.actualHeight;
				const hasText:Boolean = this._text.length > 0;
				if(hasText)
				{
					//we need to wait a frame for the TextField to render
					//properly. sometimes two, and this is a known issue.
					this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
				if(this._textSnapshot)
				{
					this._textSnapshot.visible = hasText;
				}
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			this.measure(HELPER_POINT);
			return this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
		}

		/**
		 * @private
		 */
		protected function refreshSnapshot():void
		{
			if(this._textField.width == 0 || this._textField.height == 0)
			{
				return;
			}
			if(this._needsNewBitmap || !this._textSnapshotBitmapData)
			{
				if(this._textSnapshotBitmapData)
				{
					this._textSnapshotBitmapData.dispose();
				}
				this._textSnapshotBitmapData = new BitmapData(this._snapshotWidth, this._snapshotHeight, true, 0x00ff00ff);
			}
			if(!this._textSnapshotBitmapData)
			{
				return;
			}
			HELPER_MATRIX.identity();
			HELPER_MATRIX.scale(Starling.contentScaleFactor, Starling.contentScaleFactor);
			this._textSnapshotBitmapData.fillRect(this._textSnapshotBitmapData.rect, 0x00ff00ff);
			this._textSnapshotBitmapData.draw(this._textField, HELPER_MATRIX);
			if(!this._textSnapshot)
			{
				this._textSnapshot = new Image(starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor));
				this.addChild(this._textSnapshot);
			}
			else
			{
				if(this._needsNewBitmap)
				{
					this._textSnapshot.texture.dispose();
					this._textSnapshot.texture = starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor);
					this._textSnapshot.readjustSize();
				}
				else
				{
					//this is faster if we haven't resized the bitmapdata
					const texture:starling.textures.Texture = this._textSnapshot.texture;
					if(Starling.handleLostContext && texture is ConcreteTexture)
					{
						ConcreteTexture(texture).restoreOnLostContext(this._textSnapshotBitmapData);
					}
					flash.display3D.textures.Texture(texture.base).uploadFromBitmapData(this._textSnapshotBitmapData);
				}
			}
			this._needsNewBitmap = false;
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:Event):void
		{
			//we need to invalidate in order to get a fresh snapshot
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			if(this._textSnapshotBitmapData)
			{
				this._textSnapshotBitmapData.dispose();
				this._textSnapshotBitmapData = null;
			}

			if(this._textSnapshot)
			{
				//avoid the need to call dispose(). we'll create a new snapshot
				//when the renderer is added to stage again.
				this._textSnapshot.texture.dispose();
				this.removeChild(this._textSnapshot, true);
				this._textSnapshot = null;
			}
		}

		/**
		 * @private
		 */
		protected function enterFrameHandler(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.refreshSnapshot();
		}
	}
}
