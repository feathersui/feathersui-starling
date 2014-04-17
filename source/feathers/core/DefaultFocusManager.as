/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.controls.IScrollContainer;
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.core.FocusManager;
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
	 * The default <code>IPopUpManager</code> implementation.
	 *
	 * @see FocusManager
	 */
	public class DefaultFocusManager implements IFocusManager
	{
		/**
		 * @private
		 */
		protected static var _nativeFocusTarget:Sprite;

		/**
		 * @private
		 */
		protected static var _nativeFocusTargetReferenceCount:int = 0;

		/**
		 * Constructor.
		 */
		public function DefaultFocusManager(root:DisplayObjectContainer = null)
		{
			if(!root)
			{
				root = Starling.current.stage;
			}
			this._root = root;
			this.setFocusManager(this._root);
		}

		/**
		 * @private
		 */
		protected var _root:DisplayObjectContainer;

		/**
		 * @inheritDoc
		 */
		public function get root():DisplayObjectContainer
		{
			return this._root;
		}

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
				_nativeFocusTargetReferenceCount++;
				if(_nativeFocusTargetReferenceCount == 1)
				{
					//we need a native display object on the native stage to receive
					//key focus change events!
					_nativeFocusTarget = new Sprite();
					_nativeFocusTarget.tabEnabled = true;
					_nativeFocusTarget.mouseEnabled = false;
					_nativeFocusTarget.mouseChildren = false;
					_nativeFocusTarget.alpha = 0;
					Starling.current.nativeOverlay.addChild(_nativeFocusTarget);
				}

				this._root.addEventListener(Event.ADDED, topLevelContainer_addedHandler);
				this._root.addEventListener(Event.REMOVED, topLevelContainer_removedHandler);
				this._root.addEventListener(TouchEvent.TOUCH, topLevelContainer_touchHandler);
				Starling.current.nativeStage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, stage_keyFocusChangeHandler, false, 0, true);
				Starling.current.nativeStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, stage_mouseFocusChangeHandler, false, 0, true);
				this.focus = this._savedFocus;
				this._savedFocus = null;
			}
			else
			{
				_nativeFocusTargetReferenceCount--;
				if(_nativeFocusTargetReferenceCount <= 0)
				{
					_nativeFocusTarget.parent.removeChild(_nativeFocusTarget);
					_nativeFocusTarget = null;
				}
				this._root.removeEventListener(Event.ADDED, topLevelContainer_addedHandler);
				this._root.removeEventListener(Event.REMOVED, topLevelContainer_removedHandler);
				this._root.removeEventListener(TouchEvent.TOUCH, topLevelContainer_touchHandler);
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
					var nativeStage:Stage = Starling.current.nativeStage;
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
				var targetWithFocus:IFocusDisplayObject = IFocusDisplayObject(target);
				targetWithFocus.focusManager = this;
			}
			else if(target is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = DisplayObjectContainer(target);
				var childCount:int = container.numChildren;
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
				var targetWithFocus:IFocusDisplayObject = IFocusDisplayObject(target);
				targetWithFocus.focusManager = null;
			}
			if(target is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = DisplayObjectContainer(target);
				var childCount:int = container.numChildren;
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
							if(this.isValidFocus(foundChild))
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
				if(this.isValidFocus(foundChild))
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
							if(this.isValidFocus(foundChild))
							{
								return foundChild;
							}
						}
					}
				}
			}

			if(beforeChild && container != this._root)
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
							if(this.isValidFocus(foundChild))
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
				if(this.isValidFocus(foundChild))
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
							if(this.isValidFocus(foundChild))
							{
								return foundChild;
							}
						}
					}
				}
			}

			if(afterChild && container != this._root)
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
				if(this.isValidFocus(childWithFocus))
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
				if(this.isValidFocus(childWithFocus))
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
		protected function isValidFocus(child:IFocusDisplayObject):Boolean
		{
			if(!child)
			{
				return false;
			}
			if(!child.isFocusEnabled)
			{
				return false;
			}
			var uiChild:IFeathersControl = child as IFeathersControl;
			if(uiChild && !uiChild.isEnabled)
			{
				return false;
			}
			return true;
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
					newFocus = this.findPreviousFocus(this._root);
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
					newFocus = this.findNextFocus(this._root);
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
			const touch:Touch = event.getTouch(this._root, TouchPhase.BEGAN);
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
					var tempFocusTarget:IFocusDisplayObject = IFocusDisplayObject(target);
					if(this.isValidFocus(tempFocusTarget))
					{
						focusTarget = tempFocusTarget;
					}
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
