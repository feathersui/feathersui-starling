/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.BaseScreenNavigator;
	import feathers.data.ListCollection;
	import feathers.layout.Direction;
	import feathers.layout.RelativePosition;
	import feathers.skins.IStyleProvider;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * A tabbed container.
	 *
	 * <p>The following example creates a tab navigator, adds a tab and
	 * displays it:</p>
	 *
	 * <listing version="3.0">
	 * </listing>
	 *
	 * @see ../../../help/tab-navigator.html How to use the Feathers TabNavigator component
	 * @see feathers.controls.TabNavigatorItem
	 */
	public class TabNavigator extends BaseScreenNavigator
	{
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
		 * The value added to the <code>styleNameList</code> of the tab bar.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the tab bar style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_TAB_BAR</code>.
		 *
		 * <p>To customize the tab bar style name without subclassing, see
		 * <code>customTabBarStyleName</code>.</p>
		 *
		 * @see #customTabBarStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var tabBarStyleName:String = DEFAULT_CHILD_STYLE_NAME_TAB_BAR;

		/**
		 * @private
		 */
		protected var _tabBarDataProvider:ListCollection = new ListCollection(new <String>[]);

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
		public function get customTabBarStyleName():String
		{
			return this._customTabBarStyleName;
		}

		/**
		 * @private
		 */
		public function set customTabBarStyleName(value:String):void
		{
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
		public function get tabBarPosition():String
		{
			return this._tabBarPosition;
		}

		/**
		 * @private
		 */
		public function set tabBarPosition(value:String):void
		{
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
		 * @see #showScreen()
		 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
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
			if(this._transition == value)
			{
				return;
			}
			this._transition = value;
		}

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
			return this.showScreenInternal(id, transition);
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
		 * @see #customTabBarStyleName
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
		protected function tabBar_changeHandler(event:Event):void
		{
			var id:String = this.tabBar.selectedItem as String;
			var transition:Function = null;
			if(this._activeScreenID === null)
			{
				transition = defaultTransition;
			}
			this.showScreen(id, transition);
		}
	}
}
