/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * A UI control with text that has a baseline.
	 *
	 * @productversion Feathers 2.0.0
	 */
	public interface ITextBaselineControl extends IFeathersControl
	{
		/**
		 * Returns the text baseline measurement, in pixels.
		 */
		function get baseline():Number;
	}
}
