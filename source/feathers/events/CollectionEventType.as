/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.events
{
	/**
	 * Event <code>type</code> constants for collections. This class is
	 * not a subclass of <code>starling.events.Event</code> because these
	 * constants are meant to be used with <code>dispatchEventWith()</code> and
	 * take advantage of the Starling's event object pooling. The object passed
	 * to an event listener will be of type <code>starling.events.Event</code>.
	 *
	 * <listing version="3.0">
	 * function listener( event:Event ):void
	 * {
	 *     trace( "add item" );
	 * }
	 * collection.addEventListener( CollectionEventType.ADD_ITEM, listener );</listing>
	 */
	public class CollectionEventType
	{
		/**
		 * Dispatched when the data provider's source is completely replaced.
		 */
		public static const RESET:String = "reset";

		/**
		 * Dispatched when a filter has been applied to or removed from the
		 * collection. The underlying source remains the same, but zero or more
		 * items may have been removed or added.
		 */
		public static const FILTER_CHANGE:String = "filterChange";

		/**
		 * Dispatched when an item is added to the collection.
		 */
		public static const ADD_ITEM:String = "addItem";

		/**
		 * Dispatched when an item is removed from the collection.
		 */
		public static const REMOVE_ITEM:String = "removeItem";

		/**
		 * Dispatched when an item is replaced in the collection with a
		 * different item.
		 */
		public static const REPLACE_ITEM:String = "replaceItem";

		/**
		 * Dispatched when an item in the collection has changed.
		 */
		public static const UPDATE_ITEM:String = "updateItem";

		/**
		 * Dispatched when all existing items in the collection have changed
		 * (but they have not been replaced by different items).
		 */
		public static const UPDATE_ALL:String = "updateAll";
	}
}
