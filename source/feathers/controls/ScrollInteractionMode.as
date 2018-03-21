/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Different ways that the user can interact with a scrolling container to
	 * control its scroll position.
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class ScrollInteractionMode
	{
		/**
		 * The user may touch anywhere on the scroller and drag to scroll. The
		 * scroll bars will be visual indicator of position, but they will not
		 * be interactive.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const TOUCH:String = "touch";

		/**
		 * The user may only interact with the scroll bars to scroll. The user
		 * cannot touch anywhere in the scroller's content and drag like a touch
		 * interface.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const MOUSE:String = "mouse";

		/**
		 * The user may touch anywhere on the scroller and drag to scroll, and
		 * the scroll bars may be dragged separately. For most touch interfaces,
		 * this is not a common behavior. The scroll bar on touch interfaces is
		 * often simply a visual indicator and non-interactive.
		 *
		 * <p>One case where this mode might be used is a "scroll bar" that
		 * displays a tappable alphabetical index to navigate a
		 * <code>GroupedList</code> with alphabetical categories.</p>
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";
	}
}
