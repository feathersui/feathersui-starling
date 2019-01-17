/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * A display object that supports validation. Display objects of this type
	 * will delay updating after property changes until just before Starling
	 * renders the display list to avoid running redundant code.
	 *
	 * @productversion Feathers 1.3.0
	 */
	public interface IValidating extends IFeathersDisplayObject
	{
		/**
		 * The component's depth in the display list, relative to the stage. If
		 * the component isn't on the stage, its depth will be <code>-1</code>.
		 *
		 * <p>Used by the validation system to validate components from the
		 * top down.</p>
		 */
		function get depth():int;

		/**
		 * Immediately validates the display object, if it is invalid. The
		 * validation system exists to postpone updating a display object after
		 * properties are changed until until the last possible moment the
		 * display object is rendered. This allows multiple properties to be
		 * changed at a time without requiring a full update every time.
		 */
		function validate():void;
	}
}
