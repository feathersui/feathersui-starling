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
package feathers.layout
{
	import starling.display.DisplayObject;

	/**
	 * A virtual layout that supports variable item dimensions.
	 */
	public interface IVariableVirtualLayout extends IVirtualLayout
	{
		/**
		 * When the layout is virtualized, and this value is true, the items may
		 * have variable dimensions. If false, the items will all share the
		 * same dimensions as the typical item. Performance is better for
		 * layouts where all items have the same dimensions.
		 */
		function get hasVariableItemDimensions():Boolean;

		/**
		 * @private
		 */
		function set hasVariableItemDimensions(value:Boolean):void;

		/**
		 * Clears the cached dimensions for all virtualized indices.
		 */
		function resetVariableVirtualCache():void;

		/**
		 * Clears the cached dimensions for one specific virtualized index.
		 */
		function resetVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void;
	}
}
