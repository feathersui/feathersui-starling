/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.FocusManager;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapChar;
	import starling.text.BitmapFont;

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
	 * Renders text using <code>starling.text.BitmapFont</code> that may be
	 * edited at runtime by the user. This text editor is intended for use in
	 * desktop applications, and it does not provide support for software
	 * keyboards on mobile devices.
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-editors
	 * @see starling.text.BitmapFont
	 */
	public class BitmapFontTextEditor extends BitmapFontTextRenderer implements ITextEditor
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		protected static const IS_WORD:RegExp = /\w/;

		/**
		 * @private
		 */
		protected static const IS_WHITESPACE:RegExp = /\s/;

		/**
		 * @private
		 */
		protected static const REQUIRES_ESCAPE:Dictionary = new Dictionary();
		REQUIRES_ESCAPE[/\[/g] = "\\[";
		REQUIRES_ESCAPE[/\]/g] = "\\]";
		REQUIRES_ESCAPE[/\{/g] = "\\{";
		REQUIRES_ESCAPE[/\}/g] = "\\}";
		REQUIRES_ESCAPE[/\(/g] = "\\(";
		REQUIRES_ESCAPE[/\)/g] = "\\)";
		REQUIRES_ESCAPE[/\|/g] = "\\|";
		REQUIRES_ESCAPE[/\//g] = "\\/";
		REQUIRES_ESCAPE[/\./g] = "\\.";
		REQUIRES_ESCAPE[/\+/g] = "\\+";
		REQUIRES_ESCAPE[/\*/g] = "\\*";
		REQUIRES_ESCAPE[/\?/g] = "\\?";
		REQUIRES_ESCAPE[/\$/g] = "\\$";

		/**
		 * Constructor.
		 */
		public function BitmapFontTextEditor()
		{
			this.isQuickHitAreaEnabled = true;
			this.truncateToFit = false;
			this.addEventListener(TouchEvent.TOUCH, textEditor_touchHandler);
		}

		/**
		 * @private
		 */
		protected var _selectionSkin:DisplayObject;

		/**
		 *
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
		protected var _cursorSkin:DisplayObject;

		/**
		 *
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
			if(this._cursorSkin == value)
			{
				return;
			}
			if(this._cursorSkin && this._cursorSkin.parent == this)
			{
				this._cursorSkin.removeFromParent();
			}
			this._cursorSkin = value;
			if(this._cursorSkin)
			{
				this._cursorSkin.visible = false;
				this.addChild(this._cursorSkin);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _displayAsPassword:Boolean = false;

		/**
		 * Indicates whether the text field is a password text field that hides
		 * input characters using a substitute character.
		 *
		 * <p>In the following example, the text is displayed as a password:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.displayAsPassword = true;</listing>
		 *
		 * @default false
		 *
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
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isEditable:Boolean = true;

		/**
		 * Determines if the text input is editable. If the text input is not
		 * editable, it will still appear enabled.
		 *
		 * <p>In the following example, the text is not editable:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.isEditable = false;</listing>
		 *
		 * @default true
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
		 * @inheritDoc
		 *
		 * @default true
		 */
		public function get setTouchFocusOnEndedPhase():Boolean
		{
			return true;
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
			if(this._text == value)
			{
				return;
			}
			super.text = value;
			this.dispatchEventWith(starling.events.Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _maxChars:int = 0;

		/**
		 * Indicates the maximum number of characters that a user can enter into
		 * the text editor. A script can insert more text than <code>maxChars</code>
		 * allows. If <code>maxChars</code> equals zero, a user can enter an
		 * unlimited amount of text into the text editor.
		 *
		 * <p>In the following example, the maximum character count is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.maxChars = 10;</listing>
		 *
		 * @default 0
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
		protected var _restrictStartsWithExclude:Boolean = false;

		/**
		 * @private
		 */
		protected var _restricts:Vector.<RegExp>;

		/**
		 * @private
		 */
		protected var _restrict:String;

		/**
		 * Restricts the set of characters that a user can enter into the text
		 * field. Only user interaction is restricted; a script can put any text
		 * into the text field.
		 *
		 * <p>In the following example, the text is restricted to numbers:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.restrict = "0-9";</listing>
		 *
		 * @default null
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
			if(value)
			{
				if(this._restricts)
				{
					this._restricts.length = 0;
				}
				else
				{
					this._restricts = new <RegExp>[];
				}
				if(this._restrict === "")
				{
					this._restricts.push(/^$/);
				}
				else if(this._restrict)
				{
					var startIndex:int = 0;
					var isExcluding:Boolean = value.indexOf("^") == 0;
					this._restrictStartsWithExclude = isExcluding;
					do
					{
						var nextStartIndex:int = value.indexOf("^", startIndex + 1);
						if(nextStartIndex >= 0)
						{
							var partialRestrict:String = value.substr(startIndex, nextStartIndex - startIndex);
							this._restricts.push(this.createRestrictRegExp(partialRestrict, isExcluding));
						}
						else
						{
							partialRestrict = value.substr(startIndex)
							this._restricts.push(this.createRestrictRegExp(partialRestrict, isExcluding));
							break;
						}
						startIndex = nextStartIndex;
						isExcluding = !isExcluding;
					}
					while(true)
				}
			}
			else
			{
				this._restricts = null;
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectionStartIndex:int = 0;

		/**
		 * @private
		 */
		protected var _selectionEndIndex:int = 0;

		/**
		 * @private
		 */
		protected var _selectionAnchorIndex:int = -1;

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
		protected var _nativeFocus:InteractiveObject;

		/**
		 * @private
		 */
		protected function get nativeFocus():InteractiveObject
		{
			return this._nativeFocus;
		}

		/**
		 * @private
		 */
		protected function set nativeFocus(value:InteractiveObject):void
		{
			if(this._nativeFocus == value)
			{
				return;
			}
			if(this._nativeFocus)
			{
				this._nativeFocus.removeEventListener(flash.events.Event.CUT, nativeStage_cutHandler);
				this._nativeFocus.removeEventListener(flash.events.Event.COPY, nativeStage_copyHandler);
				this._nativeFocus.removeEventListener(flash.events.Event.PASTE, nativeStage_pasteHandler);
			}
			this._nativeFocus = value;
			if(this._nativeFocus)
			{
				this._nativeFocus.addEventListener(flash.events.Event.CUT, nativeStage_cutHandler, false, 0, true);
				this._nativeFocus.addEventListener(flash.events.Event.COPY, nativeStage_copyHandler, false, 0, true);
				this._nativeFocus.addEventListener(flash.events.Event.PASTE, nativeStage_pasteHandler, false, 0, true);
			}
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
			//we already have focus, so there's no reason to change
			if(this._hasFocus && !position)
			{
				return;
			}
			if(this.isCreated)
			{
				var newIndex:int = -1;
				if(position)
				{
					var positionX:Number = position.x;
					var positionY:Number = position.y;
					if(positionX < 0)
					{
						newIndex = 0;
					}
					else
					{
						newIndex = this.getSelectionIndexAtPoint(positionX, positionY);
					}
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
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this.nativeFocus = null;
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}

		/**
		 * @inheritDoc
		 */
		public function selectRange(startIndex:int, endIndex:int):void
		{
			if(endIndex < startIndex)
			{
				var temp:int = endIndex;
				endIndex = startIndex;
				startIndex = temp;
			}
			this._selectionStartIndex = startIndex;
			this._selectionEndIndex = endIndex;
			if(startIndex == endIndex)
			{
				if(startIndex < 0)
				{
					this._cursorSkin.visible = false;
				}
				else if(this._hasFocus)
				{
					this._cursorSkin.visible = this._selectionStartIndex >= 0;
				}
				this._selectionSkin.visible = false;
			}
			else
			{
				this._cursorSkin.visible = false;
				this._selectionSkin.visible = true;
			}
			var cursorIndex:int = endIndex;
			if(this.touchPointID >= 0 && this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == endIndex)
			{
				cursorIndex = startIndex;
			}
			this.positionCursorAtIndex(cursorIndex);
			this.positionSelectionBackground();
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			var oldBatchX:Number = this._batchX;
			var oldCursorX:Number = this._cursorSkin.x;
			this._batchX -= this._scrollX;
			this._cursorSkin.x -= this._scrollX;
			super.render(support, parentAlpha);
			this._batchX = oldBatchX;
			this._cursorSkin.x = oldCursorX;
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._selectionSkin)
			{
				this.selectionSkin = new Quad(1, 1, 0x000000);
			}
			super.initialize();
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			super.draw();

			var clipRect:Rectangle = this.clipRect;
			if(clipRect)
			{
				clipRect.setTo(0, 0, this.actualWidth, this.actualHeight);
			}
			else
			{
				this.clipRect = new Rectangle(0, 0, this.actualWidth, this.actualHeight)
			}
		}

		/**
		 * @private
		 */
		override protected function refreshTextFormat():void
		{
			super.refreshTextFormat();
			if(this._cursorSkin)
			{
				var font:BitmapFont = this.currentTextFormat.font;
				var customSize:Number = this.currentTextFormat.size;
				var scale:Number = customSize / font.size;
				if(scale != scale) //isNaN
				{
					scale = 1;
				}
				this._cursorSkin.height = font.lineHeight * scale;
			}
		}

		/**
		 * @private
		 */
		protected function createRestrictRegExp(restrict:String, isExcluding:Boolean):RegExp
		{
			if(!isExcluding && restrict.indexOf("^") == 0)
			{
				//unlike regular expressions, which always treat ^ as excluding,
				//restrict uses ^ to swap between excluding and including.
				//if we're including, we need to remove ^ for the regexp
				restrict = restrict.substr(1);
			}
			//we need to do backslash first. otherwise, we'll get duplicates
			restrict = restrict.replace(/\\/g, "\\\\");
			for(var key:Object in REQUIRES_ESCAPE)
			{
				var keyRegExp:RegExp = key as RegExp;
				var value:String = REQUIRES_ESCAPE[keyRegExp] as String;
				restrict = restrict.replace(keyRegExp, value);
			}
			return new RegExp("[" + restrict + "]");
		}

		/**
		 * @private
		 */
		protected function focusIn():void
		{
			var showCursor:Boolean = this._selectionStartIndex >= 0 && this._selectionStartIndex != this._selectionEndIndex;
			this._cursorSkin.visible = showCursor;
			this._selectionSkin.visible = !showCursor;
			var nativeStage:Stage = Starling.current.nativeStage;
			//this is before the hasFocus check because the native stage may
			//have lost focus when clicking on the text editor, so we may need
			//to put it back in focus
			if(!FocusManager.isEnabled && !nativeStage.focus)
			{
				//something needs to be focused so that we can receive cut,
				//copy, and paste events
				nativeStage.focus = nativeStage;
			}
			//it shouldn't have changed, but let's be sure we're listening to
			//the right object for cut/copy/paste events.
			this.nativeFocus = nativeStage.focus;
			if(this._hasFocus)
			{
				return;
			}
			//we're reusing this variable. since this isn't a display object
			//that the focus manager can see, it's not being used anyway.
			this._hasFocus = true;
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}

		/**
		 * @private
		 */
		protected function getSelectionIndexAtPoint(pointX:Number, pointY:Number):int
		{
			if(!this._text)
			{
				return 0;
			}

			var font:BitmapFont = this.currentTextFormat.font;
			var customSize:Number = this.currentTextFormat.size;
			var customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			var isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			var scale:Number = customSize / font.size;
			if(scale != scale) //isNaN
			{
				scale = 1;
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
					previousCharID == previousCharID) //!isNaN
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
			var font:BitmapFont = this.currentTextFormat.font;
			var customSize:Number = this.currentTextFormat.size;
			var customLetterSpacing:Number = this.currentTextFormat.letterSpacing;
			var isKerningEnabled:Boolean = this.currentTextFormat.isKerningEnabled;
			var scale:Number = customSize / font.size;
			if(scale != scale) //isNaN
			{
				scale = 1;
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
					previousCharID == previousCharID) //!isNaN
				{
					currentKerning = charData.getKerning(previousCharID) * scale;
				}
				currentX += customLetterSpacing + currentKerning + charData.xAdvance * scale;
				previousCharID = charID;
			}
			return currentX;
		}

		/**
		 * @private
		 */
		protected function positionCursorAtIndex(index:int):void
		{
			if(index < 0)
			{
				index = 0;
			}
			var cursorX:Number = this.getXPositionOfIndex(index);
			cursorX = int(cursorX - (this._cursorSkin.width / 2));
			this._cursorSkin.x = cursorX;
			this._cursorSkin.y = 0;

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
		protected function positionSelectionBackground():void
		{
			var font:BitmapFont = this.currentTextFormat.font;
			var customSize:Number = this.currentTextFormat.size;
			var scale:Number = customSize / font.size;
			if(scale != scale) //isNaN
			{
				scale = 1;
			}

			var startX:Number = this.getXPositionOfIndex(this._selectionStartIndex) - this._scrollX;
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
			this._selectionSkin.y = 0;
			this._selectionSkin.height = font.lineHeight * scale;
		}

		/**
		 * @private
		 */
		protected function findPreviousWordStartIndex():int
		{
			if(this._selectionStartIndex <= 0)
			{
				return 0;
			}
			var nextCharIsWord:Boolean = IS_WORD.test(this._text.charAt(this._selectionStartIndex - 1));
			for(var i:int = this._selectionStartIndex - 2; i >= 0; i--)
			{
				var charIsWord:Boolean = IS_WORD.test(this._text.charAt(i));
				if(!charIsWord && nextCharIsWord)
				{
					return i + 1;
				}
				nextCharIsWord = charIsWord;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function findNextWordStartIndex():int
		{
			var textLength:int = this._text.length;
			if(this._selectionEndIndex >= textLength - 1)
			{
				return textLength;
			}
			//the first character is a special case. any non-whitespace is
			//considered part of the word.
			var prevCharIsWord:Boolean = !IS_WHITESPACE.test(this._text.charAt(this._selectionEndIndex));
			for(var i:int = this._selectionEndIndex + 1; i < textLength; i++)
			{
				var charIsWord:Boolean = IS_WORD.test(this._text.charAt(i));
				if(charIsWord && !prevCharIsWord)
				{
					return i;
				}
				prevCharIsWord = charIsWord;
			}
			return textLength;
		}

		/**
		 * @private
		 */
		protected function getSelectedText():String
		{
			if(this._selectionStartIndex == this._selectionEndIndex)
			{
				return null;
			}
			return this._text.substr(this._selectionStartIndex, this._selectionEndIndex - this._selectionStartIndex);
		}

		/**
		 * @private
		 */
		protected function deleteSelectedText():void
		{
			this.text = this._text.substr(0, this._selectionStartIndex) + this._text.substr(this._selectionEndIndex);
			this.selectRange(this._selectionStartIndex, this._selectionStartIndex);
		}

		/**
		 * @private
		 */
		protected function replaceSelectedText(text:String):void
		{
			var newText:String = this._text.substr(0, this._selectionStartIndex) + text + this._text.substr(this._selectionEndIndex);
			if(this._maxChars > 0 && newText.length > this._maxChars)
			{
				return;
			}
			this.text = newText;
			var selectionIndex:int = this._selectionStartIndex + text.length;
			this.selectRange(selectionIndex, selectionIndex);
		}

		/**
		 * @private
		 */
		protected function textEditor_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || !this._isEditable)
			{
				this.touchPointID = -1;
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, null, this.touchPointID);
				touch.getLocation(this, HELPER_POINT);
				HELPER_POINT.x += this._scrollX;
				this.selectRange(this._selectionAnchorIndex, this.getSelectionIndexAtPoint(HELPER_POINT.x, HELPER_POINT.y));
				if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
					if(this._selectionStartIndex == this._selectionEndIndex)
					{
						this._selectionAnchorIndex = -1;
					}
					if(!FocusManager.isEnabled && this._hasFocus)
					{
						this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
					}
				}
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this.touchPointID = touch.id;
				touch.getLocation(this, HELPER_POINT);
				HELPER_POINT.x += this._scrollX;
				if(event.shiftKey)
				{
					if(this._selectionAnchorIndex < 0)
					{
						this._selectionAnchorIndex = this._selectionStartIndex;
					}
					this.selectRange(this._selectionAnchorIndex, this.getSelectionIndexAtPoint(HELPER_POINT.x, HELPER_POINT.y));
				}
				else
				{
					this.setFocus(HELPER_POINT);
					this._selectionAnchorIndex = this._selectionStartIndex;
				}
			}
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.stage, TouchPhase.BEGAN);
			if(!touch) //we only care about began touches
			{
				return;
			}
			touch.getLocation(this.stage, HELPER_POINT);
			var isInBounds:Boolean = this.contains(this.stage.hitTest(HELPER_POINT, true));
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
			if(!this._isEnabled || !this._isEditable || this.touchPointID >= 0)
			{
				return;
			}
			//ignore cut, copy, and paste
			var charCode:uint = event.charCode;
			if(event.ctrlKey && (charCode == 99 || charCode == 118 || charCode == 120)) //c, p, and x
			{
				return;
			}
			var newIndex:int = -1;
			if(!FocusManager.isEnabled && event.keyCode == Keyboard.TAB)
			{
				this.clearFocus();
				return;
			}
			else if(event.keyCode == Keyboard.HOME || event.keyCode == Keyboard.UP)
			{
				newIndex = 0;
			}
			else if(event.keyCode == Keyboard.END || event.keyCode == Keyboard.DOWN)
			{
				newIndex = this._text.length;
			}
			else if(event.keyCode == Keyboard.LEFT)
			{
				if(event.shiftKey)
				{
					if(this._selectionAnchorIndex < 0)
					{
						this._selectionAnchorIndex = this._selectionStartIndex;
					}
					if(this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionStartIndex &&
						this._selectionStartIndex != this._selectionEndIndex)
					{
						newIndex = this._selectionEndIndex - 1;
						this.selectRange(this._selectionStartIndex, newIndex);
					}
					else
					{
						newIndex = this._selectionStartIndex - 1;
						if(newIndex < 0)
						{
							newIndex = 0;
						}
						this.selectRange(newIndex, this._selectionEndIndex);
					}
					return;
				}
				else if(this._selectionStartIndex != this._selectionEndIndex)
				{
					newIndex = this._selectionStartIndex;
				}
				else
				{
					if(event.altKey || event.ctrlKey)
					{
						newIndex = this.findPreviousWordStartIndex();
					}
					else
					{
						newIndex = this._selectionStartIndex - 1;
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
					if(this._selectionAnchorIndex < 0)
					{
						this._selectionAnchorIndex = this._selectionStartIndex;
					}
					if(this._selectionAnchorIndex >= 0 && this._selectionAnchorIndex == this._selectionEndIndex &&
						this._selectionStartIndex != this._selectionEndIndex)
					{
						newIndex = this._selectionStartIndex + 1;
						this.selectRange(newIndex, this._selectionEndIndex);
					}
					else
					{
						newIndex = this._selectionEndIndex + 1;
						if(newIndex < 0 || newIndex > this._text.length)
						{
							newIndex = this._text.length;
						}
						this.selectRange(this._selectionStartIndex, newIndex);
					}
					return;
				}
				else if(this._selectionStartIndex != this._selectionEndIndex)
				{
					newIndex = this._selectionEndIndex;
				}
				else
				{
					if(event.altKey || event.ctrlKey)
					{
						newIndex = this.findNextWordStartIndex();
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
				else if(event.keyCode == Keyboard.DELETE)
				{
					if(event.altKey || event.ctrlKey)
					{
						this.text = this._text.substr(0, this._selectionStartIndex) + this._text.substr(this.findNextWordStartIndex());

					}
					else if(this._selectionStartIndex != this._selectionEndIndex)
					{
						this.deleteSelectedText();
					}
					else if(this._selectionEndIndex < this._text.length)
					{
						this.text = this._text.substr(0, this._selectionStartIndex) + this._text.substr(this._selectionEndIndex + 1);
					}
				}
				else if(event.keyCode == Keyboard.BACKSPACE)
				{
					if(event.altKey || event.ctrlKey)
					{
						newIndex = this.findPreviousWordStartIndex();
						this.text = this._text.substr(0, newIndex) + this._text.substr(this._selectionEndIndex);
					}
					else if(this._selectionStartIndex != this._selectionEndIndex)
					{
						this.deleteSelectedText();
					}
					else if(this._selectionStartIndex > 0)
					{
						this.text = this._text.substr(0, this._selectionStartIndex - 1) + this._text.substr(this._selectionEndIndex);
						newIndex = this._selectionStartIndex - 1;
					}
				}
				else if(event.ctrlKey && charCode == 97) //a
				{
					this.selectRange(0, this._text.length);
				}
				else if(charCode >= 32) //ignore control characters
				{
					var character:String = String.fromCharCode(charCode);
					if(this._restricts)
					{
						var isExcluding:Boolean = this._restrictStartsWithExclude;
						var isIncluded:Boolean = isExcluding;
						var restrictCount:int = this._restricts.length;
						for(var i:int = 0; i < restrictCount; i++)
						{
							var restrict:RegExp = this._restricts[i];
							if(isExcluding)
							{
								isIncluded = isIncluded && restrict.test(character);
							}
							else
							{
								isIncluded = isIncluded || restrict.test(character);
							}
							isExcluding = !isExcluding;
						}
						if(!isIncluded)
						{
							return;
						}
					}
					this.replaceSelectedText(character);
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
		protected function nativeStage_cutHandler(event:flash.events.Event):void
		{
			if(!this._isEditable || !this._isEnabled || this._selectionStartIndex == this._selectionEndIndex)
			{
				return;
			}
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.getSelectedText());
			this.deleteSelectedText();
		}

		/**
		 * @private
		 */
		protected function nativeStage_copyHandler(event:flash.events.Event):void
		{
			if(!this._isEditable || !this._isEnabled || this._selectionStartIndex == this._selectionEndIndex)
			{
				return;
			}
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, this.getSelectedText());
		}

		/**
		 * @private
		 */
		protected function nativeStage_pasteHandler(event:flash.events.Event):void
		{
			if(!this._isEditable || !this._isEnabled)
			{
				return;
			}
			var pastedText:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
			if(this._restricts)
			{
				var textLength:int = pastedText.length;
				var restrictCount:int = this._restricts.length;
				for(var i:int = 0; i < textLength; i++)
				{
					var character:String = pastedText.charAt(i);
					var isExcluding:Boolean = this._restrictStartsWithExclude;
					var isIncluded:Boolean = isExcluding;
					for(var j:int = 0; j < restrictCount; j++)
					{
						var restrict:RegExp = this._restricts[j];
						if(isExcluding)
						{
							isIncluded = isIncluded && restrict.test(character);
						}
						else
						{
							isIncluded = isIncluded || restrict.test(character);
						}
						isExcluding = !isExcluding;
					}
					if(!isIncluded)
					{
						pastedText = pastedText.substr(0, i) + pastedText.substr(i + 1);
						i--;
						textLength--;
					}
				}
			}
			this.replaceSelectedText(pastedText);
		}
	}
}
