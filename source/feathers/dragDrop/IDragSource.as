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
package feathers.dragDrop
{
	import org.osflash.signals.ISignal;

	/**
	 * An object that can initiate drag actions with the drag and drop manager.
	 *
	 * @see DragDropManager
	 */
	public interface IDragSource
	{
		/**
		 * Dispatched when the drag and drop manager begins the drag.
		 *
		 * <p>A listener is expected to have the following function signature:</p>
		 * <pre>function(source:IDragSource, data:DragData):void</pre>
		 */
		function get onDragStart():ISignal;

		/**
		 * Dispatched when the drop has been completed or when the drag has been
		 * cancelled.
		 *
		 * <p>A listener is expected to have the following function signature:</p>
		 * <pre>function(source:IDragSource, data:DragData, isDropped:Boolean):void</pre>
		 */
		function get onDragComplete():ISignal;
	}
}
