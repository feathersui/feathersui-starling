/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.events
{
	import feathers.dragDrop.DragData;

	import starling.events.Event;

	public class DragDropEvent extends Event
	{
		public static const DRAG_START:String = "dragStart";
		public static const DRAG_COMPLETE:String = "dragComplete";
		public static const DRAG_ENTER:String = "dragEnter";
		public static const DRAG_MOVE:String = "dragMove";
		public static const DRAG_EXIT:String = "dragExit";
		public static const DRAG_DROP:String = "dragDrop";

		public function DragDropEvent(type:String, dragData:DragData, isDropped:Boolean, localX:Number = NaN, localY:Number = NaN)
		{
			super(type, false, dragData);
			this.isDropped = isDropped;
			this.localX = localX;
			this.localY = localY;
		}

		public function get dragData():DragData
		{
			return DragData(this.data);
		}

		public var isDropped:Boolean;
		public var localX:Number;
		public var localY:Number;
	}
}
