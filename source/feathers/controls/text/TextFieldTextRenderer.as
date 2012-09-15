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
package feathers.controls.text
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

	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;

	import starling.core.RenderSupport;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;

	/**
	 * Renders text with a native <code>flash.text.TextField</code>.
	 * 
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
		private static const helperMatrix:Matrix = new Matrix();

		/**
		 * Constructor.
		 */
		public function TextFieldTextRenderer()
		{
			this.isQuickHitAreaEnabled = true;
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
		private var _wordWrap:Boolean = false;

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
				this._textField.wordWrap = this._wordWrap;
				this._textField.embedFonts = this._embedFonts;
				if(this._textFormat)
				{
					this._textField.setTextFormat(this._textFormat);
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
			}

			if(stylesInvalid || dataInvalid || sizeInvalid)
			{
				const hasText:Boolean = this._text.length > 0;
				if(hasText)
				{
					this.refreshSnapshot(sizeInvalid || !this._textSnapshotBitmapData);
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
		protected function refreshSnapshot(needsNewBitmap:Boolean):void
		{
			if(needsNewBitmap)
			{
				const tfWidth:Number = this._textField.width * Starling.contentScaleFactor;
				const tfHeight:Number = this._textField.height * Starling.contentScaleFactor;
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
			helperMatrix.identity();
			helperMatrix.scale(Starling.contentScaleFactor, Starling.contentScaleFactor);
			this._textSnapshotBitmapData.fillRect(this._textSnapshotBitmapData.rect, 0x00ff00ff);
			this._textSnapshotBitmapData.draw(this._textField, helperMatrix);
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
					const texture:starling.textures.Texture = this._textSnapshot.texture;
					if(Starling.handleLostContext && texture is ConcreteTexture)
					{
						ConcreteTexture(texture).restoreOnLostContext(this._textSnapshotBitmapData);
					}
					flash.display3D.textures.Texture(texture.base).uploadFromBitmapData(this._textSnapshotBitmapData);
				}
			}
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
	}
}
