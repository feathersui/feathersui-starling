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
	import feathers.controls.*;
	import feathers.core.IToggle;

	/**
	 * Interface to implement a renderer for a list item.
	 */
	public interface IListItemRenderer extends IToggle
	{
		/**
		 * An item from the list's data provider. The data may change if this
		 * item renderer is reused for a new item because it's no longer needed
		 * for the original item.
		 */
		function get data():Object;
		
		/**
		 * @private
		 */
		function set data(value:Object):void;
		
		/**
		 * The index (numeric position, starting from zero) of the item within
		 * the list's data provider. Like the <code>data</code> property, this
		 * value may change if this item renderer is reused by the list for a
		 * different item.
		 */
		function get index():int;
		
		/**
		 * @private
		 */
		function set index(value:int):void;
		
		/**
		 * The list that contains this item renderer.
		 */
		function get owner():List;
		
		/**
		 * @private
		 */
		function set owner(value:List):void;
	}
}