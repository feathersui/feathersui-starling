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
	import feathers.core.IFeathersControl;
	import feathers.core.INativeFocusOwner;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.utils.geom.matrixToRotation;
	import feathers.utils.geom.matrixToScaleX;
	import feathers.utils.geom.matrixToScaleY;

	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display3D.Context3DProfile;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.text.AntiAliasType;
	import flash.text.FontType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.rendering.Painter;
	import starling.text.TextFormat;
	import starling.textures.ConcreteTexture;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.MathUtil;
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
	 * Dispatched when the user presses the Enter key while the editor has focus.
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
	 * <code>TextInput</code> component, using the native
	 * <code>flash.text.TextField</code> class with its <code>type</code>
	 * property set to <code>flash.text.TextInputType.INPUT</code>. When not in
	 * focus, the <code>TextField</code> is drawn to <code>BitmapData</code> and
	 * uploaded to a texture on the GPU. Textures are managed internally by this
	 * component, and they will be automatically disposed when the component is
	 * disposed.
	 *
	 * <p>For desktop apps, <code>TextFieldTextEditor</code> is recommended
	 * instead of <code>StageTextTextEditor</code>. <code>StageTextTextEditor</code>
	 * will still work in desktop apps, but it is more appropriate for mobile
	 * apps.</p>
	 *
	 * <p>The following example shows how to use
	 * <code>TextFieldTextEditor</code> with a <code>TextInput</code>:</p>
	 *
	 * <listing version="3.0">
	 * var input:TextInput = new TextInput();
	 * input.textEditorFactory = function():ITextEditor
	 * {
	 *     return new TextFieldTextEditor();
	 * };
	 * this.addChild( input );</listing>
	 *
	 * @see feathers.controls.TextInput
	 * @see ../../../../help/text-editors.html Introduction to Feathers text editors
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html flash.text.TextField
	 */
	public class TextFieldTextEditor extends BaseTextEditor implements ITextEditor, INativeFocusOwner
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>TextFieldTextEditor</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function TextFieldTextEditor()
		{
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(Event.ADDED_TO_STAGE, textEditor_addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, textEditor_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return globalStyleProvider;
		}

		/**
		 * The text field sub-component.
		 */
		protected var textField:TextField;

		/**
		 * @copy feathers.core.INativeFocusOwner#nativeFocus
		 */
		public function get nativeFocus():Object
		{
			return this.textField;
		}

		/**
		 * An image that displays a snapshot of the native <code>TextField</code>
		 * in the Starling display list when the editor doesn't have focus.
		 */
		protected var textSnapshot:Image;

		/**
		 * The separate text field sub-component used for measurement.
		 * Typically, the main text field often doesn't report correct values
		 * for a full frame if its dimensions are changed too often.
		 */
		protected var measureTextField:TextField;

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
		protected var _textFieldSnapshotClipRect:Rectangle = new Rectangle();

		/**
		 * @private
		 */
		protected var _textFieldOffsetX:Number = 0;

		/**
		 * @private
		 */
		protected var _textFieldOffsetY:Number = 0;

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
		protected var _needsNewTexture:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function get baseline():Number
		{
			if(!this.textField)
			{
				return 0;
			}
			var gutterDimensionsOffset:Number = 0;
			if(this._useGutter)
			{
				gutterDimensionsOffset = 2;
			}
			return gutterDimensionsOffset + this.textField.getLineMetrics(0).ascent;
		}

		/**
		 * @private
		 */
		protected var _previousTextFormat:flash.text.TextFormat;

		/**
		 * @private
		 */
		protected var _currentTextFormat:flash.text.TextFormat;

		/**
		 * For debugging purposes, the current
		 * <code>flash.text.TextFormat</code> used to render the text. Updated
		 * during validation, and may be <code>null</code> before the first
		 * validation.
		 *
		 * <p>Do not modify this value. It is meant for testing and debugging
		 * only. Use the parent's <code>starling.text.TextFormat</code> font
		 * styles APIs instead.</p>
		 */
		public function get currentTextFormat():flash.text.TextFormat
		{
			return this._currentTextFormat;
		}

		/**
		 * @private
		 */
		protected var _textFormatForState:Object;

		/**
		 * @private
		 */
		protected var _fontStylesTextFormat:flash.text.TextFormat;

		/**
		 * @private
		 */
		protected var _textFormat:flash.text.TextFormat;

		/**
		 * Advanced font formatting used to draw the text, if
		 * <code>fontStyles</code> and <code>starling.text.TextFormat</code>
		 * cannot be used on the parent component because the full capabilities
		 * of <code>flash.text.TextField</code> are required.
		 *
		 * <p>In the following example, the text format is changed:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.textFormat = new TextFormat( "Source Sans Pro" );;</listing>
		 *
		 * <p><strong>Warning:</strong> If this property is not
		 * <code>null</code>, any <code>starling.text.TextFormat</code> font
		 * styles that are passed in from the parent component may be ignored.
		 * In other words, advanced font styling with
		 * <code>flash.text.TextFormat</code> will always take precedence.</p>
		 *
		 * @default null
		 *
		 * @see #setTextFormatForState()
		 * @see #disabledTextFormat
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html flash.text.TextFormat
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
			//since the text format has changed, the comparison will return
			//false whether we use the real previous format or null. might as
			//well remove the reference to an object we don't need anymore.
			this._previousTextFormat = null;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _disabledTextFormat:flash.text.TextFormat;

		/**
		 * Advanced font formatting used to draw the text when the component is
		 * disabled, if <code>disabledFontStyles</code> and
		 * <code>starling.text.TextFormat</code> cannot be used on the parent
		 * component because the full capabilities of
		 * <code>flash.text.TextField</code> are required.
		 *
		 * <p>In the following example, the disabled text format is changed:</p>
		 *
		 * <p><strong>Warning:</strong> If this property is not
		 * <code>null</code>, any <code>starling.text.TextFormat</code> font
		 * styles that are passed in from the parent component may be ignored.
		 * In other words, advanced font styling with
		 * <code>flash.text.TextFormat</code> will always take precedence.</p>
		 *
		 * <listing version="3.0">
		 * textEditor.isEnabled = false;
		 * textEditor.disabledTextFormat = new TextFormat( "Source Sans Pro" );</listing>
		 *
		 * @default null
		 *
		 * @see #textFormat
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html flash.text.TextFormat
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
		protected var _embedFonts:Boolean = false;

		/**
		 * If advanced <code>flash.text.TextFormat</code> styles are specified,
		 * determines if the TextField should use an embedded font or not. If
		 * the specified font is not embedded, the text may not be displayed at
		 * all.
		 *
		 * <p>If the font styles are passed in from the parent component, the
		 * text renderer will automatically detect if a font is embedded or not,
		 * and the <code>embedFonts</code> property will be ignored if it is set
		 * to <code>false</code>. Setting it to <code>true</code> will force the
		 * <code>TextField</code> to always try to use embedded fonts.</p>
		 *
		 * <p>In the following example, the font is embedded:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.embedFonts = true;</listing>
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#embedFonts Full description of flash.text.TextField.embedFonts in Adobe's Flash Platform API Reference
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
		 *
		 * <p>In the following example, word wrap is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.wordWrap = true;</listing>
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#wordWrap Full description of flash.text.TextField.wordWrap in Adobe's Flash Platform API Reference
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
		protected var _multiline:Boolean = false;

		/**
		 * Indicates whether field is a multiline text field.
		 *
		 * <p>In the following example, multiline is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.multiline = true;</listing>
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#multiline Full description of flash.text.TextField.multiline in Adobe's Flash Platform API Reference
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
		protected var _isHTML:Boolean = false;

		/**
		 * Determines if the TextField should display the value of the
		 * <code>text</code> property as HTML or not.
		 *
		 * <p>In the following example, the text is displayed as HTML:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.isHTML = true;</listing>
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText flash.text.TextField.htmlText
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
		 * When set to <code>true</code> and the text field is not in focus,
		 * Flash Player highlights the selection in the text field in gray. When
		 * set to <code>false</code> and the text field is not in focus, Flash
		 * Player does not highlight the selection in the text field.
		 *
		 * <p>In the following example, the selection is always shown:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.alwaysShowSelection = true;</listing>
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#alwaysShowSelection Full description of flash.text.TextField.alwaysShowSelection in Adobe's Flash Platform API Reference
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
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 * 
		 * Specifies whether the text field is a password text field that hides
		 * the input characters using asterisks instead of the actual
		 * characters.
		 *
		 * @see feathers.controls.TextInput#displayAsPassword
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#displayAsPassword Full description of flash.text.TextField.displayAsPassword in Adobe's Flash Platform API Reference
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
		protected var _maxChars:int = 0;

		/**
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 * 
		 * @copy feathers.controls.TextInput#maxChars
		 *
		 * @see feathers.controls.TextInput#maxChars
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#maxChars Full description of flash.text.TextField.maxChars in Adobe's Flash Platform API Reference
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
		 * <p>This property is managed by the <code>TextInput</code>.</p>
		 * 
		 * @copy feathers.controls.TextInput#restrict
		 *
		 * @see feathers.controls.TextInput#restrict
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#restrict Full description of flash.text.TextField.restrict in Adobe's Flash Platform API Reference
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
		 * @private
		 */
		private var _antiAliasType:String = AntiAliasType.ADVANCED;

		/**
		 * The type of anti-aliasing used for this text field, defined as
		 * constants in the <code>flash.text.AntiAliasType</code> class. You can
		 * control this setting only if the font is embedded (with the
		 * <code>embedFonts</code> property set to true).
		 *
		 * <p>In the following example, the anti-alias type is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.antiAliasType = AntiAliasType.NORMAL;</listing>
		 *
		 * @default flash.text.AntiAliasType.ADVANCED
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#antiAliasType Full description of flash.text.TextField.antiAliasType in Adobe's Flash Platform API Reference
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/AntiAliasType.html flash.text.AntiAliasType
		 * @see #embedFonts
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
		private var _gridFitType:String = GridFitType.PIXEL;

		/**
		 * Determines whether Flash Player forces strong horizontal and vertical
		 * lines to fit to a pixel or subpixel grid, or not at all using the
		 * constants defined in the <code>flash.text.GridFitType</code> class.
		 * This property applies only if the <code>antiAliasType</code> property
		 * of the text field is set to <code>flash.text.AntiAliasType.ADVANCED</code>.
		 *
		 * <p>In the following example, the grid fit type is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.gridFitType = GridFitType.SUBPIXEL;</listing>
		 *
		 * @default flash.text.GridFitType.PIXEL
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#gridFitType Full description of flash.text.TextField.gridFitType in Adobe's Flash Platform API Reference
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/GridFitType.html flash.text.GridFitType
		 * @see #antiAliasType
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
		 * The sharpness of the glyph edges in this text field. This property
		 * applies only if the <code>antiAliasType</code> property of the text
		 * field is set to <code>flash.text.AntiAliasType.ADVANCED</code>. The
		 * range for <code>sharpness</code> is a number from <code>-400</code>
		 * to <code>400</code>.
		 *
		 * <p>In the following example, the sharpness is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.sharpness = 200;</listing>
		 *
		 * @default 0
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#sharpness Full description of flash.text.TextField.sharpness in Adobe's Flash Platform API Reference
		 * @see #antiAliasType
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
		 * The thickness of the glyph edges in this text field. This property
		 * applies only if the <code>antiAliasType</code> property is set to
		 * <code>flash.text.AntiAliasType.ADVANCED</code>. The range for
		 * <code>thickness</code> is a number from <code>-200</code> to
		 * <code>200</code>.
		 *
		 * <p>In the following example, the thickness is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.thickness = 100;</listing>
		 *
		 * @default 0
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#thickness Full description of flash.text.TextField.thickness in Adobe's Flash Platform API Reference
		 * @see #antiAliasType
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

		/**
		 * @private
		 */
		private var _background:Boolean = false;

		/**
		 * Specifies whether the text field has a background fill. Use the
		 * <code>backgroundColor</code> property to set the background color of
		 * a text field.
		 *
		 * <p>In the following example, the background is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.background = true;
		 * textRenderer.backgroundColor = 0xff0000;</listing>
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#background Full description of flash.text.TextField.background in Adobe's Flash Platform API Reference
		 * @see #backgroundColor
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
		 * The color of the text field background that is displayed if the
		 * <code>background</code> property is set to <code>true</code>.
		 *
		 * <p>In the following example, the background color is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.background = true;
		 * textRenderer.backgroundColor = 0xff000ff;</listing>
		 *
		 * @default 0xffffff
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#backgroundColor Full description of flash.text.TextField.backgroundColor in Adobe's Flash Platform API Reference
		 * @see #background
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
		 * Specifies whether the text field has a border. Use the
		 * <code>borderColor</code> property to set the border color.
		 *
		 * <p>Note: this property cannot be used when the <code>useGutter</code>
		 * property is set to <code>false</code> (the default value!).</p>
		 *
		 * <p>In the following example, the border is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.border = true;
		 * textRenderer.borderColor = 0xff0000;</listing>
		 *
		 * @default false
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#border Full description of flash.text.TextField.border in Adobe's Flash Platform API Reference
		 * @see #borderColor
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
		 * The color of the text field border that is displayed if the
		 * <code>border</code> property is set to <code>true</code>.
		 *
		 * <p>In the following example, the border color is changed:</p>
		 *
		 * <listing version="3.0">
		 * textRenderer.border = true;
		 * textRenderer.borderColor = 0xff00ff;</listing>
		 *
		 * @default 0x000000
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#borderColor Full description of flash.text.TextField.borderColor in Adobe's Flash Platform API Reference
		 * @see #border
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
		protected var _useGutter:Boolean = false;

		/**
		 * Determines if the 2-pixel gutter around the edges of the
		 * <code>flash.text.TextField</code> will be used in measurement and
		 * layout. To visually align with other text renderers and text editors,
		 * it is often best to leave the gutter disabled.
		 *
		 * <p>In the following example, the gutter is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.useGutter = true;</listing>
		 *
		 * @default false
		 */
		public function get useGutter():Boolean
		{
			return this._useGutter;
		}

		/**
		 * @private
		 */
		public function set useGutter(value:Boolean):void
		{
			if(this._useGutter == value)
			{
				return;
			}
			this._useGutter = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @inheritDoc
		 */
		public function get setTouchFocusOnEndedPhase():Boolean
		{
			return false;
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
			if(this.textField)
			{
				return this.textField.selectionBeginIndex;
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
			if(this.textField)
			{
				return this.textField.selectionEndIndex;
			}
			return 0;
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
		protected var _useSnapshotDelayWorkaround:Boolean = false;

		/**
		 * Fixes an issue where <code>flash.text.TextField</code> renders
		 * incorrectly when drawn to <code>BitmapData</code> by waiting one
		 * frame.
		 *
		 * <p>Warning: enabling this workaround may cause slight flickering
		 * after the <code>text</code> property is changed.</p>
		 *
		 * <p>In the following example, the workaround is enabled:</p>
		 *
		 * <listing version="3.0">
		 * textEditor.useSnapshotDelayWorkaround = true;</listing>
		 *
		 * @default false
		 */
		public function get useSnapshotDelayWorkaround():Boolean
		{
			return this._useSnapshotDelayWorkaround;
		}

		/**
		 * @private
		 */
		public function set useSnapshotDelayWorkaround(value:Boolean):void
		{
			if(this._useSnapshotDelayWorkaround == value)
			{
				return;
			}
			this._useSnapshotDelayWorkaround = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var resetScrollOnFocusOut:Boolean = true;

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this.textSnapshot)
			{
				//avoid the need to call dispose(). we'll create a new snapshot
				//when the renderer is added to stage again.
				this.textSnapshot.texture.dispose();
				this.removeChild(this.textSnapshot, true);
				this.textSnapshot = null;
			}

			if(this.textField)
			{
				if(this.textField.parent)
				{
					this.textField.parent.removeChild(this.textField);
				}
				this.textField.removeEventListener(flash.events.Event.CHANGE, textField_changeHandler);
				this.textField.removeEventListener(FocusEvent.FOCUS_IN, textField_focusInHandler);
				this.textField.removeEventListener(FocusEvent.FOCUS_OUT, textField_focusOutHandler);
				this.textField.removeEventListener(KeyboardEvent.KEY_DOWN, textField_keyDownHandler);
				this.textField.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, textField_softKeyboardActivatingHandler);
				this.textField.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, textField_softKeyboardActivateHandler);
				this.textField.removeEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, textField_softKeyboardDeactivateHandler);
			}
			//this isn't necessary, but if a memory leak keeps the text renderer
			//from being garbage collected, freeing up the text field may help
			//ease major memory pressure from native filters
			this.textField = null;
			this.measureTextField = null;
			
			this.stateContext = null;

			super.dispose();
		}

		/**
		 * @private
		 */
		override public function render(painter:Painter):void
		{
			if(this.textSnapshot)
			{
				if(this._updateSnapshotOnScaleChange)
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
				this.positionSnapshot();
			}
			//we'll skip this if the text field isn't visible to avoid running
			//that code every frame.
			if(this.textField && this.textField.visible)
			{
				this.transformTextField();
			}
			super.render(painter);
		}

		/**
		 * @inheritDoc
		 */
		public function setFocus(position:Point = null):void
		{
			if(this.textField !== null)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				if(this.textField.parent === null)
				{
					starling.nativeStage.addChild(this.textField);
				}
				if(position !== null)
				{
					var nativeScaleFactor:Number = 1;
					if(starling.supportHighResolutions)
					{
						nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
					}
					var scaleFactor:Number = starling.contentScaleFactor / nativeScaleFactor;
					var scaleX:Number = this.textField.scaleX;
					var scaleY:Number = this.textField.scaleY;
					var gutterPositionOffset:Number = 2;
					if(this._useGutter)
					{
						gutterPositionOffset = 0;
					}
					var positionX:Number = position.x + gutterPositionOffset;
					var positionY:Number = position.y + gutterPositionOffset;
					if(positionX < gutterPositionOffset)
					{
						//account for negative positions
						positionX = gutterPositionOffset;
					}
					else
					{
						var maxPositionX:Number = (this.textField.width / scaleX) - gutterPositionOffset;
						if(positionX > maxPositionX)
						{
							positionX = maxPositionX;
						}
					}
					if(positionY < gutterPositionOffset)
					{
						//account for negative positions
						positionY = gutterPositionOffset;
					}
					else
					{
						var maxPositionY:Number = (this.textField.height / scaleY) - gutterPositionOffset;
						if(positionY > maxPositionY)
						{
							positionY = maxPositionY;
						}
					}
					this._pendingSelectionBeginIndex = this.getSelectionIndexAtPoint(positionX, positionY);
					if(this._pendingSelectionBeginIndex < 0)
					{
						if(this._multiline)
						{
							var lineIndex:int = this.textField.getLineIndexAtPoint((this.textField.width / 2) / scaleX, positionY);
							try
							{
								this._pendingSelectionBeginIndex = this.textField.getLineOffset(lineIndex) + this.textField.getLineLength(lineIndex);
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
							this._pendingSelectionBeginIndex = this.getSelectionIndexAtPoint(positionX, this.textField.getLineMetrics(0).ascent / 2);
							if(this._pendingSelectionBeginIndex < 0)
							{
								this._pendingSelectionBeginIndex = this._text.length;
							}
						}
					}
					else
					{
						var bounds:Rectangle = this.textField.getCharBoundaries(this._pendingSelectionBeginIndex);
						//bounds should never be null because the character
						//index passed to getCharBoundaries() comes from a
						//call to getCharIndexAtPoint(). however, a user
						//reported that a null reference error happened
						//here! I couldn't reproduce, but I might as well
						//assume that the runtime has a bug. won't hurt.
						if(bounds)
						{
							var boundsX:Number = bounds.x;
							if(bounds && (boundsX + bounds.width - positionX) < (positionX - boundsX))
							{
								this._pendingSelectionBeginIndex++;
							}
						}
					}
					this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
				}
				else
				{
					this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
				}
				if(!FocusManager.isEnabledForStage(this.stage))
				{
					starling.nativeStage.focus = this.textField;
				}
				this.textField.requestSoftKeyboard();
				if(this._textFieldHasFocus)
				{
					this.invalidate(INVALIDATION_FLAG_SELECTED);
				}
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
			if(!this._textFieldHasFocus)
			{
				return;
			}
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var nativeStage:Stage = starling.nativeStage;
			if(nativeStage.focus === this.textField)
			{
				//only clear the native focus when our native target has focus
				//because otherwise another component may lose focus.

				//setting the focus to Starling.current.nativeStage doesn't work
				//here, so we need to use null. on Android, if we give focus to the
				//nativeStage, focus will be removed from the StageText, but the
				//soft keyboard will incorrectly remain open.
				nativeStage.focus = null;
				
				//previously, there was a comment here that said that the native
				//stage focus should not be set to null. this was due to an
				//issue in focus manager where focus would be restored
				//incorrectly if the stage focus became null. this issue was
				//fixed, and it is now considered safe to use null.
			}
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
			if(this.textField)
			{
				if(!this._isValidating)
				{
					this.validate();
				}
				this.textField.setSelection(beginIndex, endIndex);
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

			this.commit();

			result = this.measure(result);

			return result;
		}

		/**
		 * Gets the advanced <code>flash.text.TextFormat</code> font formatting
		 * passed in using <code>setTextFormatForState()</code> for the
		 * specified state.
		 *
		 * <p>If an <code>flash.text.TextFormat</code> is not defined for a
		 * specific state, returns <code>null</code>.</p>
		 *
		 * @see #setTextFormatForState()
		 */
		public function getTextFormatForState(state:String):flash.text.TextFormat
		{
			if(this._textFormatForState === null)
			{
				return null;
			}
			return flash.text.TextFormat(this._textFormatForState[state]);
		}

		/**
		 * Sets the advanced <code>flash.text.TextFormat</code> font formatting
		 * to be used by the text editor when the <code>currentState</code>
		 * property of the <code>stateContext</code> matches the specified state
		 * value.
		 *
		 * <p>If an <code>TextFormat</code> is not defined for a specific
		 * state, the value of the <code>textFormat</code> property will be
		 * used instead.</p>
		 *
		 * <p>If the <code>disabledTextFormat</code> property is not
		 * <code>null</code> and the <code>isEnabled</code> property is
		 * <code>false</code>, all other text formats will be ignored.</p>
		 *
		 * @see #stateContext
		 * @see #textFormat
		 */
		public function setTextFormatForState(state:String, textFormat:flash.text.TextFormat):void
		{
			if(textFormat)
			{
				if(!this._textFormatForState)
				{
					this._textFormatForState = {};
				}
				this._textFormatForState[state] = textFormat;
			}
			else
			{
				delete this._textFormatForState[state];
			}
			//if the context's current state is the state that we're modifying,
			//we need to use the new value immediately.
			if(this._stateContext && this._stateContext.currentState === state)
			{
				this.invalidate(INVALIDATION_FLAG_STATE);
			}
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this.textField = new TextField();
			//let's ensure that the text field can only get keyboard focus
			//through code. no need to set mouseEnabled to false since the text
			//field won't be visible until it needs to be interactive, so it
			//can't receive focus with mouse/touch anyway.
			this.textField.tabEnabled = false;
			this.textField.visible = false;
			this.textField.needsSoftKeyboard = true;
			this.textField.addEventListener(flash.events.Event.CHANGE, textField_changeHandler);
			this.textField.addEventListener(FocusEvent.FOCUS_IN, textField_focusInHandler);
			this.textField.addEventListener(FocusEvent.FOCUS_OUT, textField_focusOutHandler);
			this.textField.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, textField_mouseFocusChangeHandler);
			this.textField.addEventListener(KeyboardEvent.KEY_DOWN, textField_keyDownHandler);
			this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING, textField_softKeyboardActivatingHandler);
			this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, textField_softKeyboardActivateHandler);
			this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, textField_softKeyboardDeactivateHandler);
			//when adding more events here, don't forget to remove them when the
			//text editor is disposed

			this.measureTextField = new TextField();
			this.measureTextField.autoSize = TextFieldAutoSize.LEFT;
			this.measureTextField.selectable = false;
			this.measureTextField.tabEnabled = false;
			this.measureTextField.mouseWheelEnabled = false;
			this.measureTextField.mouseEnabled = false;
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
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			if(dataInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshTextFormat();
				this.commitStylesAndData(this.textField);
			}
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
		protected function measure(result:Point = null):Point
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

			this.commitStylesAndData(this.measureTextField);

			var gutterDimensionsOffset:Number = 4;
			if(this._useGutter)
			{
				gutterDimensionsOffset = 0;
			}

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				this.measureTextField.wordWrap = false;
				newWidth = this.measureTextField.width - gutterDimensionsOffset;
				if(newWidth < this._explicitMinWidth)
				{
					newWidth = this._explicitMinWidth;
				}
				else if(newWidth > this._explicitMaxWidth)
				{
					newWidth = this._explicitMaxWidth;
				}
			}

			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				this.measureTextField.wordWrap = this._wordWrap;
				this.measureTextField.width = newWidth + gutterDimensionsOffset;
				newHeight = this.measureTextField.height - gutterDimensionsOffset;
				if(this._useGutter)
				{
					newHeight += 4;
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

			result.x = newWidth;
			result.y = newHeight;

			return result;
		}

		/**
		 * @private
		 */
		protected function commitStylesAndData(textField:TextField):void
		{
			textField.antiAliasType = this._antiAliasType;
			textField.background = this._background;
			textField.backgroundColor = this._backgroundColor;
			textField.border = this._border;
			textField.borderColor = this._borderColor;
			textField.gridFitType = this._gridFitType;
			textField.sharpness = this._sharpness;
			textField.thickness = this._thickness;
			textField.maxChars = this._maxChars;
			textField.restrict = this._restrict;
			textField.alwaysShowSelection = this._alwaysShowSelection;
			textField.displayAsPassword = this._displayAsPassword;
			textField.wordWrap = this._wordWrap;
			textField.multiline = this._multiline;
			if(!this._embedFonts &&
				this._currentTextFormat === this._fontStylesTextFormat)
			{
				//when font styles are passed in from the parent component, we
				//automatically determine if the TextField should use embedded
				//fonts, unless embedFonts is explicitly true
				this.textField.embedFonts = SystemUtil.isEmbeddedFont(
					this._currentTextFormat.font, this._currentTextFormat.bold,
					this._currentTextFormat.italic, FontType.EMBEDDED);
			}
			else
			{
				this.textField.embedFonts = this._embedFonts;
			}
			textField.type = this._isEditable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			textField.selectable = this._isEnabled && (this._isEditable || this._isSelectable);

			if(textField === this.textField)
			{
				//for some reason, textField.defaultTextFormat always fails
				//comparison against currentTextFormat. if we save to a member
				//variable and compare against that instead, it works.
				//I guess text field creates a different TextFormat object.
				var isFormatDifferent:Boolean = this._previousTextFormat != this._currentTextFormat;
				this._previousTextFormat = this._currentTextFormat;
			}
			textField.defaultTextFormat = this._currentTextFormat;

			if(this._isHTML)
			{
				if(isFormatDifferent || textField.htmlText != this._text)
				{
					if(textField == this.textField && this._pendingSelectionBeginIndex < 0)
					{
						//if the TextFormat has changed from the last commit,
						//the selection range may be lost when we set the text
						//so we need to save it to restore later. 
						this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
						this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
					}
					//the TextField's text should be updated after a TextFormat
					//change because otherwise it will keep using the old one.
					textField.htmlText = this._text;
				}
			}
			else
			{
				if(isFormatDifferent || textField.text != this._text)
				{
					if(textField == this.textField && this._pendingSelectionBeginIndex < 0)
					{
						this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
						this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
					}
					textField.text = this._text;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshTextFormat():void
		{
			var textFormat:flash.text.TextFormat;
			if(this._stateContext !== null)
			{
				if(this._textFormatForState !== null)
				{
					var currentState:String = this._stateContext.currentState;
					if(currentState in this._textFormatForState)
					{
						textFormat = flash.text.TextFormat(this._textFormatForState[currentState]);
					}
				}
				if(textFormat === null && this._disabledTextFormat !== null &&
					this._stateContext is IFeathersControl && !IFeathersControl(this._stateContext).isEnabled)
				{
					textFormat = this._disabledTextFormat;
				}
			}
			else //no state context
			{
				//we can still check if the text renderer is disabled to see if
				//we should use disabledTextFormat
				if(!this._isEnabled && this._disabledTextFormat !== null)
				{
					textFormat = this._disabledTextFormat;
				}
			}
			if(textFormat === null)
			{
				textFormat = this._textFormat;
			}
			//flash.text.TextFormat is considered more advanced, so it gets
			//precedence over starling.text.TextFormat font styles
			if(textFormat === null)
			{
				textFormat = this.getTextFormatFromFontStyles();
			}
			this._currentTextFormat = textFormat;
		}

		/**
		 * @private
		 */
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
			var textFieldTextHeight:Number = this.textField.textHeight;
			if(textFieldTextHeight > this.actualHeight)
			{
				return 0;
			}
			if(verticalAlign === Align.BOTTOM)
			{
				return this.actualHeight - textFieldTextHeight;
			}
			else if(verticalAlign === Align.CENTER)
			{
				return (this.actualHeight - textFieldTextHeight) / 2;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected function layout(sizeInvalid:Boolean):void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

			if(sizeInvalid)
			{
				this.refreshSnapshotParameters();
				this.refreshTextFieldSize();
				this.transformTextField();
				this.positionSnapshot();
			}

			this.checkIfNewSnapshotIsNeeded();

			if(!this._textFieldHasFocus && (sizeInvalid || stylesInvalid || dataInvalid || stateInvalid || this._needsNewTexture))
			{
				if(this._useSnapshotDelayWorkaround)
				{
					//sometimes, we need to wait a frame for flash.text.TextField
					//to render properly when drawing to BitmapData.
					this.addEventListener(Event.ENTER_FRAME, refreshSnapshot_enterFrameHandler);
				}
				else
				{
					this.refreshSnapshot();
				}
			}
			this.doPendingActions();
		}

		/**
		 * @private
		 */
		protected function getSelectionIndexAtPoint(pointX:Number, pointY:Number):int
		{
			return this.textField.getCharIndexAtPoint(pointX, pointY);
		}

		/**
		 * @private
		 */
		protected function refreshTextFieldSize():void
		{
			var gutterDimensionsOffset:Number = 4;
			if(this._useGutter)
			{
				gutterDimensionsOffset = 0;
			}
			this.textField.width = this.actualWidth + gutterDimensionsOffset;
			this.textField.height = this.actualHeight + gutterDimensionsOffset;
		}

		/**
		 * @private
		 */
		protected function refreshSnapshotParameters():void
		{
			this._textFieldOffsetX = 0;
			this._textFieldOffsetY = 0;
			this._textFieldSnapshotClipRect.x = 0;
			this._textFieldSnapshotClipRect.y = 0;

			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var scaleFactor:Number = starling.contentScaleFactor;
			var clipWidth:Number = this.actualWidth * scaleFactor;
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
			var clipHeight:Number = this.actualHeight * scaleFactor;
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
		protected function transformTextField():void
		{
			//there used to be some code here that returned immediately if the
			//TextField wasn't visible. some mobile devices displayed the text
			//at the wrong scale if the TextField weren't transformed before
			//being made visible, so I had to remove it. I moved the visible
			//check into render(), since it can still benefit from the
			//optimization there. see issue #1104.

			var matrix:Matrix = Pool.getMatrix();
			var point:Point = Pool.getPoint();
			this.getTransformationMatrix(this.stage, matrix);
			var globalScaleX:Number = matrixToScaleX(matrix);
			var globalScaleY:Number = matrixToScaleY(matrix);
			var smallerGlobalScale:Number = globalScaleX;
			if(globalScaleY < smallerGlobalScale)
			{
				smallerGlobalScale = globalScaleY;
			}
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			var scaleFactor:Number = starling.contentScaleFactor / nativeScaleFactor;
			var gutterPositionOffset:Number = 0;
			if(!this._useGutter)
			{
				gutterPositionOffset = 2 * smallerGlobalScale;
			}
			var verticalAlignOffsetY:Number = this.getVerticalAlignmentOffsetY();
			if(this.is3D)
			{
				var matrix3D:Matrix3D = Pool.getMatrix3D();
				var point3D:Vector3D = Pool.getPoint3D();
				this.getTransformationMatrix3D(this.stage, matrix3D);
				MatrixUtil.transformCoords3D(matrix3D, -gutterPositionOffset, -gutterPositionOffset + verticalAlignOffsetY, 0, point3D);
				point.setTo(point3D.x, point3D.y);
				Pool.putPoint3D(point3D);
				Pool.putMatrix3D(matrix3D);
			}
			else
			{
				MatrixUtil.transformCoords(matrix, -gutterPositionOffset, -gutterPositionOffset + verticalAlignOffsetY, point);
			}
			var starlingViewPort:Rectangle = starling.viewPort;
			this.textField.x = Math.round(starlingViewPort.x + (point.x * scaleFactor));
			this.textField.y = Math.round(starlingViewPort.y + (point.y * scaleFactor));
			this.textField.rotation = matrixToRotation(matrix) * 180 / Math.PI;
			this.textField.scaleX = matrixToScaleX(matrix) * scaleFactor;
			this.textField.scaleY = matrixToScaleY(matrix) * scaleFactor;

			Pool.putPoint(point);
			Pool.putMatrix(matrix);
		}

		/**
		 * @private
		 */
		protected function positionSnapshot():void
		{
			if(!this.textSnapshot)
			{
				return;
			}
			var matrix:Matrix = Pool.getMatrix();
			this.getTransformationMatrix(this.stage, matrix);
			this.textSnapshot.x = Math.round(matrix.tx) - matrix.tx;
			this.textSnapshot.y = Math.round(matrix.ty) - matrix.ty;
			this.textSnapshot.y += this.getVerticalAlignmentOffsetY();
			Pool.putMatrix(matrix);
		}

		/**
		 * @private
		 */
		protected function checkIfNewSnapshotIsNeeded():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var canUseRectangleTexture:Boolean = starling.profile !== Context3DProfile.BASELINE_CONSTRAINED;
			if(canUseRectangleTexture)
			{
				this._snapshotWidth = this._textFieldSnapshotClipRect.width;
				this._snapshotHeight = this._textFieldSnapshotClipRect.height;
			}
			else
			{
				this._snapshotWidth = MathUtil.getNextPowerOfTwo(this._textFieldSnapshotClipRect.width);
				this._snapshotHeight = MathUtil.getNextPowerOfTwo(this._textFieldSnapshotClipRect.height);
			}
			var textureRoot:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
			this._needsNewTexture = this._needsNewTexture || !this.textSnapshot ||
				(textureRoot !== null && (textureRoot.scale !== starling.contentScaleFactor ||
				this._snapshotWidth !== textureRoot.nativeWidth || this._snapshotHeight !== textureRoot.nativeHeight));
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
				var endIndex:int = this._pendingSelectionEndIndex;
				this._pendingSelectionBeginIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.selectRange(startIndex, endIndex);
			}
		}

		/**
		 * @private
		 */
		protected function texture_onRestore():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(this.textSnapshot && this.textSnapshot.texture &&
				this.textSnapshot.texture.scale != starling.contentScaleFactor)
			{
				//if we've changed between scale factors, we need to recreate
				//the texture to match the new scale factor.
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			else
			{
				this.refreshSnapshot();
			}
		}

		/**
		 * @private
		 */
		protected function refreshSnapshot():void
		{
			if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
			{
				return;
			}
			var gutterPositionOffset:Number = 2;
			if(this._useGutter)
			{
				gutterPositionOffset = 0;
			}
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var scaleFactor:Number = starling.contentScaleFactor;
			var matrix:Matrix = Pool.getMatrix();
			if(this._updateSnapshotOnScaleChange)
			{
				this.getTransformationMatrix(this.stage, matrix);
				var globalScaleX:Number = matrixToScaleX(matrix);
				var globalScaleY:Number = matrixToScaleY(matrix);
			}
			matrix.identity();
			matrix.translate(this._textFieldOffsetX - gutterPositionOffset, this._textFieldOffsetY - gutterPositionOffset);
			matrix.scale(scaleFactor, scaleFactor);
			if(this._updateSnapshotOnScaleChange)
			{
				matrix.scale(globalScaleX, globalScaleY);
			}
			var bitmapData:BitmapData = new BitmapData(this._snapshotWidth, this._snapshotHeight, true, 0x00ff00ff);
			bitmapData.draw(this.textField, matrix, null, null, this._textFieldSnapshotClipRect);
			Pool.putMatrix(matrix);
			var newTexture:Texture;
			if(!this.textSnapshot || this._needsNewTexture)
			{
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
			if(this._updateSnapshotOnScaleChange)
			{
				this.textSnapshot.scaleX = 1 / globalScaleX;
				this.textSnapshot.scaleY = 1 / globalScaleY;
				this._lastGlobalScaleX = globalScaleX;
				this._lastGlobalScaleY = globalScaleY;
			}
			this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
			bitmapData.dispose();
			this._needsNewTexture = false;
		}

		/**
		 * @private
		 */
		protected function textEditor_addedToStageHandler(event:Event):void
		{
			if(this.textField.parent === null)
			{
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				//the text field needs to be on the native stage to measure properly
				starling.nativeStage.addChild(this.textField);
			}
		}

		/**
		 * @private
		 */
		protected function textEditor_removedFromStageHandler(event:Event):void
		{
			if(this.textField.parent)
			{
				//remove this from the stage, if needed
				//it will be added back next time we receive focus
				this.textField.parent.removeChild(this.textField);
			}
		}

		/**
		 * @private
		 */
		protected function hasFocus_enterFrameHandler(event:Event):void
		{
			if(this.textSnapshot)
			{
				this.textSnapshot.visible = !this._textFieldHasFocus;
			}
			this.textField.visible = this._textFieldHasFocus;

			if(this._textFieldHasFocus)
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
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, hasFocus_enterFrameHandler);
			}
		}

		/**
		 * @private
		 */
		protected function refreshSnapshot_enterFrameHandler(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, refreshSnapshot_enterFrameHandler);
			this.refreshSnapshot();
		}

		/**
		 * @private
		 */
		protected function stage_touchHandler(event:TouchEvent):void
		{
			if(this._maintainTouchFocus)
			{
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
		protected function textField_changeHandler(event:flash.events.Event):void
		{
			if(this._isHTML)
			{
				this.text = this.textField.htmlText;
			}
			else
			{
				this.text = this.textField.text;
			}
		}

		/**
		 * @private
		 */
		protected function textField_focusInHandler(event:FocusEvent):void
		{
			this._textFieldHasFocus = true;
			this.stage.addEventListener(TouchEvent.TOUCH, stage_touchHandler);
			this.addEventListener(Event.ENTER_FRAME, hasFocus_enterFrameHandler);
			this.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}

		/**
		 * @private
		 */
		protected function textField_focusOutHandler(event:FocusEvent):void
		{
			this._textFieldHasFocus = false;
			this.stage.removeEventListener(TouchEvent.TOUCH, stage_touchHandler);

			if(this.resetScrollOnFocusOut)
			{
				this.textField.scrollH = this.textField.scrollV = 0;
			}

			//the text may have changed, so we invalidate the data flag
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}

		/**
		 * @private
		 */
		protected function textField_mouseFocusChangeHandler(event:FocusEvent):void
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
		protected function textField_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ENTER)
			{
				this.dispatchEventWith(FeathersEventType.ENTER);
			}
			else if(!FocusManager.isEnabledForStage(this.stage) && event.keyCode == Keyboard.TAB)
			{
				this.clearFocus();
			}
		}

		/**
		 * @private
		 */
		protected function textField_softKeyboardActivateHandler(event:SoftKeyboardEvent):void
		{
			this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATE, true);
		}

		/**
		 * @private
		 */
		protected function textField_softKeyboardActivatingHandler(event:SoftKeyboardEvent):void
		{
			this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATING, true);
		}

		/**
		 * @private
		 */
		protected function textField_softKeyboardDeactivateHandler(event:SoftKeyboardEvent):void
		{
			this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_DEACTIVATE, true);
		}
	}
}
