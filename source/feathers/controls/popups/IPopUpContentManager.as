package feathers.controls.popups
{
	import starling.display.DisplayObject;

	/**
	 * Dispatched when the pop-up content closes.
	 *
	 * @eventType starling.events.Event.CLOSE
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * Automatically manages pop-up content layout and positioning.
	 */
	public interface IPopUpContentManager
	{
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
