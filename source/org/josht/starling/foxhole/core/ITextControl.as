package org.josht.starling.foxhole.core
{
	import flash.geom.Point;

	public interface ITextControl
	{
		function get text():String;
		function set text(value:String):void;

		function get baseline():Number;

		function measureText(result:Point = null):Point;
	}
}
