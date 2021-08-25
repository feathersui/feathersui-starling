/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.system
{
	import flash.display.Stage;
	import flash.system.Capabilities;

	import starling.core.Starling;

	/**
	 * Using values from the Stage and Capabilities classes, makes educated
	 * guesses about the physical size of the device this code is running on.
	 *
	 * @productversion Feathers 1.0.0
	 */
	public class DeviceCapabilities
	{
		/**
		 * Indicates if the arrow and enter keys on a standard keyboard are
		 * treated the same as a d-pad. If <code>true</code>, focus and other
		 * behaviors may be controlled with a standard keyboard.
		 *
		 * <p>In the following example, the D-Pad is simulated:</p>
		 *
		 * <listing version="3.0">
		 * DeviceCapabilities.simulateDPad = true;</listing>
		 *
		 * @default false
		 *
		 * @productversion Feathers 3.4.0
		 */
		public static var simulateDPad:Boolean = false;

		//early Android tablets were frequently 600x1024 170 DPI, which results
		//in a portrait width slightly larger than 3.5 inches
		/**
		 * The minimum physical width, in inches, of the device when in
		 * portrait orientation to be considered a tablet.
		 * 
		 * <p>When calling <code>isTablet()</code>, a device must meet the
		 * requirements of both the minimum portrait width and the minimum
		 * landscape width.</p>
		 *
		 * @default 3.5
		 *
		 * @see #tabletScreenLandscapeWidthMinimumInches
		 * @see #isTablet()
		 */
		public static var tabletScreenPortraitWidthMinimumInches:Number = 3.5;

		/**
		 * The minimum physical size, in inches, of the device's larger side to
		 * be considered a tablet.
		 * 
		 * <p>When calling <code>isTablet()</code>, a device must meet the
		 * requirements of both the minimum portrait width and the minimum
		 * landscape width.</p>
		 *
		 * @default 5
		 *
		 * @see #tabletScreenPortraitWidthMinimumInches
		 * @see #isTablet()
		 */
		public static var tabletScreenLandscapeWidthMinimumInches:Number = 5;

		//the iPhone X is 1125x2436 458 DPI, which results in a portrait width
		//of ~2.45 inches. This device should be treated as a small phone.
		//the Pixel XL is 1440x2560 534 DPI, which results in a portrait width
		//of ~2.69 inches. This device should be treated as a large phone.
		/**
		 * The minimum physical width, in inches, of the device when in
		 * portrait orientation to be considered a large phone (sometimes
		 * called a phablet).
		 * 
		 * <p>When calling <code>isLargePhone()</code>, a device must meet the
		 * requirements of both the minimum portrait width and the minimum
		 * landscape width.</p>
		 *
		 * @default 2.5
		 *
		 * @see #largePhoneScreenLandscapeWidthMinimumInches
		 * @see #isLargePhone()
		 */
		public static var largePhoneScreenPortraitWidthMinimumInches:Number = 2.5;

		/**
		 * The minimum physical size, in inches, of the device's larger side to
		 * be considered a large phone (sometimes called a phablet).
		 * 
		 * <p>When calling <code>isLargePhone()</code>, a device must meet the
		 * requirements of both the minimum portrait width and the minimum
		 * landscape width.</p>
		 *
		 * @default 4.5
		 *
		 * @see #largePhoneScreenPortraitWidthMinimumInches
		 * @see #isLargePhone()
		 */
		public static var largePhoneScreenLandscapeWidthMinimumInches:Number = 4.5;

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
		 * @see #tabletScreenPortraitWidthMinimumInches
		 * @see #tabletScreenLandscapeWidthMinimumInches
		 * @see #isPhone()
		 */
		public static function isTablet(stage:Stage = null):Boolean
		{
			var portraitWidth:Number = screenInchesX(stage);
			var landscapeWidth:Number = screenInchesY(stage);
			if(portraitWidth > landscapeWidth)
			{
				//make sure the longer side is used for landscape comparison
				var temp:Number = landscapeWidth;
				landscapeWidth = portraitWidth;
				portraitWidth = temp;
			}
			return portraitWidth >= tabletScreenPortraitWidthMinimumInches &&
				landscapeWidth >= tabletScreenLandscapeWidthMinimumInches;
		}

		/**
		 * Determines if this device is probably a large phone (sometimes
		 * called a phablet), based on the physical width and height, in
		 * inches, calculated using the full-screen dimensions and the screen
		 * density.
		 *
		 * @see #largePhoneScreenLandscapeWidthMinimumInches
		 * @see #largePhoneScreenPortraitWidthMinimumInches
		 * @see #isPhone()
		 * @see #isTablet()
		 */
		public static function isLargePhone(stage:Stage = null):Boolean
		{
			var portraitWidth:Number = screenInchesX(stage);
			var landscapeWidth:Number = screenInchesY(stage);
			if(portraitWidth > landscapeWidth)
			{
				//make sure the longer side is used for landscape comparison
				var temp:Number = landscapeWidth;
				landscapeWidth = portraitWidth;
				portraitWidth = temp;
			}
			return portraitWidth >= largePhoneScreenPortraitWidthMinimumInches &&
				landscapeWidth >= largePhoneScreenLandscapeWidthMinimumInches &&
				!isTablet(stage);
		}

		/**
		 * Determines if this device is probably a phone, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen density.
		 * 
		 * <p>Returns <code>true</code> if the device is smaller than the
		 * minimum dimensions of a tablet. Larger phones (sometimes called
		 * phablets) are classified as phones when calling
		 * <code>isPhone()</code>. If <code>isPhone()</code> returns
		 * <code>true</code>, use <code>isLargePhone()</code> to determine the
		 * size of the phone, if necessary.</p>
		 *
		 * @see #isTablet()
		 * @see #isLargePhone()
		 */
		public static function isPhone(stage:Stage = null):Boolean
		{
			return !isTablet(stage);
		}

		/**
		 * The physical width of the device, in inches. Calculated using the
		 * full-screen width and the screen density.
		 *
		 * @see #screenPixelWidth
		 * @see #dpi
		 */
		public static function screenInchesX(stage:Stage = null):Number
		{
			if(stage === null)
			{
				stage = Starling.current.nativeStage;
			}
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
		 * @see #dpi
		 */
		public static function screenInchesY(stage:Stage = null):Number
		{
			if(stage === null)
			{
				stage = Starling.current.nativeStage;
			}
			var screenHeight:Number = screenPixelHeight;
			if(screenHeight !== screenHeight) //isNaN
			{
				screenHeight = stage.fullScreenHeight;
			}
			return screenHeight / dpi;
		}
	}
}
