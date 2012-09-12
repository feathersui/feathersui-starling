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
	 * <code>ListCollection</code>.
	 * 
	 * @see ListCollection
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
	}
}