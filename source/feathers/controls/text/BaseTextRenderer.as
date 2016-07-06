/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text
{
	import feathers.core.FeathersControl;
	import feathers.core.IStateContext;
	import feathers.core.IStateObserver;
	import feathers.core.IToggle;
	import feathers.events.FeathersEventType;

	import starling.events.Event;
	import starling.text.TextFormat;

	/**
	 * A base class for text renderers that implements some common properties.
	 */
	public class BaseTextRenderer extends FeathersControl implements IStateObserver
	{
		/**
		 * Constructor.
		 */
		public function BaseTextRenderer()
		{
			super();
		}

		/**
		 * @private
		 */
		protected var _text:String = null;

		/**
		 * @copy feathers.core.ITextRenderer#text
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
			if(this._text == value)
			{
				return;
			}
			this._text = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _stateContext:IStateContext;

		/**
		 * When the text renderer observes a state context, the text renderer
		 * may change its font styles based on the current state of that
		 * context. Typically, a relevant component will automatically assign
		 * itself as the state context of a text renderer, so this property is
		 * typically meant for internal use only.
		 *
		 * @default null
		 *
		 * @see #setFontStylesForState()
		 */
		public function get stateContext():IStateContext
		{
			return this._stateContext;
		}

		/**
		 * @private
		 */
		public function set stateContext(value:IStateContext):void
		{
			if(this._stateContext === value)
			{
				return;
			}
			if(this._stateContext)
			{
				this._stateContext.removeEventListener(FeathersEventType.STATE_CHANGE, stateContext_stateChangeHandler);
			}
			this._stateContext = value;
			if(this._stateContext)
			{
				this._stateContext.addEventListener(FeathersEventType.STATE_CHANGE, stateContext_stateChangeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_STATE);
		}

		/**
		 * @private
		 */
		protected var _wordWrap:Boolean = false;

		/**
		 * @copy feathers.core.ITextRenderer#wordWrap
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
		protected var _fontStylesForState:Object;

		/**
		 * @private
		 */
		protected var _fontStyles:TextFormat;

		/**
		 * @copy feathers.core.ITextRenderer#fontStyles
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #setFontStylesForState()
		 * @see #disabledFontStyles
		 * @see #selectedFontStyles
		 */
		public function get fontStyles():TextFormat
		{
			return this._fontStyles;
		}

		/**
		 * @private
		 */
		public function set fontStyles(value:TextFormat):void
		{
			if(this._fontStyles === value)
			{
				return;
			}
			if(this._fontStyles !== null)
			{
				this._fontStyles.removeEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this._fontStyles = value;
			if(this._fontStyles !== null)
			{
				this._fontStyles.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _disabledFontStyles:TextFormat;

		/**
		 * @copy feathers.core.ITextRenderer#disabledFontStyles
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #fontStyles
		 * @see #selectedFontStyles
		 */
		public function get disabledFontStyles():TextFormat
		{
			return this._disabledFontStyles;
		}

		/**
		 * @private
		 */
		public function set disabledFontStyles(value:TextFormat):void
		{
			if(this._disabledFontStyles === value)
			{
				return;
			}
			if(this._disabledFontStyles !== null)
			{
				this._disabledFontStyles.removeEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this._disabledFontStyles = value;
			if(this._disabledFontStyles !== null)
			{
				this._disabledFontStyles.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _selectedFontStyles:TextFormat;

		/**
		 * @copy feathers.core.ITextRenderer#selectedFontStyles
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #fontStyles
		 * @see #stateContext
		 * @see feathers.core.IToggle
		 */
		public function get selectedFontStyles():TextFormat
		{
			return this._selectedFontStyles;
		}

		/**
		 * @private
		 */
		public function set selectedFontStyles(value:TextFormat):void
		{
			if(this._selectedFontStyles === value)
			{
				return;
			}
			if(this._selectedFontStyles !== null)
			{
				this._selectedFontStyles.removeEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this._selectedFontStyles = value;
			if(this._selectedFontStyles !== null)
			{
				this._selectedFontStyles.addEventListener(Event.CHANGE, fontStyles_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @copy feathers.core.ITextRenderer#setFontStylesForState()
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 * @see #stateContext
		 * @see #fontStyles
		 */
		public function setFontStylesForState(state:String, fontStyles:TextFormat):void
		{
			if(fontStyles !== null)
			{
				if(this._fontStylesForState === null)
				{
					this._fontStylesForState = {};
				}
				this._fontStylesForState[state] = fontStyles;
				if(fontStyles !== null)
				{
					fontStyles.addEventListener(Event.CHANGE, fontStyles_changeHandler);
				}
			}
			else
			{
				var oldFontStyles:TextFormat = this._fontStylesForState[state];
				if(oldFontStyles !== null)
				{
					oldFontStyles.removeEventListener(Event.CHANGE, fontStyles_changeHandler);
				}
				delete this._fontStylesForState[state];
			}
			//if the context's current state is the state that we're modifying,
			//we need to use the new value immediately.
			if(this._stateContext !== null && this._stateContext.currentState === state)
			{
				this.invalidate(INVALIDATION_FLAG_STATE);
			}
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.stateContext = null;
			super.dispose();
		}

		/**
		 * Returns the font styles based on the current state.
		 */
		protected function getFontStyles():TextFormat
		{
			var fontStyles:TextFormat;
			if(this._stateContext !== null && this._fontStylesForState !== null)
			{
				var currentState:String = this._stateContext.currentState;
				if(currentState in this._fontStylesForState)
				{
					fontStyles = TextFormat(this._fontStylesForState[currentState]);
				}
			}
			if(fontStyles === null && !this._isEnabled && this._disabledFontStyles !== null)
			{
				fontStyles = this._disabledFontStyles;
			}
			if(fontStyles === null && this._selectedFontStyles !== null &&
				this._stateContext is IToggle && IToggle(this._stateContext).isSelected)
			{
				fontStyles = this._selectedFontStyles;
			}
			if(fontStyles === null)
			{
				fontStyles = this._fontStyles;
			}
			return fontStyles;
		}

		/**
		 * @private
		 */
		protected function stateContext_stateChangeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_STATE);
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
