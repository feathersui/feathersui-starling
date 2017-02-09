/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	/**
	 * Constants for positioning an item relative to another item in a layout.
	 *
	 * <p>Note: Some constants may not be valid for certain properties. Please
	 * see the description of the property in the API reference for full
	 * details.</p>
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class RelativePosition
	{
		/**
		 * The item will be positioned above another item.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const TOP:String = "top";

		/**
		 * The item will be positioned to the right of another item.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const RIGHT:String = "right";

		/**
		 * The item will be positioned below another item.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const BOTTOM:String = "bottom";

		/**
		 * The item will be positioned to the left of another item.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const LEFT:String = "left";

		/**
		 * The item will be positioned manually with no relation to the position
		 * of another item. Additional properties may be available to manually
		 * set the x and y position of the item.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const MANUAL:String = "manual";

		/**
		 * The item will be positioned to the left another item, and the
		 * baselines will be aligned to match. If an item doesn't have a
		 * baseline, then its bottom edge will be used as the baseline.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const LEFT_BASELINE:String = "leftBaseline";

		/**
		 * The item will be positioned to the right of another item, and the
		 * baselines will be aligned to match. If an item doesn't have a
		 * baseline, then its bottom edge will be used as the baseline.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const RIGHT_BASELINE:String = "rightBaseline";
	}
}
