package org.josht.starling.foxhole.core
{
	import flash.geom.Point;

	public interface ITextControl
	{
		/**
		 * The text to display.
		 */
		function get text():String;

		/**
		 * @private
		 */
		function set text(value:String):void;

		/**
		 * The baseline measurement of the text.
		 */
		function get baseline():Number;

		/**
		 *
		 * @param result
		 * @return
		 */
		function measureText(result:Point = null):Point;
	}
}
