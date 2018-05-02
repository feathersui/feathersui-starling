/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	/**
	 * Constants for determining how an effect behaves when it is interrupted.
	 * 
	 * @see feathers.motion.effectClasses.IEffectContext#interrupt()
	 * @see ../../../help/effects.html Effects and animation for Feathers components
	 *
	 * @productversion Feathers 3.5.0
	 */
	public class EffectInterruptBehavior
	{
		/**
		 * When the effect is interrupted, it stops at its current position.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static const STOP:String = "stop";

		/**
		 * When the effect is interrupted, it immediately advances to the end.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static const END:String = "end";
	}
}