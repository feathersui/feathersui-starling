/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	import feathers.text.StageTextField;
	import feathers.utils.geom.matrixToScaleX;
	import feathers.utils.geom.matrixToScaleY;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.utils.MatrixUtil;

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
	 * Dispatched when the soft keyboard is activated. Not all text editors will
	 * activate a soft keyboard.
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
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_ACTIVATE
	 */
	[Event(name="softKeyboardActivate",type="starling.events.Event")]

	/**
	 * Dispatched when the soft keyboard is deactivated. Not all text editors
	 * will activate a soft keyboard.
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
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_DEACTIVATE
	 */
	[Event(name="softKeyboardDeactivate",type="starling.events.Event")]

	/**
	 * A Feathers text editor that uses the native <code>flash.text.StageText</code>
	 * class in Adobe AIR, and the custom <code>feathers.text.StageTextField</code>
	 * class (that simulates <code>StageText</code> using
	 * <code>flash.text.TextField</code>) in Adobe Flash Player.
	 *
	 * <p>Note: Due to quirks with how the runtime manages focus with
	 * <code>StageText</code>, <code>StageTextTextEditor</code> is not
	 * compatible with the Feathers <code>FocusManager</code>.</p>
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-editors
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html flash.text.StageText
	 * @see feathers.text.StageTextField
	 */
	public class StageTextTextEditor extends FeathersControl implements ITextEditor
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
		 * @private
		 */
		protected static const INVALIDATION_FLAG_POSITION:String = "position";

		/**
		 * Constructor.
		 */
		public function StageTextTextEditor()
		{
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * @private
		 */
		override public function set x(value:Number):void
		{
			super.x = value;
			//we need to know when the position changes to change the position
			//of the StageText instance.
			this.invalidate(INVALIDATION_FLAG_POSITION);
		}

		/**
		 * @private
		 */
		override public function set y(value:Number):void
		{
			super.y = value;
			this.invalidate(INVALIDATION_FLAG_POSITION);
		}

		/**
		 * The StageText instance. It's typed Object so that a replacement class
		 * can be used in browser-based Flash Player.
		 */
		protected var stageText:Object;

		/**
		 * An image that displays a snapshot of the native <code>StageText</code>
		 * in the Starling display list when the editor doesn't have focus.
		 */
		protected var textSnapshot:Image;

		/**
		 * @private
		 */
		protected var _needsNewTexture:Boolean = false;

		/**
		 * @private
		 */
		protected var _ignoreStageTextChanges:Boolean = false;

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * The text displayed by the input.
		 *
		 * <p>In the following example, the text is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.text = "Lorem ipsum";</listing>
		 *
		 * @default ""
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
			this.dispatchEventWith(starling.events.Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _measureTextField:TextField;

		/**
		 * @private
		 */
		protected var _stageTextHasFocus:Boolean = false;

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
		protected var _stageTextIsComplete:Boolean = false;

		/**
		 * @private
		 */
		protected var _autoCapitalize:String = "none";

		/**
		 * Controls how a device applies auto capitalization to user input. This
		 * property is only a hint to the underlying platform, because not all
		 * devices and operating systems support this functionality.
		 *
		 * <p>In the following example, the auto capitalize behavior is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.autoCapitalize = AutoCapitalize.WORD;</listing>
		 *
		 * @default flash.text.AutoCapitalize.NONE
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#autoCapitalize Full description of flash.text.StageText.autoCapitalize in Adobe's Flash Platform API Reference
		 */
		public function get autoCapitalize():String
		{
			return this._autoCapitalize;
		}

		/**
		 * @private
		 */
		public function set autoCapitalize(value:String):void
		{
			if(this._autoCapitalize == value)
			{
				return;
			}
			this._autoCapitalize = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _autoCorrect:Boolean = false;

		/**
		 * Indicates whether a device auto-corrects user input for spelling or
		 * punctuation mistakes. This property is only a hint to the underlying
		 * platform, because not all devices and operating systems support this
		 * functionality.
		 *
		 * <p>In the following example, auto correct is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.autoCorrect = true;</listing>
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#autoCorrect Full description of flash.text.StageText.autoCorrect in Adobe's Flash Platform API Reference
		 */
		public function get autoCorrect():Boolean
		{
			return this._autoCorrect;
		}

		/**
		 * @private
		 */
		public function set autoCorrect(value:Boolean):void
		{
			if(this._autoCorrect == value)
			{
				return;
			}
			this._autoCorrect = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _color:uint = 0x000000;

		/**
		 * Specifies text color as a number containing three 8-bit RGB
		 * components.
		 *
		 * <p>In the following example, the text color is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.color = 0xff9900;</listing>
		 *
		 * @default 0x000000
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#color Full description of flash.text.StageText.color in Adobe's Flash Platform API Reference
		 */
		public function get color():uint
		{
			return this._color as uint;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if(this._color == value)
			{
				return;
			}
			this._color = value;
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
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#displayAsPassword Full description of flash.text.StageText.displayAsPassword in Adobe's Flash Platform API Reference
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
		protected var _fontFamily:String = null;

		/**
		 * Indicates the name of the current font family. A value of null
		 * indicates the system default.
		 *
		 * <p>In the following example, the font family is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.fontFamily = "Source Sans Pro";</listing>
		 *
		 * @default null
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#fontFamily Full description of flash.text.StageText.fontFamily in Adobe's Flash Platform API Reference
		 */
		public function get fontFamily():String
		{
			return this._fontFamily;
		}

		/**
		 * @private
		 */
		public function set fontFamily(value:String):void
		{
			if(this._fontFamily == value)
			{
				return;
			}
			this._fontFamily = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _fontPosture:String = FontPosture.NORMAL;

		/**
		 * Specifies the font posture, using constants defined in the
		 * <code>flash.text.engine.FontPosture</code> class.
		 *
		 * <p>In the following example, the font posture is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.fontPosture = FontPosture.ITALIC;</listing>
		 *
		 * @default flash.text.engine.FontPosture.NORMAL
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#fontPosture Full description of flash.text.StageText.fontPosture in Adobe's Flash Platform API Reference
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontPosture.html flash.text.engine.FontPosture
		 */
		public function get fontPosture():String
		{
			return this._fontPosture;
		}

		/**
		 * @private
		 */
		public function set fontPosture(value:String):void
		{
			if(this._fontPosture == value)
			{
				return;
			}
			this._fontPosture = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _fontSize:int = 12;

		/**
		 * The size in pixels for the current font family.
		 *
		 * <p>In the following example, the font size is increased to 16 pixels:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.fontSize = 16;</listing>
		 *
		 * @default 12
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#fontSize Full description of flash.text.StageText.fontSize in Adobe's Flash Platform API Reference
		 */
		public function get fontSize():int
		{
			return this._fontSize;
		}

		/**
		 * @private
		 */
		public function set fontSize(value:int):void
		{
			if(this._fontSize == value)
			{
				return;
			}
			this._fontSize = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _fontWeight:String = FontWeight.NORMAL;

		/**
		 * Specifies the font weight, using constants defined in the
		 * <code>flash.text.engine.FontWeight</code> class.
		 *
		 * <p>In the following example, the font weight is changed to bold:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.fontWeight = FontWeight.BOLD;</listing>
		 *
		 * @default flash.text.engine.FontWeight.NORMAL
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#fontWeight Full description of flash.text.StageText.fontWeight in Adobe's Flash Platform API Reference
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontWeight.html flash.text.engine.FontWeight
		 */
		public function get fontWeight():String
		{
			return this._fontWeight;
		}

		/**
		 * @private
		 */
		public function set fontWeight(value:String):void
		{
			if(this._fontWeight == value)
			{
				return;
			}
			this._fontWeight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _locale:String = "en";

		/**
		 * Indicates the locale of the text. <code>StageText</code> uses the
		 * standard locale identifiers. For example <code>"en"</code>,
		 * <code>"en_US"</code> and <code>"en-US"</code> are all English.
		 *
		 * <p>In the following example, the locale is changed to Russian:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.locale = "ru";</listing>
		 *
		 * @default "en"
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#locale Full description of flash.text.StageText.locale in Adobe's Flash Platform API Reference
		 */
		public function get locale():String
		{
			return this._locale;
		}

		/**
		 * @private
		 */
		public function set locale(value:String):void
		{
			if(this._locale == value)
			{
				return;
			}
			this._locale = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#maxChars Full description of flash.text.StageText.maxChars in Adobe's Flash Platform API Reference
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
		protected var _multiline:Boolean = false;

		/**
		 * Indicates whether the StageText object can display more than one line
		 * of text. This property is configurable after the text editor is
		 * created, unlike a regular <code>StageText</code> instance. The text
		 * editor will dispose and recreate its internal <code>StageText</code>
		 * instance if the value of the <code>multiline</code> property is
		 * changed after the <code>StageText</code> is initially created.
		 *
		 * <p>In the following example, multiline is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.multiline = true;</listing>
		 *
		 * When setting this property to <code>true</code>, it is recommended
		 * that the text input's <code>verticalAlign</code> property is set to
		 * <code>TextInput.VERTICAL_ALIGN_JUSTIFY</code>.
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#multiline Full description of flash.text.StageText.multiline in Adobe's Flash Platform API Reference
		 */
		public function get multiline():Boolean
		{
			return this._multiline;
		}

		/**
		 * @private
		 */
		public function set multiline(value:Boolean):void
		{
			if(this._multiline == value)
			{
				return;
			}
			this._multiline = value;
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
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#restrict Full description of flash.text.StageText.restrict in Adobe's Flash Platform API Reference
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
		protected var _returnKeyLabel:String = "default";

		/**
		 * Indicates the label on the Return key for devices that feature a soft
		 * keyboard. The available values are constants defined in the
		 * <code>flash.text.ReturnKeyLabel</code> class. This property is only a
		 * hint to the underlying platform, because not all devices and
		 * operating systems support this functionality.
		 *
		 * <p>In the following example, the return key label is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.returnKeyLabel = ReturnKeyLabel.GO;</listing>
		 *
		 * @default flash.text.ReturnKeyLabel.DEFAULT
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#returnKeyLabel Full description of flash.text.StageText.returnKeyLabel in Adobe's Flash Platform API Reference
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/ReturnKeyLabel.html flash.text.ReturnKeyLabel
		 */
		public function get returnKeyLabel():String
		{
			return this._returnKeyLabel;
		}

		/**
		 * @private
		 */
		public function set returnKeyLabel(value:String):void
		{
			if(this._returnKeyLabel == value)
			{
				return;
			}
			this._returnKeyLabel = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _softKeyboardType:String = "default";

		/**
		 * Controls the appearance of the soft keyboard. Valid values are
		 * defined as constants in the <code>flash.text.SoftKeyboardType</code>
		 * class. This property is only a hint to the underlying platform,
		 * because not all devices and operating systems support this
		 * functionality.
		 *
		 * <p>In the following example, the soft keyboard type is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.softKeyboardType = SoftKeyboardType.NUMBER;</listing>
		 *
		 * @default flash.text.SoftKeyboardType.DEFAULT
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#softKeyboardType Full description of flash.text.StageText.softKeyboardType in Adobe's Flash Platform API Reference
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/SoftKeyboardType.html flash.text.SoftKeyboardType
		 */
		public function get softKeyboardType():String
		{
			return this._softKeyboardType;
		}

		/**
		 * @private
		 */
		public function set softKeyboardType(value:String):void
		{
			if(this._softKeyboardType == value)
			{
				return;
			}
			this._softKeyboardType = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _textAlign:String = TextFormatAlign.START;

		/**
		 * Indicates the paragraph alignment. Valid values are defined as
		 * constants in the <code>flash.text.TextFormatAlign</code> class.
		 *
		 * <p>In the following example, the text is centered:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.textAlign = TextFormatAlign.CENTER;</listing>
		 *
		 * @default flash.text.TextFormatAlign.START
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#textAlign Full description of flash.text.StageText.textAlign in Adobe's Flash Platform API Reference
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormatAlign.html flash.text.TextFormatAlign
		 */
		public function get textAlign():String
		{
			return this._textAlign;
		}

		/**
		 * @private
		 */
		public function set textAlign(value:String):void
		{
			if(this._textAlign == value)
			{
				return;
			}
			this._textAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.disposeContent();
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
			const starlingViewPort:Rectangle = Starling.current.viewPort;
			var stageTextViewPort:Rectangle = this.stageText.viewPort;
			if(!stageTextViewPort)
			{
				stageTextViewPort = new Rectangle();
			}
			var nativeScaleFactor:Number = 1;
			if(Starling.current.supportHighResolutions)
			{
				nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
			}
			var scaleFactor:Number = Starling.contentScaleFactor / nativeScaleFactor;
			stageTextViewPort.x = Math.round(starlingViewPort.x + (HELPER_POINT.x * scaleFactor));
			stageTextViewPort.y = Math.round(starlingViewPort.y + (HELPER_POINT.y * scaleFactor));
			this.stageText.viewPort = stageTextViewPort;

			if(this.stageText.visible)
			{
				this.getTransformationMatrix(this.stage, HELPER_MATRIX);
				var globalScaleX:Number = matrixToScaleX(HELPER_MATRIX);
				var globalScaleY:Number = matrixToScaleY(HELPER_MATRIX);
				var smallerGlobalScale:Number = globalScaleX;
				if(globalScaleY < globalScaleX)
				{
					smallerGlobalScale = globalScaleY;
				}
				//for some reason, we don't need to account for the native scale factor here
				scaleFactor = Starling.contentScaleFactor;
				this.stageText.fontSize = this._fontSize * scaleFactor * smallerGlobalScale;
			}

			if(this.textSnapshot)
			{
				this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
				this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
			}

			super.render(support, parentAlpha);
		}

		/**
		 * @inheritDoc
		 */
		public function setFocus(position:Point = null):void
		{
			if(this.stageText && this._stageTextIsComplete)
			{
				if(position)
				{
					const positionX:Number = position.x;
					const positionY:Number = position.y;
					if(positionX < 0)
					{
						this._pendingSelectionStartIndex = this._pendingSelectionEndIndex = 0;
					}
					else
					{
						this._pendingSelectionStartIndex = this._measureTextField.getCharIndexAtPoint(positionX, positionY);
						if(this._pendingSelectionStartIndex < 0)
						{
							if(this._multiline)
							{
								const lineIndex:int = int(positionY / this._measureTextField.getLineMetrics(0).height);
								try
								{
									this._pendingSelectionStartIndex = this._measureTextField.getLineOffset(lineIndex) + this._measureTextField.getLineLength(lineIndex);
									if(this._pendingSelectionStartIndex != this._text.length)
									{
										this._pendingSelectionStartIndex--;
									}
								}
								catch(error:Error)
								{
									//we may be checking for a line beyond the
									//end that doesn't exist
									this._pendingSelectionStartIndex = this._text.length;
								}
							}
							else
							{
								this._pendingSelectionStartIndex = this._text.length;
							}
						}
						else
						{
							const bounds:Rectangle = this._measureTextField.getCharBoundaries(this._pendingSelectionStartIndex);
							const boundsX:Number = bounds.x;
							if(bounds && (boundsX + bounds.width - positionX) < (positionX - boundsX))
							{
								this._pendingSelectionStartIndex++;
							}
						}
						this._pendingSelectionEndIndex = this._pendingSelectionStartIndex;
					}
				}
				else
				{
					this._pendingSelectionStartIndex = this._pendingSelectionEndIndex = -1;
				}
				this.stageText.visible = true;
				this.stageText.assignFocus();
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
			if(!this._stageTextHasFocus)
			{
				return;
			}
			Starling.current.nativeStage.focus = Starling.current.nativeStage;
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}

		/**
		 * @inheritDoc
		 */
		public function selectRange(startIndex:int, endIndex:int):void
		{
			if(this._stageTextIsComplete && this.stageText)
			{
				this._pendingSelectionStartIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.stageText.selectRange(startIndex, endIndex);
			}
			else
			{
				this._pendingSelectionStartIndex = startIndex;
				this._pendingSelectionEndIndex = endIndex;
			}
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

			if(!this._measureTextField)
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


			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			if(stylesInvalid || dataInvalid)
			{
				this.refreshMeasureProperties();
			}

			result = this.measure(result);

			return result;
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
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			if(stylesInvalid || dataInvalid)
			{
				this.refreshMeasureProperties();
			}

			const oldIgnoreStageTextChanges:Boolean = this._ignoreStageTextChanges;
			this._ignoreStageTextChanges = true;
			if(stylesInvalid)
			{
				this.refreshStageTextProperties();
			}

			if(dataInvalid)
			{
				if(this.stageText.text != this._text)
				{
					if(this._pendingSelectionStartIndex < 0)
					{
						this._pendingSelectionStartIndex = this.stageText.selectionActiveIndex;
						this._pendingSelectionEndIndex = this.stageText.selectionAnchorIndex;
					}
					this.stageText.text = this._text;
				}
			}
			this._ignoreStageTextChanges = oldIgnoreStageTextChanges;

			if(stylesInvalid || stateInvalid)
			{
				this.stageText.editable = this._isEditable && this._isEnabled;
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

			this._measureTextField.autoSize = TextFieldAutoSize.LEFT;

			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = Math.max(this._minWidth, Math.min(this._maxWidth, this._measureTextField.width));
			}

			this._measureTextField.width = newWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = Math.max(this._minHeight, Math.min(this._maxHeight, this._measureTextField.height));
			}

			this._measureTextField.autoSize = TextFieldAutoSize.NONE;

			//put the width and height back just in case we measured without
			//a full validation
			this._measureTextField.width = this.actualWidth;
			this._measureTextField.height = this.actualHeight;

			result.x = newWidth;
			result.y = newHeight;

			return result;
		}

		/**
		 * @private
		 */
		protected function layout(sizeInvalid:Boolean):void
		{
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const positionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_POSITION);
			const skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);

			if(positionInvalid || sizeInvalid || stylesInvalid || skinInvalid || stateInvalid)
			{
				this.refreshViewPort();
				const viewPort:Rectangle = this.stageText.viewPort;
				const textureRoot:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
				this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || viewPort.width != textureRoot.width || viewPort.height != textureRoot.height;
			}

			if(!this._stageTextHasFocus && (stylesInvalid || dataInvalid || sizeInvalid || this._needsNewTexture))
			{
				const hasText:Boolean = this._text.length > 0;
				if(hasText)
				{
					this.refreshSnapshot();
				}
				if(this.textSnapshot)
				{
					this.textSnapshot.visible = !this._stageTextHasFocus;
					this.textSnapshot.alpha = hasText ? 1 : 0;
				}
				this.stageText.visible = false;
			}

			this.doPendingActions();
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>setSizeInternal()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
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
		protected function refreshMeasureProperties():void
		{
			this._measureTextField.displayAsPassword = this._displayAsPassword;
			this._measureTextField.maxChars = this._maxChars;
			this._measureTextField.restrict = this._restrict;
			this._measureTextField.multiline = this._measureTextField.wordWrap = this._multiline;

			const format:TextFormat = this._measureTextField.defaultTextFormat;
			format.color = this._color;
			format.font = this._fontFamily;
			format.italic = this._fontPosture == FontPosture.ITALIC;
			format.size = this._fontSize;
			format.bold = this._fontWeight == FontWeight.BOLD;
			var alignValue:String = this._textAlign;
			if(alignValue == TextFormatAlign.START)
			{
				alignValue = TextFormatAlign.LEFT;
			}
			else if(alignValue == TextFormatAlign.END)
			{
				alignValue = TextFormatAlign.RIGHT;
			}
			format.align = alignValue;
			this._measureTextField.defaultTextFormat = format;
			this._measureTextField.setTextFormat(format);
			if(this._text.length == 0)
			{
				this._measureTextField.text = " ";
			}
			else
			{
				this._measureTextField.text = this._text;
			}
		}

		/**
		 * @private
		 */
		protected function refreshStageTextProperties():void
		{
			if(this.stageText.multiline != this._multiline)
			{
				if(this.stageText)
				{
					this.disposeStageText();
				}
				this.createStageText();
			}

			this.stageText.autoCapitalize = this._autoCapitalize;
			this.stageText.autoCorrect = this._autoCorrect;
			this.stageText.color = this._color;
			this.stageText.displayAsPassword = this._displayAsPassword;
			this.stageText.fontFamily = this._fontFamily;
			this.stageText.fontPosture = this._fontPosture;

			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			var globalScaleX:Number = matrixToScaleX(HELPER_MATRIX);
			var globalScaleY:Number = matrixToScaleY(HELPER_MATRIX);
			var smallerGlobalScale:Number = globalScaleX;
			if(globalScaleY < globalScaleX)
			{
				smallerGlobalScale = globalScaleY;
			}
			//for some reason, we don't need to account for the native scale factor here
			var scaleFactor:Number = Starling.contentScaleFactor;
			this.stageText.fontSize = this._fontSize * scaleFactor * smallerGlobalScale;

			this.stageText.fontWeight = this._fontWeight;
			this.stageText.locale = this._locale;
			this.stageText.maxChars = this._maxChars;
			this.stageText.restrict = this._restrict;
			this.stageText.returnKeyLabel = this._returnKeyLabel;
			this.stageText.softKeyboardType = this._softKeyboardType;
			this.stageText.textAlign = this._textAlign;
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
				const endIndex:int = (this._pendingSelectionEndIndex < 0) ? this._pendingSelectionStartIndex : this._pendingSelectionEndIndex;
				this._pendingSelectionStartIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.selectRange(startIndex, endIndex);
			}
		}

		/**
		 * @private
		 */
		protected function texture_onRestore():void
		{
			this.refreshSnapshot();
			if(this.textSnapshot)
			{
				this.textSnapshot.visible = !this._stageTextHasFocus;
				this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
			}
			if(!this._stageTextHasFocus)
			{
				this.stageText.visible = false;
			}
		}

		/**
		 * @private
		 */
		protected function refreshSnapshot():void
		{
			const viewPort:Rectangle = this.stageText.viewPort;
			if(viewPort.width == 0 || viewPort.height == 0)
			{
				return;
			}

			//StageText sucks because it requires that the BitmapData's width
			//and height exactly match its view port width and height.
			var bitmapData:BitmapData = new BitmapData(viewPort.width, viewPort.height, true, 0x00ff00ff);
			this.stageText.drawViewPortToBitmapData(bitmapData);

			var newTexture:Texture;
			if(!this.textSnapshot || this._needsNewTexture)
			{
				newTexture = Texture.fromBitmapData(bitmapData, false, false, Starling.contentScaleFactor);
				newTexture.root.onRestore = texture_onRestore;
			}
			if(!this.textSnapshot)
			{
				this.textSnapshot = new Image(newTexture);
				this.addChild(this.textSnapshot);
			}
			else
			{
				if(this._needsNewTexture)
				{
					this.textSnapshot.texture.dispose();
					this.textSnapshot.texture = newTexture;
					this.textSnapshot.readjustSize();
				}
				else
				{
					//this is faster, if we haven't resized the bitmapdata
					const existingTexture:Texture = this.textSnapshot.texture;
					existingTexture.root.uploadBitmapData(bitmapData);
				}
			}
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			this.textSnapshot.scaleX = 1 / matrixToScaleX(HELPER_MATRIX);
			this.textSnapshot.scaleY = 1 / matrixToScaleY(HELPER_MATRIX);
			bitmapData.dispose();
			this._needsNewTexture = false;
		}

		/**
		 * @private
		 */
		protected function refreshViewPort():void
		{
			const starlingViewPort:Rectangle = Starling.current.viewPort;
			var stageTextViewPort:Rectangle = this.stageText.viewPort;
			if(!stageTextViewPort)
			{
				stageTextViewPort = new Rectangle();
			}
			if(!this.stageText.stage)
			{
				this.stageText.stage = Starling.current.nativeStage;
			}

			HELPER_POINT.x = HELPER_POINT.y = 0;
			this.getTransformationMatrix(this.stage, HELPER_MATRIX);
			var globalScaleX:Number = matrixToScaleX(HELPER_MATRIX);
			var globalScaleY:Number = matrixToScaleY(HELPER_MATRIX);
			MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
			var nativeScaleFactor:Number = 1;
			if(Starling.current.supportHighResolutions)
			{
				nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
			}
			var scaleFactor:Number = Starling.contentScaleFactor / nativeScaleFactor;
			stageTextViewPort.x = Math.round(starlingViewPort.x + HELPER_POINT.x * scaleFactor);
			stageTextViewPort.y = Math.round(starlingViewPort.y + HELPER_POINT.y * scaleFactor);
			var viewPortWidth:Number = Math.round(this.actualWidth * scaleFactor * globalScaleX);
			if(viewPortWidth < 1 || isNaN(viewPortWidth))
			{
				viewPortWidth = 1;
			}
			var viewPortHeight:Number = Math.round(this.actualHeight * scaleFactor * globalScaleY);
			if(viewPortHeight < 1 || isNaN(viewPortHeight))
			{
				viewPortHeight = 1;
			}
			stageTextViewPort.width = viewPortWidth;
			stageTextViewPort.height = viewPortHeight;
			this.stageText.viewPort = stageTextViewPort;

			this._measureTextField.width = this.actualWidth;
			this._measureTextField.height = this.actualHeight;
		}

		/**
		 * @private
		 */
		protected function disposeContent():void
		{
			if(this._measureTextField)
			{
				Starling.current.nativeStage.removeChild(this._measureTextField);
				this._measureTextField = null;
			}

			if(this.stageText)
			{
				this.disposeStageText();
			}

			if(this.textSnapshot)
			{
				//avoid the need to call dispose(). we'll create a new snapshot
				//when the renderer is added to stage again.
				this.textSnapshot.texture.dispose();
				this.removeChild(this.textSnapshot, true);
				this.textSnapshot = null;
			}
		}

		/**
		 * @private
		 */
		protected function disposeStageText():void
		{
			if(!this.stageText)
			{
				return;
			}
			this.stageText.removeEventListener(flash.events.Event.CHANGE, stageText_changeHandler);
			this.stageText.removeEventListener(KeyboardEvent.KEY_DOWN, stageText_keyDownHandler);
			this.stageText.removeEventListener(KeyboardEvent.KEY_UP, stageText_keyUpHandler);
			this.stageText.removeEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
			this.stageText.removeEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);
			this.stageText.removeEventListener(flash.events.Event.COMPLETE, stageText_completeHandler);
			this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, stageText_softKeyboardActivateHandler);
			this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, stageText_softKeyboardDeactivateHandler);
			this.stageText.stage = null;
			this.stageText.dispose();
			this.stageText = null;
		}

		/**
		 * Creates and adds the <code>stageText</code> instance.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function createStageText():void
		{
			this._stageTextIsComplete = false;
			var StageTextType:Class;
			var initOptions:Object;
			try
			{
				StageTextType = Class(getDefinitionByName("flash.text.StageText"));
				const StageTextInitOptionsType:Class = Class(getDefinitionByName("flash.text.StageTextInitOptions"));
				initOptions = new StageTextInitOptionsType(this._multiline);
			}
			catch(error:Error)
			{
				StageTextType = StageTextField;
				initOptions = { multiline: this._multiline };
			}
			this.stageText = new StageTextType(initOptions);
			this.stageText.visible = false;
			this.stageText.addEventListener(flash.events.Event.CHANGE, stageText_changeHandler);
			this.stageText.addEventListener(KeyboardEvent.KEY_DOWN, stageText_keyDownHandler);
			this.stageText.addEventListener(KeyboardEvent.KEY_UP, stageText_keyUpHandler);
			this.stageText.addEventListener(FocusEvent.FOCUS_IN, stageText_focusInHandler);
			this.stageText.addEventListener(FocusEvent.FOCUS_OUT, stageText_focusOutHandler);
			this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, stageText_softKeyboardActivateHandler);
			this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, stageText_softKeyboardDeactivateHandler);
			this.stageText.addEventListener(flash.events.Event.COMPLETE, stageText_completeHandler);
			this.invalidate();
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:starling.events.Event):void
		{
			if(this._measureTextField && !this._measureTextField.parent)
			{
				Starling.current.nativeStage.addChild(this._measureTextField);
			}
			else if(!this._measureTextField)
			{
				this._measureTextField = new TextField();
				this._measureTextField.visible = false;
				this._measureTextField.mouseEnabled = this._measureTextField.mouseWheelEnabled = false;
				this._measureTextField.autoSize = TextFieldAutoSize.LEFT;
				this._measureTextField.multiline = false;
				this._measureTextField.wordWrap = false;
				this._measureTextField.embedFonts = false;
				this._measureTextField.defaultTextFormat = new TextFormat(null, 11, 0x000000, false, false, false);
				Starling.current.nativeStage.addChild(this._measureTextField);
			}

			this.createStageText();
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:starling.events.Event):void
		{
			this.disposeContent();
		}

		/**
		 * @private
		 */
		protected function stageText_changeHandler(event:flash.events.Event):void
		{
			if(this._ignoreStageTextChanges)
			{
				return;
			}
			this.text = this.stageText.text;
		}

		/**
		 * @private
		 */
		protected function stageText_completeHandler(event:flash.events.Event):void
		{
			this.stageText.removeEventListener(flash.events.Event.COMPLETE, stageText_completeHandler);
			this.invalidate();

			this._stageTextIsComplete = true;
		}

		/**
		 * @private
		 */
		protected function stageText_focusInHandler(event:FocusEvent):void
		{
			this._stageTextHasFocus = true;
			if(this.textSnapshot)
			{
				this.textSnapshot.visible = false;
			}
			this.invalidate(INVALIDATION_FLAG_SKIN);
			this.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}

		/**
		 * @private
		 */
		protected function stageText_focusOutHandler(event:FocusEvent):void
		{
			this._stageTextHasFocus = false;
			//since StageText doesn't expose its scroll position, we need to
			//set the selection back to the beginning to scroll there. it's a
			//hack, but so is everything about StageText.
			//in other news, why won't 0,0 work here?
			this.stageText.selectRange(1, 1);

			this.invalidate(INVALIDATION_FLAG_DATA);
			this.invalidate(INVALIDATION_FLAG_SKIN);
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}

		/**
		 * @private
		 */
		protected function stageText_keyDownHandler(event:KeyboardEvent):void
		{
			if(!this._multiline && (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.NEXT))
			{
				event.preventDefault();
				this.dispatchEventWith(FeathersEventType.ENTER);
			}
			else if(event.keyCode == Keyboard.BACK)
			{
				//even a listener on the stage won't detect the back key press that
				//will close the application if the StageText has focus, so we
				//always need to prevent it here
				event.preventDefault();
				Starling.current.nativeStage.focus = Starling.current.nativeStage;
			}
		}

		/**
		 * @private
		 */
		protected function stageText_keyUpHandler(event:KeyboardEvent):void
		{
			if(!this._multiline && (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.NEXT))
			{
				event.preventDefault();
			}
		}

		/**
		 * @private
		 */
		protected function stageText_softKeyboardActivateHandler(event:SoftKeyboardEvent):void
		{
			this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATE, true);
		}

		/**
		 * @private
		 */
		protected function stageText_softKeyboardDeactivateHandler(event:SoftKeyboardEvent):void
		{
			this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_DEACTIVATE, true);
		}
	}
}
