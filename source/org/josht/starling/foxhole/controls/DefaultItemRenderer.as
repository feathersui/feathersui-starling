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

	import org.josht.starling.foxhole.core.FoxholeControl;

	import starling.display.DisplayObject;

	/**
	 * The default item renderer for List.
	 * 
	 * @see List
	 */
	public class DefaultItemRenderer extends Button implements IListItemRenderer
	{
		/**
		 * @private
		 */
		private static const DOWN_STATE_DELAY_MS:int = 250;
		
		/**
		 * Constructor.
		 */
		public function DefaultItemRenderer()
		{
			super();
			this.isToggle = true;
			this.isQuickHitAreaEnabled = false;
		}

		/**
		 * @private
		 */
		protected var accessory:DisplayObject;
		
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
		private var _index:int = -1;
		
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
		protected var _delayedCurrentState:String;
		
		/**
		 * @private
		 */
		protected var _stateDelayTimer:Timer;

		/**
		 * @private
		 */
		protected var _useStateDelayTimer:Boolean = true;

		/**
		 * If true, the down state (and subsequent state changes) will be
		 * delayed to make scrolling look nicer.
		 */
		public function get useStateDelayTimer():Boolean
		{
			return _useStateDelayTimer;
		}

		/**
		 * @private
		 */
		public function set useStateDelayTimer(value:Boolean):void
		{
			this._useStateDelayTimer = value;
		}
		
		/**
		 * @private
		 */
		override protected function set currentState(value:String):void
		{
			if(this._useStateDelayTimer && this._stateDelayTimer)
			{
				this._delayedCurrentState = value;
				return;
			}
			else if(this._useStateDelayTimer && !this._stateDelayTimer && value.toLowerCase().indexOf("down") >= 0)
			{
				this._delayedCurrentState = value;
				this._stateDelayTimer = new Timer(DOWN_STATE_DELAY_MS, 1);
				this._stateDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
				this._stateDelayTimer.start();
				return;
			}

			//either we're not delaying states, or we're switching to a state
			//that isn't the down state (and we haven't delayed down)
			if(this._stateDelayTimer)
			{
				this._stateDelayTimer.stop();
				this._stateDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, stateDelayTimer_timerCompleteHandler);
				this._stateDelayTimer = null;
			}
			super.currentState = value;
		}

		/**
		 * @private
		 */
		private var _labelField:String = "label";

		/**
		 * The field in the item that contains the label text to be displayed by
		 * the renderer. If the item does not have this field, and a
		 * <code>labelFunction</code> is not defined, then the renderer will
		 * default to calling <code>toString()</code> on the item. To omit the
		 * label completely, either provide a custom item renderer without a
		 * label or define a <code>labelFunction</code> that returns an empty
		 * string.
		 *
		 * @see #labelFunction
		 */
		public function get labelField():String
		{
			return this._labelField;
		}

		/**
		 * @private
		 */
		public function set labelField(value:String):void
		{
			if(this._labelField == value)
			{
				return;
			}
			this._labelField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _labelFunction:Function;

		/**
		 * A function used to generate label text for a specific item. If this
		 * function is not null, then the <code>labelField</code> will be
		 * ignored.
		 *
		 * @see #labelField
		 */
		public function get labelFunction():Function
		{
			return this._labelFunction;
		}

		/**
		 * @private
		 */
		public function set labelFunction(value:Function):void
		{
			this._labelFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _iconField:String = "icon";

		/**
		 * The field in the item that contains the icon to be displayed next to
		 * the label in the renderer. If the item does not have this field, and
		 * an <code>iconFunction</code> is not defined, then the renderer will
		 * not display an icon.
		 *
		 * @see #iconFunction
		 */
		public function get iconField():String
		{
			return this._iconField;
		}

		/**
		 * @private
		 */
		public function set iconField(value:String):void
		{
			if(this._iconField == value)
			{
				return;
			}
			this._iconField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _iconFunction:Function;

		/**
		 * A function used to generate an icon for a specific item. If this
		 * function is not null, then the <code>iconField</code> will be
		 * ignored.
		 *
		 * @see #iconField
		 */
		public function get iconFunction():Function
		{
			return this._iconFunction;
		}

		/**
		 * @private
		 */
		public function set iconFunction(value:Function):void
		{
			this._iconFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _accessoryField:String = "accessory";

		/**
		 * The field in the item that contains the type of accessory to be
		 * displayed on the right of the renderer. If the item does not have
		 * this field, and an <code>accessoryFunction</code> is not defined,
		 * then the renderer will not display an accessory.
		 *
		 * @see #accessoryFunction
		 */
		public function get accessoryField():String
		{
			return this._accessoryField;
		}

		/**
		 * @private
		 */
		public function set accessoryField(value:String):void
		{
			if(this._accessoryField == value)
			{
				return;
			}
			this._accessoryField = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _accessoryFunction:Function;

		/**
		 * A function used to generate an accessory view for a specific item. If
		 * this function is not null, then the <code>accessoryField</code> will
		 * be ignored.
		 *
		 * @see #accessoryField
		 */
		public function get accessoryFunction():Function
		{
			return this._accessoryFunction;
		}

		/**
		 * @private
		 */
		public function set accessoryFunction(value:Function):void
		{
			this._accessoryFunction = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * Using <code>labelField</code> and <code>labelFunction</code>,
		 * generates a label from the item.
		 */
		public function itemToLabel(item:Object):String
		{
			if(this._labelFunction != null)
			{
				return this._labelFunction(item) as String;
			}
			else if(this._labelField != null && item && item.hasOwnProperty(this._labelField))
			{
				return item[this._labelField] as String;
			}
			else if(item is Object)
			{
				return item.toString();
			}
			return "";
		}

		/**
		 * Using <code>iconField</code> and <code>iconFunction</code>,
		 * generates an icon from the item.
		 */
		public function itemToIcon(item:Object):DisplayObject
		{
			if(this._iconFunction != null)
			{
				return this._iconFunction(item) as DisplayObject;
			}
			else if(this._iconField != null && item && item.hasOwnProperty(this._iconField))
			{
				return item[this._iconField] as DisplayObject;
			}

			return null;
		}

		/**
		 * Using <code>accessoryField</code> and <code>accessoryFunction</code>,
		 * generates an accessory view for the item.
		 */
		public function itemToAccessory(item:Object):DisplayObject
		{
			if(this._accessoryFunction != null)
			{
				return this._accessoryFunction(item) as DisplayObject;
			}
			else if(this._accessoryField != null && item && item.hasOwnProperty(this._accessoryField))
			{
				return item[this._accessoryField] as DisplayObject;
			}

			return null;
		}
		
		/**
		 * @private
		 */
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(dataInvalid)
			{
				this.commitData();
			}
			super.draw();
		}

		/**
		 * @private
		 */
		protected function commitData():void
		{
			if(this._owner)
			{
				this._label = this.itemToLabel(this._data);
				this.defaultIcon = this.itemToIcon(this._data);
				var newAccessory:DisplayObject = this.itemToAccessory(this._data);
				if(newAccessory != this.accessory)
				{
					if(this.accessory)
					{
						this.accessory.removeFromParent();
					}
					this.accessory = newAccessory;
					this.addChild(this.accessory);
				}
			}
			else
			{
				this._label = "";
				this.defaultIcon = null;
				if(this.accessory)
				{
					this.accessory.removeFromParent();
					this.accessory = null;
				}
			}
		}


		/**
		 * @private
		 */
		override protected function layoutContent():void
		{
			super.layoutContent();
			if(!this.accessory)
			{
				return;
			}
			if(this.accessory is FoxholeControl)
			{
				FoxholeControl(this.accessory).validate();
			}
			this.accessory.x = this.actualWidth - this._paddingRight - this.accessory.width;
			this.accessory.y = (this.actualHeight - this.accessory.height) / 2;
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