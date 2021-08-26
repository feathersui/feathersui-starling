/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.BaseScreenNavigator;
	import feathers.events.ExclusiveTouch;
	import feathers.events.FeathersEventType;
	import feathers.motion.effectClasses.IEffectContext;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import flash.geom.Point;
	import flash.utils.getTimer;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	[DefaultProperty("mxmlContent")]
	/**
	 * Typically used to provide some kind of animation or visual effect,
	 * this function that is called when the screen navigator pushes a new
	 * screen onto the stack.
	 *
	 * <p>In the following example, the screen navigator is given a push
	 * transition that slides the screens to the left:</p>
	 *
	 * <listing version="3.0">
	 * navigator.pushTransition = Slide.createSlideLeftTransition();</listing>
	 *
	 * <p>A number of animated transitions may be found in the
	 * <a href="../motion/package-detail.html">feathers.motion</a> package.
	 * However, you are not limited to only these transitions. It's possible
	 * to create custom transitions too.</p>
	 *
	 * <p>A custom transition function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes. This callback indicate to the
	 * screen navigator that the transition has finished. This function has
	 * the following signature:</p>
	 *
	 * <pre>function(cancelTransition:Boolean = false):void</pre>
	 *
	 * <p>The first argument defaults to <code>false</code>, meaning that
	 * the transition completed successfully. In most cases, this callback
	 * may be called without arguments. If a transition is cancelled before
	 * completion (perhaps through some kind of user interaction), and the
	 * previous screen should be restored, pass <code>true</code> as the
	 * first argument to the callback to inform the screen navigator that
	 * the transition is cancelled.</p>
	 *
	 * @default null
	 *
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 * @see #pushScreen()
	 * @see #popTransition
	 * @see #popToRootTransition
	 */
	[Style(name="pushTransition",type="Function")]

	/**
	 * Typically used to provide some kind of animation or visual effect,
	 * this function that is called when the screen navigator pops a screen
	 * from the top of the stack.
	 *
	 * <p>In the following example, the screen navigator is given a pop
	 * transition that slides the screens to the right:</p>
	 *
	 * <listing version="3.0">
	 * navigator.popTransition = Slide.createSlideRightTransition();</listing>
	 *
	 * <p>A number of animated transitions may be found in the
	 * <a href="../motion/package-detail.html">feathers.motion</a> package.
	 * However, you are not limited to only these transitions. It's possible
	 * to create custom transitions too.</p>
	 *
	 * <p>A custom transition function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes. This callback indicate to the
	 * screen navigator that the transition has finished. This function has
	 * the following signature:</p>
	 *
	 * <pre>function(cancelTransition:Boolean = false):void</pre>
	 *
	 * <p>The first argument defaults to <code>false</code>, meaning that
	 * the transition completed successfully. In most cases, this callback
	 * may be called without arguments. If a transition is cancelled before
	 * completion (perhaps through some kind of user interaction), and the
	 * previous screen should be restored, pass <code>true</code> as the
	 * first argument to the callback to inform the screen navigator that
	 * the transition is cancelled.</p>
	 *
	 * @default null
	 *
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 * @see #popScreen()
	 * @see #pushTransition
	 * @see #popToRootTransition
	 */
	[Style(name="popTransition",type="Function")]

	/**
	 * Typically used to provide some kind of animation or visual effect, a
	 * function that is called when the screen navigator clears its stack,
	 * to show the first screen that was pushed onto the stack.
	 *
	 * <p>If this property is <code>null</code>, the value of the
	 * <code>popTransition</code> property will be used instead.</p>
	 *
	 * <p>In the following example, a custom pop to root transition is
	 * passed to the screen navigator:</p>
	 *
	 * <listing version="3.0">
	 * navigator.popToRootTransition = Fade.createFadeInTransition();</listing>
	 *
	 * <p>A number of animated transitions may be found in the
	 * <a href="../motion/package-detail.html">feathers.motion</a> package.
	 * However, you are not limited to only these transitions. It's possible
	 * to create custom transitions too.</p>
	 *
	 * <p>A custom transition function should have the following signature:</p>
	 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
	 *
	 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
	 * arguments may be <code>null</code>, but never both. The
	 * <code>oldScreen</code> argument will be <code>null</code> when the
	 * first screen is displayed or when a new screen is displayed after
	 * clearing the screen. The <code>newScreen</code> argument will
	 * be null when clearing the screen.</p>
	 *
	 * <p>The <code>completeCallback</code> function <em>must</em> be called
	 * when the transition effect finishes. This callback indicate to the
	 * screen navigator that the transition has finished. This function has
	 * the following signature:</p>
	 *
	 * <pre>function(cancelTransition:Boolean = false):void</pre>
	 *
	 * <p>The first argument defaults to <code>false</code>, meaning that
	 * the transition completed successfully. In most cases, this callback
	 * may be called without arguments. If a transition is cancelled before
	 * completion (perhaps through some kind of user interaction), and the
	 * previous screen should be restored, pass <code>true</code> as the
	 * first argument to the callback to inform the screen navigator that
	 * the transition is cancelled.</p>
	 *
	 * @default null
	 *
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 * @see #popToRootScreen()
	 * @see #pushTransition
	 * @see #popTransition
	 */
	[Style(name="popToRootTransition",type="Function")]

	/**
	 * A "view stack"-like container that supports navigation between screens
	 * (any display object) through events.
	 *
	 * <p>The following example creates a screen navigator, adds a screen and
	 * displays it:</p>
	 *
	 * <listing version="3.0">
	 * var navigator:StackScreenNavigator = new StackScreenNavigator();
	 * navigator.addScreen( "mainMenu", new StackScreenNavigatorItem( MainMenuScreen ) );
	 * this.addChild( navigator );
	 * 
	 * navigator.rootScreenID = "mainMenu";</listing>
	 *
	 * @see ../../../help/stack-screen-navigator.html How to use the Feathers StackScreenNavigator component
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 * @see feathers.controls.StackScreenNavigatorItem
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class StackScreenNavigator extends BaseScreenNavigator
	{
		/**
		 * @private
		 * The current velocity is given high importance.
		 */
		private static const CURRENT_VELOCITY_WEIGHT:Number = 2.33;

		/**
		 * @private
		 * Older saved velocities are given less importance.
		 */
		private static const VELOCITY_WEIGHTS:Vector.<Number> = new <Number>[1, 1.33, 1.66, 2];

		/**
		 * @private
		 */
		private static const MAXIMUM_SAVED_VELOCITY_COUNT:int = 4;

		/**
		 * The default <code>IStyleProvider</code> for all <code>StackScreenNavigator</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function StackScreenNavigator()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, stackScreenNavigator_initializeHandler);
			this.addEventListener(TouchEvent.TOUCH, stackScreenNavigator_touchHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return StackScreenNavigator.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _isDragging:Boolean = false;

		/**
		 * @private
		 */
		protected var _dragCancelled:Boolean = false;

		/**
		 * @private
		 */
		protected var _startTouchX:Number;

		/**
		 * @private
		 */
		protected var _currentTouchX:Number;

		/**
		 * @private
		 */
		protected var _previousTouchTime:int;

		/**
		 * @private
		 */
		protected var _previousTouchX:Number;

		/**
		 * @private
		 */
		protected var _velocityX:Number = 0;

		/**
		 * @private
		 */
		protected var _previousVelocityX:Vector.<Number> = new <Number>[];

		/**
		 * @private
		 */
		protected var _pushTransition:Function;

		/**
		 * @private
		 */
		public function get pushTransition():Function
		{
			return this._pushTransition;
		}

		/**
		 * @private
		 */
		public function set pushTransition(value:Function):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._pushTransition = value;
		}

		/**
		 * @private
		 */
		protected var _popTransition:Function;

		/**
		 * @private
		 */
		public function get popTransition():Function
		{
			return this._popTransition;
		}

		/**
		 * @private
		 */
		public function set popTransition(value:Function):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._popTransition = value;
		}

		/**
		 * @private
		 */
		protected var _popToRootTransition:Function = null;

		/**
		 * @private
		 */
		public function get popToRootTransition():Function
		{
			return this._popToRootTransition;
		}

		/**
		 * @private
		 */
		public function set popToRootTransition(value:Function):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._popToRootTransition = value;
		}

		/**
		 * @private
		 */
		protected var _poppedStackItem:StackItem = null;

		/**
		 * @private
		 */
		protected var _stack:Vector.<StackItem> = new <StackItem>[];

		/**
		 * @private
		 */
		public function get stackCount():int
		{
			var stackLength:int = this._stack.length;
			if(stackLength > 0)
			{
				return this._stack.length + 1;
			}
			if(this._activeScreen)
			{
				return 1;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected var _pushScreenEvents:Object = {};

		/**
		 * @private
		 */
		protected var _replaceScreenEvents:Object;

		/**
		 * @private
		 */
		protected var _popScreenEvents:Vector.<String>;

		/**
		 * @private
		 */
		protected var _popToRootScreenEvents:Vector.<String>;

		/**
		 * @private
		 */
		protected var _tempRootScreenID:String;

		/**
		 * Sets the first screen at the bottom of the stack, or the root screen.
		 * When this screen is shown, there will be no transition.
		 *
		 * <p>If the stack contains screens when you set this property, they
		 * will be removed from the stack. In other words, setting this property
		 * will clear the stack, erasing the current history.</p>
		 *
		 * <p>In the following example, the root screen is set:</p>
		 *
		 * <listing version="3.0">
		 * navigator.rootScreenID = "someScreen";</listing>
		 *
		 * @see #popToRootScreen()
		 */
		public function get rootScreenID():String
		{
			if(this._tempRootScreenID !== null)
			{
				return this._tempRootScreenID;
			}
			else if(this._stack.length == 0)
			{
				return this._activeScreenID;
			}
			return this._stack[0].id;
		}

		/**
		 * @private
		 */
		public function set rootScreenID(value:String):void
		{
			if(this._isInitialized)
			{
				//we may have delayed showing the root screen until after
				//initialization, but this property could be set between when
				//_isInitialized is set to true and when the screen is actually
				//shown, so we need to clear this variable, just in case. 
				this._tempRootScreenID = null;
				
				//this clears the whole stack and starts fresh
				this._stack.length = 0;
				if(value !== null)
				{
					//show without a transition because we're not navigating.
					//we're forcibly replacing the root screen.
					this.showScreenInternal(value, null);
				}
				else
				{
					this.clearScreenInternal(null);
				}
			}
			else
			{
				this._tempRootScreenID = value;
			}
		}

		/**
		 * @private
		 */
		protected var _mxmlContent:Array;

		[ArrayElementType(elementType="feathers.controls.StackScreenNavigatorItem")]
		/**
		 * @private
		 */
		public function get mxmlContent():Array
		{
			return this._mxmlContent;
		}

		/**
		 * @private
		 */
		public function set mxmlContent(value:Array):void
		{
			if(this._mxmlContent == value)
			{
				return;
			}
			this._mxmlContent = value;
			this.removeAllScreens();
			var screenCount:int = value.length;
			for(var i:int = 0; i < screenCount; i++)
			{
				var screenItem:StackScreenNavigatorItem = StackScreenNavigatorItem(value[i]);
				var screenID:String = screenItem.mxmlID;
				this.addScreen(screenID, screenItem);
			}
		}

		/**
		 * @private
		 */
		protected var _minimumDragDistance:Number = 0.04;

		/**
		 * The minimum physical distance (in inches) that a touch must move
		 * before a drag gesture begins when <code>isSwipeToPopEnabled</code>
		 * is <code>true</code>.
		 *
		 * <p>In the following example, the minimum drag distance is customized:</p>
		 *
		 * <listing version="3.0">
		 * scroller.minimumDragDistance = 0.1;</listing>
		 *
		 * @default 0.04
		 * 
		 * @see #isSwipeToPopEnabled
		 */
		public function get minimumDragDistance():Number
		{
			return this._minimumDragDistance;
		}

		/**
		 * @private
		 */
		public function set minimumDragDistance(value:Number):void
		{
			this._minimumDragDistance = value;
		}

		/**
		 * @private
		 */
		protected var _minimumSwipeVelocity:Number = 5;

		/**
		 * The minimum physical velocity (in inches per second) that a touch
		 * must move before a swipe is detected. Otherwise, it will settle which
		 * screen to navigate to based on which one is closer when the touch ends.
		 *
		 * <p>In the following example, the minimum swipe velocity is customized:</p>
		 *
		 * <listing version="3.0">
		 * navigator.minimumSwipeVelocity = 2;</listing>
		 *
		 * @default 5
		 * 
		 * @see #isSwipeToPopEnabled
		 */
		public function get minimumSwipeVelocity():Number
		{
			return this._minimumSwipeVelocity;
		}

		/**
		 * @private
		 */
		public function set minimumSwipeVelocity(value:Number):void
		{
			this._minimumSwipeVelocity = value;
		}

		/**
		 * @private
		 */
		protected var _isSwipeToPopEnabled:Boolean = false;

		/**
		 * Determines if the swipe gesture to pop the current screen is enabled.
		 * 
		 * <p>In the following example, swiping to go back is enabled:</p>
		 *
		 * <listing version="3.0">
		 * navigator.isSwipeToPopEnabled = true;</listing>
		 * 
		 * @default false
		 */
		public function get isSwipeToPopEnabled():Boolean
		{
			return this._isSwipeToPopEnabled;
		}

		/**
		 * @private
		 */
		public function set isSwipeToPopEnabled(value:Boolean):void
		{
			this._isSwipeToPopEnabled = value;
		}

		/**
		 * @private
		 */
		protected var _swipeToPopGestureEdgeSize:Number = 0.1;

		/**
		 * The size (in inches) of the region near the left edge of the content
		 * that can be dragged when <code>isSwipeToPopEnabled</code> is
		 * <code>true</code>.
		 *
		 * <p>In the following example, the swipe-to-pop gesture edge size is
		 * customized:</p>
		 *
		 * <listing version="3.0">
		 * drawers.swipeToPopGestureEdgeSize = 0.25;</listing>
		 *
		 * @default 0.1
		 * 
		 * @see #isSwipeToPopEnabled
		 */
		public function get swipeToPopGestureEdgeSize():Number
		{
			return this._swipeToPopGestureEdgeSize;
		}

		/**
		public function set swipeToPopGestureEdgeSize(value:Number):void
		{
			this._swipeToPopGestureEdgeSize = value;
		}

		/**
		 * @private
		 */
		protected var _savedTransitionOnComplete:Function = null;

		/**
		 * @private
		 */
		protected var _dragEffectContext:IEffectContext = null;

		/**
		 * @private
		 */
		protected var _dragEffectTransition:Function = null;

		/**
		 * Registers a new screen with a string identifier that can be used
		 * to reference the screen in other calls, like <code>removeScreen()</code>
		 * or <code>pushScreen()</code>.
		 *
		 * @see #removeScreen()
		 */
		public function addScreen(id:String, item:StackScreenNavigatorItem):void
		{
			this.addScreenInternal(id, item);
		}

		/**
		 * Removes an existing screen using the identifier assigned to it in the
		 * call to <code>addScreen()</code>.
		 *
		 * @see #removeAllScreens()
		 * @see #addScreen()
		 */
		public function removeScreen(id:String):StackScreenNavigatorItem
		{
			var stackCount:int = this._stack.length;
			for(var i:int = stackCount - 1; i >= 0; i--)
			{
				var item:StackItem = this._stack[i];
				if(item.id === id)
				{
					this._stack.removeAt(i);
					//don't break here because there might be multiple screens
					//with this ID in the stack
				}
			}
			return StackScreenNavigatorItem(this.removeScreenInternal(id));
		}

		/**
		 * @private
		 */
		override public function removeAllScreens():void
		{
			this._stack.length = 0;
			super.removeAllScreens();
		}

		/**
		 * Returns the <code>StackScreenNavigatorItem</code> instance with the
		 * specified identifier.
		 */
		public function getScreen(id:String):StackScreenNavigatorItem
		{
			if(this._screens.hasOwnProperty(id))
			{
				return StackScreenNavigatorItem(this._screens[id]);
			}
			return null;
		}

		/**
		 * Pushes a screen onto the top of the stack.
		 *
		 * <p>A set of key-value pairs representing properties on the previous
		 * screen may be passed in. If the new screen is popped, these values
		 * may be used to restore the previous screen's state.</p>
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>pushTransition</code> property will be used instead.</p>
		 *
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * @see #pushTransition
		 */
		public function pushScreen(id:String, savedPreviousScreenProperties:Object = null, transition:Function = null):DisplayObject
		{
			if(transition === null)
			{
				var item:StackScreenNavigatorItem = this.getScreen(id);
				if(item && item.pushTransition !== null)
				{
					transition = item.pushTransition;
				}
				else
				{
					transition = this.pushTransition;
				}
			}
			if(this._activeScreenID)
			{
				this._stack[this._stack.length] = new StackItem(this._activeScreenID, savedPreviousScreenProperties);
			}
			else if(savedPreviousScreenProperties)
			{
				throw new ArgumentError("Cannot save properties for the previous screen because there is no previous screen.");
			}
			return this.showScreenInternal(id, transition);
		}

		/**
		 * Pops the current screen from the top of the stack, returning to the
		 * previous screen.
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>popTransition</code> property will be used instead.</p>
		 *
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * @see #popTransition
		 */
		public function popScreen(transition:Function = null):DisplayObject
		{
			if(this._stack.length == 0)
			{
				return this._activeScreen;
			}
			if(transition === null)
			{
				var screenItem:StackScreenNavigatorItem = this.getScreen(this._activeScreenID);
				if(screenItem && screenItem.popTransition !== null)
				{
					transition = screenItem.popTransition;
				}
				else
				{
					transition = this.popTransition;
				}
			}
			this._poppedStackItem = this._stack.pop();
			return this.showScreenInternal(this._poppedStackItem.id, transition, this._poppedStackItem.properties);
		}

		/**
		 * Returns to the root screen, at the bottom of the stack.
		 *
		 * <p>An optional transition may be specified. If <code>null</code>, the
		 * <code>popToRootTransition</code> or <code>popTransition</code>
		 * property will be used instead.</p>
		 *
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * @see #popToRootTransition
		 * @see #popTransition
		 */
		public function popToRootScreen(transition:Function = null):DisplayObject
		{
			if(this._stack.length == 0)
			{
				return this._activeScreen;
			}
			if(transition == null)
			{
				transition = this.popToRootTransition;
				if(transition == null)
				{
					transition = this.popTransition;
				}
			}
			var item:StackItem = this._stack[0];
			this._stack.length = 0;
			return this.showScreenInternal(item.id, transition, item.properties);
		}

		/**
		 * Pops all screens from the stack, leaving the
		 * <code>StackScreenNavigator</code> empty.
		 *
		 * <p>An optional transition may be specified. If <code>null</code>, the
		 * <code>popTransition</code> property will be used instead.</p>
		 *
		 * @see #popTransition
		 */
		public function popAll(transition:Function = null):void
		{
			if(!this._activeScreen)
			{
				return;
			}
			if(transition == null)
			{
				transition = this.popTransition;
			}
			this._stack.length = 0;
			this.clearScreenInternal(transition);
		}

		/**
		 * Returns to the root screen, at the bottom of the stack, but replaces
		 * it with a new root screen.
		 *
		 * <p>An optional transition may be specified. If <code>null</code>, the
		 * <code>popToRootTransition</code> or <code>popTransition</code>
		 * property will be used instead.</p>
		 *
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * @see #popToRootTransition
		 * @see #popTransition
		 */
		public function popToRootScreenAndReplace(id:String, transition:Function = null):DisplayObject
		{
			if(transition == null)
			{
				transition = this.popToRootTransition;
				if(transition == null)
				{
					transition = this.popTransition;
				}
			}
			this._stack.length = 0;
			return this.showScreenInternal(id, transition);
		}

		/**
		 * Replaces the current screen on the top of the stack with a new
		 * screen. May be used in the case where you want to navigate from
		 * screen A to screen B and then to screen C, but when popping screen C,
		 * you want to skip screen B and return to screen A.
		 * 
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * <p>An optional transition may be specified. If <code>null</code> the
		 * <code>pushTransition</code> property will be used instead.</p>
		 *
		 * @see #pushTransition
		 */
		public function replaceScreen(id:String, transition:Function = null):DisplayObject
		{
			if(transition === null)
			{
				var item:StackScreenNavigatorItem = this.getScreen(id);
				if(item && item.pushTransition !== null)
				{
					transition = item.pushTransition;
				}
				else
				{
					transition = this.pushTransition;
				}
			}
			return this.showScreenInternal(id, transition);
		}

		/**
		 * @private
		 */
		override public function hitTest(local:Point):DisplayObject
		{
			var result:DisplayObject = super.hitTest(local);
			if(this._isDragging && result !== null)
			{
				//don't allow touches to reach children while dragging
				return this;
			}
			return result;
		}

		/**
		 * @private
		 */
		override protected function prepareActiveScreen():void
		{
			var item:StackScreenNavigatorItem = StackScreenNavigatorItem(this._screens[this._activeScreenID]);
			this.addPushEventsToActiveScreen(item);
			this.addReplaceEventsToActiveScreen(item);
			this.addPopEventsToActiveScreen(item);
			this.addPopToRootEventsToActiveScreen(item);
		}

		/**
		 * @private
		 */
		override protected function cleanupActiveScreen():void
		{
			var item:StackScreenNavigatorItem = StackScreenNavigatorItem(this._screens[this._activeScreenID]);
			this.removePushEventsFromActiveScreen(item);
			this.removeReplaceEventsFromActiveScreen(item);
			this.removePopEventsFromActiveScreen(item);
			this.removePopToRootEventsFromActiveScreen(item);
		}

		/**
		 * @private
		 */
		protected function addPushEventsToActiveScreen(item:StackScreenNavigatorItem):void
		{
			var events:Object = item.pushEvents;
			var savedScreenEvents:Object = {};
			for(var eventName:String in events)
			{
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
				var eventAction:Object = events[eventName];
				if(eventAction is Function)
				{
					if(signal)
					{
						signal.add(eventAction as Function);
					}
					else
					{
						this._activeScreen.addEventListener(eventName, eventAction as Function);
					}
				}
				else if(eventAction is String)
				{
					if(signal)
					{
						var eventListener:Function = this.createPushScreenSignalListener(eventAction as String, signal);
						signal.add(eventListener);
					}
					else
					{
						eventListener = this.createPushScreenEventListener(eventAction as String);
						this._activeScreen.addEventListener(eventName, eventListener);
					}
					savedScreenEvents[eventName] = eventListener;
				}
				else
				{
					throw new TypeError("Unknown push event action defined for screen:", eventAction.toString());
				}
			}
			this._pushScreenEvents[this._activeScreenID] = savedScreenEvents;
		}

		/**
		 * @private
		 */
		protected function removePushEventsFromActiveScreen(item:StackScreenNavigatorItem):void
		{
			var pushEvents:Object = item.pushEvents;
			var savedScreenEvents:Object = this._pushScreenEvents[this._activeScreenID];
			for(var eventName:String in pushEvents)
			{
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
				var eventAction:Object = pushEvents[eventName];
				if(eventAction is Function)
				{
					if(signal)
					{
						signal.remove(eventAction as Function);
					}
					else
					{
						this._activeScreen.removeEventListener(eventName, eventAction as Function);
					}
				}
				else if(eventAction is String)
				{
					var eventListener:Function = savedScreenEvents[eventName] as Function;
					if(signal)
					{
						signal.remove(eventListener);
					}
					else
					{
						this._activeScreen.removeEventListener(eventName, eventListener);
					}
				}
			}
			this._pushScreenEvents[this._activeScreenID] = null;
		}

		/**
		 * @private
		 */
		protected function addReplaceEventsToActiveScreen(item:StackScreenNavigatorItem):void
		{
			var events:Object = item.replaceEvents;
			if(!events)
			{
				return;
			}
			var savedScreenEvents:Object = {};
			for(var eventName:String in events)
			{
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
				var eventAction:Object = events[eventName];
				if(eventAction is String)
				{
					if(signal)
					{
						var eventListener:Function = this.createReplaceScreenSignalListener(eventAction as String, signal);
						signal.add(eventListener);
					}
					else
					{
						eventListener = this.createReplaceScreenEventListener(eventAction as String);
						this._activeScreen.addEventListener(eventName, eventListener);
					}
					savedScreenEvents[eventName] = eventListener;
				}
				else
				{
					throw new TypeError("Unknown replace event action defined for screen:", eventAction.toString());
				}
			}
			if(!this._replaceScreenEvents)
			{
				this._replaceScreenEvents = {};
			}
			this._replaceScreenEvents[this._activeScreenID] = savedScreenEvents;
		}

		/**
		 * @private
		 */
		protected function removeReplaceEventsFromActiveScreen(item:StackScreenNavigatorItem):void
		{
			var replaceEvents:Object = item.replaceEvents;
			if(!replaceEvents)
			{
				return;
			}
			var savedScreenEvents:Object = this._replaceScreenEvents[this._activeScreenID];
			for(var eventName:String in replaceEvents)
			{
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
				var eventAction:Object = replaceEvents[eventName];
				if(eventAction is String)
				{
					var eventListener:Function = savedScreenEvents[eventName] as Function;
					if(signal)
					{
						signal.remove(eventListener);
					}
					else
					{
						this._activeScreen.removeEventListener(eventName, eventListener);
					}
				}
			}
			this._replaceScreenEvents[this._activeScreenID] = null;
		}

		/**
		 * @private
		 */
		protected function addPopEventsToActiveScreen(item:StackScreenNavigatorItem):void
		{
			if(!item.popEvents)
			{
				return;
			}
			//creating a copy because this array could change before the screen
			//is removed.
			var popEvents:Vector.<String> = item.popEvents.slice();
			var eventCount:int = popEvents.length;
			for(var i:int = 0; i < eventCount; i++)
			{
				var eventName:String = popEvents[i];
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
				if(signal)
				{
					signal.add(popSignalListener);
				}
				else
				{
					this._activeScreen.addEventListener(eventName, popEventListener);
				}
			}
			this._popScreenEvents = popEvents;
		}

		/**
		 * @private
		 */
		protected function removePopEventsFromActiveScreen(item:StackScreenNavigatorItem):void
		{
			if(!this._popScreenEvents)
			{
				return;
			}
			var eventCount:int = this._popScreenEvents.length;
			for(var i:int = 0; i < eventCount; i++)
			{
				var eventName:String = this._popScreenEvents[i];
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
				if(signal)
				{
					signal.remove(popSignalListener);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, popEventListener);
				}
			}
			this._popScreenEvents = null;
		}

		/**
		 * @private
		 */
		protected function removePopToRootEventsFromActiveScreen(item:StackScreenNavigatorItem):void
		{
			if(!this._popToRootScreenEvents)
			{
				return;
			}
			var eventCount:int = this._popToRootScreenEvents.length;
			for(var i:int = 0; i < eventCount; i++)
			{
				var eventName:String = this._popToRootScreenEvents[i];
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
				if(signal)
				{
					signal.remove(popToRootSignalListener);
				}
				else
				{
					this._activeScreen.removeEventListener(eventName, popToRootEventListener);
				}
			}
			this._popToRootScreenEvents = null;
		}

		/**
		 * @private
		 */
		protected function addPopToRootEventsToActiveScreen(item:StackScreenNavigatorItem):void
		{
			if(!item.popToRootEvents)
			{
				return;
			}
			//creating a copy because this array could change before the screen
			//is removed.
			var popToRootEvents:Vector.<String> = item.popToRootEvents.slice();
			var eventCount:int = popToRootEvents.length;
			for(var i:int = 0; i < eventCount; i++)
			{
				var eventName:String = popToRootEvents[i];
				var signal:Object = null;
				if(BaseScreenNavigator.SIGNAL_TYPE !== null &&
					this._activeScreen.hasOwnProperty(eventName))
				{
					signal = this._activeScreen[eventName] as BaseScreenNavigator.SIGNAL_TYPE;
				}
				if(signal)
				{
					signal.add(popToRootSignalListener);
				}
				else
				{
					this._activeScreen.addEventListener(eventName, popToRootEventListener);
				}
			}
			this._popToRootScreenEvents = popToRootEvents;
		}

		/**
		 * @private
		 */
		protected function createPushScreenEventListener(screenID:String):Function
		{
			var self:StackScreenNavigator = this;
			var eventListener:Function = function(event:Event, data:Object):void
			{
				self.pushScreen(screenID, data);
			};

			return eventListener;
		}

		/**
		 * @private
		 */
		protected function createPushScreenSignalListener(screenID:String, signal:Object):Function
		{
			var self:StackScreenNavigator = this;
			if(signal.valueClasses.length == 1)
			{
				//shortcut to avoid the allocation of the rest array
				var signalListener:Function = function(arg0:Object):void
				{
					self.pushScreen(screenID, arg0);
				};
			}
			else
			{
				signalListener = function(...rest:Array):void
				{
					var data:Object;
					if(rest.length > 0)
					{
						data = rest[0];
					}
					self.pushScreen(screenID, data);
				};
			}

			return signalListener;
		}

		/**
		 * @private
		 */
		protected function createReplaceScreenEventListener(screenID:String):Function
		{
			var self:StackScreenNavigator = this;
			var eventListener:Function = function(event:Event):void
			{
				self.replaceScreen(screenID);
			};

			return eventListener;
		}

		/**
		 * @private
		 */
		protected function createReplaceScreenSignalListener(screenID:String, signal:Object):Function
		{
			var self:StackScreenNavigator = this;
			if(signal.valueClasses.length == 0)
			{
				//shortcut to avoid the allocation of the rest array
				var signalListener:Function = function():void
				{
					self.replaceScreen(screenID);
				};
			}
			else
			{
				signalListener = function(...rest:Array):void
				{
					self.replaceScreen(screenID);
				};
			}

			return signalListener;
		}

		/**
		 * @private
		 */
		protected function handleTouchBegan(touch:Touch):void
		{
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			if(exclusiveTouch.getClaim(touch.id))
			{
				//already claimed
				return;
			}

			var point:Point = Pool.getPoint();
			touch.getLocation(this, point);
			var localX:Number = point.x;
			Pool.putPoint(point);

			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var leftInches:Number = localX / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			if(leftInches < 0 || leftInches > this._swipeToPopGestureEdgeSize)
			{
				//we're not close enough to the edge
				return;
			}

			this._touchPointID = touch.id;
			this._velocityX = 0;
			this._previousVelocityX.length = 0;
			this._previousTouchTime = getTimer();
			this._previousTouchX = this._startTouchX = this._currentTouchX = localX;
			this._isDragging = false;
			this._dragCancelled = false;

			exclusiveTouch.addEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
		}

		/**
		 * @private
		 */
		protected function handleTouchMoved(touch:Touch):void
		{
			var point:Point = Pool.getPoint();
			touch.getLocation(this, point);
			this._currentTouchX = point.x;
			Pool.putPoint(point);
			var now:int = getTimer();
			var timeOffset:int = now - this._previousTouchTime;
			if(timeOffset > 0)
			{
				//we're keeping previous velocity updates to improve accuracy
				this._previousVelocityX[this._previousVelocityX.length] = this._velocityX;
				if(this._previousVelocityX.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityX.shift();
				}
				this._velocityX = (this._currentTouchX - this._previousTouchX) / timeOffset;
				this._previousTouchTime = now;
				this._previousTouchX = this._currentTouchX;
			}
		}

		/**
		 * @private
		 */
		protected function dragTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
		{
			this._savedTransitionOnComplete = onComplete;
			this._dragEffectContext = this._dragEffectTransition(this._previousScreenInTransition, this._activeScreen, null, true);
			this._dragEffectTransition = null;
			this.handleDragMove();
		}

		/**
		 * @private
		 */
		protected function handleDragMove():void
		{
			if(this._dragEffectContext === null)
			{
				//the transition may not have started yet
				return;
			}
			var offsetX:Number = this._currentTouchX - this._startTouchX;
			this._dragEffectContext.position = offsetX / this.screenContainer.width;
		}

		/**
		 * @private
		 */
		protected function handleDragEnd():void
		{
			if(this._dragEffectContext === null)
			{
				//if we're waiting to start the transition for performance
				//reasons, force it to start immediately
				if(this._waitingTransition !== null)
				{
					this.startWaitingTransition();
				}
			}

			this._dragCancelled = false;
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			
			var sum:Number = this._velocityX * CURRENT_VELOCITY_WEIGHT;
			var velocityCount:int = this._previousVelocityX.length;
			var totalWeight:Number = CURRENT_VELOCITY_WEIGHT;
			for(var i:int = 0; i < velocityCount; i++)
			{
				var weight:Number = VELOCITY_WEIGHTS[i];
				sum += this._previousVelocityX.shift() * weight;
				totalWeight += weight;
			}

			var inchesPerSecondX:Number = 1000 * (sum / totalWeight) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			if(inchesPerSecondX < -this._minimumSwipeVelocity)
			{
				//force back to current screen
				if(this._isDragging)
				{
					this._dragCancelled = true;
				}
			}
			else
			{
				var offsetX:Number = this._currentTouchX - this._startTouchX;
				var ratio:Number = offsetX / this.screenContainer.width;
				if(ratio <= 0.5)
				{
					if(this._isDragging)
					{
						this._dragCancelled = true;
					}
				}
			}

			this._dragEffectContext.addEventListener(Event.COMPLETE, dragEffectContext_completeHandler);
			if(this._dragCancelled)
			{
				this._dragEffectContext.playReverse();
			}
			else
			{
				this._dragEffectContext.play();
			}
		}

		/**
		 * @private
		 */
		protected function checkForDrag():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var horizontalInchesMoved:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			if(horizontalInchesMoved < this._minimumDragDistance)
			{
				return;
			}

			this._dragEffectTransition = null;
			var screenItem:StackScreenNavigatorItem = this.getScreen(this._activeScreenID);
			if(screenItem && screenItem.popTransition !== null)
			{
				this._dragEffectTransition = screenItem.popTransition;
			}
			else
			{
				this._dragEffectTransition = this.popTransition;
			}
			
			//if no transition has been specified, use the default
			if(this._dragEffectTransition === null)
			{
				this._dragEffectTransition = defaultTransition;
			}

			//if this is an old transition that doesn't support being managed,
			//simply start it without management.
			if(this._dragEffectTransition.length < 4)
			{
				this._dragEffectTransition = null;
				this.popScreen();
				return;
			}

			this._isDragging = true;
			this.popScreen(dragTransition);
			this._startTouchX = this._currentTouchX;
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
			exclusiveTouch.claimTouch(this._touchPointID, this);
			this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
		}

		/**
		 * @private
		 */
		override protected function transitionComplete(cancelTransition:Boolean = false):void
		{
			this._poppedStackItem = null;
			super.transitionComplete(cancelTransition);
		}

		/**
		 * @private
		 */
		protected function popEventListener(event:Event):void
		{
			this.popScreen();
		}

		/**
		 * @private
		 */
		protected function popSignalListener(...rest:Array):void
		{
			this.popScreen();
		}

		/**
		 * @private
		 */
		protected function popToRootEventListener(event:Event):void
		{
			this.popToRootScreen();
		}

		/**
		 * @private
		 */
		protected function popToRootSignalListener(...rest:Array):void
		{
			this.popToRootScreen();
		}

		/**
		 * @private
		 */
		protected function stackScreenNavigator_initializeHandler(event:Event):void
		{
			if(this._tempRootScreenID !== null)
			{
				var screenID:String = this._tempRootScreenID;
				this._tempRootScreenID = null;
				this.showScreenInternal(screenID, null);
			}
		}

		/**
		 * @private
		 */
		protected function stackScreenNavigator_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || !this._isSwipeToPopEnabled || (this._stack.length == 0 && !this._isDragging))
			{
				this._touchPointID = -1;
				return;
			}
			if(this._touchPointID != -1)
			{
				var touch:Touch = event.getTouch(this, null, this._touchPointID);
				if(touch === null)
				{
					return;
				}
				if(touch.phase === TouchPhase.MOVED)
				{
					this.handleTouchMoved(touch);

					if(!this._isDragging)
					{
						this.checkForDrag();
					}
					if(this._isDragging)
					{
						this.handleDragMove();
					}
				}
				else if(touch.phase === TouchPhase.ENDED)
				{
					this._touchPointID = -1;
					if(this._isDragging)
					{
						this.handleDragEnd();
						this.dispatchEventWith(FeathersEventType.END_INTERACTION);
					}
				}
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(touch === null)
				{
					return;
				}
				this.handleTouchBegan(touch);
			}
		}

		/**
		 * @private
		 */
		protected function exclusiveTouch_changeHandler(event:Event, touchID:int):void
		{
			if(this._touchPointID == -1 || this._touchPointID != touchID || this._isDragging)
			{
				return;
			}

			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			if(exclusiveTouch.getClaim(touchID) === this)
			{
				return;
			}

			this._touchPointID = -1;
		}

		/**
		 * @private
		 */
		protected function dragEffectContext_completeHandler(event:Event):void
		{
			this._dragEffectContext.removeEventListeners();
			this._dragEffectContext = null;
			this._isDragging = false;
			var cancelled:Boolean = this._dragCancelled;
			this._dragCancelled = false;
			var onComplete:Function = this._savedTransitionOnComplete;
			this._savedTransitionOnComplete = null;
			if(cancelled)
			{
				this._stack[this._stack.length] = this._poppedStackItem;
			}
			onComplete(cancelled);
		}
	}
}

final class StackItem
{
	public function StackItem(id:String, properties:Object)
	{
		this.id = id;
		this.properties = properties;
	}

	public var id:String;
	public var properties:Object;
}
