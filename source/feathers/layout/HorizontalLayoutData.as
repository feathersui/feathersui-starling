/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * @inheritDoc
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Extra, optional data used by an <code>HorizontalLayout</code> instance to
	 * position and size a display object.
	 *
	 * @see HorizontalLayout
	 * @see ILayoutDisplayObject
	 *
	 * @productversion Feathers 1.3.0
	 */
	public class HorizontalLayoutData extends EventDispatcher implements ILayoutData
	{
		/**
		 * Constructor.
		 */
		public function HorizontalLayoutData(percentWidth:Number = NaN, percentHeight:Number = NaN)
		{
			this._percentWidth = percentWidth;
			this._percentHeight = percentHeight;
		}

		/**
		 * @private
		 */
		protected var _percentWidth:Number;

		/**
		 * The width of the layout object, as a percentage of the container's
		 * width. The container will calculate the sum of all of its children
		 * with explicit pixel widths, and then the remaining space will be
		 * distributed to children with percent widths.
		 *
		 * <p>A percentage may be specified in the range from <code>0</code>
		 * to <code>100</code>. If the value is set to <code>NaN</code>, this
		 * property is ignored. It will also be ignored when the
		 * <code>useVirtualLayout</code> property of the
		 * <code>HorizontalLayout</code> is set to <code>false</code>.</p>
		 *
		 * @default NaN
		 */
		public function get percentWidth():Number
		{
			return this._percentWidth;
		}

		/**
		 * @private
		 */
		public function set percentWidth(value:Number):void
		{
			if(this._percentWidth == value)
			{
				return;
			}
			this._percentWidth = value;
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _percentHeight:Number;


		/**
		 * The height of the layout object, as a percentage of the container's
		 * height.
		 *
		 * <p>A percentage may be specified in the range from <code>0</code>
		 * to <code>100</code>. If the value is set to <code>NaN</code>, this
		 * property is ignored.</p>
		 *
		 * <p>Performance tip: If all items in your layout will have 100%
		 * height, it's better to set the <code>verticalAlign</code> property of
		 * the <code>HorizontalLayout</code> to
		 * <code>VerticalAlign.JUSTIFY</code>.</p>
		 *
		 * @default NaN
		 *
		 * @see feathers.layout.VerticalAlign.JUSTIFY
		 */
		public function get percentHeight():Number
		{
			return this._percentHeight;
		}

		/**
		 * @private
		 */
		public function set percentHeight(value:Number):void
		{
			if(this._percentHeight == value)
			{
				return;
			}
			this._percentHeight = value;
			this.dispatchEventWith(Event.CHANGE);
		}
	}
}
