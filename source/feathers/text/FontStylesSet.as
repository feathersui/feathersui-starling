/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.text
{
	import feathers.core.IFeathersControl;
	import feathers.core.IStateContext;
	import feathers.core.IStateContext;
	import feathers.core.IStateObserver;
	import feathers.core.ITextRenderer;
	import feathers.core.IToggle;

	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.text.TextFormat;

	/**
	 * Dispatched when a new <code>starling.text.TextFormat</code> is passed in
	 * or when one of the existing <code>TextFormat</code> objects is modified.
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
	 * Used internally by <code>ITextRenderer</code> implementations to pass
	 * around sets of <code>TextFormat</code> objects for a component's
	 * different states.
	 * 
	 * <p>A custom component that uses one or more text renderers is expected to
	 * provide user-facing APIs to set its font styles using
	 * separate <code>TextFormat</code> instances. The combined set of these
	 * formats should be stored in a <code>FontStylesSet</code> that can be
	 * passed into the text renderer.</p>
	 * 
	 * @see feathers.core.ITextRenderer
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 */
	public class FontStylesSet extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function FontStylesSet()
		{
			super();
		}

		/**
		 * @private
		 * Stores formats for specific state. The key is the state constant,
		 * and the value is a TextFormat.
		 */
		protected var _stateToFormat:Object;

		/**
		 * @private
		 */
		protected var _format:TextFormat;

		/**
		 * The default font format used to display the text.
		 * 
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 */
		public function get format():TextFormat
		{
			return this._format;
		}

		/**
		 * @private
		 */
		public function set format(value:TextFormat):void
		{
			if(this._format === value)
			{
				return;
			}
			if(this._format !== null)
			{
				this._format.removeEventListener(Event.CHANGE, format_changeHandler);
			}
			this._format = value;
			if(this._format !== null)
			{
				this._format.addEventListener(Event.CHANGE, format_changeHandler);
			}
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _disabledFormat:TextFormat;

		/**
		 * The font styles used to display the text when the component is
		 * disabled. If <code>null</code>, the value of the <code>format</code>
		 * property will typically be used.
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 */
		public function get disabledFormat():TextFormat
		{
			return this._disabledFormat;
		}

		/**
		 * @private
		 */
		public function set disabledFormat(value:TextFormat):void
		{
			if(this._disabledFormat === value)
			{
				return;
			}
			if(this._disabledFormat !== null)
			{
				this._disabledFormat.removeEventListener(Event.CHANGE, format_changeHandler);
			}
			this._disabledFormat = value;
			if(this._disabledFormat !== null)
			{
				this._disabledFormat.addEventListener(Event.CHANGE, format_changeHandler);
			}
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _selectedFormat:TextFormat;

		/**
		 * The font styles used to display the text when the component is
		 * selected. If <code>null</code>, the value of the <code>format</code>
		 * property will typically be used.
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 */
		public function get selectedFormat():TextFormat
		{
			return this._selectedFormat;
		}

		/**
		 * @private
		 */
		public function set selectedFormat(value:TextFormat):void
		{
			if(this._selectedFormat === value)
			{
				return;
			}
			if(this._selectedFormat !== null)
			{
				this._selectedFormat.removeEventListener(Event.CHANGE, format_changeHandler);
			}
			this._selectedFormat = value;
			if(this._selectedFormat !== null)
			{
				this._selectedFormat.addEventListener(Event.CHANGE, format_changeHandler);
			}
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * Returns the <code>TextFormat</code> for a specific state, or
		 * <code>null</code> if the <code>TextFormat</code> has not been set
		 * for that state.
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 */
		public function getFormatForState(state:String):TextFormat
		{
			if(this._stateToFormat === null)
			{
				return null;
			}
			return TextFormat(this._stateToFormat[state]);
		}

		/**
		 * Sets the <code>TextFormat</code> for a specific state.
		 * 
		 * <p>Pass in <code>null</code> to clear the format for the state.</p>
		 *
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 */
		public function setFormatForState(state:String, format:TextFormat):void
		{
			if(format !== null)
			{
				if(this._stateToFormat === null)
				{
					this._stateToFormat = {};
				}
				this._stateToFormat[state] = format;
				if(format !== null)
				{
					format.addEventListener(Event.CHANGE, format_changeHandler);
				}
			}
			else
			{
				var oldFormat:TextFormat = TextFormat(this._stateToFormat[state]);
				if(oldFormat !== null)
				{
					oldFormat.removeEventListener(Event.CHANGE, format_changeHandler);
				}
				delete this._stateToFormat[state];
			}
		}

		/**
		 * Chooses the appropriate <code>TextFormat</code> to use based on the
		 * state of the text renderer passed in. If the text renderer has a
		 * <code>stateContext</code>, the state of the <code>stateContext</code>
		 * takes precedent.
		 * 
		 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
		 */
		public function getTextFormatForTarget(target:IFeathersControl):TextFormat
		{
			var textFormat:TextFormat;
			var stateContext:IStateContext;
			if(target is IStateObserver)
			{
				stateContext = IStateObserver(target).stateContext;
			}
			if(stateContext !== null)
			{
				//first, look for a format defined for a specific state
				if(this._stateToFormat !== null)
				{
					var currentState:String = stateContext.currentState;
					if(currentState in this._stateToFormat)
					{
						textFormat = TextFormat(this._stateToFormat[currentState]);
					}
				}
				//the disabled format is a convenience that can cover multiple
				//disabled states
				if(textFormat === null && this._disabledFormat !== null &&
					stateContext is IFeathersControl && !IFeathersControl(target).isEnabled)
				{
					textFormat = this._disabledFormat;
				}
				//similar with the selected format that can cover multiple
				//selected states
				if(textFormat === null && this._selectedFormat !== null &&
					stateContext is IToggle && IToggle(stateContext).isSelected)
				{
					textFormat = this._selectedFormat;
				}
			}
			else //no state context, so only text renderer can be used
			{
				if(this._disabledFormat !== null && !target.isEnabled)
				{
					textFormat = this._disabledFormat;
				}
			}
			if(textFormat === null)
			{
				//finally, fall back to the default format, if needed
				//(it may still be null, though)
				textFormat = this._format;
			}
			return textFormat;
		}

		/**
		 * @private
		 */
		protected function format_changeHandler(event:Event):void
		{
			this.dispatchEventWith(Event.CHANGE);
		}
	}
}
