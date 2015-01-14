/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import feathers.core.IFeathersDisplayObject;

	/**
	 * Dispatched when a property of the display object's layout data changes.
	 *
	 * @eventType feathers.events.FeathersEventType.LAYOUT_DATA_CHANGE
	 */
	[Event(name="layoutDataChange",type="starling.events.Event")]

	/**
	 * A display object that may be associated with extra data for use with
	 * advanced layouts.
	 */
	public interface ILayoutDisplayObject extends IFeathersDisplayObject
	{
		/**
		 * Extra parameters associated with this display object that will be
		 * used by the layout algorithm.
		 */
		function get layoutData():ILayoutData;

		/**
		 * @private
		 */
		function set layoutData(value:ILayoutData):void;

		/**
		 * Determines if the ILayout should use this object or ignore it.
		 *
		 * <p>In the following example, the display object is excluded from
		 * the layout:</p>
		 *
		 * <listing version="3.0">
		 * object.includeInLayout = false;</listing>
		 */
		function get includeInLayout():Boolean;

		/**
		 * @private
		 */
		function set includeInLayout(value:Boolean):void;
	}
}
