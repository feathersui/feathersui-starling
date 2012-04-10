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
package org.josht.starling.foxhole.controls
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * The default item renderer for List.
	 * 
	 * @see List
	 */
	public class SimpleItemRenderer extends Button implements IListItemRenderer
	{
		/**
		 * @private
		 */
		private static const DOWN_STATE_DELAY_MS:int = 250;
		
		/**
		 * Constructor.
		 */
		public function SimpleItemRenderer()
		{
			super();
			this.isToggle = true;
		}
		
		/**
		 * @private
		 */
		private var _data:Object;
		
		/**
		 * @inheritDoc
		 */
		public function get data():Object
		{
			return this._data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		private var _index:int;
		
		/**
		 * @inheritDoc
		 */
		public function get index():int
		{
			return this._index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		/**
		 * @private
		 */
		private var _owner:List;
		
		/**
		 * @inheritDoc
		 */
		public function get owner():List
		{
			return this._owner;
		}
		
		/**
		 * @private
		 */
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				this._owner.onScroll.remove(owner_onScroll);
			}
			this._owner = value;
			if(this._owner)
			{
				this._owner.onScroll.add(owner_onScroll);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		private var _delayedCurrentState:String;
		
		/**
		 * @private
		 */
		private var _stateDelayTimer:Timer;
		
		/**
		 * @private
		 */
		override protected function set currentState(value:String):void
		{
			if(this._stateDelayTimer)
			{
				this._delayedCurrentState = value;
				return;
			}
			else if(!this._stateDelayTimer && value.toLowerCase().indexOf("down") >= 0)
			{
				this._delayedCurrentState = value;
				this._stateDelayTimer = new Timer(DOWN_STATE_DELAY_MS, 1);
				this._stateDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
				this._stateDelayTimer.start();
				return;
			}
			super.currentState = value;
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(dataInvalid)
			{
				if(this._owner)
				{
					this._label = this._owner.itemToLabel(this._data);
				}
				else
				{
					this._label = "";
				}
			}
			super.draw();
		}
		
		/**
		 * @private
		 */
		protected function owner_onScroll(list:List):void
		{
			const state:String = this.isSelected ? Button.STATE_SELECTED_UP : Button.STATE_UP;
			if(this._currentState != state)
			{
				super.currentState = state;
			}
			this._touchPointID = -1;
			if(!this._stateDelayTimer)
			{
				return;
			}
			this._delayedCurrentState = null;
			this._stateDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
			this._stateDelayTimer.stop();
			this._stateDelayTimer = null;
		}
		
		/**
		 * @private
		 */
		private function stateDelayTimer_timerCompleteHandler(event:TimerEvent):void
		{
			this._stateDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
			this._stateDelayTimer = null;
			super.currentState = this._delayedCurrentState;
			this._delayedCurrentState = null;
		}
	}
}