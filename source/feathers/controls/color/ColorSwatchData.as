/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.color
{
	/**
	 * A class to store data for color swatches.
	 */
	public class ColorSwatchData
	{
		/**
		 * Constructor.
		 */
		public function ColorSwatchData(color:uint = 0x000000, label:String = null)
		{
			this.color = color;
			this.label = label;
		}

		/**
		 * The color value.
		 */
		public var color:uint;

		/**
		 * A label to associate with the color. May be <code>null</code>.
		 */
		public var label:String;
	}
}
