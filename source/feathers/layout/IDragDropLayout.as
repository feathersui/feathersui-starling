/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	import starling.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * Methods for layouts that support drag and drop.
	 */
	public interface IDragDropLayout
	{
		/**
		 * Returns the index of the item if it were dropped at the specified
		 * location.
		 */
		function getDropIndex(x:Number, y:Number, items:Vector.<DisplayObject>,
			boundsX:Number, boundsY:Number, width:Number, height:Number):int;

		/**
		 * Returns the region at the edge of an item where the drop indicator
		 * should be positioned.
		 */
		function getDropRegion(index:int, items:Vector.<DisplayObject>, result:Rectangle = null):Rectangle
	}
}