/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.core.IFocusContainer;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.IFocusExtras;
	import feathers.events.FeathersEventType;
	import feathers.layout.RelativePosition;
	import feathers.system.DeviceCapabilities;
	import feathers.utils.focus.isBetterFocusForRelativePosition;

	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	/**
	 * Dispatched when the value of the <code>focus</code> property changes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CHANGE
	 *
	 * @see #focus
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * The default <code>IFocusManager</code> implementation. This focus
	 * manager is designed to work on both desktop and mobile. Focus may be
	 * controlled by <code>Keyboard.TAB</code> (including going
	 * backwards when holding the shift key) or with the arrow keys on a d-pad
	 * (such as those that appear on a smart TV remote control and some game
	 * controllers).
	 * 
	 * <p>To simulate <code>KeyLocation.D_PAD</code> in the AIR Debug
	 * Launcher on desktop for debugging purposes, set
	 * <code>DeviceCapabilities.simulateDPad</code> to <code>true</code>.</p>
	 *
	 * @see ../../../help/focus.html Keyboard focus management in Feathers
	 * @see feathers.core.FocusManager
	 *
	 * @productversion Feathers 2.0.0
	 */
	public class DefaultFocusManager extends EventDispatcher implements IFocusManager
	{
		/**
		 * @private
		 */
		protected static var NATIVE_STAGE_TO_FOCUS_TARGET:Dictionary = new Dictionary(true);

		/**
		 * Constructor.
		 */
		public function DefaultFocusManager(root:DisplayObjectContainer)
		{
			if(!root.stage)
			{
				throw new ArgumentError("Focus manager root must be added to the stage.");
			}
			this._root = root;
			this._starling = root.stage.starling;
		}

		/**
		 * @private
		 */
		protected var _starling:Starling;

		/**
		 * @private
		 */
		protected var _nativeFocusTarget:NativeFocusTarget;

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
				this._nativeFocusTarget = NATIVE_STAGE_TO_FOCUS_TARGET[this._starling.nativeStage] as NativeFocusTarget;
				if(!this._nativeFocusTarget)
				{
					this._nativeFocusTarget = new NativeFocusTarget();
					//we must add it directly to the nativeStage because
					//otherwise, the skipUnchangedFrames property won't work
					this._starling.nativeStage.addChild(_nativeFocusTarget);
				}
				else
				{
					this._nativeFocusTarget.referenceCount++;
				}
				//since we weren't listening for objects being added while the
				//focus manager was disabled, we need to do it now in case there
				//are new ones.
				this.setFocusManager(this._root);
				this._root.addEventListener(Event.ADDED, topLevelContainer_addedHandler);
				this._root.addEventListener(Event.REMOVED, topLevelContainer_removedHandler);
				this._root.addEventListener(TouchEvent.TOUCH, topLevelContainer_touchHandler);
				this._starling.nativeStage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, stage_keyFocusChangeHandler, false, 0, true);
				this._starling.nativeStage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, stage_mouseFocusChangeHandler, false, 0, true);
				this._starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler, false, 0, true);
				//TransformGestureEvent.GESTURE_DIRECTIONAL_TAP requires
				//AIR 24, but we want to support older versions too
				this._starling.nativeStage.addEventListener("gestureDirectionalTap", stage_gestureDirectionalTapHandler, false, 0, true);
				if(this._savedFocus && !this._savedFocus.stage)
				{
					this._savedFocus = null;
				}
				this.focus = this._savedFocus;
				this._savedFocus = null;
			}
			else
			{
				this._nativeFocusTarget.referenceCount--;
				if(this._nativeFocusTarget.referenceCount <= 0)
				{
					this._nativeFocusTarget.parent.removeChild(this._nativeFocusTarget);
					delete NATIVE_STAGE_TO_FOCUS_TARGET[this._starling.nativeStage];
				}
				this._nativeFocusTarget = null;
				this._root.removeEventListener(Event.ADDED, topLevelContainer_addedHandler);
				this._root.removeEventListener(Event.REMOVED, topLevelContainer_removedHandler);
				this._root.removeEventListener(TouchEvent.TOUCH, topLevelContainer_touchHandler);
				this._starling.nativeStage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, stage_keyFocusChangeHandler);
				this._starling.nativeStage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, stage_mouseFocusChangeHandler);
				this._starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
				this._starling.nativeStage.removeEventListener("gestureDirectionalTap", stage_gestureDirectionalTapHandler);
				var focusToSave:IFocusDisplayObject = this.focus;
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
			if(this._focus === value)
			{
				return;
			}
			var shouldHaveFocus:Boolean = false;
			var oldFocus:IFeathersDisplayObject = this._focus;
			if(this._isEnabled && value !== null && value.isFocusEnabled && value.focusManager === this)
			{
				this._focus = value;
				shouldHaveFocus = true;
			}
			else
			{
				this._focus = null;
			}
			var nativeStage:Stage = this._starling.nativeStage;
			if(oldFocus is INativeFocusOwner)
			{
				var nativeFocus:Object = INativeFocusOwner(oldFocus).nativeFocus;
				if(nativeFocus === null && nativeStage !== null)
				{
					nativeFocus = nativeStage.focus;
				}
				if(nativeFocus is IEventDispatcher)
				{
					//this listener restores focus, if it is lost in a way that
					//is out of our control. since we may be manually removing
					//focus in a listener for FeathersEventType.FOCUS_OUT, we
					//don't want it to restore focus.
					IEventDispatcher(nativeFocus).removeEventListener(FocusEvent.FOCUS_OUT, nativeFocus_focusOutHandler);
				}
			}
			if(oldFocus !== null)
			{
				//this event should be dispatched after setting the new value of
				//_focus because we want to be able to access the value of the
				//focus property in the event listener.
				oldFocus.dispatchEventWith(FeathersEventType.FOCUS_OUT);
			}
			if(shouldHaveFocus && this._focus !== value)
			{
				//this shouldn't happen, but if it does, let's not break the
				//current state even more by referencing an old focused object.
				return;
			}
			if(this._isEnabled)
			{
				if(this._focus !== null)
				{
					nativeFocus = null;
					if(this._focus is INativeFocusOwner)
					{
						nativeFocus = INativeFocusOwner(this._focus).nativeFocus;
						if(nativeFocus is InteractiveObject)
						{
							nativeStage.focus = InteractiveObject(nativeFocus);
						}
						else if(nativeFocus !== null)
						{
							if(this._focus is IAdvancedNativeFocusOwner)
							{
								var advancedFocus:IAdvancedNativeFocusOwner = IAdvancedNativeFocusOwner(this._focus);
								if(!advancedFocus.hasFocus)
								{
									//let the focused component handle giving focus to
									//its nativeFocus because it may have a custom API
									advancedFocus.setFocus();
								}
							}
							else
							{
								throw new IllegalOperationError("If nativeFocus does not return an InteractiveObject, class must implement IAdvancedNativeFocusOwner interface");
							}
						}
					}
					//an INativeFocusOwner may return null for its
					//nativeFocus property, so we still need to double-check
					//that the native stage has something in focus. that's
					//why there isn't an else here
					if(nativeFocus === null)
					{
						nativeFocus = this._nativeFocusTarget;
						nativeStage.focus = this._nativeFocusTarget;
					}
					if(nativeFocus is IEventDispatcher)
					{
						IEventDispatcher(nativeFocus).addEventListener(FocusEvent.FOCUS_OUT, nativeFocus_focusOutHandler, false, 0, true);
					}
					this._focus.dispatchEventWith(FeathersEventType.FOCUS_IN);
				}
				else
				{
					nativeStage.focus = null;
				}
			}
			else
			{
				this._savedFocus = value;
			}
			this.dispatchEventWith(Event.CHANGE);
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
			if((target is DisplayObjectContainer && !(target is IFocusDisplayObject)) ||
				(target is IFocusContainer && IFocusContainer(target).isChildFocusEnabled))
			{
				var container:DisplayObjectContainer = DisplayObjectContainer(target);
				var childCount:int = container.numChildren;
				for(var i:int = 0; i < childCount; i++)
				{
					var child:DisplayObject = container.getChildAt(i);
					this.setFocusManager(child);
				}
				if(container is IFocusExtras)
				{
					var containerWithExtras:IFocusExtras = IFocusExtras(container);
					var extras:Vector.<DisplayObject> = containerWithExtras.focusExtrasBefore;
					if(extras)
					{
						childCount = extras.length;
						for(i = 0; i < childCount; i++)
						{
							child = extras[i];
							this.setFocusManager(child);
						}
					}
					extras = containerWithExtras.focusExtrasAfter;
					if(extras)
					{
						childCount = extras.length;
						for(i = 0; i < childCount; i++)
						{
							child = extras[i];
							this.setFocusManager(child);
						}
					}
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
				if(targetWithFocus.focusManager == this)
				{
					if(this._focus == targetWithFocus)
					{
						//change to focus owner, which falls back to null
						this.focus = targetWithFocus.focusOwner;
					}
					targetWithFocus.focusManager = null;
				}
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
				if(container is IFocusExtras)
				{
					var containerWithExtras:IFocusExtras = IFocusExtras(container);
					var extras:Vector.<DisplayObject> = containerWithExtras.focusExtrasBefore;
					if(extras)
					{
						childCount = extras.length;
						for(i = 0; i < childCount; i++)
						{
							child = extras[i];
							this.clearFocusManager(child);
						}
					}
					extras = containerWithExtras.focusExtrasAfter;
					if(extras)
					{
						childCount = extras.length;
						for(i = 0; i < childCount; i++)
						{
							child = extras[i];
							this.clearFocusManager(child);
						}
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function findPreviousContainerFocus(container:DisplayObjectContainer, beforeChild:DisplayObject, fallbackToGlobal:Boolean):IFocusDisplayObject
		{
			if(container is LayoutViewPort)
			{
				container = container.parent;
			}
			var hasProcessedBeforeChild:Boolean = beforeChild == null;
			if(container is IFocusExtras)
			{
				var focusWithExtras:IFocusExtras = IFocusExtras(container);
				var extras:Vector.<DisplayObject> = focusWithExtras.focusExtrasAfter;
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
				extras = focusWithExtras.focusExtrasBefore;
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

			if(fallbackToGlobal && container != this._root)
			{
				//try the container itself before moving backwards
				if(container is IFocusDisplayObject)
				{
					var focusContainer:IFocusDisplayObject = IFocusDisplayObject(container);
					if(this.isValidFocus(focusContainer))
					{
						return focusContainer;
					}
				}
				return this.findPreviousContainerFocus(container.parent, container, true);
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function findNextContainerFocus(container:DisplayObjectContainer, afterChild:DisplayObject, fallbackToGlobal:Boolean):IFocusDisplayObject
		{
			if(container is LayoutViewPort)
			{
				container = container.parent;
			}
			var hasProcessedAfterChild:Boolean = afterChild == null;
			if(container is IFocusExtras)
			{
				var focusWithExtras:IFocusExtras = IFocusExtras(container);
				var extras:Vector.<DisplayObject> = focusWithExtras.focusExtrasBefore;
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
				extras = focusWithExtras.focusExtrasAfter;
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

			if(fallbackToGlobal && container != this._root)
			{
				return this.findNextContainerFocus(container.parent, container, true);
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function findPreviousChildFocus(child:DisplayObject):IFocusDisplayObject
		{
			if((child is DisplayObjectContainer && !(child is IFocusDisplayObject)) ||
				(child is IFocusContainer && IFocusContainer(child).isChildFocusEnabled))
			{
				var childContainer:DisplayObjectContainer = DisplayObjectContainer(child);
				var foundChild:IFocusDisplayObject = this.findPreviousContainerFocus(childContainer, null, false);
				if(foundChild)
				{
					return foundChild;
				}
			}
			if(child is IFocusDisplayObject)
			{
				var childWithFocus:IFocusDisplayObject = IFocusDisplayObject(child);
				if(this.isValidFocus(childWithFocus))
				{
					return childWithFocus;
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
			if((child is DisplayObjectContainer && !(child is IFocusDisplayObject)) ||
				(child is IFocusContainer && IFocusContainer(child).isChildFocusEnabled))
			{
				var childContainer:DisplayObjectContainer = DisplayObjectContainer(child);
				var foundChild:IFocusDisplayObject = this.findNextContainerFocus(childContainer, null, false);
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
		protected function findFocusAtRelativePosition(container:DisplayObjectContainer, position:String):IFocusDisplayObject
		{
			var focusableObjects:Vector.<IFocusDisplayObject> = new <IFocusDisplayObject>[];
			findAllFocusableObjects(container, focusableObjects);
			if(this._focus === null)
			{
				if(focusableObjects.length > 0)
				{
					return focusableObjects[0];
				}
				return null;
			}
			var focusedRect:Rectangle = this._focus.getBounds(this._focus.stage, Pool.getRectangle());
			var result:IFocusDisplayObject = null;
			var count:int = focusableObjects.length;
			for(var i:int = 0; i < count; i++)
			{
				var focusableObject:IFocusDisplayObject = focusableObjects[i];
				if(focusableObject === this._focus)
				{
					continue;
				}
				if(isBetterFocusForRelativePosition(focusableObject, result, focusedRect, position))
				{
					result = focusableObject;
				}
			}
			Pool.putRectangle(focusedRect);
			if(result === null)
			{
				//default to keeping the current focus
				return this._focus;
			}
			return result;
		}

		/**
		 * @private
		 */
		protected function findAllFocusableObjects(child:DisplayObject, result:Vector.<IFocusDisplayObject>):void
		{
			if(child is IFocusDisplayObject)
			{
				var focusableObject:IFocusDisplayObject = IFocusDisplayObject(child);
				if(isValidFocus(focusableObject))
				{
					result[result.length] = focusableObject;
				}
			}
			if(child is IFocusExtras)
			{
				var focusExtras:IFocusExtras = IFocusExtras(child);
				var extras:Vector.<DisplayObject> = focusExtras.focusExtrasBefore;
				var count:int = extras.length;
				for(var i:int = 0; i < count; i++)
				{
					var childOfChild:DisplayObject = extras[i];
					findAllFocusableObjects(childOfChild, result);
				}
			}
			if(child is IFocusDisplayObject)
			{
				if(child is IFocusContainer && IFocusContainer(child).isChildFocusEnabled)
				{
					var otherContainer:DisplayObjectContainer = DisplayObjectContainer(child);
					count = otherContainer.numChildren;
					for(i = 0; i < count; i++)
					{
						childOfChild = otherContainer.getChildAt(i);
						findAllFocusableObjects(childOfChild, result);
					}
				}
			}
			else if(child is DisplayObjectContainer)
			{
				otherContainer = DisplayObjectContainer(child);
				count = otherContainer.numChildren;
				for(i = 0; i < count; i++)
				{
					childOfChild = otherContainer.getChildAt(i);
					findAllFocusableObjects(childOfChild, result);
				}
			}
			if(child is IFocusExtras)
			{
				extras = focusExtras.focusExtrasAfter;
				count = extras.length;
				for(i = 0; i < count; i++)
				{
					childOfChild = extras[i];
					findAllFocusableObjects(childOfChild, result);
				}
			}
		}

		/**
		 * @private
		 */
		protected function isValidFocus(child:IFocusDisplayObject):Boolean
		{
			if(child === null || child.focusManager !== this)
			{
				return false;
			}
			if(!child.isFocusEnabled)
			{
				if(child.focusOwner === null || !isValidFocus(child.focusOwner))
				{
					return false;
				}
			}
			var uiChild:IFeathersControl = child as IFeathersControl;
			if(uiChild !== null && !uiChild.isEnabled)
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
			if(event.relatedObject)
			{
				//we need to allow mouse focus to be passed to native display
				//objects. for instance, hyperlinks in TextField won't work
				//unless the TextField can be focused.
				this.focus = null;
				return;
			}
			event.preventDefault();
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyLocation !== KeyLocation.D_PAD && !DeviceCapabilities.simulateDPad)
			{
				//focus is controlled only with a d-pad and not the regular
				//keyboard arrow keys
				return;
			}
			if(event.keyCode !== Keyboard.UP && event.keyCode !== Keyboard.DOWN &&
				event.keyCode !== Keyboard.LEFT && event.keyCode !== Keyboard.RIGHT)
			{
				return;
			}
			if(event.isDefaultPrevented())
			{
				//something else has already handled this keyboard event
				return;
			}
			var newFocus:IFocusDisplayObject;
			var currentFocus:IFocusDisplayObject = this._focus;
			if(currentFocus !== null && currentFocus.focusOwner !== null)
			{
				newFocus = currentFocus.focusOwner;
			}
			else
			{
				var position:String = RelativePosition.RIGHT;
				switch(event.keyCode)
				{
					case Keyboard.UP:
					{
						position = RelativePosition.TOP;
						if(currentFocus !== null && currentFocus.nextUpFocus !== null)
						{
							newFocus = currentFocus.nextUpFocus;
						}
						break;
					}
					case Keyboard.RIGHT:
					{
						position = RelativePosition.RIGHT;
						if(currentFocus !== null && currentFocus.nextRightFocus !== null)
						{
							newFocus = currentFocus.nextRightFocus;
						}
						break;
					}
					case Keyboard.DOWN:
					{
						position = RelativePosition.BOTTOM;
						if(currentFocus !== null && currentFocus.nextDownFocus !== null)
						{
							newFocus = currentFocus.nextDownFocus;
						}
						break;
					}
					case Keyboard.LEFT:
					{
						position = RelativePosition.LEFT;
						if(currentFocus !== null && currentFocus.nextLeftFocus !== null)
						{
							newFocus = currentFocus.nextLeftFocus;
						}
						break;
					}
				}
				if(newFocus === null)
				{
					newFocus = findFocusAtRelativePosition(this._root, position);
				}
			}
			if(newFocus !== this._focus)
			{
				event.preventDefault();
				this.focus = newFocus;
			}
			if(this._focus)
			{
				this._focus.showFocus();
			}
		}

		/**
		 * @private
		 */
		protected function stage_gestureDirectionalTapHandler(event:TransformGestureEvent):void
		{
			if(event.isDefaultPrevented())
			{
				//something else has already handled this event
				return;
			}
			var position:String = null;
			if(event.offsetY < 0)
			{
				position = RelativePosition.TOP;
			}
			else if(event.offsetY > 0)
			{
				position = RelativePosition.BOTTOM;
			}
			else if(event.offsetX > 0)
			{
				position = RelativePosition.RIGHT;
			}
			else if(event.offsetX < 0)
			{
				position = RelativePosition.LEFT;
			}
			if(position === null)
			{
				return;
			}
			var newFocus:IFocusDisplayObject = findFocusAtRelativePosition(this._root, position);
			if(newFocus !== this._focus)
			{
				event.preventDefault();
				this.focus = newFocus;
			}
			if(this._focus)
			{
				this._focus.showFocus();
			}
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
			var currentFocus:IFocusDisplayObject = this._focus;
			if(currentFocus && currentFocus.focusOwner)
			{
				newFocus = currentFocus.focusOwner;
			}
			else if(event.shiftKey)
			{
				if(currentFocus)
				{
					if(currentFocus.previousTabFocus)
					{
						newFocus = currentFocus.previousTabFocus;
					}
					else
					{
						newFocus = this.findPreviousContainerFocus(currentFocus.parent, DisplayObject(currentFocus), true);
					}
				}
				if(!newFocus)
				{
					newFocus = this.findPreviousContainerFocus(this._root, null, false);
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
					else if(currentFocus is IFocusContainer && IFocusContainer(currentFocus).isChildFocusEnabled)
					{
						newFocus = this.findNextContainerFocus(DisplayObjectContainer(currentFocus), null, true);
					}
					else
					{
						newFocus = this.findNextContainerFocus(currentFocus.parent, DisplayObject(currentFocus), true);
					}
				}
				if(!newFocus)
				{
					newFocus = this.findNextContainerFocus(this._root, null, false);
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
			if(Capabilities.os.indexOf("tvOS") !== -1)
			{
				return;
			}
			var touch:Touch = event.getTouch(this._root, TouchPhase.BEGAN);
			if(!touch)
			{
				return;
			}
			if(this._focus !== null && this._focus.maintainTouchFocus)
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
						if(!focusTarget || !(tempFocusTarget is IFocusContainer) || !(IFocusContainer(tempFocusTarget).isChildFocusEnabled))
						{
							focusTarget = tempFocusTarget;
						}
					}
				}
				target = target.parent;
			}
			while(target)
			if(this._focus !== null && focusTarget !== null)
			{
				//ignore touches on focusOwner because we consider the
				//focusOwner to indirectly have focus already
				var focusOwner:IFocusDisplayObject = this._focus.focusOwner;
				if(focusOwner === focusTarget)
				{
					return;
				}
				//similarly, ignore touches on display objects that have a
				//focusOwner and that owner is the currently focused object
				var result:DisplayObject = DisplayObject(focusTarget);
				while(result != null)
				{
					var focusResult:IFocusDisplayObject = result as IFocusDisplayObject;
					if(focusResult !== null)
					{
						focusOwner = focusResult.focusOwner;
						if(focusOwner !== null)
						{
							if(focusOwner === this._focus)
							{
								//the current focus is the touch target's owner,
								//so we don't need to clear focus
								focusTarget = focusOwner;
							}
							//if we've found a display object with a focus owner,
							//then we've gone far enough up the display list
							break;
						}
						else if(focusResult.isFocusEnabled)
						{
							//if focus in enabled, then we've gone far enough up
							//the display list
							break;
						}
					}
					result = result.parent;
				}
			}
			this.focus = focusTarget;
		}

		/**
		 * @private
		 */
		protected function nativeFocus_focusOutHandler(event:FocusEvent):void
		{
			var nativeFocus:Object = event.currentTarget;
			var nativeStage:Stage = this._starling.nativeStage;
			if(nativeStage.focus !== null && nativeStage.focus !== nativeFocus)
			{
				//we should stop listening for this event because something else
				//has focus now
				if(nativeFocus is IEventDispatcher)
				{
					IEventDispatcher(nativeFocus).removeEventListener(FocusEvent.FOCUS_OUT, nativeFocus_focusOutHandler);
				}
			}
			else if(this._focus !== null)
			{
				if(this._focus is INativeFocusOwner &&
					INativeFocusOwner(this._focus).nativeFocus !== nativeFocus)
				{
					return;
				}
				//if there's still a feathers focus, but the native stage object has
				//lost focus for some reason, and there's no focus at all, force it
				//back into focus.
				//this can happen on app deactivate!
				if(nativeFocus is InteractiveObject)
				{
					nativeStage.focus = InteractiveObject(nativeFocus);
				}
				else //nativeFocus is IAdvancedNativeFocusOwner
				{
					//let the focused component handle giving focus to its
					//nativeFocus because it may have a custom API
					IAdvancedNativeFocusOwner(this._focus).setFocus();
				}
			}
		}
	}
}

import flash.display.Sprite;

class NativeFocusTarget extends Sprite
{
	public function NativeFocusTarget()
	{
		this.tabEnabled = true;
		this.mouseEnabled = false;
		this.mouseChildren = false;
		this.alpha = 0;
	}

	public var referenceCount:int = 1;
}