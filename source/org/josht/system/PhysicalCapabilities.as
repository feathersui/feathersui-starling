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
		 * Determines if this device is probably a tablet, based on the physical
		 * width and height, in inches, calculated using the full-screen
		 * dimensions and the screen DPI.
		 */
		public static function isTablet(stage:Stage):Boolean
		{
			return (Math.max(stage.fullScreenWidth, stage.fullScreenHeight) / Capabilities.screenDPI) >= IS_TABLET_MINIMUM_INCHES;
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
			return stage.fullScreenWidth / Capabilities.screenDPI;
		}

		/**
		 * The physical height of the device, in inches. Calculated using the
		 * full-screen height and the screen DPI.
		 */
		public static function screenInchesY(stage:Stage):Number
		{
			return stage.fullScreenHeight / Capabilities.screenDPI;
		}
	}
}
