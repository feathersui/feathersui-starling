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
		 * @private
		 */
		protected static const stack:Vector.<IFocusManager> = new <IFocusManager>[];

		/**
		 * @private
		 */
		protected static var _defaultFocusManager:IFocusManager;

		/**
		 * Determines if the default focus manager is enabled.
		 */
		public static function get isEnabled():Boolean
		{
			return _defaultFocusManager != null;
		}

		/**
		 * @private
		 */
		public static function set isEnabled(value:Boolean):void
		{
			if((value && _defaultFocusManager != null) ||
				(!value && !_defaultFocusManager))
			{
				return;
			}
			if(value)
			{
				_defaultFocusManager = pushFocusManager();
			}
			else if(_defaultFocusManager)
			{
				removeFocusManager(_defaultFocusManager);
				_defaultFocusManager = null;
			}
		}

		/**
		 * Adds a focus manager to the stack, and gives it exclusive focus.
		 */
		public static function pushFocusManager(manager:IFocusManager = null):IFocusManager
		{
			if(!manager)
			{
				manager = new FocusManager(null, false);
			}
			if(stack.length > 0)
			{
				const oldManager:IFocusManager = stack[stack.length - 1];
				oldManager.isEnabled = false;
			}
			stack.push(manager);
			manager.isEnabled = true;
			return manager;
		}

		/**
		 * Removes the specified focus manager from the stack. If it was
		 * the top-most focus manager, the new top-most focus manager is
		 * enabled,
		 */
		public static function removeFocusManager(manager:IFocusManager):void
		{
			const index:int = stack.indexOf(manager);
			if(index < 0)
			{
				return;
			}
			manager.isEnabled = false;
			stack.splice(index, 1);
			if(index > 0 && index == stack.length)
			{
				manager = stack[stack.length - 1];
				manager.isEnabled = true;
			}
		}

		/**
		 * Removes the top-most focus manager from the stack and returns
		 * exclusive focus to the manager below it.
		 */
		public static function popFocusManager():void
		{
			if(stack.length == 0)
			{
				return;
			}
			const manager:IFocusManager = stack[stack.length - 1];
			removeFocusManager(manager);
		}

		/**
		 * Constructor.
		 */
		public function FocusManager(topLevelContainer:DisplayObjectContainer = null, enableImmediately:Boolean = true)
		{
			if(!topLevelContainer)
			{
				topLevelContainer = Starling.current.stage;
			}
			this._topLevelContainer = topLevelContainer;
			this.setFocusManager(this._topLevelContainer);
			this.isEnabled = enableImmediately;
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
				if(stack.indexOf(this) < 0)
				{
					pushFocusManager(this);
				}
				this._topLevelContainer.addEventListener(Event.ADDED, topLevelContainer_addedHandler);
				this._topLevelContainer.addEventListener(Event.REMOVED, topLevelContainer_removedHandler);
				Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, topLevelContainer_keyDownHandler);
				this.focus = this._savedFocus;
				this._savedFocus = null;
			}
			else
			{
				this._topLevelContainer.removeEventListener(Event.ADDED, topLevelContainer_addedHandler);
				this._topLevelContainer.removeEventListener(Event.REMOVED, topLevelContainer_removedHandler);
				Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, topLevelContainer_keyDownHandler);
				const focusToSave:IFocusDisplayObject = this.focus;
				this.focus = null;
				this._savedFocus = focusToSave;
			}
		}

		/**
		 * @private
		 */
		protected var _savedFocus:IFocusDisplayObject;

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
				this._focus = null;
			}
			if(this._isEnabled)
			{
				this._focus = value;
				if(this._focus)
				{
					this._focus.dispatchEventWith(FeathersEventType.FOCUS_IN);
				}
			}
			else
			{
				this._savedFocus = value;
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
			else if(target is DisplayObjectContainer)
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
