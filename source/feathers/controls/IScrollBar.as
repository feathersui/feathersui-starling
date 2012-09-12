package feathers.controls
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
		/**
		 * The minimum value of the scroll bar.
		 */
		function get minimum():Number;

		/**
		 * @private
		 */
		function set minimum(value:Number):void;

		/**
		 * The maximum value of the scroll bar.
		 */
		function get maximum():Number;

		/**
		 * @private
		 */
		function set maximum(value:Number):void;

		/**
		 * The current value of the scroll bar.
		 */
		function get value():Number;

		/**
		 * @private
		 */
		function set value(value:Number):void;

		/**
		 * The amount the scroll bar value must change to increment or
		 * decrement.
		 */
		function get step():Number;

		/**
		 * @private
		 */
		function set step(value:Number):void;

		/**
		 * The amount the scroll bar value must change to get from one "page" to
		 * the next.
		 */
		function get page():Number;

		/**
		 * @private
		 */
		function set page(value:Number):void;

		/**
		 * Dispatched when the scroll bar's value changes.
		 */
		function get onChange():ISignal;
	}
}
