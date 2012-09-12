/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
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
