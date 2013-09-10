/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.events.FeathersEventType;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.FocusEvent;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Manages touch and keyboard focus.
	 *
	 * <p>Note: When enabling focus management, you should always use
	 * <code>TextFieldTextEditor</code> as the text editor for <code>TextInput</code>
	 * components. <code>StageTextTextEditor</code> is not compatible with the
	 * focus manager.</p>
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
		 * @private
		 */
		protected static var _nativeFocusTarget:Sprite;

		/**
		 * Determines if the default focus manager is enabled. For mobile apps,
		 * the focus manager should generally remain disabled. For desktop apps,
		 * it is recommended to enable the focus manager to support keyboard
		 * navigation.
		 *
		 * <p>In the following example, focus management is enabled:</p>
		 *
		 * <listing version="3.0">
		 * FocusManager.isEnabled = true;</listing>
		 *
		 * @default false
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

				//we need a native display object on the native stage to receive
				//key focus change events!
				_nativeFocusTarget = new Sprite();
				_nativeFocusTarget.tabEnabled = true;
				_nativeFocusTarget.mouseEnabled = false;
				_nativeFocusTarget.mouseChildren = false;
				_nativeFocusTarget.alpha = 0;
				Starling.current.nativeOverlay.addChild(_nativeFocusTarget);
			}
			else
			{
				if(_nativeFocusTarget)
				{
					_nativeFocusTarget.parent.removeChild(_nativeFocusTarget);
					_nativeFocusTarget = null;
				}
				if(_defaultFocusManager)
				{
					removeFocusManager(_defaultFocusManager);
					_defaultFocusManager = null;
				}
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
		 *
		 * @default false
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
				this._topLevelContainer.addEventListener(TouchEvent.TOUCH, topLevelContainer_touchHandler);
				Starling.current.nativeStage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, stage_keyFocusChangeHandler, false, 0, true);
				Starling.current.nativeStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, stage_mouseFocusChangeHandler, false, 0, true);
				this.focus = this._savedFocus;
				this._savedFocus = null;
			}
			else
			{
				this._topLevelContainer.removeEventListener(Event.ADDED, topLevelContainer_addedHandler);
				this._topLevelContainer.removeEventListener(Event.REMOVED, topLevelContainer_removedHandler);
				this._topLevelContainer.removeEventListener(TouchEvent.TOUCH, topLevelContainer_touchHandler);
				Starling.current.nativeStage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, stage_keyFocusChangeHandler);
				Starling.current.nativeStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, stage_mouseFocusChangeHandler);
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
		 *
		 * @default null
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
				this._focus.removeEventListener(Event.REMOVED_FROM_STAGE, focus_removedFromStageHandler);
				this._focus.dispatchEventWith(FeathersEventType.FOCUS_OUT);
				this._focus = null;
			}
			if(!value || !value.isFocusEnabled)
			{
				this._focus = null;
				return;
			}
			if(this._isEnabled)
			{
				this._focus = value;
				if(this._focus)
				{
					const nativeStage:Stage = Starling.current.nativeStage;
					if(!nativeStage.focus)
					{
						nativeStage.focus = _nativeFocusTarget;
					}
					this._focus.addEventListener(Event.REMOVED_FROM_STAGE, focus_removedFromStageHandler);
					this._focus.dispatchEventWith(FeathersEventType.FOCUS_IN);
				}
				else
				{
					Starling.current.nativeStage.focus = null;
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
		protected function findPreviousFocus(container:DisplayObjectContainer, beforeChild:DisplayObject = null):IFocusDisplayObject
		{
			if(container is LayoutViewPort)
			{
				container = container.parent;
			}
			var hasProcessedBeforeChild:Boolean = beforeChild == null;
			if(container is IFocusExtras)
			{
				var focusContainer:IFocusExtras = IFocusExtras(container);
				var extras:Vector.<DisplayObject> = focusContainer.focusExtrasAfter;
				if(extras)
				{
					var skip:Boolean = false;
					if(beforeChild)
					{
						var startIndex:int = extras.indexOf(beforeChild) - 1;
						hasProcessedBeforeChild = startIndex >= -1;
						skip = !hasProcessedBeforeChild;
					}
					else
					{
						startIndex = extras.length - 1;
					}
					if(!skip)
					{
						for(var i:int = startIndex; i >= 0; i--)
						{
							var child:DisplayObject = extras[i];
							var foundChild:IFocusDisplayObject = this.findPreviousChildFocus(child);
							if(foundChild)
							{
								return foundChild;
							}
						}
					}
				}
			}
			if(beforeChild && !hasProcessedBeforeChild)
			{
				startIndex = container.getChildIndex(beforeChild) - 1;
				hasProcessedBeforeChild = startIndex >= -1;
			}
			else
			{
				startIndex = container.numChildren - 1;
			}
			for(i = startIndex; i >= 0; i--)
			{
				child = container.getChildAt(i);
				foundChild = this.findPreviousChildFocus(child);
				if(foundChild)
				{
					return foundChild;
				}
			}
			if(container is IFocusExtras)
			{
				extras = focusContainer.focusExtrasBefore;
				if(extras)
				{
					skip = false;
					if(beforeChild && !hasProcessedBeforeChild)
					{
						startIndex = extras.indexOf(beforeChild) - 1;
						hasProcessedBeforeChild = startIndex >= -1;
						skip = !hasProcessedBeforeChild;
					}
					else
					{
						startIndex = extras.length - 1;
					}
					if(!skip)
					{
						for(i = startIndex; i >= 0; i--)
						{
							child = extras[i];
							foundChild = this.findPreviousChildFocus(child);
							if(foundChild)
							{
								return foundChild;
							}
						}
					}
				}
			}

			if(beforeChild && container != this._topLevelContainer)
			{
				return this.findPreviousFocus(container.parent, container);
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function findNextFocus(container:DisplayObjectContainer, afterChild:DisplayObject = null):IFocusDisplayObject
		{
			if(container is LayoutViewPort)
			{
				container = container.parent;
			}
			var hasProcessedAfterChild:Boolean = afterChild == null;
			if(container is IFocusExtras)
			{
				var focusContainer:IFocusExtras = IFocusExtras(container);
				var extras:Vector.<DisplayObject> = focusContainer.focusExtrasBefore;
				if(extras)
				{
					var skip:Boolean = false;
					if(afterChild)
					{
						var startIndex:int = extras.indexOf(afterChild) + 1;
						hasProcessedAfterChild = startIndex > 0;
						skip = !hasProcessedAfterChild;
					}
					else
					{
						startIndex = 0;
					}
					if(!skip)
					{
						var childCount:int = extras.length;
						for(var i:int = startIndex; i < childCount; i++)
						{
							var child:DisplayObject = extras[i];
							var foundChild:IFocusDisplayObject = this.findNextChildFocus(child);
							if(foundChild)
							{
								return foundChild;
							}
						}
					}
				}
			}
			if(afterChild && !hasProcessedAfterChild)
			{
				startIndex = container.getChildIndex(afterChild) + 1;
				hasProcessedAfterChild = startIndex > 0;
			}
			else
			{
				startIndex = 0;
			}
			childCount = container.numChildren;
			for(i = startIndex; i < childCount; i++)
			{
				child = container.getChildAt(i);
				foundChild = this.findNextChildFocus(child);
				if(foundChild)
				{
					return foundChild;
				}
			}
			if(container is IFocusExtras)
			{
				extras = focusContainer.focusExtrasAfter;
				if(extras)
				{
					skip = false;
					if(afterChild && !hasProcessedAfterChild)
					{
						startIndex = extras.indexOf(afterChild) + 1;
						hasProcessedAfterChild = startIndex > 0;
						skip = !hasProcessedAfterChild;
					}
					else
					{
						startIndex = 0;
					}
					if(!skip)
					{
						childCount = extras.length;
						for(i = startIndex; i < childCount; i++)
						{
							child = extras[i];
							foundChild = this.findNextChildFocus(child);
							if(foundChild)
							{
								return foundChild;
							}
						}
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
		protected function findPreviousChildFocus(child:DisplayObject):IFocusDisplayObject
		{
			if(child is IFocusDisplayObject)
			{
				var childWithFocus:IFocusDisplayObject = IFocusDisplayObject(child);
				if(childWithFocus.isFocusEnabled)
				{
					return childWithFocus;
				}
			}
			else if(child is DisplayObjectContainer)
			{
				var childContainer:DisplayObjectContainer = DisplayObjectContainer(child);
				var foundChild:IFocusDisplayObject = this.findPreviousFocus(childContainer);
				if(foundChild)
				{
					return foundChild;
				}
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function findNextChildFocus(child:DisplayObject):IFocusDisplayObject
		{
			if(child is IFocusDisplayObject)
			{
				var childWithFocus:IFocusDisplayObject = IFocusDisplayObject(child);
				if(childWithFocus.isFocusEnabled)
				{
					return childWithFocus;
				}
			}
			else if(child is DisplayObjectContainer)
			{
				var childContainer:DisplayObjectContainer = DisplayObjectContainer(child);
				var foundChild:IFocusDisplayObject = this.findNextFocus(childContainer);
				if(foundChild)
				{
					return foundChild;
				}
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function stage_mouseFocusChangeHandler(event:FocusEvent):void
		{
			event.preventDefault();
		}

		/**
		 * @private
		 */
		protected function stage_keyFocusChangeHandler(event:FocusEvent):void
		{
			//keyCode 0 is sent by IE, for some reason
			if(event.keyCode != Keyboard.TAB && event.keyCode != 0)
			{
				return;
			}

			var newFocus:IFocusDisplayObject;
			const currentFocus:IFocusDisplayObject = this._focus;
			if(event.shiftKey)
			{
				if(currentFocus)
				{
					if(currentFocus.previousTabFocus)
					{
						newFocus = currentFocus.previousTabFocus;
					}
					else
					{
						newFocus = this.findPreviousFocus(currentFocus.parent, DisplayObject(currentFocus));
					}
				}
				if(!newFocus)
				{
					newFocus = this.findPreviousFocus(this._topLevelContainer);
				}
			}
			else
			{
				if(currentFocus)
				{
					if(currentFocus.nextTabFocus)
					{
						newFocus = currentFocus.nextTabFocus;
					}
					else
					{
						newFocus = this.findNextFocus(currentFocus.parent, DisplayObject(currentFocus));
					}
				}
				if(!newFocus)
				{
					newFocus = this.findNextFocus(this._topLevelContainer);
				}
			}
			if(newFocus)
			{
				event.preventDefault();
			}
			this.focus = newFocus;
			if(this._focus)
			{
				this._focus.showFocus();
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

		/**
		 * @private
		 */
		protected function topLevelContainer_touchHandler(event:TouchEvent):void
		{
			const touch:Touch = event.getTouch(this._topLevelContainer, TouchPhase.BEGAN);
			if(!touch)
			{
				return;
			}

			var focusTarget:IFocusDisplayObject = null;
			var target:DisplayObject = touch.target;
			do
			{
				if(target is IFocusDisplayObject)
				{
					focusTarget = IFocusDisplayObject(target);
				}
				target = target.parent;
			}
			while(target)
			this.focus = focusTarget;
		}

		/**
		 * @private
		 */
		protected function focus_removedFromStageHandler(event:Event):void
		{
			this.focus = null;
		}

	}
}
