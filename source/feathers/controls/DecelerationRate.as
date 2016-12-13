/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Deceleration rate, per millisecond.
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class DecelerationRate
	{
		/**
		 * The default deceleration rate per millisecond.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const NORMAL:Number = 0.998;

		/**
		 * Decelerates a bit faster than the normal amount.
		 * 
		 * @see #NORMAL
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const FAST:Number = 0.99;
	}
}
