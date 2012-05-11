package org.josht.starling.foxhole.controls
{
	/**
	 * Interface to implement a pull down control for a advanced list.
	 */
	public interface IPullDownControl
	{
		function get currentState():String;

		/**
		 * @private
		 */
		function set currentState(value:String):void;
	}
}

