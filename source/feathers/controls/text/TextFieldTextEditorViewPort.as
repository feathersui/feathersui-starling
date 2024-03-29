/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.controls.Scroller;
	import feathers.skins.IStyleProvider;
	import feathers.utils.geom.matrixToRotation;
	import feathers.utils.geom.matrixToScaleX;
	import feathers.utils.geom.matrixToScaleY;
	import feathers.utils.math.roundToNearest;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	import starling.core.Starling;
	import starling.utils.MatrixUtil;
	import starling.utils.Pool;

	/**
	 * A text editor view port for the <code>TextArea</code> component that uses
	 * <code>flash.text.TextField</code>.
	 *
	 * @see feathers.controls.TextArea
	 *
	 * @productversion Feathers 1.1.0
	 */
	public class TextFieldTextEditorViewPort extends TextFieldTextEditor implements ITextEditorViewPort
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>TextFieldTextEditorViewPort</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function TextFieldTextEditorViewPort()
		{
			super();
			this.multiline = true;
			this.wordWrap = true;
			this.resetScrollOnFocusOut = false;
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return globalStyleProvider;
		}

		/**
		 * @private
		 */
		private var _ignoreScrolling:Boolean = false;

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
					(this._actualVisibleWidth < value || this._actualVisibleWidth == oldValue))
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
				(this._actualVisibleWidth > value || this._actualVisibleWidth == oldValue))
			{
				//only invalidate if this change might affect the visibleWidth
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualVisibleWidth:Number = 0;

		private var _explicitVisibleWidth:Number;

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
			if(this._actualVisibleWidth != value)
			{
				this._actualVisibleWidth = value;
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
					(this._actualVisibleHeight < value || this._actualVisibleHeight == oldValue))
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
				(this._actualVisibleHeight > value || this._actualVisibleHeight == oldValue))
			{
				//only invalidate if this change might affect the visibleHeight
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		private var _actualVisibleHeight:Number = 0;

		private var _explicitVisibleHeight:Number;

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
			if(this._actualVisibleHeight != value)
			{
				this._actualVisibleHeight = value;
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
		}

		/**
		 * @private
		 */
		public function get contentX():Number
		{
			return 0;
		}

		/**
		 * @private
		 */
		public function get contentY():Number
		{
			return 0;
		}

		/**
		 * @private
		 */
		protected var _scrollStep:int = 0;

		/**
		 * @private
		 */
		public function get horizontalScrollStep():Number
		{
			return this._scrollStep;
		}

		/**
		 * @private
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
		 * @private
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
		 * @private
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
			if(this._verticalScrollPosition == value)
			{
				return;
			}
			this._verticalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			//hack because the superclass doesn't know about the scroll flag
			this.invalidate(INVALIDATION_FLAG_SIZE);
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
		override public function get baseline():Number
		{
			return super.baseline + this._paddingTop + this._verticalScrollPosition;
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
		override public function setFocus(position:Point = null):void
		{
			if(position !== null)
			{
				position.x -= this._paddingLeft;
				position.y -= this._paddingTop;
			}
			super.setFocus(position);
		}

		/**
		 * @private
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			var result:Boolean = super.autoSizeIfNeeded();
			var needsWidth:Boolean = this._explicitVisibleWidth !== this._explicitVisibleWidth; //isNaN
			var needsHeight:Boolean = this._explicitVisibleHeight !== this._explicitVisibleHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinVisibleWidth !== this._explicitMinVisibleWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinVisibleHeight !== this._explicitMinVisibleHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return result;
			}
			if(needsWidth)
			{
				this._actualVisibleWidth = this.actualWidth;
			}
			if(needsHeight)
			{
				this._actualVisibleHeight = this.actualHeight;
			}
			if(needsMinWidth)
			{
				this._actualMinVisibleWidth = this.actualMinWidth;
			}
			if(needsMinHeight)
			{
				this._actualMinVisibleHeight = this.actualMinHeight;
			}
			return result;
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

			var needsWidth:Boolean = this._explicitVisibleWidth !== this._explicitVisibleWidth; //isNaN

			this.commitStylesAndData(this.measureTextField);

			var gutterDimensionsOffset:Number = 4;
			if(this._useGutter)
			{
				gutterDimensionsOffset = 0;
			}

			var newWidth:Number = this._explicitVisibleWidth;
			this.measureTextField.width = newWidth - this._paddingLeft - this._paddingRight + gutterDimensionsOffset;
			if(needsWidth)
			{
				//this.measureTextField.wordWrap = false;
				newWidth = this.measureTextField.width + this._paddingLeft + this._paddingRight - gutterDimensionsOffset;
				if(this._explicitMinVisibleWidth === this._explicitMinVisibleWidth && //!isNaN
					newWidth < this._explicitMinVisibleWidth)
				{
					newWidth = this._explicitMinVisibleWidth;
				}
				else if(newWidth > this._maxVisibleWidth)
				{
					newWidth = this._maxVisibleWidth;
				}
			}
			//this.measureTextField.width = newWidth - this._paddingLeft - this._paddingRight + gutterDimensionsOffset;
			//this.measureTextField.wordWrap = true;
			var newHeight:Number = this.measureTextField.height + this._paddingTop + this._paddingBottom - gutterDimensionsOffset;
			if(this._useGutter)
			{
				newHeight += 4;
			}
			if(this._explicitVisibleHeight === this._explicitVisibleHeight) //!isNaN
			{
				if(newHeight < this._explicitVisibleHeight)
				{
					newHeight = this._explicitVisibleHeight;
				}
			}
			else if(this._explicitMinVisibleHeight === this._explicitMinVisibleHeight) //!isNaN
			{
				if(newHeight < this._explicitMinVisibleHeight)
				{
					newHeight = this._explicitMinVisibleHeight;
				}
			}

			result.x = newWidth;
			result.y = newHeight;

			return result;
		}

		/**
		 * @private
		 */
		override protected function refreshSnapshotParameters():void
		{
			var textFieldWidth:Number = this._actualVisibleWidth - this._paddingLeft - this._paddingRight;
			if(textFieldWidth !== textFieldWidth) //isNaN
			{
				if(this._maxVisibleWidth < Number.POSITIVE_INFINITY)
				{
					textFieldWidth = this._maxVisibleWidth - this._paddingLeft - this._paddingRight;
				}
				else
				{
					textFieldWidth = this._actualMinVisibleWidth - this._paddingLeft - this._paddingRight;
				}
			}
			var textFieldHeight:Number = this._actualVisibleHeight - this._paddingTop - this._paddingBottom;
			if(textFieldHeight !== textFieldHeight) //isNaN
			{
				if(this._maxVisibleHeight < Number.POSITIVE_INFINITY)
				{
					textFieldHeight = this._maxVisibleHeight - this._paddingTop - this._paddingBottom;
				}
				else
				{
					textFieldHeight = this._actualMinVisibleHeight - this._paddingTop - this._paddingBottom;
				}
			}

			this._textFieldOffsetX = 0;
			this._textFieldOffsetY = 0;
			this._textFieldSnapshotClipRect.x = 0;
			this._textFieldSnapshotClipRect.y = 0;

			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var scaleFactor:Number = starling.contentScaleFactor;
			var clipWidth:Number = textFieldWidth * scaleFactor;
			if(this._updateSnapshotOnScaleChange)
			{
				var matrix:Matrix = Pool.getMatrix();
				this.getTransformationMatrix(this.stage, matrix);
				clipWidth *= matrixToScaleX(matrix);
			}
			if(clipWidth < 0)
			{
				clipWidth = 0;
			}
			var clipHeight:Number = textFieldHeight * scaleFactor;
			if(this._updateSnapshotOnScaleChange)
			{
				clipHeight *= matrixToScaleY(matrix);
				Pool.putMatrix(matrix);
			}
			if(clipHeight < 0)
			{
				clipHeight = 0;
			}
			this._textFieldSnapshotClipRect.width = clipWidth;
			this._textFieldSnapshotClipRect.height = clipHeight;
		}

		/**
		 * @private
		 */
		override protected function refreshTextFieldSize():void
		{
			var oldIgnoreScrolling:Boolean = this._ignoreScrolling;
			var gutterDimensionsOffset:Number = 4;
			if(this._useGutter)
			{
				gutterDimensionsOffset = 0;
			}
			this._ignoreScrolling = true;
			this.textField.width = this._actualVisibleWidth - this._paddingLeft - this._paddingRight + gutterDimensionsOffset;
			var textFieldHeight:Number = this._actualVisibleHeight - this._paddingTop - this._paddingBottom + gutterDimensionsOffset;
			if(this.textField.height != textFieldHeight)
			{
				this.textField.height = textFieldHeight;
			}
			var scroller:Scroller = Scroller(this.parent);
			this.textField.scrollV = Math.round(1 + ((this.textField.maxScrollV - 1) * (this._verticalScrollPosition / scroller.maxVerticalScrollPosition)));
			this._ignoreScrolling = oldIgnoreScrolling;
		}

		/**
		 * @private
		 */
		override protected function commitStylesAndData(textField:TextField):void
		{
			super.commitStylesAndData(textField);
			if(textField == this.textField)
			{
				this._scrollStep = textField.getLineMetrics(0).height;
			}
		}

		/**
		 * @private
		 */
		override protected function transformTextField():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			var scaleFactor:Number = starling.contentScaleFactor / nativeScaleFactor;
			var matrix:Matrix = Pool.getMatrix();
			var point:Point = Pool.getPoint();
			this.getTransformationMatrix(this.stage, matrix);
			MatrixUtil.transformCoords(matrix, 0, 0, point);
			var scaleX:Number = matrixToScaleX(matrix) * scaleFactor;
			var scaleY:Number = matrixToScaleY(matrix) * scaleFactor;
			var offsetX:Number = Math.round(this._paddingLeft * scaleX);
			var offsetY:Number = Math.round((this._paddingTop + this._verticalScrollPosition) * scaleY);
			var starlingViewPort:Rectangle = starling.viewPort;
			var gutterPositionOffset:Number = 2;
			if(this._useGutter)
			{
				gutterPositionOffset = 0;
			}
			this.textField.x = offsetX + Math.round(starlingViewPort.x + (point.x * scaleFactor) - gutterPositionOffset * scaleX);
			this.textField.y = offsetY + Math.round(starlingViewPort.y + (point.y * scaleFactor) - gutterPositionOffset * scaleY);
			this.textField.rotation = matrixToRotation(matrix) * 180 / Math.PI;
			this.textField.scaleX = scaleX;
			this.textField.scaleY = scaleY;
			Pool.putPoint(point);
			Pool.putMatrix(matrix);
		}

		/**
		 * @private
		 */
		override protected function positionSnapshot():void
		{
			if(!this.textSnapshot)
			{
				return;
			}
			var matrix:Matrix = Pool.getMatrix();
			this.getTransformationMatrix(this.stage, matrix);
			this.textSnapshot.x = this._paddingLeft + Math.round(matrix.tx) - matrix.tx;
			this.textSnapshot.y = this._paddingTop + this._verticalScrollPosition + Math.round(matrix.ty) - matrix.ty;
			Pool.putMatrix(matrix);
		}

		/**
		 * @private
		 */
		override protected function checkIfNewSnapshotIsNeeded():void
		{
			super.checkIfNewSnapshotIsNeeded();
			this._needsNewTexture ||= this.isInvalid(INVALIDATION_FLAG_SCROLL);
		}

		/**
		 * @private
		 */
		override protected function textField_focusInHandler(event:FocusEvent):void
		{
			this.textField.addEventListener(Event.SCROLL, textField_scrollHandler);
			super.textField_focusInHandler(event);
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		override protected function textField_focusOutHandler(event:FocusEvent):void
		{
			this.textField.removeEventListener(Event.SCROLL, textField_scrollHandler);
			super.textField_focusOutHandler(event);
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function textField_scrollHandler(event:Event):void
		{
			//for some reason, the text field's scroll positions don't work
			//properly unless we access the values here. weird.
			var scrollH:Number = this.textField.scrollH;
			var scrollV:Number = this.textField.scrollV;
			if(this._ignoreScrolling)
			{
				return;
			}
			var scroller:Scroller = Scroller(this.parent);
			if(scroller.maxVerticalScrollPosition > 0 && this.textField.maxScrollV > 1)
			{
				var calculatedVerticalScrollPosition:Number = scroller.maxVerticalScrollPosition * (scrollV - 1) / (this.textField.maxScrollV - 1);
				scroller.verticalScrollPosition = roundToNearest(calculatedVerticalScrollPosition, this._scrollStep);
			}
		}

	}
}
