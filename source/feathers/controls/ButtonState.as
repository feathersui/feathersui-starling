/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * States for button components.
	 *
	 * @see feathers.controls.BasicButton
	 * @see feathers.controls.Button
	 * @see feathers.controls.ToggleButton
	 * @see feathers.controls.Check
	 * @see feathers.controls.Radio
	 */
	public class ButtonState
	{
		/**
		 * The default, up state.
		 */
		public static const UP:String = "up";
		
		/**
		 * The down state, when the mouse is pressed over the component.
		 */
		public static const DOWN:String = "down";
		
		/**
		 * The hover state, when the mouse is over the component.
		 */
		public static const HOVER:String = "hover";

		/**
		 * The disabled state, when the component is disabled.
		 */
		public static const DISABLED:String = "disabled";

		/**
		 * The up state, when selected.
		 */
		public static const UP_AND_SELECTED:String = "upAndSelected";

		/**
		 * The down state, when selected.
		 */
		public static const DOWN_AND_SELECTED:String = "downAndSelected";

		/**
		 * The hover state, when selected.
		 */
		public static const HOVER_AND_SELECTED:String = "hoverAndSelected";

		/**
		 * The disabled state, when selected.
		 */
		public static const DISABLED_AND_SELECTED:String = "disabledAndSelected";
	}
}
