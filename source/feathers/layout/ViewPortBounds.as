/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	/**
	 * Used by layout algorithms for determining the bounds in which to position
	 * and size items.
	 */
	public class ViewPortBounds
	{
		/**
		 * Constructor.
		 */
		public function ViewPortBounds()
		{

		}

		/**
		 * The x position of the view port, in pixels.
		 */
		public var x:Number = 0;

		/**
		 * The y position of the view port, in pixels.
		 */
		public var y:Number = 0;

		/**
		 * The horizontal scroll position of the view port, in pixels.
		 */
		public var scrollX:Number = 0;

		/**
		 * The vertical scroll position of the view port, in pixels.
		 */
		public var scrollY:Number = 0;

		/**
		 * The explicit width of the view port, in pixels. If <code>NaN</code>,
		 * there is no explicit width value.
		 */
		public var explicitWidth:Number = NaN;

		/**
		 * The explicit height of the view port, in pixels. If <code>NaN</code>,
		 * there is no explicit height value.
		 */
		public var explicitHeight:Number = NaN;

		/**
		 * The minimum width of the view port, in pixels. Should be 0 or
		 * a positive number less than infinity.
		 */
		public var minWidth:Number = 0;

		/**
		 * The minimum width of the view port, in pixels. Should be 0 or
		 * a positive number less than infinity.
		 */
		public var minHeight:Number = 0;

		/**
		 * The maximum width of the view port, in pixels. Should be 0 or
		 * a positive number, including infinity.
		 */
		public var maxWidth:Number = Number.POSITIVE_INFINITY;

		/**
		 * The maximum height of the view port, in pixels. Should be 0 or
		 * a positive number, including infinity.
		 */
		public var maxHeight:Number = Number.POSITIVE_INFINITY;
	}
}
