/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Interaction modes for page indicators.
	 * 
	 * @see feathers.controls.PageIndicator
	 */
	public class PageIndicatorInteractionMode
	{
		/**
		 * Touching the page indicator on the left of the selected symbol will
		 * select the previous index and to the right of the selected symbol
		 * will select the next index.
		 */
		public static const PREVIOUS_NEXT:String = "previousNext";

		/**
		 * Touching the page indicator on a symbol will select that symbol's
		 * exact index.
		 */
		public static const PRECISE:String = "precise";
	}
}
