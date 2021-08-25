/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Constants that define whether a container allows scrolling or not.
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class ScrollPolicy
	{
		/**
		 * The scroller may scroll if the content is larger than the
		 * view port's bounds. If the interaction mode is touch, the elastic
		 * edges will only be active if the maximum scroll position is greater
		 * than zero. If the scroll bar display mode is fixed, the scroll bar
		 * will only be visible when the maximum scroll position is greater than
		 * zero.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const AUTO:String = "auto";

		/**
		 * The scroller will always scroll. If the interaction mode is touch,
		 * elastic edges will always be active, even when the maximum scroll
		 * position is zero. If the scroll bar display mode is fixed, the scroll
		 * bar will always be visible.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const ON:String = "on";

		/**
		 * The scroller does not scroll at all, even if the content is larger
		 * than the view port's bounds. If the scroll bar display mode is fixed
		 * or float, the scroll bar will never be visible.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const OFF:String = "off";
	}
}
