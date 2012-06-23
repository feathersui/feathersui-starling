package org.josht.starling.foxhole.controls.supportClasses
{
	import org.osflash.signals.ISignal;

	[ExcludeClass]
	public interface IViewPort
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

		function get onResize():ISignal;
	}
}
