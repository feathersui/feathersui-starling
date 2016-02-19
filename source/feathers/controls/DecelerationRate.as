/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Deceleration rate, per millisecond.
	 */
	public class DecelerationRate
	{
		/**
		 * The default deceleration rate per millisecond.
		 */
		public static const NORMAL:Number = 0.998;

		/**
		 * Decelerates a bit faster than the normal amount.
		 * 
		 * @see #NORMAL
		 */
		public static const FAST:Number = 0.99;
	}
}
