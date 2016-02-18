/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.core.INativeFocusOwner;
	import feathers.core.IStateContext;
	import feathers.core.IStateObserver;
	import feathers.core.PopUpManager;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;

	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

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
	 */
	public class TextArea extends Scroller implements INativeFocusOwner, IStateContext
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_ON:String = "on";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_OFF:String = "off";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT:String = "fixedFloat";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

		/**
		 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
		 *
		 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

		/**
		 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL
		 *
		 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
		 *
		 * @see feathers.controls.Scroller#decelerationRate
		 */
		public static const DECELERATION_RATE_NORMAL:Number = 0.998;

		/**
		 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
		 *
		 * @see feathers.controls.Scroller#decelerationRate
		 */
		public static const DECELERATION_RATE_FAST:Number = 0.99;

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TextInputState.ENABLED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_ENABLED:String = "enabled";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TextInputState.DISABLED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DISABLED:String = "disabled";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TextInputState.FOCUSED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_FOCUSED:String = "focused";

		/**
		 * The default value added to the <code>styleNameList</code> of the text
		 * editor.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR:String = "feathers-text-area-text-editor";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * error callout.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT:String = "feathers-text-input-error-callout";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY:String = "errorCalloutFactory";

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
		 * The value added to the <code>styleNameList</code> of the text editor.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the text editor style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var textEditorStyleName:String = DEFAULT_CHILD_STYLE_NAME_TEXT_EDITOR;

		/**
		 * The value added to the <code>styleNameList</code> of the error
		 * callout. This variable is <code>protected</code> so that sub-classes
		 * can customize the prompt text renderer style name in their
		 * constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_ERROR_CALLOUT</code>.
		 *
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
		public function get nativeFocus():InteractiveObject
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
		protected var _pendingSelectionStartIndex:int = -1;

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
		 * @default null
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
		 * A display object displayed behind the text area's content when it
		 * has focus.
		 *
		 * <p>In the following example, the text area's focused background skin is
		 * specified:</p>
		 *
		 * <listing version="3.0">
		 * textArea.backgroundFocusedSkin = new Image( texture );</listing>
		 *
		 * @default null
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
		 * The skin used for the text area's error state. If <code>null</code>,
		 * then <code>backgroundSkin</code> is used instead.
		 *
		 * <p>The following example gives the text area a skin for the error state:</p>
		 *
		 * <listing version="3.0">
		 * textArea.backgroundErrorSkin = new Image( texture );</listing>
		 *
		 * @default null
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
		protected var _stateToSkinFunction:Function;

		/**
		 * DEPRECATED: Create a <code>feathers.skins.ImageSkin</code> instead,
		 * and pass to the <code>backgroundSkin</code> property.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get stateToSkinFunction():Function
		{
			return this._stateToSkinFunction;
		}

		/**
		 * @private
		 */
		public function set stateToSkinFunction(value:Function):void
		{
			if(this._stateToSkinFunction == value)
			{
				return;
			}
			this._stateToSkinFunction = value;
			this.invalidate(INVALIDATION_FLAG_SKIN);
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
		public function get customTextEditorStyleName():String
		{
			return this._customTextEditorStyleName;
		}

		/**
		 * @private
		 */
		public function set customTextEditorStyleName(value:String):void
		{
			if(this._customTextEditorStyleName == value)
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
		protected var _customErrorCalloutStyleName:String;

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
		public function get customErrorCalloutStyleName():String
		{
			return this._customErrorCalloutStyleName;
		}

		/**
		 * @private
		 */
		public function set customErrorCalloutStyleName(value:String):void
		{
			if(this._customErrorCalloutStyleName == value)
			{
				return;
			}
			this._customErrorCalloutStyleName = value;
			this.invalidate(INVALIDATION_FLAG_ERROR_CALLOUT_FACTORY);
		}

		/**
		 * @inheritDoc
		 */
		override public function showFocus():void
		{
			if(!this._focusManager || this._focusManager.focus != this)
			{
				return;
			}
			this.selectRange(0, this._text.length);
			super.showFocus();
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
		public function selectRange(startIndex:int, endIndex:int = -1):void
		{
			if(endIndex < 0)
			{
				endIndex = startIndex;
			}
			if(startIndex < 0)
			{
				throw new RangeError("Expected start index greater than or equal to 0. Received " + startIndex + ".");
			}
			if(endIndex > this._text.length)
			{
				throw new RangeError("Expected start index less than " + this._text.length + ". Received " + endIndex + ".");
			}

			if(this.textEditorViewPort)
			{
				this._pendingSelectionStartIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.textEditorViewPort.selectRange(startIndex, endIndex);
			}
			else
			{
				this._pendingSelectionStartIndex = startIndex;
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
			super.dispose();
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

			if(textEditorInvalid)
			{
				this.createTextEditor();
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
		protected function createErrorCallout():void
		{
			if(this.callout)
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
			this.callout.text = this._errorString;
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
			if(this._pendingSelectionStartIndex >= 0)
			{
				var startIndex:int = this._pendingSelectionStartIndex;
				var endIndex:int = this._pendingSelectionEndIndex;
				this._pendingSelectionStartIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.selectRange(startIndex, endIndex);
			}
		}

		/**
		 * @private
		 */
		protected function refreshTextEditorProperties():void
		{
			this.textEditorViewPort.maxChars = this._maxChars;
			this.textEditorViewPort.restrict = this._restrict;
			this.textEditorViewPort.isEditable = this._isEditable;
			for(var propertyName:String in this._textEditorProperties)
			{
				var propertyValue:Object = this._textEditorProperties[propertyName];
				this.textEditorViewPort[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		override protected function refreshBackgroundSkin():void
		{
			var oldSkin:DisplayObject = this.currentBackgroundSkin;
			this.currentBackgroundSkin = this.getCurrentSkin();
			if(oldSkin !== this.currentBackgroundSkin)
			{
				if(oldSkin)
				{
					this.removeChild(oldSkin, false);
				}
				if(this.currentBackgroundSkin)
				{
					this.addChildAt(this.currentBackgroundSkin, 0);
					if(this.originalBackgroundWidth !== this.originalBackgroundWidth) //isNaN
					{
						this.originalBackgroundWidth = this.currentBackgroundSkin.width;
					}
					if(this.originalBackgroundHeight !== this.originalBackgroundHeight) //isNaN
					{
						this.originalBackgroundHeight = this.currentBackgroundSkin.height;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function getCurrentSkin():DisplayObject
		{
			if(this._stateToSkinFunction != null)
			{
				return DisplayObject(this._stateToSkinFunction(this, this._currentState, this.currentBackgroundSkin));
			}
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
		protected function setFocusOnTextEditorWithTouch(touch:Touch):void
		{
			if(!this.isFocusEnabled)
			{
				return;
			}
			touch.getLocation(this.stage, HELPER_POINT);
			var isInBounds:Boolean = this.contains(this.stage.hitTest(HELPER_POINT));
			if(!this._textEditorHasFocus && isInBounds)
			{
				this.globalToLocal(HELPER_POINT, HELPER_POINT);
				HELPER_POINT.x -= this._paddingLeft;
				HELPER_POINT.y -= this._paddingTop;
				this._isWaitingToSetFocus = false;
				this.textEditorViewPort.setFocus(HELPER_POINT);
			}
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
		override protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(this._isEditable)
			{
				return;
			}
			super.stage_keyDownHandler(event);
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
			if(this._errorString !== null && this._errorString.length > 0)
			{
				this.createErrorCallout();
			}
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
			if(this.callout)
			{
				this.callout.removeFromParent(true);
				this.callout = null;
			}
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
	}
}
