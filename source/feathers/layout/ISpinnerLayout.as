/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.layout
{
	/**
	 * A layout for the <code>SpinnerList</code> component.
	 *
	 * @see feathers.controls.SpinnerList
	 *
	 * @productversion Feathers 2.1.0
	 */
	public interface ISpinnerLayout extends ILayout
	{
		/**
		 * The interval, in pixels, between snapping points.
		 */
		function get snapInterval():Number;
	}
}
