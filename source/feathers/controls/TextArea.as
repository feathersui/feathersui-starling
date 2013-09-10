/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.text.ITextEditorViewPort;
	import feathers.controls.text.TextFieldTextEditorViewPort;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.PropertyProxy;
	import feathers.events.FeathersEventType;

	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the text area's <code>text</code> property changes.
	 *
	 * @eventType starling.events.Event.CHANGE
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Dispatched when the text area receives focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the text area loses focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * A text entry control that allows users to enter and edit multiple lines
	 * of uniformly-formatted text with the ability to scroll.
	 *
	 * <p><strong>Important:</strong> <code>TextArea</code> is not recommended
	 * for mobile. Instead, you should generally use a <code>TextInput</code>
	 * with a <code>StageTextTextEditor</code> that has its <code>multiline</code>
	 * property set to <code>true</code>. In that situation, the
	 * <code>StageText</code> instance will automatically provide its own
	 * scroll bars. <code>TextArea</code> is intended for use on desktop.</p>
	 *
	 * <p>The following example sets the text in a text area, selects the text,
	 * and listens for when the text value changes:</p>
	 *
	 * <listing version="3.0">
	 * var textArea:TextArea = new TextArea();
	 * textArea.text = "Hello\nWorld"; //it's multiline!
	 * textArea.selectRange( 0, textArea.text.length );
	 * textArea.addEventListener( Event.CHANGE, input_changeHandler );
	 * this.addChild( textArea );</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/text-area
	 * @see feathers.controls.TextInput
	 * @see http://wiki.starling-framework.org/feathers/text-editors
	 */
	public class TextArea extends Scroller implements IFocusDisplayObject
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
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

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
		 * Constructor.
		 */
		public function TextArea()
		{
			super();

			this.addEventListener(TouchEvent.TOUCH, textArea_touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, textArea_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		protected var textEditorViewPort:ITextEditorViewPort;

		/**
		 * @private
		 */
		protected var _textEditorHasFocus:Boolean = false;

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
		override public function get isFocusEnabled():Boolean
		{
			return this._isEditable && this._isFocusEnabled;
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
		protected var _backgroundFocusedSkin:DisplayObject;

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
			return this._backgroundFocusedSkin;
		}

		/**
		 * @private
		 */
		public function set backgroundFocusedSkin(value:DisplayObject):void
		{
			if(this._backgroundFocusedSkin == value)
			{
				return;
			}

			if(this._backgroundFocusedSkin && this._backgroundFocusedSkin != this._backgroundSkin &&
				this._backgroundFocusedSkin != this._backgroundDisabledSkin)
			{
				this.removeChild(this._backgroundFocusedSkin);
			}
			this._backgroundFocusedSkin = value;
			if(this._backgroundFocusedSkin && this._backgroundFocusedSkin.parent != this)
			{
				this._backgroundFocusedSkin.visible = false;
				this._backgroundFocusedSkin.touchable = false;
				this.addChildAt(this._backgroundFocusedSkin, 0);
			}
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
		 * input.textEditorFactory = function():ITextEditorViewPort
		 * {
		 *     return new TextFieldTextEditorViewPort();
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.text.ITextEditorViewPort
		 * @see feathers.controls.text.TextFieldTextEditorViewPort
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
		protected var _textEditorProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the text area's text
		 * editor view port. The text editor view port is an <code>ITextEditorViewPort</code>
		 * instance that is created by <code>textEditorFactory</code>.
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
		 * <code>TextFieldTextEditorViewPort</code>):</p>
		 *
		 * <listing version="3.0">
		 * input.textEditorProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333);
		 * input.textEditorProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #textEditorFactory
		 * @see feathers.controls.text.ITextEditorViewPort
		 * @see feathers.controls.text.TextFieldTextEditorViewPort
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
		override protected function draw():void
		{
			const textEditorInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_EDITOR);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);

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
				const oldIgnoreTextChanges:Boolean = this._ignoreTextChanges;
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

			this.refreshFocusIndicator();

			this.doPendingActions();
		}

		/**
		 * @inheritDoc
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				if(!isNaN(this.originalBackgroundWidth))
				{
					newWidth = this.originalBackgroundWidth;
				}
				else
				{
					newWidth = 0;
				}
			}
			if(needsHeight)
			{
				if(!isNaN(this.originalBackgroundHeight))
				{
					newHeight = this.originalBackgroundHeight;
				}
				else
				{
					newHeight = 0;
				}
			}
			return this.setSizeInternal(newWidth, newHeight, false);
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
			this.textEditorViewPort.addEventListener(Event.CHANGE, textEditor_changeHandler);
			this.textEditorViewPort.addEventListener(FeathersEventType.FOCUS_IN, textEditor_focusInHandler);
			this.textEditorViewPort.addEventListener(FeathersEventType.FOCUS_OUT, textEditor_focusOutHandler);

			const oldViewPort:ITextEditorViewPort = ITextEditorViewPort(this._viewPort);
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
		protected function refreshTextEditorProperties():void
		{
			this.textEditorViewPort.maxChars = this._maxChars;
			this.textEditorViewPort.restrict = this._restrict;
			this.textEditorViewPort.isEditable = this._isEditable;
			const displayTextEditor:DisplayObject = DisplayObject(this.textEditorViewPort);
			for(var propertyName:String in this._textEditorProperties)
			{
				if(displayTextEditor.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._textEditorProperties[propertyName];
					this.textEditorViewPort[propertyName] = propertyValue;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function refreshBackgroundSkin():void
		{
			if(this._hasFocus && this._backgroundFocusedSkin)
			{
				this.currentBackgroundSkin = this._backgroundFocusedSkin;
				this.setChildIndex(this.currentBackgroundSkin, 0);
				this.currentBackgroundSkin.visible = true;

				if(isNaN(this.originalBackgroundWidth))
				{
					this.originalBackgroundWidth = this.currentBackgroundSkin.width;
				}
				if(isNaN(this.originalBackgroundHeight))
				{
					this.originalBackgroundHeight = this.currentBackgroundSkin.height;
				}
				return;
			}
			super.refreshBackgroundSkin();
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

			const horizontalScrollBar:DisplayObject = DisplayObject(this.horizontalScrollBar);
			const verticalScrollBar:DisplayObject = DisplayObject(this.verticalScrollBar);
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
			this._touchPointID = -1;
			this.invalidate(INVALIDATION_FLAG_STATE);
			if(this._focusManager)
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
			this.invalidate(INVALIDATION_FLAG_STATE);
			if(this._focusManager)
			{
				return;
			}
			this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
		}
	}
}
