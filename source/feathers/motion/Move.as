/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import starling.animation.Transitions;
	import starling.display.DisplayObject;
	import starling.animation.Tween;

	/**
	 * Animates a component's <code>x</code> and <code>y</code> position. 
	 *
	 * @productversion Feathers 3.5.0
	 */
	public class Move
	{
		/**
		 * Creates an effect function for the target component that shows the
		 * component by masking it with a growing circle in the center.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createMoveEffect(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT):Function
		{
			return function(target:DisplayObject):IMoveEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.moveTo(target.x, target.y);
				return new TweenMoveEffectContext(tween);
			}
		}
	}
}