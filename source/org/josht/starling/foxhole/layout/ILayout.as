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
package org.josht.starling.foxhole.layout
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

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
		 * specified bounds. The items are <strong>not</strong> absolutely
		 * restricted to appear only within the bounds. The bounds can affect
		 * positioning, but the algorithm may very well ignore them completely.
		 * Returns the actual bounds of the content.
		 */
		function layout(items:Vector.<DisplayObject>, suggestedBounds:Rectangle, resultDimensions:Point = null):Point;
	}
}
