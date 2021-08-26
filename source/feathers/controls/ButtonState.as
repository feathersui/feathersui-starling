/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

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
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class ButtonState
	{
		/**
		 * The default, up state.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const UP:String = "up";

		/**
		 * The down state, when a touch begins on the component.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const DOWN:String = "down";

		/**
		 * The hover state, when the mouse is over the component. This state is
		 * not used on a touchscreen.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const HOVER:String = "hover";

		/**
		 * The disabled state, when the component's <code>isEnabled</code>
		 * property is <code>false</code>.
		 * 
		 * @see feathers.core.FeathersControl#isEnabled
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const DISABLED:String = "disabled";

		/**
		 * Same as the up state, but the component is also selected.
		 *
		 * @see feathers.controls.ToggleButton#isSelected
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const UP_AND_SELECTED:String = "upAndSelected";

		/**
		 * Same as the down state, but the component is also selected.
		 *
		 * @see feathers.controls.ToggleButton#isSelected
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const DOWN_AND_SELECTED:String = "downAndSelected";

		/**
		 * Same as the hover state, but the component is also selected.
		 *
		 * @see feathers.controls.ToggleButton#isSelected
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const HOVER_AND_SELECTED:String = "hoverAndSelected";

		/**
		 * Same as the disabled state, but the component is also selected.
		 *
		 * @see feathers.controls.ToggleButton#isSelected
		 * @see feathers.core.FeathersControl#isEnabled
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const DISABLED_AND_SELECTED:String = "disabledAndSelected";

		/**
		 * Same as the focused state, but the component is also selected.
		 *
		 * @see feathers.controls.ToggleButton#isSelected
		 * @see feathers.core.FocusManager
		 *
		 * @productversion Feathers 3.4.0
		 */
		public static const FOCUSED_AND_SELECTED:String = "focusedAndSelected";
	}
}
