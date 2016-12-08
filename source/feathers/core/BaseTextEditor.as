/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.events.FeathersEventType;
	import feathers.text.FontStylesSet;

	import starling.events.Event;

	/**
	 * A base class for text editors that implements some common properties.
	 *
	 * @productversion Feathers 3.1.0
	 */
	public class BaseTextEditor extends FeathersControl implements IStateObserver
	{
		/**
		 * Constructor.
		 */
		public function BaseTextEditor()
		{
			super();
		}

		/**
		 * @private
		 */
		protected var _text:String = "";

		/**
		 * @copy feathers.core.ITextEditor#text
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
		protected var _stateContext:IStateContext;

		/**
		 * When the text editor observes a state context, the text editor may
		 * change its font styles based on the current state of that context.
		 * Typically, a relevant component will automatically assign itself as
		 * the state context of a text editor, so this property is typically
		 * meant for internal use only.
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
		protected var _fontStyles:FontStylesSet;

		/**
		 * @copy feathers.core.ITextEditor#fontStyles
		 */
		public function get fontStyles():FontStylesSet
		{
			return this._fontStyles;
		}

		/**
		 * @private
		 */
		public function set fontStyles(value:FontStylesSet):void
		{
			if(this._fontStyles === value)
			{
				return;
			}
			if(this._fontStyles !== null)
			{
				this._fontStyles.removeEventListener(Event.CHANGE, fontStylesSet_changeHandler);
			}
			this._fontStyles = value;
			if(this._fontStyles !== null)
			{
				this._fontStyles.addEventListener(Event.CHANGE, fontStylesSet_changeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.stateContext = null;
			this.fontStyles = null;
			super.dispose();
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
		protected function fontStylesSet_changeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
	}
}
