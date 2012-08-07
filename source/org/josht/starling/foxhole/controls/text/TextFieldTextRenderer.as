package org.josht.starling.foxhole.controls.text
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.core.ITextRenderer;

	import starling.core.RenderSupport;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;

	/**
	 * Displays text in Foxhole as rendered by a native TextField.
	 */
	public class TextFieldTextRenderer extends FoxholeControl implements ITextRenderer
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		private static const helperMatrix:Matrix = new Matrix();

		/**
		 * Constructor.
		 */
		public function TextFieldTextRenderer()
		{
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
		private var _text:String = "";

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
			return this._textField.getLineMetrics(0).ascent;
		}

		/**
		 * @private
		 */
		private var _embedFonts:Boolean = false;

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
		private var _isHTML:Boolean = false;

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
		private var _snapToPixels:Boolean = true;

		/**
		 * Determines if the text should be snapped to the nearest whole pixel
		 * when rendered.
		 */
		public function get snapToPixels():Boolean
		{
			return _snapToPixels;
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
		override public function render(support:RenderSupport, alpha:Number):void
		{
			if(this._textSnapshot)
			{
				if(this._snapToPixels)
				{
					this.getTransformationMatrix(this.stage, helperMatrix);
					this._textSnapshot.x = Math.round(helperMatrix.tx) - helperMatrix.tx;
					this._textSnapshot.y = Math.round(helperMatrix.ty) - helperMatrix.ty;
					const scrollRect:Rectangle = this.scrollRect;
					if(scrollRect)
					{
						this._textSnapshot.x += Math.round(scrollRect.x) - scrollRect.x;
						this._textSnapshot.y += Math.round(scrollRect.y) - scrollRect.y;
					}
				}
				else
				{
					this._textSnapshot.x = this._textSnapshot.y = 0;
				}
			}
			super.render(support, alpha);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._textSnapshotBitmapData)
			{
				this._textSnapshotBitmapData.dispose();
				this._textSnapshotBitmapData = null;
			}

			super.dispose();
		}

		/**
		 * Measures the label's text, without a full validation, if possible.
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

			if(this._isHTML)
			{
				this._textField.htmlText = this._text;
			}
			else
			{
				this._textField.text = this._text;
			}
			this._textField.embedFonts = this._embedFonts;
			if(this._textFormat)
			{
				this._textField.setTextFormat(this._textFormat);
			}

			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.wordWrap = false;

			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = Math.max(this._minWidth, Math.min(this._maxWidth, this._textField.width + 1));
			}

			this._textField.width = newWidth;
			this._textField.wordWrap = true;
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = Math.max(this._minHeight, Math.min(this._maxHeight, this._textField.height + 1));
			}

			this._textField.autoSize = TextFieldAutoSize.NONE;

			result.x = newWidth;
			result.y = newHeight;
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
				this._textField.antiAliasType = AntiAliasType.ADVANCED;
				this._textField.gridFitType = GridFitType.PIXEL;
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(dataInvalid)
			{
				if(this._isHTML)
				{
					this._textField.htmlText = this._text;
				}
				else
				{
					this._textField.text = this._text;
				}
			}

			if(dataInvalid || stylesInvalid)
			{
				this._textField.embedFonts = this._embedFonts;
				if(this._textFormat)
				{
					this._textField.setTextFormat(this._textFormat);
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid)
			{
				this._textField.width = this.actualWidth;
				this._textField.height = this.actualHeight;
			}

			if(stylesInvalid || dataInvalid || sizeInvalid)
			{
				this.refreshSnapshot(this._text && (sizeInvalid || !this._textSnapshotBitmapData));
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

			this.measureText(HELPER_POINT);
			return this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
		}

		/**
		 * @private
		 */
		protected function refreshSnapshot(needsNewBitmap:Boolean):void
		{
			if(needsNewBitmap)
			{
				const tfWidth:Number = this._textField.width;
				const tfHeight:Number = this._textField.height;
				if(tfWidth == 0 || tfHeight == 0)
				{
					return;
				}
				if(!this._textSnapshotBitmapData || this._textSnapshotBitmapData.width != tfWidth || this._textSnapshotBitmapData.height != tfHeight)
				{
					if(this._textSnapshotBitmapData)
					{
						this._textSnapshotBitmapData.dispose();
					}
					this._textSnapshotBitmapData = new BitmapData(tfWidth, tfHeight, true, 0x00ff00ff);
				}
			}

			if(!this._textSnapshotBitmapData)
			{
				return;
			}
			this._textSnapshotBitmapData.fillRect(this._textSnapshotBitmapData.rect, 0x00ff00ff);
			this._textSnapshotBitmapData.draw(this._textField);
			if(!this._textSnapshot)
			{
				this._textSnapshot = new Image(starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor));
				this.addChild(this._textSnapshot);
			}
			else
			{
				if(needsNewBitmap)
				{
					this._textSnapshot.texture.dispose();
					this._textSnapshot.texture = starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor);
					this._textSnapshot.readjustSize();
				}
				else
				{
					//this is faster, so use it if we haven't resized the
					//bitmapdata
					flash.display3D.textures.Texture(this._textSnapshot.texture.base).uploadFromBitmapData(this._textSnapshotBitmapData);
				}
			}
		}
	}
}
