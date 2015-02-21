/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * Dispatched when the suggestions finish loading.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>A <code>ListCollection</code> containing
	 *   the suggestions to display.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.COMPLETE
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * Creates a list of suggestions for an <code>AutoComplete</code> component
	 * by searching through items in a <code>ListCollection</code>.
	 *
	 * @see feathers.controls.AutoComplete
	 * @see feathers.data.ListCollection
	 */
	public class LocalAutoCompleteSource extends EventDispatcher implements IAutoCompleteSource
	{
		/**
		 * @private
		 */
		protected static function defaultCompareFunction(item:Object, textToMatch:String):Boolean
		{
			return item.toString().toLowerCase().indexOf(textToMatch.toLowerCase()) >= 0;
		}

		/**
		 * Constructor.
		 */
		public function LocalAutoCompleteSource(source:ListCollection = null)
		{
			this._dataProvider = source;
		}

		/**
		 * @private
		 */
		private var _dataProvider:ListCollection;

		/**
		 * A collection of items to be used as a source for auto-complete
		 * results.
		 */
		public function get dataProvider():ListCollection
		{
			return this._dataProvider;
		}

		/**
		 * @private
		 */
		public function set dataProvider(value:ListCollection):void
		{
			this._dataProvider = value;
		}

		/**
		 * @private
		 */
		protected var _compareFunction:Function = defaultCompareFunction;

		/**
		 * A function used to compare items from the data provider with the
		 * string passed to the <code>load()</code> function in order to
		 * generate a list of suggestions. The function should return
		 * <code>true</code> if the item should be included in the list of
		 * suggestions.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:Object, textToMatch:String ):Boolean</pre>
		 */
		public function get compareFunction():Function
		{
			return this._compareFunction;
		}

		/**
		 * @private
		 */
		public function set compareFunction(value:Function):void
		{
			if(value === null)
			{
				value = defaultCompareFunction;
			}
			this._compareFunction = value;
		}

		/**
		 * @copy feathers.data.IAutoCompleteSource#load()
		 */
		public function load(textToMatch:String, result:ListCollection = null):void
		{
			if(result)
			{
				result.removeAll();
			}
			else
			{
				result = new ListCollection();
			}
			if(!this._dataProvider || textToMatch.length == 0)
			{
				this.dispatchEventWith(Event.COMPLETE, false, result);
				return;
			}
			var compareFunction:Function = this._compareFunction;
			for(var i:int = 0; i < this._dataProvider.length; i++)
			{
				var item:Object = this._dataProvider.getItemAt(i);
				if(compareFunction(item, textToMatch))
				{
					result.addItem(item);
				}
			}
			this.dispatchEventWith(Event.COMPLETE, false, result);
		}
	}
}
