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
package feathers.controls.supportClasses
{
	import feathers.core.FeathersControl;
	import feathers.display.ScrollRectManager;

	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.MatrixUtil;

	/**
	 * @private
	 */
	public class TextFieldViewPort extends FeathersControl implements IViewPort
	{
		private static const helperMatrix:Matrix = new Matrix();
		private static const helperPoint:Point = new Point();

		public function TextFieldViewPort()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private var _textFieldContainer:Sprite;
		private var _textField:TextField;

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
			if(!value)
			{
				value = "";
			}
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

		private var _minVisibleWidth:Number = 0;

		public function get minVisibleWidth():Number
		{
			return this._minVisibleWidth;
		}

		public function set minVisibleWidth(value:Number):void
		{
			if(this._minVisibleWidth == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleWidth cannot be NaN");
			}
			this._minVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _maxVisibleWidth:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleWidth():Number
		{
			return this._maxVisibleWidth;
		}

		public function set maxVisibleWidth(value:Number):void
		{
			if(this._maxVisibleWidth == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			this._maxVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		protected var _visibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			return this._visibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this._visibleWidth == value || (isNaN(value) && isNaN(this._visibleWidth)))
			{
				return;
			}
			this._visibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _minVisibleHeight:Number = 0;

		public function get minVisibleHeight():Number
		{
			return this._minVisibleHeight;
		}

		public function set minVisibleHeight(value:Number):void
		{
			if(this._minVisibleHeight == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("minVisibleHeight cannot be NaN");
			}
			this._minVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		private var _maxVisibleHeight:Number = Number.POSITIVE_INFINITY;

		public function get maxVisibleHeight():Number
		{
			return this._maxVisibleHeight;
		}

		public function set maxVisibleHeight(value:Number):void
		{
			if(this._maxVisibleHeight == value)
			{
				return;
			}
			if(isNaN(value))
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			this._maxVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		protected var _visibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			return this._visibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this._visibleHeight == value || (isNaN(value) && isNaN(this._visibleHeight)))
			{
				return;
			}
			this._visibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		public function get horizontalScrollStep():Number
		{
			return this._visibleWidth / 10;
		}

		public function get verticalScrollStep():Number
		{
			return this._visibleHeight / 10;
		}

		private var _horizontalScrollPosition:Number = 0;

		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		public function set horizontalScrollPosition(value:Number):void
		{
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		private var _verticalScrollPosition:Number = 0;

		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		public function set verticalScrollPosition(value:Number):void
		{
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
		}

		protected var _paddingTop:Number = 0;

		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		protected var _paddingRight:Number = 0;

		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		protected var _paddingBottom:Number = 0;

		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		protected var _paddingLeft:Number = 0;

		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		override public function render(support:RenderSupport, alpha:Number):void
		{
			const starlingViewPort:Rectangle = Starling.current.viewPort;
			helperPoint.x = helperPoint.y = 0;
			this.parent.parent.getTransformationMatrix(this.stage, helperMatrix);
			MatrixUtil.transformCoords(helperMatrix, 0, 0, helperPoint);
			ScrollRectManager.toStageCoordinates(helperPoint, this.parent.parent);
			this._textFieldContainer.x = starlingViewPort.x + helperPoint.x * Starling.contentScaleFactor;
			this._textFieldContainer.y = starlingViewPort.y + helperPoint.y * Starling.contentScaleFactor;
			this._textFieldContainer.scaleX = this._textFieldContainer.scaleY =  Starling.contentScaleFactor;
			super.render(support, alpha);
		}

		override protected function initialize():void
		{
			this._textFieldContainer = new Sprite();
			this._textFieldContainer.mouseChildren = this._textFieldContainer.mouseEnabled = false;
			this._textField = new TextField();
			this._textField.selectable = this._textFieldContainer.mouseEnabled =
				this._textField.mouseWheelEnabled = false;
			this._textField.wordWrap = true;
			this._textField.multiline = true;
			this._textFieldContainer.addChild(this._textField);
		}

		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);

			if(stylesInvalid)
			{
				if(this._textFormat)
				{
					this._textField.defaultTextFormat = this._textFormat;
					this._textField.setTextFormat(this._textFormat);
				}
				this._textField.embedFonts = this._embedFonts;
				this._textField.x = this._paddingLeft;
				this._textField.y = this._paddingTop;
			}

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

			const calculatedVisibleWidth:Number = !isNaN(this._visibleWidth) ? this._visibleWidth : Math.max(this._minVisibleWidth, Math.min(this._maxVisibleWidth, this.stage.stageWidth));
			const calculatedTextFieldWidth:Number = calculatedVisibleWidth - this._paddingLeft - this._paddingRight;
			this._textField.width = calculatedTextFieldWidth;
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			const totalContentHeight:Number = this._textField.height + this._paddingTop + this._paddingBottom;
			this._textField.autoSize = TextFieldAutoSize.NONE;
			const calculatedVisibleHeight:Number = !isNaN(this._visibleHeight) ? this._visibleHeight : Math.max(this._minVisibleHeight, Math.min(this._maxVisibleHeight, totalContentHeight));
			this._textField.height = totalContentHeight - this._paddingTop - this._paddingBottom;
			sizeInvalid = this.setSizeInternal(calculatedVisibleWidth, totalContentHeight, false);

			if(sizeInvalid || scrollInvalid)
			{
				var scrollRect:Rectangle = this._textFieldContainer.scrollRect;
				if(!scrollRect)
				{
					scrollRect = new Rectangle();
				}
				scrollRect.width = calculatedVisibleWidth;
				scrollRect.height = calculatedVisibleHeight;
				scrollRect.x = this._horizontalScrollPosition;
				scrollRect.y = this._verticalScrollPosition;
				this._textFieldContainer.scrollRect = scrollRect;
			}
		}

		private function addedToStageHandler(event:Event):void
		{
			Starling.current.nativeStage.addChild(this._textFieldContainer);
		}

		private function removedFromStageHandler(event:Event):void
		{
			Starling.current.nativeStage.removeChild(this._textFieldContainer);
		}
	}
}
