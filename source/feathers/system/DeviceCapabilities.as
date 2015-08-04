/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.system
{
	import flash.display.Stage;
	import flash.system.Capabilities;

	/**
	 * Using values from the Stage and Capabilities classes, makes educated
	 * guesses about the physical size of the device this code is running on.
	 */
	public class DeviceCapabilities
	{
		/**
		 * The minimum physical size, in inches, of the device's larger side to
		 * be considered a tablet.
		 *
		 * @default 5
		 *
		 * @see #isTablet()
		 * @see #isPhone()
		 */
		public static var tabletScreenMinimumInches:Number = 5;

		/**
		 * A custom width, in pixels, to use for calculations of the device's
		 * physical screen size. Set to NaN to use the actual width.
		 *
		 * @default flash.display.Stage.fullScreenWidth
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Stage.html#fullScreenWidth Full description of flash.display.Stage.fullScreenWidth in Adobe's Flash Platform API Reference
		 */
		public static var screenPixelWidth:Number = NaN;

		/**
		 * A custom height, in pixels, to use for calculations of the device's
		 * physical screen size. Set to NaN to use the actual height.
		 *
		 * @default flash.display.Stage.fullScreenHeight
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/Stage.html#fullScreenWidth Full description of flash.display.Stage.fullScreenWidth in Adobe's Flash Platform API Reference
		 */
		public static var screenPixelHeight:Number = NaN;
		
		/**
		 * The screen density to be used by Feathers. Defaults to the value of
		 * <code>flash.system.Capabilities.screenDPI</code>, but may be
		 * overridden. For example, if one wishes to demo a mobile app in a
		 * desktop browser, a custom screen density will override the real
		 * density of the desktop screen.
		 *
		 * <p><strong>Warning:</strong> You should avoid changing this value on
		 * a mobile device because it may result in unexpected side effects. In
		 * addition to being used to scale components in the example themes, the
		 * screen density is used by components such as <code>Scroller</code>
		 * (and its subclasses like <code>List</code> and
		 * <code>ScrollContainer</code>) to optimize the scrolling behavior.
		 * Reporting a different screen density may cause some components to
		 * appear poorly responsive (or overly sensitive) to touches.</p>
		 *
		 * @default flash.system.Capabilities.screenDPI
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#screenDPI Full description of flash.system.Capabilities.screenDPI in Adobe's Flash Platform API Reference
		 */
		public static var dpi:int = Capabilities.screenDPI;

		/**
		 * Determines if this device is probably a tablet, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen density.
		 *
		 * @see #tabletScreenMinimumInches
		 * @see #screenPixelWidth
		 * @see #screenPixelHeight
		 * @see #isPhone()
		 */
		public static function isTablet(stage:Stage):Boolean
		{
			var screenWidth:Number = screenPixelWidth;
			if(screenWidth !== screenWidth) //isNaN
			{
				screenWidth = stage.fullScreenWidth;
			}
			var screenHeight:Number = screenPixelHeight;
			if(screenHeight !== screenHeight) //isNaN
			{
				screenHeight = stage.fullScreenHeight;
			}
			if(screenWidth < screenHeight)
			{
				screenWidth = screenHeight;
			}
			return (screenWidth / dpi) >= tabletScreenMinimumInches;
		}

		/**
		 * Determines if this device is probably a phone, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen density.
		 *
		 * @see #isTablet()
		 */
		public static function isPhone(stage:Stage):Boolean
		{
			return !isTablet(stage);
		}

		/**
		 * The physical width of the device, in inches. Calculated using the
		 * full-screen width and the screen density.
		 *
		 * @see #screenPixelWidth
		 */
		public static function screenInchesX(stage:Stage):Number
		{
			var screenWidth:Number = screenPixelWidth;
			if(screenWidth !== screenWidth) //isNaN
			{
				screenWidth = stage.fullScreenWidth;
			}
			return screenWidth / dpi;
		}

		/**
		 * The physical height of the device, in inches. Calculated using the
		 * full-screen height and the screen density.
		 *
		 * @see #screenPixelHeight
		 */
		public static function screenInchesY(stage:Stage):Number
		{
			var screenHeight:Number = screenPixelHeight;
			if(screenHeight !== screenHeight) //isNaN
			{
				screenHeight = stage.fullScreenHeight;
			}
			return screenHeight / dpi;
		}
	}
}
