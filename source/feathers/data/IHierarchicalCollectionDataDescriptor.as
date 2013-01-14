/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	/**
	 * An adapter interface to support any kind of data source in
	 * hierarchical collections.
	 *
	 * @see HierarchicalCollection
	 */
	public interface IHierarchicalCollectionDataDescriptor
	{
		/**
		 * Determines if a node from the data source is a branch.
		 */
		function isBranch(node:Object):Boolean;

		/**
		 * The number of items at the specified location in the data source.
		 *
		 * <p>The rest arguments are the indices that make up the location. If
		 * a location is omitted, the length returned will be for the root level
		 * of the collection.</p>
		 */
		function getLength(data:Object, ...rest:Array):int;

		/**
		 * Returns the item at the specified location in the data source.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 */
		function getItemAt(data:Object, index:int, ...rest:Array):Object;

		/**
		 * Replaces the item at the specified location with a new item.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 */
		function setItemAt(data:Object, item:Object, index:int, ...rest:Array):void;

		/**
		 * Adds an item to the data source, at the specified location.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 */
		function addItemAt(data:Object, item:Object, index:int, ...rest:Array):void;

		/**
		 * Removes the item at the specified location from the data source and
		 * returns it.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 */
		function removeItemAt(data:Object, index:int, ...rest:Array):Object;

		/**
		 * Determines which location the item appears at within the data source.
		 * If the item isn't in the data source, returns an empty <code>Vector.&lt;int&gt;</code>.
		 *
		 * <p>The <code>rest</code> arguments are optional indices to narrow
		 * the search.</p>
		 */
		function getItemLocation(data:Object, item:Object, result:Vector.<int> = null, ...rest:Array):Vector.<int>;
	}
}
