package feathers.controls.popups
{
	import org.osflash.signals.ISignal;

	import starling.display.DisplayObject;

	/**
	 * Automatically manages pop-up content layout and positioning.
	 */
	public interface IPopUpContentManager
	{
		/**
		 * Dispatched when the pop-up content closes.
		 */
		function get onClose():ISignal;

		/**
		 * Displays the pop-up content.
		 */
		function open(content:DisplayObject, source:DisplayObject):void;

		/**
		 * Closes the pop-up content. If it is not opened, nothing happens.
		 */
		function close():void;

		/**
		 * Cleans up the manager.
		 */
		function dispose():void;
	}
}
