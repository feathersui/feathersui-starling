/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.controls.Scroller;
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

	/**
	 * A text editor view port for the <code>TextArea</code> component that uses
	 * <code>flash.text.TextField</code>.
	 *
	 * @see feathers.controls.TextArea
	 */
	public class TextFieldTextEditorViewPort extends TextFieldTextEditor implements ITextEditorViewPort
	{
		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

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
		private var _ignoreScrolling:Boolean = false;

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
		protected var _scrollStep:int = 0;

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
			if(this._horizontalScrollPosition == value)
			{
				return;
			}
			this._horizontalScrollPosition = value;
			this.invalidate(INVALIDATION_FLAG_SCROLL);
			//hack because the superclass doesn't know about the scroll flag
			this.invalidate(INVALIDATION_FLAG_SIZE);
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
		override protected function measure(result:Point = null):Point
		{
			if(!result)
			{
				result = new Point();
			}

			var needsWidth:Boolean = this._visibleWidth !== this._visibleWidth; //isNaN

			this.commitStylesAndData(this.measureTextField);

			var gutterDimensionsOffset:Number = 4;
			if(this._useGutter)
			{
				gutterDimensionsOffset = 0;
			}

			var newWidth:Number = this._visibleWidth;
			this.measureTextField.width = newWidth + gutterDimensionsOffset;
			if(needsWidth)
			{
				newWidth = this.measureTextField.width - gutterDimensionsOffset;
				if(newWidth < this._minVisibleWidth)
				{
					newWidth = this._minVisibleWidth;
				}
				else if(newWidth > this._maxVisibleWidth)
				{
					newWidth = this._maxVisibleWidth;
				}
			}
			var newHeight:Number = this.measureTextField.height - gutterDimensionsOffset;
			if(this._useGutter)
			{
				newHeight += 4;
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
			var textFieldWidth:Number = this._visibleWidth;
			if(textFieldWidth !== textFieldWidth) //isNaN
			{
				if(this._maxVisibleWidth < Number.POSITIVE_INFINITY)
				{
					textFieldWidth = this._maxVisibleWidth;
				}
				else
				{
					textFieldWidth = this._minVisibleWidth;
				}
			}
			var textFieldHeight:Number = this._visibleHeight;
			if(textFieldHeight !== textFieldHeight) //isNaN
			{
				if(this._maxVisibleHeight < Number.POSITIVE_INFINITY)
				{
					textFieldHeight = this._maxVisibleHeight;
				}
				else
				{
					textFieldHeight = this._minVisibleHeight;
				}
			}

			this._textFieldOffsetX = 0;
			this._textFieldOffsetY = 0;
			this._textFieldClipRect.x = 0;
			this._textFieldClipRect.y = 0;

			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			var clipWidth:Number = textFieldWidth * Starling.contentScaleFactor * matrixToScaleX(HELPER_MATRIX);
			if(clipWidth < 0)
			{
				clipWidth = 0;
			}
			var clipHeight:Number = textFieldHeight * Starling.contentScaleFactor * matrixToScaleY(HELPER_MATRIX);
			if(clipHeight < 0)
			{
				clipHeight = 0;
			}
			this._textFieldClipRect.width = clipWidth;
			this._textFieldClipRect.height = clipHeight;
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
			this.textField.width = this._visibleWidth + gutterDimensionsOffset;
			var textFieldHeight:Number = this._visibleHeight + gutterDimensionsOffset;
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
			if(!this.textField.visible)
			{
				return;
			}
			var nativeScaleFactor:Number = 1;
			if(Starling.current.supportHighResolutions)
			{
				nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
			}
			var scaleFactor:Number = Starling.contentScaleFactor / nativeScaleFactor;
			HELPER_POINT.x = HELPER_POINT.y = 0;
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
			var scaleX:Number = matrixToScaleX(HELPER_MATRIX) * scaleFactor;
			var scaleY:Number = matrixToScaleY(HELPER_MATRIX) * scaleFactor;
			var offsetX:Number = Math.round(this._horizontalScrollPosition * scaleX);
			var offsetY:Number = Math.round(this._verticalScrollPosition * scaleY);
			var starlingViewPort:Rectangle = Starling.current.viewPort;
			var gutterPositionOffset:Number = 2;
			if(this._useGutter)
			{
				gutterPositionOffset = 0;
			}
			this.textField.x = offsetX + Math.round(starlingViewPort.x + (HELPER_POINT.x * scaleFactor) - gutterPositionOffset * scaleX);
			this.textField.y = offsetY + Math.round(starlingViewPort.y + (HELPER_POINT.y * scaleFactor) - gutterPositionOffset * scaleY);
			this.textField.rotation = matrixToRotation(HELPER_MATRIX) * 180 / Math.PI;
			this.textField.scaleX = scaleX;
			this.textField.scaleY = scaleY;
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
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			this.textSnapshot.x = this._horizontalScrollPosition + Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
			this.textSnapshot.y = this._verticalScrollPosition + Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
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
