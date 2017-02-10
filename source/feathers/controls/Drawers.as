/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.BaseScreenNavigator;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	import feathers.core.IValidating;
	import feathers.events.ExclusiveTouch;
	import feathers.events.FeathersEventType;
	import feathers.layout.Orientation;
	import feathers.layout.RelativeDepth;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;
	import feathers.utils.display.getDisplayObjectDepthFromStage;
	import feathers.utils.math.roundToNearest;

	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.ResizeEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * The divider between the bottom drawer and the content when the bottom
	 * drawer is docked.
	 *
	 * <p>In the following example, a <code>Quad</code> is added as the
	 * bottom drawer divider:</p>
	 *
	 * <listing version="3.0">
	 * var divider:Quad = new Quad( 2, 2, 0x999999 );
	 * drawers.bottomDrawerDivider = quad;
	 * drawers.bottomDrawerDockMode = Orientation.BOTH</listing>
	 *
	 * @default null
	 *
	 * @see #bottomDrawer
	 */
	[Style(name="bottomDrawerDivider",type="starling.display.DisplayObject")]

	/**
	 * The divider between the left drawer and the content when the left
	 * drawer is docked.
	 *
	 * <p>In the following example, a <code>Quad</code> is added as the
	 * left drawer divider:</p>
	 *
	 * <listing version="3.0">
	 * var divider:Quad = new Quad( 2, 2, 0x999999 );
	 * drawers.leftDrawerDivider = quad;
	 * drawers.leftDrawerDockMode = Orientation.BOTH</listing>
	 *
	 * @default null
	 *
	 * @see #leftDrawer
	 */
	[Style(name="leftDrawerDivider",type="starling.display.DisplayObject")]

	/**
	 * Determines whether the drawer opens above the content or below it.
	 *
	 * <p>In the following example, the drawers are opened above the
	 * content:</p>
	 *
	 * <listing version="3.0">
	 * drawers.openMode = RelativeDepth.ABOVE;</listing>
	 *
	 * @default feathers.layout.RelativeDepth#BELOW
	 *
	 * @see feathers.layout.RelativeDepth#BELOW
	 * @see feathers.layout.RelativeDepth#ABOVE
	 */
	[Style(name="openMode",type="String")]

	/**
	 * The duration, in seconds, of the animation when a drawer opens or
	 * closes.
	 *
	 * <p>In the following example, the duration of the animation that opens
	 * or closes a drawer is set to 500 milliseconds:</p>
	 *
	 * <listing version="3.0">
	 * drawers.openOrCloseDuration = 0.5;</listing>
	 *
	 * @default 0.25
	 *
	 * @see #style:openOrCloseEase
	 */
	[Style(name="openOrCloseDuration",type="Number")]

	/**
	 * The easing function used for opening or closing the drawers.
	 *
	 * <p>In the following example, the ease of the animation that opens and
	 * closes a drawer is customized:</p>
	 *
	 * <listing version="3.0">
	 * drawers.openOrCloseEase = Transitions.EASE_IN_OUT;</listing>
	 *
	 * @default starling.animation.Transitions.EASE_OUT
	 *
	 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
	 * @see #style:openOrCloseDuration
	 */
	[Style(name="openOrCloseEase",type="Object")]

	/**
	 * An optional display object that appears above the content when a
	 * drawer is open.
	 *
	 * <p>In the following example, a <code>Quad</code> is added as the
	 * overlay skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Quad = new Quad( 10, 10, 0x000000 );
	 * skin.alpha = 0.75;
	 * drawers.overlaySkin = skin;</listing>
	 *
	 * @default null
	 */
	[Style(name="overlaySkin",type="starling.display.DisplayObject")]

	/**
	 * The divider between the right drawer and the content when the right
	 * drawer is docked.
	 *
	 * <p>In the following example, a <code>Quad</code> is added as the
	 * right drawer divider:</p>
	 *
	 * <listing version="3.0">
	 * var divider:Quad = new Quad( 2, 2, 0x999999 );
	 * drawers.rightDrawerDivider = quad;
	 * drawers.rightDrawerDockMode = Orientation.BOTH</listing>
	 *
	 * @default null
	 *
	 * @see #rightDrawer
	 */
	[Style(name="rightDrawerDivider",type="starling.display.DisplayObject")]

	/**
	 * The divider between the top drawer and the content when the top
	 * drawer is docked.
	 *
	 * <p>In the following example, a <code>Quad</code> is added as the
	 * top drawer divider:</p>
	 *
	 * <listing version="3.0">
	 * var divider:Quad = new Quad( 2, 2, 0x999999 );
	 * drawers.topDrawerDivider = quad;
	 * drawers.topDrawerDockMode = Orientation.BOTH</listing>
	 *
	 * @default null
	 *
	 * @see #topDrawer
	 */
	[Style(name="topDrawerDivider",type="starling.display.DisplayObject")]

	/**
	 * Dispatched when the user starts dragging the content to open or close a
	 * drawer.
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
	 */
	[Event(name="beginInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when the user stops dragging the content to open or close a
	 * drawer. The drawer may continue opening or closing after this event is
	 * dispatched if the user interaction has also triggered an animation.
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
	 */
	[Event(name="endInteraction",type="starling.events.Event")]

	/**
	 * Dispatched when a drawer has completed opening. The <code>data</code>
	 * property of the event indicates which drawer is open.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The drawer that was opened.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.OPEN
	 * @see #event:close starling.events.Event.CLOSE
	 */
	[Event(name="open",type="starling.events.Event")]

	/**
	 * Dispatched when a drawer has completed closing. The <code>data</code>
	 * property of the event indicates which drawer was closed.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The drawer that was closed.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CLOSE
	 * @see #event:open starling.events.Event.OPEN
	 */
	[Event(name="close",type="starling.events.Event")]

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
	 * var navigator:StackScreenNavigator = new StackScreenNavigator();
	 * var list:List = new List();
	 * // the navigator's screens, the list's data provider, and additional
	 * // properties should be set here.
	 * 
	 * var drawers:Drawers = new Drawers();
	 * drawers.content = navigator;
	 * drawers.leftDrawer = menu;
	 * drawers.leftDrawerToggleEventType = Event.OPEN;
	 * this.addChild( drawers );</listing>
	 *
	 * <p>In the example above, a screen in the <code>StackScreenNavigator</code>
	 * component dispatches an event of type <code>Event.OPEN</code> when it
	 * wants to display the slide out the <code>List</code> that is used as
	 * the left drawer.</p>
	 *
	 * @see ../../../help/drawers.html How to use the Feathers Drawers component
	 *
	 * @productversion Feathers 1.2.0
	 */
	public class Drawers extends FeathersControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all <code>Drawers</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		[Deprecated(replacement="feathers.layout.Orientation.PORTRAIT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Orientation.PORTRAIT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DOCK_MODE_PORTRAIT:String = "portrait";

		[Deprecated(replacement="feathers.layout.Orientation.LANDSCAPE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Orientation.LANDSCAPE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DOCK_MODE_LANDSCAPE:String = "landscape";

		[Deprecated(replacement="feathers.layout.Orientation.BOTH",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Orientation.BOTH</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DOCK_MODE_BOTH:String = "both";

		[Deprecated(replacement="feathers.layout.Orientation.NONE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Orientation.NONE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DOCK_MODE_NONE:String = "none";

		[Deprecated(replacement="feathers.layout.RelativeDepth.ABOVE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativeDepth.ABOVE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const OPEN_MODE_ABOVE:String = "overlay";

		[Deprecated(replacement="feathers.layout.RelativeDepth.BELOW",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativeDepth.BELOW</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const OPEN_MODE_BELOW:String = "below";

		[Deprecated(replacement="feathers.controls.AutoSizeMode.STAGE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.AutoSizeMode.STAGE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const AUTO_SIZE_MODE_STAGE:String = "stage";

		[Deprecated(replacement="feathers.controls.AutoSizeMode.CONTENT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.AutoSizeMode.CONTENT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const AUTO_SIZE_MODE_CONTENT:String = "content";

		[Deprecated(replacement="feathers.controls.DragGesture.EDGE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.DragGesture.EDGE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const OPEN_GESTURE_DRAG_CONTENT_EDGE:String = "dragContentEdge";

		[Deprecated(replacement="feathers.controls.DragGesture.CONTENT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.DragGesture.CONTENT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const OPEN_GESTURE_DRAG_CONTENT:String = "dragContent";

		[Deprecated(replacement="feathers.controls.DragGesture.NONE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.DragGesture.NONE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const OPEN_GESTURE_NONE:String = "none";

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
		private static const HELPER_POINT:Point = new Point();

		/**
		 * Constructor.
		 */
		public function Drawers(content:IFeathersControl = null)
		{
			super();
			this.content = content;
			this.addEventListener(Event.ADDED_TO_STAGE, drawers_addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, drawers_removedFromStageHandler);
			this.addEventListener(TouchEvent.TOUCH, drawers_touchHandler);
		}

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
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Drawers.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _originalContentWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalContentHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _content:IFeathersControl;

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
		 * <p>In the following example, a <code>StackScreenNavigator</code> is added
		 * as the content:</p>
		 *
		 * <listing version="3.0">
		 * var navigator:StackScreenNavigator = new StackScreenNavigator();
		 * // additional code to add the screens can go here
		 * drawers.content = navigator;</listing>
		 *
		 * @default null
		 *
		 * @see #contentEventDispatcherField
		 * @see #contentEventDispatcherFunction
		 * @see #contentEventDispatcherChangeEventType
		 */
		public function get content():IFeathersControl
		{
			return this._content
		}

		/**
		 * @private
		 */
		public function set content(value:IFeathersControl):void
		{
			if(this._content === value)
			{
				return;
			}
			if(this._content)
			{
				if(this._contentEventDispatcherChangeEventType)
				{
					this._content.removeEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
				}
				this._content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
				if(this._content.parent === this)
				{
					this.removeChild(DisplayObject(this._content), false);
				}
			}
			this._content = value;
			this._originalContentWidth = NaN;
			this._originalContentHeight = NaN;
			if(this._content)
			{
				if(this._content is BaseScreenNavigator)
				{
					this.contentEventDispatcherField = SCREEN_NAVIGATOR_CONTENT_EVENT_DISPATCHER_FIELD;
					this.contentEventDispatcherChangeEventType = Event.CHANGE;
				}
				if(this._contentEventDispatcherChangeEventType)
				{
					this._content.addEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
				}
				if(this._autoSizeMode === AutoSizeMode.CONTENT || !this.stage)
				{
					this._content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
				}
				if(this._openMode === RelativeDepth.ABOVE)
				{
					this.addChildAt(DisplayObject(this._content), 0);
				}
				else //below
				{
					//the content should appear under the overlay skin, if it exists
					if(this._overlaySkin)
					{
						this.addChildAt(DisplayObject(this._content), this.getChildIndex(this._overlaySkin));
					}
					else
					{
						this.addChild(DisplayObject(this._content));
					}
				}
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _overlaySkinOriginalAlpha:Number = 1;

		/**
		 * @private
		 */
		protected var _overlaySkin:DisplayObject;

		/**
		 * @private
		 */
		public function get overlaySkin():DisplayObject
		{
			return this._overlaySkin
		}

		/**
		 * @private
		 */
		public function set overlaySkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._overlaySkin === value)
			{
				return;
			}
			if(this._overlaySkin && this._overlaySkin.parent == this)
			{
				this.removeChild(this._overlaySkin, false);
			}
			this._overlaySkin = value;
			if(this._overlaySkin)
			{
				this._overlaySkinOriginalAlpha = this._overlaySkin.alpha;
				this._overlaySkin.visible = this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen;
				this.addChild(this._overlaySkin);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _originalTopDrawerWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalTopDrawerHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _topDrawer:IFeathersControl;

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
		public function get topDrawer():IFeathersControl
		{
			return this._topDrawer
		}

		/**
		 * @private
		 */
		public function set topDrawer(value:IFeathersControl):void
		{
			if(this._topDrawer === value)
			{
				return;
			}
			if(this.isTopDrawerOpen && value === null)
			{
				this.isTopDrawerOpen = false;
			}
			if(this._topDrawer && this._topDrawer.parent === this)
			{
				this.removeChild(DisplayObject(this._topDrawer), false);
			}
			this._topDrawer = value;
			this._originalTopDrawerWidth = NaN;
			this._originalTopDrawerHeight = NaN;
			if(this._topDrawer)
			{
				this._topDrawer.visible = false;
				this._topDrawer.addEventListener(FeathersEventType.RESIZE, drawer_resizeHandler);
				if(this._openMode === RelativeDepth.ABOVE)
				{
					this.addChild(DisplayObject(this._topDrawer));
				}
				else //below
				{
					this.addChildAt(DisplayObject(this._topDrawer), 0);
				}
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _topDrawerDivider:DisplayObject;

		/**
		 * @private
		 */
		public function get topDrawerDivider():DisplayObject
		{
			return this._topDrawerDivider;
		}

		/**
		 * @private
		 */
		public function set topDrawerDivider(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._topDrawerDivider === value)
			{
				return;
			}
			if(this._topDrawerDivider && this._topDrawerDivider.parent == this)
			{
				this.removeChild(this._topDrawerDivider, false);
			}
			this._topDrawerDivider = value;
			if(this._topDrawerDivider)
			{
				this._topDrawerDivider.visible = false;
				this.addChild(this._topDrawerDivider);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _topDrawerDockMode:String = Orientation.NONE;

		[Inspectable(type="String",enumeration="portrait,landscape,both,none")]
		/**
		 * Determines if the top drawer is docked in all, some, or no stage
		 * orientations. The current stage orientation is determined by
		 * calculating the aspect ratio of the stage.
		 *
		 * <p>In the following example, the top drawer is docked in the
		 * landscape stage orientation:</p>
		 *
		 * <listing version="3.0">
		 * drawers.topDrawerDockMode = Orientation.LANDSCAPE;</listing>
		 *
		 * @default feathers.layout.Orientation.NONE
		 *
		 * @see feathers.layout.Orientation#PORTRAIT
		 * @see feathers.layout.Orientation#LANDSCAPE
		 * @see feathers.layout.Orientation#NONE
		 * @see feathers.layout.Orientation#BOTH
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
			if(this.contentEventDispatcher && this._topDrawerToggleEventType)
			{
				this.contentEventDispatcher.removeEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
			}
			this._topDrawerToggleEventType = value;
			if(this.contentEventDispatcher && this._topDrawerToggleEventType)
			{
				this.contentEventDispatcher.addEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
			}
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
			if(value)
			{
				this.isRightDrawerOpen = false;
				this.isBottomDrawerOpen = false;
				this.isLeftDrawerOpen = false;
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
			if(!this._topDrawer)
			{
				return false;
			}
			if(this._topDrawerDockMode === Orientation.BOTH)
			{
				return true;
			}
			if(this._topDrawerDockMode === Orientation.NONE)
			{
				return false;
			}
			var stage:Stage = this.stage;
			if(stage === null)
			{
				//fall back to the current stage, but it may be wrong...
				stage = Starling.current.stage;
			}
			if(stage.stageWidth > stage.stageHeight)
			{
				return this._topDrawerDockMode === Orientation.LANDSCAPE;
			}
			return this._topDrawerDockMode === Orientation.PORTRAIT;
		}

		/**
		 * @private
		 */
		protected var _originalRightDrawerWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalRightDrawerHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _rightDrawer:IFeathersControl;

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
		public function get rightDrawer():IFeathersControl
		{
			return this._rightDrawer
		}

		/**
		 * @private
		 */
		public function set rightDrawer(value:IFeathersControl):void
		{
			if(this._rightDrawer == value)
			{
				return;
			}
			if(this.isRightDrawerOpen && value === null)
			{
				this.isRightDrawerOpen = false;
			}
			if(this._rightDrawer && this._rightDrawer.parent == this)
			{
				this.removeChild(DisplayObject(this._rightDrawer), false);
			}
			this._rightDrawer = value;
			this._originalRightDrawerWidth = NaN;
			this._originalRightDrawerHeight = NaN;
			if(this._rightDrawer)
			{
				this._rightDrawer.visible = false;
				this._rightDrawer.addEventListener(FeathersEventType.RESIZE, drawer_resizeHandler);
				if(this._openMode === RelativeDepth.ABOVE)
				{
					this.addChild(DisplayObject(this._rightDrawer));
				}
				else //below
				{
					this.addChildAt(DisplayObject(this._rightDrawer), 0);
				}
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _rightDrawerDivider:DisplayObject;

		/**
		 * @private
		 */
		public function get rightDrawerDivider():DisplayObject
		{
			return this._rightDrawerDivider;
		}

		/**
		 * @private
		 */
		public function set rightDrawerDivider(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._rightDrawerDivider === value)
			{
				return;
			}
			if(this._rightDrawerDivider && this._rightDrawerDivider.parent == this)
			{
				this.removeChild(this._rightDrawerDivider, false);
			}
			this._rightDrawerDivider = value;
			if(this._rightDrawerDivider)
			{
				this._rightDrawerDivider.visible = false;
				this.addChild(this._rightDrawerDivider);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _rightDrawerDockMode:String = Orientation.NONE;

		[Inspectable(type="String",enumeration="portrait,landscape,both,none")]
		/**
		 * Determines if the right drawer is docked in all, some, or no stage
		 * orientations. The current stage orientation is determined by
		 * calculating the aspect ratio of the stage.
		 *
		 * <p>In the following example, the right drawer is docked in the
		 * landscape stage orientation:</p>
		 *
		 * <listing version="3.0">
		 * drawers.rightDrawerDockMode = Orientation.LANDSCAPE;</listing>
		 *
		 * @default feathers.layout.Orientation.NONE
		 *
		 * @see feathers.layout.Orientation#PORTRAIT
		 * @see feathers.layout.Orientation#LANDSCAPE
		 * @see feathers.layout.Orientation#NONE
		 * @see feathers.layout.Orientation#BOTH
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
			if(this.contentEventDispatcher && this._rightDrawerToggleEventType)
			{
				this.contentEventDispatcher.removeEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
			}
			this._rightDrawerToggleEventType = value;
			if(this.contentEventDispatcher && this._rightDrawerToggleEventType)
			{
				this.contentEventDispatcher.addEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
			}
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
			if(value)
			{
				this.isTopDrawerOpen = false;
				this.isBottomDrawerOpen = false;
				this.isLeftDrawerOpen = false;
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
			if(!this._rightDrawer)
			{
				return false;
			}
			if(this._rightDrawerDockMode === Orientation.BOTH)
			{
				return true;
			}
			if(this._rightDrawerDockMode === Orientation.NONE)
			{
				return false;
			}
			var stage:Stage = this.stage;
			if(stage === null)
			{
				//fall back to the current stage, but it may be wrong...
				stage = Starling.current.stage;
			}
			if(stage.stageWidth > stage.stageHeight)
			{
				return this._rightDrawerDockMode === Orientation.LANDSCAPE;
			}
			return this._rightDrawerDockMode === Orientation.PORTRAIT;
		}

		/**
		 * @private
		 */
		protected var _originalBottomDrawerWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalBottomDrawerHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _bottomDrawer:IFeathersControl;

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
		public function get bottomDrawer():IFeathersControl
		{
			return this._bottomDrawer
		}

		/**
		 * @private
		 */
		public function set bottomDrawer(value:IFeathersControl):void
		{
			if(this._bottomDrawer === value)
			{
				return;
			}
			if(this.isBottomDrawerOpen && value === null)
			{
				this.isBottomDrawerOpen = false;
			}
			if(this._bottomDrawer && this._bottomDrawer.parent === this)
			{
				this.removeChild(DisplayObject(this._bottomDrawer), false);
			}
			this._bottomDrawer = value;
			this._originalBottomDrawerWidth = NaN;
			this._originalBottomDrawerHeight = NaN;
			if(this._bottomDrawer)
			{
				this._bottomDrawer.visible = false;
				this._bottomDrawer.addEventListener(FeathersEventType.RESIZE, drawer_resizeHandler);
				if(this._openMode === RelativeDepth.ABOVE)
				{
					this.addChild(DisplayObject(this._bottomDrawer));
				}
				else //below
				{
					this.addChildAt(DisplayObject(this._bottomDrawer), 0);
				}
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _bottomDrawerDivider:DisplayObject;

		/**
		 * @private
		 */
		public function get bottomDrawerDivider():DisplayObject
		{
			return this._bottomDrawerDivider;
		}

		/**
		 * @private
		 */
		public function set bottomDrawerDivider(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._bottomDrawerDivider === value)
			{
				return;
			}
			if(this._bottomDrawerDivider && this._bottomDrawerDivider.parent == this)
			{
				this.removeChild(this._bottomDrawerDivider, false);
			}
			this._bottomDrawerDivider = value;
			if(this._bottomDrawerDivider)
			{
				this._bottomDrawerDivider.visible = false;
				this.addChild(this._bottomDrawerDivider);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _bottomDrawerDockMode:String = Orientation.NONE;

		[Inspectable(type="String",enumeration="portrait,landscape,both,none")]
		/**
		 * Determines if the bottom drawer is docked in all, some, or no stage
		 * orientations. The current stage orientation is determined by
		 * calculating the aspect ratio of the stage.
		 *
		 * <p>In the following example, the bottom drawer is docked in the
		 * landscape stage orientation:</p>
		 *
		 * <listing version="3.0">
		 * drawers.bottomDrawerDockMode = Orientation.LANDSCAPE;</listing>
		 *
		 * @default feathers.layout.Orientation.NONE
		 *
		 * @see feathers.layout.Orientation#PORTRAIT
		 * @see feathers.layout.Orientation#LANDSCAPE
		 * @see feathers.layout.Orientation#NONE
		 * @see feathers.layout.Orientation#BOTH
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
			if(this.contentEventDispatcher && this._bottomDrawerToggleEventType)
			{
				this.contentEventDispatcher.removeEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
			}
			this._bottomDrawerToggleEventType = value;
			if(this.contentEventDispatcher && this._bottomDrawerToggleEventType)
			{
				this.contentEventDispatcher.addEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
			}
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
			if(value)
			{
				this.isTopDrawerOpen = false;
				this.isRightDrawerOpen = false;
				this.isLeftDrawerOpen = false;
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
			if(!this._bottomDrawer)
			{
				return false;
			}
			if(this._bottomDrawerDockMode === Orientation.BOTH)
			{
				return true;
			}
			if(this._bottomDrawerDockMode === Orientation.NONE)
			{
				return false;
			}
			var stage:Stage = this.stage;
			if(stage === null)
			{
				//fall back to the current stage, but it may be wrong...
				stage = Starling.current.stage;
			}
			if(stage.stageWidth > stage.stageHeight)
			{
				return this._bottomDrawerDockMode === Orientation.LANDSCAPE;
			}
			return this._bottomDrawerDockMode === Orientation.PORTRAIT;
		}

		/**
		 * @private
		 */
		protected var _originalLeftDrawerWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var _originalLeftDrawerHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _leftDrawer:IFeathersControl;

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
		public function get leftDrawer():IFeathersControl
		{
			return this._leftDrawer;
		}

		/**
		 * @private
		 */
		public function set leftDrawer(value:IFeathersControl):void
		{
			if(this._leftDrawer === value)
			{
				return;
			}
			if(this.isLeftDrawerOpen && value === null)
			{
				this.isLeftDrawerOpen = false;
			}
			if(this._leftDrawer && this._leftDrawer.parent === this)
			{
				this.removeChild(DisplayObject(this._leftDrawer), false);
			}
			this._leftDrawer = value;
			this._originalLeftDrawerWidth = NaN;
			this._originalLeftDrawerHeight = NaN;
			if(this._leftDrawer)
			{
				this._leftDrawer.visible = false;
				this._leftDrawer.addEventListener(FeathersEventType.RESIZE, drawer_resizeHandler);
				if(this._openMode === RelativeDepth.ABOVE)
				{
					this.addChild(DisplayObject(this._leftDrawer));
				}
				else //below
				{
					this.addChildAt(DisplayObject(this._leftDrawer), 0);
				}
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _leftDrawerDivider:DisplayObject;

		/**
		 * @private
		 */
		public function get leftDrawerDivider():DisplayObject
		{
			return this._leftDrawerDivider;
		}

		/**
		 * @private
		 */
		public function set leftDrawerDivider(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._leftDrawerDivider === value)
			{
				return;
			}
			if(this._leftDrawerDivider && this._leftDrawerDivider.parent == this)
			{
				this.removeChild(this._leftDrawerDivider, false);
			}
			this._leftDrawerDivider = value;
			if(this._leftDrawerDivider)
			{
				this._leftDrawerDivider.visible = false;
				this.addChild(this._leftDrawerDivider);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _leftDrawerDockMode:String = Orientation.NONE;

		[Inspectable(type="String",enumeration="portrait,landscape,both,none")]
		/**
		 * Determines if the left drawer is docked in all, some, or no stage
		 * orientations. The current stage orientation is determined by
		 * calculating the aspect ratio of the stage.
		 *
		 * <p>In the following example, the left drawer is docked in the
		 * landscape stage orientation:</p>
		 *
		 * <listing version="3.0">
		 * drawers.leftDrawerDockMode = Orientation.LANDSCAPE;</listing>
		 *
		 * @default feathers.layout.Orientation.NONE
		 *
		 * @see feathers.layout.Orientation#PORTRAIT
		 * @see feathers.layout.Orientation#LANDSCAPE
		 * @see feathers.layout.Orientation#NONE
		 * @see feathers.layout.Orientation#BOTH
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
			if(this.contentEventDispatcher && this._leftDrawerToggleEventType)
			{
				this.contentEventDispatcher.removeEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
			}
			this._leftDrawerToggleEventType = value;
			if(this.contentEventDispatcher && this._leftDrawerToggleEventType)
			{
				this.contentEventDispatcher.addEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
			}
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
			if(value)
			{
				this.isTopDrawerOpen = false;
				this.isRightDrawerOpen = false;
				this.isBottomDrawerOpen = false;
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
			if(!this._leftDrawer)
			{
				return false;
			}
			if(this._leftDrawerDockMode === Orientation.BOTH)
			{
				return true;
			}
			if(this._leftDrawerDockMode === Orientation.NONE)
			{
				return false;
			}
			var stage:Stage = this.stage;
			if(stage === null)
			{
				//fall back to the current stage, but it may be wrong...
				stage = Starling.current.stage;
			}
			if(stage.stageWidth > stage.stageHeight)
			{
				return this._leftDrawerDockMode === Orientation.LANDSCAPE;
			}
			return this._leftDrawerDockMode == Orientation.PORTRAIT;
		}

		/**
		 * @private
		 */
		protected var _autoSizeMode:String = AutoSizeMode.STAGE;

		[Inspectable(type="String",enumeration="stage,content")]
		/**
		 * Determines how the drawers container will set its own size when its
		 * dimensions (width and height) aren't set explicitly.
		 *
		 * <p>In the following example, the drawers container will be sized to
		 * match its content:</p>
		 *
		 * <listing version="3.0">
		 * drawers.autoSizeMode = AutoSizeMode.CONTENT;</listing>
		 *
		 * @default feathers.controls.AutoSizeMode.STAGE
		 *
		 * @see feathers.controls.AutoSizeMode#STAGE
		 * @see feathers.controls.AutoSizeMode#CONTENT
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
			if(this._content !== null)
			{
				if(this._autoSizeMode == AutoSizeMode.CONTENT)
				{
					this._content.addEventListener(FeathersEventType.RESIZE, content_resizeHandler);
				}
				else
				{
					this._content.removeEventListener(FeathersEventType.RESIZE, content_resizeHandler);
				}
			}
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
		protected var _openMode:String = RelativeDepth.BELOW;

		[Inspectable(type="String",enumeration="below,above")]
		/**
		 * @private
		 */
		public function get openMode():String
		{
			return this._openMode;
		}

		/**
		 * @private
		 */
		public function set openMode(value:String):void
		{
			//for legacy reasons, OPEN_MODE_ABOVE had a different string value
			if(value === "overlay")
			{
				value = RelativeDepth.ABOVE;
			}
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._openMode == value)
			{
				return;
			}
			this._openMode = value;
			if(this._content !== null)
			{
				if(this._openMode === RelativeDepth.ABOVE)
				{
					this.setChildIndex(DisplayObject(this._content), 0);
				}
				else //below
				{
					if(this._overlaySkin)
					{
						//the content should below the overlay skin
						this.setChildIndex(DisplayObject(this._content), this.numChildren - 1);
						this.setChildIndex(this._overlaySkin, this.numChildren - 1);
					}
					else
					{
						this.setChildIndex(DisplayObject(this._content), this.numChildren - 1);
					}
				}
			}
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _openGesture:String = DragGesture.EDGE;

		[Inspectable(type="String",enumeration="content,edge,none")]
		/**
		 * An optional touch gesture used to open a drawer.
		 *
		 * <p>In the following example, the drawers are opened by dragging
		 * anywhere inside the content:</p>
		 *
		 * <listing version="3.0">
		 * drawers.openGesture = DragGesture.CONTENT;</listing>
		 *
		 * @default feathers.controls.DragGesture.EDGE
		 *
		 * @see feathers.controls.DragGesture#NONE
		 * @see feathers.controls.DragGesture#CONTENT
		 * @see feathers.controls.DragGesture#EDGE
		 */
		public function get openGesture():String
		{
			return this._openGesture;
		}

		/**
		 * @private
		 */
		public function set openGesture(value:String):void
		{
			if(value === "dragContent")
			{
				value = DragGesture.CONTENT;
			}
			else if(value === "dragContentEdge")
			{
				value = DragGesture.EDGE;
			}
			this._openGesture = value;
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
		 * drawers.minimumDragDistance = 0.1;</listing>
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
		protected var _minimumDrawerThrowVelocity:Number = 5;

		/**
		 * The minimum physical velocity (in inches per second) that a touch
		 * must move before the a drawern can be "thrown" to open or close it.
		 * Otherwise, it will settle open or closed based on which state is
		 * closer when the touch ends.
		 *
		 * <p>In the following example, the minimum drawer throw velocity is customized:</p>
		 *
		 * <listing version="3.0">
		 * drawers.minimumDrawerThrowVelocity = 2;</listing>
		 *
		 * @default 5
		 */
		public function get minimumDrawerThrowVelocity():Number
		{
			return this._minimumDrawerThrowVelocity;
		}

		/**
		 * @private
		 */
		public function set minimumDrawerThrowVelocity(value:Number):void
		{
			this._minimumDrawerThrowVelocity = value;
		}

		/**
		 * @private
		 */
		protected var _openGestureEdgeSize:Number = 0.1;

		/**
		 * The minimum physical distance (in inches) that a touch must move
		 * before a drag gesture begins.
		 *
		 * <p>In the following example, the open gesture edge size customized:</p>
		 *
		 * <listing version="3.0">
		 * drawers.openGestureEdgeSize = 0.25;</listing>
		 *
		 * @default 0.1
		 */
		public function get openGestureEdgeSize():Number
		{
			return this._openGestureEdgeSize;
		}

		/**
		 * @private
		 */
		public function set openGestureEdgeSize(value:Number):void
		{
			this._openGestureEdgeSize = value;
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
		 * <p>For <code>StackScreenNavigator</code> and
		 * <code>ScreenNavigator</code> components, this value is automatically
		 * set to <code>Event.CHANGE</code>.</p>
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
			if(this._content !== null && this._contentEventDispatcherChangeEventType)
			{
				this._content.removeEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
			}
			this._contentEventDispatcherChangeEventType = value;
			if(this._content !== null && this._contentEventDispatcherChangeEventType)
			{
				this._content.addEventListener(this._contentEventDispatcherChangeEventType, content_eventDispatcherChangeHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _contentEventDispatcherField:String;

		/**
		 * A property of the <code>content</code> that references an event
		 * dispatcher that dispatches events to toggle drawers open and closed.
		 *
		 * <p>For <code>StackScreenNavigator</code> and
		 * <code>ScreenNavigator</code> components, this value is automatically
		 * set to <code>"activeScreen"</code> to listen for events from the
		 * currently active/visible screen.</p>
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
			this.invalidate(INVALIDATION_FLAG_DATA);
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
			this.invalidate(INVALIDATION_FLAG_DATA);
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			this._openOrCloseDuration = value;
		}

		/**
		 * @private
		 */
		protected var _openOrCloseEase:Object = Transitions.EASE_OUT;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		protected var _isDragging:Boolean = false;

		/**
		 * @private
		 */
		protected var _isDraggingTopDrawer:Boolean = false;

		/**
		 * @private
		 */
		protected var _isDraggingRightDrawer:Boolean = false;

		/**
		 * @private
		 */
		protected var _isDraggingBottomDrawer:Boolean = false;

		/**
		 * @private
		 */
		protected var _isDraggingLeftDrawer:Boolean = false;

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
		override public function hitTest(localPoint:Point):DisplayObject
		{
			var result:DisplayObject = super.hitTest(localPoint);
			if(result)
			{
				if(this._isDragging)
				{
					return this;
				}
				if(this.isTopDrawerOpen && result != this._topDrawer && !(this._topDrawer is DisplayObjectContainer && DisplayObjectContainer(this._topDrawer).contains(result)))
				{
					return this;
				}
				else if(this.isRightDrawerOpen && result != this._rightDrawer && !(this._rightDrawer is DisplayObjectContainer && DisplayObjectContainer(this._rightDrawer).contains(result)))
				{
					return this;
				}
				else if(this.isBottomDrawerOpen && result != this._bottomDrawer && !(this._bottomDrawer is DisplayObjectContainer && DisplayObjectContainer(this._bottomDrawer).contains(result)))
				{
					return this;
				}
				else if(this.isLeftDrawerOpen && result != this._leftDrawer && !(this._leftDrawer is DisplayObjectContainer && DisplayObjectContainer(this._leftDrawer).contains(result)))
				{
					return this;
				}
				return result;
			}
			//we want to register touches in our hitArea as a last resort
			if(!this.visible || !this.touchable)
			{
				return null;
			}
			return this._hitArea.contains(localPoint.x, localPoint.y) ? this : null;
		}

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
			if(!this._topDrawer || this.isTopDrawerDocked)
			{
				return;
			}
			this.pendingToggleDuration = duration;
			if(this.isToggleTopDrawerPending)
			{
				return;
			}
			if(!this.isTopDrawerOpen)
			{
				this.isRightDrawerOpen = false;
				this.isBottomDrawerOpen = false;
				this.isLeftDrawerOpen = false;
			}
			this.isToggleTopDrawerPending = true;
			this.isToggleRightDrawerPending = false;
			this.isToggleBottomDrawerPending = false;
			this.isToggleLeftDrawerPending = false;
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
			if(!this._rightDrawer || this.isRightDrawerDocked)
			{
				return;
			}
			this.pendingToggleDuration = duration;
			if(this.isToggleRightDrawerPending)
			{
				return;
			}
			if(!this.isRightDrawerOpen)
			{
				this.isTopDrawerOpen = false;
				this.isBottomDrawerOpen = false;
				this.isLeftDrawerOpen = false;
			}
			this.isToggleTopDrawerPending = false;
			this.isToggleRightDrawerPending = true;
			this.isToggleBottomDrawerPending = false;
			this.isToggleLeftDrawerPending = false;
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
			if(!this._bottomDrawer || this.isBottomDrawerDocked)
			{
				return;
			}
			this.pendingToggleDuration = duration;
			if(this.isToggleBottomDrawerPending)
			{
				return;
			}
			if(!this.isBottomDrawerOpen)
			{
				this.isTopDrawerOpen = false;
				this.isRightDrawerOpen = false;
				this.isLeftDrawerOpen = false;
			}
			this.isToggleTopDrawerPending = false;
			this.isToggleRightDrawerPending = false;
			this.isToggleBottomDrawerPending = true;
			this.isToggleLeftDrawerPending = false;
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
			if(!this._leftDrawer || this.isLeftDrawerDocked)
			{
				return;
			}
			this.pendingToggleDuration = duration;
			if(this.isToggleLeftDrawerPending)
			{
				return;
			}
			if(!this.isLeftDrawerOpen)
			{
				this.isTopDrawerOpen = false;
				this.isRightDrawerOpen = false;
				this.isBottomDrawerOpen = false;
			}
			this.isToggleTopDrawerPending = false;
			this.isToggleRightDrawerPending = false;
			this.isToggleBottomDrawerPending = false;
			this.isToggleLeftDrawerPending = true;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var selectedInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);

			if(dataInvalid)
			{
				this.refreshCurrentEventTarget();
			}

			if(sizeInvalid || layoutInvalid)
			{
				this.refreshDrawerStates();
			}
			if(sizeInvalid || layoutInvalid || selectedInvalid)
			{
				this.refreshOverlayState();
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
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}
			
			var measureContent:Boolean = this._autoSizeMode === AutoSizeMode.CONTENT || !this.stage;
			var isTopDrawerDocked:Boolean = this.isTopDrawerDocked;
			var isRightDrawerDocked:Boolean = this.isRightDrawerDocked;
			var isBottomDrawerDocked:Boolean = this.isBottomDrawerDocked;
			var isLeftDrawerDocked:Boolean = this.isLeftDrawerDocked;
			if(measureContent)
			{
				if(this._content !== null)
				{
					this._content.validate();
					if(this._originalContentWidth !== this._originalContentWidth) //isNaN
					{
						this._originalContentWidth = this._content.width;
					}
					if(this._originalContentHeight !== this._originalContentHeight) //isNaN
					{
						this._originalContentHeight = this._content.height;
					}
				}
				if(isTopDrawerDocked)
				{
					this._topDrawer.validate();
					if(this._originalTopDrawerWidth !== this._originalTopDrawerWidth) //isNaN
					{
						this._originalTopDrawerWidth = this._topDrawer.width;
					}
					if(this._originalTopDrawerHeight !== this._originalTopDrawerHeight) //isNaN
					{
						this._originalTopDrawerHeight = this._topDrawer.height;
					}
				}
				if(isRightDrawerDocked)
				{
					this._rightDrawer.validate();
					if(this._originalRightDrawerWidth !== this._originalRightDrawerWidth) //isNaN
					{
						this._originalRightDrawerWidth = this._rightDrawer.width;
					}
					if(this._originalRightDrawerHeight !== this._originalRightDrawerHeight) //isNaN
					{
						this._originalRightDrawerHeight = this._rightDrawer.height;
					}
				}
				if(isBottomDrawerDocked)
				{
					this._bottomDrawer.validate();
					if(this._originalBottomDrawerWidth !== this._originalBottomDrawerWidth) //isNaN
					{
						this._originalBottomDrawerWidth = this._bottomDrawer.width;
					}
					if(this._originalBottomDrawerHeight !== this._originalBottomDrawerHeight) //isNaN
					{
						this._originalBottomDrawerHeight = this._bottomDrawer.height;
					}
				}
				if(isLeftDrawerDocked)
				{
					this._leftDrawer.validate();
					if(this._originalLeftDrawerWidth !== this._originalLeftDrawerWidth) //isNaN
					{
						this._originalLeftDrawerWidth = this._leftDrawer.width;
					}
					if(this._originalLeftDrawerHeight !== this._originalLeftDrawerHeight) //isNaN
					{
						this._originalLeftDrawerHeight = this._leftDrawer.height;
					}
				}
			}

			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				if(measureContent)
				{
					if(this._content !== null)
					{
						newWidth = this._originalContentWidth;
					}
					else
					{
						newWidth = 0;
					}
					if(isLeftDrawerDocked)
					{
						newWidth += this._originalLeftDrawerWidth;
					}
					if(isRightDrawerDocked)
					{
						newWidth += this._originalRightDrawerWidth;
					}
					if(isTopDrawerDocked && this._originalTopDrawerWidth > newWidth)
					{
						newWidth = this._originalTopDrawerWidth;
					}
					if(isBottomDrawerDocked && this._originalBottomDrawerWidth > newWidth)
					{
						newWidth = this._originalBottomDrawerWidth;
					}
				}
				else
				{
					newWidth = this.stage.stageWidth;
				}
			}

			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				if(measureContent)
				{
					if(this._content !== null)
					{
						newHeight = this._originalContentHeight;
					}
					else
					{
						newHeight = 0;
					}
					if(isTopDrawerDocked)
					{
						newHeight += this._originalTopDrawerHeight;
					}
					if(isBottomDrawerDocked)
					{
						newHeight += this._originalBottomDrawerHeight;
					}
					if(isLeftDrawerDocked && this._originalLeftDrawerHeight > newHeight)
					{
						newHeight = this._originalLeftDrawerHeight;
					}
					if(isRightDrawerDocked && this._originalRightDrawerHeight > newHeight)
					{
						newHeight = this._originalRightDrawerHeight;
					}
				}
				else
				{
					newHeight = this.stage.stageHeight;
				}
			}

			var newMinWidth:Number = this._explicitMinWidth;
			if(needsMinWidth)
			{
				if(measureContent)
				{
					if(this._content !== null)
					{
						newMinWidth = this._content.minWidth;
					}
					else
					{
						newMinWidth = 0;
					}
					if(isLeftDrawerDocked)
					{
						newMinWidth += this._leftDrawer.minWidth;
					}
					if(isRightDrawerDocked)
					{
						newMinWidth += this._rightDrawer.minWidth;
					}
					if(isTopDrawerDocked && this._topDrawer.minWidth > newMinWidth)
					{
						newMinWidth = this._topDrawer.minWidth;
					}
					if(isBottomDrawerDocked && this._bottomDrawer.minWidth > newMinWidth)
					{
						newMinWidth = this._bottomDrawer.minWidth;
					}
				}
				else
				{
					newMinWidth = this.stage.stageWidth;
				}
			}

			var newMinHeight:Number = this._explicitMinHeight;
			if(needsMinHeight)
			{
				if(measureContent)
				{
					if(this._content !== null)
					{
						newMinHeight = this._content.minHeight;
					}
					else
					{
						newMinHeight = 0;
					}
					if(isTopDrawerDocked)
					{
						newMinHeight += this._topDrawer.minHeight;
					}
					if(isBottomDrawerDocked)
					{
						newMinHeight += this._bottomDrawer.minHeight;
					}
					if(isLeftDrawerDocked && this._leftDrawer.minHeight > newMinHeight)
					{
						newMinHeight = this._leftDrawer.minHeight;
					}
					if(isRightDrawerDocked && this._rightDrawer.minHeight > newMinHeight)
					{
						newMinHeight = this._rightDrawer.minHeight;
					}
				}
				else
				{
					newMinHeight = this.stage.stageHeight;
				}
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * Positions and sizes the children.
		 */
		protected function layoutChildren():void
		{
			var isTopDrawerOpen:Boolean = this.isTopDrawerOpen;
			var isRightDrawerOpen:Boolean = this.isRightDrawerOpen;
			var isBottomDrawerOpen:Boolean = this.isBottomDrawerOpen;
			var isLeftDrawerOpen:Boolean = this.isLeftDrawerOpen;
			var isTopDrawerDocked:Boolean = this.isTopDrawerDocked;
			var isRightDrawerDocked:Boolean = this.isRightDrawerDocked;
			var isBottomDrawerDocked:Boolean = this.isBottomDrawerDocked;
			var isLeftDrawerDocked:Boolean = this.isLeftDrawerDocked;

			var topDrawerHeight:Number = 0;
			var bottomDrawerHeight:Number = 0;
			if(this._topDrawer !== null)
			{
				this._topDrawer.width = this.actualWidth;
				this._topDrawer.validate();
				topDrawerHeight = this._topDrawer.height;
				if(this._topDrawerDivider !== null)
				{
					this._topDrawerDivider.width = this._topDrawer.width;
					if(this._topDrawerDivider is IValidating)
					{
						IValidating(this._topDrawerDivider).validate();
					}
				}
			}
			if(this._bottomDrawer !== null)
			{
				this._bottomDrawer.width = this.actualWidth;
				this._bottomDrawer.validate();
				bottomDrawerHeight = this._bottomDrawer.height;
				if(this._bottomDrawerDivider !== null)
				{
					this._bottomDrawerDivider.width = this._bottomDrawer.width;
					if(this._bottomDrawerDivider is IValidating)
					{
						IValidating(this._bottomDrawerDivider).validate();
					}
				}
			}

			var contentHeight:Number = this.actualHeight;
			if(isTopDrawerDocked)
			{
				contentHeight -= topDrawerHeight;
				if(this._topDrawerDivider !== null)
				{
					contentHeight -= this._topDrawerDivider.height;
				}
			}
			if(isBottomDrawerDocked)
			{
				contentHeight -= bottomDrawerHeight;
				if(this._bottomDrawerDivider !== null)
				{
					contentHeight -= this._bottomDrawerDivider.height;
				}
			}
			if(contentHeight < 0)
			{
				contentHeight = 0;
			}

			var rightDrawerWidth:Number = 0;
			var leftDrawerWidth:Number = 0;
			if(this._rightDrawer !== null)
			{
				if(isRightDrawerDocked)
				{
					this._rightDrawer.height = contentHeight;
				}
				else
				{
					this._rightDrawer.height = this.actualHeight;
				}
				this._rightDrawer.validate();
				rightDrawerWidth = this._rightDrawer.width;
				if(this._rightDrawerDivider !== null)
				{
					this._rightDrawerDivider.height = this._rightDrawer.height;
					if(this._rightDrawerDivider is IValidating)
					{
						IValidating(this._rightDrawerDivider).validate();
					}
				}
			}
			if(this._leftDrawer !== null)
			{
				if(isLeftDrawerDocked)
				{
					this._leftDrawer.height = contentHeight;
				}
				else
				{
					this._leftDrawer.height = this.actualHeight;
				}
				this._leftDrawer.validate();
				leftDrawerWidth = this._leftDrawer.width;
				if(this._leftDrawerDivider !== null)
				{
					this._leftDrawerDivider.height = this._leftDrawer.height;
					if(this._leftDrawerDivider is IValidating)
					{
						IValidating(this._leftDrawerDivider).validate();
					}
				}
			}

			var contentWidth:Number = this.actualWidth;
			if(isLeftDrawerDocked)
			{
				contentWidth -= leftDrawerWidth;
				if(this._leftDrawerDivider !== null)
				{
					contentWidth -= this._leftDrawerDivider.width;
				}
			}
			if(isRightDrawerDocked)
			{
				contentWidth -= rightDrawerWidth;
				if(this._rightDrawerDivider !== null)
				{
					contentWidth -= this._rightDrawerDivider.width;
				}
			}
			if(contentWidth < 0)
			{
				contentWidth = 0;
			}

			var contentX:Number = 0;
			if(isRightDrawerOpen && this._openMode === RelativeDepth.BELOW)
			{
				contentX = -rightDrawerWidth;
				if(isLeftDrawerDocked)
				{
					contentX += leftDrawerWidth;
					if(this._leftDrawerDivider)
					{
						contentX += this._leftDrawerDivider.width;
					}
				}
			}
			else if((isLeftDrawerOpen && this._openMode === RelativeDepth.BELOW) || isLeftDrawerDocked)
			{
				contentX = leftDrawerWidth;
				if(this._leftDrawerDivider && isLeftDrawerDocked)
				{
					contentX += this._leftDrawerDivider.width;
				}
			}
			var contentY:Number = 0;
			if(isBottomDrawerOpen && this._openMode === RelativeDepth.BELOW)
			{
				contentY = -bottomDrawerHeight;
				if(isTopDrawerDocked)
				{
					contentY += topDrawerHeight;
					if(this._topDrawerDivider)
					{
						contentY += this._topDrawerDivider.height;
					}
				}
			}
			else if((isTopDrawerOpen && this._openMode === RelativeDepth.BELOW) || isTopDrawerDocked)
			{
				contentY = topDrawerHeight;
				if(this._topDrawerDivider && isTopDrawerDocked)
				{
					contentY += this._topDrawerDivider.height;
				}
			}
			if(this._content !== null)
			{
				this._content.x = contentX;
				this._content.y = contentY;
				if(this._autoSizeMode !== AutoSizeMode.CONTENT)
				{
					this._content.width = contentWidth;
					this._content.height = contentHeight;

					//final validation to avoid juggler next frame issues
					this._content.validate();
				}
			}

			if(this._topDrawer !== null)
			{
				var topDrawerX:Number = 0;
				var topDrawerY:Number = 0;
				if(isTopDrawerDocked)
				{
					if(isBottomDrawerOpen && this._openMode === RelativeDepth.BELOW)
					{
						topDrawerY -= bottomDrawerHeight;
					}
					if(!isLeftDrawerDocked)
					{
						topDrawerX = contentX;
					}
				}
				else if(this._openMode === RelativeDepth.ABOVE &&
					!this._isTopDrawerOpen)
				{
					topDrawerY -= topDrawerHeight;
				}
				this._topDrawer.x = topDrawerX;
				this._topDrawer.y = topDrawerY;
				this._topDrawer.visible = isTopDrawerOpen || isTopDrawerDocked || this._isDraggingTopDrawer;
				if(this._topDrawerDivider !== null)
				{
					this._topDrawerDivider.visible = isTopDrawerDocked;
					this._topDrawerDivider.x = topDrawerX;
					this._topDrawerDivider.y = topDrawerY + topDrawerHeight;
				}

				//final validation to avoid juggler next frame issues
				this._topDrawer.validate();
			}

			if(this._rightDrawer !== null)
			{
				var rightDrawerX:Number = this.actualWidth - rightDrawerWidth;
				var rightDrawerY:Number = 0;
				if(isRightDrawerDocked)
				{
					rightDrawerX = contentX + contentWidth;
					if(this._rightDrawerDivider)
					{
						rightDrawerX += this._rightDrawerDivider.width;
					}
					rightDrawerY = contentY;
				}
				else if(this._openMode === RelativeDepth.ABOVE &&
					!this._isRightDrawerOpen)
				{
					rightDrawerX += rightDrawerWidth;
				}
				this._rightDrawer.x = rightDrawerX;
				this._rightDrawer.y = rightDrawerY;
				this._rightDrawer.visible = isRightDrawerOpen || isRightDrawerDocked || this._isDraggingRightDrawer;
				if(this._rightDrawerDivider !== null)
				{
					this._rightDrawerDivider.visible = isRightDrawerDocked;
					this._rightDrawerDivider.x = rightDrawerX - this._rightDrawerDivider.width;
					this._rightDrawerDivider.y = rightDrawerY;
				}

				//final validation to avoid juggler next frame issues
				this._rightDrawer.validate();
			}

			if(this._bottomDrawer !== null)
			{
				var bottomDrawerX:Number = 0;
				var bottomDrawerY:Number = this.actualHeight - bottomDrawerHeight;
				if(isBottomDrawerDocked)
				{
					if(!isLeftDrawerDocked)
					{
						bottomDrawerX = contentX;
					}
					bottomDrawerY = contentY + contentHeight;
					if(this._bottomDrawerDivider)
					{
						bottomDrawerY += this._bottomDrawerDivider.height;
					}
				}
				else if(this._openMode === RelativeDepth.ABOVE &&
					!this._isBottomDrawerOpen)
				{
					bottomDrawerY += bottomDrawerHeight;
				}
				this._bottomDrawer.x = bottomDrawerX;
				this._bottomDrawer.y = bottomDrawerY;
				this._bottomDrawer.visible = isBottomDrawerOpen || isBottomDrawerDocked || this._isDraggingBottomDrawer;
				if(this._bottomDrawerDivider !== null)
				{
					this._bottomDrawerDivider.visible = isBottomDrawerDocked;
					this._bottomDrawerDivider.x = bottomDrawerX;
					this._bottomDrawerDivider.y = bottomDrawerY - this._bottomDrawerDivider.height;
				}

				//final validation to avoid juggler next frame issues
				this._bottomDrawer.validate();
			}

			if(this._leftDrawer !== null)
			{
				var leftDrawerX:Number = 0;
				var leftDrawerY:Number = 0;
				if(isLeftDrawerDocked)
				{
					if(isRightDrawerOpen && this._openMode === RelativeDepth.BELOW)
					{
						leftDrawerX -= rightDrawerWidth;
					}
					leftDrawerY = contentY;
				}
				else if(this._openMode === RelativeDepth.ABOVE &&
					!this._isLeftDrawerOpen)
				{
					leftDrawerX -= leftDrawerWidth;
				}
				this._leftDrawer.x = leftDrawerX;
				this._leftDrawer.y = leftDrawerY;
				this._leftDrawer.visible = isLeftDrawerOpen || isLeftDrawerDocked || this._isDraggingLeftDrawer;
				if(this._leftDrawerDivider !== null)
				{
					this._leftDrawerDivider.visible = isLeftDrawerDocked;
					this._leftDrawerDivider.x = leftDrawerX + leftDrawerWidth;
					this._leftDrawerDivider.y = leftDrawerY;
				}

				//final validation to avoid juggler next frame issues
				this._leftDrawer.validate();
			}

			if(this._overlaySkin !== null)
			{
				this.positionOverlaySkin();
				this._overlaySkin.width = this.actualWidth;
				this._overlaySkin.height = this.actualHeight;

				//final validation to avoid juggler next frame issues
				if(this._overlaySkin is IValidating)
				{
					IValidating(this._overlaySkin).validate();
				}
			}
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
			this.prepareTopDrawer();
			if(this._overlaySkin)
			{
				this._overlaySkin.visible = true;
				if(this._isTopDrawerOpen)
				{
					this._overlaySkin.alpha = 0;
				}
				else
				{
					this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
				}
			}
			var targetPosition:Number = this._isTopDrawerOpen ? this._topDrawer.height : 0;
			var duration:Number = this.pendingToggleDuration;
			if(duration !== duration) //isNaN
			{
				duration = this._openOrCloseDuration;
			}
			this.pendingToggleDuration = NaN;
			if(this._openMode === RelativeDepth.ABOVE)
			{
				targetPosition = targetPosition === 0 ? -this._topDrawer.height : 0;
				this._openOrCloseTween = new Tween(this._topDrawer, duration, this._openOrCloseEase);
			}
			else //below
			{
				this._openOrCloseTween = new Tween(this._content, duration, this._openOrCloseEase);
			}
			this._openOrCloseTween.animate("y", targetPosition);
			this._openOrCloseTween.onUpdate = topDrawerOpenOrCloseTween_onUpdate;
			this._openOrCloseTween.onComplete = topDrawerOpenOrCloseTween_onComplete;
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
			this.prepareRightDrawer();
			if(this._overlaySkin)
			{
				this._overlaySkin.visible = true;
				if(this._isRightDrawerOpen)
				{
					this._overlaySkin.alpha = 0;
				}
				else
				{
					this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
				}
			}
			var targetPosition:Number = 0;
			if(this._isRightDrawerOpen)
			{
				targetPosition = -this._rightDrawer.width;
			}
			if(this.isLeftDrawerDocked && this._openMode === RelativeDepth.BELOW)
			{
				targetPosition += this._leftDrawer.width;
				if(this._leftDrawerDivider)
				{
					targetPosition += this._leftDrawerDivider.width;
				}
			}
			var duration:Number = this.pendingToggleDuration;
			if(duration !== duration) //isNaN
			{
				duration = this._openOrCloseDuration;
			}
			this.pendingToggleDuration = NaN;
			if(this._openMode === RelativeDepth.ABOVE)
			{
				this._openOrCloseTween = new Tween(this._rightDrawer, duration, this._openOrCloseEase);
				targetPosition += this.actualWidth;
			}
			else //below
			{
				this._openOrCloseTween = new Tween(this._content, duration, this._openOrCloseEase);
			}
			this._openOrCloseTween.animate("x", targetPosition);
			this._openOrCloseTween.onUpdate = rightDrawerOpenOrCloseTween_onUpdate;
			this._openOrCloseTween.onComplete = rightDrawerOpenOrCloseTween_onComplete;
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
			this.prepareBottomDrawer();
			if(this._overlaySkin)
			{
				this._overlaySkin.visible = true;
				if(this._isBottomDrawerOpen)
				{
					this._overlaySkin.alpha = 0;
				}
				else
				{
					this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
				}
			}
			var targetPosition:Number = 0;
			if(this._isBottomDrawerOpen)
			{
				targetPosition = -this._bottomDrawer.height;
			}
			if(this.isTopDrawerDocked && this._openMode === RelativeDepth.BELOW)
			{
				targetPosition += this._topDrawer.height;
				if(this._topDrawerDivider)
				{
					targetPosition += this._topDrawerDivider.height;
				}
			}
			var duration:Number = this.pendingToggleDuration;
			if(duration !== duration) //isNaN
			{
				duration = this._openOrCloseDuration;
			}
			this.pendingToggleDuration = NaN;
			if(this._openMode === RelativeDepth.ABOVE)
			{
				targetPosition += this.actualHeight;
				this._openOrCloseTween = new Tween(this._bottomDrawer, duration, this._openOrCloseEase);
			}
			else //below
			{
				this._openOrCloseTween = new Tween(this._content, duration, this._openOrCloseEase);
			}
			this._openOrCloseTween.animate("y", targetPosition);
			this._openOrCloseTween.onUpdate = bottomDrawerOpenOrCloseTween_onUpdate;
			this._openOrCloseTween.onComplete = bottomDrawerOpenOrCloseTween_onComplete;
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
			this.prepareLeftDrawer();
			if(this._overlaySkin)
			{
				this._overlaySkin.visible = true;
				if(this._isLeftDrawerOpen)
				{
					this._overlaySkin.alpha = 0;
				}
				else
				{
					this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
				}
			}
			var targetPosition:Number = this._isLeftDrawerOpen ? this._leftDrawer.width : 0;
			var duration:Number = this.pendingToggleDuration;
			if(duration !== duration) //isNaN
			{
				duration = this._openOrCloseDuration;
			}
			this.pendingToggleDuration = NaN;
			if(this._openMode === RelativeDepth.ABOVE)
			{
				targetPosition = targetPosition === 0 ? -this._leftDrawer.width : 0;
				this._openOrCloseTween = new Tween(this._leftDrawer, duration, this._openOrCloseEase);
			}
			else //below
			{
				this._openOrCloseTween = new Tween(this._content, duration, this._openOrCloseEase);
			}
			this._openOrCloseTween.animate("x", targetPosition);
			this._openOrCloseTween.onUpdate = leftDrawerOpenOrCloseTween_onUpdate;
			this._openOrCloseTween.onComplete = leftDrawerOpenOrCloseTween_onComplete;
			Starling.juggler.add(this._openOrCloseTween);
		}

		/**
		 * @private
		 */
		protected function prepareTopDrawer():void
		{
			this._topDrawer.visible = true;
			if(this._openMode === RelativeDepth.ABOVE)
			{
				if(this._overlaySkin)
				{
					this.setChildIndex(this._overlaySkin, this.numChildren - 1);
				}
				this.setChildIndex(DisplayObject(this._topDrawer), this.numChildren - 1);
			}
			if(!this._clipDrawers || this._openMode !== RelativeDepth.BELOW)
			{
				return;
			}
			if(this._topDrawer.mask === null)
			{
				var mask:Quad = new Quad(1, 1, 0xff00ff);
				//the initial dimensions cannot be 0 or there's a runtime error,
				//and these values might be 0
				mask.width = this.actualWidth;
				mask.height = this._content.y;
				this._topDrawer.mask = mask;
			}
		}

		/**
		 * @private
		 */
		protected function prepareRightDrawer():void
		{
			this._rightDrawer.visible = true;
			if(this._openMode === RelativeDepth.ABOVE)
			{
				if(this._overlaySkin)
				{
					this.setChildIndex(this._overlaySkin, this.numChildren - 1);
				}
				this.setChildIndex(DisplayObject(this._rightDrawer), this.numChildren - 1);
			}
			if(!this._clipDrawers || this._openMode !== RelativeDepth.BELOW)
			{
				return;
			}
			if(this._rightDrawer.mask === null)
			{
				var mask:Quad = new Quad(1, 1, 0xff00ff);
				//the initial dimensions cannot be 0 or there's a runtime error,
				//and these values might be 0
				if(this.isLeftDrawerDocked)
				{
					mask.width = -this._leftDrawer.x;
				}
				else
				{
					mask.width = -this._content.x;
				}
				mask.height = this.actualHeight;
				this._rightDrawer.mask = mask;
			}
		}

		/**
		 * @private
		 */
		protected function prepareBottomDrawer():void
		{
			this._bottomDrawer.visible = true;
			if(this._openMode === RelativeDepth.ABOVE)
			{
				if(this._overlaySkin)
				{
					this.setChildIndex(this._overlaySkin, this.numChildren - 1);
				}
				this.setChildIndex(DisplayObject(this._bottomDrawer), this.numChildren - 1);
			}
			if(!this._clipDrawers || this._openMode !== RelativeDepth.BELOW)
			{
				return;
			}
			if(this._bottomDrawer.mask === null)
			{
				var mask:Quad = new Quad(1, 1, 0xff00ff);
				//the initial dimensions cannot be 0 or there's a runtime error,
				//and these values might be 0
				mask.width = this.actualWidth;
				if(this.isTopDrawerDocked)
				{
					mask.height = -this._topDrawer.y;
				}
				else
				{
					mask.height = -this._content.y;
				}
				this._bottomDrawer.mask = mask;
			}
		}

		/**
		 * @private
		 */
		protected function prepareLeftDrawer():void
		{
			this._leftDrawer.visible = true;
			if(this._openMode === RelativeDepth.ABOVE)
			{
				if(this._overlaySkin)
				{
					this.setChildIndex(this._overlaySkin, this.numChildren - 1);
				}
				this.setChildIndex(DisplayObject(this._leftDrawer), this.numChildren - 1);
			}
			if(!this._clipDrawers || this._openMode !== RelativeDepth.BELOW)
			{
				return;
			}
			if(this._leftDrawer.mask === null)
			{
				var mask:Quad = new Quad(1, 1, 0xff00ff);
				//the initial dimensions cannot be 0 or there's a runtime error,
				//and these values might be 0
				mask.width = this._content.x;
				mask.height = this.actualHeight;
				this._leftDrawer.mask = mask;
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
			if(this._contentEventDispatcherFunction !== null)
			{
				return this._contentEventDispatcherFunction(this._content) as EventDispatcher;
			}
			else if(this._contentEventDispatcherField !== null && this._content && (this._contentEventDispatcherField in this._content))
			{
				return this._content[this._contentEventDispatcherField] as EventDispatcher;
			}
			return this._content as EventDispatcher;
		}

		/**
		 * @private
		 */
		protected function refreshCurrentEventTarget():void
		{
			if(this.contentEventDispatcher)
			{
				if(this._topDrawerToggleEventType)
				{
					this.contentEventDispatcher.removeEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
				}
				if(this._rightDrawerToggleEventType)
				{
					this.contentEventDispatcher.removeEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
				}
				if(this._bottomDrawerToggleEventType)
				{
					this.contentEventDispatcher.removeEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
				}
				if(this._leftDrawerToggleEventType)
				{
					this.contentEventDispatcher.removeEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
				}
			}
			this.contentEventDispatcher = this.contentToContentEventDispatcher();
			if(this.contentEventDispatcher)
			{
				if(this._topDrawerToggleEventType)
				{
					this.contentEventDispatcher.addEventListener(this._topDrawerToggleEventType, content_topDrawerToggleEventTypeHandler);
				}
				if(this._rightDrawerToggleEventType)
				{
					this.contentEventDispatcher.addEventListener(this._rightDrawerToggleEventType, content_rightDrawerToggleEventTypeHandler);
				}
				if(this._bottomDrawerToggleEventType)
				{
					this.contentEventDispatcher.addEventListener(this._bottomDrawerToggleEventType, content_bottomDrawerToggleEventTypeHandler);
				}
				if(this._leftDrawerToggleEventType)
				{
					this.contentEventDispatcher.addEventListener(this._leftDrawerToggleEventType, content_leftDrawerToggleEventTypeHandler);
				}
			}
		}

		/**
		 * @private
		 */
		protected function refreshDrawerStates():void
		{
			if(this.isTopDrawerDocked && this._isTopDrawerOpen)
			{
				this._isTopDrawerOpen = false;
			}
			if(this.isRightDrawerDocked && this._isRightDrawerOpen)
			{
				this._isRightDrawerOpen = false;
			}
			if(this.isBottomDrawerDocked && this._isBottomDrawerOpen)
			{
				this._isBottomDrawerOpen = false;
			}
			if(this.isLeftDrawerDocked && this._isLeftDrawerOpen)
			{
				this._isLeftDrawerOpen = false;
			}
		}

		/**
		 * @private
		 */
		protected function refreshOverlayState():void
		{
			if(!this._overlaySkin || this._isDragging)
			{
				return;
			}
			var showOverlay:Boolean = (this._isTopDrawerOpen && !this.isTopDrawerDocked) ||
				(this._isRightDrawerOpen && !this.isRightDrawerDocked) ||
				(this._isBottomDrawerOpen && !this.isBottomDrawerDocked) ||
				(this._isLeftDrawerOpen && !this.isLeftDrawerDocked);
			if(showOverlay !== this._overlaySkin.visible)
			{
				this._overlaySkin.visible = showOverlay;
				this._overlaySkin.alpha = showOverlay ? this._overlaySkinOriginalAlpha : 0;
			}
		}

		/**
		 * @private
		 */
		protected function handleTapToClose(touch:Touch):void
		{
			touch.getLocation(this.stage, HELPER_POINT);
			if(this !== this.stage.hitTest(HELPER_POINT))
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
		protected function handleTouchBegan(touch:Touch):void
		{
			var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
			if(exclusiveTouch.getClaim(touch.id))
			{
				//already claimed
				return;
			}

			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			touch.getLocation(this, HELPER_POINT);
			var localX:Number = HELPER_POINT.x;
			var localY:Number = HELPER_POINT.y;
			if(!this.isTopDrawerOpen && !this.isRightDrawerOpen && !this.isBottomDrawerOpen && !this.isLeftDrawerOpen)
			{
				if(this._openGesture === DragGesture.NONE)
				{
					return;
				}
				if(this._openGesture === DragGesture.EDGE)
				{
					var isNearAnyEdge:Boolean = false;
					if(this._topDrawer && !this.isTopDrawerDocked)
					{
						var topInches:Number = localY / (DeviceCapabilities.dpi / starling.contentScaleFactor);
						if(topInches >= 0 && topInches <= this._openGestureEdgeSize)
						{
							isNearAnyEdge = true;
						}
					}
					if(!isNearAnyEdge)
					{
						if(this._rightDrawer && !this.isRightDrawerDocked)
						{
							var rightInches:Number = (this.actualWidth - localX) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
							if(rightInches >= 0 && rightInches <= this._openGestureEdgeSize)
							{
								isNearAnyEdge = true;
							}
						}
						if(!isNearAnyEdge)
						{
							if(this._bottomDrawer && !this.isBottomDrawerDocked)
							{
								var bottomInches:Number = (this.actualHeight - localY) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
								if(bottomInches >= 0 && bottomInches <= this._openGestureEdgeSize)
								{
									isNearAnyEdge = true;
								}
							}
							if(!isNearAnyEdge)
							{
								if(this._leftDrawer && !this.isLeftDrawerDocked)
								{
									var leftInches:Number = localX / (DeviceCapabilities.dpi / starling.contentScaleFactor);
									if(leftInches >= 0 && leftInches <= this._openGestureEdgeSize)
									{
										isNearAnyEdge = true;
									}
								}
							}
						}
					}
					if(!isNearAnyEdge)
					{
						return;
					}
				}
			}
			else if(this._openMode === RelativeDepth.BELOW && touch.target !== this)
			{
				//when the drawer is opened below, it will only close when
				//something outside of the drawer is touched
				return;
			}
			//when the drawer is opened above, anything may be touched

			this.touchPointID = touch.id;
			this._velocityX = 0;
			this._velocityY = 0;
			this._previousVelocityX.length = 0;
			this._previousVelocityY.length = 0;
			this._previousTouchTime = getTimer();
			this._previousTouchX = this._startTouchX = this._currentTouchX = localX;
			this._previousTouchY = this._startTouchY = this._currentTouchY = localY;
			this._isDragging = false;
			this._isDraggingTopDrawer = false;
			this._isDraggingRightDrawer = false;
			this._isDraggingBottomDrawer = false;
			this._isDraggingLeftDrawer = false;

			exclusiveTouch.addEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
		}

		/**
		 * @private
		 */
		protected function handleTouchMoved(touch:Touch):void
		{
			touch.getLocation(this, HELPER_POINT);
			this._currentTouchX = HELPER_POINT.x;
			this._currentTouchY = HELPER_POINT.y;
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
		protected function handleDragEnd():void
		{
			//take the average for more accuracy
			var sum:Number = this._velocityX * CURRENT_VELOCITY_WEIGHT;
			var velocityCount:int = this._previousVelocityX.length;
			var totalWeight:Number = CURRENT_VELOCITY_WEIGHT;
			for(var i:int = 0; i < velocityCount; i++)
			{
				var weight:Number = VELOCITY_WEIGHTS[i];
				sum += this._previousVelocityX.shift() * weight;
				totalWeight += weight;
			}

			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var inchesPerSecondX:Number = 1000 * (sum / totalWeight) / (DeviceCapabilities.dpi / starling.contentScaleFactor);

			sum = this._velocityY * CURRENT_VELOCITY_WEIGHT;
			velocityCount = this._previousVelocityY.length;
			totalWeight = CURRENT_VELOCITY_WEIGHT;
			for(i = 0; i < velocityCount; i++)
			{
				weight = VELOCITY_WEIGHTS[i];
				sum += this._previousVelocityY.shift() * weight;
				totalWeight += weight;
			}
			var inchesPerSecondY:Number = 1000 * (sum / totalWeight) / (DeviceCapabilities.dpi / starling.contentScaleFactor);

			this._isDragging = false;
			if(this._isDraggingTopDrawer)
			{
				this._isDraggingTopDrawer = false;
				if(!this._isTopDrawerOpen && inchesPerSecondY > this._minimumDrawerThrowVelocity)
				{
					this._isTopDrawerOpen = true;
				}
				else if(this._isTopDrawerOpen && inchesPerSecondY < -this._minimumDrawerThrowVelocity)
				{
					this._isTopDrawerOpen = false;
				}
				else if(this._openMode === RelativeDepth.ABOVE)
				{
					this._isTopDrawerOpen = roundToNearest(this._topDrawer.y, this._topDrawer.height) == 0;
				}
				else //below
				{
					this._isTopDrawerOpen = roundToNearest(this._content.y, this._topDrawer.height) != 0;
				}
				this.openOrCloseTopDrawer();
			}
			else if(this._isDraggingRightDrawer)
			{
				this._isDraggingRightDrawer = false;
				if(!this._isRightDrawerOpen && inchesPerSecondX < -this._minimumDrawerThrowVelocity)
				{
					this._isRightDrawerOpen = true;
				}
				else if(this._isRightDrawerOpen && inchesPerSecondX > this._minimumDrawerThrowVelocity)
				{
					this._isRightDrawerOpen = false;
				}
				else if(this._openMode === RelativeDepth.ABOVE)
				{
					this._isRightDrawerOpen = roundToNearest(this.actualWidth - this._rightDrawer.x, this._rightDrawer.width) != 0;
				}
				else //bottom
				{
					var positionToCheck:Number = this._content.x;
					if(this.isLeftDrawerDocked)
					{
						positionToCheck -= this._leftDrawer.width;
					}
					this._isRightDrawerOpen = roundToNearest(positionToCheck, this._rightDrawer.width) != 0;
				}
				this.openOrCloseRightDrawer();
			}
			else if(this._isDraggingBottomDrawer)
			{
				this._isDraggingBottomDrawer = false;
				if(!this._isBottomDrawerOpen && inchesPerSecondY < -this._minimumDrawerThrowVelocity)
				{
					this._isBottomDrawerOpen = true;
				}
				else if(this._isBottomDrawerOpen && inchesPerSecondY > this._minimumDrawerThrowVelocity)
				{
					this._isBottomDrawerOpen = false;
				}
				else if(this._openMode === RelativeDepth.ABOVE)
				{
					this._isBottomDrawerOpen = roundToNearest(this.actualHeight - this._bottomDrawer.y, this._bottomDrawer.height) != 0;
				}
				else //below
				{
					positionToCheck = this._content.y;
					if(this.isTopDrawerDocked)
					{
						positionToCheck -= this._topDrawer.height;
					}
					this._isBottomDrawerOpen = roundToNearest(positionToCheck, this._bottomDrawer.height) != 0;
				}
				this.openOrCloseBottomDrawer();
			}
			else if(this._isDraggingLeftDrawer)
			{
				this._isDraggingLeftDrawer = false;
				if(!this._isLeftDrawerOpen && inchesPerSecondX > this._minimumDrawerThrowVelocity)
				{
					this._isLeftDrawerOpen = true;
				}
				else if(this._isLeftDrawerOpen && inchesPerSecondX < -this._minimumDrawerThrowVelocity)
				{
					this._isLeftDrawerOpen = false;
				}
				else if(this._openMode === RelativeDepth.ABOVE)
				{
					this._isLeftDrawerOpen = roundToNearest(this._leftDrawer.x, this._leftDrawer.width) == 0;
				}
				else //below
				{
					this._isLeftDrawerOpen = roundToNearest(this._content.x, this._leftDrawer.width) != 0;
				}
				this.openOrCloseLeftDrawer();
			}
		}

		/**
		 * @private
		 */
		protected function handleDragMove():void
		{
			var contentX:Number = 0;
			var contentY:Number = 0;
			if(this.isLeftDrawerDocked)
			{
				contentX = this._leftDrawer.width;
				if(this._leftDrawerDivider !== null)
				{
					contentX += this._leftDrawerDivider.width;
				}
			}
			if(this.isTopDrawerDocked)
			{
				contentY = this._topDrawer.height;
				if(this._topDrawerDivider !== null)
				{
					contentY += this._topDrawerDivider.height;
				}
			}
			if(this._isDraggingLeftDrawer)
			{
				var leftDrawerWidth:Number = this._leftDrawer.width;
				if(this.isLeftDrawerOpen)
				{
					contentX = leftDrawerWidth + this._currentTouchX - this._startTouchX;
				}
				else
				{
					contentX = this._currentTouchX - this._startTouchX;
				}
				if(contentX < 0)
				{
					contentX = 0;
				}
				if(contentX > leftDrawerWidth)
				{
					contentX = leftDrawerWidth;
				}
			}
			else if(this._isDraggingRightDrawer)
			{
				var rightDrawerWidth:Number = this._rightDrawer.width;
				if(this.isRightDrawerOpen)
				{
					contentX = -rightDrawerWidth + this._currentTouchX - this._startTouchX;
				}
				else
				{
					contentX = this._currentTouchX - this._startTouchX;
				}
				if(contentX < -rightDrawerWidth)
				{
					contentX = -rightDrawerWidth;
				}
				if(contentX > 0)
				{
					contentX = 0;
				}
				if(this.isLeftDrawerDocked && this._openMode === RelativeDepth.BELOW)
				{
					contentX += this._leftDrawer.width;
					if(this._leftDrawerDivider !== null)
					{
						contentX += this._leftDrawerDivider.width;
					}
				}
			}
			else if(this._isDraggingTopDrawer)
			{
				var topDrawerHeight:Number = this._topDrawer.height;
				if(this.isTopDrawerOpen)
				{
					contentY = topDrawerHeight + this._currentTouchY - this._startTouchY;
				}
				else
				{
					contentY = this._currentTouchY - this._startTouchY;
				}
				if(contentY < 0)
				{
					contentY = 0;
				}
				if(contentY > topDrawerHeight)
				{
					contentY = topDrawerHeight;
				}
			}
			else if(this._isDraggingBottomDrawer)
			{
				var bottomDrawerHeight:Number = this._bottomDrawer.height;
				if(this.isBottomDrawerOpen)
				{
					contentY = -bottomDrawerHeight + this._currentTouchY - this._startTouchY;
				}
				else
				{
					contentY = this._currentTouchY - this._startTouchY;
				}
				if(contentY < -bottomDrawerHeight)
				{
					contentY = -bottomDrawerHeight;
				}
				if(contentY > 0)
				{
					contentY = 0;
				}
				if(this.isTopDrawerDocked && this._openMode === RelativeDepth.BELOW)
				{
					contentY += this._topDrawer.height;
					if(this._topDrawerDivider !== null)
					{
						contentY += this._topDrawerDivider.height;
					}
				}
			}
			if(this._openMode === RelativeDepth.ABOVE)
			{
				if(this._isDraggingTopDrawer)
				{
					this._topDrawer.y = contentY - this._topDrawer.height;
				}
				else if(this._isDraggingRightDrawer)
				{
					this._rightDrawer.x = this.actualWidth + contentX;
				}
				else if(this._isDraggingBottomDrawer)
				{
					this._bottomDrawer.y = this.actualHeight + contentY;
				}
				else if(this._isDraggingLeftDrawer)
				{
					this._leftDrawer.x = contentX - this._leftDrawer.width;
				}
			}
			else //below
			{
				this._content.x = contentX;
				this._content.y = contentY;
			}
			if(this._isDraggingTopDrawer)
			{
				this.topDrawerOpenOrCloseTween_onUpdate();
			}
			else if(this._isDraggingRightDrawer)
			{
				this.rightDrawerOpenOrCloseTween_onUpdate();
			}
			else if(this._isDraggingBottomDrawer)
			{
				this.bottomDrawerOpenOrCloseTween_onUpdate();
			}
			else if(this._isDraggingLeftDrawer)
			{
				this.leftDrawerOpenOrCloseTween_onUpdate();
			}
		}

		/**
		 * @private
		 */
		protected function checkForDragToClose():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var horizontalInchesMoved:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			var verticalInchesMoved:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			if(this.isLeftDrawerOpen && horizontalInchesMoved <= -this._minimumDragDistance)
			{
				this._isDragging = true;
				this._isDraggingLeftDrawer = true;
				this.prepareLeftDrawer();
			}
			else if(this.isRightDrawerOpen && horizontalInchesMoved >= this._minimumDragDistance)
			{
				this._isDragging = true;
				this._isDraggingRightDrawer = true;
				this.prepareRightDrawer();
			}
			else if(this.isTopDrawerOpen && verticalInchesMoved <= -this._minimumDragDistance)
			{
				this._isDragging = true;
				this._isDraggingTopDrawer = true;
				this.prepareTopDrawer();
			}
			else if(this.isBottomDrawerOpen && verticalInchesMoved >= this._minimumDragDistance)
			{
				this._isDragging = true;
				this._isDraggingBottomDrawer = true;
				this.prepareBottomDrawer();
			}

			if(this._isDragging)
			{
				if(this._overlaySkin)
				{
					this._overlaySkin.visible = true;
					this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
				}
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
		protected function checkForDragToOpen():void
		{
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			var horizontalInchesMoved:Number = (this._currentTouchX - this._startTouchX) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			var verticalInchesMoved:Number = (this._currentTouchY - this._startTouchY) / (DeviceCapabilities.dpi / starling.contentScaleFactor);
			if(this._leftDrawer && !this.isLeftDrawerDocked && horizontalInchesMoved >= this._minimumDragDistance)
			{
				this._isDragging = true;
				this._isDraggingLeftDrawer = true;
				this.prepareLeftDrawer();
			}
			else if(this._rightDrawer && !this.isRightDrawerDocked && horizontalInchesMoved <= -this._minimumDragDistance)
			{
				this._isDragging = true;
				this._isDraggingRightDrawer = true;
				this.prepareRightDrawer();
			}
			else if(this._topDrawer && !this.isTopDrawerDocked && verticalInchesMoved >= this._minimumDragDistance)
			{
				this._isDragging = true;
				this._isDraggingTopDrawer = true;
				this.prepareTopDrawer();
			}
			else if(this._bottomDrawer && !this.isBottomDrawerDocked && verticalInchesMoved <= -this._minimumDragDistance)
			{
				this._isDragging = true;
				this._isDraggingBottomDrawer = true;
				this.prepareBottomDrawer();
			}

			if(this._isDragging)
			{
				if(this._overlaySkin)
				{
					this._overlaySkin.visible = true;
					this._overlaySkin.alpha = 0;
				}
				this._startTouchX = this._currentTouchX;
				this._startTouchY = this._currentTouchY;
				var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
				exclusiveTouch.claimTouch(this.touchPointID, this);
				exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
				this.dispatchEventWith(FeathersEventType.BEGIN_INTERACTION);
			}
		}

		/**
		 * @private
		 */
		protected function positionOverlaySkin():void
		{
			if(this._overlaySkin === null)
			{
				return;
			}

			if(this.isLeftDrawerDocked)
			{
				this._overlaySkin.x = this._leftDrawer.x;
			}
			else if(this._openMode === RelativeDepth.ABOVE && this._leftDrawer)
			{
				this._overlaySkin.x = this._leftDrawer.x + this._leftDrawer.width;
			}
			else //below or no left drawer
			{
				if(this._content !== null)
				{
					this._overlaySkin.x = this._content.x;
				}
				else
				{
					this._overlaySkin.x = 0;
				}
			}

			if(this.isTopDrawerDocked)
			{
				this._overlaySkin.y = this._topDrawer.y;
			}
			else if(this._openMode === RelativeDepth.ABOVE && this._topDrawer)
			{
				this._overlaySkin.y = this._topDrawer.y + this._topDrawer.height;
			}
			else //below or now top drawer
			{
				if(this._content !== null)
				{
					this._overlaySkin.y = this._content.y;
				}
				else
				{
					this._overlaySkin.y = 0;
				}
			}
		}

		/**
		 * @private
		 */
		protected function topDrawerOpenOrCloseTween_onUpdate():void
		{
			if(this._overlaySkin)
			{
				if(this._openMode === RelativeDepth.ABOVE)
				{
					var ratio:Number = 1 + this._topDrawer.y / this._topDrawer.height;
				}
				else //below
				{
					ratio = this._content.y / this._topDrawer.height;
				}
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * ratio;
			}
			this.openOrCloseTween_onUpdate();
		}

		/**
		 * @private
		 */
		protected function rightDrawerOpenOrCloseTween_onUpdate():void
		{
			if(this._overlaySkin)
			{
				if(this._openMode === RelativeDepth.ABOVE)
				{
					var ratio:Number = -(this._rightDrawer.x - this.actualWidth) / this._rightDrawer.width;
				}
				else //below
				{
					ratio = (this.actualWidth - this._content.x - this._content.width) / this._rightDrawer.width;
				}
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * ratio;
			}
			this.openOrCloseTween_onUpdate();
		}

		/**
		 * @private
		 */
		protected function bottomDrawerOpenOrCloseTween_onUpdate():void
		{
			if(this._overlaySkin)
			{
				if(this._openMode === RelativeDepth.ABOVE)
				{
					var ratio:Number = -(this._bottomDrawer.y - this.actualHeight) / this._bottomDrawer.height;
				}
				else //below
				{
					ratio = (this.actualHeight - this._content.y - this._content.height) / this._bottomDrawer.height;
				}
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * ratio;
			}
			this.openOrCloseTween_onUpdate();
		}

		/**
		 * @private
		 */
		protected function leftDrawerOpenOrCloseTween_onUpdate():void
		{
			if(this._overlaySkin)
			{
				if(this._openMode === RelativeDepth.ABOVE)
				{
					var ratio:Number = 1 + this._leftDrawer.x / this._leftDrawer.width;
				}
				else //below
				{
					ratio = this._content.x / this._leftDrawer.width;
				}
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha * ratio;
			}
			this.openOrCloseTween_onUpdate();
		}

		/**
		 * @private
		 */
		protected function openOrCloseTween_onUpdate():void
		{
			if(this._clipDrawers && this._openMode === RelativeDepth.BELOW)
			{
				var isTopDrawerDocked:Boolean = this.isTopDrawerDocked;
				var isRightDrawerDocked:Boolean = this.isRightDrawerDocked;
				var isBottomDrawerDocked:Boolean = this.isBottomDrawerDocked;
				var isLeftDrawerDocked:Boolean = this.isLeftDrawerDocked;
				var contentX:Number = this._content.x;
				var contentY:Number = this._content.y;
				if(isTopDrawerDocked)
				{
					if(isLeftDrawerDocked)
					{
						var leftDrawerDockedWidth:Number = this._leftDrawer.width;
						if(this._leftDrawerDivider !== null)
						{
							leftDrawerDockedWidth += this._leftDrawerDivider.width;
						}
						this._topDrawer.x = contentX - leftDrawerDockedWidth;
					}
					else
					{
						this._topDrawer.x = contentX;
					}
					if(this._topDrawerDivider !== null)
					{
						this._topDrawerDivider.x = this._topDrawer.x;
						this._topDrawerDivider.y = contentY - this._topDrawerDivider.height;
						this._topDrawer.y = this._topDrawerDivider.y - this._topDrawer.height;
					}
					else
					{
						this._topDrawer.y = contentY - this._topDrawer.height;
					}
				}
				if(isRightDrawerDocked)
				{
					if(this._rightDrawerDivider !== null)
					{
						this._rightDrawerDivider.x = contentX + this._content.width;
						this._rightDrawer.x = this._rightDrawerDivider.x + this._rightDrawerDivider.width;
						this._rightDrawerDivider.y = contentY;
					}
					else
					{
						this._rightDrawer.x = contentX + this._content.width;
					}
					this._rightDrawer.y = contentY;
				}
				if(isBottomDrawerDocked)
				{
					if(isLeftDrawerDocked)
					{
						leftDrawerDockedWidth = this._leftDrawer.width;
						if(this._leftDrawerDivider !== null)
						{
							leftDrawerDockedWidth += this._leftDrawerDivider.width;
						}
						this._bottomDrawer.x = contentX - leftDrawerDockedWidth;
					}
					else
					{
						this._bottomDrawer.x = contentX;
					}
					if(this._bottomDrawerDivider !== null)
					{
						this._bottomDrawerDivider.x = this._bottomDrawer.x;
						this._bottomDrawerDivider.y = contentY + this._content.height;
						this._bottomDrawer.y = this._bottomDrawerDivider.y + this._bottomDrawerDivider.height;
					}
					else
					{
						this._bottomDrawer.y = contentY + this._content.height;
					}
				}
				if(isLeftDrawerDocked)
				{
					if(this._leftDrawerDivider !== null)
					{
						this._leftDrawerDivider.x = contentX - this._leftDrawerDivider.width;
						this._leftDrawer.x = this._leftDrawerDivider.x - this._leftDrawer.width;
						this._leftDrawerDivider.y = contentY;
					}
					else
					{
						this._leftDrawer.x = contentX - this._leftDrawer.width;
					}
					this._leftDrawer.y = contentY;
				}
				if(this._topDrawer !== null)
				{
					var mask:Quad = this._topDrawer.mask as Quad;
					if(mask !== null)
					{
						mask.height = contentY;
					}
				}
				if(this._rightDrawer !== null)
				{
					mask = this._rightDrawer.mask as Quad;
					if(mask !== null)
					{
						var rightClipWidth:Number = -contentX;
						if(isLeftDrawerDocked)
						{
							rightClipWidth = -this._leftDrawer.x;
						}
						mask.x = this._rightDrawer.width - rightClipWidth;
						mask.width = rightClipWidth;
					}
				}
				if(this._bottomDrawer !== null)
				{
					mask = this._bottomDrawer.mask as Quad;
					if(mask !== null)
					{
						var bottomClipHeight:Number = -contentY;
						if(isTopDrawerDocked)
						{
							bottomClipHeight = -this._topDrawer.y;
						}
						mask.y = this._bottomDrawer.height - bottomClipHeight;
						mask.height = bottomClipHeight;
					}
				}
				if(this._leftDrawer !== null)
				{
					mask = this._leftDrawer.mask as Quad;
					if(mask !== null)
					{
						mask.width = contentX;
					}
				}
			}

			if(this._overlaySkin !== null)
			{
				this.positionOverlaySkin();
			}
		}

		/**
		 * @private
		 */
		protected function topDrawerOpenOrCloseTween_onComplete():void
		{
			if(this._overlaySkin)
			{
				this._overlaySkin.alpha = this._overlaySkinOriginalAlpha;
			}
			this._openOrCloseTween = null;
			this._topDrawer.mask = null;
			var isTopDrawerOpen:Boolean = this.isTopDrawerOpen;
			var isTopDrawerDocked:Boolean = this.isTopDrawerDocked;
			this._topDrawer.visible = isTopDrawerOpen || isTopDrawerDocked;
			if(this._overlaySkin)
			{
				this._overlaySkin.visible = isTopDrawerOpen;
			}
			if(isTopDrawerOpen)
			{
				this.dispatchEventWith(Event.OPEN, false, this._topDrawer);
			}
			else
			{
				this.dispatchEventWith(Event.CLOSE, false, this._topDrawer);
			}
		}

		/**
		 * @private
		 */
		protected function rightDrawerOpenOrCloseTween_onComplete():void
		{
			this._openOrCloseTween = null;
			this._rightDrawer.mask = null;
			var isRightDrawerOpen:Boolean = this.isRightDrawerOpen;
			var isRightDrawerDocked:Boolean = this.isRightDrawerDocked;
			this._rightDrawer.visible = isRightDrawerOpen || isRightDrawerDocked;
			if(this._overlaySkin)
			{
				this._overlaySkin.visible = isRightDrawerOpen;
			}
			if(isRightDrawerOpen)
			{
				this.dispatchEventWith(Event.OPEN, false, this._rightDrawer);
			}
			else
			{
				this.dispatchEventWith(Event.CLOSE, false, this._rightDrawer);
			}
		}

		/**
		 * @private
		 */
		protected function bottomDrawerOpenOrCloseTween_onComplete():void
		{
			this._openOrCloseTween = null;
			this._bottomDrawer.mask = null;
			var isBottomDrawerOpen:Boolean = this.isBottomDrawerOpen;
			var isBottomDrawerDocked:Boolean = this.isBottomDrawerDocked;
			this._bottomDrawer.visible = isBottomDrawerOpen || isBottomDrawerDocked;
			if(this._overlaySkin)
			{
				this._overlaySkin.visible = isBottomDrawerOpen;
			}
			if(isBottomDrawerOpen)
			{
				this.dispatchEventWith(Event.OPEN, false, this._bottomDrawer);
			}
			else
			{
				this.dispatchEventWith(Event.CLOSE, false, this._bottomDrawer);
			}
		}

		/**
		 * @private
		 */
		protected function leftDrawerOpenOrCloseTween_onComplete():void
		{
			this._openOrCloseTween = null;
			this._leftDrawer.mask = null;
			var isLeftDrawerOpen:Boolean = this.isLeftDrawerOpen;
			var isLeftDrawerDocked:Boolean = this.isLeftDrawerDocked;
			this._leftDrawer.visible = isLeftDrawerOpen || isLeftDrawerDocked;
			if(this._overlaySkin)
			{
				this._overlaySkin.visible = isLeftDrawerOpen;
			}
			if(isLeftDrawerOpen)
			{
				this.dispatchEventWith(Event.OPEN, false, this._leftDrawer);
			}
			else
			{
				this.dispatchEventWith(Event.CLOSE, false, this._leftDrawer);
			}
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
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			starling.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, drawers_nativeStage_keyDownHandler, false, priority, true);
		}

		/**
		 * @private
		 */
		protected function drawers_removedFromStageHandler(event:Event):void
		{
			if(this.touchPointID >= 0)
			{
				var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);
				exclusiveTouch.removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
			}
			this.touchPointID = -1;
			this._isDragging = false;
			this._isDraggingTopDrawer = false;
			this._isDraggingRightDrawer = false;
			this._isDraggingBottomDrawer = false;
			this._isDraggingLeftDrawer = false;
			this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
			starling.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, drawers_nativeStage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function drawers_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || this._openOrCloseTween)
			{
				this.touchPointID = -1;
				return;
			}
			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, null, this.touchPointID);
				if(!touch)
				{
					return;
				}
				if(touch.phase == TouchPhase.MOVED)
				{
					this.handleTouchMoved(touch);

					if(!this._isDragging)
					{
						if(this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen)
						{
							this.checkForDragToClose();
						}
						else
						{
							this.checkForDragToOpen();
						}
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
					else
					{
						ExclusiveTouch.forStage(this.stage).removeEventListener(Event.CHANGE, exclusiveTouch_changeHandler);
						if(this.isTopDrawerOpen || this.isRightDrawerOpen || this.isBottomDrawerOpen || this.isLeftDrawerOpen)
						{
							//there is no drag, so we may have a tap
							this.handleTapToClose(touch);
						}
					}

				}
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(!touch)
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
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
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
		protected function content_resizeHandler(event:Event):void
		{
			if(this._isValidating || this._autoSizeMode != AutoSizeMode.CONTENT)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected function drawer_resizeHandler(event:Event):void
		{
			if(this._isValidating)
			{
				return;
			}
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
	}
}
