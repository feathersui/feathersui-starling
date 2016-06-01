/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.BaseScreenNavigator;
	import feathers.layout.RelativePosition;
	import feathers.skins.IStyleProvider;

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
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
			this.tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			this.addChild(this.tabBar);
		}

		/**
		 * @private
		 */
		override protected function layoutChildren():void
		{
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
			}

			if(this._activeScreen !== null)
			{
				if(this._tabBarPosition === RelativePosition.LEFT)
				{
					this._activeScreen.x = this.tabBar.width;
				}
				else
				{
					this._activeScreen.x = 0;
				}
				if(this._tabBarPosition === RelativePosition.TOP)
				{
					this._activeScreen.y = this.tabBar.height;
				}
				else
				{
					this._activeScreen.y = 0;
				}
				this._activeScreen.width = this.actualWidth - this._activeScreen.x;
				this._activeScreen.width = this.actualHeight - this._activeScreen.y;
			}
		}

		/**
		 * @private
		 */
		protected function tabBar_changeHandler(event:Event):void
		{
			
		}
	}
}
