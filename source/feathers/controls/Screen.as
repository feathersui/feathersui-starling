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
	import feathers.events.FeathersEventType;
	import feathers.system.DeviceCapabilities;
	import feathers.utils.display.calculateScaleRatioToFit;
	import feathers.utils.display.getDisplayObjectDepthFromStage;

	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * Provides useful capabilities for a menu screen displayed by
	 * <code>ScreenNavigator</code>.
	 *
	 * <p>The following example provides a basic framework for a new screen:</p>
	 *
	 * <listing version="3.0">
	 * package
	 * {
	 *     import feathers.controls.Screen;
	 *
	 *     public class CustomScreen extends Screen
	 *     {
	 *         public function CustomScreen()
	 *         {
	 *         }
	 *
	 *         override protected function initialize():void
	 *         {
	 *             //runs once when screen is first added to the stage.
	 *             //a good place to add children and things.
	 *         }
	 *
	 *         override protected function draw():void
	 *         {
	 *             //runs every time invalidate() is called
	 *             //a good place for measurement and layout
	 *         }
	 *     }
	 * }</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/screen
	 * @see ScreenNavigator
	 */
	public class Screen extends FeathersControl implements IScreen
	{
		/**
		 * Constructor.
		 */
		public function Screen()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, screen_addedToStageHandler);
			this.addEventListener(FeathersEventType.RESIZE, screen_resizeHandler);
			super();
			this.originalDPI = DeviceCapabilities.dpi;
		}
		
		/**
		 * @private
		 */
		protected var _originalWidth:Number = NaN;
		
		/**
		 * The original intended width of the application. If not set manually,
		 * <code>loaderInfo.width</code> is automatically detected (to get
		 * width value from <code>[SWF]</code> metadata.
		 *
		 * <p>In the following example, the original width is customized:</p>
		 *
		 * <listing version="3.0">
		 * this.originalWidth = 960; //iPhone with Retina Display in landscape</listing>
		 *
		 * @see #pixelScale
		 */
		public function get originalWidth():Number
		{
			return this._originalWidth;
		}
		
		/**
		 * @private
		 */
		public function set originalWidth(value:Number):void
		{
			if(this._originalWidth == value)
			{
				return;
			}
			this._originalWidth = value;
			if(this.stage)
			{
				this.refreshPixelScale();
			}
		}
		
		/**
		 * @private
		 */
		protected var _originalHeight:Number = NaN;
		
		/**
		 * The original intended height of the application. If not set manually,
		 * <code>loaderInfo.height</code> is automatically detected (to get
		 * height value from <code>[SWF]</code> metadata.
		 *
		 * <p>In the following example, the original height is customized:</p>
		 *
		 * <listing version="3.0">
		 * this.originalWidth = 640; //iPhone with Retina Display in landscape</listing>
		 *
		 * @see #pixelScale
		 */
		public function get originalHeight():Number
		{
			return this._originalHeight;
		}
		
		/**
		 * @private
		 */
		public function set originalHeight(value:Number):void
		{
			if(this._originalHeight == value)
			{
				return;
			}
			this._originalHeight = value;
			if(this.stage)
			{
				this.refreshPixelScale();
			}
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
		protected var _pixelScale:Number = 1;
		
		/**
		 * Uses <code>originalWidth</code>, <code>originalHeight</code>,
		 * <code>actualWidth</code>, and <code>actualHeight</code>,
		 * to calculate a scale value that will allow all content will fit
		 * within the current stage bounds using the same relative layout. This
		 * scale value does not account for differences between the original DPI
		 * and the current device's DPI.
		 *
		 * @see #originalWidth
		 * @see #originalHeight
		 */
		protected function get pixelScale():Number
		{
			return this._pixelScale;
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
		override protected function draw():void
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return;
			}

			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth || needsHeight)
			{
				var maxX:Number = isNaN(newWidth) ? 0 : newWidth;
				var maxY:Number = isNaN(newHeight) ? 0 : newHeight;
				const childCount:int = this.numChildren;
				for(var i:int = 0; i < childCount; i++)
				{
					var child:DisplayObject = this.getChildAt(i);
					if(child is IFeathersControl)
					{
						IFeathersControl(child).validate();
					}
					maxX = Math.max(maxX, child.x + child.width);
					maxY = Math.max(maxY, child.y + child.height);
				}
				if(needsWidth)
				{
					newWidth = maxX;
				}
				if(needsHeight)
				{
					newHeight = maxY;
				}
			}
			this.setSizeInternal(newWidth, newHeight, false);
		}
		
		/**
		 * @private
		 */
		protected function refreshPixelScale():void
		{
			if(!this.stage)
			{
				return;
			}
			const loaderInfo:LoaderInfo = DisplayObjectContainer(Starling.current.nativeStage.root).getChildAt(0).loaderInfo;
			//if originalWidth or originalHeight is NaN, it's because the Screen
			//has been added to the display list, and we really need values now.
			if(isNaN(this._originalWidth))
			{
				try
				{
					this._originalWidth = loaderInfo.width;
				} 
				catch(error:Error) 
				{
					this._originalWidth = this.stage.stageWidth;
				}
			}
			if(isNaN(this._originalHeight))
			{
				try
				{
					this._originalHeight = loaderInfo.height;
				} 
				catch(error:Error) 
				{
					this._originalHeight = this.stage.stageHeight;
				}
			}
			this._pixelScale = calculateScaleRatioToFit(originalWidth, originalHeight, this.actualWidth, this.actualHeight);
		}
		
		/**
		 * @private
		 */
		protected function screen_addedToStageHandler(event:Event):void
		{
			if(event.target != this)
			{
				return;
			}
			this.refreshPixelScale();
			this.addEventListener(Event.REMOVED_FROM_STAGE, screen_removedFromStageHandler);
			//using priority here is a hack so that objects higher up in the
			//display list have a chance to cancel the event first.
			var priority:int = -getDisplayObjectDepthFromStage(this);
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, screen_nativeStage_keyDownHandler, false, priority, true);
		}

		/**
		 * @private
		 */
		protected function screen_removedFromStageHandler(event:Event):void
		{
			if(event.target != this)
			{
				return;
			}
			this.removeEventListener(Event.REMOVED_FROM_STAGE, screen_removedFromStageHandler);
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, screen_nativeStage_keyDownHandler);
		}
		
		/**
		 * @private
		 */
		protected function screen_resizeHandler(event:Event):void
		{
			this.refreshPixelScale();
		}
		
		/**
		 * @private
		 */
		protected function screen_nativeStage_keyDownHandler(event:KeyboardEvent):void
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