/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.supportClasses
{
	import feathers.core.IFeathersControl;

	[ExcludeClass]
	public interface IViewPort extends IFeathersControl
	{
		function get visibleWidth():Number;
		function set visibleWidth(value:Number):void;
		function get minVisibleWidth():Number;
		function set minVisibleWidth(value:Number):void;
		function get maxVisibleWidth():Number;
		function set maxVisibleWidth(value:Number):void;
		function get visibleHeight():Number;
		function set visibleHeight(value:Number):void;
		function get minVisibleHeight():Number;
		function set minVisibleHeight(value:Number):void;
		function get maxVisibleHeight():Number;
		function set maxVisibleHeight(value:Number):void;

		function get contentX():Number;
		function get contentY():Number;

		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;
		function get horizontalScrollStep():Number;
		function get verticalScrollStep():Number;
	}
}
