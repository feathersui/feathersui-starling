/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import flash.errors.IllegalOperationError;

	[Exclude(name="isToggle",kind="property")]

	/**
	 * A toggle control that contains a label and a box that may be checked
	 * or not to indicate selection.
	 *
	 * <p>In the following example, a check is created and selected, and a
	 * listener for <code>Event.CHANGE</code> is added:</p>
	 *
	 * <listing version="3.0">
	 * var check:Check = new Check();
	 * check.label = "Pick Me!";
	 * check.isSelected = true;
	 * check.addEventListener( Event.CHANGE, check_changeHandler );
	 * this.addChild( check );</listing>
	 *
	 * @see http://wiki.starling-framework.org/feathers/check
	 * @see ToggleSwitch
	 */
	public class Check extends Button
	{
		/**
		 * Constructor.
		 */
		public function Check()
		{
			super.isToggle = true;
		}

		/**
		 * @private
		 */
		override public function set isToggle(value:Boolean):void
		{
			throw IllegalOperationError("CheckBox isToggle must always be true.");
		}
	}
}
