/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Constants that define how scroll bars are displayed in a container.
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class ScrollBarDisplayMode
	{
		/**
		 * The scroll bars appear above the scroller's view port, overlapping
		 * the content, and they fade out when not in use.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const FLOAT:String = "float";

		/**
		 * The scroll bars are always visible and appear next to the scroller's
		 * view port, making the view port smaller than the scroller.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const FIXED:String = "fixed";

		/**
		 * The scroll bars appear above the scroller's view port, overlapping
		 * the content, but they do not fade out when not in use.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const FIXED_FLOAT:String = "fixedFloat";

		/**
		 * The scroll bars are never visible.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const NONE:String = "none";
	}
}
