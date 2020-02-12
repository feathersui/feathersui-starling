/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import feathers.motion.effectClasses.IEffectContext;
	import feathers.motion.effectClasses.TweenEffectContext;

	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	/**
	 * Creates animated transitions for screen navigators that slides two
	 * display objects in the same direction (replacing one with the other) like
	 * a classic slide carousel. Animates the <code>x</code> and <code>y</code>
	 * properties of the display objects. The display objects may slide up,
	 * right, down, or left.
	 *
	 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class Slide
	{
		/**
		 * @private
		 */
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		/**
		 * Creates a transition function for a screen navigator that slides the
		 * new screen to the left from off-stage, pushing the old screen in the
		 * same direction.
		 *
		 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createSlideLeftTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					if(oldScreen)
					{
						oldScreen.x = 0;
						oldScreen.y = 0;
					}
					newScreen.x = newScreen.width;
					newScreen.y = 0;
					var tween:SlideTween = new SlideTween(newScreen, oldScreen, -newScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					tween = new SlideTween(oldScreen, null, -oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
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
		 * Creates a transition function for a screen navigator that that slides
		 * the new screen to the right from off-stage, pushing the old screen in
		 * the same direction.
		 *
		 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createSlideRightTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					if(oldScreen)
					{
						oldScreen.x = 0;
						oldScreen.y = 0;
					}
					newScreen.x = -newScreen.width;
					newScreen.y = 0;
					var tween:SlideTween = new SlideTween(newScreen, oldScreen, newScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					tween = new SlideTween(oldScreen, null, oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
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
		 * Creates a transition function for a screen navigator that that slides
		 * the new screen up from off-stage, pushing the old screen in the same
		 * direction.
		 *
		 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createSlideUpTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					if(oldScreen)
					{
						oldScreen.x = 0;
						oldScreen.y = 0;
					}
					newScreen.x = 0;
					newScreen.y = newScreen.height;
					var tween:SlideTween = new SlideTween(newScreen, oldScreen, 0, -newScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					tween = new SlideTween(oldScreen, null, 0, -oldScreen.height, duration, ease, onComplete, tweenProperties);
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
		 * Creates a transition function for a screen navigator that that slides
		 * the new screen down from off-stage, pushing the old screen in the
		 * same direction.
		 *
		 * @see ../../../help/transitions.html#slide Transitions for Feathers screen navigators: Slide
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createSlideDownTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					if(oldScreen)
					{
						oldScreen.x = 0;
						oldScreen.y = 0;
					}
					newScreen.x = 0;
					newScreen.y = -newScreen.height;
					var tween:SlideTween = new SlideTween(newScreen, oldScreen, 0, newScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					tween = new SlideTween(oldScreen, null, 0, oldScreen.height, duration, ease, onComplete, tweenProperties);
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

class SlideTween extends Tween
{
	public function SlideTween(target:DisplayObject, otherTarget:DisplayObject,
		xOffset:Number, yOffset:Number, duration:Number, ease:Object,
		onCompleteCallback:Function, tweenProperties:Object)
	{
		super(target, duration, ease);
		if(xOffset != 0)
		{
			this._xOffset = xOffset;
			this.animate("x", target.x + xOffset);
		}
		if(yOffset != 0)
		{
			this._yOffset = yOffset;
			this.animate("y", target.y + yOffset);
		}
		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}
		this._navigator = target.parent;
		if(otherTarget)
		{
			this._otherTarget = otherTarget;
			this.onUpdate = this.updateOtherTarget;
		}
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
	}

	private var _navigator:DisplayObject;
	private var _otherTarget:DisplayObject;
	private var _onCompleteCallback:Function;
	private var _xOffset:Number = 0;
	private var _yOffset:Number = 0;

	private function updateOtherTarget():void
	{
		var newScreen:DisplayObject = DisplayObject(this.target);
		if(this._xOffset < 0)
		{
			this._otherTarget.x = newScreen.x - this._navigator.width;
		}
		else if(this._xOffset > 0)
		{
			this._otherTarget.x = newScreen.x + newScreen.width;
		}
		if(this._yOffset < 0)
		{
			this._otherTarget.y = newScreen.y - this._navigator.height;
		}
		else if(this._yOffset > 0)
		{
			this._otherTarget.y = newScreen.y + newScreen.height;
		}
	}

	private function cleanupTween():void
	{
		this.target.x = 0;
		this.target.y = 0;
		if(this._otherTarget)
		{
			this._otherTarget.x = 0;
			this._otherTarget.y = 0;
		}
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}
}