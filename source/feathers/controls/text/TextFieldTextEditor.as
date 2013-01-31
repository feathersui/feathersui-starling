/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;

	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.events.FocusEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.utils.MatrixUtil;
	import starling.utils.getNextPowerOfTwo;

	/**
	 * Dispatched when the text property changes.
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user presses the Enter key while the editor has focus.
	 *
	 * @eventType feathers.events.FeathersEventType.ENTER
	 */
	[Event(name="enter",type="starling.events.Event")]

	/**
	 * Dispatched when the text editor receives focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the text editor loses focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * A Feathers text editor that uses the native <code>TextField</code> class
	 * set to <code>TextInputType.INPUT</code>.
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-editors
	 * @see flash.text.TextField
	 */
	public class TextFieldTextEditor extends FeathersControl implements ITextEditor
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_POSITION:String = "position";

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
		public function TextFieldTextEditor()
		{
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The text field sub-component.
		 */
		protected var textField:TextField;

		/**
		 * An image that displays a snapshot of the native <code>TextField</code>
		 * in the Starling display list when the editor doesn't have focus.
		 */
		protected var textSnapshot:Image;

		/**
		 * @private
		 */
		protected var _textSnapshotBitmapData:BitmapData;

		/**
		 * @private
		 */
		protected var _oldGlobalX:Number = 0;

		/**
		 * @private
		 */
		protected var _oldGlobalY:Number = 0;

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
		protected var _frameCount:int = 0;

		/**
		 * @private
		 */
		protected var _savedSelectionIndex:int = -1;

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
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._text == value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _textFormat:TextFormat;

		/**
		 * The format of the text, such as font and styles.
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
		protected var _alwaysShowSelection:Boolean = false;

		/**
		 * Same as the <code>flash.text.TextField</code> property with the same name.
		 */
		public function get alwaysShowSelection():Boolean
		{
			return this._alwaysShowSelection;
		}

		/**
		 * @private
		 */
		public function set alwaysShowSelection(value:Boolean):void
		{
			if(this._alwaysShowSelection == value)
			{
				return;
			}
			this._alwaysShowSelection = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _displayAsPassword:Boolean = false;

		/**
		 * Same as the <code>flash.text.TextField</code> property with the same name.
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
		protected var _maxChars:int = int.MAX_VALUE;

		/**
		 * Same as the <code>flash.text.TextField</code> property with the same name.
		 */
		public function get maxChars():int
		{
			return this._maxChars;
		}

		/**
		 * @private
		 */
		public function set maxChars(value:int):void
		{
			if(this._maxChars == value)
			{
				return;
			}
			this._maxChars = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _restrict:String;

		/**
		 * Same as the <code>flash.text.TextField</code> property with the same name.
		 */
		public function get restrict():String
		{
			return this._restrict;
		}

		/**
		 * @private
		 */
		public function set restrict(value:String):void
		{
			if(this._restrict == value)
			{
				return;
			}
			this._restrict = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textFieldHasFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _isWaitingToSetFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _pendingSelectionStartIndex:int = -1;

		/**
		 * @private
		 */
		protected var _pendingSelectionEndIndex:int = -1;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this.textField.parent)
			{
				Starling.current.nativeStage.removeChild(this.textField);
			}
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			HELPER_POINT.x = HELPER_POINT.y = 0;
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
			if(HELPER_POINT.x != this._oldGlobalX || HELPER_POINT.y != this._oldGlobalY)
			{
				this._oldGlobalX = HELPER_POINT.x;
				this._oldGlobalY = HELPER_POINT.y;
				const starlingViewPort:Rectangle = Starling.current.viewPort;
				this.textField.x = Math.round(starlingViewPort.x + (HELPER_POINT.x * Starling.contentScaleFactor));
				this.textField.y = Math.round(starlingViewPort.y + (HELPER_POINT.y * Starling.contentScaleFactor));
			}

			if(this.textSnapshot)
			{
				this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
				this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
			}

			//theoretically, this will ensure that the TextField is set visible
			//or invisible immediately after the snapshot changes visibility in
			//the rendered graphics. the OS might take longer to do the change,
			//though.
			this.textField.visible = this.textSnapshot ? !this.textSnapshot.visible : this._textFieldHasFocus;
			super.render(support, parentAlpha);
		}

		/**
		 * @inheritDoc
		 */
		public function setFocus(position:Point = null):void
		{
			if(this.textField)
			{
				if(!this.textField.parent)
				{
					Starling.current.nativeStage.addChild(this.textField);
				}
				if(position)
				{
					const positionX:Number = position.x;
					const positionY:Number = position.y;
					if(positionX < 0)
					{
						this._savedSelectionIndex = 0;
					}
					else
					{
						this._savedSelectionIndex = this.textField.getCharIndexAtPoint(positionX, positionY);
						const bounds:Rectangle = this.textField.getCharBoundaries(this._savedSelectionIndex);
						if(bounds && (bounds.x + bounds.width - positionX) < (positionX - bounds.x))
						{
							this._savedSelectionIndex++;
						}
					}
				}
				else
				{
					this._savedSelectionIndex = -1;
				}
				Starling.current.nativeStage.focus = this.textField;
			}
			else
			{
				this._isWaitingToSetFocus = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function selectRange(startIndex:int, endIndex:int):void
		{
			if(this.textField)
			{
				this.validate();
				this.textField.setSelection(startIndex, endIndex);
			}
			else
			{
				this._pendingSelectionStartIndex = startIndex;
				this._pendingSelectionEndIndex = endIndex;
			}
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.textField = new TextField();
			this.textField.type = TextFieldType.INPUT;
			this.textField.selectable = true;
			this.textField.addEventListener(flash.events.Event.CHANGE, textField_changeHandler);
			this.textField.addEventListener(FocusEvent.FOCUS_IN, textField_focusInHandler);
			this.textField.addEventListener(FocusEvent.FOCUS_OUT, textField_focusOutHandler);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const positionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_POSITION);
			const skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);

			if(dataInvalid || stylesInvalid)
			{
				this.commitStylesAndData();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layout(sizeInvalid);

			this.doPendingActions();
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

			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this.textField.wordWrap = false;

			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = Math.max(this._minWidth, Math.min(this._maxWidth, this.textField.width));
			}

			this.textField.width = newWidth;
			this.textField.wordWrap = this._wordWrap;
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = Math.max(this._minHeight, Math.min(this._maxHeight, this.textField.height));
			}

			this.textField.autoSize = TextFieldAutoSize.NONE;

			//put the width and height back just in case we measured without
			//a full validation
			this.textField.width = this.actualWidth;
			this.textField.height = this.actualHeight;

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function commitStylesAndData():void
		{
			this.textField.maxChars = this._maxChars;
			this.textField.restrict = this._restrict;
			this.textField.alwaysShowSelection = this._alwaysShowSelection;
			this.textField.displayAsPassword = this._displayAsPassword;
			this.textField.wordWrap = this._wordWrap;
			this.textField.embedFonts = this._embedFonts;
			if(this._textFormat)
			{
				this.textField.defaultTextFormat = this._textFormat;
			}
			if(this._isHTML)
			{
				this.textField.htmlText = this._text;
			}
			else
			{
				this.textField.text = this._text;
			}
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
				this.textField.width = this.actualWidth;
				this.textField.height = this.actualHeight;
				this._snapshotWidth = getNextPowerOfTwo(this.actualWidth * Starling.contentScaleFactor);
				this._snapshotHeight = getNextPowerOfTwo(this.actualHeight * Starling.contentScaleFactor);
				this._needsNewBitmap = this._needsNewBitmap || !this._textSnapshotBitmapData || this._snapshotWidth != this._textSnapshotBitmapData.width || this._snapshotHeight != this._textSnapshotBitmapData.height;
			}

			if(!this._textFieldHasFocus && (stylesInvalid || dataInvalid || this._needsNewBitmap))
			{
				const hasText:Boolean = this._text.length > 0;
				if(hasText)
				{
					//we need to wait a frame (sometimes two!) for the TextField
					//to render properly. yes, really.
					this._frameCount = 0;
					this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
			}
		}

		/**
		 * @private
		 */
		protected function doPendingActions():void
		{
			if(this._isWaitingToSetFocus)
			{
				this._isWaitingToSetFocus = false;
				this.setFocus();
			}

			if(this._pendingSelectionStartIndex >= 0)
			{
				const startIndex:int = this._pendingSelectionStartIndex;
				const endIndex:int = this._pendingSelectionEndIndex;
				this._pendingSelectionStartIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.selectRange(startIndex, endIndex);
			}
		}

		/**
		 * @private
		 */
		protected function refreshSnapshot():void
		{
			if(this.textField.width == 0 || this.textField.height == 0)
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
			this._textSnapshotBitmapData.draw(this.textField, HELPER_MATRIX);
			if(!this.textSnapshot)
			{
				this.textSnapshot = new Image(starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor));
				this.addChild(this.textSnapshot);
			}
			else
			{
				if(this._needsNewBitmap)
				{
					this.textSnapshot.texture.dispose();
					this.textSnapshot.texture = starling.textures.Texture.fromBitmapData(this._textSnapshotBitmapData, false, false, Starling.contentScaleFactor);
					this.textSnapshot.readjustSize();
				}
				else
				{
					//this is faster if we haven't resized the bitmapdata
					const texture:starling.textures.Texture = this.textSnapshot.texture;
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
		protected function removedFromStageHandler(event:Event):void
		{
			if(this.textField.parent)
			{
				Starling.current.nativeStage.removeChild(this.textField);
			}
		}

		/**
		 * @private
		 */
		protected function enterFrameHandler(event:Event):void
		{
			this._frameCount++;
			if(this._frameCount < 2)
			{
				return;
			}
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if(this.textSnapshot)
			{
				this.textSnapshot.visible = this._text.length > 0;
			}
			this.refreshSnapshot();
		}

		/**
		 * @private
		 */
		protected function textField_changeHandler(event:flash.events.Event):void
		{
			this.text = this.textField.text;
		}

		/**
		 * @private
		 */
		protected function textField_focusInHandler(event:FocusEvent):void
		{
			this._textFieldHasFocus = true;
			if(this.textSnapshot)
			{
				this.textSnapshot.visible = false;
			}
			if(this._savedSelectionIndex >= 0)
			{
				const selectionIndex:int = this._savedSelectionIndex;
				this._savedSelectionIndex = -1;
				this.selectRange(selectionIndex, selectionIndex)
			}
			this.invalidate(INVALIDATION_FLAG_SKIN);
			this.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}

		/**
		 * @private
		 */
		protected function textField_focusOutHandler(event:FocusEvent):void
		{
			this._textFieldHasFocus = false;

			this.textField.scrollH = this.textField.scrollV = 0;

			this.invalidate(INVALIDATION_FLAG_DATA);
			this.invalidate(INVALIDATION_FLAG_SKIN);
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}
	}
}
