/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.events.FeathersEventType;

	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.KeyboardEvent;

	/**
	 * Manages touch and keyboard focus.
	 */
	public class FocusManager implements IFocusManager
	{
		/**
		 * Constructor.
		 */
		public function FocusManager(topLevelContainer:DisplayObjectContainer)
		{
			this._topLevelContainer = topLevelContainer;
			this.isEnabled = true;
		}

		/**
		 * @private
		 */
		protected var _topLevelContainer:DisplayObjectContainer;

		/**
		 * @private
		 */
		protected var _isEnabled:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function get isEnabled():Boolean
		{
			return this._isEnabled;
		}

		/**
		 * @private
		 */
		public function set isEnabled(value:Boolean):void
		{
			if(this._isEnabled == value)
			{
				return;
			}
			this._isEnabled = value;
			if(this._isEnabled)
			{
				this._topLevelContainer.addEventListener(Event.ADDED, topLevelContainer_addedHandler);
				this._topLevelContainer.addEventListener(Event.REMOVED, topLevelContainer_removedHandler);
				Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, topLevelContainer_keyDownHandler);
				this.setFocusManager(this._topLevelContainer);
			}
			else
			{
				this._topLevelContainer.removeEventListener(Event.ADDED, topLevelContainer_addedHandler);
				this._topLevelContainer.removeEventListener(Event.REMOVED, topLevelContainer_removedHandler);
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, topLevelContainer_keyDownHandler);
				this.clearFocusManager(this._topLevelContainer);
			}
		}

		/**
		 * @private
		 */
		protected var _focus:IFocusDisplayObject;

		/**
		 * @inheritDoc
		 */
		public function get focus():IFocusDisplayObject
		{
			return this._focus;
		}

		/**
		 * @private
		 */
		public function set focus(value:IFocusDisplayObject):void
		{
			if(this._focus == value)
			{
				return;
			}
			if(this._focus)
			{
				this._focus.dispatchEventWith(FeathersEventType.FOCUS_OUT);
			}
			this._focus = value;
			if(this._focus)
			{
				this._focus.dispatchEventWith(FeathersEventType.FOCUS_IN);
			}
		}

		/**
		 * @private
		 */
		protected function setFocusManager(target:DisplayObject):void
		{
			if(target is IFocusDisplayObject)
			{
				const targetWithFocus:IFocusDisplayObject = IFocusDisplayObject(target);
				targetWithFocus.focusManager = this;
			}
			if(target is DisplayObjectContainer)
			{
				const container:DisplayObjectContainer = DisplayObjectContainer(target);
				const childCount:int = container.numChildren;
				for(var i:int = 0; i < childCount; i++)
				{
					var child:DisplayObject = container.getChildAt(i);
					this.setFocusManager(child);
				}
			}
		}

		/**
		 * @private
		 */
		protected function clearFocusManager(target:DisplayObject):void
		{
			if(target is IFocusDisplayObject)
			{
				const targetWithFocus:IFocusDisplayObject = IFocusDisplayObject(target);
				targetWithFocus.focusManager = null;
			}
			if(target is DisplayObjectContainer)
			{
				const container:DisplayObjectContainer = DisplayObjectContainer(target);
				const childCount:int = container.numChildren;
				for(var i:int = 0; i < childCount; i++)
				{
					var child:DisplayObject = container.getChildAt(i);
					this.clearFocusManager(child);
				}
			}
		}

		/**
		 * @private
		 */
		protected function findNextFocus(container:DisplayObjectContainer, afterChild:DisplayObject = null):IFocusDisplayObject
		{
			var startIndex:int = 0;
			if(afterChild)
			{
				startIndex = container.getChildIndex(afterChild) + 1;
			}
			const childCount:int = container.numChildren;
			for(var i:int = startIndex; i < childCount; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				if(child is IFocusDisplayObject)
				{
					var childWithFocus:IFocusDisplayObject = IFocusDisplayObject(child);
					if(childWithFocus.isFocusEnabled)
					{
						return childWithFocus;
					}
				}
				if(child is DisplayObjectContainer)
				{
					var childContainer:DisplayObjectContainer = DisplayObjectContainer(child);
					var foundChild:IFocusDisplayObject = this.findNextFocus(childContainer);
					if(foundChild)
					{
						return foundChild;
					}
				}
			}

			if(afterChild && container != this._topLevelContainer)
			{
				return this.findNextFocus(container.parent, container);
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function topLevelContainer_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode != Keyboard.TAB)
			{
				return;
			}

			if(event.shiftKey)
			{

			}
			else
			{
				if(this._focus)
				{
					if(this._focus.nextTabFocus)
					{
						this.focus = this._focus.nextTabFocus;
						return;
					}
					else
					{
						var found:IFocusDisplayObject = this.findNextFocus(this._focus.parent, DisplayObject(this._focus));
						if(found)
						{
							this.focus = found;
							return;
						}
					}
				}
				this.focus = this.findNextFocus(this._topLevelContainer);
			}
		}

		/**
		 * @private
		 */
		protected function topLevelContainer_addedHandler(event:Event):void
		{
			this.setFocusManager(DisplayObject(event.target));
		}

		/**
		 * @private
		 */
		protected function topLevelContainer_removedHandler(event:Event):void
		{
			this.clearFocusManager(DisplayObject(event.target));
		}

	}
}
