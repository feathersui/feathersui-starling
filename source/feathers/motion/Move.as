/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import feathers.core.IFeathersControl;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import feathers.motion.effectClasses.IMoveEffectContext;
	import feathers.motion.effectClasses.TweenMoveEffectContext;
	import feathers.motion.effectClasses.TweenEffectContext;
	import feathers.motion.effectClasses.IEffectContext;

	/**
	 * Animates a component's <code>x</code> and <code>y</code> position. 
	 *
	 * @productversion Feathers 3.5.0
	 */
	public class Move
	{
		/**
		 * Creates an effect function for the target component that animates
		 * its x and y position when they are changed. Must be used with
		 * the <code>moveEffect</code> property.
		 * 
		 * @see feathers.core.FeathersControl#moveEffect
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createMoveEffect(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.STOP):Function
		{
			return function(target:DisplayObject):IMoveEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				var context:TweenMoveEffectContext = new TweenMoveEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its position from its current location to a new
		 * location.
		 *
		 * @productversion Feathers 3.5.0
		 * 
		 * @see #createMoveXToEffect()
		 * @see #createMoveYToEffect()
		 */
		public static function createMoveToEffect(toX:Number, toY:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.moveTo(toX, toY);
				var context:TweenEffectContext = new TweenEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>x</strong> position from its current location to
		 * a new location.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createMoveXToEffect(toX:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("x", toX);
				var context:TweenEffectContext = new TweenEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>y</strong> position from its current location to
		 * a new location.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createMoveYToEffect(toY:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("y", toY);
				var context:TweenEffectContext = new TweenEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its position from a specific location to its
		 * current location.
		 *
		 * @productversion Feathers 3.5.0
		 * 
		 * @see #createMoveXFromEffect()
		 * @see #createMoveYFromEffect()
		 */
		public static function createMoveFromEffect(fromX:Number, fromY:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var oldX:Number = target.x;
				var oldY:Number = target.y;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).suspendEffects();
				}
				target.x = fromX;
				target.y = fromY;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).resumeEffects();
				}
				var tween:Tween = new Tween(target, duration, ease);
				tween.moveTo(oldX, oldY);
				var context:TweenEffectContext = new TweenEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>x</strong> position from a specific location to
		 * its current location.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createMoveXFromEffect(fromX:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var oldX:Number = target.x;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).suspendEffects();
				}
				target.x = fromX;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).resumeEffects();
				}
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("x", oldX);
				var context:TweenEffectContext = new TweenEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>y</strong> position from a specific location to
		 * its current location.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createMoveYFromEffect(fromY:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var oldY:Number = target.y;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).suspendEffects();
				}
				target.y = fromY;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).resumeEffects();
				}
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("y", oldY);
				var context:TweenEffectContext = new TweenEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its position from its current location to a new
		 * location calculated by an offset.
		 *
		 * @productversion Feathers 3.5.0
		 * 
		 * @see #createMoveXByEffect()
		 * @see #createMoveYByEffect()
		 */
		public static function createMoveByEffect(xBy:Number, yBy:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.moveTo(target.x + xBy, target.y + yBy);
				var context:TweenEffectContext = new TweenEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>x</strong> position from its current location to
		 * a new location calculated by an offset.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createMoveXByEffect(xBy:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("x", target.x + xBy);
				var context:TweenEffectContext = new TweenEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>y</strong> position from its current location to
		 * a new location calculated by an offset.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createMoveYByEffect(yBy:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("y", target.y + yBy);
				var context:TweenEffectContext = new TweenEffectContext(tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}
	}
}