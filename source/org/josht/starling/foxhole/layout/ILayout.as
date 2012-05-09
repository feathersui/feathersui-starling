package org.josht.starling.foxhole.layout
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.josht.starling.foxhole.data.ListCollection;

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
		function layout(items:ListCollection, suggestedBounds:Rectangle, resultDimensions:Point = null):Point;
	}
}
