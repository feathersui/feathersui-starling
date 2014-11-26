/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.autoComplete
{
	import feathers.data.ListCollection;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	[Event(name="complete",type="starling.events.Event")]

	/**
	 * Returns auto-complete results by searching through items in a <code>ListCollection</code>.
	 *
	 * @see feathers.data.ListCollection
	 */
	public class LocalAutoCompleteSource extends EventDispatcher implements IAutoCompleteSource
	{
		/**
		 * Constructor.
		 */
		public function LocalAutoCompleteSource(source:ListCollection = null)
		{
			this._source = source;
		}

		/**
		 * @private
		 */
		private var _source:ListCollection;

		/**
		 * A collection of items to be used as a source for auto-complete
		 * results.
		 */
		public function get source():ListCollection
		{
			return this._source;
		}

		/**
		 * @private
		 */
		public function set source(value:ListCollection):void
		{
			this._source = value;
		}

		/**
		 * @inheritDoc
		 */
		public function load(text:String, result:ListCollection = null):void
		{
			if(result)
			{
				result.removeAll();
			}
			else
			{
				result = new ListCollection();
			}
			if(!this._source || text.length == 0)
			{
				this.dispatchEventWith(Event.COMPLETE, false, result);
				return;
			}
			for(var i:int = 0; i < this._source.length; i++)
			{
				var item:Object = this._source.getItemAt(i);
				if(item.toString().toLowerCase().indexOf(text.toLowerCase()) >= 0)
				{
					result.push(item);
				}
			}
			this.dispatchEventWith(Event.COMPLETE, false, result);
		}
	}
}
