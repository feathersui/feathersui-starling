package org.josht.system
{
	import flash.display.Stage;
	import flash.system.Capabilities;

	/**
	 * Using values from the Stage and Capabilities classes, makes educated
	 * guesses about the physical size of the device this code is running on.
	 */
	public class PhysicalCapabilities
	{
		/**
		 * The minimum physical size, in inches, of the device's larger side to
		 * be considered a tablet.
		 */
		public static var IS_TABLET_MINIMUM_INCHES:Number = 5;

		/**
		 * A custom width, in pixels, to use for calculations. Useful for
		 * desktop Flash Player demos that need to simulate mobile screens.
		 */
		public static var CUSTOM_SCREEN_WIDTH:Number = NaN;

		/**
		 * A custom height, in pixels, to use for calculations. Useful for
		 * desktop Flash Player demos that need to simulate mobile screens.
		 */
		public static var CUSTOM_SCREEN_HEIGHT:Number = NaN;

		/**
		 * A custom dpi to use for calculations. Useful for desktop Flash Player
		 * demos that need to simulate mobile screens.
		 */
		public static var CUSTOM_SCREEN_DPI:Number = NaN;

		/**
		 * Determines if this device is probably a tablet, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen DPI.
		 */
		public static function isTablet(stage:Stage):Boolean
		{
			const screenWidth:Number = isNaN(CUSTOM_SCREEN_WIDTH) ? stage.fullScreenWidth : CUSTOM_SCREEN_WIDTH;
			const screenHeight:Number = isNaN(CUSTOM_SCREEN_HEIGHT) ? stage.fullScreenHeight : CUSTOM_SCREEN_HEIGHT;
			const screenDPI:Number = isNaN(CUSTOM_SCREEN_DPI) ? Capabilities.screenDPI : CUSTOM_SCREEN_DPI;
			return (Math.max(screenWidth, screenHeight) / screenDPI) >= IS_TABLET_MINIMUM_INCHES;
		}

		/**
		 * Determines if this device is probably a phone, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen DPI.
		 */
		public static function isPhone(stage:Stage):Boolean
		{
			return !isTablet(stage);
		}

		/**
		 * The physical width of the device, in inches. Calculated using the
		 * full-screen width and the screen DPI.
		 */
		public static function screenInchesX(stage:Stage):Number
		{
			const screenWidth:Number = isNaN(CUSTOM_SCREEN_WIDTH) ? stage.fullScreenWidth : CUSTOM_SCREEN_WIDTH;
			const screenDPI:Number = isNaN(CUSTOM_SCREEN_DPI) ? Capabilities.screenDPI : CUSTOM_SCREEN_DPI;
			return screenWidth / screenDPI;
		}

		/**
		 * The physical height of the device, in inches. Calculated using the
		 * full-screen height and the screen DPI.
		 */
		public static function screenInchesY(stage:Stage):Number
		{
			const screenHeight:Number = isNaN(CUSTOM_SCREEN_HEIGHT) ? stage.fullScreenHeight : CUSTOM_SCREEN_HEIGHT;
			const screenDPI:Number = isNaN(CUSTOM_SCREEN_DPI) ? Capabilities.screenDPI : CUSTOM_SCREEN_DPI;
			return screenHeight / screenDPI;
		}
	}
}
