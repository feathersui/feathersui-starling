/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.core.FeathersControl;
	import feathers.text.FontStylesSet;
	import feathers.utils.geom.matrixToRotation;
	import feathers.utils.geom.matrixToScaleX;
	import feathers.utils.geom.matrixToScaleY;

	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.FontType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.rendering.Painter;
	import starling.text.TextFormat;
	import starling.utils.MatrixUtil;
	import starling.utils.Pool;
	import starling.utils.SystemUtil;

	/**
	 * @private
	 * Used internally by ScrollText. Not meant to be used on its own.
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class TextFieldViewPort extends FeathersControl implements IViewPort
	{
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
		 * @see feathers.controls.ScrollText#text
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
		private var _isHTML:Boolean = false;

		/**
		 * @see feathers.controls.ScrollText#isHTML
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
		protected var _fontStylesTextFormat:flash.text.TextFormat;

		/**
		 * @private
		 */
		protected var _fontStyles:FontStylesSet;

		/**
		 * Generic font styles.
		 */
		public function get fontStyles():FontStylesSet
		{
			return this._fontStyles;
		}

		/**
		 * @private
		 */
		public function set fontStyles(value:FontStylesSet):void
		{
			if(this._fontStyles === value)
			{
				return;
			}
			if(this._fontStyles !== null)
			{
				this._fontStyles.removeEventListener(Event.CHANGE, fontStylesSet_changeHandler);
			}
			this._fontStyles = value;
			if(this._fontStyles !== null)
			{
				this._fontStyles.addEventListener(Event.CHANGE, fontStylesSet_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _currentTextFormat:flash.text.TextFormat;

		/**
		 * @private
		 */
		private var _textFormat:flash.text.TextFormat;

		/**
		 * @see feathers.controls.ScrollText#textFormat
		 */
		public function get textFormat():flash.text.TextFormat
		{
			return this._textFormat;
		}

		/**
		 * @private
		 */
		public function set textFormat(value:flash.text.TextFormat):void
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
		private var _disabledTextFormat:flash.text.TextFormat;

		/**
		 * @see feathers.controls.ScrollText#disabledTextFormat
		 */
		public function get disabledTextFormat():flash.text.TextFormat
		{
			return this._disabledTextFormat;
		}

		/**
		 * @private
		 */
		public function set disabledTextFormat(value:flash.text.TextFormat):void
		{
			if(this._disabledTextFormat == value)
			{
				return;
			}
			this._disabledTextFormat = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _styleSheet:StyleSheet;

		/**
		 * @see feathers.controls.ScrollText#styleSheet
		 */
		public function get styleSheet():StyleSheet
		{
			return this._styleSheet;
		}

		/**
		 * @private
		 */
		public function set styleSheet(value:StyleSheet):void
		{
			if(this._styleSheet == value)
			{
				return;
			}
			this._styleSheet = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _embedFonts:Boolean = false;

		/**
		 * @see feathers.controls.ScrollText#embedFonts
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
		private var _antiAliasType:String = AntiAliasType.ADVANCED;

		/**
		 * @see feathers.controls.ScrollText#antiAliasType
		 */
		public function get antiAliasType():String
		{
			return this._antiAliasType;
		}

		/**
		 * @private
		 */
		public function set antiAliasType(value:String):void
		{
			if(this._antiAliasType == value)
			{
				return;
			}
			this._antiAliasType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _background:Boolean = false;

		/**
		 * @see feathers.controls.ScrollText#background
		 */
		public function get background():Boolean
		{
			return this._background;
		}

		/**
		 * @private
		 */
		public function set background(value:Boolean):void
		{
			if(this._background == value)
			{
				return;
			}
			this._background = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _backgroundColor:uint = 0xffffff;

		/**
		 * @see feathers.controls.ScrollText#backgroundColor
		 */
		public function get backgroundColor():uint
		{
			return this._backgroundColor;
		}

		/**
		 * @private
		 */
		public function set backgroundColor(value:uint):void
		{
			if(this._backgroundColor == value)
			{
				return;
			}
			this._backgroundColor = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _border:Boolean = false;

		/**
		 * @see feathers.controls.ScrollText#border
		 */
		public function get border():Boolean
		{
			return this._border;
		}

		/**
		 * @private
		 */
		public function set border(value:Boolean):void
		{
			if(this._border == value)
			{
				return;
			}
			this._border = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _borderColor:uint = 0x000000;

		/**
		 * @see feathers.controls.ScrollText#borderColor
		 */
		public function get borderColor():uint
		{
			return this._borderColor;
		}

		/**
		 * @private
		 */
		public function set borderColor(value:uint):void
		{
			if(this._borderColor == value)
			{
				return;
			}
			this._borderColor = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _cacheAsBitmap:Boolean = true;

		/**
		 * @see feathers.controls.ScrollText#cacheAsBitmap
		 */
		public function get cacheAsBitmap():Boolean
		{
			return this._cacheAsBitmap;
		}

		/**
		 * @private
		 */
		public function set cacheAsBitmap(value:Boolean):void
		{
			if(this._cacheAsBitmap == value)
			{
				return;
			}
			this._cacheAsBitmap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _condenseWhite:Boolean = false;

		/**
		 * @see feathers.controls.ScrollText#condenseWhite
		 */
		public function get condenseWhite():Boolean
		{
			return this._condenseWhite;
		}

		/**
		 * @private
		 */
		public function set condenseWhite(value:Boolean):void
		{
			if(this._condenseWhite == value)
			{
				return;
			}
			this._condenseWhite = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _displayAsPassword:Boolean = false;

		/**
		 * @see feathers.controls.ScrollText#displayAsPassword
		 */
		public function get displayAsPassword():Boolean
		{
			return this._displayAsPassword;
		}

		/**
		 * @private
		 */
		public function set displayAsPassword(value:Boolean):void
		{
			if(this._displayAsPassword == value)
			{
				return;
			}
			this._displayAsPassword = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _gridFitType:String = GridFitType.PIXEL;

		/**
		 * @see feathers.controls.ScrollText#gridFitType
		 */
		public function get gridFitType():String
		{
			return this._gridFitType;
		}

		/**
		 * @private
		 */
		public function set gridFitType(value:String):void
		{
			if(this._gridFitType == value)
			{
				return;
			}
			this._gridFitType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _sharpness:Number = 0;

		/**
		 * @see feathers.controls.ScrollText#sharpness
		 */
		public function get sharpness():Number
		{
			return this._sharpness;
		}

		/**
		 * @private
		 */
		public function set sharpness(value:Number):void
		{
			if(this._sharpness == value)
			{
				return;
			}
			this._sharpness = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _thickness:Number = 0;

		/**
		 * @see feathers.controls.ScrollText#thickness
		 */
		public function get thickness():Number
		{
			return this._thickness;
		}

		/**
		 * @private
		 */
		public function set thickness(value:Number):void
		{
			if(this._thickness == value)
			{
				return;
			}
			this._thickness = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _actualMinVisibleWidth:Number = 0;

		private var _explicitMinVisibleWidth:Number;

		public function get minVisibleWidth():Number
		{
			if(this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth) //isNaN
			{
				return this._actualMinVisibleWidth;
			}
			return this._explicitMinVisibleWidth;
		}

		public function set minVisibleWidth(value:Number):void
		{
			if(this._explicitMinVisibleWidth == value)
			{
				return;
			}
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN &&
				this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth) //isNaN
			{
				return;
			}
			var oldValue:Number = this._explicitMinVisibleWidth;
			this._explicitMinVisibleWidth = value;
			if(valueIsNaN)
			{
				this._actualMinVisibleWidth = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				this._actualMinVisibleWidth = value;
				if(this._explicitVisibleWidth !== this._explicitVisibleWidth && //isNaN
					(this._actualVisibleWidth < value || this._actualVisibleWidth === oldValue))
				{
					//only invalidate if this change might affect the visibleWidth
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
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
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleWidth cannot be NaN");
			}
			var oldValue:Number = this._maxVisibleWidth;
			this._maxVisibleWidth = value;
			if(this._explicitVisibleWidth !== this._explicitVisibleWidth && //isNaN
				(this._actualVisibleWidth > value || this._actualVisibleWidth === oldValue))
			{
				//only invalidate if this change might affect the visibleWidth
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualVisibleWidth:Number = 0;

		private var _explicitVisibleWidth:Number = NaN;

		public function get visibleWidth():Number
		{
			if(this._explicitVisibleWidth !== this._explicitVisibleWidth) //isNaN
			{
				return this._actualVisibleWidth;
			}
			return this._explicitVisibleWidth;
		}

		public function set visibleWidth(value:Number):void
		{
			if(this._explicitVisibleWidth == value ||
				(value !== value && this._explicitVisibleWidth !== this._explicitVisibleWidth)) //isNaN
			{
				return;
			}
			this._explicitVisibleWidth = value;
			if(this._actualVisibleWidth !== value)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualMinVisibleHeight:Number = 0;

		private var _explicitMinVisibleHeight:Number;

		public function get minVisibleHeight():Number
		{
			if(this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight) //isNaN
			{
				return this._actualMinVisibleHeight;
			}
			return this._explicitMinVisibleHeight;
		}

		public function set minVisibleHeight(value:Number):void
		{
			if(this._explicitMinVisibleHeight == value)
			{
				return;
			}
			var valueIsNaN:Boolean = value !== value; //isNaN
			if(valueIsNaN &&
				this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight) //isNaN
			{
				return;
			}
			var oldValue:Number = this._explicitMinVisibleHeight;
			this._explicitMinVisibleHeight = value;
			if(valueIsNaN)
			{
				this._actualMinVisibleHeight = 0;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				this._actualMinVisibleHeight = value;
				if(this._explicitVisibleHeight !== this._explicitVisibleHeight && //isNaN
					(this._actualVisibleHeight < value || this._actualVisibleHeight === oldValue))
				{
					//only invalidate if this change might affect the visibleHeight
					this.invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
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
			if(value !== value) //isNaN
			{
				throw new ArgumentError("maxVisibleHeight cannot be NaN");
			}
			var oldValue:Number = this._maxVisibleHeight;
			this._maxVisibleHeight = value;
			if(this._explicitVisibleHeight !== this._explicitVisibleHeight && //isNaN
				(this._actualVisibleHeight > value || this._actualVisibleHeight === oldValue))
			{
				//only invalidate if this change might affect the visibleHeight
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualVisibleHeight:Number = 0;

		private var _explicitVisibleHeight:Number = NaN;

		public function get visibleHeight():Number
		{
			if(this._explicitVisibleHeight !== this._explicitVisibleHeight) //isNaN
			{
				return this._actualVisibleHeight;
			}
			return this._explicitVisibleHeight;
		}

		public function set visibleHeight(value:Number):void
		{
			if(this._explicitVisibleHeight == value ||
				(value !== value && this._explicitVisibleHeight !== this._explicitVisibleHeight)) //isNaN
			{
				return;
			}
			this._explicitVisibleHeight = value;
			if(this._actualVisibleHeight !== value)
			{
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		public function get contentX():Number
		{
			return 0;
		}

		public function get contentY():Number
		{
			return 0;
		}

		private var _scrollStep:Number;

		public function get horizontalScrollStep():Number
		{
			return this._scrollStep;
		}

		public function get verticalScrollStep():Number
		{
			return this._scrollStep;
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

		public function get requiresMeasurementOnScroll():Boolean
		{
			return false;
		}

		private var _paddingTop:Number = 0;

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

		private var _paddingRight:Number = 0;

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

		private var _paddingBottom:Number = 0;

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

		private var _paddingLeft:Number = 0;

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

		override public function render(painter:Painter):void
		{
			//this component is an overlay above Starling, and it should be
			//excluded from the render cache
			painter.excludeFromCache(this);

			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var starlingViewPort:Rectangle = starling.viewPort;
			var matrix:Matrix = Pool.getMatrix();
			var point:Point = Pool.getPoint();
			this.parent.getTransformationMatrix(this.stage, matrix);
			MatrixUtil.transformCoords(matrix, 0, 0, point);
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			var scaleFactor:Number = starling.contentScaleFactor / nativeScaleFactor;
			this._textFieldContainer.x = starlingViewPort.x + point.x * scaleFactor;
			this._textFieldContainer.y = starlingViewPort.y + point.y * scaleFactor;
			this._textFieldContainer.scaleX = matrixToScaleX(matrix) * scaleFactor;
			this._textFieldContainer.scaleY = matrixToScaleY(matrix) * scaleFactor;
			this._textFieldContainer.rotation = matrixToRotation(matrix) * 180 / Math.PI;
			this._textFieldContainer.alpha = painter.state.alpha;
			Pool.putPoint(point);
			Pool.putMatrix(matrix);
			super.render(painter);
		}

		override protected function initialize():void
		{
			this._textFieldContainer = new Sprite();
			this._textFieldContainer.visible = false;
			this._textField = new TextField();
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			this._textField.selectable = false;
			this._textField.mouseWheelEnabled = false;
			this._textField.wordWrap = true;
			this._textField.multiline = true;
			this._textField.addEventListener(TextEvent.LINK, textField_linkHandler);
			this._textFieldContainer.addChild(this._textField);
		}

		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			if(stylesInvalid)
			{
				this.refreshTextFormat();
				this._textField.antiAliasType = this._antiAliasType;
				this._textField.background = this._background;
				this._textField.backgroundColor = this._backgroundColor;
				this._textField.border = this._border;
				this._textField.borderColor = this._borderColor;
				this._textField.condenseWhite = this._condenseWhite;
				this._textField.displayAsPassword = this._displayAsPassword;
				this._textField.gridFitType = this._gridFitType;
				this._textField.sharpness = this._sharpness;
				this._textField.thickness = this._thickness;
				this._textField.cacheAsBitmap = this._cacheAsBitmap;
				this._textField.x = this._paddingLeft;
				this._textField.y = this._paddingTop;
			}

			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(dataInvalid || stylesInvalid || stateInvalid)
			{
				if(this._styleSheet !== null)
				{
					this._textField.embedFonts = this._embedFonts;
					this._textField.styleSheet = this._styleSheet;
				}
				else
				{
					if(!this._embedFonts &&
						this._currentTextFormat === this._fontStylesTextFormat)
					{
						//when font styles are passed in from the parent component, we
						//automatically determine if the TextField should use embedded
						//fonts, unless embedFonts is explicitly true
						this._textField.embedFonts = SystemUtil.isEmbeddedFont(
							this._currentTextFormat.font, this._currentTextFormat.bold,
							this._currentTextFormat.italic, FontType.EMBEDDED);
					}
					else
					{
						this._textField.embedFonts = this._embedFonts;
					}
					this._textField.styleSheet = null;
					this._textField.defaultTextFormat = this._currentTextFormat;
				}
				if(this._isHTML)
				{
					this._textField.htmlText = this._text;
				}
				else
				{
					this._textField.text = this._text;
				}
				this._scrollStep = this._textField.getLineMetrics(0).height * starling.contentScaleFactor;
			}

			var calculatedVisibleWidth:Number = this._explicitVisibleWidth;
			if(calculatedVisibleWidth != calculatedVisibleWidth)
			{
				if(this.stage !== null)
				{
					calculatedVisibleWidth = this.stage.stageWidth;
				}
				else
				{
					calculatedVisibleWidth = starling.stage.stageWidth;
				}
				if(calculatedVisibleWidth < this._explicitMinVisibleWidth)
				{
					calculatedVisibleWidth = this._explicitMinVisibleWidth;
				}
				else if(calculatedVisibleWidth > this._maxVisibleWidth)
				{
					calculatedVisibleWidth = this._maxVisibleWidth;
				}
			}
			this._textField.width = calculatedVisibleWidth - this._paddingLeft - this._paddingRight;
			var totalContentHeight:Number = this._textField.height + this._paddingTop + this._paddingBottom;
			var calculatedVisibleHeight:Number = this._explicitVisibleHeight;
			if(calculatedVisibleHeight != calculatedVisibleHeight)
			{
				calculatedVisibleHeight = totalContentHeight;
				if(calculatedVisibleHeight < this._explicitMinVisibleHeight)
				{
					calculatedVisibleHeight = this._explicitMinVisibleHeight;
				}
				else if(calculatedVisibleHeight > this._maxVisibleHeight)
				{
					calculatedVisibleHeight = this._maxVisibleHeight;
				}
			}
			sizeInvalid = this.saveMeasurements(
					calculatedVisibleWidth, totalContentHeight,
					calculatedVisibleWidth, totalContentHeight) || sizeInvalid;
			this._actualVisibleWidth = calculatedVisibleWidth;
			this._actualVisibleHeight = calculatedVisibleHeight;
			this._actualMinVisibleWidth = calculatedVisibleWidth;
			this._actualMinVisibleHeight = calculatedVisibleHeight;

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

		protected function refreshTextFormat():void
		{
			if(!this._isEnabled && this._disabledTextFormat !== null)
			{
				this._currentTextFormat = this._disabledTextFormat;
			}
			else if(this._textFormat !== null)
			{
				this._currentTextFormat = this._textFormat;
			}
			else if(this._fontStyles !== null)
			{
				this._currentTextFormat = this.getTextFormatFromFontStyles();
			}
		}

		protected function getTextFormatFromFontStyles():flash.text.TextFormat
		{
			if(this.isInvalid(INVALIDATION_FLAG_STYLES) ||
				this.isInvalid(INVALIDATION_FLAG_STATE))
			{
				var fontStylesFormat:starling.text.TextFormat;
				if(this._fontStyles !== null)
				{
					fontStylesFormat = this._fontStyles.getTextFormatForTarget(this);
				}
				if(fontStylesFormat !== null)
				{
					this._fontStylesTextFormat = fontStylesFormat.toNativeFormat(this._fontStylesTextFormat);
				}
				else if(this._fontStylesTextFormat === null)
				{
					//fallback to a default so that something is displayed
					this._fontStylesTextFormat = new flash.text.TextFormat();
				}
			}
			return this._fontStylesTextFormat;
		}

		private function addedToStageHandler(event:Event):void
		{
			this.stage.starling.nativeStage.addChild(this._textFieldContainer);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function removedFromStageHandler(event:Event):void
		{
			this.stage.starling.nativeStage.removeChild(this._textFieldContainer);
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void
		{
			var target:DisplayObject = this;
			do
			{
				if(!target.visible)
				{
					this._textFieldContainer.visible = false;
					return;
				}
				target = target.parent;
			}
			while(target)
			this._textFieldContainer.visible = true;
		}

		protected function textField_linkHandler(event:TextEvent):void
		{
			this.dispatchEventWith(Event.TRIGGERED, false, event.text);
		}

		protected function fontStylesSet_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}
}
