/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups
{
	import feathers.controls.Callout;

	import flash.errors.IllegalOperationError;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * @inheritDoc
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * Displays pop-up content (such as the List in a PickerList) in a Callout.
	 *
	 * @see PickerList
	 */
	public class CalloutPopUpContentManager extends EventDispatcher implements IPopUpContentManager
	{
		/**
		 * Constructor.
		 */
		public function CalloutPopUpContentManager()
		{
		}

		/**
		 * @private
		 */
		protected var content:DisplayObject;

		/**
		 * @private
		 */
		protected var callout:Callout;

		/**
		 * @inheritDoc
		 */
		public function open(content:DisplayObject, source:DisplayObject):void
		{
			if(this.content)
			{
				throw new IllegalOperationError("Pop-up content is already defined.");
			}

			this.content = content;
			this.callout = Callout.show(content, source);
			this.callout.addEventListener(Event.CLOSE, callout_closeHandler);
		}

		/**
		 * @inheritDoc
		 */
		public function close():void
		{
			if(!this.callout)
			{
				return;
			}
			this.callout.close();
		}

		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			this.close();
		}

		/**
		 * @private
		 */
		protected function cleanup():void
		{
			this.content = null;
			this.callout.content = null;
			this.callout.removeEventListener(Event.CLOSE, callout_closeHandler);
			this.callout = null;
		}

		/**
		 * @private
		 */
		protected function callout_closeHandler(event:Event):void
		{
			this.cleanup();
			this.dispatchEventWith(Event.CLOSE);
		}
	}
}
