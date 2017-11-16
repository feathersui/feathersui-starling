/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	/**
	 * Gives a component the ability to control an effect.
	 */
	public interface IEffectContext
	{
		function get position():Number;
		function set position(value:Number):void;
	}	
}