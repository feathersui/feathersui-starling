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
package feathers.controls.renderers
{
	import feathers.controls.GroupedList;

	/**
	 * Interface to implement a renderer for a grouped list header or footer.
	 */
	public interface IGroupedListHeaderOrFooterRenderer
	{
		/**
		 * Data for a header or footer from the grouped list's data provider.
		 * The data may change if this renderer is reused for a new header or
		 * footer because it's no longer needed for the original data.
		 */
		function get data():Object;

		/**
		 * @private
		 */
		function set data(value:Object):void;

		/**
		 * The index of the group within the data provider of the grouped list.
		 */
		function get groupIndex():int;

		/**
		 * @private
		 */
		function set groupIndex(value:int):void;

		/**
		 * The index of the item within the layout.
		 */
		function get layoutIndex():int;

		/**
		 * @private
		 */
		function set layoutIndex(value:int):void;

		/**
		 * The grouped list that contains this header or footer renderer.
		 */
		function get owner():GroupedList;

		/**
		 * @private
		 */
		function set owner(value:GroupedList):void;
	}
}
