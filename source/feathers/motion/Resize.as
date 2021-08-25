/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import feathers.core.IFeathersControl;
	import feathers.motion.effectClasses.IEffectContext;
	import feathers.motion.effectClasses.IResizeEffectContext;
	import feathers.motion.effectClasses.TweenEffectContext;
	import feathers.motion.effectClasses.TweenResizeEffectContext;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObject;

	/**
	 * An effect that animates a component's <code>width</code> and
	 * <code>height</code> dimensions. 
	 * 
	 * @see ../../../help/effects.html Effects and animation for Feathers components
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
		public static function createResizeEffect(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "stop"):Function
		{
			return function(target:DisplayObject):IResizeEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				var context:TweenResizeEffectContext = new TweenResizeEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its dimensions from their current values to new values.
		 *
		 * @productversion Feathers 3.5.0
		 * 
		 * @see #createResizeWidthToEffect()
		 * @see #createResizeHeightToEffect()
		 */
		public static function createResizeToEffect(toWidth:Number, toHeight:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "end"):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("width", toWidth);
				tween.animate("height", toHeight);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>width</strong> from its current value to a new
		 * value.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeWidthToEffect(toWidth:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "end"):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("width", toWidth);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>height</strong> from its current value to a new
		 * value.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeHeightToEffect(toHeight:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "end"):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("height", toHeight);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its dimensions from specific values to its
		 * current values.
		 *
		 * @productversion Feathers 3.5.0
		 * 
		 * @see #createResizeWidthFromEffect()
		 * @see createResizeHeightFromEffect()
		 */
		public static function createResizeFromEffect(fromWidth:Number, fromHeight:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "end"):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var oldWidth:Number = target.width;
				var oldHeight:Number = target.height;
				if(target is IFeathersControl)
				{
					var oldExplicitWidth:Number = IFeathersControl(target).explicitWidth;
					var oldExplicitHeight:Number = IFeathersControl(target).explicitHeight;
					if(oldExplicitWidth === oldExplicitWidth || //!isNaN
						oldExplicitHeight === oldExplicitHeight) //!isNaN
					{
						tween.onComplete = function():void
						{
							//restore the original explicit height
							target.width = oldExplicitWidth;
							target.height = oldExplicitHeight;
						};
					}
					IFeathersControl(target).suspendEffects();
				}
				target.width = fromWidth;
				target.height = fromHeight;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).resumeEffects();
				}
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("width", oldWidth);
				tween.animate("height", oldHeight);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>width</strong> from a specific value to its
		 * current value.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeWidthFromEffect(fromWidth:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "end"):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var oldWidth:Number = target.width;
				if(target is IFeathersControl)
				{
					var oldExplicitWidth:Number = IFeathersControl(target).explicitWidth;
					if(oldExplicitWidth === oldExplicitWidth) //!isNaN
					{
						tween.onComplete = function():void
						{
							//restore the original explicit width
							target.width = oldExplicitWidth;
						};
					}
					IFeathersControl(target).suspendEffects();
				}
				target.width = fromWidth;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).resumeEffects();
				}
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("width", oldWidth);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>height</strong> from a specific value to its
		 * current value.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeHeightFromEffect(fromHeight:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "end"):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var oldHeight:Number = target.height;
				if(target is IFeathersControl)
				{
					var oldExplicitHeight:Number = IFeathersControl(target).explicitHeight;
					if(oldExplicitHeight === oldExplicitHeight) //!isNaN
					{
						tween.onComplete = function():void
						{
							//restore the original explicit height
							target.height = oldExplicitHeight;
						};
					}
					IFeathersControl(target).suspendEffects();
				}
				target.height = fromHeight;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).resumeEffects();
				}
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("height", oldHeight);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its dimensions from its current values to new values
		 * calculated by an offset.
		 *
		 * @productversion Feathers 3.5.0
		 * 
		 * @see #createResizeWidthByEffect()
		 * @see #createResizeHeightByEffect()
		 */
		public static function createResizeByEffect(widthBy:Number, heightBy:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "end"):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("width", target.width + widthBy);
				tween.animate("height", target.height + heightBy);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>width</strong> from its current value to a new
		 * value calculated by an offset.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeWidthByEffect(widthBy:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "end"):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("width", target.width + widthBy);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function for the target component that
		 * animates its <strong>height</strong> from its current value to a new
		 * value calculated by an offset.
		 *
		 * @productversion Feathers 3.5.0
		 */
		public static function createResizeHeightByEffect(heightBy:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = "end"):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.animate("height", target.height + heightBy);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}
	}
}