/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * A toggle associated with a specific group.
	 *
	 * @see ToggleGroup
	 *
	 * @productversion Feathers 1.0.0
	 */
	public interface IGroupedToggle extends IToggle
	{
		/**
		 * When the toggle is added to a <code>ToggleGroup</code>, the group
		 * will manage the entire group's selection when one of the toggles in
		 * the group changes.
		 *
		 * <p>In the following example, a <code>Radio</code> is added to a <code>ToggleGroup</code>:</p>
		 *
		 * <listing version="3.0">
		 * var group:ToggleGroup = new ToggleGroup();
		 * group.addEventListener( Event.CHANGE, group_changeHandler );
		 * 
		 * var radio:Radio = new Radio();
		 * radio.toggleGroup = group;
		 * this.addChild( radio );</listing>
		 */
		function get toggleGroup():ToggleGroup;

		/**
		 * @private
		 */
		function set toggleGroup(value:ToggleGroup):void;
	}
}
