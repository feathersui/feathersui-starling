/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.controls.popups
{
	import flash.errors.IllegalOperationError;

	import feathers.controls.*;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

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
