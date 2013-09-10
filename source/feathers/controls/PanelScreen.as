/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.system.DeviceCapabilities;
	import feathers.utils.display.getDisplayObjectDepthFromStage;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.events.Event;

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
	 *             this.addEventListener( FeathersEventType.INITIALIZE, initializeHandler );
	 *         }
	 *
	 *         private function initializeHandler( event:Event ):void
	 *         {
	 *             //runs once when screen is first added to the stage.
	 *             //a good place to add children and customize the layout
	 *         }
	 *     }
	 * }</listing>
	 *
	 * @see ScreenNavigator
	 * @see Panel
	 * @see Screen
	 * @see http://wiki.starling-framework.org/feathers/panel-screen
	 */
	public class PanelScreen extends Panel implements IScreen
	{
		/**
		 * The default value added to the <code>nameList</code> of the header.
		 *
		 * @see feathers.core.IFeathersControl#nameList
		 */
		public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-panel-screen-header";

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
		 * Constructor.
		 */
		public function PanelScreen()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, panelScreen_addedToStageHandler);
			super();
			this.headerName = DEFAULT_CHILD_NAME_HEADER;
			this.originalDPI = DeviceCapabilities.dpi;
			this.clipContent = false;
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
		protected var _owner:ScreenNavigator;

		/**
		 * @inheritDoc
		 */
		public function get owner():ScreenNavigator
		{
			return this._owner;
		}

		/**
		 * @private
		 */
		public function set owner(value:ScreenNavigator):void
		{
			this._owner = value;
		}

		/**
		 * @private
		 */
		protected var _originalDPI:int = 0;

		/**
		 * The original intended DPI of the application. This value cannot be
		 * automatically detected and it must be set manually.
		 *
		 * <p>In the following example, the original DPI is customized:</p>
		 *
		 * <listing version="3.0">
		 * this.originalDPI = 326; //iPhone with Retina Display</listing>
		 *
		 * @see #dpiScale
		 * @see feathers.system.DeviceCapabilities#dpi
		 */
		public function get originalDPI():int
		{
			return this._originalDPI;
		}

		/**
		 * @private
		 */
		public function set originalDPI(value:int):void
		{
			if(this._originalDPI == value)
			{
				return;
			}
			this._originalDPI = value;
			this._dpiScale = DeviceCapabilities.dpi / this._originalDPI;
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}

		/**
		 * @private
		 */
		protected var _dpiScale:Number = 1;

		/**
		 * Uses <code>originalDPI</code> and <code>DeviceCapabilities.dpi</code>
		 * to calculate a scale value to allow all content to be the same
		 * physical size (in inches). Using this value will have a much larger
		 * effect on the layout of the content, but it can ensure that
		 * interactive items won't be scaled too small to affect the accuracy
		 * of touches. Likewise, it won't scale items to become ridiculously
		 * physically large. Most useful when targeting many different platforms
		 * with the same code.
		 *
		 * @see #originalDPI
		 * @see feathers.system.DeviceCapabilities#dpi
		 */
		protected function get dpiScale():Number
		{
			return this._dpiScale;
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
			if(event.target != this)
			{
				return;
			}
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
			if(event.target != this)
			{
				return;
			}
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
