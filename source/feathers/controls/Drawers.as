/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.system.DeviceCapabilities;
	import feathers.utils.display.getDisplayObjectDepthFromStage;
	import feathers.utils.math.roundToNearest;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.ResizeEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * A container that displays primary content in the center surrounded by
	 * optional "drawers" that can open and close on the edges. Useful for
	 * mobile-style app menus that slide open from the side of the screen.
	 *
	 * <p>Additionally, each drawer may be individually "docked" in an
	 * always-open state, making this a useful application-level layout
	 * container even if the drawers never need to be hidden. Docking behavior
	 * may be limited to either portrait or landscape, or a drawer may be docked
	 * in both orientations. By default, a drawer is not docked.</p>
	 *
	 * <p>The following example creates an app with a slide out menu to the
	 * left of the main content:</p>
	 *
	 * <listing version="3.0">
	 * var navigator:ScreenNavigator = new ScreenNavigator();
	 * var list:List = new List();
	 * // the navigator's screens, the list's data provider, and additional
	 * // properties should be set here.
	 * var drawers:Drawers = new Drawers();
	 * drawers.content = navigator;
	 * drawers.leftDrawer = menu;
	 * drawers.leftDrawerToggleEventType = Event.OPEN;
	 * this.addChild( drawers );</listing>
	 *
	 * <p>In the example above, a screen in the <code>ScreenNavigator</code>
	 * component dispatches an event of type <code>Event.OPEN</code> when it
	 * wants to display the slide out the <code>List</code> that is used as
	 * the left drawer.</p>
	 *
	 * @see http://wiki.starling-framework.org/feathers/drawers
	 */
	public class Drawers extends FeathersControl
	{
		/**
		 * The drawer will be docked in portrait orientation, but it must be
		 * opened and closed explicitly in landscape orientation.
		 *
		 * @see #topDrawerDockMode
		 * @see #rightDrawerDockMode
		 * @see #bottomDrawerDockMode
		 * @see #leftDrawerDockMode
		 * @see #isTopDrawerDocked
		 * @see #isRightDrawerDocked
		 * @see #isBottomDrawerDocked
		 * @see #isLeftDrawerDocked
		 */
		public static const DOCK_MODE_PORTRAIT:String = "portrait";

		/**
		 * The drawer will be docked in landscape orientation, but it must be
		 * opened and closed explicitly in portrait orientation.
		 *
		 * @see #topDrawerDockMode
		 * @see #rightDrawerDockMode
		 * @see #bottomDrawerDockMode
		 * @see #leftDrawerDockMode
		 * @see #isTopDrawerDocked
		 * @see #isRightDrawerDocked
		 * @see #isBottomDrawerDocked
		 * @see #isLeftDrawerDocked
		 */
		public static const DOCK_MODE_LANDSCAPE:String = "landscape";

		/**
		 * The drawer will be docked in all orientations.
		 *
		 * @see #topDrawerDockMode
		 * @see #rightDrawerDockMode
		 * @see #bottomDrawerDockMode
		 * @see #leftDrawerDockMode
		 * @see #isTopDrawerDocked
		 * @see #isRightDrawerDocked
		 * @see #isBottomDrawerDocked
		 * @see #isLeftDrawerDocked
		 */
		public static const DOCK_MODE_BOTH:String = "both";

		/**
		 * The drawer won't be docked in any orientation. It must be opened and
		 * closed explicitly in all orientations.
		 *
		 * @see #topDrawerDockMode
		 * @see #rightDrawerDockMode
		 * @see #bottomDrawerDockMode
		 * @see #leftDrawerDockMode
		 * @see #isTopDrawerDocked
		 * @see #isRightDrawerDocked
		 * @see #isBottomDrawerDocked
		 * @see #isLeftDrawerDocked
		 */
		public static const DOCK_MODE_NONE:String = "none";

		/**
		 * The screen navigator will auto size itself to fill the entire stage.
		 *
		 * @see #autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_STAGE:String = "stage";

		/**
		 * The screen navigator will auto size itself to fit its content.
		 *
		 * @see #autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_CONTENT:String = "content";

		/**
		 * The field used to access the "content event dispatcher" of a
		 * <code>ScreenNavigator</code> component, which happens to be the
		 * currently active screen.
		 *
		 * @see #contentEventDispatcherField
		 * @see feathers.controls.ScreenNavigator
		 */
		protected static const SCREEN_NAVIGATOR_CONTENT_EVENT_DISPATCHER_FIELD:String = "activeScreen";

		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 * The minimum physical distance (in inches) that a touch must move
		 * before the drawer starts closing.
		 */
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;

		/**
		 * Constructor.
		 */
		public function Drawers(content:DisplayObject = null)
		{
			this.content = content;
			this.addEventListener(Event.ADDED_TO_STAGE, drawers_addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, drawers_removedFromStageHandler);
		}

		/**
		 * An overlay displayed over the content when a drawer is open to block
		 * touches to the content.
		 */
		protected var contentOverlay:Quad;

		/**
		 * The event dispatcher that controls opening and closing drawers with
		 * events. Often, the event dispatcher is the content itself, but you
		 * may specify a <code>contentEventDispatcherField</code> to access a
		 * property of the content instead, or you may specify a
		 * <code>contentEventDispatcherFunction</code> to run some more complex
		 * code to access the event dispatcher.
		 *
		 * @see #contentEventDispatcherField
		 * @see #contentEventDispatcherFunction
		 */
		protected var contentEventDispatcher:EventDispatcher;

		/**
		 * @private
		 */
		protected var _content:DisplayObject;

		/**
		 * The primary content displayed in the center of the container.
		 *
		 * <p>If the primary content is a container where you'd prefer to listen
		 * to events from its children, you may need to use properties like
		 * <code>contentEventDispatcherField</code>, <code>contentEventDispatcherFunction</code>,
		 * and <code>contentEventDispatcherChangeEventType</code> to ensure that
		 * open and close events for drawers are correctly mapped to the correct
		 * event dispatcher. If the content is dispatching the events, then those
		 * properties should be set to <code>null</code>.</p>
		 *
		 * <p>In the following example, a <code>ScreenNavigator</code> is added
		 * as the content:</p>
		 *
		 * <listing version="3.0">
		 * var navigator:ScreenNavigator = new ScreenNavigator();
		 * // additional code to add the screens can go here
		 * drawers.content = navigator;</listing>
		 *
		 * @default null
		 *
		 * @see #contentEventDispatcherField
		 * @see #contentEventDispatcherFunction
		 * @see #contentEventDispatcherChangeEventType
		 */
		public function get content():DisplayObject
		{
			return this._content
		}

		/**
		 * @private
		 */
		public function set content(value:DisplayObject):void
		{
			if(this._content == value)
			{
				return;
			}
			if(this._content)
			{
				if(this._contentEventDispatcherChangeEventType)
				{
					this._content.removeEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
				}
				if(this._content.parent == this)
				{
					this.removeChild(this._content, false);
				}
			}
			this._content = value;
			if(this._content)
			{
				if(this._content is ScreenNavigator)
				{
					this.contentEventDispatcherField = SCREEN_NAVIGATOR_CONTENT_EVENT_DISPATCHER_FIELD;
					this.contentEventDispatcherChangeEventType = Event.CHANGE;
				}
				if(this._contentEventDispatcherChangeEventType)
				{
					this._content.addEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
				}
				this.addChild(this._content);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _topDrawer:DisplayObject;

		/**
		 * The drawer that appears above the primary content.
		 *
		 * <p>In the following example, a <code>List</code> is added as the
		 * top drawer:</p>
		 *
		 * <listing version="3.0">
		 * var list:List = new List();
		 * // set data provider and other properties here
		 * drawers.topDrawer = list;</listing>
		 *
		 * @default null
		 *
		 * @see #topDrawerDockMode
		 * @see #topDrawerToggleEventType
		 */
		public function get topDrawer():DisplayObject
		{
			return this._topDrawer
		}

		/**
		 * @private
		 */
		public function set topDrawer(value:DisplayObject):void
		{
			if(this._topDrawer == value)
			{
				return;
			}
			if(this._topDrawer && this._topDrawer.parent == this)
			{
				this.removeChild(this._topDrawer, false);
			}
			this._topDrawer = value;
			if(this._topDrawer)
			{
				this._topDrawer.visible = false;
				this.addChildAt(this._topDrawer, 0);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _topDrawerDockMode:String = DOCK_MODE_NONE;

		/**
		 * Determines if the top drawer is docked in all, some, or no stage
		 * orientations. The current stage orientation is determined by
		 * calculating the aspect ratio of the stage.
		 *
		 * <p>In the following example, the top drawer is docked in the
		 * landscape stage orientation:</p>
		 *
		 * <listing version="3.0">
		 * drawers.topDrawerDockMode = Drawers.DOCK_MODE_LANDSCAPE;</listing>
		 *
		 * @default Drawers.DOCK_MODE_NONE
		 *
		 * @see #topDrawer
		 */
		public function get topDrawerDockMode():String
		{
			return this._topDrawerDockMode;
		}

		/**
		 * @private
		 */
		public function set topDrawerDockMode(value:String):void
		{
			if(this._topDrawerDockMode == value)
			{
				return;
			}
			this._topDrawerDockMode = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _topDrawerToggleEventType:String;

		/**
		 * When this event is dispatched by the content event dispatcher, the
		 * top drawer will toggle open and closed.
		 *
		 * <p>In the following example, the top drawer is toggled when the
		 * content dispatches an event of type <code>Event.OPEN</code>:</p>
		 *
		 * <listing version="3.0">
		 * drawers.topDrawerToggleEventType = Event.OPEN;</listing>
		 *
		 * @default null
		 *
		 * @see #content
		 * @see #topDrawer
		 */
		public function get topDrawerToggleEventType():String
		{
			return this._topDrawerToggleEventType;
		}

		/**
		 * @private
		 */
		public function set topDrawerToggleEventType(value:String):void
		{
			if(this._topDrawerToggleEventType == value)
			{
				return;
			}
			this._topDrawerToggleEventType = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _isTopDrawerOpen:Boolean = false;

		/**
		 * Indicates if the top drawer is currently open. If you want to check
		 * if the top drawer is docked, check <code>isTopDrawerDocked</code>
		 * instead.
		 *
		 * <p>To animate the top drawer open or closed, call
		 * <code>toggleTopDrawer()</code>. Setting <code>isTopDrawerOpen</code>
		 * will open or close the top drawer without animation.</p>
		 *
		 * <p>In the following example, we check if the top drawer is open:</p>
		 *
		 * <listing version="3.0">
		 * if( drawers.isTopDrawerOpen )
		 * {
		 *     // do something
		 * }</listing>
		 *
		 * @default false
		 *
		 * @see #isTopDrawerDocked
		 * @see #topDrawer
		 * @see #toggleTopDrawer()
		 */
		public function get isTopDrawerOpen():Boolean
		{
			return this._topDrawer && this._isTopDrawerOpen;
		}

		/**
		 * @private
		 */
		public function set isTopDrawerOpen(value:Boolean):void
		{
			if(this.isTopDrawerDocked || this._isTopDrawerOpen == value)
			{
				return;
			}
			this._isTopDrawerOpen = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * Indicates if the top drawer is currently docked. Docking behavior of
		 * the top drawer is controlled with the <code>topDrawerDockMode</code>
		 * property. To check if the top drawer is open, but not docked, use
		 * the <code>isTopDrawerOpen</code> property.
		 *
		 * @see #topDrawer
		 * @see #topDrawerDockMode
		 * @see #isTopDrawerOpen
		 */
		public function get isTopDrawerDocked():Boolean
		{
			if(!this._topDrawer || !this.stage)
			{
				return false;
			}
			if(this._topDrawerDockMode == DOCK_MODE_BOTH)
			{
				return true;
			}
			if(this._topDrawerDockMode == DOCK_MODE_NONE)
			{
				return false;
			}
			if(this.stage.stageWidth > this.stage.stageHeight)
			{
				return this._topDrawerDockMode == DOCK_MODE_LANDSCAPE;
			}
			return this._topDrawerDockMode == DOCK_MODE_PORTRAIT;
		}

		/**
		 * @private
		 */
		protected var _rightDrawer:DisplayObject;

		/**
		 * The drawer that appears to the right of the primary content.
		 *
		 * <p>In the following example, a <code>List</code> is added as the
		 * right drawer:</p>
		 *
		 * <listing version="3.0">
		 * var list:List = new List();
		 * // set data provider and other properties here
		 * drawers.rightDrawer = list;</listing>
		 *
		 * @default null
		 *
		 * @see #rightDrawerDockMode
		 * @see #rightDrawerToggleEventType
		 */
		public function get rightDrawer():DisplayObject
		{
			return this._rightDrawer
		}

		/**
		 * @private
		 */
		public function set rightDrawer(value:DisplayObject):void
		{
			if(this._rightDrawer == value)
			{
				return;
			}
			if(this._rightDrawer && this._rightDrawer.parent == this)
			{
				this.removeChild(this._rightDrawer, false);
			}
			this._rightDrawer = value;
			if(this._rightDrawer)
			{
				this._rightDrawer.visible = false;
				this.addChildAt(this._rightDrawer, 0);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _rightDrawerDockMode:String = DOCK_MODE_NONE;

		/**
		 * Determines if the right drawer is docked in all, some, or no stage
		 * orientations. The current stage orientation is determined by
		 * calculating the aspect ratio of the stage.
		 *
		 * <p>In the following example, the right drawer is docked in the
		 * landscape stage orientation:</p>
		 *
		 * <listing version="3.0">
		 * drawers.rightDrawerDockMode = Drawers.DOCK_MODE_LANDSCAPE;</listing>
		 *
		 * @default Drawers.DOCK_MODE_NONE
		 *
		 * @see #rightDrawer
		 */
		public function get rightDrawerDockMode():String
		{
			return this._rightDrawerDockMode;
		}

		/**
		 * @private
		 */
		public function set rightDrawerDockMode(value:String):void
		{
			if(this._rightDrawerDockMode == value)
			{
				return;
			}
			this._rightDrawerDockMode = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _rightDrawerToggleEventType:String;

		/**
		 * When this event is dispatched by the content event dispatcher, the
		 * right drawer will toggle open and closed.
		 *
		 * <p>In the following example, the right drawer is toggled when the
		 * content dispatches an event of type <code>Event.OPEN</code>:</p>
		 *
		 * <listing version="3.0">
		 * drawers.rightDrawerToggleEventType = Event.OPEN;</listing>
		 *
		 * @default null
		 *
		 * @see #content
		 * @see #rightDrawer
		 */
		public function get rightDrawerToggleEventType():String
		{
			return this._rightDrawerToggleEventType;
		}

		/**
		 * @private
		 */
		public function set rightDrawerToggleEventType(value:String):void
		{
			if(this._rightDrawerToggleEventType == value)
			{
				return;
			}
			this._rightDrawerToggleEventType = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _isRightDrawerOpen:Boolean = false;

		/**
		 * Indicates if the right drawer is currently open. If you want to check
		 * if the right drawer is docked, check <code>isRightDrawerDocked</code>
		 * instead.
		 *
		 * <p>To animate the right drawer open or closed, call
		 * <code>toggleRightDrawer()</code>. Setting <code>isRightDrawerOpen</code>
		 * will open or close the right drawer without animation.</p>
		 *
		 * <p>In the following example, we check if the right drawer is open:</p>
		 *
		 * <listing version="3.0">
		 * if( drawers.isRightDrawerOpen )
		 * {
		 *     // do something
		 * }</listing>
		 *
		 * @default false
		 *
		 * @see #rightDrawer
		 * @see #rightDrawerDockMode
		 * @see #toggleRightDrawer()
		 */
		public function get isRightDrawerOpen():Boolean
		{
			return this._rightDrawer && this._isRightDrawerOpen;
		}

		/**
		 * @private
		 */
		public function set isRightDrawerOpen(value:Boolean):void
		{
			if(this.isRightDrawerDocked || this._isRightDrawerOpen == value)
			{
				return;
			}
			this._isRightDrawerOpen = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * Indicates if the right drawer is currently docked. Docking behavior of
		 * the right drawer is controlled with the <code>rightDrawerDockMode</code>
		 * property. To check if the right drawer is open, but not docked, use
		 * the <code>isRightDrawerOpen</code> property.
		 *
		 * @see #rightDrawer
		 * @see #rightDrawerDockMode
		 * @see #isRightDrawerOpen
		 */
		public function get isRightDrawerDocked():Boolean
		{
			if(!this._rightDrawer || !this.stage)
			{
				return false;
			}
			if(this._rightDrawerDockMode == DOCK_MODE_BOTH)
			{
				return true;
			}
			if(this._rightDrawerDockMode == DOCK_MODE_NONE)
			{
				return false;
			}
			if(this.stage.stageWidth > this.stage.stageHeight)
			{
				return this._rightDrawerDockMode == DOCK_MODE_LANDSCAPE;
			}
			return this._rightDrawerDockMode == DOCK_MODE_PORTRAIT;
		}

		/**
		 * @private
		 */
		protected var _bottomDrawer:DisplayObject;

		/**
		 * The drawer that appears below the primary content.
		 *
		 * <p>In the following example, a <code>List</code> is added as the
		 * bottom drawer:</p>
		 *
		 * <listing version="3.0">
		 * var list:List = new List();
		 * // set data provider and other properties here
		 * drawers.bottomDrawer = list;</listing>
		 *
		 * @default null
		 *
		 * @see #bottomDrawerDockMode
		 * @see #bottomDrawerToggleEventType
		 */
		public function get bottomDrawer():DisplayObject
		{
			return this._bottomDrawer
		}

		/**
		 * @private
		 */
		public function set bottomDrawer(value:DisplayObject):void
		{
			if(this._bottomDrawer == value)
			{
				return;
			}
			if(this._bottomDrawer && this._bottomDrawer.parent == this)
			{
				this.removeChild(this._bottomDrawer, false);
			}
			this._bottomDrawer = value;
			if(this._bottomDrawer)
			{
				this._bottomDrawer.visible = false;
				this.addChildAt(this._bottomDrawer, 0);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _bottomDrawerDockMode:String = DOCK_MODE_NONE;

		/**
		 * Determines if the bottom drawer is docked in all, some, or no stage
		 * orientations. The current stage orientation is determined by
		 * calculating the aspect ratio of the stage.
		 *
		 * <p>In the following example, the bottom drawer is docked in the
		 * landscape stage orientation:</p>
		 *
		 * <listing version="3.0">
		 * drawers.bottomDrawerDockMode = Drawers.DOCK_MODE_LANDSCAPE;</listing>
		 *
		 * @default Drawers.DOCK_MODE_NONE
		 *
		 * @see #bottomDrawer
		 */
		public function get bottomDrawerDockMode():String
		{
			return this._bottomDrawerDockMode;
		}

		/**
		 * @private
		 */
		public function set bottomDrawerDockMode(value:String):void
		{
			if(this._bottomDrawerDockMode == value)
			{
				return;
			}
			this._bottomDrawerDockMode = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _bottomDrawerToggleEventType:String;

		/**
		 * When this event is dispatched by the content event dispatcher, the
		 * bottom drawer will toggle open and closed.
		 *
		 * <p>In the following example, the bottom drawer is toggled when the
		 * content dispatches an event of type <code>Event.OPEN</code>:</p>
		 *
		 * <listing version="3.0">
		 * drawers.bottomDrawerToggleEventType = Event.OPEN;</listing>
		 *
		 * @default null
		 *
		 * @see #content
		 * @see #bottomDrawer
		 */
		public function get bottomDrawerToggleEventType():String
		{
			return this._bottomDrawerToggleEventType;
		}

		/**
		 * @private
		 */
		public function set bottomDrawerToggleEventType(value:String):void
		{
			if(this._bottomDrawerToggleEventType == value)
			{
				return;
			}
			this._bottomDrawerToggleEventType = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _isBottomDrawerOpen:Boolean = false;

		/**
		 * Indicates if the bottom drawer is currently open. If you want to check
		 * if the bottom drawer is docked, check <code>isBottomDrawerDocked</code>
		 * instead.
		 *
		 * <p>To animate the bottom drawer open or closed, call
		 * <code>toggleBottomDrawer()</code>. Setting <code>isBottomDrawerOpen</code>
		 * will open or close the bottom drawer without animation.</p>
		 *
		 * <p>In the following example, we check if the bottom drawer is open:</p>
		 *
		 * <listing version="3.0">
		 * if( drawers.isBottomDrawerOpen )
		 * {
		 *     // do something
		 * }</listing>
		 *
		 * @default false
		 *
		 * @see #bottomDrawer
		 * @see #isBottomDrawerOpen
		 * @see #toggleBottomDrawer()
		 */
		public function get isBottomDrawerOpen():Boolean
		{
			return this._bottomDrawer && this._isBottomDrawerOpen;
		}

		/**
		 * @private
		 */
		public function set isBottomDrawerOpen(value:Boolean):void
		{
			if(this.isBottomDrawerDocked || this._isBottomDrawerOpen == value)
			{
				return;
			}
			this._isBottomDrawerOpen = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * Indicates if the bottom drawer is currently docked. Docking behavior of
		 * the bottom drawer is controlled with the <code>bottomDrawerDockMode</code>
		 * property. To check if the bottom drawer is open, but not docked, use
		 * the <code>isBottomDrawerOpen</code> property.
		 *
		 * @see #bottomDrawer
		 * @see #bottomDrawerDockMode
		 * @see #isBottomDrawerOpen
		 */
		public function get isBottomDrawerDocked():Boolean
		{
			if(!this._bottomDrawer || !this.stage)
			{
				return false;
			}
			if(this._bottomDrawerDockMode == DOCK_MODE_BOTH)
			{
				return true;
			}
			if(this._bottomDrawerDockMode == DOCK_MODE_NONE)
			{
				return false;
			}
			if(this.stage.stageWidth > this.stage.stageHeight)
			{
				return this._bottomDrawerDockMode == DOCK_MODE_LANDSCAPE;
			}
			return this._bottomDrawerDockMode == DOCK_MODE_PORTRAIT;
		}

		/**
		 * @private
		 */
		protected var _leftDrawer:DisplayObject;

		/**
		 * The drawer that appears below the primary content.
		 *
		 * <p>In the following example, a <code>List</code> is added as the
		 * left drawer:</p>
		 *
		 * <listing version="3.0">
		 * var list:List = new List();
		 * // set data provider and other properties here
		 * drawers.leftDrawer = list;</listing>
		 *
		 * @default null
		 *
		 * @see #leftDrawerDockMode
		 * @see #leftDrawerToggleEventType
		 */
		public function get leftDrawer():DisplayObject
		{
			return this._leftDrawer;
		}

		/**
		 * @private
		 */
		public function set leftDrawer(value:DisplayObject):void
		{
			if(this._leftDrawer == value)
			{
				return;
			}
			if(this._leftDrawer && this._leftDrawer.parent == this)
			{
				this.removeChild(this._leftDrawer, false);
			}
			this._leftDrawer = value;
			if(this._leftDrawer)
			{
				this._leftDrawer.visible = false;
				this.addChildAt(this._leftDrawer, 0);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _leftDrawerDockMode:String = DOCK_MODE_NONE;

		/**
		 * Determines if the left drawer is docked in all, some, or no stage
		 * orientations. The current stage orientation is determined by
		 * calculating the aspect ratio of the stage.
		 *
		 * <p>In the following example, the left drawer is docked in the
		 * landscape stage orientation:</p>
		 *
		 * <listing version="3.0">
		 * drawers.leftDrawerDockMode = Drawers.DOCK_MODE_LANDSCAPE;</listing>
		 *
		 * @default Drawers.DOCK_MODE_NONE
		 *
		 * @see #leftDrawer
		 */
		public function get leftDrawerDockMode():String
		{
			return this._leftDrawerDockMode;
		}

		/**
		 * @private
		 */
		public function set leftDrawerDockMode(value:String):void
		{
			if(this._leftDrawerDockMode == value)
			{
				return;
			}
			this._leftDrawerDockMode = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _leftDrawerToggleEventType:String;

		/**
		 * When this event is dispatched by the content event dispatcher, the
		 * left drawer will toggle open and closed.
		 *
		 * <p>In the following example, the left drawer is toggled when the
		 * content dispatches and event of type <code>Event.OPEN</code>:</p>
		 *
		 * <listing version="3.0">
		 * drawers.leftDrawerToggleEventType = Event.OPEN;</listing>
		 *
		 * @default null
		 *
		 * @see #content
		 * @see #leftDrawer
		 */
		public function get leftDrawerToggleEventType():String
		{
			return this._leftDrawerToggleEventType;
		}

		/**
		 * @private
		 */
		public function set leftDrawerToggleEventType(value:String):void
		{
			if(this._leftDrawerToggleEventType == value)
			{
				return;
			}
			this._leftDrawerToggleEventType = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _isLeftDrawerOpen:Boolean = false;

		/**
		 * Indicates if the left drawer is currently open. If you want to check
		 * if the left drawer is docked, check <code>isLeftDrawerDocked</code>
		 * instead.
		 *
		 * <p>To animate the left drawer open or closed, call
		 * <code>toggleLeftDrawer()</code>. Setting <code>isLeftDrawerOpen</code>
		 * will open or close the left drawer without animation.</p>
		 *
		 * <p>In the following example, we check if the left drawer is open:</p>
		 *
		 * <listing version="3.0">
		 * if( drawers.isLeftDrawerOpen )
		 * {
		 *     // do something
		 * }</listing>
		 *
		 * @default false
		 *
		 * @see #leftDrawer
		 * @see #isLeftDrawerDocked
		 * @see #toggleLeftDrawer()
		 */
		public function get isLeftDrawerOpen():Boolean
		{
			return this._leftDrawer && this._isLeftDrawerOpen;
		}

		/**
		 * @private
		 */
		public function set isLeftDrawerOpen(value:Boolean):void
		{
			if(this.isLeftDrawerDocked || this._isLeftDrawerOpen == value)
			{
				return;
			}
			this._isLeftDrawerOpen = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * Indicates if the left drawer is currently docked. Docking behavior of
		 * the left drawer is controlled with the <code>leftDrawerDockMode</code>
		 * property. To check if the left drawer is open, but not docked, use
		 * the <code>isLeftDrawerOpen</code> property.
		 *
		 * @see #leftDrawer
		 * @see #leftDrawerDockMode
		 * @see #isLeftDrawerOpen
		 */
		public function get isLeftDrawerDocked():Boolean
		{
			if(!this._leftDrawer || !this.stage)
			{
				return false;
			}
			if(this._leftDrawerDockMode == DOCK_MODE_BOTH)
			{
				return true;
			}
			if(this._leftDrawerDockMode == DOCK_MODE_NONE)
			{
				return false;
			}
			if(this.stage.stageWidth > this.stage.stageHeight)
			{
				return this._leftDrawerDockMode == DOCK_MODE_LANDSCAPE;
			}
			return this._leftDrawerDockMode == DOCK_MODE_PORTRAIT;
		}

		/**
		 * @private
		 */
		protected var _autoSizeMode:String = AUTO_SIZE_MODE_STAGE;

		[Inspectable(type="String",enumeration="stage,content")]
		/**
		 * Determines how the drawers container will set its own size when its
		 * dimensions (width and height) aren't set explicitly.
		 *
		 * <p>In the following example, the drawers container will be sized to
		 * match its content:</p>
		 *
		 * <listing version="3.0">
		 * drawers.autoSizeMode = Drawers.AUTO_SIZE_MODE_CONTENT;</listing>
		 *
		 * @default Drawers.AUTO_SIZE_MODE_STAGE
		 *
		 * @see #AUTO_SIZE_MODE_STAGE
		 * @see #AUTO_SIZE_MODE_CONTENT
		 */
		public function get autoSizeMode():String
		{
			return this._autoSizeMode;
		}

		/**
		 * @private
		 */
		public function set autoSizeMode(value:String):void
		{
			if(this._autoSizeMode == value)
			{
				return;
			}
			this._autoSizeMode = value;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _clipDrawers:Boolean = true;

		/**
		 * Determines if the drawers are clipped while opening or closing. If
		 * the content does not have a background, the drawers should
		 * generally be clipped so that the drawer does not show under the
		 * content. If the content has a fully opaque background that will
		 * conceal the drawers, then clipping may be disabled to potentially
		 * improve performance.
		 *
		 * <p>In the following example, clipping will be disabled:</p>
		 *
		 * <listing version="3.0">
		 * navigator.clipDrawers = false;</listing>
		 *
		 * @default true
		 *
		 * @see #topDrawer
		 * @see #rightDrawer
		 * @see #bottomDrawer
		 * @see #leftDrawer
		 */
		public function get clipDrawers():Boolean
		{
			return this._clipDrawers;
		}

		/**
		 * @private
		 */
		public function set clipDrawers(value:Boolean):void
		{
			if(this._clipDrawers == value)
			{
				return;
			}
			this._clipDrawers = value;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _contentEventDispatcherChangeEventType:String;

		/**
		 * The event dispatched by the content to indicate that the content
		 * event dispatcher has changed. When this event is dispatched by the
		 * content, the drawers container will listen for the drawer toggle
		 * events from the new dispatcher that discovered using
		 * <code>contentEventDispatcherField</code> or
		 * <code>contentEventDispatcherFunction</code>.
		 *
		 * <p>For a <code>ScreenNavigator</code> component, this value is
		 * automatically set to <code>Event.CHANGE</code>.</p>
		 *
		 * <p>In the following example, the drawers container will update its
		 * content event dispatcher when the content dispatches an event of type
		 * <code>Event.CHANGE</code>:</p>
		 *
		 * <listing version="3.0">
		 * drawers.contentEventDispatcherChangeEventType = Event.CHANGE;</listing>
		 *
		 * @default null
		 *
		 * @see #contentEventDispatcherField
		 * @see #contentEventDispatcherFunction
		 */
		public function get contentEventDispatcherChangeEventType():String
		{
			return this._contentEventDispatcherChangeEventType;
		}

		/**
		 * @private
		 */
		public function set contentEventDispatcherChangeEventType(value:String):void
		{
			if(this._contentEventDispatcherChangeEventType == value)
			{
				return;
			}
			if(this._content && this._contentEventDispatcherChangeEventType)
			{
				this._content.removeEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
			}
			this._contentEventDispatcherChangeEventType = value;
			if(this._content && this._contentEventDispatcherChangeEventType)
			{
				this._content.addEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _contentEventDispatcherField:String;

		/**
		 * A property of the <code>content</code> that references an event
		 * dispatcher that dispatches events to toggle drawers open and closed.
		 *
		 * <p>For a <code>ScreenNavigator</code> component, this value is
		 * automatically set to <code>"activeScreen"</code> to listen for events
		 * from the currently active/visible screen.</p>
		 *
		 * <p>In the following example, the content event dispatcher field is
		 * customized:</p>
		 *
		 * <listing version="3.0">
		 * drawers.contentEventDispatcherField = "selectedChild";</listing>
		 *
		 * @default null
		 *
		 * @see #contentEventDispatcherFunction
		 * @see #contentEventDispatcherChangeEventType
		 * @see #topDrawerToggleEventType
		 * @see #rightDrawerToggleEventType
		 * @see #bottomDrawerToggleEventType
		 * @see #leftDrawerToggleEventType
		 */
		public function get contentEventDispatcherField():String
		{
			return this._contentEventDispatcherField;
		}

		/**
		 * @private
		 */
		public function set contentEventDispatcherField(value:String):void
		{
			if(this._contentEventDispatcherField == value)
			{
				return;
			}
			this._contentEventDispatcherField = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _contentEventDispatcherFunction:Function;

		/**
		 * A function that returns an event dispatcher that dispatches events to
		 * toggle drawers open and closed.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 *
		 * <pre>function( content:DisplayObject ):EventDispatcher</pre>
		 *
		 * <p>In the following example, the content event dispatcher function is
		 * customized:</p>
		 *
		 * <listing version="3.0">
		 * drawers.contentEventDispatcherField = function( content:CustomView ):void
		 * {
		 *     return content.selectedChild;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #contentEventDispatcherField
		 * @see #contentEventDispatcherChangeEventType
		 * @see #topDrawerToggleEventType
		 * @see #rightDrawerToggleEventType
		 * @see #bottomDrawerToggleEventType
		 * @see #leftDrawerToggleEventType
		 */
		public function get contentEventDispatcherFunction():Function
		{
			return this._contentEventDispatcherFunction;
		}

		/**
		 * @private
		 */
		public function set contentEventDispatcherFunction(value:Function):void
		{
			if(this._contentEventDispatcherFunction == value)
			{
				return;
			}
			this._contentEventDispatcherFunction = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _openOrCloseTween:Tween;

		/**
		 * @private
		 */
		protected var _openOrCloseDuration:Number = 0.25;

		/**
		 * The duration, in seconds, of the animation when a drawer opens or
		 * closes.
		 *
		 * <p>In the following example, the duration of the animation that opens
		 * or closes a drawer is set to 500 milliseconds:</p>
		 *
		 * <listing version="3.0">
		 * scroller.openOrCloseDuration = 0.5;</listing>
		 *
		 * @default 0.25
		 *
		 * @see #openOrCloseEase
		 */
		public function get openOrCloseDuration():Number
		{
			return this._openOrCloseDuration;
		}

		/**
		 * @private
		 */
		public function set openOrCloseDuration(value:Number):void
		{
			this._openOrCloseDuration = value;
		}

		/**
		 * @private
		 */
		protected var _openOrCloseEase:Object = Transitions.EASE_OUT;

		/**
		 * The easing function used for opening or closing the drawers.
		 *
		 * <p>In the following example, the ease of the animation that opens and
		 * closes a drawer is customized:</p>
		 *
		 * <listing version="3.0">
		 * drawrs.openOrCloseEase = Transitions.EASE_IN_OUT;</listing>
		 *
		 * @default starling.animation.Transitions.EASE_OUT
		 *
		 * @see starling.animation.Transitions
		 * @see #openOrCloseDuration
		 */
		public function get openOrCloseEase():Object
		{
			return this._openOrCloseEase;
		}

		/**
		 * @private
		 */
		public function set openOrCloseEase(value:Object):void
		{
			this._openOrCloseEase = value;
		}

		/**
		 * @private
		 */
		protected var isToggleTopDrawerPending:Boolean = false;

		/**
		 * @private
		 */
		protected var isToggleRightDrawerPending:Boolean = false;

		/**
		 * @private
		 */
		protected var isToggleBottomDrawerPending:Boolean = false;

		/**
		 * @private
		 */
		protected var isToggleLeftDrawerPending:Boolean = false;

		/**
		 * @private
		 */
		protected var pendingToggleDuration:Number;

		/**
		 * @private
		 */
		protected var touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _isDraggingHorizontally:Boolean = false;

		/**
		 * @private
		 */
		protected var _isDraggingVertically:Boolean = false;

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
		 * Opens or closes the top drawer. If the <code>duration</code> argument
		 * is <code>NaN</code>, the default <code>openOrCloseDuration</code> is
		 * used. The default value of the <code>duration</code> argument is
		 * <code>NaN</code>. Otherwise, this value is the duration of the
		 * animation, in seconds.
		 *
		 * <p>To open or close the top drawer without animation, set the
		 * <code>isTopDrawerOpen</code> property.</p>
		 *
		 * @see #isTopDrawerOpen
		 * @see #openOrCloseDuration
		 * @see #openOrCloseEase
		 */
		public function toggleTopDrawer(duration:Number = NaN):void
		{
			if(!this._topDrawer || this.isToggleTopDrawerPending || this.isTopDrawerDocked)
			{
				return;
			}
			this.isToggleTopDrawerPending = true;
			this.isToggleRightDrawerPending = false;
			this.isToggleBottomDrawerPending = false;
			this.isToggleLeftDrawerPending = false;
			this.pendingToggleDuration = duration;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * Opens or closes the right drawer. If the <code>duration</code> argument
		 * is <code>NaN</code>, the default <code>openOrCloseDuration</code> is
		 * used. The default value of the <code>duration</code> argument is
		 * <code>NaN</code>. Otherwise, this value is the duration of the
		 * animation, in seconds.
		 *
		 * <p>To open or close the right drawer without animation, set the
		 * <code>isRightDrawerOpen</code> property.</p>
		 *
		 * @see #isRightDrawerOpen
		 * @see #openOrCloseDuration
		 * @see #openOrCloseEase
		 */
		public function toggleRightDrawer(duration:Number = NaN):void
		{
			if(!this._rightDrawer || this.isToggleRightDrawerPending || this.isRightDrawerDocked)
			{
				return;
			}
			this.isToggleTopDrawerPending = false;
			this.isToggleRightDrawerPending = true;
			this.isToggleBottomDrawerPending = false;
			this.isToggleLeftDrawerPending = false;
			this.pendingToggleDuration = duration;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * Opens or closes the bottom drawer. If the <code>duration</code> argument
		 * is <code>NaN</code>, the default <code>openOrCloseDuration</code> is
		 * used. The default value of the <code>duration</code> argument is
		 * <code>NaN</code>. Otherwise, this value is the duration of the
		 * animation, in seconds.
		 *
		 * <p>To open or close the bottom drawer without animation, set the
		 * <code>isBottomDrawerOpen</code> property.</p>
		 *
		 * @see #isBottomDrawerOpen
		 * @see #openOrCloseDuration
		 * @see #openOrCloseEase
		 */
		public function toggleBottomDrawer(duration:Number = NaN):void
		{
			if(!this._bottomDrawer || this.isToggleBottomDrawerPending || this.isBottomDrawerDocked)
			{
				return;
			}
			this.isToggleTopDrawerPending = false;
			this.isToggleRightDrawerPending = false;
			this.isToggleBottomDrawerPending = true;
			this.isToggleLeftDrawerPending = false;
			this.pendingToggleDuration = duration;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * Opens or closes the left drawer. If the <code>duration</code> argument
		 * is <code>NaN</code>, the default <code>openOrCloseDuration</code> is
		 * used. The default value of the <code>duration</code> argument is
		 * <code>NaN</code>. Otherwise, this value is the duration of the
		 * animation, in seconds.
		 *
		 * <p>To open or close the left drawer without animation, set the
		 * <code>isLeftDrawerOpen</code> property.</p>
		 *
		 * @see #isLeftDrawerOpen
		 * @see #openOrCloseDuration
		 * @see #openOrCloseEase
		 */
		public function toggleLeftDrawer(duration:Number = NaN):void
		{
			if(!this._leftDrawer || this.isToggleLeftDrawerPending || this.isLeftDrawerDocked)
			{
				return;
			}
			this.isToggleTopDrawerPending = false;
			this.isToggleRightDrawerPending = false;
			this.isToggleBottomDrawerPending = false;
			this.isToggleLeftDrawerPending = true;
			this.pendingToggleDuration = duration;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.contentOverlay)
			{
				this.contentOverlay = new Quad(10, 10, 0xff00ff);
				this.contentOverlay.alpha = 0;
				this.contentOverlay.visible = false;
				this.contentOverlay.addEventListener(TouchEvent.TOUCH, contentOverlay_touchHandler);
				this.addChild(this.contentOverlay);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			if(dataInvalid)
			{
				this.refreshCurrentEventTarget();
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			this.layoutChildren();

			this.handlePendingActions();
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>setSizeInternal()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}

			if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT &&
				this._content is IFeathersControl)
			{
				IFeathersControl(this._content).validate();
				var isTopDrawerDocked:Boolean = this.isTopDrawerDocked;
				if(isTopDrawerDocked && this._topDrawer is IFeathersControl)
				{
					IFeathersControl(this._topDrawer).validate();
				}
				var isRightDrawerDocked:Boolean = this.isRightDrawerDocked;
				if(isRightDrawerDocked && this._rightDrawer is IFeathersControl)
				{
					IFeathersControl(this._rightDrawer).validate();
				}
				var isBottomDrawerDocked:Boolean = this.isBottomDrawerDocked;
				if(isBottomDrawerDocked && this._bottomDrawer is IFeathersControl)
				{
					IFeathersControl(this._bottomDrawer).validate();
				}
				var isLeftDrawerDocked:Boolean = this.isLeftDrawerDocked;
				if(isLeftDrawerDocked && this._leftDrawer is IFeathersControl)
				{
					IFeathersControl(this._leftDrawer).validate();
				}
			}

			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
				{
					newWidth = this._content ? this._content.width : 0;
					if(isLeftDrawerDocked)
					{
						newWidth += this._leftDrawer.width;
					}
					if(isRightDrawerDocked)
					{
						newWidth += this._rightDrawer.width;
					}
				}
				else
				{
					newWidth = this.stage.stageWidth;
				}
			}

			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				if(this._autoSizeMode == AUTO_SIZE_MODE_CONTENT)
				{
					newHeight = this._content ? this._content.height : 0;
					if(isTopDrawerDocked)
					{
						newHeight += this._topDrawer.width;
					}
					if(isBottomDrawerDocked)
					{
						newHeight += this._bottomDrawer.width;
					}
				}
				else
				{
					newHeight = this.stage.stageHeight;
				}
			}

			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * Positions and sizes the children.
		 */
		protected function layoutChildren():void
		{
			if(this._topDrawer is IFeathersControl)
			{
				IFeathersControl(this._topDrawer).validate();
			}
			if(this._rightDrawer is IFeathersControl)
			{
				IFeathersControl(this._rightDrawer).validate();
			}
			if(this._bottomDrawer is IFeathersControl)
			{
				IFeathersControl(this._bottomDrawer).validate();
			}
			if(this._leftDrawer is IFeathersControl)
			{
				IFeathersControl(this._leftDrawer).validate();
			}
			var isTopDrawerOpen:Boolean = this.isTopDrawerOpen;
			var isRightDrawerOpen:Boolean = this.isRightDrawerOpen;
			var isBottomDrawerOpen:Boolean = this.isBottomDrawerOpen;
			var isLeftDrawerOpen:Boolean = this.isLeftDrawerOpen;
			var isTopDrawerDocked:Boolean = this.isTopDrawerDocked;
			var isRightDrawerDocked:Boolean = this.isRightDrawerDocked;
			var isBottomDrawerDocked:Boolean = this.isBottomDrawerDocked;
			var isLeftDrawerDocked:Boolean = this.isLeftDrawerDocked;
			var topDrawerHeight:Number = this._topDrawer ? this._topDrawer.height : 0;
			var rightDrawerWidth:Number = this._rightDrawer ? this._rightDrawer.width : 0;
			var bottomDrawerHeight:Number = this._bottomDrawer ? this._bottomDrawer.height : 0;
			var leftDrawerWidth:Number = this._leftDrawer ? this._leftDrawer.width : 0;

			var contentWidth:Number = this.actualWidth;
			if(isLeftDrawerDocked)
			{
				contentWidth -= leftDrawerWidth;
			}
			if(isRightDrawerDocked)
			{
				contentWidth -= rightDrawerWidth;
			}
			var contentHeight:Number = this.actualHeight;
			if(isTopDrawerDocked)
			{
				contentHeight -= topDrawerHeight;
			}
			if(isBottomDrawerDocked)
			{
				contentHeight -= bottomDrawerHeight;
			}

			if(isLeftDrawerOpen || isLeftDrawerDocked)
			{
				this._content.x = leftDrawerWidth;
			}
			else if(isRightDrawerOpen)
			{
				this._content.x = -rightDrawerWidth;
			}
			else
			{
				this._content.x = 0;
			}
			if(isTopDrawerOpen || isTopDrawerDocked)
			{
				this._content.y = topDrawerHeight;
			}
			else if(isBottomDrawerOpen)
			{
				this._content.y = -bottomDrawerHeight;
			}
			else
			{
				this._content.y = 0;
			}
			this._content.width = contentWidth;
			this._content.height = contentHeight;

			if(this._topDrawer)
			{
				this._topDrawer.x = 0;
				this._topDrawer.y = 0;
				this._topDrawer.width = this.actualWidth;
				this._topDrawer.visible = isTopDrawerOpen || isTopDrawerDocked;
			}

			if(this._rightDrawer)
			{
				this._rightDrawer.x = this.actualWidth - rightDrawerWidth;
				this._rightDrawer.y = 0;
				this._rightDrawer.height = this.actualHeight;
				this._rightDrawer.visible = isRightDrawerOpen || isRightDrawerDocked;
			}

			if(this._bottomDrawer)
			{
				this._bottomDrawer.x = 0;
				this._bottomDrawer.y = this.actualHeight - bottomDrawerHeight;
				this._bottomDrawer.width = this.actualWidth;
				this._bottomDrawer.visible = isBottomDrawerOpen || isBottomDrawerDocked;
			}

			if(this._leftDrawer)
			{
				this._leftDrawer.x = 0;
				this._leftDrawer.y = 0;
				this._leftDrawer.height = this.actualHeight;
				this._leftDrawer.visible = isLeftDrawerOpen || isLeftDrawerDocked;
			}

			this.contentOverlay.x = this._content.x;
			this.contentOverlay.y = this._content.y;
			this.contentOverlay.width = this._content.width;
			this.contentOverlay.height = this._content.height;
			this.contentOverlay.visible = isTopDrawerOpen || isRightDrawerOpen ||
				isBottomDrawerOpen || isLeftDrawerOpen;

			//always on top
			this.setChildIndex(this.contentOverlay, this.numChildren - 1);
		}

		/**
		 * @private
		 */
		protected function handlePendingActions():void
		{
			if(this.isToggleTopDrawerPending)
			{
				this._isTopDrawerOpen = !this._isTopDrawerOpen;
				this.isToggleTopDrawerPending = false;
				this.openOrCloseTopDrawer();
			}
			else if(this.isToggleRightDrawerPending)
			{
				this._isRightDrawerOpen = !this._isRightDrawerOpen;
				this.isToggleRightDrawerPending = false;
				this.openOrCloseRightDrawer();
			}
			else if(this.isToggleBottomDrawerPending)
			{
				this._isBottomDrawerOpen = !this._isBottomDrawerOpen;
				this.isToggleBottomDrawerPending = false;
				this.openOrCloseBottomDrawer();
			}
			else if(this.isToggleLeftDrawerPending)
			{
				this._isLeftDrawerOpen = !this._isLeftDrawerOpen;
				this.isToggleLeftDrawerPending = false;
				this.openOrCloseLeftDrawer();
			}
		}

		/**
		 * @private
		 */
		protected function openOrCloseTopDrawer():void
		{
			if(!this._topDrawer || this.isTopDrawerDocked)
			{
				return;
			}
			if(this._openOrCloseTween)
			{
				this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
				Starling.juggler.remove(this._openOrCloseTween);
				this._openOrCloseTween = null;
			}
			this.applyTopClipRect();
			this._topDrawer.visible = true;
			this.contentOverlay.visible = true;
			var targetPosition:Number = this._isTopDrawerOpen ? this._topDrawer.height : 0;
			this._openOrCloseTween = new Tween(this._content, this._openOrCloseDuration, this._openOrCloseEase);
			this._openOrCloseTween.animate("y", targetPosition);
			this._openOrCloseTween.onUpdate = openOrCloseTween_onUpdate;
			this._openOrCloseTween.onComplete = openOrCloseTween_onComplete;
			Starling.juggler.add(this._openOrCloseTween);
		}

		/**
		 * @private
		 */
		protected function openOrCloseRightDrawer():void
		{
			if(!this._rightDrawer || this.isRightDrawerDocked)
			{
				return;
			}
			if(this._openOrCloseTween)
			{
				this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
				Starling.juggler.remove(this._openOrCloseTween);
				this._openOrCloseTween = null;
			}
			this.applyRightClipRect();
			this._rightDrawer.visible = true;
			this.contentOverlay.visible = true;
			var targetPosition:Number = this._isRightDrawerOpen ? -this._rightDrawer.width : 0;
			this._openOrCloseTween = new Tween(this._content, this._openOrCloseDuration, this._openOrCloseEase);
			this._openOrCloseTween.animate("x", targetPosition);
			this._openOrCloseTween.onUpdate = openOrCloseTween_onUpdate;
			this._openOrCloseTween.onComplete = openOrCloseTween_onComplete;
			Starling.juggler.add(this._openOrCloseTween);
		}

		/**
		 * @private
		 */
		protected function openOrCloseBottomDrawer():void
		{
			if(!this._bottomDrawer || this.isBottomDrawerDocked)
			{
				return;
			}
			if(this._openOrCloseTween)
			{
				this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
				Starling.juggler.remove(this._openOrCloseTween);
				this._openOrCloseTween = null;
			}
			this.applyBottomClipRect();
			this._bottomDrawer.visible = true;
			this.contentOverlay.visible = true;
			var targetPosition:Number = this._isBottomDrawerOpen ? -this._bottomDrawer.height : 0;
			this._openOrCloseTween = new Tween(this._content, this._openOrCloseDuration, this._openOrCloseEase);
			this._openOrCloseTween.animate("y", targetPosition);
			this._openOrCloseTween.onUpdate = openOrCloseTween_onUpdate;
			this._openOrCloseTween.onComplete = openOrCloseTween_onComplete;
			Starling.juggler.add(this._openOrCloseTween);
		}

		/**
		 * @private
		 */
		protected function openOrCloseLeftDrawer():void
		{
			if(!this._leftDrawer || this.isLeftDrawerDocked)
			{
				return;
			}
			if(this._openOrCloseTween)
			{
				this._openOrCloseTween.advanceTime(this._openOrCloseTween.totalTime);
				Starling.juggler.remove(this._openOrCloseTween);
				this._openOrCloseTween = null;
			}
			this.applyLeftClipRect();
			this._leftDrawer.visible = true;
			this.contentOverlay.visible = true;
			var targetPosition:Number = this._isLeftDrawerOpen ? this._leftDrawer.width : 0;
			var duration:Number = !isNaN(this.pendingToggleDuration) ? this.pendingToggleDuration : this._openOrCloseDuration;
			this._openOrCloseTween = new Tween(this._content, duration, this._openOrCloseEase);
			this._openOrCloseTween.animate("x", targetPosition);
			this._openOrCloseTween.onUpdate = openOrCloseTween_onUpdate;
			this._openOrCloseTween.onComplete = openOrCloseTween_onComplete;
			Starling.juggler.add(this._openOrCloseTween);
		}

		/**
		 * @private
		 */
		protected function applyTopClipRect():void
		{
			if(!this._clipDrawers || !(this._topDrawer is Sprite))
			{
				return;
			}
			var topSprite:Sprite = Sprite(this._topDrawer);
			if(!topSprite.clipRect)
			{
				topSprite.clipRect = new Rectangle(0, 0, this.actualWidth, this._content.y);
			}
		}

		/**
		 * @private
		 */
		protected function applyRightClipRect():void
		{
			if(!this._clipDrawers || !(this._rightDrawer is Sprite))
			{
				return;
			}
			var rightSprite:Sprite = Sprite(this._rightDrawer);
			if(!rightSprite.clipRect)
			{
				rightSprite.clipRect = new Rectangle(0, 0, -this._content.x, this.actualHeight);
			}
		}

		/**
		 * @private
		 */
		protected function applyBottomClipRect():void
		{
			if(!this._clipDrawers || !(this._bottomDrawer is Sprite))
			{
				return;
			}
			var bottomSprite:Sprite = Sprite(this._bottomDrawer);
			if(!bottomSprite.clipRect)
			{
				bottomSprite.clipRect = new Rectangle(0, 0, this.actualWidth, -this._content.y);
			}
		}

		/**
		 * @private
		 */
		protected function applyLeftClipRect():void
		{
			if(!this._clipDrawers || !(this._leftDrawer is Sprite))
			{
				return;
			}
			var leftSprite:Sprite = Sprite(this._leftDrawer);
			if(!leftSprite.clipRect)
			{
				leftSprite.clipRect = new Rectangle(0, 0, this._content.x, this.actualHeight);
			}
		}

		/**
		 * Uses the content event dispatcher fields and functions to generate a
		 * content event dispatcher icon for the content.
		 *
		 * <p>All of the content event dispatcher fields and functions, ordered
		 * by priority:</p>
		 * <ol>
		 *     <li><code>contentEventDispatcherFunction</code></li>
		 *     <li><code>contentEventDispatcherField</code></li>
		 * </ol>
		 *
		 * @see #content
		 * @see #contentEventDispatcherField
		 * @see #contentEventDispatcherFunction
		 * @see #contentEventDispatcherChangeEventType
		 */
		protected function contentToContentEventDispatcher():EventDispatcher
		{
			if(this._contentEventDispatcherFunction != null)
			{
				return this._contentEventDispatcherFunction(this._content) as EventDispatcher;
			}
			else if(this._contentEventDispatcherField != null && this._content && this._content.hasOwnProperty(this._contentEventDispatcherField))
			{
				return this._content[this._contentEventDispatcherField] as EventDispatcher;
			}
			return this._content;
		}

		/**
		 * @private
		 */
		protected function refreshCurrentEventTarget():void
		{
			if(this.contentEventDispatcher)
			{
				this.contentEventDispatcher.removeEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
				this.contentEventDispatcher.removeEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
				this.contentEventDispatcher.removeEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
				this.contentEventDispatcher.removeEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
			}
			this.contentEventDispatcher = this.contentToContentEventDispatcher();
			if(this.contentEventDispatcher)
			{
				this.contentEventDispatcher.addEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
				this.contentEventDispatcher.addEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
				this.contentEventDispatcher.addEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
				this.contentEventDispatcher.addEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
			}
		}

		/**
		 * @private
		 */
		protected function handleOverlayTap(touch:Touch):void
		{
			touch.getLocation(this.stage, HELPER_POINT);
			if(this.contentOverlay != this.stage.hitTest(HELPER_POINT, true))
			{
				return;
			}

			if(this.isTopDrawerOpen)
			{
				this._isTopDrawerOpen = false;
				this.openOrCloseTopDrawer();
			}
			else if(this.isRightDrawerOpen)
			{
				this._isRightDrawerOpen = false;
				this.openOrCloseRightDrawer();
			}
			else if(this.isBottomDrawerOpen)
			{
				this._isBottomDrawerOpen = false;
				this.openOrCloseBottomDrawer();
			}
			else if(this.isLeftDrawerOpen)
			{
				this._isLeftDrawerOpen = false;
				this.openOrCloseLeftDrawer();
			}
		}

		/**
		 * @private
		 */
		protected function handleDragEnd():void
		{
			this._isDraggingHorizontally = false;
			this._isDraggingVertically = false;
			if(this.isTopDrawerOpen)
			{
				this._isTopDrawerOpen = roundToNearest(this._content.y, this._topDrawer.height) != 0;
				this.openOrCloseTopDrawer();
			}
			else if(this.isRightDrawerOpen)
			{
				this._isRightDrawerOpen = roundToNearest(this._content.x, this._rightDrawer.width) != 0;
				this.openOrCloseRightDrawer();
			}
			else if(this.isBottomDrawerOpen)
			{
				this._isBottomDrawerOpen = roundToNearest(this._content.y, this._bottomDrawer.height) != 0;
				this.openOrCloseBottomDrawer();
			}
			else if(this.isLeftDrawerOpen)
			{
				this._isLeftDrawerOpen = roundToNearest(this._content.x, this._leftDrawer.width) != 0;
				this.openOrCloseLeftDrawer();
			}
		}

		/**
		 * @private
		 */
		protected function dragHorizontally():void
		{
			if(this._isLeftDrawerOpen)
			{
				var leftDrawerWidth:Number = this._leftDrawer.width;
				var contentX:Number = leftDrawerWidth + this._currentTouchX - this._startTouchX;
				if(contentX < 0)
				{
					contentX = 0;
				}
				if(contentX > leftDrawerWidth)
				{
					contentX = leftDrawerWidth;
				}
			}
			else //right drawer is open
			{
				var rightDrawerWidth:Number = this._rightDrawer.width;
				contentX = -rightDrawerWidth + this._currentTouchX - this._startTouchX;
				if(contentX < -rightDrawerWidth)
				{
					contentX = -rightDrawerWidth;
				}
				if(contentX > 0)
				{
					contentX = 0;
				}
			}
			this._content.x = contentX;
			this.openOrCloseTween_onUpdate();
		}

		/**
		 * @private
		 */
		protected function dragVertically():void
		{
			if(this.isTopDrawerOpen)
			{
				var topDrawerHeight:Number = this._topDrawer.width;
				var contentY:Number = topDrawerHeight + this._currentTouchY - this._startTouchY;
				if(contentY < 0)
				{
					contentY = 0;
				}
				if(contentY > topDrawerHeight)
				{
					contentY = topDrawerHeight;
				}
				this._content.y = contentY;
			}
			else // bottom drawer is open
			{
				var bottomDrawerHeight:Number = this._bottomDrawer.height;
				contentY = -bottomDrawerHeight + this._currentTouchY - this._startTouchY;
				if(contentY < -bottomDrawerHeight)
				{
					contentY = -bottomDrawerHeight;
				}
				if(contentY > 0)
				{
					contentY = 0;
				}
			}
			this._content.y = contentY;
			this.openOrCloseTween_onUpdate();
		}

		/**
		 * @private
		 */
		protected function checkForDrag():void
		{
			var isTopDrawerOpen:Boolean = this.isTopDrawerOpen;
			var isRightDrawerOpen:Boolean = this.isRightDrawerOpen;
			var isBottomDrawerOpen:Boolean = this.isBottomDrawerOpen;
			var isLeftDrawerOpen:Boolean = this.isLeftDrawerOpen;

			var horizontalInchesMoved:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
			var verticalInchesMoved:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / Starling.contentScaleFactor);
			if(((isLeftDrawerOpen && horizontalInchesMoved <= -MINIMUM_DRAG_DISTANCE) ||
				(isRightDrawerOpen && horizontalInchesMoved >= MINIMUM_DRAG_DISTANCE)) &&
				!this._isDraggingHorizontally && !this._isDraggingVertically)
			{
				this._startTouchX = this._currentTouchX;
				this._isDraggingHorizontally = true;
				if(isLeftDrawerOpen)
				{
					this.applyLeftClipRect();
				}
				else
				{
					this.applyRightClipRect();
				}
			}
			else if(((isTopDrawerOpen && verticalInchesMoved <= -MINIMUM_DRAG_DISTANCE) ||
				(isBottomDrawerOpen && verticalInchesMoved >= MINIMUM_DRAG_DISTANCE)) &&
				!this._isDraggingHorizontally && !this._isDraggingVertically)
			{
				this._startTouchY = this._currentTouchY;
				this._isDraggingVertically = true;
				if(isTopDrawerOpen)
				{
					this.applyTopClipRect();
				}
				else
				{
					this.applyBottomClipRect();
				}
			}
		}

		/**
		 * @private
		 */
		protected function openOrCloseTween_onUpdate():void
		{
			this.contentOverlay.x = this._content.x;
			this.contentOverlay.y = this._content.y;
			if(this._clipDrawers)
			{
				if(this._topDrawer is Sprite)
				{
					var sprite:Sprite = Sprite(this._topDrawer);
					var clipRect:Rectangle = sprite.clipRect;
					if(clipRect)
					{
						clipRect.height = this._content.y;
					}
				}
				if(this._rightDrawer is Sprite)
				{
					sprite = Sprite(this._rightDrawer);
					clipRect = sprite.clipRect;
					if(clipRect)
					{
						var rightClipWidth:Number = -this._content.x;
						clipRect.x = this._rightDrawer.width - rightClipWidth;
						clipRect.width = rightClipWidth;
					}
				}
				if(this._bottomDrawer is Sprite)
				{
					sprite = Sprite(this._bottomDrawer);
					clipRect = sprite.clipRect;
					if(clipRect)
					{
						var bottomClipHeight:Number = -this._content.y;
						clipRect.y = this._bottomDrawer.height - bottomClipHeight;
						clipRect.height = bottomClipHeight;
					}
				}
				if(this._leftDrawer is Sprite)
				{
					sprite = Sprite(this._leftDrawer);
					clipRect = sprite.clipRect;
					if(clipRect)
					{
						clipRect.width = this._content.x;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function openOrCloseTween_onComplete():void
		{
			var isTopDrawerOpen:Boolean = this.isTopDrawerOpen;
			var isRightDrawerOpen:Boolean = this.isRightDrawerOpen;
			var isBottomDrawerOpen:Boolean = this.isBottomDrawerOpen;
			var isLeftDrawerOpen:Boolean = this.isLeftDrawerOpen;
			this._openOrCloseTween = null;
			if(this._topDrawer)
			{
				if(this._topDrawer is Sprite)
				{
					Sprite(this._topDrawer).clipRect = null;
				}
				this._topDrawer.visible = isTopDrawerOpen || this.isTopDrawerDocked;
			}
			if(this._rightDrawer)
			{
				if(this._rightDrawer is Sprite)
				{
					Sprite(this._rightDrawer).clipRect = null;
				}
				this._rightDrawer.visible = isRightDrawerOpen || this.isRightDrawerDocked;
			}
			if(this._bottomDrawer)
			{
				if(this._bottomDrawer is Sprite)
				{
					Sprite(this._bottomDrawer).clipRect = null;
				}
				this._bottomDrawer.visible = isBottomDrawerOpen || this.isBottomDrawerDocked;
			}
			if(this._leftDrawer)
			{
				if(this._leftDrawer is Sprite)
				{
					Sprite(this._leftDrawer).clipRect = null;
				}
				this._leftDrawer.visible = isLeftDrawerOpen || this.isLeftDrawerDocked;
			}
			this.contentOverlay.visible = isTopDrawerOpen || isRightDrawerOpen ||
				isBottomDrawerOpen || isLeftDrawerOpen;
		}

		/**
		 * @private
		 */
		protected function content_eventDispatcherChangeHandler(event:Event):void
		{
			this.refreshCurrentEventTarget();
		}

		/**
		 * @private
		 */
		protected function drawers_addedToStageHandler(event:Event):void
		{
			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			//using priority here is a hack so that objects higher up in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, drawers_nativeStage_keyDownHandler, false, priority, true);
		}

		/**
		 * @private
		 */
		protected function drawers_removedFromStageHandler(event:Event):void
		{
			this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, drawers_nativeStage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			if(this.isTopDrawerDocked)
			{
				this._isTopDrawerOpen = false;
			}
			if(this.isRightDrawerDocked)
			{
				this._isRightDrawerOpen = false;
			}
			if(this.isBottomDrawerDocked)
			{
				this._isBottomDrawerOpen = false;
			}
			if(this.isLeftDrawerDocked)
			{
				this._isLeftDrawerOpen = false;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function drawers_nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.isDefaultPrevented())
			{
				//someone else already handled this one
				return;
			}
			if(event.keyCode == Keyboard.BACK)
			{
				var isAnyDrawerOpen:Boolean = false;
				if(this.isTopDrawerOpen)
				{
					this.toggleTopDrawer();
					isAnyDrawerOpen = true;
				}
				else if(this.isRightDrawerOpen)
				{
					this.toggleRightDrawer();
					isAnyDrawerOpen = true;
				}
				else if(this.isBottomDrawerOpen)
				{
					this.toggleBottomDrawer();
					isAnyDrawerOpen = true;
				}
				else if(this.isLeftDrawerOpen)
				{
					this.toggleLeftDrawer();
					isAnyDrawerOpen = true;
				}
				if(isAnyDrawerOpen)
				{
					event.preventDefault();
				}
			}
		}

		/**
		 * @private
		 */
		protected function content_topDrawerToggleEventTypeHandler(event:Event):void
		{
			if(!this._topDrawer || this.isTopDrawerDocked)
			{
				return;
			}
			this._isTopDrawerOpen = !this._isTopDrawerOpen;
			this.openOrCloseTopDrawer();
		}

		/**
		 * @private
		 */
		protected function content_rightDrawerToggleEventTypeHandler(event:Event):void
		{
			if(!this._rightDrawer || this.isRightDrawerDocked)
			{
				return;
			}
			this._isRightDrawerOpen = !this._isRightDrawerOpen;
			this.openOrCloseRightDrawer();
		}

		/**
		 * @private
		 */
		protected function content_bottomDrawerToggleEventTypeHandler(event:Event):void
		{
			if(!this._bottomDrawer || this.isBottomDrawerDocked)
			{
				return;
			}
			this._isBottomDrawerOpen = !this._isBottomDrawerOpen;
			this.openOrCloseBottomDrawer();
		}

		/**
		 * @private
		 */
		protected function content_leftDrawerToggleEventTypeHandler(event:Event):void
		{
			if(!this._leftDrawer || this.isLeftDrawerDocked)
			{
				return;
			}
			this._isLeftDrawerOpen = !this._isLeftDrawerOpen;
			this.openOrCloseLeftDrawer();
		}

		/**
		 * @private
		 */
		protected function contentOverlay_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || this._openOrCloseTween)
			{
				this.touchPointID = -1;
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.contentOverlay, null, this.touchPointID);
				if(!touch)
				{
					return;
				}
				if(touch.phase == TouchPhase.MOVED)
				{
					touch.getLocation(this, HELPER_POINT);
					this._currentTouchX = HELPER_POINT.x;
					this._currentTouchY = HELPER_POINT.y;

					if(!this._isDraggingHorizontally && !this._isDraggingVertically)
					{
						this.checkForDrag();
					}

					if(this._isDraggingHorizontally)
					{
						this.dragHorizontally();
					}
					else if(this._isDraggingVertically)
					{
						this.dragVertically();
					}
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					this.touchPointID = -1;
					if(!this._isDraggingHorizontally && !this._isDraggingVertically)
					{
						//there is no drag, so we may have a tap
						this.handleOverlayTap(touch);
					}
					else
					{
						this.handleDragEnd();
					}

				}
			}
			else
			{
				touch = event.getTouch(this.contentOverlay, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				this.touchPointID = touch.id;
				touch.getLocation(this, HELPER_POINT);
				this._startTouchX = this._currentTouchX = HELPER_POINT.x;
				this._startTouchY = this._currentTouchY = HELPER_POINT.y;
				this._isDraggingHorizontally = false;
				this._isDraggingVertically = false;
			}
		}
	}
}
