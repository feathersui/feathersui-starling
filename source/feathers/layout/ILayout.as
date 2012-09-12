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
	import flash.geom.Point;

	import org.osflash.signals.ISignal;

	import starling.display.DisplayObject;

	/**
	 * Interface providing layout capabilities for containers.
	 */
	public interface ILayout
	{
		/**
		 * Dispatched when a property of the layout changes, indicating that a
		 * redraw is probably needed.
		 */
		function get onLayoutChange():ISignal;

		/**
		 * Positions (and possibly resizes) the supplied items within the
		 * optional bounds argument. If no bounds are specified, the layout
		 * algorithm will assume that the bounds start a 0,0 and have unbounded
		 * dimensions. Returns the actual bounds of the content, which may
		 * be different than the specified bounds.
		 *
		 * <p>Note: The items are <strong>not</strong> absolutely
		 * restricted to appear only within the bounds. The bounds can affect
		 * positioning, but the algorithm may very well ignore them completely.</p>
		 *
		 */
		function layout(items:Vector.<DisplayObject>, viewPortBounds:ViewPortBounds = null, result:LayoutBoundsResult = null):LayoutBoundsResult;


		/**
		 * Using the item dimensions, calculates a scroll position that will
		 * ensure that the item at a given index will be visible within the
		 * specified bounds.
		 */
		function getScrollPositionForIndex(index:int, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point;
	}
}
