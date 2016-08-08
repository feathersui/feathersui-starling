/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 * @see feathers.controls.renderers.DefaultListItemRenderer
	 * @see feathers.controls.renderers.DefaultGroupedListItemRenderer
	 */
	public class ButtonState
	{
		/**
		 * The default, up state.
		 */
		public static const UP:String = "up";

		/**
		 * The down state, when a touch begins on the component.
		 */
		public static const DOWN:String = "down";

		/**
		 * The hover state, when the mouse is over the component. This state is
		 * not used on a touchscreen.
		 */
		public static const HOVER:String = "hover";

		/**
		 * The disabled state, when the component's <code>isEnabled</code>
		 * property is <code>false</code>.
		 * 
		 * @see feathers.core.FeathersControl#isEnabled
		 */
		public static const DISABLED:String = "disabled";

		/**
		 * Same as the up state, but the component is also selected.
		 *
		 * @see feathers.core.ToggleButton#isSelected
		 */
		public static const UP_AND_SELECTED:String = "upAndSelected";

		/**
		 * Same as the down state, but the component is also selected.
		 *
		 * @see feathers.core.ToggleButton#isSelected
		 */
		public static const DOWN_AND_SELECTED:String = "downAndSelected";

		/**
		 * Same as the hover state, but the component is also selected.
		 *
		 * @see feathers.core.ToggleButton#isSelected
		 */
		public static const HOVER_AND_SELECTED:String = "hoverAndSelected";

		/**
		 * Same as the disabled state, but the component is also selected.
		 *
		 * @see feathers.core.ToggleButton#isSelected
		 * @see feathers.core.FeathersControl#isEnabled
		 */
		public static const DISABLED_AND_SELECTED:String = "disabledAndSelected";
	}
}
