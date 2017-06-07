/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

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
	 *
	 * @productversion Feathers 1.0.0
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
		 *
		 * <p>Calling <code>getLengthOfBranch()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function getLength(data:Object, ...rest:Array):int;

		/**
		 * The number of items at the specified location in the data source.
		 */
		function getLengthAtLocation(data:Object, location:Vector.<int> = null):int

		/**
		 * Returns the item at the specified location in the data source.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 * 
		 * <p>Calling <code>getItemAtLocation()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function getItemAt(data:Object, index:int, ...rest:Array):Object;

		/**
		 * Returns the item at the specified location in the data source.
		 */
		function getItemAtLocation(data:Object, location:Vector.<int>):Object;

		/**
		 * Replaces the item at the specified location with a new item.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 *
		 * <p>Calling <code>setItemAtLocation()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function setItemAt(data:Object, item:Object, index:int, ...rest:Array):void;

		/**
		 * Replaces the item at the specified location with a new item.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 */
		function setItemAtLocation(data:Object, item:Object, location:Vector.<int>):void;

		/**
		 * Adds an item to the data source, at the specified location.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 *
		 * <p>Calling <code>addItemAtLocation()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function addItemAt(data:Object, item:Object, index:int, ...rest:Array):void;

		/**
		 * Adds an item to the data source, at the specified location.
		 */
		function addItemAtLocation(data:Object, item:Object, location:Vector.<int>):void;

		/**
		 * Removes the item at the specified location from the data source and
		 * returns it.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 */
		function removeItemAt(data:Object, index:int, ...rest:Array):Object;

		/**
		 * Removes the item at the specified location from the data source and
		 * returns it.
		 *
		 * <p>The rest arguments are the indices that make up the location.</p>
		 *
		 * <p>Calling <code>removeItemAtLocation()</code> instead is recommended
		 * because the <code>Vector.&lt;int&gt;</code> location may be reused to
		 * avoid excessive garbage collection from temporary objects created by
		 * <code>...rest</code> arguments.</p>
		 */
		function removeItemAtLocation(data:Object, location:Vector.<int>):Object;

		/**
		 * Removes all items from the data source.
		 */
		function removeAll(data:Object):void;

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
