/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.core.FeathersControl;
	import feathers.core.IAdvancedNativeFocusOwner;
	import feathers.core.IFeathersControl;
	import feathers.core.IMeasureDisplayObject;
	import feathers.core.INativeFocusOwner;
	import feathers.core.IStateContext;
	import feathers.core.IStateObserver;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.text.FontStylesSet;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextFormat;
	import starling.utils.Pool;

	/**
	 * A display object displayed behind the text area's content when it
	 * is disabled.
	 *
	 * <p>In the following example, the text area's disabled background skin
	 * is specified:</p>
	 *
	 * <listing version="3.0">
	 * textArea.isEnabled = false;
	 * textArea.backgroundDisabledSkin = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>TextInputState.DISABLED</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * textArea.setSkinForState( TextInputState.DISABLED, skin );</listing>
	 *
	 * @default null
	 * 
	 * @see #style:backgroundSkin
	 * @see #setSkinForState()
	 */
	[Style(name="backgroundDisabledSkin",type="starling.display.DisplayObject")]

	/**
	 * A display object displayed behind the text area's content when it
	 * has focus.
	 *
	 * <p>In the following example, the text area's focused background skin is
	 * specified:</p>
	 *
	 * <listing version="3.0">
	 * textArea.backgroundFocusedSkin = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>TextInputState.FOCUSED</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * textArea.setSkinForState( TextInputState.FOCUSED, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundSkin
	 * @see #setSkinForState()
	 */
	[Style(name="backgroundFocusedSkin",type="starling.display.DisplayObject")]

	/**
	 * The skin used for the text area's error state. If <code>null</code>,
	 * then <code>backgroundSkin</code> is used instead.
	 *
	 * <p>The following example gives the text area a skin for the error state:</p>
	 *
	 * <listing version="3.0">
	 * textArea.backgroundErrorSkin = new Image( texture );</listing>
	 *
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>TextInputState.ERROR</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * textArea.setSkinForState( TextInputState.ERROR, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:backgroundSkin
	 * @see #setSkinForState()
	 */
	[Style(name="backgroundErrorSkin",type="starling.display.DisplayObject")]

	/**
	 * A style name to add to the text area's error callout sub-component.
	 * Typically used by a theme to provide different styles to different
	 * text areas.
	 *
	 * <p>In the following example, a custom error callout style name
	 * is passed to the text area:</p>
	 *
	 * <listing version="3.0">
	 * textArea.customErrorCalloutStyleName = "my-custom-text-area-error-callout";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( Callout ).setFunctionForStyleName( "my-custom-text-area-error-callout", setCustomTextAreaErrorCalloutStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT
	 * @see feathers.core.FeathersControl#styleNameList
	 */
	[Style(name="customErrorCalloutStyleName",type="String")]

	/**
	 * A style name to add to the text area's prompt text renderer
	 * sub-component. Typically used by a theme to provide different styles
	 * to different text inputs.
	 *
	 * <p>In the following example, a custom prompt text renderer style name
	 * is passed to the text area:</p>
	 *
	 * <listing version="3.0">
	 * textArea.customPromptStyleName = "my-custom-text-area-prompt";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( BitmapFontTextRenderer ).setFunctionForStyleName( "my-custom-text-area-prompt", setCustomTextAreaPromptStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_PROMPT
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #promptFactory
	 */
	[Style(name="customPromptStyleName",type="String")]

	/**
	 * A style name to add to the text area's text editor sub-component.
	 * Typically used by a theme to provide different styles to different
	 * text areas.
	 *
	 * <p>In the following example, a custom text editor style name is
	 * passed to the text area:</p>
	 *
	 * <listing version="3.0">
	 * textArea.customTextEditorStyleName = "my-custom-text-area-text-editor";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( TextFieldTextEditorViewPort ).setFunctionForStyleName( "my-custom-text-area-text-editor", setCustomTextAreaTextEditorStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #textEditorFactory
	 */
	[Style(name="customTextEditorStyleName",type="String")]

	/**
	 * The font styles used to display the text area's text when the text
	 * area is disabled.
	 *
	 * <p>In the following example, the disabled font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * textArea.disabledFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Alternatively, you may use <code>setFontStylesForState()</code> with
	 * <code>TextInputState.DISABLED</code> to set the same font styles:</p>
	 *
	 * <listing version="3.0">
	 * var fontStyles:TextFormat = new TextFormat( "Helvetica", 20, 0x999999 );
	 * textArea.setFontStylesForState( TextInputState.DISABLED, fontStyles );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text editor being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>textEditorFactory</code> to set more advanced styles on the
	 * text editor.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:fontStyles
	 * @see #setFontStylesForState()
	 */
	[Style(name="disabledFontStyles",type="starling.text.TextFormat")]

	/**
	 * The font styles used to display the text area's text.
	 *
	 * <p>In the following example, the font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * textArea.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text editor being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>textEditorFactory</code> to set more advanced styles on the
	 * text editor.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:disabledFontStyles
	 * @see #setFontStylesForState()
	 */
	[Style(name="fontStyles",type="starling.text.TextFormat")]

	/**
	 * Quickly sets all inner padding properties to the same value. The
	 * <code>innerPadding</code> getter always returns the value of
	 * <code>innerPaddingTop</code>, but the other innert padding values may be
	 * different.
	 *
	 * <p>The following example gives the button 20 pixels of padding on all
	 * sides:</p>
	 *
	 * <listing version="3.0">
	 * textArea.innerPadding = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:innerPaddingTop
	 * @see #style:innerPaddingRight
	 * @see #style:innerPaddingBottom
	 * @see #style:innerPaddingLeft
	 */
	[Style(name="innerPadding",type="Number")]

	/**
	 * The minimum space, in pixels, between the text area's top edge and the
	 * text area's content.
	 *
	 * <p>The following example gives the text area 20 pixels of inner padding
	 * on the top edge only:</p>
	 *
	 * <listing version="3.0">
	 * textArea.innerPaddingTop = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:innerPadding
	 */
	[Style(name="innerPaddingTop",type="Number")]

	/**
	 * The minimum space, in pixels, between the text area's right edge and the
	 * text area's content.
	 *
	 * <p>The following example gives the text area 20 pixels of inner padding
	 * on the right edge only:</p>
	 *
	 * <listing version="3.0">
	 * textArea.innerPaddingRight = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:innerPadding
	 */
	[Style(name="innerPaddingRight",type="Number")]

	/**
	 * The minimum space, in pixels, between the text area's bottom edge and the
	 * text area's content.
	 *
	 * <p>The following example gives the text area 20 pixels of inner padding
	 * on the bottom edge only:</p>
	 *
	 * <listing version="3.0">
	 * textArea.innerPaddingBottom = 20;</listing>
	 *
	 * @default 0
	 * 
	 * @see #style:innerPadding
	 */
	[Style(name="innerPaddingBottom",type="Number")]

	/**
	 * The minimum space, in pixels, between the text area's left edge and the
	 * text area's content.
	 *
	 * <p>The following example gives the text area 20 pixels of inner padding
	 * on the left edge only:</p>
	 *
	 * <listing version="3.0">
	 * textArea.innerPaddingLeft = 20;</listing>
	 *
	 * @default 0
	 *
	 * @see #style:innerPadding
	 */
	[Style(name="innerPaddingLeft",type="Number")]

	/**
	 * The font styles used to display the text area's prompt when the text area
	 * is disabled.
	 *
	 * <p>In the following example, the disabled font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * textArea.promptDisabledFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>promptFactory</code> to set more advanced styles on the
	 * text renderer.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:promptFontStyles
	 * @see #setPromptFontStylesForState()
	 */
	[Style(name="promptDisabledFontStyles",type="starling.text.TextFormat")]

	/**
	 * The font styles used to display the text area's prompt text.
	 *
	 * <p>In the following example, the font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * textArea.promptFontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>promptFactory</code> to set more advanced styles on the
	 * text renderer.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:promptDisabledFontStyles
	 * @see #setPromptFontStylesForState()
	 */
	[Style(name="promptFontStyles",type="starling.text.TextFormat")]

	/**
	 * Dispatched when the text area's <code>text</code> property changes.
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
	 * Dispatched when the display object's state changes.
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
	 * @eventType feathers.events.FeathersEventType.STATE_CHANGE
	 *
	 * @see #currentState
	 */
	[Event(name="stateChange",type="starling.events.Event")]

	/**
	 * A text entry control that allows users to enter and edit multiple lines
	 * of uniformly-formatted text with the ability to scroll.
	 *
	 * <p>The following example sets the text in a text area, selects the text,
	 * and listens for when the text value changes:</p>
	 *
	 * <listing version="3.0">
	 * var textArea:TextArea = new TextArea();
	 * textArea.text = "Hello\nWorld"; //it's multiline!
	 * textArea.selectRange( 0, textArea.text.length );
	 * textArea.addEventListener( Event.CHANGE, textArea_changeHandler );
	 * this.addChild( textArea );</listing>
	 *
	 * @see ../../../help/text-area.html How to use the Feathers TextArea component
	 * @see feathers.controls.TextInput
	 *
	 * @productversion Feathers 1.1.0
	 */
	public class TextArea extends Scroller implements IAdvancedNativeFocusOwner, IStateContext
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the text
		 * editor.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR:String = "feathers-text-area-text-editor";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * prompt text renderer.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_PROMPT:String = "feathers-text-input-prompt";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * error callout.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT:String = "feathers-text-area-error-callout";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY:String = "errorCalloutFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_PROMPT_FACTORY:String = "promptFactory";

		/**
		 * The default <code>IStyleProvider</code> for all <code>TextArea</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function TextArea()
		{
			super();
			if(this._fontStylesSet === null)
			{
				this._fontStylesSet = new FontStylesSet();
				this._fontStylesSet.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			if(this._promptFontStylesSet === null)
			{
				this._promptFontStylesSet = new FontStylesSet();
				this._promptFontStylesSet.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this._measureViewPort = false;
			this.addEventListener(TouchEvent.TOUCH, textArea_touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, textArea_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		protected var textEditorViewPort:ITextEditorViewPort;

		/**
		 * The <code>TextCallout</code> that displays the value of the
		 * <code>errorString</code> property. The value may be <code>null</code>
		 * if there is no current error string or if the text area doesn't have
		 * focus.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var callout:TextCallout;

		/**
		 * The prompt text renderer sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var promptTextRenderer:ITextRenderer;

		/**
		 * The value added to the <code>styleNameList</code> of the text editor.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the text editor style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR</code>.
		 *
		 * <p>To customize the text editor style name without subclassing, see
		 * <code>customTextEditorStyleName</code>.</p>
		 *
		 * @see #style:customTextEditorStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var textEditorStyleName:String = DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR;

		/**
		 * The value added to the <code>styleNameList</code> of the prompt text
		 * renderer. This variable is <code>protected</code> so that sub-classes
		 * can customize the prompt text renderer style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_PROMPT</code>.
		 *
		 * <p>To customize the prompt text renderer style name without
		 * subclassing, see <code>customPromptStyleName</code>.</p>
		 *
		 * @see #style:customPromptStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var promptStyleName:String = DEFAULT_CHILD_STYLE_NAME_PROMPT;

		/**
		 * The value added to the <code>styleNameList</code> of the error
		 * callout. This variable is <code>protected</code> so that sub-classes
		 * can customize the error callout text renderer style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT</code>.
		 *
		 * <p>To customize the error callout style name without subclassing, see
		 * <code>customErrorCalloutStyleName</code>.</p>
		 *
		 * @see #style:customErrorCalloutStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var errorCalloutStyleName:String = DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT;

		/**
		 * @private
		 */
		protected var _textEditorHasFocus:Boolean = false;

		/**
		 * A text editor may be an <code>INativeFocusOwner</code>, so we need to
		 * return the value of its <code>nativeFocus</code> property. If not,
		 * then we return <code>null</code>.
		 *
		 * @see feathers.core.INativeFocusOwner
		 */
		public function get nativeFocus():Object
		{
			if(this.textEditorViewPort is INativeFocusOwner)
			{
				return INativeFocusOwner(this.textEditorViewPort).nativeFocus;
			}
			return null;
		}

		/**
		 * @private
		 */
		protected var _isWaitingToSetFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _pendingSelectionBeginIndex:int = -1;

		/**
		 * @private
		 */
		protected var _pendingSelectionEndIndex:int = -1;

		/**
		 * @private
		 */
		protected var _textAreaTouchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _oldMouseCursor:String = null;

		/**
		 * @private
		 */
		protected var _ignoreTextChanges:Boolean = false;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return TextArea.globalStyleProvider;
		}

		/**
		 * @private
		 */
		override public function get isFocusEnabled():Boolean
		{
			if(this._isEditable)
			{
				//the behavior is different when editable.
				return this._isEnabled && this._isFocusEnabled;
			}
			return super.isFocusEnabled;
		}

		/**
		 * When the <code>FocusManager</code> isn't enabled, <code>hasFocus</code>
		 * can be used instead of <code>FocusManager.focus == textArea</code>
		 * to determine if the text area has focus.
		 */
		public function get hasFocus():Boolean
		{
			if(!this._focusManager)
			{
				return this._textEditorHasFocus;
			}
			return this._hasFocus;
		}

		/**
		 * @private
		 */
		override public function set isEnabled(value:Boolean):void
		{
			super.isEnabled = value;
			this.refreshState();
		}

		/**
		 * @private
		 */
		protected var _currentState:String = TextInputState.ENABLED;

		/**
		 * The current state of the text area.
		 *
		 * @see feathers.controls.TextInputState
		 * @see #event:stateChange feathers.events.FeathersEventType.STATE_CHANGE
		 */
		public function get currentState():String
		{
			return this._currentState;
		}

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * The text displayed by the text area. The text area dispatches
		 * <code>Event.CHANGE</code> when the value of the <code>text</code>
		 * property changes for any reason.
		 *
		 * <p>In the following example, the text area's text is updated:</p>
		 *
		 * <listing version="3.0">
		 * textArea.text = "Hello World";</listing>
		 *
		 * @see #event:change
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
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _prompt:String = null;

		/**
		 * The prompt, hint, or description text displayed by the text area when
		 * the value of its text is empty.
		 *
		 * <p>In the following example, the text area's prompt is updated:</p>
		 *
		 * <listing version="3.0">
		 * textArea.prompt = "User Name";</listing>
		 *
		 * @default null
		 */
		public function get prompt():String
		{
			return this._prompt;
		}

		/**
		 * @private
		 */
		public function set prompt(value:String):void
		{
			if(this._prompt == value)
			{
				return;
			}
			this._prompt = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _maxChars:int = 0;

		/**
		 * The maximum number of characters that may be entered.
		 *
		 * <p>In the following example, the text area's maximum characters is
		 * specified:</p>
		 *
		 * <listing version="3.0">
		 * textArea.maxChars = 10;</listing>
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
		 * Limits the set of characters that may be entered.
		 *
		 * <p>In the following example, the text area's allowed characters are
		 * restricted:</p>
		 *
		 * <listing version="3.0">
		 * textArea.restrict = "0-9;</listing>
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
		protected var _isEditable:Boolean = true;

		/**
		 * Determines if the text area is editable. If the text area is not
		 * editable, it will still appear enabled.
		 *
		 * <p>In the following example, the text area is not editable:</p>
		 *
		 * <listing version="3.0">
		 * textArea.isEditable = false;</listing>
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
		 * @private
		 */
		protected var _errorString:String = null;

		/**
		 * Error text to display in a <code>Callout</code> when the text area
		 * has focus. When this value is not <code>null</code> the text area's
		 * state is changed to <code>TextInputState.ERROR</code>.
		 *
		 * An empty string will change the background, but no
		 * <code>Callout</code> will appear on focus.
		 *
		 * To clear an error, the <code>errorString</code> property must be set
		 * to <code>null</code>
		 *
		 * <p>The following example displays an error string:</p>
		 *
		 * <listing version="3.0">
		 * textArea.errorString = "Something is wrong";</listing>
		 *
		 * @default null
		 *
		 * @see #currentState
		 */
		public function get errorString():String
		{
			return this._errorString;
		}

		/**
		 * @private
		 */
		public function set errorString(value:String):void
		{
			if(this._errorString === value)
			{
				return;
			}
			this._errorString = value;
			this.refreshState();
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToSkin:Object = {};

		/**
		 * @private
		 */
		override public function get backgroundDisabledSkin():DisplayObject
		{
			return this.getSkinForState(TextInputState.DISABLED);
		}

		/**
		 * @private
		 */
		override public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			this.setSkinForState(TextInputState.DISABLED, value);
		}

		/**
		 * @private
		 */
		public function get backgroundFocusedSkin():DisplayObject
		{
			return this.getSkinForState(TextInputState.FOCUSED);
		}

		/**
		 * @private
		 */
		public function set backgroundFocusedSkin(value:DisplayObject):void
		{
			this.setSkinForState(TextInputState.FOCUSED, value);
		}

		/**
		 * @private
		 */
		public function get backgroundErrorSkin():DisplayObject
		{
			return this.getSkinForState(TextInputState.ERROR);
		}

		/**
		 * @private
		 */
		public function set backgroundErrorSkin(value:DisplayObject):void
		{
			this.setSkinForState(TextInputState.ERROR, value);
		}

		/**
		 * @private
		 */
		protected var _fontStylesSet:FontStylesSet;

		/**
		 * @private
		 */
		public function get fontStyles():TextFormat
		{
			return this._fontStylesSet.format;
		}

		/**
		 * @private
		 */
		public function set fontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			if(value !== null)
			{
				value.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.format = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		public function get disabledFontStyles():TextFormat
		{
			return this._fontStylesSet.disabledFormat;
		}

		/**
		 * @private
		 */
		public function set disabledFontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			if(value !== null)
			{
				value.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.disabledFormat = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _textEditorFactory:Function;

		/**
		 * A function used to instantiate the text editor view port. If
		 * <code>null</code>, a <code>TextFieldTextEditorViewPort</code> will
		 * be instantiated. The text editor must be an instance of
		 * <code>ITextEditorViewPort</code>. This factory can be used to change
		 * properties on the text editor view port when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set styles on the text editor view
		 * port.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextEditorViewPort</pre>
		 *
		 * <p>In the following example, a custom text editor factory is passed
		 * to the text area:</p>
		 *
		 * <listing version="3.0">
		 * textArea.textEditorFactory = function():ITextEditorViewPort
		 * {
		 *     return new TextFieldTextEditorViewPort();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.text.ITextEditorViewPort
		 */
		public function get textEditorFactory():Function
		{
			return this._textEditorFactory;
		}

		/**
		 * @private
		 */
		public function set textEditorFactory(value:Function):void
		{
			if(this._textEditorFactory == value)
			{
				return;
			}
			this._textEditorFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_EDITOR);
		}

		/**
		 * @private
		 */
		protected var _customTextEditorStyleName:String;

		/**
		 * @private
		 */
		public function get customTextEditorStyleName():String
		{
			return this._customTextEditorStyleName;
		}

		/**
		 * @private
		 */
		public function set customTextEditorStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customTextEditorStyleName === value)
			{
				return;
			}
			this._customTextEditorStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _textEditorProperties:PropertyProxy;

		/**
		 * An object that stores properties for the text area's text editor
		 * sub-component, and the properties will be passed down to the
		 * text editor when the text area validates. The available properties
		 * depend on which <code>ITextEditorViewPort</code> implementation is
		 * returned by <code>textEditorFactory</code>. Refer to
		 * <a href="text/ITextEditorViewPort.html"><code>feathers.controls.text.ITextEditorViewPort</code></a>
		 * for a list of available text editor implementations for text area.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>textEditorFactory</code> function
		 * instead of using <code>textEditorProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the text input's text editor properties
		 * are specified (this example assumes that the text editor is a
		 * <code>TextFieldTextEditorViewPort</code>):</p>
		 *
		 * <listing version="3.0">
		 * textArea.textEditorProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333);
		 * textArea.textEditorProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #textEditorFactory
		 * @see feathers.controls.text.ITextEditorViewPort
		 */
		public function get textEditorProperties():Object
		{
			if(!this._textEditorProperties)
			{
				this._textEditorProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._textEditorProperties;
		}

		/**
		 * @private
		 */
		public function set textEditorProperties(value:Object):void
		{
			if(this._textEditorProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				var newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._textEditorProperties)
			{
				this._textEditorProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._textEditorProperties = PropertyProxy(value);
			if(this._textEditorProperties)
			{
				this._textEditorProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _promptFontStylesSet:FontStylesSet;

		/**
		 * @private
		 */
		public function get promptFontStyles():TextFormat
		{
			return this._promptFontStylesSet.format;
		}

		/**
		 * @private
		 */
		public function set promptFontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			if(value !== null)
			{
				value.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._promptFontStylesSet.format = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		public function get promptDisabledFontStyles():TextFormat
		{
			return this._promptFontStylesSet.disabledFormat;
		}

		/**
		 * @private
		 */
		public function set promptDisabledFontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			if(value !== null)
			{
				value.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._promptFontStylesSet.disabledFormat = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _promptFactory:Function;

		/**
		 * A function used to instantiate the prompt text renderer. If null,
		 * <code>FeathersControl.defaultTextRendererFactory</code> is used
		 * instead. The prompt text renderer must be an instance of
		 * <code>ITextRenderer</code>. This factory can be used to change
		 * properties on the prompt when it is first created. For instance, if
		 * you are skinning Feathers components without a theme, you might use
		 * this factory to set styles on the prompt.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>If the <code>prompt</code> property is <code>null</code>, the
		 * prompt text renderer will not be created.</p>
		 *
		 * <p>In the following example, a custom prompt factory is passed to the
		 * text input:</p>
		 *
		 * <listing version="3.0">
		 * input.promptFactory = function():ITextRenderer
		 * {
		 *     return new TextFieldTextRenderer();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #prompt
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get promptFactory():Function
		{
			return this._promptFactory;
		}

		/**
		 * @private
		 */
		public function set promptFactory(value:Function):void
		{
			if(this._promptFactory == value)
			{
				return;
			}
			this._promptFactory = value;
			this.invalidate(INVALIDATION_FLAG_PROMPT_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customPromptStyleName:String;

		/**
		 * @private
		 */
		public function get customPromptStyleName():String
		{
			return this._customPromptStyleName;
		}

		/**
		 * @private
		 */
		public function set customPromptStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customPromptStyleName === value)
			{
				return;
			}
			this._customPromptStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _customErrorCalloutStyleName:String;

		/**
		 * @private
		 */
		public function get customErrorCalloutStyleName():String
		{
			return this._customErrorCalloutStyleName;
		}

		/**
		 * @private
		 */
		public function set customErrorCalloutStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customErrorCalloutStyleName === value)
			{
				return;
			}
			this._customErrorCalloutStyleName = value;
			this.invalidate(INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY);
		}

		/**
		 * @private
		 */
		public function get innerPadding():Number
		{
			return this._innerPaddingTop;
		}

		/**
		 * @private
		 */
		public function set innerPadding(value:Number):void
		{
			this.innerPaddingTop = value;
			this.innerPaddingRight = value;
			this.innerPaddingBottom = value;
			this.innerPaddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _innerPaddingTop:Number = 0;

		/**
		 * @private
		 */
		public function get innerPaddingTop():Number
		{
			return this._innerPaddingTop;
		}

		/**
		 * @private
		 */
		public function set innerPaddingTop(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._innerPaddingTop == value)
			{
				return;
			}
			this._innerPaddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _innerPaddingRight:Number = 0;

		/**
		 * @private
		 */
		public function get innerPaddingRight():Number
		{
			return this._innerPaddingRight;
		}

		/**
		 * @private
		 */
		public function set innerPaddingRight(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._innerPaddingRight == value)
			{
				return;
			}
			this._innerPaddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _innerPaddingBottom:Number = 0;

		/**
		 * @private
		 */
		[Deprecated(since="4.2.0",replacement="innerPaddingBottom")]
		public function get paddinnerPaddingBottomingBottom():Number
		{
			return this._innerPaddingBottom;
		}
		
		/**
		 * @private
		 */
		public function get innerPaddingBottom():Number
		{
			return this._innerPaddingBottom;
		}

		/**
		 * @private
		 */
		public function set innerPaddingBottom(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._innerPaddingBottom == value)
			{
				return;
			}
			this._innerPaddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _innerPaddingLeft:Number = 0;

		/**
		 * @private
		 */
		public function get innerPaddingLeft():Number
		{
			return this._innerPaddingLeft;
		}

		/**
		 * @private
		 */
		public function set innerPaddingLeft(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._innerPaddingLeft == value)
			{
				return;
			}
			this._innerPaddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @copy feathers.core.ITextEditor#selectionBeginIndex
		 */
		public function get selectionBeginIndex():int
		{
			if(this._pendingSelectionBeginIndex >= 0)
			{
				return this._pendingSelectionBeginIndex;
			}
			if(this.textEditorViewPort)
			{
				return this.textEditorViewPort.selectionBeginIndex;
			}
			return 0;
		}

		/**
		 * @copy feathers.core.ITextEditor#selectionEndIndex
		 */
		public function get selectionEndIndex():int
		{
			if(this._pendingSelectionEndIndex >= 0)
			{
				return this._pendingSelectionEndIndex;
			}
			if(this.textEditorViewPort)
			{
				return this.textEditorViewPort.selectionEndIndex;
			}
			return 0;
		}

		/**
		 * Focuses the text area control so that it may be edited.
		 */
		public function setFocus():void
		{
			if(this._textEditorHasFocus)
			{
				return;
			}
			if(this.textEditorViewPort)
			{
				this._isWaitingToSetFocus = false;
				this.textEditorViewPort.setFocus();
			}
			else
			{
				this._isWaitingToSetFocus = true;
				this.invalidate(INVALIDATION_FLAG_SELECTED);
			}
		}

		/**
		 * Manually removes focus from the text area control.
		 */
		public function clearFocus():void
		{
			this._isWaitingToSetFocus = false;
			if(!this.textEditorViewPort || !this._textEditorHasFocus)
			{
				return;
			}
			this.textEditorViewPort.clearFocus();
		}

		/**
		 * Sets the range of selected characters. If both values are the same,
		 * or the end index is <code>-1</code>, the text insertion position is
		 * changed and nothing is selected.
		 */
		public function selectRange(beginIndex:int, endIndex:int = -1):void
		{
			if(endIndex < 0)
			{
				endIndex = beginIndex;
			}
			if(beginIndex < 0)
			{
				throw new RangeError("Expected begin index greater than or equal to 0. Received " + beginIndex + ".");
			}
			if(endIndex > this._text.length)
			{
				throw new RangeError("Expected begin index less than " + this._text.length + ". Received " + endIndex + ".");
			}

			//if it's invalid, we need to wait until validation before changing
			//the selection
			if(this.textEditorViewPort !== null && (this._isValidating || !this.isInvalid()))
			{
				this._pendingSelectionBeginIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.textEditorViewPort.selectRange(beginIndex, endIndex);
			}
			else
			{
				this._pendingSelectionBeginIndex = beginIndex;
				this._pendingSelectionEndIndex = endIndex;
				this.invalidate(INVALIDATION_FLAG_SELECTED);
			}
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			//we don't dispose it if the text area is the parent because it'll
			//already get disposed in super.dispose()
			for(var state:String in this._stateToSkin)
			{
				var skin:DisplayObject = this._stateToSkin[state] as DisplayObject;
				if(skin !== null && skin.parent !== this)
				{
					skin.dispose();
				}
			}
			if(this._fontStylesSet !== null)
			{
				this._fontStylesSet.dispose();
				this._fontStylesSet = null;
			}
			if(this._promptFontStylesSet !== null)
			{
				this._promptFontStylesSet.dispose();
				this._promptFontStylesSet = null;
			}
			super.dispose();
		}

		/**
		 * Gets the font styles to be used to display the text area's text when
		 * the text area's <code>currentState</code> property matches the
		 * specified state value.
		 *
		 * <p>If font styles are not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #setFontStylesForState()
		 * @see #style:fontStyles
		 */
		public function getFontStylesForState(state:String):TextFormat
		{
			if(this._fontStylesSet === null)
			{
				return null;
			}
			return this._fontStylesSet.getFormatForState(state);
		}

		/**
		 * Sets the font styles to be used to display the text area's text when
		 * the text area's <code>currentState</code> property matches the
		 * specified state value.
		 *
		 * <p>If font styles are not defined for a specific state, the value of
		 * the <code>fontStyles</code> property will be used instead.</p>
		 *
		 * <p>Note: if the text editor has been customized with advanced font
		 * formatting, it may override the values specified with
		 * <code>setFontStylesForState()</code> and properties like
		 * <code>fontStyles</code> and <code>disabledFontStyles</code>.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #style:fontStyles
		 */
		public function setFontStylesForState(state:String, format:TextFormat):void
		{
			var key:String = "setFontStylesForState--" + state;
			if(this.processStyleRestriction(key))
			{
				return;
			}
			function changeHandler(event:Event):void
			{
				processStyleRestriction(key);
			}
			if(format !== null)
			{
				format.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.setFormatForState(state, format);
			if(format !== null)
			{
				format.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * Gets the font styles to be used to display the text area's prompt
		 * when the text area's <code>currentState</code> property matches the
		 * specified state value.
		 *
		 * <p>If prompt font styles are not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #setPromptFontStylesForState()
		 * @see #promptFontStyles
		 */
		public function getPromptFontStylesForState(state:String):TextFormat
		{
			if(this._promptFontStylesSet === null)
			{
				return null;
			}
			return this._promptFontStylesSet.getFormatForState(state);
		}

		/**
		 * Sets the font styles to be used to display the text area's prompt
		 * when the text area's <code>currentState</code> property matches the
		 * specified state value.
		 *
		 * <p>If prompt font styles are not defined for a specific state, the
		 * value of the <code>promptFontStyles</code> property will be used instead.</p>
		 *
		 * <p>Note: if the text renderer has been customized with advanced font
		 * formatting, it may override the values specified with
		 * <code>setPromptFontStylesForState()</code> and properties like
		 * <code>promptFontStyles</code> and <code>promptDisabledFontStyles</code>.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #promptFontStyles
		 */
		public function setPromptFontStylesForState(state:String, format:TextFormat):void
		{
			var key:String = "setPromptFontStylesForState--" + state;
			if(this.processStyleRestriction(key))
			{
				return;
			}
			function changeHandler(event:Event):void
			{
				processStyleRestriction(key);
			}
			if(format !== null)
			{
				format.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._promptFontStylesSet.setFormatForState(state, format);
			if(format !== null)
			{
				format.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * Gets the skin to be used by the text area when its
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a skin is not defined for a specific state, returns
		 * <code>null</code>.</p>
		 *
		 * @see #setSkinForState()
		 * @see feathers.controls.TextInputState
		 */
		public function getSkinForState(state:String):DisplayObject
		{
			return this._stateToSkin[state] as DisplayObject;
		}

		/**
		 * Sets the skin to be used by the text area when its
		 * <code>currentState</code> property matches the specified state value.
		 *
		 * <p>If a skin is not defined for a specific state, the value of the
		 * <code>backgroundSkin</code> property will be used instead.</p>
		 *
		 * @see #backgroundSkin
		 * @see #getSkinForState()
		 * @see feathers.controls.TextInputState
		 */
		public function setSkinForState(state:String, skin:DisplayObject):void
		{
			var key:String = "setSkinForState--" + state;
			if(this.processStyleRestriction(key))
			{
				if(skin !== null)
				{
					skin.dispose();
				}
				return;
			}
			if(skin !== null)
			{
				this._stateToSkin[state] = skin;
			}
			else
			{
				delete this._stateToSkin[state];
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var textEditorInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_EDITOR);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var promptFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_PROMPT_FACTORY);

			if(textEditorInvalid)
			{
				this.createTextEditor();
			}

			if(promptFactoryInvalid || (this._prompt !== null && !this.promptTextRenderer))
			{
				this.createPrompt();
			}

			if(textEditorInvalid || stylesInvalid)
			{
				this.refreshTextEditorProperties();
			}

			if(textEditorInvalid || dataInvalid)
			{
				var oldIgnoreTextChanges:Boolean = this._ignoreTextChanges;
				this._ignoreTextChanges = true;
				this.textEditorViewPort.text = this._text;
				this._ignoreTextChanges = oldIgnoreTextChanges;
			}

			if(promptFactoryInvalid || stylesInvalid)
			{
				this.refreshPromptProperties();
			}

			if(this.promptTextRenderer)
			{
				if(promptFactoryInvalid || dataInvalid || stylesInvalid)
				{
					this.promptTextRenderer.visible = this._prompt && this._text.length == 0;
				}

				if(promptFactoryInvalid || stateInvalid)
				{
					this.promptTextRenderer.isEnabled = this._isEnabled;
				}
			}

			if(textEditorInvalid || stateInvalid)
			{
				this.textEditorViewPort.isEnabled = this._isEnabled;
				if(!this._isEnabled && Mouse.supportsNativeCursor && this._oldMouseCursor)
				{
					Mouse.cursor = this._oldMouseCursor;
					this._oldMouseCursor = null;
				}
			}

			super.draw();

			//the state might not change if the text input has focus when
			//the error string changes, so check for styles too!
			if(stateInvalid || stylesInvalid)
			{
				this.refreshErrorCallout();
			}

			this.doPendingActions();
		}

		/**
		 * Creates and adds the <code>textEditorViewPort</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #textEditorViewPort
		 * @see #textEditorFactory
		 */
		protected function createTextEditor():void
		{
			if(this.textEditorViewPort)
			{
				this.textEditorViewPort.removeEventListener(Event.CHANGE, textEditor_changeHandler);
				this.textEditorViewPort.removeEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
				this.textEditorViewPort.removeEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
				this.textEditorViewPort = null;
			}

			if(this._textEditorFactory != null)
			{
				this.textEditorViewPort = ITextEditorViewPort(this._textEditorFactory());
			}
			else
			{
				this.textEditorViewPort = new TextFieldTextEditorViewPort();
			}
			var textEditorStyleName:String = this._customTextEditorStyleName != null ? this._customTextEditorStyleName : this.textEditorStyleName;
			this.textEditorViewPort.styleNameList.add(textEditorStyleName);
			if(this.textEditorViewPort is IStateObserver)
			{
				IStateObserver(this.textEditorViewPort).stateContext = this;
			}
			this.textEditorViewPort.addEventListener(Event.CHANGE, textEditor_changeHandler);
			this.textEditorViewPort.addEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
			this.textEditorViewPort.addEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);

			var oldViewPort:ITextEditorViewPort = ITextEditorViewPort(this._viewPort);
			this.viewPort = this.textEditorViewPort;
			if(oldViewPort)
			{
				//the view port setter won't do this
				oldViewPort.dispose();
			}
		}

		/**
		 * @private
		 */
		protected function createPrompt():void
		{
			if(this.promptTextRenderer)
			{
				this.removeChild(DisplayObject(this.promptTextRenderer), true);
				this.promptTextRenderer = null;
			}

			if(this._prompt === null)
			{
				return;
			}

			var factory:Function = this._promptFactory != null ? this._promptFactory : FeathersControl.defaultTextRendererFactory;
			this.promptTextRenderer = ITextRenderer(factory());
			var promptStyleName:String = this._customPromptStyleName != null ? this._customPromptStyleName : this.promptStyleName;
			this.promptTextRenderer.styleNameList.add(promptStyleName);
			this.addChild(DisplayObject(this.promptTextRenderer));
		}

		/**
		 * @private
		 */
		protected function createErrorCallout():void
		{
			if(this.callout !== null)
			{
				this.callout.removeFromParent(true);
				this.callout = null;
			}

			if(this._errorString === null)
			{
				return;
			}
			this.callout = new TextCallout();
			var errorCalloutStyleName:String = this._customErrorCalloutStyleName != null ? this._customErrorCalloutStyleName : this.errorCalloutStyleName;
			this.callout.styleNameList.add(errorCalloutStyleName);
			this.callout.closeOnKeys = null;
			this.callout.closeOnTouchBeganOutside = false;
			this.callout.closeOnTouchEndedOutside = false;
			this.callout.touchable = false;
			this.callout.origin = this;
			PopUpManager.addPopUp(this.callout, false, false);
		}

		/**
		 * @private
		 */
		protected function changeState(state:String):void
		{
			if(this._currentState === state)
			{
				return;
			}
			this._currentState = state;
			this.invalidate(INVALIDATION_FLAG_STATE);
			this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
		}

		/**
		 * @private
		 */
		protected function doPendingActions():void
		{
			if(this._isWaitingToSetFocus || (this._focusManager && this._focusManager.focus == this))
			{
				this._isWaitingToSetFocus = false;
				if(!this._textEditorHasFocus)
				{
					this.textEditorViewPort.setFocus();
				}
			}
			if(this._pendingSelectionBeginIndex >= 0)
			{
				var beginIndex:int = this._pendingSelectionBeginIndex;
				var endIndex:int = this._pendingSelectionEndIndex;
				this._pendingSelectionBeginIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.selectRange(beginIndex, endIndex);
			}
		}

		/**
		 * @private
		 */
		protected function refreshTextEditorProperties():void
		{
			this.textEditorViewPort.fontStyles = this._fontStylesSet;
			this.textEditorViewPort.maxChars = this._maxChars;
			this.textEditorViewPort.restrict = this._restrict;
			this.textEditorViewPort.isEditable = this._isEditable;
			this.textEditorViewPort.paddingTop = this._innerPaddingTop;
			this.textEditorViewPort.paddingRight = this._innerPaddingRight;
			this.textEditorViewPort.paddingBottom = this._innerPaddingBottom;
			this.textEditorViewPort.paddingLeft = this._innerPaddingLeft;
			for(var propertyName:String in this._textEditorProperties)
			{
				var propertyValue:Object = this._textEditorProperties[propertyName];
				this.textEditorViewPort[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function refreshPromptProperties():void
		{
			if(!this.promptTextRenderer)
			{
				return;
			}
			this.promptTextRenderer.text = this._prompt;
			this.promptTextRenderer.fontStyles = this._promptFontStylesSet;
		}

		/**
		 * @private
		 */
		override protected function refreshBackgroundSkin():void
		{
			var oldSkin:DisplayObject = this.currentBackgroundSkin;
			this.currentBackgroundSkin = this.getCurrentBackgroundSkin();
			if(oldSkin !== this.currentBackgroundSkin)
			{
				if(oldSkin !== null)
				{
					if(oldSkin is IStateObserver)
					{
						IStateObserver(oldSkin).stateContext = null;
					}
					this.removeChild(oldSkin, false);
				}
				if(this.currentBackgroundSkin !== null)
				{
					if(this.currentBackgroundSkin is IStateObserver)
					{
						IStateObserver(this.currentBackgroundSkin).stateContext = this;
					}
					this.addChildAt(this.currentBackgroundSkin, 0);
					if(this.currentBackgroundSkin is IFeathersControl)
					{
						IFeathersControl(this.currentBackgroundSkin).initializeNow();
					}
					if(this.currentBackgroundSkin is IMeasureDisplayObject)
					{
						var measureSkin:IMeasureDisplayObject = IMeasureDisplayObject(this.currentBackgroundSkin);
						this._explicitBackgroundWidth = measureSkin.explicitWidth;
						this._explicitBackgroundHeight = measureSkin.explicitHeight;
						this._explicitBackgroundMinWidth = measureSkin.explicitMinWidth;
						this._explicitBackgroundMinHeight = measureSkin.explicitMinHeight;
					}
					else
					{
						this._explicitBackgroundWidth = this.currentBackgroundSkin.width;
						this._explicitBackgroundHeight = this.currentBackgroundSkin.height;
						this._explicitBackgroundMinWidth = this._explicitBackgroundWidth;
						this._explicitBackgroundMinHeight = this._explicitBackgroundHeight;
					}
				}
			}
		}

		/**
		 * @private
		 */
		override protected function getCurrentBackgroundSkin():DisplayObject
		{
			var result:DisplayObject = this._stateToSkin[this._currentState] as DisplayObject;
			if(result !== null)
			{
				return result;
			}
			return this._backgroundSkin;
		}

		/**
		 * @private
		 */
		protected function refreshState():void
		{
			if(this._isEnabled)
			{
				if(this._textEditorHasFocus)
				{
					this.changeState(TextInputState.FOCUSED);
				}
				else if(this._errorString !== null)
				{
					this.changeState(TextInputState.ERROR);
				}
				else
				{
					this.changeState(TextInputState.ENABLED);
				}
			}
			else
			{
				this.changeState(TextInputState.DISABLED);
			}
		}

		/**
		 * @private
		 */
		protected function refreshErrorCallout():void
		{
			if(this._textEditorHasFocus && this.callout === null &&
				this._errorString !== null && this._errorString.length > 0)
			{
				this.createErrorCallout();
			}
			else if(this.callout !== null &&
				(!this._textEditorHasFocus || this._errorString === null || this._errorString.length == 0))
			{
				this.callout.removeFromParent(true);
				this.callout = null;
			}
			if(this.callout !== null)
			{
				this.callout.text = this._errorString;
			}
		}

		/**
		 * @private
		 */
		override protected function layoutChildren():void
		{
			super.layoutChildren();

			if(this.promptTextRenderer !== null)
			{
				this.promptTextRenderer.x = this._leftViewPortOffset + this._innerPaddingLeft;
				this.promptTextRenderer.y = this._topViewPortOffset + this._innerPaddingTop;
				this.promptTextRenderer.width = this.actualWidth - this._leftViewPortOffset - this._rightViewPortOffset - this._innerPaddingLeft - this._innerPaddingRight;
				this.promptTextRenderer.height = this.actualHeight - this._topViewPortOffset - this._bottomViewPortOffset - this._innerPaddingTop - this._innerPaddingBottom;
			}
		}

		/**
		 * @private
		 */
		protected function setFocusOnTextEditorWithTouch(touch:Touch):void
		{
			if(!this.isFocusEnabled)
			{
				return;
			}
			var point:Point = Pool.getPoint();
			touch.getLocation(this.stage, point);
			var isInBounds:Boolean = this.contains(this.stage.hitTest(point));
			if(!this._textEditorHasFocus && isInBounds)
			{
				this.globalToLocal(point, point);
				point.x -= this._paddingLeft;
				point.y -= this._paddingTop;
				//we account for the scroll position in the text editor view
				//port, so don't do it here!
				this._isWaitingToSetFocus = false;
				this.textEditorViewPort.setFocus(point);
			}
			Pool.putPoint(point);
		}

		/**
		 * @private
		 */
		protected function textArea_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._textAreaTouchPointID = -1;
				return;
			}

			var horizontalScrollBar:DisplayObject = DisplayObject(this.horizontalScrollBar);
			var verticalScrollBar:DisplayObject = DisplayObject(this.verticalScrollBar);
			if(this._textAreaTouchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, TouchPhase.ENDED, this._textAreaTouchPointID);
				if(!touch || touch.isTouching(verticalScrollBar) || touch.isTouching(horizontalScrollBar))
				{
					return;
				}
				this.removeEventListener(Event.SCROLL, textArea_scrollHandler);
				this._textAreaTouchPointID = -1;
				if(this.textEditorViewPort.setTouchFocusOnEndedPhase)
				{
					this.setFocusOnTextEditorWithTouch(touch);
				}
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(touch)
				{
					if(touch.isTouching(verticalScrollBar) || touch.isTouching(horizontalScrollBar))
					{
						return;
					}
					this._textAreaTouchPointID = touch.id;
					if(!this.textEditorViewPort.setTouchFocusOnEndedPhase)
					{
						this.setFocusOnTextEditorWithTouch(touch);
					}
					this.addEventListener(Event.SCROLL, textArea_scrollHandler);
					return;
				}
				touch = event.getTouch(this, TouchPhase.HOVER);
				if(touch)
				{
					if(touch.isTouching(verticalScrollBar) || touch.isTouching(horizontalScrollBar))
					{
						return;
					}
					if(Mouse.supportsNativeCursor && !this._oldMouseCursor)
					{
						this._oldMouseCursor = Mouse.cursor;
						Mouse.cursor = MouseCursor.IBEAM;
					}
					return;
				}
				//end hover
				if(Mouse.supportsNativeCursor && this._oldMouseCursor)
				{
					Mouse.cursor = this._oldMouseCursor;
					this._oldMouseCursor = null;
				}
			}
		}

		/**
		 * @private
		 */
		protected function textArea_scrollHandler(event:Event):void
		{
			this.removeEventListener(Event.SCROLL, textArea_scrollHandler);
			this._textAreaTouchPointID = -1;
		}

		/**
		 * @private
		 */
		protected function textArea_removedFromStageHandler(event:Event):void
		{
			if(!this._focusManager && this._textEditorHasFocus)
			{
				this.clearFocus();
			}
			this._isWaitingToSetFocus = false;
			this._textEditorHasFocus = false;
			this._textAreaTouchPointID = -1;
			this.removeEventListener(Event.SCROLL, textArea_scrollHandler);
			if(Mouse.supportsNativeCursor && this._oldMouseCursor)
			{
				Mouse.cursor = this._oldMouseCursor;
				this._oldMouseCursor = null;
			}
		}

		/**
		 * @private
		 */
		override protected function focusInHandler(event:Event):void
		{
			if(!this._focusManager)
			{
				return;
			}
			super.focusInHandler(event);
			this.setFocus();
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			if(!this._focusManager)
			{
				return;
			}
			super.focusOutHandler(event);
			this.textEditorViewPort.clearFocus();
			this.invalidate(INVALIDATION_FLAG_STATE);
		}

		/**
		 * @private
		 */
		override protected function nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(this._isEditable)
			{
				return;
			}
			super.nativeStage_keyDownHandler(event);
		}

		/**
		 * @private
		 */
		protected function textEditor_changeHandler(event:Event):void
		{
			if(this._ignoreTextChanges)
			{
				return;
			}
			this.text = this.textEditorViewPort.text;
		}

		/**
		 * @private
		 */
		protected function textEditor_focusInHandler(event:Event):void
		{
			this._textEditorHasFocus = true;
			this.refreshState();
			this.refreshErrorCallout();
			this._touchPointID = -1;
			this.invalidate(INVALIDATION_FLAG_STATE);
			if(this._focusManager && this.isFocusEnabled && this._focusManager.focus !== this)
			{
				//if setFocus() was called manually, we need to notify the focus
				//manager (unless isFocusEnabled is false).
				//if the focus manager already knows that we have focus, it will
				//simply return without doing anything.
				this._focusManager.focus = this;
			}
			else if(!this._focusManager)
			{
				this.dispatchEventWith(FeathersEventType.FOCUS_IN);
			}
		}

		/**
		 * @private
		 */
		protected function textEditor_focusOutHandler(event:Event):void
		{
			this._textEditorHasFocus = false;
			this.refreshState();
			this.refreshErrorCallout();
			this.invalidate(INVALIDATION_FLAG_STATE);
			if(this._focusManager && this._focusManager.focus === this)
			{
				//if clearFocus() was called manually, we need to notify the
				//focus manager if it still thinks we have focus.
				this._focusManager.focus = null;
			}
			else if(!this._focusManager)
			{
				this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
			}
		}

		/**
		 * @private
		 */
		protected function fontStyles_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}
}
