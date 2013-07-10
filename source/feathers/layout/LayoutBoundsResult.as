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
		 * The starting position of the view port's content on the x axis.
		 * Usually, this value is <code>0</code>, but it may be negative.
		 * negative.
		 */
		public var contentX:Number = 0;

		/**
		 * The starting position of the view port's content on the y axis.
		 * Usually, this value is <code>0</code>, but it may be negative.
		 */
		public var contentY:Number = 0;

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
