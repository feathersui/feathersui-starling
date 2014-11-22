/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions
{
	import starling.animation.Transitions;
	import starling.display.DisplayObject;

	public class Slide
	{
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		public static function createSlideLeftTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);

				if(newScreen)
				{
					if(oldScreen)
					{
						oldScreen.x = 0;
						oldScreen.y = 0;
					}
					newScreen.x = newScreen.width;
					newScreen.y = 0;
					new SlideTween(newScreen, oldScreen, -newScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new SlideTween(oldScreen, null, -oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		public static function createSlideRightTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);

				if(newScreen)
				{
					if(oldScreen)
					{
						oldScreen.x = 0;
						oldScreen.y = 0;
					}
					newScreen.x = -newScreen.width;
					newScreen.y = 0;
					new SlideTween(newScreen, oldScreen, newScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new SlideTween(oldScreen, null, oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		public static function createSlideUpTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);

				if(newScreen)
				{
					if(oldScreen)
					{
						oldScreen.x = 0;
						oldScreen.y = 0;
					}
					newScreen.x = 0;
					newScreen.y = newScreen.height;
					new SlideTween(newScreen, oldScreen, 0, -newScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new SlideTween(oldScreen, null, 0, -oldScreen.height, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		public static function createSlideDownTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);

				if(newScreen)
				{
					if(oldScreen)
					{
						oldScreen.x = 0;
						oldScreen.y = 0;
					}
					newScreen.x = 0;
					newScreen.y = -newScreen.height;
					new SlideTween(newScreen, oldScreen, 0, newScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new SlideTween(oldScreen, null, 0, oldScreen.height, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		private static function validateAndCleanup(oldScreen:DisplayObject, newScreen:DisplayObject):void
		{
			if(!oldScreen && !newScreen)
			{
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);
			}

			if(oldScreen)
			{
				var activeTween:SlideTween = SlideTween.SCREEN_TO_TWEEN[oldScreen] as SlideTween;
				if(activeTween)
				{
					//force the existing tween to finish so that the
					//properties of the old screen end up in a good state.
					activeTween.advanceTime(activeTween.totalTime);
				}
			}
		}
	}
}

import flash.utils.Dictionary;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

class SlideTween extends Tween
{
	internal static const SCREEN_TO_TWEEN:Dictionary = new Dictionary(true);

	public function SlideTween(target:DisplayObject, otherTarget:DisplayObject,
		xOffset:Number, yOffset:Number, duration:Number, ease:Object,
		onCompleteCallback:Function, tweenProperties:Object)
	{
		super(target, duration, ease);
		SCREEN_TO_TWEEN[target] = this;
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
		Starling.juggler.add(this);
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
		delete SCREEN_TO_TWEEN[this.target];
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