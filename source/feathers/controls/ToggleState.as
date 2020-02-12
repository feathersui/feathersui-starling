/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * States for simple toggle components.
	 *
	 * @see feathers.core.IToggle
	 * @see feathers.controls.ToggleSwitch
	 *
	 * @productversion Feathers 3.1.0
	 */
	public class ToggleState
	{
		/**
		 * The state where the component is not selected. If the component
		 * implements the <code>IToggle</code> interface, the
		 * <code>isSelected</code> property will be <code>false</code>.
		 *
		 * @see feathers.core.IToggle
		 *
		 * @productversion Feathers 3.1.0
		 */
		public static const NOT_SELECTED:String = "notSelected";

		/**
		 * The state where the component is selected. If the component
		 * implements the <code>IToggle</code> interface, the
		 * <code>isSelected</code> property will be <code>true</code>.
		 *
		 * @see feathers.core.IToggle
		 *
		 * @productversion Feathers 3.1.0
		 */
		public static const SELECTED:String = "selected";

		/**
		 * The state where the component is not selected and disabled. If the
		 * component implements the <code>IToggle</code> interface, the
		 * <code>isSelected</code> property will be <code>false</code>. The
		 * <code>isEnabled</code> property will be <code>false</code>.
		 *
		 * @see feathers.core.IToggle
		 *
		 * @productversion Feathers 3.1.0
		 */
		public static const DISABLED:String = "disabled";

		/**
		 * The state where the component is selected and disabled. If the
		 * component implements the <code>IToggle</code> interface, the
		 * <code>isSelected</code> property will be <code>true</code>. The
		 * <code>isEnabled</code> property will be <code>false</code>.
		 *
		 * @see feathers.core.IToggle
		 *
		 * @productversion Feathers 3.1.0
		 */
		public static const SELECTED_AND_DISABLED:String = "selectedAndDisabled";
	}
}
