/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import feathers.core.IFeathersControl;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObject;

	/**
	 * Animates a component's <code>width</code> and <code>height</code> dimensions. 
	 *
	 * @productversion Feathers 3.5.0
	 */
	public class Resize
	{
		/**
		 * Creates an effect function for the target component that animates
		 * its dimensions when they are changed. Must be used with the
		 * <code>resizeEffect</code> property.
		 * 
		 * @see feathers.core.FeathersControl#resizeEffect
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeEffect(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT):Function
		{
			return function(target:DisplayObject):IResizeEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				return new TweenResizeEffectContext(tween);
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its dimensions from their current values to new values.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeToEffect(toWidth:Number, toHeight:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("width", toWidth);
				tween.animate("height", toHeight);
				return new TweenEffectContext(tween);
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its dimensions from specific values to its
		 * current values.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeFromEffect(fromX:Number, fromY:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var oldWidth:Number = target.width;
				var oldHeight:Number = target.height;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).suspendEffects();
				}
				target.width = fromX;
				target.height = fromY;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).resumeEffects();
				}
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("width", oldWidth);
				tween.animate("height", oldHeight);
				return new TweenEffectContext(tween);
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its position from its current location to a new
		 * location calculated by an offset.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeByEffect(widthBy:Number, heightBy:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("width", target.width + widthBy);
				tween.animate("height", target.height + heightBy);
				return new TweenEffectContext(tween);
			}
		}
	}
}