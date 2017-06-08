/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.BaseScreenNavigator;
	import feathers.core.IFeathersControl;
	import feathers.data.IListCollection;
	import feathers.data.VectorCollection;
	import feathers.events.ExclusiveTouch;
	import feathers.events.FeathersEventType;
	import feathers.layout.Direction;
	import feathers.layout.RelativePosition;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import flash.geom.Point;
	import flash.utils.getTimer;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	/**
	 * A style name to add to the navigator's tab bar sub-component.
	 * Typically used by a theme to provide different styles to different
	 * navigators.
	 *
	 * <p>In the following example, a custom tab bar style name is passed
	 * to the navigator:</p>
	 *
	 * <listing version="3.0">
	 * navigator.customTabBarStyleName = "my-custom-tab-bar";</listing>
	 *
	 * <p>In your theme, you can target this sub-component style name to
	 * provide different styles than the default:</p>
	 *
	 * <listing version="3.0">
	 * getStyleProviderForClass( TabBar ).setFunctionForStyleName( "my-custom-tab-bar", setCustomTabBarStyles );</listing>
	 *
	 * @default null
	 *
	 * @see #DEFAULT_CHILD_STYLE_NAME_TAB_BAR
	 * @see feathers.core.FeathersControl#styleNameList
	 * @see #tabBarFactory
	 */
	[Style(name="customTabBarStyleName",type="String")]

	/**
	 * The duration, in seconds, of the animation for a swipe gesture.
	 *
	 * <p>In the following example, the duration of the animation for a swipe
	 * gesture is set to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * navigator.swipeDuration = 0.5;</listing>
	 *
	 * @default 0.25
	 *
	 * @see #style:swipeEase
	 * @see #isSwipeEnabled
	 */
	[Style(name="swipeDuration",type="Number")]

	/**
	 * The easing function used with the animation for a swipe gesture.
	 *
	 * <p>In the following example, the ease of the animation for a swipe
	 * gesture is customized:</p>
	 *
	 * <listing version="3.0">
	 * navigator.swipeEase = Transitions.EASE_IN_OUT;</listing>
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 *
	 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
	 * @see #style:swipeDuration
	 * @see #isSwipeEnabled
	 */
	[Style(name="swipeEase",type="Object")]

	/**
	 * The location of the tab bar.
	 *
	 * <p>The following example positions the tab bar on the top of the
	 * navigator:</p>
	 *
	 * <listing version="3.0">
	 * navigator.tabBarPosition = RelativePosition.TOP;</listing>
	 *
	 * @default feathers.layout.RelativePosition.BOTTOM
	 *
	 * @see feathers.layout.RelativePosition#TOP
	 * @see feathers.layout.RelativePosition#RIGHT
	 * @see feathers.layout.RelativePosition#BOTTOM
	 * @see feathers.layout.RelativePosition#LEFT
	 */
	[Style(name="tabBarPosition",type="String")]

	/**
	 * Typically used to provide some kind of animation or visual effect,
	 * this function is called when a new screen is shown.
	 *
	 * <p>In the following example, the tab navigator is given a
	 * transition that fades in the new screen on top of the old screen:</p>
	 *
	 * <listing version="3.0">
	 * navigator.transition = Fade.createFadeInTransition();</listing>
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
	 * when the transition effect finishes.This callback indicate to the
	 * tab navigator that the transition has finished. This function has
	 * the following signature:</p>
	 *
	 * <pre>function(cancelTransition:Boolean = false):void</pre>
	 *
	 * <p>The first argument defaults to <code>false</code>, meaning that
	 * the transition completed successfully. In most cases, this callback
	 * may be called without arguments. If a transition is cancelled before
	 * completion (perhaps through some kind of user interaction), and the
	 * previous screen should be restored, pass <code>true</code> as the
	 * first argument to the callback to inform the tab navigator that
	 * the transition is cancelled.</p>
	 *
	 * @default null
	 *
	 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
	 * @see #showScreen()
	 */
	[Style(name="transition",type="Function")]

	/**
	 * Dispatched when one of the tabs is triggered. The <code>data</code>
	 * property of the event contains the <code>TabNavigatorItem</code> that is
	 * associated with the tab that was triggered.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The <code>TabNavigatorItem</code>
	 *   associated with the tab that was triggered.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.TRIGGERED
	 */
	[Event(name="triggered", type="starling.events.Event")]

	/**
	 * Dispatched when the user starts a swipe gesture to switch tabs.
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
	 * @eventType feathers.events.FeathersEventType.BEGIN_INTERACTION
	 * @see #event:endInteraction feathers.events.FeathersEventType.END_INTERACTION
	 * @see #isSwipeEnabled
	 */
	[Event(name="beginInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when the user stops a swipe gesture. If the user interaction
	 * has also triggered an animation, the content may continue moving after
	 * this event is dispatched.
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
	 * @eventType feathers.events.FeathersEventType.END_INTERACTION
	 * @see #event:beginInteraction feathers.events.FeathersEventType.BEGIN_INTERACTION
	 * @see #isSwipeEnabled
	 */
	[Event(name="endInteraction",type="starling.events.Event")]

	/**
	 * A tabbed container.
	 *
	 * <p>The following example creates a tab navigator, adds a couple of tabs
	 * and displays the navigator:</p>
	 *
	 * <listing version="3.0">
	 * var navigator:TabNavigator = new TabNavigator();
	 * navigator.addScreen( "newsFeed", new TabNavigatorItem( NewsFeedTab, "News" ) );
	 * navigator.addScreen( "profile", new TabNavigatorItem( ProfileTab, "Profile" ) );
	 * this.addChild( navigator );
	 * </listing>
	 *
	 * @see ../../../help/tab-navigator.html How to use the Feathers TabNavigator component
	 * @see feathers.controls.TabNavigatorItem
	 *
	 * @productversion Feathers 3.1.0
	 */
	public class TabNavigator extends BaseScreenNavigator
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
		 * @private
		 */
		protected static const INVALIDATION_FLAG_TAB_BAR_FACTORY:String = "tabBarFactory";

		/**
		 * The default value added to the <code>styleNameList</code> of the tab
		 * bar.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_TAB_BAR:String = "feathers-tab-navigator-tab-bar";

		/**
		 * The default <code>IStyleProvider</code> for all <code>TabNavigator</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultTabBarFactory():TabBar
		{
			return new TabBar();
		}

		/**
		 * Constructor.
		 */
		public function TabNavigator()
		{
			super();
			this.screenContainer = new LayoutGroup();
			this.screenContainer.addEventListener(TouchEvent.TOUCH, screenContainer_touchHandler);
			this.addChild(this.screenContainer);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return TabNavigator.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _selectedIndex:int = -1;

		/**
		 * The index of the currently selected tab. Returns <code>-1</code> if
		 * no tab is selected.
		 *
		 * <p>In the following example, the tab navigator's selected index is changed:</p>
		 *
		 * <listing version="3.0">
		 * navigator.selectedIndex = 2;</listing>
		 *
		 * <p>The following example listens for when selection changes and
		 * requests the selected index:</p>
		 *
		 * <listing version="3.0">
		 * function navigator_changeHandler( event:Event ):void
		 * {
		 *     var navigator:TabNavigator = TabNavigator( event.currentTarget );
		 *     var index:int = navigator.selectedIndex;
		 *
		 * }
		 * navigator.addEventListener( Event.CHANGE, navigator_changeHandler );</listing>
		 *
		 * @default -1
		 */
		public function get selectedIndex():int
		{
			return this._selectedIndex;
		}

		/**
		 * @private
		 */
		public function set selectedIndex(value:int):void
		{
			if(this._selectedIndex === value)
			{
				return;
			}
			this._selectedIndex = value;
			if(value < 0)
			{
				this.clearScreenInternal();
			}
			else
			{
				var id:String = this._tabBarDataProvider.getItemAt(this._selectedIndex) as String;
				if(this._activeScreenID === id)
				{
					return;
				}
				this.showScreen(id);
			}
		}

		/**
		 * The value added to the <code>styleNameList</code> of the tab bar.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the tab bar style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TAB_BAR</code>.
		 *
		 * <p>To customize the tab bar style name without subclassing, see
		 * <code>customTabBarStyleName</code>.</p>
		 *
		 * @see #style:customTabBarStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var tabBarStyleName:String = DEFAULT_CHILD_STYLE_NAME_TAB_BAR;

		//this would be a VectorCollection with a Vector.<String>, but the ASC1
		//compiler doesn't like it!
		/**
		 * @private
		 */
		protected var _tabBarDataProvider:IListCollection = new VectorCollection(new <String>[]);

		/**
		 * @private
		 */
		protected var tabBar:TabBar;

		/**
		 * @private
		 */
		protected var _tabBarFactory:Function;

		/**
		 * A function used to generate the navigator's tab bar sub-component.
		 * The tab bar must be an instance of <code>TabBar</code> (or a
		 * subclass). This factory can be used to change properties on the tab
		 * bar when it is first created. For instance, if you are skinning
		 * Feathers components without a theme, you might use this factory to
		 * set skins and other styles on the tab bar.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():TabBar</pre>
		 *
		 * <p>In the following example, a custom tab bar factory is passed
		 * to the navigator:</p>
		 *
		 * <listing version="3.0">
		 * navigator.tabBarFactory = function():TabBar
		 * {
		 *     var tabs:TabBar = new TabBar();
		 *     tabs.distributeTabSizes = true;
		 *     return tabs;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.TabBar
		 */
		public function get tabBarFactory():Function
		{
			return this._tabBarFactory;
		}

		/**
		 * @private
		 */
		public function set tabBarFactory(value:Function):void
		{
			if(this._tabBarFactory == value)
			{
				return;
			}
			this._tabBarFactory = value;
			this.invalidate(INVALIDATION_FLAG_TAB_BAR_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customTabBarStyleName:String;

		/**
		 * @private
		 */
		public function get customTabBarStyleName():String
		{
			return this._customTabBarStyleName;
		}

		/**
		 * @private
		 */
		public function set customTabBarStyleName(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._customTabBarStyleName === value)
			{
				return;
			}
			this._customTabBarStyleName = value;
			this.invalidate(INVALIDATION_FLAG_TAB_BAR_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _tabBarPosition:String = RelativePosition.BOTTOM;

		[Inspectable(type="String",enumeration="top,right,bottom,left")]
		/**
		 * @private
		 */
		public function get tabBarPosition():String
		{
			return this._tabBarPosition;
		}

		/**
		 * @private
		 */
		public function set tabBarPosition(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._tabBarPosition === value)
			{
				return;
			}
			this._tabBarPosition = value;
			this.invalidate(INVALIDATION_FLAG_TAB_BAR_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _transition:Function;

		/**
		 * @private
		 */
		public function get transition():Function
		{
			return this._transition;
		}

		/**
		 * @private
		 */
		public function set transition(value:Function):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._transition = value;
		}

		/**
		 * @private
		 */
		protected var _dragCancelled:Boolean = false;

		/**
		 * @private
		 */
		protected var _isDragging:Boolean = false;

		/**
		 * @private
		 */
		protected var _isDraggingPrevious:Boolean = false;

		/**
		 * @private
		 */
		protected var _isDraggingNext:Boolean = false;

		/**
		 * @private
		 */
		protected var _swipeTween:Tween = null;

		/**
		 * @private
		 */
		protected var _isSwipeEnabled:Boolean = false;

		/**
		 * Determines if the swipe gesture to switch between tabs is enabled.
		 * 
		 * <p>In the following example, swiping between tabs is enabled:</p>
		 *
		 * <listing version="3.0">
		 * navigator.isSwipeEnabled = true;</listing>
		 * 
		 * @default false
		 */
		public function get isSwipeEnabled():Boolean
		{
			return this._swipeDuration;
		}

		/**
		 * @private
		 */
		public function set isSwipeEnabled(value:Boolean):void
		{
			this._isSwipeEnabled = value;
		}

		/**
		 * @private
		 */
		protected var _swipeDuration:Number = 0.25;

		/**
		 * @private
		 */
		public function get swipeDuration():Number
		{
			return this._swipeDuration;
		}

		/**
		 * @private
		 */
		public function set swipeDuration(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._swipeDuration = value;
		}

		/**
		 * @private
		 */
		protected var _swipeEase:Object = Transitions.EASE_OUT;

		/**
		 * @private
		 */
		public function get swipeEase():Object
		{
			return this._swipeEase;
		}

		/**
		 * @private
		 */
		public function set swipeEase(value:Object):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._swipeEase = value;
		}

		/**
		 * @private
		 */
		protected var _minimumDragDistance:Number = 0.04;

		/**
		 * The minimum physical distance (in inches) that a touch must move
		 * before a drag gesture begins.
		 *
		 * <p>In the following example, the minimum drag distance is customized:</p>
		 *
		 * <listing version="3.0">
		 * scroller.minimumDragDistance = 0.1;</listing>
		 *
		 * @default 0.04
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
		 * screen to navigate to base don which one is closer when the touch ends.
		 *
		 * <p>In the following example, the minimum swipe velocity is customized:</p>
		 *
		 * <listing version="3.0">
		 * navigator.minimumSwipeVelocity = 2;</listing>
		 *
		 * @default 5
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
		protected var _startTouchX:Number;

		/**
		 * @private
		 */
		protected var _startTouchY:Number;

		/**
		 * @private
		 */
		protected var _currentTouchX:Number;

		/**
		 * @private
		 */
		protected var _currentTouchY:Number;

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
		protected var _previousTouchY:Number;

		/**
		 * @private
		 */
		protected var _velocityX:Number = 0;

		/**
		 * @private
		 */
		protected var _velocityY:Number = 0;

		/**
		 * @private
		 */
		protected var _previousVelocityX:Vector.<Number> = new <Number>[];

		/**
		 * @private
		 */
		protected var _previousVelocityY:Vector.<Number> = new <Number>[];

		/**
		 * @private
		 */
		protected var _savedTransitionOnComplete:Function;

		/**
		 * Registers a new screen with a string identifier that can be used
		 * to reference the screen in other calls, like <code>removeScreen()</code>
		 * or <code>showScreen()</code>.
		 *
		 * @see #addScreenAt()
		 * @see #removeScreen()
		 * @see #removeScreenAt()
		 */
		public function addScreen(id:String, item:TabNavigatorItem):void
		{
			this.addScreenAt(id, item, this._tabBarDataProvider.length);
		}

		/**
		 * Registers a new screen with a string identifier that can be used
		 * to reference the screen in other calls, like <code>removeScreen()</code>
		 * or <code>showScreen()</code>.
		 *
		 * @see #addScreen()
		 * @see #removeScreen()
		 * @see #removeScreenAt()
		 */
		public function addScreenAt(id:String, item:TabNavigatorItem, index:int):void
		{
			this.addScreenInternal(id, item);
			this._tabBarDataProvider.addItemAt(id, index);
			if(this._selectedIndex < 0 && this._tabBarDataProvider.length === 1)
			{
				this.selectedIndex = 0;
			}
		}

		/**
		 * Removes an existing screen using the identifier assigned to it in the
		 * call to <code>addScreen()</code> or <code>addScreenAt()</code>.
		 *
		 * @see #removeScreenAt()
		 * @see #removeAllScreens()
		 * @see #addScreen()
		 * @see #addScreenAt()
		 */
		public function removeScreen(id:String):TabNavigatorItem
		{
			this._tabBarDataProvider.removeItem(id);
			return TabNavigatorItem(this.removeScreenInternal(id));
		}

		/**
		 * Removes an existing screen using the identifier assigned to it in the
		 * call to <code>addScreen()</code>.
		 *
		 * @see #removeScreen()
		 * @see #removeAllScreens()
		 * @see #addScreen()
		 * @see #addScreenAt()
		 */
		public function removeScreenAt(index:int):TabNavigatorItem
		{
			var id:String = this._tabBarDataProvider.removeItemAt(index) as String;
			return TabNavigatorItem(this.removeScreenInternal(id));
		}

		/**
		 * @private
		 */
		override public function removeAllScreens():void
		{
			this._tabBarDataProvider.removeAll();
			super.removeAllScreens();
		}

		/**
		 *
		 * Displays the screen with the specified id. An optional transition may
		 * be passed in. If <code>null</code> the <code>transition</code>
		 * property will be used instead.
		 *
		 * <p>Returns a reference to the new screen, unless a transition is
		 * currently active. In that case, the new screen will be queued until
		 * the transition has completed, and no reference will be returned.</p>
		 *
		 * @see #transition
		 */
		public function showScreen(id:String, transition:Function = null):DisplayObject
		{
			if(this._activeScreenID === id)
			{
				//if we're already showing this id, do nothing
				return this._activeScreen;
			}
			if(transition === null)
			{
				var item:TabNavigatorItem = this.getScreen(id);
				if(item !== null && item.transition !== null)
				{
					transition = item.transition;
				}
				else
				{
					transition = this.transition;
				}
			}
			//showScreenInternal() dispatches Event.CHANGE, so we want to be
			//sure that the selectedIndex property returns the correct value
			this._selectedIndex = this._tabBarDataProvider.getItemIndex(id);
			var result:DisplayObject = this.showScreenInternal(id, transition);
			//however, we don't want to set the tab bar's selectedIndex before
			//calling setScreenInternal() because it would cause showScreen()
			//to be called again if we did it first
			this.tabBar.selectedIndex = this._selectedIndex;
			return result;
		}

		/**
		 * Returns the <code>TabNavigatorItem</code> instance with the
		 * specified identifier.
		 */
		public function getScreen(id:String):TabNavigatorItem
		{
			if(this._screens.hasOwnProperty(id))
			{
				return TabNavigatorItem(this._screens[id]);
			}
			return null;
		}

		/**
		 * @private
		 */
		override public function hitTest(localPoint:Point):DisplayObject
		{
			var result:DisplayObject = super.hitTest(localPoint);
			if(result)
			{
				if(this._isDragging)
				{
					return this.screenContainer;
				}
				return result;
			}
			//we want to register touches in our hitArea as a last resort
			if(!this.visible || !this.touchable)
			{
				return null;
			}
			return this._hitArea.contains(localPoint.x, localPoint.y) ? this.screenContainer : null;
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var tabBarFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TAB_BAR_FACTORY);

			if(tabBarFactoryInvalid)
			{
				this.createTabBar();
			}

			super.draw();
		}

		/**
		 * Creates and adds the <code>tabBar</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #tabBar
		 * @see #tabBarFactory
		 * @see #style:customTabBarStyleName
		 */
		protected function createTabBar():void
		{
			if(this.tabBar)
			{
				this.tabBar.removeFromParent(true);
				this.tabBar = null;
			}

			var factory:Function = this._tabBarFactory != null ? this._tabBarFactory : defaultTabBarFactory;
			var tabBarStyleName:String = this._customTabBarStyleName != null ? this._customTabBarStyleName : this.tabBarStyleName;
			this.tabBar = TabBar(factory());
			this.tabBar.styleNameList.add(tabBarStyleName);
			if(this._tabBarPosition === RelativePosition.LEFT ||
				this._tabBarPosition === RelativePosition.RIGHT)
			{
				this.tabBar.direction = Direction.VERTICAL;
			}
			else //top or bottom
			{
				this.tabBar.direction = Direction.HORIZONTAL;
			}
			this.tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			this.tabBar.addEventListener(Event.TRIGGERED, tabBar_triggeredHandler);
			this.tabBar.dataProvider = this._tabBarDataProvider;
			this.tabBar.labelFunction = this.getTabLabel;
			this.tabBar.iconFunction = this.getTabIcon;
			this.addChild(this.tabBar);
		}

		/**
		 * @private
		 */
		protected function getTabLabel(id:String):String
		{
			var item:TabNavigatorItem = this.getScreen(id);
			return item.label;
		}

		/**
		 * @private
		 */
		protected function getTabIcon(id:String):DisplayObject
		{
			var item:TabNavigatorItem = this.getScreen(id);
			return item.icon;
		}

		/**
		 * @private
		 */
		override protected function prepareActiveScreen():void
		{
			if(this._activeScreen is StackScreenNavigator)
			{
				//always show root screen when switching to this tab
				StackScreenNavigator(this._activeScreen).popToRootScreen(defaultTransition);
			}
		}

		/**
		 * @private
		 */
		override protected function cleanupActiveScreen():void
		{
		}

		/**
		 * @private
		 */
		override protected function layoutChildren():void
		{
			var screenWidth:Number = this.actualWidth;
			var screenHeight:Number = this.actualHeight;
			if(this._tabBarPosition === RelativePosition.LEFT ||
				this._tabBarPosition === RelativePosition.RIGHT)
			{
				this.tabBar.y = 0;
				this.tabBar.height = this.actualHeight;
				this.tabBar.validate();
				if(this._tabBarPosition === RelativePosition.LEFT)
				{
					this.tabBar.x = 0;
				}
				else
				{
					this.tabBar.x = this.actualWidth - this.tabBar.width;
				}
				screenWidth -= this.tabBar.width;
			}
			else //top or bottom
			{
				this.tabBar.x = 0;
				this.tabBar.width = this.actualWidth;
				this.tabBar.validate();
				if(this._tabBarPosition === RelativePosition.TOP)
				{
					this.tabBar.y = 0;
				}
				else
				{
					this.tabBar.y = this.actualHeight - this.tabBar.height;
				}
				screenHeight -= this.tabBar.height;
			}

			if(this._tabBarPosition === RelativePosition.LEFT)
			{
				this.screenContainer.x = this.tabBar.width;
			}
			else //top, bottom, or right
			{
				this.screenContainer.x = 0;
			}
			if(this._tabBarPosition === RelativePosition.TOP)
			{
				this.screenContainer.y = this.tabBar.height;
			}
			else //right, left, or bottom
			{
				this.screenContainer.y = 0;
			}
			this.screenContainer.width = screenWidth;
			this.screenContainer.height = screenHeight;
			if(this._activeScreen !== null)
			{
				this._activeScreen.x = 0;
				this._activeScreen.y = 0;
				this._activeScreen.width = screenWidth;
				this._activeScreen.height = screenHeight;
			}
		}

		/**
		 * @private
		 */
		protected function tabBar_triggeredHandler(event:Event, id:String):void
		{
			this.dispatchEventWith(Event.TRIGGERED, false, this.getScreen(id));
			if(id !== this._activeScreenID)
			{
				return;
			}
			if(this._activeScreen is StackScreenNavigator)
			{
				var navigator:StackScreenNavigator = StackScreenNavigator(this._activeScreen);
				navigator.popToRootScreen();
			}
		}

		/**
		 * @private
		 */
		protected function tabBar_changeHandler(event:Event):void
		{
			var id:String = this.tabBar.selectedItem as String;
			if(this._activeScreenID === id)
			{
				//we're already showing this screen, so no need to do anything
				//this probably isn't a bug because we sometimes update the
				//tab bar's selected index after the activeScreenID is updated
				return;
			}
			var transition:Function = null;
			if(this._activeScreenID === null)
			{
				transition = defaultTransition;
			}
			this.showScreen(id, transition);
		}

		/**
		 * @private
		 */
		protected function exclusiveTouch_changeHandler(event:Event, touchID:int):void
		{
			if(this.touchPointID < 0 || this.touchPointID != touchID || this._isDragging)
			{
				return;
			}

			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			if(exclusiveTouch.getClaim(touchID) == this)
			{
				return;
			}

			this.touchPointID = -1;
		}

		/**
		 * @private
		 */
		protected function dragTransition(oldScreen:IFeathersControl, newScreen:IFeathersControl, onComplete:Function):void
		{
			this._savedTransitionOnComplete = onComplete;
			if(this._swipeTween !== null)
			{
				//it's possible that TouchPhase.ENDED is dispatched before the
				//transition starts. if that's the case, the tween will already
				//be created, and we simply add it to the juggler.
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				starling.juggler.add(this._swipeTween);
			}
			else
			{
				this.handleDragMove();
			}
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
			var localY:Number = point.y;
			Pool.putPoint(point);

			this.touchPointID = touch.id;
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
			this._previousTouchTime = getTimer();
			this._previousTouchX = this._startTouchX = this._currentTouchX = localX;
			this._previousTouchY = this._startTouchY = this._currentTouchY = localY;
			this._isDraggingPrevious = false;
			this._isDraggingNext = false;
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
			this._currentTouchY = point.y;
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
				this._previousVelocityY[this._previousVelocityY.length] = this._velocityY;
				if(this._previousVelocityY.length > MAXIMUM_SAVED_VELOCITY_COUNT)
				{
					this._previousVelocityY.shift();
				}
				this._velocityX = (this._currentTouchX - this._previousTouchX) / timeOffset;
				this._velocityY = (this._currentTouchY - this._previousTouchY) / timeOffset;
				this._previousTouchTime = now;
				this._previousTouchX = this._currentTouchX;
				this._previousTouchY = this._currentTouchY;
			}
		}

		/**
		 * @private
		 */
		protected function handleDragMove():void
		{
			if(this._tabBarPosition === RelativePosition.LEFT ||
				this._tabBarPosition === RelativePosition.RIGHT)
			{
				this._previousScreenInTransition.y = this._currentTouchY - this._startTouchY;
			}
			else //top or bottom
			{
				this._previousScreenInTransition.x = this._currentTouchX - this._startTouchX;
			}
			this.swipeTween_onUpdate();
		}

		/**
		 * @private
		 */
		override protected function transitionComplete(cancelTransition:Boolean = false):void
		{
			if(cancelTransition)
			{
				this._selectedIndex = this._tabBarDataProvider.getItemIndex(this._previousScreenInTransitionID);
				this.tabBar.selectedIndex = this._selectedIndex;
			}
			super.transitionComplete(cancelTransition);
		}

		/**
		 * @private
		 */
		protected function swipeTween_onUpdate():void
		{
			if(this._tabBarPosition === RelativePosition.LEFT ||
				this._tabBarPosition === RelativePosition.RIGHT)
			{
				if(this._isDraggingPrevious)
				{
					this._activeScreen.x = this._previousScreenInTransition.x;
					this._activeScreen.y = this._previousScreenInTransition.y - this._activeScreen.height;
				}
				else if(this._isDraggingNext)
				{
					this._activeScreen.x = this._previousScreenInTransition.x;
					this._activeScreen.y = this._previousScreenInTransition.y + this._previousScreenInTransition.height;
				}
			}
			else //top or bottom
			{
				if(this._isDraggingPrevious)
				{
					this._activeScreen.x = this._previousScreenInTransition.x - this._activeScreen.width;
					this._activeScreen.y = this._previousScreenInTransition.y;
				}
				else if(this._isDraggingNext)
				{
					this._activeScreen.x = this._previousScreenInTransition.x + this._previousScreenInTransition.width;
					this._activeScreen.y = this._previousScreenInTransition.y;
				}
			}
		}

		/**
		 * @private
		 */
		protected function swipeTween_onComplete():void
		{
			this._swipeTween = null;
			this._isDragging = false;
			this._isDraggingPrevious = false;
			this._isDraggingNext = false;
			var cancelled:Boolean = this._dragCancelled;
			this._dragCancelled = false;
			var onComplete:Function = this._savedTransitionOnComplete;
			this._savedTransitionOnComplete = null;
			onComplete(cancelled);
		}

		/**
		 * @private
		 */
		protected function handleDragEnd():void
		{
			this._dragCancelled = false;
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			if(this._tabBarPosition === RelativePosition.LEFT ||
				this._tabBarPosition === RelativePosition.RIGHT)
			{
				//take the average for more accuracy
				var sum:Number = this._velocityY * CURRENT_VELOCITY_WEIGHT;
				var velocityCount:int = this._previousVelocityY.length;
				var totalWeight:Number = CURRENT_VELOCITY_WEIGHT;
				for(var i:int = 0; i < velocityCount; i++)
				{
					var weight:Number = VELOCITY_WEIGHTS[i];
					sum += this._previousVelocityY.shift() * weight;
					totalWeight += weight;
				}
				var inchesPerSecondY:Number = 1000 * (sum / totalWeight) / (DeviceCapabilities.dpi / starling.contentScaleFactor);

				if(inchesPerSecondY < -this._minimumSwipeVelocity)
				{
					//force next
					if(this._isDraggingPrevious)
					{
						this._dragCancelled = true;
					}
				}
				else if(inchesPerSecondY > this._minimumSwipeVelocity)
				{
					//force previous
					if(this._isDraggingNext)
					{
						this._dragCancelled = true;
					}
				}
				else if(this._activeScreen.y >= (this.screenContainer.height / 2))
				{
					if(this._isDraggingNext)
					{
						this._dragCancelled = true;
					}
				}
				else if(this._activeScreen.y <= -(this.screenContainer.height / 2))
				{
					if(this._isDraggingPrevious)
					{
						this._dragCancelled = true;
					}
				}
			}
			else //top or bottom
			{
				sum = this._velocityX * CURRENT_VELOCITY_WEIGHT;
				velocityCount = this._previousVelocityX.length;
				totalWeight = CURRENT_VELOCITY_WEIGHT;
				for(i = 0; i < velocityCount; i++)
				{
					weight = VELOCITY_WEIGHTS[i];
					sum += this._previousVelocityX.shift() * weight;
					totalWeight += weight;
				}

				var inchesPerSecondX:Number = 1000 * (sum / totalWeight) / (DeviceCapabilities.dpi / starling.contentScaleFactor);

				if(inchesPerSecondX < -this._minimumSwipeVelocity)
				{
					//force next
					if(this._isDraggingPrevious)
					{
						this._dragCancelled = true;
					}
				}
				else if(inchesPerSecondX > this._minimumSwipeVelocity)
				{
					//force previous
					if(this._isDraggingNext)
					{
						this._dragCancelled = true;
					}
				}
				else if(this._activeScreen.x >= (this.screenContainer.width / 2))
				{
					if(this._isDraggingNext)
					{
						this._dragCancelled = true;
					}
				}
				else if(this._activeScreen.x <= -(this.screenContainer.width / 2))
				{
					if(this._isDraggingPrevious)
					{
						this._dragCancelled = true;
					}
				}
			}

			this._swipeTween = new Tween(this._previousScreenInTransition, this._swipeDuration, this._swipeEase);
			if(this._tabBarPosition === RelativePosition.LEFT ||
				this._tabBarPosition === RelativePosition.RIGHT)
			{
				if(this._dragCancelled)
				{
					this._swipeTween.animate("y", 0);
				}
				else if(this._isDraggingPrevious)
				{
					this._swipeTween.animate("y", this.screenContainer.height);
				}
				else if(this._isDraggingNext)
				{
					this._swipeTween.animate("y", -this.screenContainer.height);
				}
			}
			else //top or bottom
			{
				if(this._dragCancelled)
				{
					this._swipeTween.animate("x", 0);
				}
				else if(this._isDraggingPrevious)
				{
					this._swipeTween.animate("x", this.screenContainer.width);
				}
				else if(this._isDraggingNext)
				{
					this._swipeTween.animate("x", -this.screenContainer.width);
				}
			}
			this._swipeTween.onUpdate = this.swipeTween_onUpdate;
			this._swipeTween.onComplete = this.swipeTween_onComplete;
			if(this._savedTransitionOnComplete !== null)
			{
				//it's possible that we get here before the transition has
				//officially start. if that's the case, we won't add the tween
				//to the juggler now, and we'll do it later.
				starling.juggler.add(this._swipeTween);
			}
		}

		/**
		 * @private
		 */
		protected function checkForDrag():void
		{
			var maxIndex:int = this._tabBarDataProvider.length - 1;
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var horizontalInchesMoved:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			var verticalInchesMoved:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			if(this._tabBarPosition === RelativePosition.LEFT ||
				this._tabBarPosition === RelativePosition.RIGHT)
			{
				if(this._selectedIndex > 0 && verticalInchesMoved >= this._minimumDragDistance)
				{
					this._isDraggingPrevious = true;
				}
				else if(this._selectedIndex < maxIndex && verticalInchesMoved <= -this._minimumDragDistance)
				{
					this._isDraggingNext = true;
				}
			}
			else //top or bottom
			{
				if(this._selectedIndex > 0 && horizontalInchesMoved >= this._minimumDragDistance)
				{
					this._isDraggingPrevious = true;
				}
				else if(this._selectedIndex < maxIndex && horizontalInchesMoved <= -this._minimumDragDistance)
				{
					this._isDraggingNext = true;
				}
			}

			if(this._isDraggingPrevious)
			{
				var previousIndex:int = this._selectedIndex - 1;
				this._isDragging = true;
				var previousID:String = this._tabBarDataProvider.getItemAt(previousIndex) as String;
				this.showScreen(previousID, dragTransition);
			}
			if(this._isDraggingNext)
			{
				var nextIndex:int = this._selectedIndex + 1;
				this._isDragging = true;
				var nextID:String = this._tabBarDataProvider.getItemAt(nextIndex) as String;
				this.showScreen(nextID, dragTransition);
			}
			if(this._isDragging)
			{
				this._startTouchX = this._currentTouchX;
				this._startTouchY = this._currentTouchY;
				var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
				exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
				exclusiveTouch.claimTouch(this.touchPointID, this);
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			}
		}

		/**
		 * @private
		 */
		protected function screenContainer_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || this._swipeTween !== null || !this._isSwipeEnabled)
			{
				this.touchPointID = -1;
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.screenContainer, null, this.touchPointID);
				if(!touch)
				{
					return;
				}
				if(touch.phase == TouchPhase.MOVED)
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
				else if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
					if(this._isDragging)
					{
						this.handleDragEnd();
						this.dispatchEventWith(FeathersEventType.END_INTERACTION);
					}
				}
			}
			else
			{
				touch = event.getTouch(this.screenContainer, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this.handleTouchBegan(touch);
			}
		}
	}
}
