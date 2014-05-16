/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;

	import flash.geom.Point;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.KeyboardEvent;
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
	 * focus. This event may not be dispatched on some platforms, depending on
	 * the value of <code>returnKeyLabel</code>. This issue may even occur when
	 * using the <em>default value</em> of <code>returnKeyLabel</code>!
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
	 * @see #returnKeyLabel
	 * @see flash.text.ReturnKeyLabel
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
		public function BitmapFontTextEditor()
		{
			this.isQuickHitAreaEnabled = true;
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
		protected var _isWaitingToSetFocus:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function setFocus(position:Point = null):void
		{
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
				this.selectRange(newIndex, newIndex);
				this._cursorSkin.visible = this._selectionStartIndex >= 0;
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
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
			this._cursorSkin.visible = false;
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			Starling.current.nativeStage.focus = Starling.current.nativeStage;
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
			if(this._selectionStartIndex == startIndex && this._selectionEndIndex == endIndex)
			{
				return;
			}
			this._selectionStartIndex = startIndex;
			this._selectionEndIndex = endIndex;
			if(startIndex < 0)
			{
				this._cursorSkin.visible = false;
			}
			this.positionCursorAtIndex(endIndex);
			this.invalidate(INVALIDATION_FLAG_SELECTED);
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
			if(pointX > currentX)
			{
				return this._text.length;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function positionCursorAtIndex(index:int):void
		{
			if(index < 0)
			{
				return;
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
			this._cursorSkin.x = int(currentX - (this._cursorSkin.width / 2));
			this._cursorSkin.y = 0;
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			var newIndex:int = -1;
			if(event.keyCode == Keyboard.HOME || event.keyCode == Keyboard.UP)
			{
				newIndex = 0;
			}
			else if(event.keyCode == Keyboard.END || event.keyCode == Keyboard.DOWN)
			{
				newIndex = this._text.length;
			}
			else if(event.keyCode == Keyboard.LEFT)
			{
				if(this._selectionStartIndex != this._selectionEndIndex)
				{
					newIndex = this._selectionStartIndex;
				}
				else
				{
					newIndex = this._selectionStartIndex - 1;
					if(newIndex < 0)
					{
						newIndex = 0;
					}
				}
			}
			else if(event.keyCode == Keyboard.RIGHT)
			{
				if(this._selectionStartIndex != this._selectionEndIndex)
				{
					newIndex = this._selectionEndIndex;
				}
				else
				{
					newIndex = this._selectionEndIndex + 1;
					if(newIndex > this._text.length)
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
					if(this._selectionStartIndex != this._selectionEndIndex)
					{
						this.text = this.text.substr(0, this._selectionStartIndex) + this.text.substr(this._selectionEndIndex);
					}
					else if(this._selectionEndIndex < this._text.length)
					{
						this.text = this.text.substr(0, this._selectionStartIndex) + this.text.substr(this._selectionEndIndex + 1);
					}
				}
				else if(event.keyCode == Keyboard.BACKSPACE)
				{
					if(this._selectionStartIndex != this._selectionEndIndex)
					{
						this.text = this.text.substr(0, this._selectionStartIndex) + this.text.substr(this._selectionEndIndex);
					}
					else if(this._selectionStartIndex > 0)
					{
						this.text = this.text.substr(0, this._selectionStartIndex - 1) + this.text.substr(this._selectionEndIndex);
						newIndex = this._selectionStartIndex - 1;
					}
				}
				else if(event.charCode >= 32) //ignore control characters
				{
					this.text = this.text.substr(0, this._selectionStartIndex) + String.fromCharCode(event.charCode) + this.text.substr(this._selectionEndIndex);
					newIndex = this._selectionEndIndex + 1;
				}
			}
			if(newIndex >= 0)
			{
				this.selectRange(newIndex, newIndex);
			}
		}
	}
}
