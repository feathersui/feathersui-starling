/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;
	import feathers.skins.StateValueSelector;

	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the text input's <code>text</code> property changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the user presses the Enter key while the text input
	 * has focus. This event may not be dispatched at all times. Certain text
	 * editors will not dispatch an event for the enter key on some platforms,
	 * depending on the values of certain properties. This may include the
	 * default values for some platforms! If you've encountered this issue,
	 * please see the specific text editor's API documentation for complete
	 * details of this event's limitations and requirements.
	 *
	 * @eventType feathers.events.FeathersEventType.ENTER
	 */
	[Event(name="enter",type="starling.events.Event")]

	/**
	 * Dispatched when the text input receives focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the text input loses focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * Dispatched when the soft keyboard is activated by the text editor. Not
	 * all text editors will activate a soft keyboard.
	 *
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_ACTIVATE
	 */
	[Event(name="softKeyboardActivate",type="starling.events.Event")]

	/**
	 * Dispatched when the soft keyboard is deactivated by the text editor. Not
	 * all text editors will activate a soft keyboard.
	 *
	 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_DEACTIVATE
	 */
	[Event(name="softKeyboardDeactivate",type="starling.events.Event")]

	/**
	 * A text entry control that allows users to enter and edit a single line of
	 * uniformly-formatted text.
	 *
	 * <p>To set things like font properties, the ability to display as
	 * password, and character restrictions, use the <code>textEditorProperties</code> to pass
	 * values to the <code>ITextEditor</code> instance.</p>
	 *
	 * <p>The following example sets the text in a text input, selects the text,
	 * and listens for when the text value changes:</p>
	 *
	 * <listing version="3.0">
	 * var input:TextInput = new TextInput();
	 * input.text = "Hello World";
	 * input.selectRange( 0, input.text.length );
	 * input.addEventListener( Event.CHANGE, input_changeHandler );
	 * this.addChild( input );</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-input
	 * @see http://wiki.starling-framework.org/feathers/text-editors
	 * @see feathers.core.ITextEditor
	 */
	public class TextInput extends FeathersControl implements IFocusDisplayObject
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * The <code>TextInput</code> is enabled and does not have focus.
		 */
		public static const STATE_ENABLED:String = "enabled";

		/**
		 * The <code>TextInput</code> is disabled.
		 */
		public static const STATE_DISABLED:String = "disabled";

		/**
		 * The <code>TextInput</code> is enabled and has focus.
		 */
		public static const STATE_FOCUSED:String = "focused";

		/**
		 * An alternate name to use with TextInput to allow a theme to give it
		 * a search input style. If a theme does not provide a skin for the
		 * search text input, the theme will automatically fall back to using
		 * the default text input skin.
		 *
		 * <p>An alternate name should always be added to a component's
		 * <code>nameList</code> before the component is added to the stage for
		 * the first time. If it is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the searc style is applied to a text
		 * input:</p>
		 *
		 * <listing version="3.0">
		 * var input:TextInput = new TextInput();
		 * input.nameList.add( TextInput.ALTERNATE_NAME_SEARCH_TEXT_INPUT );
		 * this.addChild( input );</listing>
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const ALTERNATE_NAME_SEARCH_TEXT_INPUT:String = "feathers-search-text-input";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_PROMPT_FACTORY:String = "promptFactory";

		/**
		 * Constructor.
		 */
		public function TextInput()
		{
			this.isQuickHitAreaEnabled = true;
			this.addEventListener(TouchEvent.TOUCH, textInput_touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, textInput_removedFromStageHandler);
		}

		/**
		 * The text editor sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var textEditor:ITextEditor;

		/**
		 * The prompt text renderer sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var promptTextRenderer:ITextRenderer;

		/**
		 * The currently selected background, based on state.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var currentBackground:DisplayObject;

		/**
		 * The currently visible icon. The value will be <code>null</code> if
		 * there is no currently visible icon.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected var currentIcon:DisplayObject;

		/**
		 * @private
		 */
		protected var _textEditorHasFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _ignoreTextChanges:Boolean = false;

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		override public function get isFocusEnabled():Boolean
		{
			return this._isEditable && this._isFocusEnabled;
		}

		/**
		 * @private
		 */
		override public function set isEnabled(value:Boolean):void
		{
			super.isEnabled = value;
			if(this._isEnabled)
			{
				this.currentState = this._hasFocus ? STATE_FOCUSED : STATE_ENABLED;
			}
			else
			{
				this.currentState = STATE_DISABLED;
			}
		}

		/**
		 * @private
		 */
		protected var _stateNames:Vector.<String> = new <String>
		[
			STATE_ENABLED, STATE_DISABLED, STATE_FOCUSED
		];

		/**
		 * A list of all valid state names for use with <code>currentState</code>.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #currentState
		 */
		protected function get stateNames():Vector.<String>
		{
			return this._stateNames;
		}

		/**
		 * @private
		 */
		protected var _currentState:String = STATE_ENABLED;

		/**
		 * The current state of the input.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function get currentState():String
		{
			return this._currentState;
		}

		/**
		 * @private
		 */
		protected function set currentState(value:String):void
		{
			if(this._currentState == value)
			{
				return;
			}
			if(this.stateNames.indexOf(value) < 0)
			{
				throw new ArgumentError("Invalid state: " + value + ".");
			}
			this._currentState = value;
			this.invalidate(INVALIDATION_FLAG_STATE);
		}

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * The text displayed by the text input. The text input dispatches
		 * <code>Event.CHANGE</code> when the value of the <code>text</code>
		 * property changes for any reason.
		 *
		 * <p>In the following example, the text input's text is updated:</p>
		 *
		 * <listing version="3.0">
		 * input.text = "Hello World";</listing>
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
		protected var _prompt:String;

		/**
		 * The prompt, hint, or description text displayed by the input when the
		 * value of its text is empty.
		 *
		 * <p>In the following example, the text input's prompt is updated:</p>
		 *
		 * <listing version="3.0">
		 * input.prompt = "User Name";</listing>
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
		protected var _typicalText:String;

		/**
		 * The text used to measure the input when the dimensions are not set
		 * explicitly (in addition to using the background skin for measurement).
		 *
		 * <p>In the following example, the text input's typical text is
		 * updated:</p>
		 *
		 * <listing version="3.0">
		 * input.text = "We want to allow the text input to show all of this text";</listing>
		 *
		 * @default null
		 */
		public function get typicalText():String
		{
			return this._typicalText;
		}

		/**
		 * @private
		 */
		public function set typicalText(value:String):void
		{
			if(this._typicalText == value)
			{
				return;
			}
			this._typicalText = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _maxChars:int = 0;

		/**
		 * The maximum number of characters that may be entered. If <code>0</code>,
		 * any number of characters may be entered.
		 *
		 * <p>In the following example, the text input's maximum characters is
		 * specified:</p>
		 *
		 * <listing version="3.0">
		 * input.maxChars = 10;</listing>
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
		 * <p>In the following example, the text input's allowed characters are
		 * restricted:</p>
		 *
		 * <listing version="3.0">
		 * input.restrict = "0-9;</listing>
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
		protected var _displayAsPassword:Boolean = false;

		/**
		 * Determines if the entered text will be masked so that it cannot be
		 * seen, such as for a password input.
		 *
		 * <p>In the following example, the text input's text is displayed as
		 * a password:</p>
		 *
		 * <listing version="3.0">
		 * input.displayAsPassword = true;</listing>
		 *
		 * @default false
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
		 * <p>In the following example, the text input is not editable:</p>
		 *
		 * <listing version="3.0">
		 * input.isEditable = false;</listing>
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
		protected var _textEditorFactory:Function;

		/**
		 * A function used to instantiate the text editor. If null,
		 * <code>FeathersControl.defaultTextEditorFactory</code> is used
		 * instead. The text editor must be an instance of
		 * <code>ITextEditor</code>. This factory can be used to change
		 * properties on the text editor when it is first created. For instance,
		 * if you are skinning Feathers components without a theme, you might
		 * use this factory to set styles on the text editor.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextEditor</pre>
		 *
		 * <p>In the following example, a custom text editor factory is passed
		 * to the text input:</p>
		 *
		 * <listing version="3.0">
		 * input.textEditorFactory = function():ITextEditor
		 * {
		 *     return new TextFieldTextEditor();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextEditor
		 * @see feathers.core.FeathersControl#defaultTextEditorFactory
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
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
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
		protected var _promptProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the text input's prompt
		 * text renderer. The prompt text renderer is an <code>ITextRenderer</code>
		 * instance that is created by <code>promptFactory</code>. The available
		 * properties depend on which <code>ITextRenderer</code> implementation
		 * is returned by <code>promptFactory</code>. The most common
		 * implementations are <code>BitmapFontTextRenderer</code> and
		 * <code>TextFieldTextRenderer</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>promptFactory</code> function
		 * instead of using <code>promptProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the text input's prompt's properties are
		 * updated (this example assumes that the prompt text renderer is a
		 * <code>TextFieldTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * input.promptProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * input.promptProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #promptFactory
		 * @see feathers.core.ITextRenderer
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
		 */
		public function get promptProperties():Object
		{
			if(!this._promptProperties)
			{
				this._promptProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._promptProperties;
		}

		/**
		 * @private
		 */
		public function set promptProperties(value:Object):void
		{
			if(this._promptProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._promptProperties)
			{
				this._promptProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._promptProperties = PropertyProxy(value);
			if(this._promptProperties)
			{
				this._promptProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 * The width of the first skin that was displayed.
		 */
		protected var _originalSkinWidth:Number = NaN;

		/**
		 * @private
		 * The height of the first skin that was displayed.
		 */
		protected var _originalSkinHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _skinSelector:StateValueSelector = new StateValueSelector();

		/**
		 * The skin used when no other skin is defined for the current state.
		 * Intended for use when multiple states should use the same skin.
		 *
		 * <p>The following example gives the input a default skin to use for
		 * all states when no specific skin is available:</p>
		 *
		 * <listing version="3.0">
		 * input.backgroundSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #backgroundEnabledSkin
		 * @see #backgroundDisabledSkin
		 * @see #backgroundFocusedSkin
		 */
		public function get backgroundSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.defaultValue);
		}

		/**
		 * @private
		 */
		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this._skinSelector.defaultValue == value)
			{
				return;
			}
			this._skinSelector.defaultValue = value;
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}

		/**
		 * The skin used for the input's enabled state. If <code>null</code>,
		 * then <code>backgroundSkin</code> is used instead.
		 *
		 * <p>The following example gives the input a skin for the enabled state:</p>
		 *
		 * <listing version="3.0">
		 * input.backgroundEnabledSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #backgroundSkin
		 * @see #backgroundDisabledSkin
		 */
		public function get backgroundEnabledSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_ENABLED));
		}

		/**
		 * @private
		 */
		public function set backgroundEnabledSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_ENABLED) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_ENABLED);
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}

		/**
		 * The skin used for the input's focused state. If <code>null</code>,
		 * then <code>backgroundSkin</code> is used instead.
		 *
		 * <p>The following example gives the input a skin for the focused state:</p>
		 *
		 * <listing version="3.0">
		 * input.backgroundFocusedSkin = new Image( texture );</listing>
		 *
		 * @default null
		 */
		public function get backgroundFocusedSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_FOCUSED));
		}

		/**
		 * @private
		 */
		public function set backgroundFocusedSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_FOCUSED) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_FOCUSED);
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}

		/**
		 * The skin used for the input's disabled state. If <code>null</code>,
		 * then <code>backgroundSkin</code> is used instead.
		 *
		 * <p>The following example gives the input a skin for the disabled state:</p>
		 *
		 * <listing version="3.0">
		 * input.backgroundDisabledSkin = new Image( texture );</listing>
		 *
		 * @default null
		 */
		public function get backgroundDisabledSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_DISABLED));
		}

		/**
		 * @private
		 */
		public function set backgroundDisabledSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_DISABLED) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_DISABLED);
			this.invalidate(INVALIDATION_FLAG_SKIN);
		}

		/**
		 * @private
		 */
		protected var _stateToSkinFunction:Function;

		/**
		 * Returns a skin for the current state.
		 *
		 * <p>The following function signature is expected:</p>
		 * <pre>function( target:TextInput, state:Object, oldSkin:DisplayObject = null ):DisplayObject</pre>
		 *
		 * @default null
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
		protected var _iconSelector:StateValueSelector = new StateValueSelector();

		/**
		 * The icon used when no other icon is defined for the current state.
		 * Intended for use when multiple states should use the same icon.
		 *
		 * <p>The following example gives the input a default icon to use for
		 * all states when no specific icon is available:</p>
		 *
		 * <listing version="3.0">
		 * input.defaultIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #stateToIconFunction
		 * @see #enabledIcon
		 * @see #disabledIcon
		 * @see #focusedIcon
		 */
		public function get defaultIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.defaultValue);
		}

		/**
		 * @private
		 */
		public function set defaultIcon(value:DisplayObject):void
		{
			if(this._iconSelector.defaultValue == value)
			{
				return;
			}
			this._iconSelector.defaultValue = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The icon used for the input's enabled state. If <code>null</code>,
		 * then <code>defaultIcon</code> is used instead.
		 *
		 * <p>The following example gives the input an icon for the enabled state:</p>
		 *
		 * <listing version="3.0">
		 * button.enabledIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultIcon
		 * @see #disabledIcon
		 */
		public function get enabledIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_ENABLED));
		}

		/**
		 * @private
		 */
		public function set enabledIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_ENABLED) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_ENABLED);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The icon used for the input's disabled state. If <code>null</code>,
		 * then <code>defaultIcon</code> is used instead.
		 *
		 * <p>The following example gives the input an icon for the disabled state:</p>
		 *
		 * <listing version="3.0">
		 * button.disabledIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultIcon
		 * @see #enabledIcon
		 */
		public function get disabledIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_DISABLED));
		}

		/**
		 * @private
		 */
		public function set disabledIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_DISABLED) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_DISABLED);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The icon used for the input's focused state. If <code>null</code>,
		 * then <code>defaultIcon</code> is used instead.
		 *
		 * <p>The following example gives the input an icon for the focused state:</p>
		 *
		 * <listing version="3.0">
		 * button.focusedIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultIcon
		 * @see #enabledIcon
		 * @see #disabledIcon
		 */
		public function get focusedIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_FOCUSED));
		}

		/**
		 * @private
		 */
		public function set focusedIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_FOCUSED) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_FOCUSED);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _stateToIconFunction:Function;

		/**
		 * Returns an icon for the current state.
		 *
		 * <p>The following function signature is expected:</p>
		 * <pre>function( target:TextInput, state:Object, oldIcon:DisplayObject = null ):DisplayObject</pre>
		 *
		 * @default null
		 */
		public function get stateToIconFunction():Function
		{
			return this._stateToIconFunction;
		}

		/**
		 * @private
		 */
		public function set stateToIconFunction(value:Function):void
		{
			if(this._stateToIconFunction == value)
			{
				return;
			}
			this._stateToIconFunction = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * The space, in pixels, between the icon and the text editor, if an
		 * icon exists.
		 *
		 * <p>The following example creates a gap of 50 pixels between the icon
		 * and the text editor:</p>
		 *
		 * <listing version="3.0">
		 * button.defaultIcon = new Image( texture );
		 * button.gap = 50;</listing>
		 *
		 * @default 0
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * Quickly sets all padding properties to the same value. The
		 * <code>padding</code> getter always returns the value of
		 * <code>paddingTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>In the following example, the text input's padding is set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * input.padding = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #paddingTop
		 * @see #paddingRight
		 * @see #paddingBottom
		 * @see #paddingLeft
		 */
		public function get padding():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			this.paddingTop = value;
			this.paddingRight = value;
			this.paddingBottom = value;
			this.paddingLeft = value;
		}

		/**
		 * @private
		 */
		protected var _paddingTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the input's top edge and the
		 * input's content.
		 *
		 * <p>In the following example, the text input's top padding is set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * input.paddingTop = 20;</listing>
		 *
		 * @default 0
		 */
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the input's right edge and the
		 * input's content.
		 *
		 * <p>In the following example, the text input's right padding is set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * input.paddingRight = 20;</listing>
		 *
		 * @default 0
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the input's bottom edge and
		 * the input's content.
		 *
		 * <p>In the following example, the text input's bottom padding is set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * input.paddingBottom = 20;</listing>
		 *
		 * @default 0
		 */
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the input's left edge and the
		 * input's content.
		 *
		 * <p>In the following example, the text input's left padding is set to
		 * 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * input.paddingLeft = 20;</listing>
		 *
		 * @default 0
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 * Flag indicating that the text editor should get focus after it is
		 * created.
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
		protected var _oldMouseCursor:String = null;

		/**
		 * @private
		 */
		protected var _textEditorProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the text input's
		 * text editor. The text editor is an <code>ITextEditor</code> instance
		 * that is created by <code>textEditorFactory</code>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>textEditorFactory</code> function
		 * instead of using <code>textEditorProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the text input's text editor properties
		 * are specified (this example assumes that the text editor is a
		 * <code>StageTextTextEditor</code>):</p>
		 *
		 * <listing version="3.0">
		 * input.textEditorProperties.fontName = "Helvetica";
		 * input.textEditorProperties.fontSize = 16;</listing>
		 *
		 * @default null
		 *
		 * @see #textEditorFactory
		 * @see feathers.core.ITextEditor
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
				const newValue:PropertyProxy = new PropertyProxy();
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
		override public function set visible(value:Boolean):void
		{
			if(!value)
			{
				this._isWaitingToSetFocus = false;
				if(this._textEditorHasFocus)
				{
					this.textEditor.clearFocus();
				}
			}
			super.visible = value;
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
		 * Focuses the text input control so that it may be edited.
		 */
		public function setFocus():void
		{
			if(this._textEditorHasFocus || !this.visible)
			{
				return;
			}
			if(this.textEditor)
			{
				this._isWaitingToSetFocus = false;
				this.textEditor.setFocus();
			}
			else
			{
				this._isWaitingToSetFocus = true;
				this.invalidate(INVALIDATION_FLAG_SELECTED);
			}
		}

		/**
		 * Manually removes focus from the text input control.
		 */
		public function clearFocus():void
		{
			this._isWaitingToSetFocus = false;
			if(!this.textEditor || !this._textEditorHasFocus)
			{
				return;
			}
			this.textEditor.clearFocus();
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
				throw new RangeError("Expected start index >= 0. Received " + startIndex + ".");
			}
			if(endIndex > this._text.length)
			{
				throw new RangeError("Expected end index <= " + this._text.length + ". Received " + endIndex + ".");
			}

			//if it's invalid, we need to wait until validation before changing
			//the selection
			if(this.textEditor && (this._isValidating || !this.isInvalid()))
			{
				this._pendingSelectionStartIndex = -1;
				this._pendingSelectionEndIndex = -1;
				this.textEditor.selectRange(startIndex, endIndex);
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
		override protected function draw():void
		{
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const skinInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SKIN);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const textEditorInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_EDITOR);
			const promptFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_PROMPT_FACTORY);
			const focusInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);

			if(textEditorInvalid)
			{
				this.createTextEditor();
			}

			if(promptFactoryInvalid)
			{
				this.createPrompt();
			}

			if(textEditorInvalid || stylesInvalid)
			{
				this.refreshTextEditorProperties();
			}

			if(promptFactoryInvalid || stylesInvalid)
			{
				this.refreshPromptProperties();
			}

			if(textEditorInvalid || dataInvalid)
			{
				const oldIgnoreTextChanges:Boolean = this._ignoreTextChanges;
				this._ignoreTextChanges = true;
				this.textEditor.text = this._text;
				this._ignoreTextChanges = oldIgnoreTextChanges;
			}

			if(promptFactoryInvalid || dataInvalid || stylesInvalid)
			{
				this.promptTextRenderer.visible = this._prompt && this._text.length == 0;
			}

			if(textEditorInvalid || stateInvalid)
			{
				this.textEditor.isEnabled = this._isEnabled;
				if(!this._isEnabled && Mouse.supportsNativeCursor && this._oldMouseCursor)
				{
					Mouse.cursor = this._oldMouseCursor;
					this._oldMouseCursor = null;
				}
			}

			if(stateInvalid || skinInvalid)
			{
				this.refreshBackgroundSkin();
			}
			if(stateInvalid || stylesInvalid)
			{
				this.refreshIcon();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layoutChildren();

			if(sizeInvalid || focusInvalid)
			{
				this.refreshFocusIndicator();
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

			var typicalTextWidth:Number = 0;
			var typicalTextHeight:Number = 0;
			if(this._typicalText)
			{
				const oldIgnoreTextChanges:Boolean = this._ignoreTextChanges;
				this._ignoreTextChanges = true;
				this.textEditor.setSize(NaN, NaN);
				this.textEditor.text = this._typicalText;
				this.textEditor.measureText(HELPER_POINT);
				this.textEditor.text = this._text;
				this._ignoreTextChanges = oldIgnoreTextChanges;
				typicalTextWidth = HELPER_POINT.x;
				typicalTextHeight = HELPER_POINT.y;
			}
			if(this._prompt)
			{
				this.promptTextRenderer.setSize(NaN, NaN);
				this.promptTextRenderer.measureText(HELPER_POINT);
				typicalTextWidth = Math.max(typicalTextWidth, HELPER_POINT.x);
				typicalTextHeight = Math.max(typicalTextHeight, HELPER_POINT.y);
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				newWidth = Math.max(this._originalSkinWidth, typicalTextWidth + this._paddingLeft + this._paddingRight);
			}
			if(needsHeight)
			{
				newHeight = Math.max(this._originalSkinHeight, typicalTextHeight + this._paddingTop + this._paddingBottom);
			}

			if(this._typicalText)
			{
				this.textEditor.width = this.actualWidth - this._paddingLeft - this._paddingRight;
				this.textEditor.height = this.actualHeight - this._paddingTop - this._paddingBottom;
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * Creates and adds the <code>textEditor</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #textEditor
		 * @see #textEditorFactory
		 */
		protected function createTextEditor():void
		{
			if(this.textEditor)
			{
				this.removeChild(DisplayObject(this.textEditor), true);
				this.textEditor.removeEventListener(Event.CHANGE, textEditor_changeHandler);
				this.textEditor.removeEventListener(FeathersEventType.ENTER, textEditor_enterHandler);
				this.textEditor.removeEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
				this.textEditor.removeEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
				this.textEditor = null;
			}

			const factory:Function = this._textEditorFactory != null ? this._textEditorFactory : FeathersControl.defaultTextEditorFactory;
			this.textEditor = ITextEditor(factory());
			this.textEditor.addEventListener(Event.CHANGE, textEditor_changeHandler);
			this.textEditor.addEventListener(FeathersEventType.ENTER, textEditor_enterHandler);
			this.textEditor.addEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
			this.textEditor.addEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);
			this.addChild(DisplayObject(this.textEditor));
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

			const factory:Function = this._promptFactory != null ? this._promptFactory : FeathersControl.defaultTextRendererFactory;
			this.promptTextRenderer = ITextRenderer(factory());
			this.addChild(DisplayObject(this.promptTextRenderer));
		}

		/**
		 * @private
		 */
		protected function doPendingActions():void
		{
			if(this._isWaitingToSetFocus)
			{
				this._isWaitingToSetFocus = false;
				if(!this._textEditorHasFocus)
				{
					this.textEditor.setFocus();
				}
			}
			if(this._pendingSelectionStartIndex >= 0)
			{
				var startIndex:int = this._pendingSelectionStartIndex;
				var endIndex:int = this._pendingSelectionEndIndex;
				this._pendingSelectionStartIndex = -1;
				this._pendingSelectionEndIndex = -1;
				if(endIndex >= 0)
				{
					var textLength:int = this._text.length;
					if(endIndex > textLength)
					{
						endIndex = textLength;
					}
				}
				this.selectRange(startIndex, endIndex);
			}
		}

		/**
		 * @private
		 */
		protected function refreshTextEditorProperties():void
		{
			this.textEditor.displayAsPassword = this._displayAsPassword;
			this.textEditor.maxChars = this._maxChars;
			this.textEditor.restrict = this._restrict;
			this.textEditor.isEditable = this._isEditable;
			const displayTextEditor:DisplayObject = DisplayObject(this.textEditor);
			for(var propertyName:String in this._textEditorProperties)
			{
				if(displayTextEditor.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._textEditorProperties[propertyName];
					this.textEditor[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshPromptProperties():void
		{
			this.promptTextRenderer.text = this._prompt;
			const displayPrompt:DisplayObject = DisplayObject(this.promptTextRenderer);
			for(var propertyName:String in this._promptProperties)
			{
				if(displayPrompt.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._promptProperties[propertyName];
					this.promptTextRenderer[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * Sets the <code>currentBackground</code> property.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function refreshBackgroundSkin():void
		{
			const oldSkin:DisplayObject = this.currentBackground;
			if(this._stateToSkinFunction != null)
			{
				this.currentBackground = DisplayObject(this._stateToSkinFunction(this, this._currentState, oldSkin));
			}
			else
			{
				this.currentBackground = DisplayObject(this._skinSelector.updateValue(this, this._currentState, this.currentBackground));
			}
			if(this.currentBackground != oldSkin)
			{
				if(oldSkin)
				{
					this.removeChild(oldSkin, false);
				}
				if(this.currentBackground)
				{
					this.addChildAt(this.currentBackground, 0);
				}
			}
			if(this.currentBackground && (isNaN(this._originalSkinWidth) || isNaN(this._originalSkinHeight)))
			{
				if(this.currentBackground is IFeathersControl)
				{
					IFeathersControl(this.currentBackground).validate();
				}
				this._originalSkinWidth = this.currentBackground.width;
				this._originalSkinHeight = this.currentBackground.height;
			}
		}

		/**
		 * Sets the <code>currentIcon</code> property.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function refreshIcon():void
		{
			const oldIcon:DisplayObject = this.currentIcon;
			if(this._stateToIconFunction != null)
			{
				this.currentIcon = DisplayObject(this._stateToIconFunction(this, this._currentState, oldIcon));
			}
			else
			{
				this.currentIcon = DisplayObject(this._iconSelector.updateValue(this, this._currentState, this.currentIcon));
			}
			if(this.currentIcon is IFeathersControl)
			{
				IFeathersControl(this.currentIcon).isEnabled = this._isEnabled;
			}
			if(this.currentIcon != oldIcon)
			{
				if(oldIcon)
				{
					this.removeChild(oldIcon, false);
				}
				if(this.currentIcon)
				{
					//we want the icon to appear below the text editor
					var index:int = this.getChildIndex(DisplayObject(this.textEditor));
					this.addChildAt(this.currentIcon, index);
				}
			}
		}

		/**
		 * Positions and sizes the text input's children.
		 *
		 * <p>For internal use in subclasses.</p>
		 */
		protected function layoutChildren():void
		{
			if(this.currentBackground)
			{
				this.currentBackground.visible = true;
				this.currentBackground.touchable = true;
				this.currentBackground.width = this.actualWidth;
				this.currentBackground.height = this.actualHeight;
			}

			if(this.currentIcon is IFeathersControl)
			{
				IFeathersControl(this.currentIcon).validate();
			}

			if(this.currentIcon)
			{
				this.currentIcon.x = this._paddingLeft;
				this.currentIcon.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingRight - this.currentIcon.height) / 2;
				this.textEditor.x = this.currentIcon.x + this.currentIcon.width + this._gap;
				this.promptTextRenderer.x = this.currentIcon.x + this.currentIcon.width + this._gap;
			}
			else
			{
				this.textEditor.x = this._paddingLeft;
				this.promptTextRenderer.x = this._paddingLeft;
			}
			this.textEditor.y = this._paddingTop;
			this.textEditor.width = this.actualWidth - this._paddingRight - this.textEditor.x;
			this.textEditor.height = this.actualHeight - this._paddingTop - this._paddingBottom;

			this.promptTextRenderer.y = this._paddingTop;
			this.promptTextRenderer.width = this.actualWidth - this._paddingRight - this.promptTextRenderer.x;
			this.promptTextRenderer.height = this.actualHeight - this._paddingTop - this._paddingBottom;
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
			const isInBounds:Boolean = this.contains(this.stage.hitTest(HELPER_POINT, true));
			if(!this._textEditorHasFocus && isInBounds)
			{
				this.globalToLocal(HELPER_POINT, HELPER_POINT);
				HELPER_POINT.x -= this._paddingLeft;
				HELPER_POINT.y -= this._paddingTop;
				this._isWaitingToSetFocus = false;
				this.textEditor.setFocus(HELPER_POINT);
			}
		}

		/**
		 * @private
		 */
		protected function childProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function textInput_removedFromStageHandler(event:Event):void
		{
			this._textEditorHasFocus = false;
			this._isWaitingToSetFocus = false;
			this._touchPointID = -1;
			if(Mouse.supportsNativeCursor && this._oldMouseCursor)
			{
				Mouse.cursor = this._oldMouseCursor;
				this._oldMouseCursor = null;
			}
		}

		/**
		 * @private
		 */
		protected function textInput_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || !this._isEditable)
			{
				this._touchPointID = -1;
				return;
			}

			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, TouchPhase.ENDED, this._touchPointID);
				if(!touch)
				{
					return;
				}
				this._touchPointID = -1;
				if(this.textEditor.setTouchFocusOnEndedPhase)
				{
					this.setFocusOnTextEditorWithTouch(touch);
				}
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(touch)
				{
					this._touchPointID = touch.id;
					if(!this.textEditor.setTouchFocusOnEndedPhase)
					{
						this.setFocusOnTextEditorWithTouch(touch);
					}
					return;
				}
				touch = event.getTouch(this, TouchPhase.HOVER);
				if(touch)
				{
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
			this.textEditor.clearFocus();
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
			this.text = this.textEditor.text;
		}

		/**
		 * @private
		 */
		protected function textEditor_enterHandler(event:Event):void
		{
			this.dispatchEventWith(FeathersEventType.ENTER);
		}

		/**
		 * @private
		 */
		protected function textEditor_focusInHandler(event:Event):void
		{
			this._touchPointID = -1;
			if(!this.visible)
			{
				this.textEditor.clearFocus();
				return;
			}
			this._textEditorHasFocus = true;
			this.currentState = STATE_FOCUSED;
			if(this._focusManager && this._isFocusEnabled)
			{
				this._focusManager.focus = this;
			}
			else
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
			this.currentState = this._isEnabled ? STATE_ENABLED : STATE_DISABLED;
			if(this._focusManager)
			{
				if(this._focusManager.focus == this)
				{
					this._focusManager.focus = null;
				}
			}
			else
			{
				this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
			}
		}
	}
}
