/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.events
{
	import feathers.dragDrop.DragData;

	import starling.events.Event;

	/**
	 * Events used by the <code>DragDropManager</code>.
	 *
	 * @see feathers.dragDrop.DragDropManager
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class DragDropEvent extends Event
	{
		/**
		 * Dispatched by the <code>IDragSource</code> when a drag starts.
		 *
		 * @see feathers.dragDrop.IDragSource
		 */
		public static const DRAG_START:String = "dragStart";

		/**
		 * Dispatched by the <code>IDragSource</code> when a drag completes.
		 * This is always dispatched, even when there wasn't a successful drop.
		 * See the <code>isDropped</code> property to determine if the drop
		 * was successful.
		 *
		 * @see feathers.dragDrop.IDragSource
		 */
		public static const DRAG_COMPLETE:String = "dragComplete";

		/**
		 * Dispatched by a <code>IDropTarget</code> when a drag enters its
		 * bounds.
		 *
		 * @see feathers.dragDrop.IDropTarget
		 */
		public static const DRAG_ENTER:String = "dragEnter";

		/**
		 * Dispatched by a <code>IDropTarget</code> when a drag moves to a new
		 * location within its bounds.
		 *
		 * @see feathers.dragDrop.IDropTarget
		 */
		public static const DRAG_MOVE:String = "dragMove";

		/**
		 * Dispatched by a <code>IDropTarget</code> when a drag exits its
		 * bounds.
		 *
		 * @see feathers.dragDrop.IDropTarget
		 */
		public static const DRAG_EXIT:String = "dragExit";

		/**
		 * Dispatched by a <code>IDropTarget</code> when a drop occurs.
		 *
		 * @see feathers.dragDrop.IDropTarget
		 */
		public static const DRAG_DROP:String = "dragDrop";

		/**
		 * Constructor.
		 */
		public function DragDropEvent(type:String, dragData:DragData, isDropped:Boolean, localX:Number = NaN, localY:Number = NaN)
		{
			super(type, false, dragData);
			this.isDropped = isDropped;
			this.localX = localX;
			this.localY = localY;
		}

		/**
		 * The <code>DragData</code> associated with the current drag.
		 */
		public function get dragData():DragData
		{
			return DragData(this.data);
		}

		/**
		 * Determines if there has been a drop.
		 */
		public var isDropped:Boolean;

		/**
		 * The x location, in pixels, of the current action, in the local
		 * coordinate system of the <code>IDropTarget</code>.
		 *
		 * @see feathers.dragDrop.IDropTarget
		 */
		public var localX:Number;

		/**
		 * The y location, in pixels, of the current action, in the local
		 * coordinate system of the <code>IDropTarget</code>.
		 *
		 * @see feathers.dragDrop.IDropTarget
		 */
		public var localY:Number;
	}
}
