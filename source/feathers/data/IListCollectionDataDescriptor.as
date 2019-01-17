/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	/**
	 * An adapter interface to support any kind of data source in
	 * <code>ListCollection</code>.
	 * 
	 * @see ListCollection
	 *
	 * @productversion Feathers 1.0.0
	 */
	public interface IListCollectionDataDescriptor
	{
		/**
		 * The number of items in the data source.
		 */
		function getLength(data:Object):int;
		
		/**
		 * Returns the item at the specified index in the data source.
		 */
		function getItemAt(data:Object, index:int):Object;
		
		/**
		 * Replaces the item at the specified index with a new item.
		 */
		function setItemAt(data:Object, item:Object, index:int):void;
		
		/**
		 * Adds an item to the data source, at the specified index.
		 */
		function addItemAt(data:Object, item:Object, index:int):void;
		
		/**
		 * Removes the item at the specified index from the data source and
		 * returns it.
		 */
		function removeItemAt(data:Object, index:int):Object;
		
		/**
		 * Determines which index the item appears at within the data source. If
		 * the item isn't in the data source, returns <code>-1</code>.
		 */
		function getItemIndex(data:Object, item:Object):int;

		/**
		 * Removes all items from the data source.
		 */
		function removeAll(data:Object):void;
	}
}