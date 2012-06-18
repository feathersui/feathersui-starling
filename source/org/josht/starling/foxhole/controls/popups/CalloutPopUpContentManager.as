package org.josht.starling.foxhole.controls.popups
{
	import org.josht.starling.foxhole.controls.*;
	import flash.errors.IllegalOperationError;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.core.Starling;
	import starling.display.DisplayObject;

	/**
	 * Displays pop-up content (such as the List in a PickerList) in a Callout.
	 *
	 * @see PickerList
	 */
	public class CalloutPopUpContentManager implements IPopUpContentManager
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
		 * @private
		 */
		private var _onClose:Signal = new Signal(CalloutPopUpContentManager);

		/**
		 * @inheritDoc
		 */
		public function get onClose():ISignal
		{
			return this._onClose;
		}

		/**
		 * @inheritDoc
		 */
		public function open(content:DisplayObject, source:DisplayObject):void
		{
			if(this.content)
			{
				throw new IllegalOperationError("Pop-up content is already defined.")
			}

			this.content = content;
			this.callout = Callout.show(content, source);
			this.callout.onClose.add(callout_onClose);
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
			this._onClose.removeAll();
		}

		/**
		 * @private
		 */
		protected function cleanup():void
		{
			this.content = null;
			this.callout.content = null;
			this.callout.onClose.remove(callout_onClose);
			this.callout = null;
		}

		/**
		 * @private
		 */
		protected function callout_onClose(callout:Callout):void
		{
			this.cleanup();
			this._onClose.dispatch(this);
		}
	}
}
