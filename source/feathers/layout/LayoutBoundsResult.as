/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	/**
	 * Calculated bounds for layout.
	 */
	public class LayoutBoundsResult
	{
		/**
		 * Constructor.
		 */
		public function LayoutBoundsResult()
		{

		}

		/**
		 * The visible width of the view port. The view port's content may be
		 * clipped.
		 */
		public var viewPortWidth:Number;

		/**
		 * The visible height of the view port. The view port's content may be
		 * clipped.
		 */
		public var viewPortHeight:Number;

		/**
		 * The width of the content. May be larger or smaller than the view
		 * port.
		 */
		public var contentWidth:Number;

		/**
		 * The height of the content. May be larger or smaller than the view
		 * port.
		 */
		public var contentHeight:Number;
	}
}
