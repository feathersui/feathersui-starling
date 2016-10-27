/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.BaseTextEditor;
	import feathers.core.FocusManager;
	import feathers.core.IMultilineTextEditor;
	import feathers.core.INativeFocusOwner;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.text.StageTextField;
	import feathers.utils.display.stageToStarling;
	import feathers.utils.geom.matrixToScaleX;
	import feathers.utils.geom.matrixToScaleY;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.rendering.Painter;
	import starling.text.TextFormat;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.MatrixUtil;
	import starling.utils.Pool;
	import starling.utils.SystemUtil;

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
	 * Dispatched when the soft keyboard is about to activate. Not all text
	 * editors will activate a soft keyboard.
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
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_ACTIVATING
	 */
	[Event(name="softKeyboardActivating",type="starling.events.Event")]

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
	 * Text that may be edited at runtime by the user with the
	 * <code>TextInput</code> component, rendered with the native
	 * <code>flash.text.StageText</code> class in Adobe AIR and the custom
	 * <code>feathers.text.StageTextField</code> class in Adobe Flash Player
	 * (<code>StageTextField</code> simulates <code>StageText</code> using
	 * <code>flash.text.TextField</code>). When not in focus, the
	 * <code>StageText</code> (or <code>StageTextField</code>) is drawn to
	 * <code>BitmapData</code> and uploaded to a texture on the GPU. Textures
	 * are managed internally by this component, and they will be automatically
	 * disposed when the component is disposed.
	 *
	 * <p>The following example shows how to use
	 * <code>StageTextTextEditor</code> with a <code>TextInput</code>:</p>
	 *
	 * <listing version="3.0">
	 * var input:TextInput = new TextInput();
	 * input.textEditorFactory = function():ITextEditor
	 * {
	 *     return new StageTextTextEditor();
	 * };
	 * this.addChild( input );</listing>
	 *
	 * @see feathers.controls.TextInput
	 * @see ../../../../help/text-editors.html Introduction to Feathers text editors
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html flash.text.StageText
	 * @see feathers.text.StageTextField
	 */
	public class StageTextTextEditor extends BaseTextEditor implements IMultilineTextEditor, INativeFocusOwner
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>StageTextTextEditor</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function StageTextTextEditor()
		{
			this._stageTextIsTextField = /^(Windows|Mac OS|Linux) .*/.exec(Capabilities.os) || 
				(Capabilities.playerType === "Desktop" && Capabilities.isDebugger);
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, textEditor_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return globalStyleProvider;
		}

		/**
		 * The StageText instance. It's typed Object so that a replacement class
		 * can be used in browser-based Flash Player.
		 */
		protected var stageText:Object;

		/**
		 * @copy feathers.core.INativeFocusOwner#nativeFocus
		 */
		public function get nativeFocus():Object
		{
			if(!this._isEditable)
			{
				//assignFocus() doesn't work if StageText's editable property
				//is false, so we'll just let the FocusManager take care of it
				return null;
			}
			return this.stageText;
		}

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
		protected var _measureTextField:TextField;

		/**
		 * @private
		 * This flag tells us if StageText is implemented by a TextField under
		 * the hood. We want to eliminate that damn TextField gutter to improve
		 * consistency across platforms.
		 */
		protected var _stageTextIsTextField:Boolean = false;

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
		protected var _pendingSelectionBeginIndex:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get selectionBeginIndex():int
		{
			if(this._pendingSelectionBeginIndex >= 0)
			{
				return this._pendingSelectionBeginIndex;
			}
			if(this.stageText)
			{
				return this.stageText.selectionAnchorIndex;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected var _pendingSelectionEndIndex:int = -1;

		/**
		 * @inheritDoc
		 */
		public function get selectionEndIndex():int
		{
			if(this._pendingSelectionEndIndex >= 0)
			{
				return this._pendingSelectionEndIndex;
			}
			if(this.stageText)
			{
				return this.stageText.selectionActiveIndex;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected var _stageTextIsComplete:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			if(!this._measureTextField)
			{
				return 0;
			}
			return this._measureTextField.getLineMetrics(0).ascent;
		}

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
		protected var _color:uint = uint.MAX_VALUE;

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
		 * @see #disabledColor
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#color Full description of flash.text.StageText.color in Adobe's Flash Platform API Reference
		 */
		public function get color():uint
		{
			return this._color;
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
		protected var _disabledColor:uint = uint.MAX_VALUE;

		/**
		 * Specifies text color when the component is disabled as a number
		 * containing three 8-bit RGB components.
		 *
		 * <p>In the following example, the text color is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.isEnabled = false;
		 * textEditor.disabledColor = 0xff9900;</listing>
		 *
		 * @default 0x999999
		 *
		 * @see #disabledColor
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/StageText.html#color Full description of flash.text.StageText.color in Adobe's Flash Platform API Reference
		 */
		public function get disabledColor():uint
		{
			return this._disabledColor;
		}

		/**
		 * @private
		 */
		public function set disabledColor(value:uint):void
		{
			if(this._disabledColor == value)
			{
				return;
			}
			this._disabledColor = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
		 * <p><strong>Warning:</strong> This property is ignored because
		 * <code>flash.text.StageText</code> does not support selectable text
		 * that is not editable.</p>
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
		protected var _fontPosture:String;

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
		protected var _fontSize:int = 0;

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
		protected var _fontWeight:String = null;

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
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 * 
		 * @copy feathers.controls.TextInput#maxChars
		 *
		 * @see feathers.controls.TextInput#maxChars
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
		 * <code>VerticalAlign.JUSTIFY</code>.
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
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 * 
		 * @copy feathers.controls.TextInput#restrict
		 *
		 * @see feathers.controls.TextInput#restrict
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
		protected var _textAlign:String;

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
		protected var _maintainTouchFocus:Boolean = false;

		/**
		 * If enabled, the text editor will remain in focus, even if something
		 * else is touched.
		 *
		 * <p>Note: If the <code>FocusManager</code> is enabled, this property
		 * will be ignored.</p>
		 *
		 * <p>In the following example, touch focus is maintained:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.maintainTouchFocus = true;</listing>
		 *
		 * @default false
		 */
		public function get maintainTouchFocus():Boolean
		{
			return this._maintainTouchFocus;
		}

		/**
		 * @private
		 */
		public function set maintainTouchFocus(value:Boolean):void
		{
			this._maintainTouchFocus = value;
		}

		/**
		 * @private
		 */
		protected var _lastGlobalScaleX:Number = 0;

		/**
		 * @private
		 */
		protected var _lastGlobalScaleY:Number = 0;

		/**
		 * @private
		 */
		protected var _updateSnapshotOnScaleChange:Boolean = false;

		/**
		 * Refreshes the texture snapshot every time that the text editor is
		 * scaled. Based on the scale in global coordinates, so scaling the
		 * parent will require a new snapshot.
		 *
		 * <p>Warning: setting this property to true may result in reduced
		 * performance because every change of the scale requires uploading a
		 * new texture to the GPU. Use with caution. Consider setting this
		 * property to false temporarily during animations that modify the
		 * scale.</p>
		 *
		 * <p>In the following example, the snapshot will be updated when the
		 * text editor is scaled:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.updateSnapshotOnScaleChange = true;</listing>
		 *
		 * @default false
		 */
		public function get updateSnapshotOnScaleChange():Boolean
		{
			return this._updateSnapshotOnScaleChange;
		}

		/**
		 * @private
		 */
		public function set updateSnapshotOnScaleChange(value:Boolean):void
		{
			if(this._updateSnapshotOnScaleChange == value)
			{
				return;
			}
			this._updateSnapshotOnScaleChange = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._measureTextField !== null)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				starling.nativeStage.removeChild(this._measureTextField);
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

			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(painter:Painter):void
		{
			if(this._stageTextHasFocus)
			{
				painter.excludeFromCache(this);
			}
			if(this.textSnapshot && this._updateSnapshotOnScaleChange)
			{
				var matrix:Matrix = Pool.getMatrix();
				this.getTransformationMatrix(this.stage, matrix);
				if(matrixToScaleX(matrix) !== this._lastGlobalScaleX ||
					matrixToScaleY(matrix) !== this._lastGlobalScaleY)
				{
					//the snapshot needs to be updated because the scale has
					//changed since the last snapshot was taken.
					this.invalidate(INVALIDATION_FLAG_SIZE);
					this.validate();
				}
				Pool.putMatrix(matrix);
			}

			//we'll skip this if the text field isn't visible to avoid running
			//that code every frame.
			if(this.stageText && this.stageText.visible)
			{
				this.refreshViewPortAndFontSize();
			}

			if(this.textSnapshot)
			{
				this.positionSnapshot();
			}

			super.render(painter);
		}

		/**
		 * @inheritDoc
		 */
		public function setFocus(position:Point = null):void
		{
			//setting the editable property of a StageText to false seems to be
			//ignored on Android, so this is the workaround
			if(!this._isEditable && SystemUtil.platform === "AND")
			{
				return;
			}
			if(!this._isEditable && !this._isSelectable)
			{
				return;
			}
			if(this.stage !== null && this.stageText.stage === null)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				this.stageText.stage = starling.nativeStage;
			}
			if(this.stageText && this._stageTextIsComplete)
			{
				if(position)
				{
					var positionX:Number = position.x + 2;
					var positionY:Number = position.y + 2;
					if(positionX < 0)
					{
						this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = 0;
					}
					else
					{
						this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(positionX, positionY);
						if(this._pendingSelectionBeginIndex < 0)
						{
							if(this._multiline)
							{
								var lineIndex:int = int(positionY / this._measureTextField.getLineMetrics(0).height);
								try
								{
									this._pendingSelectionBeginIndex = this._measureTextField.getLineOffset(lineIndex) + this._measureTextField.getLineLength(lineIndex);
									if(this._pendingSelectionBeginIndex != this._text.length)
									{
										this._pendingSelectionBeginIndex--;
									}
								}
								catch(error:Error)
								{
									//we may be checking for a line beyond the
									//end that doesn't exist
									this._pendingSelectionBeginIndex = this._text.length;
								}
							}
							else
							{
								this._pendingSelectionBeginIndex = this._measureTextField.getCharIndexAtPoint(positionX, this._measureTextField.getLineMetrics(0).ascent / 2);
								if(this._pendingSelectionBeginIndex < 0)
								{
									this._pendingSelectionBeginIndex = this._text.length;
								}
							}
						}
						else
						{
							var bounds:Rectangle = this._measureTextField.getCharBoundaries(this._pendingSelectionBeginIndex);
							var boundsX:Number = bounds.x;
							if(bounds && (boundsX + bounds.width - positionX) < (positionX - boundsX))
							{
								this._pendingSelectionBeginIndex++;
							}
						}
						this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
					}
				}
				else
				{
					this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
				}
				this.stageText.visible = true;
				if(!this._isEditable)
				{
					//assignFocus() does not work unless the StageText's
					//editable property is true, but we want the text to be
					//selectable. as a workaround, we temporarily set editable
					//to true before calling assignFocus(). once the StageText
					//has focus, we'll set it back to false.
					this.stageText.editable = true;
				}
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
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			//setting the focus to Starling.current.nativeStage doesn't work
			//here, so we need to use null. on Android, if we give focus to the
			//nativeStage, focus will be removed from the StageText, but the
			//soft keyboard will incorrectly remain open.
			starling.nativeStage.focus = null;
		}

		/**
		 * @inheritDoc
		 */
		public function selectRange(beginIndex:int, endIndex:int):void
		{
			if(this._stageTextIsComplete && this.stageText)
			{
				this._pendingSelectionBeginIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.stageText.selectRange(beginIndex, endIndex);
			}
			else
			{
				this._pendingSelectionBeginIndex = beginIndex;
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

			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				result.x = this._explicitWidth;
				result.y = this._explicitHeight;
				return result;
			}

			//if a parent component validates before we're added to the stage,
			//measureText() may be called before initialization, so we need to
			//force it.
			if(!this._isInitialized)
			{
				this.initializeNow();
			}

			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

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
		override protected function initialize():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(this._measureTextField !== null && this._measureTextField.parent === null)
			{
				starling.nativeStage.addChild(this._measureTextField);
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
				this._measureTextField.defaultTextFormat = new flash.text.TextFormat(null, 11, 0x000000, false, false, false);
				starling.nativeStage.addChild(this._measureTextField);
			}

			this.createStageText();
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
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			if(stylesInvalid || dataInvalid)
			{
				this.refreshMeasureProperties();
			}

			var oldIgnoreStageTextChanges:Boolean = this._ignoreStageTextChanges;
			this._ignoreStageTextChanges = true;
			if(stateInvalid || stylesInvalid)
			{
				this.refreshStageTextProperties();
			}

			if(dataInvalid)
			{
				if(this.stageText.text != this._text)
				{
					if(this._pendingSelectionBeginIndex < 0)
					{
						this._pendingSelectionBeginIndex = this.stageText.selectionActiveIndex;
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

			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN

			this._measureTextField.autoSize = TextFieldAutoSize.LEFT;

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				newWidth = this._measureTextField.textWidth;
				if(newWidth < this._explicitMinWidth)
				{
					newWidth = this._explicitMinWidth;
				}
				else if(newWidth > this._explicitMaxWidth)
				{
					newWidth = this._explicitMaxWidth;
				}
			}

			//the +4 is accounting for the TextField gutter
			this._measureTextField.width = newWidth + 4;
			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(this._stageTextIsTextField)
				{
					//we know that the StageText implementation is using
					//TextField internally, so textHeight will be accurate.
					newHeight = this._measureTextField.textHeight;
				}
				else
				{
					//since we're measuring with TextField, but rendering with
					//StageText, we're using height instead of textHeight here to be
					//sure that the measured size is on the larger side, in case the
					//rendered size is actually bigger than textHeight
					//if only StageText had an API for text measurement, we wouldn't
					//be in this mess...
					newHeight = this._measureTextField.height;
				}
				if(newHeight < this._explicitMinHeight)
				{
					newHeight = this._explicitMinHeight;
				}
				else if(newHeight > this._explicitMaxHeight)
				{
					newHeight = this._explicitMaxHeight;
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
		protected function layout(sizeInvalid:Boolean):void
		{
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);

			if(sizeInvalid || stylesInvalid || skinInvalid || stateInvalid)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				this.refreshViewPortAndFontSize();
				this.refreshMeasureTextFieldDimensions();
				var viewPort:Rectangle = this.stageText.viewPort;
				var textureRoot:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
				this._needsNewTexture = this._needsNewTexture || !this.textSnapshot ||
					(textureRoot !== null && (textureRoot.scale !== starling.contentScaleFactor ||
					viewPort.width !== textureRoot.nativeWidth || viewPort.height !== textureRoot.nativeHeight));
			}

			if(!this._stageTextHasFocus && (stateInvalid || stylesInvalid || dataInvalid || sizeInvalid || this._needsNewTexture))
			{
				var hasText:Boolean = this._text.length > 0;
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
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			var point:Point = Pool.getPoint();
			this.measure(point);
			var result:Boolean = this.saveMeasurements(point.x, point.y, point.x, point.y);
			Pool.putPoint(point);
			return result;
		}

		/**
		 * @private
		 */
		protected function refreshMeasureProperties():void
		{
			this._measureTextField.displayAsPassword = this._displayAsPassword;
			this._measureTextField.maxChars = this._maxChars;
			this._measureTextField.restrict = this._restrict;
			this._measureTextField.multiline = this._multiline;
			this._measureTextField.wordWrap = this._multiline;
			var measureFormat:flash.text.TextFormat = this._measureTextField.defaultTextFormat;
			var fontStylesFormat:starling.text.TextFormat;
			if(this._fontStyles !== null)
			{
				fontStylesFormat = this._fontStyles.getTextFormatForTarget(this);
			}

			if(this._fontFamily !== null)
			{
				measureFormat.font = this._fontFamily;
			}
			else if(fontStylesFormat !== null)
			{
				measureFormat.font = fontStylesFormat.font;
			}
			else
			{
				measureFormat.font = null;
			}

			if(this._fontSize > 0)
			{
				measureFormat.size = this._fontSize;
			}
			else if(fontStylesFormat !== null)
			{
				measureFormat.size = fontStylesFormat.size;
			}
			else
			{
				measureFormat.size = 12;
			}

			if(this._fontWeight !== null)
			{
				measureFormat.bold = this._fontWeight === FontWeight.BOLD;
			}
			else if(fontStylesFormat !== null)
			{
				measureFormat.bold = fontStylesFormat.bold;
			}
			else
			{
				measureFormat.bold = false;
			}

			if(this._fontPosture !== null)
			{
				measureFormat.italic = this._fontPosture === FontPosture.ITALIC;
			}
			else if(fontStylesFormat !== null)
			{
				measureFormat.italic = fontStylesFormat.italic;
			}
			else
			{
				measureFormat.italic = false;
			}
			//color and alignment are ignored because they don't affect
			//measurement

			this._measureTextField.defaultTextFormat = measureFormat;
			this._measureTextField.setTextFormat(measureFormat);
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

			var textFormat:starling.text.TextFormat;
			if(this._fontStyles !== null)
			{
				textFormat = this._fontStyles.getTextFormatForTarget(this);
			}
			this.stageText.autoCapitalize = this._autoCapitalize;
			this.stageText.autoCorrect = this._autoCorrect;
			if(this._isEnabled)
			{
				if(this._color === uint.MAX_VALUE)
				{
					if(textFormat !== null)
					{
						this.stageText.color = textFormat.color;
					}
					else
					{
						this.stageText.color = 0x000000;
					}
				}
				else
				{
					this.stageText.color = this._color;
				}
			}
			else //disabled
			{
				if(this._disabledColor === uint.MAX_VALUE)
				{
					if(this._color === uint.MAX_VALUE)
					{
						if(textFormat !== null)
						{
							this.stageText.color = textFormat.color;
						}
						else
						{
							this.stageText.color = 0x000000;
						}
					}
					else
					{
						this.stageText.color = this._color;
					}
				}
				else
				{
					this.stageText.color = this._disabledColor;
				}
			}
			this.stageText.displayAsPassword = this._displayAsPassword;
			var fontFamily:String = this._fontFamily;
			if(fontFamily === null && textFormat !== null)
			{
				fontFamily = textFormat.font;
			} //default to null
			this.stageText.fontFamily = fontFamily;
			var fontPosture:String = this._fontPosture;
			if(fontPosture === null)
			{
				if(textFormat !== null && textFormat.italic)
				{
					fontPosture = FontPosture.ITALIC;
				}
				else
				{
					fontPosture = FontPosture.NORMAL;
				}
			}
			this.stageText.fontPosture = fontPosture;
			var fontWeight:String = this._fontWeight;
			if(fontWeight === null)
			{
				if(textFormat !== null && textFormat.bold)
				{
					fontWeight = FontWeight.BOLD;
				}
				else
				{
					fontWeight = FontWeight.NORMAL;
				}
			}
			this.stageText.fontWeight = fontWeight;
			this.stageText.locale = this._locale;
			this.stageText.maxChars = this._maxChars;
			this.stageText.restrict = this._restrict;
			this.stageText.returnKeyLabel = this._returnKeyLabel;
			this.stageText.softKeyboardType = this._softKeyboardType;
			var textAlign:String = this._textAlign;
			if(textAlign === null)
			{
				if(textFormat !== null && textFormat.horizontalAlign)
				{
					textAlign = textFormat.horizontalAlign;
				}
				else
				{
					textAlign = TextFormatAlign.START;
				}
			}
			this.stageText.textAlign = textAlign;
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
			if(this._pendingSelectionBeginIndex >= 0)
			{
				var startIndex:int = this._pendingSelectionBeginIndex;
				var endIndex:int = (this._pendingSelectionEndIndex < 0) ? this._pendingSelectionBeginIndex : this._pendingSelectionEndIndex;
				this._pendingSelectionBeginIndex = -1;
				this._pendingSelectionEndIndex = -1;
				if(this.stageText.selectionAnchorIndex != startIndex || this.stageText.selectionActiveIndex != endIndex)
				{
					//if the same range is already selected, don't try to do it
					//again because on iOS, if the StageText is multiline, this
					//will cause the clipboard menu to appear when it shouldn't.
					this.selectRange(startIndex, endIndex);
				}
			}
		}

		/**
		 * @private
		 */
		protected function texture_onRestore():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(this.textSnapshot.texture.scale != starling.contentScaleFactor)
			{
				//if we've changed between scale factors, we need to recreate
				//the texture to match the new scale factor.
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
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
		}

		/**
		 * @private
		 */
		protected function refreshSnapshot():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			//StageText's stage property cannot be null when we call
			//drawViewPortToBitmapData()
			if(this.stage !== null && this.stageText.stage === null)
			{
				this.stageText.stage = starling.nativeStage;
			}
			if(this.stageText.stage === null)
			{
				//we need to keep a flag active so that the snapshot will be
				//refreshed after the text editor is added to the stage
				this.invalidate(INVALIDATION_FLAG_DATA);
				return;
			}
			var viewPort:Rectangle = this.stageText.viewPort;
			if(viewPort.width == 0 || viewPort.height == 0)
			{
				return;
			}
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			//StageText sucks because it requires that the BitmapData's width
			//and height exactly match its view port width and height.
			//(may be doubled on Retina Mac) 
			try
			{
				var bitmapData:BitmapData = new BitmapData(viewPort.width * nativeScaleFactor, viewPort.height * nativeScaleFactor, true, 0x00ff00ff);
				this.stageText.drawViewPortToBitmapData(bitmapData);
			} 
			catch(error:Error) 
			{
				//drawing stage text to the bitmap data at double size may fail
				//on runtime versions less than 15, so fall back to using a
				//snapshot that is half size. it's not ideal, but better than
				//nothing.
				bitmapData.dispose();
				bitmapData = new BitmapData(viewPort.width, viewPort.height, true, 0x00ff00ff);
				this.stageText.drawViewPortToBitmapData(bitmapData);
			}

			var newTexture:Texture;
			if(!this.textSnapshot || this._needsNewTexture)
			{
				var scaleFactor:Number = starling.contentScaleFactor;
				//skip Texture.fromBitmapData() because we don't want
				//it to create an onRestore function that will be
				//immediately discarded for garbage collection. 
				newTexture = Texture.empty(bitmapData.width / scaleFactor, bitmapData.height / scaleFactor,
					true, false, false, scaleFactor);
				newTexture.root.uploadBitmapData(bitmapData);
				newTexture.root.onRestore = texture_onRestore;
			}
			if(!this.textSnapshot)
			{
				this.textSnapshot = new Image(newTexture);
				this.textSnapshot.pixelSnapping = true;
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
					var existingTexture:Texture = this.textSnapshot.texture;
					existingTexture.root.uploadBitmapData(bitmapData);
					//however, the image won't be notified that its
					//texture has changed, so we need to do it manually
					this.textSnapshot.setRequiresRedraw();
				}
			}
			var matrix:Matrix = Pool.getMatrix();
			this.getTransformationMatrix(this.stage, matrix);
			var globalScaleX:Number = matrixToScaleX(matrix);
			var globalScaleY:Number = matrixToScaleY(matrix);
			Pool.putMatrix(matrix);
			if(this._updateSnapshotOnScaleChange)
			{
				this.textSnapshot.scaleX = 1 / globalScaleX;
				this.textSnapshot.scaleY = 1 / globalScaleY;
				this._lastGlobalScaleX = globalScaleX;
				this._lastGlobalScaleY = globalScaleY;
			}
			else
			{
				this.textSnapshot.scaleX = 1;
				this.textSnapshot.scaleY = 1;
			}
			if(nativeScaleFactor > 1 && bitmapData.width == viewPort.width)
			{
				//when we fall back to using a snapshot that is half size on
				//older runtimes, we need to scale it up.
				this.textSnapshot.scaleX *= nativeScaleFactor;
				this.textSnapshot.scaleY *= nativeScaleFactor;
			}
			bitmapData.dispose();
			this._needsNewTexture = false;
		}

		/**
		 * @private
		 */
		protected function refreshViewPortAndFontSize():void
		{
			var matrix:Matrix = Pool.getMatrix();
			var point:Point = Pool.getPoint();
			var desktopGutterPositionOffset:Number = 0;
			var desktopGutterDimensionsOffset:Number = 0;
			if(this._stageTextIsTextField)
			{
				desktopGutterPositionOffset = 2;
				desktopGutterDimensionsOffset = 4;
			}
			this.getTransformationMatrix(this.stage, matrix);
			if(this._stageTextHasFocus || this._updateSnapshotOnScaleChange)
			{
				var globalScaleX:Number = matrixToScaleX(matrix);
				var globalScaleY:Number = matrixToScaleY(matrix);
				var smallerGlobalScale:Number = globalScaleX;
				if(globalScaleY < smallerGlobalScale)
				{
					smallerGlobalScale = globalScaleY;
				}
			}
			else
			{
				globalScaleX = 1;
				globalScaleY = 1;
				smallerGlobalScale = 1;
			}
			var verticalAlignOffsetY:Number = this.getVerticalAlignmentOffsetY();
			if(this.is3D)
			{
				var matrix3D:Matrix3D = Pool.getMatrix3D();
				var point3D:Vector3D = Pool.getPoint3D();
				this.getTransformationMatrix3D(this.stage, matrix3D);
				MatrixUtil.transformCoords3D(matrix3D, -desktopGutterPositionOffset, -desktopGutterPositionOffset + verticalAlignOffsetY, 0, point3D);
				point.setTo(point3D.x, point3D.y);
				Pool.putPoint3D(point3D);
				Pool.putMatrix3D(matrix3D);
			}
			else
			{
				MatrixUtil.transformCoords(matrix, -desktopGutterPositionOffset, -desktopGutterPositionOffset + verticalAlignOffsetY, point);
			}
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			var scaleFactor:Number = starling.contentScaleFactor / nativeScaleFactor;
			var starlingViewPort:Rectangle = starling.viewPort;
			var stageTextViewPort:Rectangle = this.stageText.viewPort;
			if(!stageTextViewPort)
			{
				stageTextViewPort = new Rectangle();
			}
			stageTextViewPort.x = Math.round(starlingViewPort.x + (point.x * scaleFactor));
			stageTextViewPort.y = Math.round(starlingViewPort.y + (point.y * scaleFactor));
			var viewPortWidth:Number = Math.round((this.actualWidth + desktopGutterDimensionsOffset) * scaleFactor * globalScaleX);
			if(viewPortWidth < 1 ||
				viewPortWidth !== viewPortWidth) //isNaN
			{
				viewPortWidth = 1;
			}
			var viewPortHeight:Number = Math.round((this.actualHeight + desktopGutterDimensionsOffset) * scaleFactor * globalScaleY);
			if(viewPortHeight < 1 ||
				viewPortHeight !== viewPortHeight) //isNaN
			{
				viewPortHeight = 1;
			}
			stageTextViewPort.width = viewPortWidth;
			stageTextViewPort.height = viewPortHeight;
			this.stageText.viewPort = stageTextViewPort;

			var fontSize:int = 12;
			if(this._fontSize > 0)
			{
				fontSize = this._fontSize;
			}
			else if(this._fontStyles !== null)
			{
				var textFormat:starling.text.TextFormat = this._fontStyles.getTextFormatForTarget(this);
				if(textFormat !== null)
				{
					fontSize = textFormat.size;
				}
			}
			//StageText's fontSize property is an int, so we need to
			//specifically avoid using Number here.
			var newFontSize:int = fontSize * scaleFactor * smallerGlobalScale;
			if(this.stageText.fontSize != newFontSize)
			{
				//we need to check if this value has changed because on iOS
				//if displayAsPassword is set to true, the new character
				//will not be shown if the font size changes. instead, it
				//immediately changes to a bullet. (Github issue #881)
				this.stageText.fontSize = newFontSize;
			}
			Pool.putPoint(point);
			Pool.putMatrix(matrix);
		}

		/**
		 * @private
		 */
		protected function refreshMeasureTextFieldDimensions():void
		{
			//the +4 is accounting for the TextField gutter
			this._measureTextField.width = this.actualWidth + 4;
			this._measureTextField.height = this.actualHeight;
		}

		/**
		 * @private
		 */
		protected function positionSnapshot():void
		{
			var matrix:Matrix = Pool.getMatrix();
			this.getTransformationMatrix(this.stage, matrix);
			var desktopGutterPositionOffset:Number = 0;
			if(this._stageTextIsTextField)
			{
				desktopGutterPositionOffset = 2;
			}
			this.textSnapshot.x = Math.round(matrix.tx) - matrix.tx - desktopGutterPositionOffset;
			this.textSnapshot.y = Math.round(matrix.ty) - matrix.ty - desktopGutterPositionOffset +
				this.getVerticalAlignmentOffsetY();
			Pool.putMatrix(matrix);
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
			this.stageText.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, stageText_softKeyboardActivatingHandler);
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
				var StageTextInitOptionsType:Class = Class(getDefinitionByName("flash.text.StageTextInitOptions"));
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
			this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, stageText_softKeyboardActivatingHandler);
			this.stageText.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, stageText_softKeyboardDeactivateHandler);
			this.stageText.addEventListener(flash.events.Event.COMPLETE, stageText_completeHandler);
			this.stageText.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, stageText_mouseFocusChangeHandler);
			this.invalidate();
		}

		/**
		 * @private
		 */
		protected function getVerticalAlignment():String
		{
			var verticalAlign:String = null;
			if(this._fontStyles !== null)
			{
				var format:starling.text.TextFormat = this._fontStyles.getTextFormatForTarget(this);
				if(format !== null)
				{
					verticalAlign = format.verticalAlign;
				}
			}
			if(verticalAlign === null)
			{
				verticalAlign = Align.TOP;
			}
			return verticalAlign;
		}

		/**
		 * @private
		 */
		protected function getVerticalAlignmentOffsetY():Number
		{
			var verticalAlign:String = this.getVerticalAlignment();
			if(this._measureTextField.textHeight > this.actualHeight)
			{
				return 0;
			}
			if(verticalAlign === Align.BOTTOM)
			{
				return (this.actualHeight - this._measureTextField.textHeight);
			}
			else if(verticalAlign === Align.CENTER)
			{
				return (this.actualHeight - this._measureTextField.textHeight) / 2;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function dispatchKeyFocusChangeEvent(event:KeyboardEvent):void
		{
			var starling:Starling = stageToStarling(this.stage);
			var focusEvent:FocusEvent = new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE, true, false, null, event.shiftKey, event.keyCode);
			starling.nativeStage.dispatchEvent(focusEvent);
		}

		/**
		 * @private
		 */
		protected function textEditor_removedFromStageHandler(event:starling.events.Event):void
		{
			//remove this from the stage, if needed
			//it will be added back next time we receive focus
			this.stageText.stage = null;
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
			if(!this._isEditable)
			{
				//see the other half of this hack in setFocus()
				this.stageText.editable = false;
			}
			this.addEventListener(starling.events.Event.ENTER_FRAME, hasFocus_enterFrameHandler);
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
		protected function hasFocus_enterFrameHandler(event:starling.events.Event):void
		{
			if(this._stageTextHasFocus)
			{
				var target:DisplayObject = this;
				do
				{
					if(!target.visible)
					{
						this.stageText.stage.focus = null;
						break;
					}
					target = target.parent;
				}
				while(target)
			}
			else
			{
				this.removeEventListener(starling.events.Event.ENTER_FRAME, hasFocus_enterFrameHandler);
			}
		}

		/**
		 * @private
		 */
		protected function stageText_mouseFocusChangeHandler(event:FocusEvent):void
		{
			if(!this._maintainTouchFocus)
			{
				return;
			}
			event.preventDefault();
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
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				starling.nativeStage.focus = starling.nativeStage;
			}
			if(event.keyCode === Keyboard.TAB && FocusManager.isEnabledForStage(this.stage))
			{
				event.preventDefault();
				this.dispatchKeyFocusChangeEvent(event);
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
			if(event.keyCode === Keyboard.TAB && FocusManager.isEnabledForStage(this.stage))
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
		protected function stageText_softKeyboardActivatingHandler(event:SoftKeyboardEvent):void
		{
			this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATING, true);
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
