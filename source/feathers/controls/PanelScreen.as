/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.skins.IStyleProvider;
	import feathers.utils.display.getDisplayObjectDepthFromStage;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.events.Event;

	/**
	 * Dispatched when the transition animation begins as the screen is shown
	 * by the screen navigator.
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
	 * @eventType feathers.events.FeathersEventType.TRANSITION_IN_START
	 */
	[Event(name="transitionInStart",type="starling.events.Event")]

	/**
	 * Dispatched when the transition animation finishes as the screen is shown
	 * by the screen navigator.
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
	 * @eventType feathers.events.FeathersEventType.TRANSITION_IN_COMPLETE
	 */
	[Event(name="transitionInComplete",type="starling.events.Event")]

	/**
	 * Dispatched when the transition animation begins as a different screen is
	 * shown by the screen navigator and this screen is hidden.
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
	 * @eventType feathers.events.FeathersEventType.TRANSITION_OUT_START
	 */
	[Event(name="transitionOutStart",type="starling.events.Event")]

	/**
	 * Dispatched when the transition animation finishes as a different screen
	 * is shown by the screen navigator and this screen is hidden.
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
	 * @eventType feathers.events.FeathersEventType.TRANSITION_OUT_COMPLETE
	 */
	[Event(name="transitionOutComplete",type="starling.events.Event")]

	/**
	 * A screen for use with <code>ScreenNavigator</code>, based on <code>Panel</code>
	 * in order to provide a header and layout.
	 *
	 * <p>This component is generally not instantiated directly. Instead it is
	 * typically used as a super class for concrete implementations of screens.
	 * With that in mind, no code example is included here.</p>
	 *
	 * <p>The following example provides a basic framework for a new panel screen:</p>
	 *
	 * <listing version="3.0">
	 * package
	 * {
	 *     import feathers.controls.PanelScreen;
	 *     
	 *     public class CustomScreen extends PanelScreen
	 *     {
	 *         public function CustomScreen()
	 *         {
	 *             super();
	 *         }
	 *         
	 *         override protected function initialize():void
	 *         {
	 *             //runs once when screen is first added to the stage
	 *             //a good place to add children and customize the layout
	 *             
	 *             //don't forget to call this!
	 *             super.initialize()
	 *         }
	 *     }
	 * }</listing>
	 *
	 * @see ../../../panel-screen.html How to use the Feathers PanelScreen component
	 * @see feathers.controls.StackScreenNavigator
	 * @see feathers.controls.ScreenNavigator
	 */
	public class PanelScreen extends Panel implements IScreen
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the header.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_HEADER:String = "feathers-panel-screen-header";

		/**
		 * DEPRECATED: Replaced by <code>PanelScreen.DEFAULT_CHILD_STYLE_NAME_HEADER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see PanelScreen#DEFAULT_CHILD_STYLE_NAME_HEADER
		 */
		public static const DEFAULT_CHILD_NAME_HEADER:String = DEFAULT_CHILD_STYLE_NAME_HEADER;

		/**
		 * The default value added to the <code>styleNameList</code> of the footer.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_FOOTER:String = "feathers-panel-screen-footer";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_AUTO
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_AUTO:String = "auto";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_ON
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_ON:String = "on";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_POLICY_OFF
		 *
		 * @see feathers.controls.Scroller#horizontalScrollPolicy
		 * @see feathers.controls.Scroller#verticalScrollPolicy
		 */
		public static const SCROLL_POLICY_OFF:String = "off";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FLOAT
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_FIXED
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";

		/**
		 * @copy feathers.controls.Scroller#SCROLL_BAR_DISPLAY_MODE_NONE
		 *
		 * @see feathers.controls.Scroller#scrollBarDisplayMode
		 */
		public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";

		/**
		 * The vertical scroll bar will be positioned on the right.
		 *
		 * @see feathers.controls.Scroller#verticalScrollBarPosition
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";

		/**
		 * The vertical scroll bar will be positioned on the left.
		 *
		 * @see feathers.controls.Scroller#verticalScrollBarPosition
		 */
		public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_TOUCH:String = "touch";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_MOUSE
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_MOUSE:String = "mouse";

		/**
		 * @copy feathers.controls.Scroller#INTERACTION_MODE_TOUCH_AND_SCROLL_BARS
		 *
		 * @see feathers.controls.Scroller#interactionMode
		 */
		public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";

		/**
		 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL
		 *
		 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL:String = "vertical";

		/**
		 * @copy feathers.controls.Scroller#MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL
		 *
		 * @see feathers.controls.Scroller#verticalMouseWheelScrollDirection
		 */
		public static const MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * @copy feathers.controls.Scroller#DECELERATION_RATE_NORMAL
		 *
		 * @see feathers.controls.Scroller#decelerationRate
		 */
		public static const DECELERATION_RATE_NORMAL:Number = 0.998;

		/**
		 * @copy feathers.controls.Scroller#DECELERATION_RATE_FAST
		 *
		 * @see feathers.controls.Scroller#decelerationRate
		 */
		public static const DECELERATION_RATE_FAST:Number = 0.99;

		/**
		 * @copy feathers.controls.ScrollContainer#AUTO_SIZE_MODE_STAGE
		 *
		 * @see feathers.controls.ScrollContainer#autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_STAGE:String = "stage";

		/**
		 * @copy feathers.controls.ScrollContainer#AUTO_SIZE_MODE_CONTENT
		 *
		 * @see feathers.controls.ScrollContainer#autoSizeMode
		 */
		public static const AUTO_SIZE_MODE_CONTENT:String = "content";

		/**
		 * The default <code>IStyleProvider</code> for all <code>PanelScreen</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function PanelScreen()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, panelScreen_addedToStageHandler);
			super();
			this.headerStyleName = DEFAULT_CHILD_STYLE_NAME_HEADER;
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return PanelScreen.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _screenID:String;

		/**
		 * @inheritDoc
		 */
		public function get screenID():String
		{
			return this._screenID;
		}

		/**
		 * @private
		 */
		public function set screenID(value:String):void
		{
			this._screenID = value;
		}

		/**
		 * @private
		 */
		protected var _owner:Object;

		/**
		 * @inheritDoc
		 */
		public function get owner():Object
		{
			return this._owner;
		}

		/**
		 * @private
		 */
		public function set owner(value:Object):void
		{
			this._owner = value;
		}

		/**
		 * Optional callback for the back hardware key. Automatically handles
		 * keyboard events to cancel the default behavior.
		 *
		 * <p>This function has the following signature:</p>
		 *
		 * <pre>function():void</pre>
		 *
		 * <p>In the following example, a function will dispatch <code>Event.COMPLETE</code>
		 * when the back button is pressed:</p>
		 *
		 * <listing version="3.0">
		 * this.backButtonHandler = onBackButton;
		 *
		 * private function onBackButton():void
		 * {
		 *     this.dispatchEvent( Event.COMPLETE );
		 * };</listing>
		 *
		 * @default null
		 */
		protected var backButtonHandler:Function;

		/**
		 * Optional callback for the menu hardware key. Automatically handles
		 * keyboard events to cancel the default behavior.
		 *
		 * <p>This function has the following signature:</p>
		 *
		 * <pre>function():void</pre>
		 *
		 * <p>In the following example, a function will be called when the menu
		 * button is pressed:</p>
		 *
		 * <listing version="3.0">
		 * this.menuButtonHandler = onMenuButton;
		 *
		 * private function onMenuButton():void
		 * {
		 *     //do something with the menu button
		 * };</listing>
		 *
		 * @default null
		 */
		protected var menuButtonHandler:Function;

		/**
		 * Optional callback for the search hardware key. Automatically handles
		 * keyboard events to cancel the default behavior.
		 *
		 * <p>This function has the following signature:</p>
		 *
		 * <pre>function():void</pre>
		 *
		 * <p>In the following example, a function will be called when the search
		 * button is pressed:</p>
		 *
		 * <listing version="3.0">
		 * this.searchButtonHandler = onSearchButton;
		 *
		 * private function onSearchButton():void
		 * {
		 *     //do something with the search button
		 * };</listing>
		 *
		 * @default null
		 */
		protected var searchButtonHandler:Function;

		/**
		 * @private
		 */
		protected function panelScreen_addedToStageHandler(event:Event):void
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, panelScreen_removedFromStageHandler);
			//using priority here is a hack so that objects higher up in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, panelScreen_nativeStage_keyDownHandler, false, priority, true);
		}

		/**
		 * @private
		 */
		protected function panelScreen_removedFromStageHandler(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, panelScreen_removedFromStageHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, panelScreen_nativeStage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function panelScreen_nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.isDefaultPrevented())
			{
				//someone else already handled this one
				return;
			}
			if(this.backButtonHandler != null &&
				event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				this.backButtonHandler();
			}

			if(this.menuButtonHandler != null &&
				event.keyCode == Keyboard.MENU)
			{
				event.preventDefault();
				this.menuButtonHandler();
			}

			if(this.searchButtonHandler != null &&
				event.keyCode == Keyboard.SEARCH)
			{
				event.preventDefault();
				this.searchButtonHandler();
			}
		}
	}
}
