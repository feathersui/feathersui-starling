/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import feathers.core.IFeathersControl;
	import feathers.motion.effectClasses.IEffectContext;
	import feathers.motion.effectClasses.TweenEffectContext;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	/**
	 * Creates effects for Feathers components and transitions for screen
	 * navigators, that animate the <code>alpha</code> property of a display
	 * object to make it fade in or out.
	 * 
	 * @see ../../../help/effects.html Effects and animation for Feathers components
	 * @see ../../../help/transitions.html#fade Transitions for Feathers screen navigators: Fade
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class Fade
	{
		/**
		 * @private
		 */
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		/**
		 * Creates an effect function that fades in the target component by
		 * animating the <code>alpha</code> property from its current value to
		 * <code>1.0</code>.
		 * 
		 * <p>To force the target to start at a specific <code>alpha</code>
		 * value (such as <code>0.0</code>), use
		 * <code>createFadeBetweenEffect()</code> instead.</p>
		 * 
		 * @see ../../../help/effects.html Effects and animation for Feathers components
		 * @see #createFadeOutEffect()
		 * @see #createFadeBetweenEffect()
		 */
		public static function createFadeInEffect(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return createFadeToEffect(1, duration, ease, interruptBehavior);
		}

		/**
		 * Creates an effect function that fades out the target component by
		 * animating the <code>alpha</code> property from its current value to
		 * <code>0.0</code>.
		 * 
		 * <p>To force the target to start at a specific <code>alpha</code>
		 * value (such as <code>1.0</code>), use
		 * <code>createFadeBetweenEffect()</code> instead.</p>
		 * 
		 * @see ../../../help/effects.html Effects and animation for Feathers components
		 * @see #createFadeInEffect()
		 * @see #createFadeBetweenEffect()
		 */
		public static function createFadeOutEffect(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return createFadeToEffect(0, duration, ease, interruptBehavior);
		}

		/**
		 * Creates an effect function that fades the target component by
		 * animating the <code>alpha</code> property from its current value to a new
		 * value.
		 * 
		 * @see ../../../help/effects.html Effects and animation for Feathers components
		 * @see #createFadeFromEffect()
		 * @see #createFadeBetweenEffect()
		 */
		public static function createFadeToEffect(endAlpha:Number, duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var tween:Tween = new Tween(target, duration, ease);
				tween.fadeTo(endAlpha);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function that fades the target component by
		 * animating the <code>alpha</code> property from a start value to its
		 * current value.
		 * 
		 * @see ../../../help/effects.html Effects and animation for Feathers components
		 * @see #createFadeToEffect()
		 * @see #createFadeBetweenEffect()
		 */
		public static function createFadeFromEffect(startAlpha:Number, duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				var endAlpha:Number = target.alpha;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).suspendEffects();
				}
				target.alpha = startAlpha;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).resumeEffects();
				}
				var tween:Tween = new Tween(target, duration, ease);
				tween.fadeTo(endAlpha);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates an effect function that fades the target component by
		 * animating the <code>alpha</code> property between a start value and an ending
		 * value.
		 * 
		 * @see ../../../help/effects.html Effects and animation for Feathers components
		 */
		public static function createFadeBetweenEffect(startAlpha:Number, endAlpha:Number, duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, interruptBehavior:String = EffectInterruptBehavior.END):Function
		{
			return function(target:DisplayObject):IEffectContext
			{
				if(target is IFeathersControl)
				{
					IFeathersControl(target).suspendEffects();
				}
				target.alpha = startAlpha;
				if(target is IFeathersControl)
				{
					IFeathersControl(target).resumeEffects();
				}
				var tween:Tween = new Tween(target, duration, ease);
				tween.fadeTo(endAlpha);
				var context:TweenEffectContext = new TweenEffectContext(target, tween);
				context.interruptBehavior = interruptBehavior;
				return context;
			}
		}

		/**
		 * Creates a transition function for a screen navigator that fades in
		 * the new screen by animating the <code>alpha</code> property from
		 * <code>0.0</code> to <code>1.0</code>, while the old screen remains
		 * fully opaque at a lower depth.
		 *
		 * @see ../../../help/transitions.html#fade Transitions for Feathers screen navigators: Fade
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createFadeInTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.alpha = 0;
					//make sure the new screen is on top
					var parent:DisplayObjectContainer = newScreen.parent;
					parent.setChildIndex(newScreen, parent.numChildren - 1);
					if(oldScreen) //oldScreen can be null, that's okay
					{
						oldScreen.alpha = 1;
					}
					var tween:FadeTween = new FadeTween(newScreen, oldScreen, duration, ease, onComplete, tweenProperties);
				}
				else
				{
					//there's no new screen to fade in, but we still want some
					//kind of animation, so we'll just fade out the old screen
					//in order to have some animation, we're going to fade out
					oldScreen.alpha = 1;
					tween = new FadeTween(oldScreen, null, duration, ease, onComplete, tweenProperties);
				}
				if(managed)
				{
					return new TweenEffectContext(null, tween);
				}
				Starling.juggler.add(tween);
				return null;
			}
		}

		/**
		 * Creates a transition function for a screen navigator that fades out
		 * the old screen by animating the <code>alpha</code> property from
		 * <code>1.0</code> to <code>0.0</code>, while the new screen remains
		 * fully opaque at a lower depth.
		 *
		 * @see ../../../help/transitions.html#fade Transitions for Feathers screen navigators: Fade
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createFadeOutTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(oldScreen)
				{
					//make sure the old screen is on top
					var parent:DisplayObjectContainer = oldScreen.parent;
					parent.setChildIndex(oldScreen, parent.numChildren - 1);
					oldScreen.alpha = 1;
					if(newScreen) //newScreen can be null, that's okay
					{
						newScreen.alpha = 1;
					}
					var tween:FadeTween = new FadeTween(oldScreen, null, duration, ease, onComplete, tweenProperties);
				}
				else
				{
					//there's no old screen to fade out, but we still want some
					//kind of animation, so we'll just fade in the new screen
					//in order to have some animation, we're going to fade out
					newScreen.alpha = 0;
					tween = new FadeTween(newScreen, null, duration, ease, onComplete, tweenProperties);
				}
				if(managed)
				{
					return new TweenEffectContext(null, tween);
				}
				Starling.juggler.add(tween);
				return null;
			}
		}

		/**
		 * Creates a transition function for a screen navigator that crossfades
		 * the screens. In other words, the old screen fades out, animating the
		 * <code>alpha</code> property from <code>1.0</code> to
		 * <code>0.0</code>. Simultaneously, the new screen fades in, animating
		 * its <code>alpha</code> property from <code>0.0</code> to <code>1.0</code>.
		 *
		 * @see ../../../help/transitions.html#fade Transitions for Feathers screen navigators: Fade
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createCrossfadeTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.alpha = 0;
					if(oldScreen) //oldScreen can be null, that's okay
					{
						oldScreen.alpha = 1;
					}
					var tween:FadeTween = new FadeTween(newScreen, oldScreen, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.alpha = 1;
					tween = new FadeTween(oldScreen, null, duration, ease, onComplete, tweenProperties);
				}
				if(managed)
				{
					return new TweenEffectContext(null, tween);
				}
				Starling.juggler.add(tween);
				return null;
			}
		}
	}
}

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

class FadeTween extends Tween
{
	public function FadeTween(target:DisplayObject, otherTarget:DisplayObject,
		duration:Number, ease:Object, onCompleteCallback:Function,
		tweenProperties:Object)
	{
		super(target, duration, ease);
		if(target.alpha == 0)
		{
			this.fadeTo(1);
		}
		else
		{
			this.fadeTo(0);
		}
		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}
		if(otherTarget)
		{
			this._otherTarget = otherTarget;
			this.onUpdate = this.updateOtherTarget;
		}
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
	}

	private var _otherTarget:DisplayObject;
	private var _onCompleteCallback:Function;

	private function updateOtherTarget():void
	{
		var newScreen:DisplayObject = DisplayObject(this.target);
		this._otherTarget.alpha = 1 - newScreen.alpha;
	}

	private function cleanupTween():void
	{
		this.target.alpha = 1;
		if(this._otherTarget)
		{
			this._otherTarget.alpha = 1;
		}
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}
}