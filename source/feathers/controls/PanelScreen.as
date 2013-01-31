/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.system.DeviceCapabilities;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import starling.core.Starling;

	import starling.events.Event;

	/**
	 * A screen for use with <code>ScreenNavigator</code>, based on <code>Panel</code>
	 * in order to provide a header and layout.
	 *
	 * @see ScreenNavigator
	 * @see Panel
	 */
	public class PanelScreen extends Panel implements IScreen
	{
		/**
		 * The default value added to the <code>nameList</code> of the header.
		 */
		public static const DEFAULT_CHILD_NAME_HEADER:String = "feathers-panel-screen-header";

		/**
		 * Constructor.
		 */
		public function PanelScreen()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, panelScreen_addedToStageHandler);
			super();
			this.headerName = DEFAULT_CHILD_NAME_HEADER;
			this.originalDPI = DeviceCapabilities.dpi;
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
		 */
		protected function get dpiScale():Number
		{
			return this._dpiScale;
		}

		/**
		 * Optional callback for the back hardware key. Automatically handles
		 * keyboard events to cancel the default behavior.
		 */
		protected var backButtonHandler:Function;

		/**
		 * Optional callback for the menu hardware key. Automatically handles
		 * keyboard events to cancel the default behavior.
		 */
		protected var menuButtonHandler:Function;

		/**
		 * Optional callback for the search hardware key. Automatically handles
		 * keyboard events to cancel the default behavior.
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
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, panelScreen_stage_keyDownHandler, false, 0, true);
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
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, panelScreen_stage_keyDownHandler);
		}

		/**
		 * @private
		 */
		protected function panelScreen_stage_keyDownHandler(event:KeyboardEvent):void
		{
			//we're accessing Keyboard.BACK (and others) using a string because
			//this code may be compiled for both Flash Player and AIR.
			if(this.backButtonHandler != null &&
				Object(Keyboard).hasOwnProperty("BACK") &&
				event.keyCode == Keyboard["BACK"])
			{
				event.stopImmediatePropagation();
				event.preventDefault();
				this.backButtonHandler();
			}

			if(this.menuButtonHandler != null &&
				Object(Keyboard).hasOwnProperty("MENU") &&
				event.keyCode == Keyboard["MENU"])
			{
				event.preventDefault();
				this.menuButtonHandler();
			}

			if(this.searchButtonHandler != null &&
				Object(Keyboard).hasOwnProperty("SEARCH") &&
				event.keyCode == Keyboard["SEARCH"])
			{
				event.preventDefault();
				this.searchButtonHandler();
			}
		}
	}
}
