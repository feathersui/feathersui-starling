package org.josht.starling.foxhole.controls
{
	import org.osflash.signals.ISignal;

	/**
	 * Minimum requirements for a scroll bar to be usable with a <code>Scroller</code>
	 * component.
	 *
	 * @see Scroller
	 */
	public interface IScrollBar
	{
		function get minimum():Number;
		function set minimum(value:Number):void;
		function get maximum():Number;
		function set maximum(value:Number):void;
		function get value():Number;
		function set value(value:Number):void;
		function get step():Number;
		function set step(value:Number):void;
		function get pageStep():Number;
		function set pageStep(value:Number):void;

		function get onChange():ISignal;
	}
}
