/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.skins.IStyleProvider;
	import feathers.utils.display.stageToStarling;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;

	import starling.core.Starling;

	/**
	 * @private
	 * A text editor view port for the <code>TextArea</code> component that uses
	 * <code>flash.text.StageText</code>.
	 * 
	 * <p><strong>WARNING!</strong> This component isn't recommended for use in
	 * production apps. It is buggy because <code>StageText</code> has a limited
	 * API that doesn't expose things like scroll position.</p>
	 *
	 * @see feathers.controls.TextArea
	 */
	public class StageTextTextEditorViewPort extends StageTextTextEditor implements ITextEditorViewPort
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>StageTextTextEditorViewPort</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function StageTextTextEditorViewPort()
		{
			super();
			this.multiline = true;
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return globalStyleProvider;
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * @default 0
		 *
		 * @see #paddingTop
		 * @see #paddingRight
		 * @see #paddingBottom
		 * @see #paddingLeft
		 */
		public function get padding():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			this.paddingTop = value;
			this.paddingRight = value;
			this.paddingBottom = value;
			this.paddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the view port's top edge and
		 * the view port's content.
		 *
		 * @default 0
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the view port's right edge and
		 * the view port's content.
		 *
		 * @default 0
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the view port's bottom edge and
		 * the view port's content.
		 *
		 * @default 0
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the view port's left edge and
		 * the view port's content.
		 *
		 * @default 0
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _minVisibleWidth:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get minVisibleWidth():Number
		{
			return this._minVisibleWidth;
		}

		/**
		 * @private
		 */
		public function set minVisibleWidth(value:Number):void
		{
			if(this._minVisibleWidth == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("minVisibleWidth cannot be NaN");
			}
			this._minVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _maxVisibleWidth:Number = Number.POSITIVE_INFINITY;

		/**
		 * @inheritDoc
		 */
		public function get maxVisibleWidth():Number
		{
			return this._maxVisibleWidth;
		}

		/**
		 * @private
		 */
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
			this._maxVisibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _visibleWidth:Number = NaN;

		/**
		 * @inheritDoc
		 */
		public function get visibleWidth():Number
		{
			return this._visibleWidth;
		}

		/**
		 * @private
		 */
		public function set visibleWidth(value:Number):void
		{
			if(this._visibleWidth == value ||
				(value !== value && this._visibleWidth !== this._visibleWidth)) //isNaN
			{
				return;
			}
			this._visibleWidth = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _minVisibleHeight:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get minVisibleHeight():Number
		{
			return this._minVisibleHeight;
		}

		/**
		 * @private
		 */
		public function set minVisibleHeight(value:Number):void
		{
			if(this._minVisibleHeight == value)
			{
				return;
			}
			if(value !== value) //isNaN
			{
				throw new ArgumentError("minVisibleHeight cannot be NaN");
			}
			this._minVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _maxVisibleHeight:Number = Number.POSITIVE_INFINITY;

		/**
		 * @inheritDoc
		 */
		public function get maxVisibleHeight():Number
		{
			return this._maxVisibleHeight;
		}

		/**
		 * @private
		 */
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
			this._maxVisibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		private var _visibleHeight:Number = NaN;

		/**
		 * @inheritDoc
		 */
		public function get visibleHeight():Number
		{
			return this._visibleHeight;
		}

		/**
		 * @private
		 */
		public function set visibleHeight(value:Number):void
		{
			if(this._visibleHeight == value ||
				(value !== value && this._visibleHeight !== this._visibleHeight)) //isNaN
			{
				return;
			}
			this._visibleHeight = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		public function get contentX():Number
		{
			return 0;
		}

		public function get contentY():Number
		{
			return 0;
		}

		/**
		 * @private
		 */
		protected var _scrollStep:int = 1;

		/**
		 * @inheritDoc
		 */
		public function get horizontalScrollStep():Number
		{
			return this._scrollStep;
		}

		/**
		 * @inheritDoc
		 */
		public function get verticalScrollStep():Number
		{
			return this._scrollStep;
		}

		/**
		 * @private
		 */
		private var _horizontalScrollPosition:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get horizontalScrollPosition():Number
		{
			return this._horizontalScrollPosition;
		}

		/**
		 * @private
		 */
		public function set horizontalScrollPosition(value:Number):void
		{
			//this value is basically ignored because the text does not scroll
			//horizontally. instead, it wraps.
			this._horizontalScrollPosition = value;
		}

		/**
		 * @private
		 */
		private var _verticalScrollPosition:Number = 0;

		/**
		 * @inheritDoc
		 */
		public function get verticalScrollPosition():Number
		{
			return this._verticalScrollPosition;
		}

		/**
		 * @private
		 */
		public function set verticalScrollPosition(value:Number):void
		{
			//this value is basically ignored because the StageText handles
			//scrolling automatically.
			this._verticalScrollPosition = value;
		}

		/**
		 * @private
		 */
		public function get requiresMeasurementOnScroll():Boolean
		{
			return false;
		}

		/**
		 * @private
		 */
		override protected function measure(result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var needsWidth:Boolean = this._visibleWidth !== this._visibleWidth; //isNaN
			var needsHeight:Boolean = this._visibleHeight !== this._visibleHeight; //isNaN

			this._measureTextField.autoSize = TextFieldAutoSize.LEFT;

			var newWidth:Number = this._visibleWidth;
			if(needsWidth)
			{
				newWidth = this._measureTextField.textWidth + this._paddingLeft + this._paddingRight;
				if(newWidth < this._minVisibleWidth)
				{
					newWidth = this._minVisibleWidth;
				}
				else if(newWidth > this._maxVisibleWidth)
				{
					newWidth = this._maxVisibleWidth;
				}
			}

			//the +4 is accounting for the TextField gutter
			this._measureTextField.width = newWidth + 4;
			var newHeight:Number = this._visibleHeight;
			if(needsHeight)
			{
				//since we're measuring with TextField, but rendering with
				//StageText, we're using height instead of textHeight here to be
				//sure that the measured size is on the larger side, in case the
				//rendered size is actually bigger than textHeight
				//if only StageText had an API for text measurement, we wouldn't
				//be in this mess...
				newHeight = this._measureTextField.height + this._paddingTop + this._paddingBottom;
				if(newHeight < this._minVisibleHeight)
				{
					newHeight = this._minVisibleHeight;
				}
				else if(newHeight > this._maxVisibleHeight)
				{
					newHeight = this._maxVisibleHeight;
				}
			}

			this._measureTextField.autoSize = TextFieldAutoSize.NONE;

			//put the width and height back just in case we measured without
			//a full validation
			//the +4 is accounting for the TextField gutter
			this._measureTextField.width = this.actualWidth + 4;
			this._measureTextField.height = this.actualHeight;

			result.x = newWidth;
			result.y = newHeight;

			return result;
		}

		/**
		 * @private
		 */
		override protected function refreshViewPortAndFontSize():void
		{
			super.refreshViewPortAndFontSize();

			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			var scaleFactor:Number = starling.contentScaleFactor / nativeScaleFactor;
			
			var viewPort:Rectangle = this.stageText.viewPort;
			viewPort.x += (this._paddingLeft * scaleFactor);
			viewPort.y += (this._paddingTop * scaleFactor);
			viewPort.width -= ((this._paddingLeft + this._paddingRight) * scaleFactor);
			viewPort.height -= ((this._paddingTop + this._paddingBottom) * scaleFactor);
			this.stageText.viewPort = viewPort;
		}

		/**
		 * @private
		 */
		override protected function positionSnapshot():void
		{
			super.positionSnapshot();
			this.textSnapshot.x += this._paddingLeft;
			this.textSnapshot.y += this._paddingRight;
		}
	}
}
