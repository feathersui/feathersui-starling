/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.FocusManager;
	import feathers.core.INativeFocusOwner;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.utils.text.TextInputNavigation;
	import feathers.utils.text.TextInputRestrict;

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.rendering.Painter;
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;
	import starling.utils.Pool;

	/**
	 * Dispatched when the text property changes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see #text
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user presses the Enter key while the editor has
	 * focus.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.FeathersEventType.ENTER
	 */
	[Event(name="enter",type="starling.events.Event")]

	/**
	 * Dispatched when the text editor receives focus.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the text editor loses focus.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * Text that may be edited at runtime by the user with the
	 * <code>TextInput</code> component, rendered with
	 * <a href="http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts" target="_top">bitmap fonts</a>.
	 * 
	 * <p>The following example shows how to use
	 * <code>BitmapFontTextEditor</code> with a <code>TextInput</code>:</p>
	 * 
	 * <listing version="3.0">
	 * var input:TextInput = new TextInput();
	 * input.textEditorFactory = function():ITextEditor
	 * {
	 *     return new BitmapFontTextEditor();
	 * };
	 * this.addChild( input );</listing>
	 *
	 * <p><strong>Warning:</strong> This text editor is intended for use in
	 * desktop applications only, and it does not provide support for software
	 * keyboards on mobile devices.</p>
	 *
	 * @see feathers.controls.TextInput
	 * @see ../../../../help/text-editors.html Introduction to Feathers text editors
	 * @see http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts Starling Wiki: Displaying Text with Bitmap Fonts
	 *
	 * @productversion Feathers 2.0.0
	 */
	public class BitmapFontTextEditor extends BitmapFontTextRenderer implements ITextEditor, INativeFocusOwner
	{
		/**
		 * @private
		 */
		protected static const LINE_FEED:String = "\n";

		/**
		 * @private
		 */
		protected static const CARRIAGE_RETURN:String = "\r";

		/**
		 * The default <code>IStyleProvider</code> for all <code>BitmapFontTextEditor</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function BitmapFontTextEditor()
		{
			super();
			this._text = "";
			this.isQuickHitAreaEnabled = true;
			this.truncateToFit = false;
			this.addEventListener(TouchEvent.TOUCH, textEditor_touchHandler);
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
		protected var _selectionSkin:DisplayObject;

		/**
		 * The skin that indicates the currently selected range of text.
		 */
		public function get selectionSkin():DisplayObject
		{
			return this._selectionSkin;
		}

		/**
		 * @private
		 */
		public function set selectionSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._selectionSkin == value)
			{
				return;
			}
			if(this._selectionSkin && this._selectionSkin.parent == this)
			{
				this._selectionSkin.removeFromParent();
			}
			this._selectionSkin = value;
			if(this._selectionSkin)
			{
				this._selectionSkin.visible = false;
				this.addChildAt(this._selectionSkin, 0);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _cursorDelay:Number = 0.53;

		/**
		 * @private
		 */
		protected var _cursorDelayID:uint = uint.MAX_VALUE;

		/**
		 * @private
		 */
		protected var _cursorSkin:DisplayObject;

		/**
		 * The skin that indicates the current position where text may be
		 * entered.
		 */
		public function get cursorSkin():DisplayObject
		{
			return this._cursorSkin;
		}

		/**
		 * @private
		 */
		public function set cursorSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._cursorSkin === value)
			{
				return;
			}
			if(this._cursorSkin !== null && this._cursorSkin.parent === this)
			{
				this._cursorSkin.removeFromParent();
			}
			this._cursorSkin = value;
			if(this._cursorSkin !== null)
			{
				this._cursorSkin.visible = false;
				this.addChild(this._cursorSkin);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _unmaskedText:String;

		/**
		 * @private
		 */
		protected var _displayAsPassword:Boolean = false;

		/**
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 *
		 * @copy feathers.controls.TextInput#displayAsPassword
		 *
		 * @see feathers.controls.TextInput#displayAsPassword
		 * @see #passwordCharCode
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
			if(this._displayAsPassword)
			{
				this._unmaskedText = this._text;
				this.refreshMaskedText();
			}
			else
			{
				this._text = this._unmaskedText;
				this._unmaskedText = null;
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _passwordCharCode:int = 42; //asterisk

		/**
		 * The character code of the character used to display a password.
		 *
		 * <p>In the following example, the substitute character for passwords
		 * is set to a bullet:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.displayAsPassword = true;
		 * textEditor.passwordCharCode = "•".charCodeAt(0);</listing>
		 *
		 * @default 42 (asterisk)
		 *
		 * @see #displayAsPassword
		 */
		public function get passwordCharCode():int
		{
			return this._passwordCharCode;
		}

		/**
		 * @private
		 */
		public function set passwordCharCode(value:int):void
		{
			if(this._passwordCharCode == value)
			{
				return;
			}
			this._passwordCharCode = value;
			if(this._displayAsPassword)
			{
				this.refreshMaskedText();
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isEditable:Boolean = true;

		/**
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 * 
		 * @copy feathers.controls.TextInput#isEditable
		 *
		 * @see feathers.controls.TextInput#isEditable
		 */
		public function get isEditable():Boolean
		{
			return this._isEditable;
		}

		/**
		 * @private
		 */
		public function set isEditable(value:Boolean):void
		{
			if(this._isEditable == value)
			{
				return;
			}
			this._isEditable = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isSelectable:Boolean = true;

		/**
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 * 
		 * @copy feathers.controls.TextInput#isSelectable
		 *
		 * @see feathers.controls.TextInput#isSelectable
		 */
		public function get isSelectable():Boolean
		{
			return this._isSelectable;
		}

		/**
		 * @private
		 */
		public function set isSelectable(value:Boolean):void
		{
			if(this._isSelectable == value)
			{
				return;
			}
			this._isSelectable = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @inheritDoc
		 *
		 * @default false
		 */
		public function get setTouchFocusOnEndedPhase():Boolean
		{
			return false;
		}

		/**
		 * @private
		 */
		override public function get text():String
		{
			if(this._displayAsPassword)
			{
				return this._unmaskedText;
			}
			return this._text;
		}

		/**
		 * @private
		 */
		override public function set text(value:String):void
		{
			if(value === null)
			{
				//don't allow null or undefined
				value = "";
			}
			var currentValue:String = this._text;
			if(this._displayAsPassword)
			{
				currentValue = this._unmaskedText;
			}
			if(currentValue == value)
			{
				return;
			}
			if(this._displayAsPassword)
			{
				this._unmaskedText = value;
				this.refreshMaskedText();
			}
			else
			{
				this._text = value;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
			var textLength:int = this._text.length;
			//we need to account for the possibility that the text is in the
			//middle of being selected when it changes
			if(this._selectionAnchorIndex > textLength)
			{
				this._selectionAnchorIndex = textLength;
			}
			//then, we need to make sure the selected range is still valid
			if(this._selectionBeginIndex > textLength)
			{
				this.selectRange(textLength, textLength);
			}
			else if(this._selectionEndIndex > textLength)
			{
				this.selectRange(this._selectionBeginIndex, textLength);
			}
			this.dispatchEventWith(starling.events.Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _maxChars:int = 0;

		/**
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 * 
		 * @copy feathers.controls.TextInput#maxChars
		 *
		 * @see feathers.controls.TextInput#maxChars
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
		protected var _restrict:TextInputRestrict;

		/**
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 * 
		 * @copy feathers.controls.TextInput#restrict
		 *
		 * @see feathers.controls.TextInput#restrict
		 */
		public function get restrict():String
		{
			if(!this._restrict)
			{
				return null;
			}
			return this._restrict.restrict;
		}

		/**
		 * @private
		 */
		public function set restrict(value:String):void
		{
			if(this._restrict && this._restrict.restrict === value)
			{
				return;
			}
			if(!this._restrict && value === null)
			{
				return;
			}
			if(value === null)
			{
				this._restrict = null;
			}
			else
			{
				if(this._restrict)
				{
					this._restrict.restrict = value;
				}
				else
				{

					this._restrict = new TextInputRestrict(value);
				}
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectionBeginIndex:int = 0;

		/**
		 * @inheritDoc
		 *
		 * @see #selectionEndIndex
		 */
		public function get selectionBeginIndex():int
		{
			return this._selectionBeginIndex;
		}

		/**
		 * @private
		 */
		protected var _selectionEndIndex:int = 0;

		/**
		 * @inheritDoc
		 *
		 * @see #selectionBeginIndex
		 */
		public function get selectionEndIndex():int
		{
			return this._selectionEndIndex;
		}

		/**
		 * @private
		 */
		protected var _selectionAnchorIndex:int = 0;

		/**
		 * @private
		 */
		protected var _scrollX:Number = 0;

		/**
		 * @private
		 */
		protected var touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _nativeFocus:Sprite;

		/**
		 * @copy feathers.core.INativeFocusOwner#nativeFocus
		 */
		public function get nativeFocus():Object
		{
			return this._nativeFocus;
		}

		/**
		 * @private
		 */
		protected var _isWaitingToSetFocus:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function setFocus(position:Point = null):void
		{
			if(this._hasFocus && !position)
			{
				//we already have focus, and there isn't a touch position, we
				//can ignore this because nothing would change
				return;
			}
			if(this._nativeFocus !== null)
			{
				if(this._nativeFocus.parent === null)
				{
					var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
					starling.nativeStage.addChild(this._nativeFocus);
				}
				var newIndex:int = -1;
				if(position !== null)
				{
					newIndex = this.getSelectionIndexAtPoint(position.x, position.y);
				}
				if(newIndex >= 0)
				{
					this.selectRange(newIndex, newIndex);
				}
				this.focusIn();
			}
			else
			{
				this._isWaitingToSetFocus = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function clearFocus():void
		{
			if(!this._hasFocus)
			{
				return;
			}
			this._hasFocus = false;
			this._cursorSkin.visible = false;
			this._selectionSkin.visible = false;
			this.refreshCursorBlink();
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this.removeEventListener(starling.events.Event.ENTER_FRAME, hasFocus_enterFrameHandler);
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var nativeStage:Stage = starling.nativeStage;
			if(nativeStage.focus === this._nativeFocus)
			{
				//only clear the native focus when our native target has focus
				//because otherwise another component may lose focus.

				//for consistency with StageTextTextEditor and
				//TextFieldTextEditor, we set the native stage's focus to null
				//here instead of setting it to the native stage due to issues
				//with those text editors on Android.
				nativeStage.focus = null;
			}
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}

		/**
		 * @inheritDoc
		 */
		public function selectRange(beginIndex:int, endIndex:int):void
		{
			if(!this._isEditable && !this._isSelectable)
			{
				return;
			}
			if(endIndex < beginIndex)
			{
				var temp:int = endIndex;
				endIndex = beginIndex;
				beginIndex = temp;
			}
			this._selectionBeginIndex = beginIndex;
			this._selectionEndIndex = endIndex;
			if(beginIndex === endIndex)
			{
				this._selectionAnchorIndex = beginIndex;
				if(beginIndex < 0)
				{
					this._cursorSkin.visible = false;
				}
				else
				{
					//cursor skin is not shown if isSelectable === true and
					//isEditable is false
					this._cursorSkin.visible = this._hasFocus && this._isEditable;
				}
				this._selectionSkin.visible = false;
			}
			else
			{
				this._cursorSkin.visible = false;
				this._selectionSkin.visible = true;
			}
			this.refreshCursorBlink();
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._nativeFocus && this._nativeFocus.parent)
			{
				this._nativeFocus.parent.removeChild(this._nativeFocus);
			}
			this._nativeFocus = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(painter:Painter):void
		{
			var oldBatchX:Number = this._batchX;
			var oldCursorX:Number = this._cursorSkin.x;
			this._batchX -= this._scrollX;
			this._cursorSkin.x -= this._scrollX;
			super.render(painter);
			this._batchX = oldBatchX;
			this._cursorSkin.x = oldCursorX;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._nativeFocus)
			{
				this._nativeFocus = new Sprite();
				//let's ensure that this can only get focus through code
				this._nativeFocus.tabEnabled = false;
				this._nativeFocus.tabChildren = false;
				this._nativeFocus.mouseEnabled = false;
				this._nativeFocus.mouseChildren = false;
				//adds support for mobile
				this._nativeFocus.needsSoftKeyboard = true;
			}
			this._nativeFocus.addEventListener(flash.events.Event.CUT, nativeFocus_cutHandler, false, 0, true);
			this._nativeFocus.addEventListener(flash.events.Event.COPY, nativeFocus_copyHandler, false, 0, true);
			this._nativeFocus.addEventListener(flash.events.Event.PASTE, nativeFocus_pasteHandler, false, 0, true);
			this._nativeFocus.addEventListener(flash.events.Event.SELECT_ALL, nativeFocus_selectAllHandler, false, 0, true);
			this._nativeFocus.addEventListener(TextEvent.TEXT_INPUT, nativeFocus_textInputHandler, false, 0, true);
			if(!this._cursorSkin)
			{
				this.ignoreNextStyleRestriction();
				this.cursorSkin = new Quad(1, 1, 0x000000);
			}
			if(!this._selectionSkin)
			{
				this.ignoreNextStyleRestriction();
				this.selectionSkin = new Quad(1, 1, 0x000000);
			}
			super.initialize();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			
			super.draw();
			
			if(dataInvalid || selectionInvalid)
			{
				this.positionCursorAtCharIndex(this.getCursorIndexFromSelectionRange());
				this.positionSelectionBackground();
			}

			var mask:Quad = this.mask as Quad;
			if(mask)
			{
				mask.x = 0;
				mask.y = 0;
				mask.width = this.actualWidth;
				mask.height = this.actualHeight;
			}
			else
			{
				mask = new Quad(1, 1, 0xff00ff);
				//the initial dimensions cannot be 0 or there's a runtime error,
				//and these values might be 0
				mask.width = this.actualWidth;
				mask.height = this.actualHeight;
				this.mask = mask;
			}
		}

		/**
		 * @private
		 */
		override protected function layoutCharacters(result:MeasureTextResult = null):MeasureTextResult
		{
			result = super.layoutCharacters(result);
			if(this._explicitWidth === this._explicitWidth && //!isNaN
				result.width > this._explicitWidth)
			{
				this._characterBatch.clear();
				var oldTextAlign:String = this._currentTextFormat.align;
				this._currentTextFormat.align = TextFormatAlign.LEFT;
				result = super.layoutCharacters(result);
				this._currentTextFormat.align = oldTextAlign;
			}
			return result;
		}

		/**
		 * @private
		 */
		override protected function refreshTextFormat():void
		{
			super.refreshTextFormat();
			if(this._cursorSkin)
			{
				var font:BitmapFont = this._currentTextFormat.font;
				var customSize:Number = this._currentTextFormat.size;
				var scale:Number = customSize / font.size;
				if(scale !== scale) //isNaN
				{
					scale = 1;
				}
				this._cursorSkin.height = font.lineHeight * scale;
			}
		}

		/**
		 * @private
		 */
		protected function refreshMaskedText():void
		{
			this._text = "";
			var textLength:int = this._unmaskedText.length;
			var maskChar:String = String.fromCharCode(this._passwordCharCode);
			for(var i:int = 0; i < textLength; i++)
			{
				this._text += maskChar;
			}
		}

		/**
		 * @private
		 */
		protected function focusIn():void
		{
			var showSelection:Boolean = (this._isEditable || this._isSelectable) &&
				this._selectionBeginIndex >= 0 &&
				this._selectionBeginIndex !== this._selectionEndIndex;
			var showCursor:Boolean = this._isEditable &&
				this._selectionBeginIndex >= 0 &&
				this._selectionBeginIndex === this._selectionEndIndex;
			this._cursorSkin.visible = showCursor;
			this._selectionSkin.visible = showSelection;
			this.refreshCursorBlink();
			if(!FocusManager.isEnabledForStage(this.stage))
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				//if there isn't a focus manager, we need to set focus manually
				starling.nativeStage.focus = this._nativeFocus;
			}
			this._nativeFocus.requestSoftKeyboard();
			if(this._hasFocus)
			{
				return;
			}
			//we're reusing this variable. since this isn't a display object
			//that the focus manager can see, it's not being used anyway.
			this._hasFocus = true;
			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this.addEventListener(starling.events.Event.ENTER_FRAME, hasFocus_enterFrameHandler);
			this.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}

		/**
		 * @private
		 */
		protected function refreshCursorBlink():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(this._cursorDelayID === uint.MAX_VALUE && this._cursorSkin.visible)
			{
				this._cursorSkin.alpha = 1;
				this._cursorDelayID = starling.juggler.delayCall(toggleCursorSkin, this._cursorDelay);
			}
			else if(this._cursorDelayID !== uint.MAX_VALUE && !this._cursorSkin.visible)
			{
				starling.juggler.removeByID(this._cursorDelayID);
				this._cursorDelayID = uint.MAX_VALUE;
			}
		}

		/**
		 * @private
		 */
		protected function toggleCursorSkin():void
		{
			if(this._cursorSkin.alpha > 0)
			{
				this._cursorSkin.alpha = 0;
			}
			else
			{
				this._cursorSkin.alpha = 1;
			}
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			this._cursorDelayID = starling.juggler.delayCall(toggleCursorSkin, this._cursorDelay);
		}

		/**
		 * @private
		 */
		protected function getSelectionIndexAtPoint(pointX:Number, pointY:Number):int
		{
			if(!this._text || pointX <= 0)
			{
				return 0;
			}
			var font:BitmapFont = this._currentTextFormat.font;
			var customSize:Number = this._currentTextFormat.size;
			var customLetterSpacing:Number = this._currentTextFormat.letterSpacing;
			var isKerningEnabled:Boolean = this._currentTextFormat.isKerningEnabled;
			var scale:Number = customSize / font.size;
			if(scale !== scale) //isNaN
			{
				scale = 1;
			}
			var align:String = this._currentTextFormat.align;
			if(align !== TextFormatAlign.LEFT)
			{
				var point:Point = Pool.getPoint();
				this.measureTextInternal(point, false);
				var lineWidth:Number = point.x;
				Pool.putPoint(point);
				var hasExplicitWidth:Boolean = this._explicitWidth === this._explicitWidth; //!isNaN
				var maxLineWidth:Number = hasExplicitWidth ? this._explicitWidth : this._explicitMaxWidth;
				if(maxLineWidth > lineWidth)
				{
					if(align === TextFormatAlign.RIGHT)
					{
						pointX -= maxLineWidth - lineWidth;
					}
					else //center
					{
						pointX -= (maxLineWidth - lineWidth) / 2;
					}
				}
			}
			var currentX:Number = 0;
			var previousCharID:Number = NaN;
			var charCount:int = this._text.length;
			for(var i:int = 0; i < charCount; i++)
			{
				var charID:int = this._text.charCodeAt(i);
				var charData:BitmapChar = font.getChar(charID);
				if(!charData)
				{
					continue;
				}
				var currentKerning:Number = 0;
				if(isKerningEnabled &&
					previousCharID === previousCharID) //!isNaN
				{
					currentKerning = charData.getKerning(previousCharID) * scale;
				}
				var charWidth:Number = customLetterSpacing + currentKerning + charData.xAdvance * scale;
				if(pointX >= currentX && pointX < (currentX + charWidth))
				{
					if(pointX > (currentX + charWidth / 2))
					{
						return i + 1;
					}
					return i;
				}
				currentX += charWidth;
				previousCharID = charID;
			}
			if(pointX >= currentX)
			{
				return this._text.length;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function getXPositionOfIndex(index:int):Number
		{
			var font:BitmapFont = this._currentTextFormat.font;
			var customSize:Number = this._currentTextFormat.size;
			var customLetterSpacing:Number = this._currentTextFormat.letterSpacing;
			var isKerningEnabled:Boolean = this._currentTextFormat.isKerningEnabled;
			var scale:Number = customSize / font.size;
			if(scale !== scale) //isNaN
			{
				scale = 1;
			}
			var xPositionOffset:Number = 0;
			var align:String = this._currentTextFormat.align;
			if(align !== TextFormatAlign.LEFT)
			{
				var point:Point = Pool.getPoint();
				this.measureTextInternal(point, false);
				var lineWidth:Number = point.x;
				Pool.putPoint(point);
				var hasExplicitWidth:Boolean = this._explicitWidth === this._explicitWidth; //!isNaN
				var maxLineWidth:Number = hasExplicitWidth ? this._explicitWidth : this._explicitMaxWidth;
				if(maxLineWidth > lineWidth)
				{
					if(align === TextFormatAlign.RIGHT)
					{
						xPositionOffset = maxLineWidth - lineWidth;
					}
					else //center
					{
						xPositionOffset = (maxLineWidth - lineWidth) / 2;
					}
				}
			}
			var currentX:Number = 0;
			var previousCharID:Number = NaN;
			var charCount:int = this._text.length;
			if(index < charCount)
			{
				charCount = index;
			}
			for(var i:int = 0; i < charCount; i++)
			{
				var charID:int = this._text.charCodeAt(i);
				var charData:BitmapChar = font.getChar(charID);
				if(!charData)
				{
					continue;
				}
				var currentKerning:Number = 0;
				if(isKerningEnabled &&
					previousCharID === previousCharID) //!isNaN
				{
					currentKerning = charData.getKerning(previousCharID) * scale;
				}
				currentX += customLetterSpacing + currentKerning + charData.xAdvance * scale;
				previousCharID = charID;
			}
			return currentX + xPositionOffset;
		}

		/**
		 * @private
		 */
		protected function positionCursorAtCharIndex(index:int):void
		{
			if(index < 0)
			{
				index = 0;
			}
			var cursorX:Number = this.getXPositionOfIndex(index);
			cursorX = int(cursorX - (this._cursorSkin.width / 2));
			this._cursorSkin.x = cursorX;
			this._cursorSkin.y = this._verticalAlignOffsetY;

			//then we update the scroll to always show the cursor
			var minScrollX:Number = cursorX + this._cursorSkin.width - this.actualWidth;
			var maxScrollX:Number = this.getXPositionOfIndex(this._text.length) - this.actualWidth;
			if(maxScrollX < 0)
			{
				maxScrollX = 0;
			}
			if(this._scrollX < minScrollX)
			{
				this._scrollX = minScrollX;
			}
			else if(this._scrollX > cursorX)
			{
				this._scrollX = cursorX;
			}
			if(this._scrollX > maxScrollX)
			{
				this._scrollX = maxScrollX;
			}
		}

		/**
		 * @private
		 */
		protected function getCursorIndexFromSelectionRange():int
		{
			var cursorIndex:int = this._selectionEndIndex;
			if(this.touchPointID >= 0 && this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionEndIndex)
			{
				cursorIndex = this._selectionBeginIndex;
			}
			return cursorIndex;
		}

		/**
		 * @private
		 */
		protected function positionSelectionBackground():void
		{
			var font:BitmapFont = this._currentTextFormat.font;
			var customSize:Number = this._currentTextFormat.size;
			var scale:Number = customSize / font.size;
			if(scale !== scale) //isNaN
			{
				scale = 1;
			}

			var startX:Number = this.getXPositionOfIndex(this._selectionBeginIndex) - this._scrollX;
			if(startX < 0)
			{
				startX = 0;
			}
			var endX:Number = this.getXPositionOfIndex(this._selectionEndIndex) - this._scrollX;
			if(endX < 0)
			{
				endX = 0;
			}
			this._selectionSkin.x = startX;
			this._selectionSkin.width = endX - startX;
			this._selectionSkin.y = this._verticalAlignOffsetY;
			this._selectionSkin.height = font.lineHeight * scale;
		}

		/**
		 * @private
		 */
		protected function getSelectedText():String
		{
			if(this._selectionBeginIndex == this._selectionEndIndex)
			{
				return null;
			}
			return this._text.substr(this._selectionBeginIndex, this._selectionEndIndex - this._selectionBeginIndex);
		}

		/**
		 * @private
		 */
		protected function deleteSelectedText():void
		{
			var currentValue:String = this._text;
			if(this._displayAsPassword)
			{
				currentValue = this._unmaskedText;
			}
			this.text = currentValue.substr(0, this._selectionBeginIndex) + currentValue.substr(this._selectionEndIndex);
			this.selectRange(this._selectionBeginIndex, this._selectionBeginIndex);
		}

		/**
		 * @private
		 */
		protected function replaceSelectedText(text:String):void
		{
			var currentValue:String = this._text;
			if(this._displayAsPassword)
			{
				currentValue = this._unmaskedText;
			}
			var newText:String = currentValue.substr(0, this._selectionBeginIndex) + text + currentValue.substr(this._selectionEndIndex);
			if(this._maxChars > 0 && newText.length > this._maxChars)
			{
				return;
			}
			this.text = newText;
			var selectionIndex:int = this._selectionBeginIndex + text.length;
			this.selectRange(selectionIndex, selectionIndex);
		}

		/**
		 * @private
		 */
		protected function hasFocus_enterFrameHandler(event:starling.events.Event):void
		{
			var target:DisplayObject = this;
			do
			{
				if(!target.visible)
				{
					this.clearFocus();
					break;
				}
				target = target.parent;
			}
			while(target)
		}

		/**
		 * @private
		 */
		protected function textEditor_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || (!this._isEditable && !this._isSelectable))
			{
				this.touchPointID = -1;
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, null, this.touchPointID);
				var point:Point = Pool.getPoint();
				touch.getLocation(this, point);
				point.x += this._scrollX;
				this.selectRange(this._selectionAnchorIndex, this.getSelectionIndexAtPoint(point.x, point.y));
				Pool.putPoint(point);
				if(touch.phase === TouchPhase.ENDED)
				{
					this.touchPointID = -1;
				}
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				if(touch.tapCount === 2)
				{
					var start:int = TextInputNavigation.findCurrentWordStartIndex(this._text, this._selectionBeginIndex);
					var end:int = TextInputNavigation.findCurrentWordEndIndex(this._text, this._selectionEndIndex);
					this.selectRange(start, end);
					return;
				}
				else if(touch.tapCount > 2)
				{
					this.selectRange(0, this._text.length);
					return;
				}
				this.touchPointID = touch.id;
				point = Pool.getPoint();
				touch.getLocation(this, point);
				point.x += this._scrollX;
				if(event.shiftKey)
				{
					if(this._selectionAnchorIndex < 0)
					{
						this._selectionAnchorIndex = this._selectionBeginIndex;
					}
					this.selectRange(this._selectionAnchorIndex, this.getSelectionIndexAtPoint(point.x, point.y));
				}
				else
				{
					this.setFocus(point);
				}
				Pool.putPoint(point);
			}
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			if(FocusManager.isEnabledForStage(this.stage))
			{
				//let the focus manager handle clearing focus
				return;
			}
			var touch:Touch = event.getTouch(this.stage, TouchPhase.BEGAN);
			if(!touch) //we only care about began touches
			{
				return;
			}
			var point:Point = Pool.getPoint();
			touch.getLocation(this.stage, point);
			var isInBounds:Boolean = this.contains(this.stage.hitTest(point));
			Pool.putPoint(point);
			if(isInBounds) //if the touch is in the text editor, it's all good
			{
				return;
			}
			//if the touch begins anywhere else, it's a focus out!
			this.clearFocus();
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this._isEnabled || (!this._isEditable && !this._isSelectable) ||
				this.touchPointID >= 0 || event.isDefaultPrevented())
			{
				return;
			}
			//ignore select all, cut, copy, and paste
			var charCode:uint = event.charCode;
			if(event.ctrlKey && (charCode == 97 || charCode == 99 || charCode == 118 || charCode == 120)) //a, c, p, and x
			{
				return;
			}
			var newIndex:int = -1;
			if(!FocusManager.isEnabledForStage(this.stage) && event.keyCode == Keyboard.TAB)
			{
				this.clearFocus();
				return;
			}
			else if(event.keyCode == Keyboard.HOME || event.keyCode == Keyboard.UP)
			{
				newIndex = 0;
				if(event.shiftKey)
				{
					this.selectRange(newIndex, this._selectionAnchorIndex);
					return;
				}
			}
			else if(event.keyCode == Keyboard.END || event.keyCode == Keyboard.DOWN)
			{
				newIndex = this._text.length;
				if(event.shiftKey)
				{
					this.selectRange(this._selectionAnchorIndex, newIndex);
					return;
				}
			}
			else if(event.keyCode == Keyboard.LEFT)
			{
				if(event.shiftKey)
				{
					if(this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionBeginIndex &&
						this._selectionBeginIndex != this._selectionEndIndex)
					{
						newIndex = this._selectionEndIndex - 1;
						this.selectRange(this._selectionBeginIndex, newIndex);
					}
					else
					{
						newIndex = this._selectionBeginIndex - 1;
						if(newIndex < 0)
						{
							newIndex = 0;
						}
						this.selectRange(newIndex, this._selectionEndIndex);
					}
					return;
				}
				else if(this._selectionBeginIndex != this._selectionEndIndex)
				{
					newIndex = this._selectionBeginIndex;
				}
				else
				{
					if(event.altKey || event.ctrlKey)
					{
						newIndex = TextInputNavigation.findPreviousWordStartIndex(this._text, this._selectionBeginIndex);
					}
					else
					{
						newIndex = this._selectionBeginIndex - 1;
					}
					if(newIndex < 0)
					{
						newIndex = 0;
					}
				}
			}
			else if(event.keyCode == Keyboard.RIGHT)
			{
				if(event.shiftKey)
				{
					if(this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionEndIndex &&
						this._selectionBeginIndex != this._selectionEndIndex)
					{
						newIndex = this._selectionBeginIndex + 1;
						this.selectRange(newIndex, this._selectionEndIndex);
					}
					else
					{
						newIndex = this._selectionEndIndex + 1;
						if(newIndex < 0 || newIndex > this._text.length)
						{
							newIndex = this._text.length;
						}
						this.selectRange(this._selectionBeginIndex, newIndex);
					}
					return;
				}
				else if(this._selectionBeginIndex != this._selectionEndIndex)
				{
					newIndex = this._selectionEndIndex;
				}
				else
				{
					if(event.altKey || event.ctrlKey)
					{
						newIndex = TextInputNavigation.findNextWordStartIndex(this._text, this._selectionEndIndex);
					}
					else
					{
						newIndex = this._selectionEndIndex + 1;
					}
					if(newIndex < 0 || newIndex > this._text.length)
					{
						newIndex = this._text.length;
					}
				}
			}
			if(newIndex < 0)
			{
				if(event.keyCode == Keyboard.ENTER)
				{
					this.dispatchEventWith(FeathersEventType.ENTER);
					return;
				}
				//everything after this point edits the text, so return if the text
				//editor isn't editable.
				if(!this._isEditable)
				{
					return;
				}
				var currentValue:String = this._text;
				if(this._displayAsPassword)
				{
					currentValue = this._unmaskedText;
				}
				if(event.keyCode == Keyboard.DELETE)
				{
					if(event.altKey || event.ctrlKey)
					{
						var nextWordStartIndex:int = TextInputNavigation.findNextWordStartIndex(this._text, this._selectionEndIndex);
						this.text = currentValue.substr(0, this._selectionBeginIndex) + currentValue.substr(nextWordStartIndex);
					}
					else if(this._selectionBeginIndex != this._selectionEndIndex)
					{
						this.deleteSelectedText();
					}
					else if(this._selectionEndIndex < currentValue.length)
					{
						this.text = currentValue.substr(0, this._selectionBeginIndex) + currentValue.substr(this._selectionEndIndex + 1);
					}
				}
				else if(event.keyCode == Keyboard.BACKSPACE)
				{
					if(event.altKey || event.ctrlKey)
					{
						newIndex = TextInputNavigation.findPreviousWordStartIndex(this._text, this._selectionBeginIndex);
						this.text = currentValue.substr(0, newIndex) + currentValue.substr(this._selectionEndIndex);
					}
					else if(this._selectionBeginIndex != this._selectionEndIndex)
					{
						this.deleteSelectedText();
					}
					else if(this._selectionBeginIndex > 0)
					{
						newIndex = this._selectionBeginIndex - 1;
						this.text = currentValue.substr(0, this._selectionBeginIndex - 1) + currentValue.substr(this._selectionEndIndex);
					}
				}
			}
			if(newIndex >= 0)
			{
				this.selectRange(newIndex, newIndex);
			}
		}

		/**
		 * @private
		 */
		protected function nativeFocus_textInputHandler(event:TextEvent):void
		{
			if(!this._isEditable || !this._isEnabled)
			{
				return;
			}
			var text:String = event.text;
			if(text === CARRIAGE_RETURN || text === LINE_FEED)
			{
				//ignore new lines
				return;
			}
			var charCode:int = text.charCodeAt(0);
			if(!this._restrict || this._restrict.isCharacterAllowed(charCode))
			{
				this.replaceSelectedText(text);
			}
		}

		/**
		 * @private
		 */
		protected function nativeFocus_selectAllHandler(event:flash.events.Event):void
		{
			if(!this._isEnabled || (!this._isEditable && !this._isSelectable))
			{
				return;
			}
			this._selectionAnchorIndex = 0;
			this.selectRange(0, this._text.length);
		}

		/**
		 * @private
		 */
		protected function nativeFocus_cutHandler(event:flash.events.Event):void
		{
			if(!this._isEnabled || (!this._isEditable && !this._isSelectable) ||
				this._selectionBeginIndex == this._selectionEndIndex || this._displayAsPassword)
			{
				return;
			}
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.getSelectedText());
			if(!this._isEditable)
			{
				return;
			}
			this.deleteSelectedText();
		}

		/**
		 * @private
		 */
		protected function nativeFocus_copyHandler(event:flash.events.Event):void
		{
			if(!this._isEnabled || (!this._isEditable && !this._isSelectable) ||
				this._selectionBeginIndex == this._selectionEndIndex || this._displayAsPassword)
			{
				return;
			}
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.getSelectedText());
		}

		/**
		 * @private
		 */
		protected function nativeFocus_pasteHandler(event:flash.events.Event):void
		{
			if(!this._isEditable || !this._isEnabled)
			{
				return;
			}
			var pastedText:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
			if(pastedText === null)
			{
				//the clipboard doesn't contain any text to paste
				return;
			}
			//new lines are not allowed
			pastedText = pastedText.replace(/[\n\r]/g, "");
			if(this._restrict)
			{
				pastedText = this._restrict.filterText(pastedText);
			}
			this.replaceSelectedText(pastedText);
		}
	}
}
