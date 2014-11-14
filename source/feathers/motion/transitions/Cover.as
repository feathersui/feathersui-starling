/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions
{
	import feathers.controls.IScreen;

	import starling.animation.Transitions;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class Cover
	{
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		public static function createCoverLeftTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				var navigator:DisplayObjectContainer;
				if(newScreen)
				{
					navigator = newScreen is IScreen ? IScreen(newScreen).owner : newScreen.parent;
					newScreen.x = navigator.width;
					newScreen.y = 0;
					new CoverTween(newScreen, -navigator.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					navigator = oldScreen is IScreen ? IScreen(oldScreen).owner : oldScreen.parent;
					new CoverTween(oldScreen, -navigator.width, 0, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		public static function createCoverRightTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				var navigator:DisplayObjectContainer;
				if(newScreen)
				{
					navigator = newScreen is IScreen ? IScreen(newScreen).owner : newScreen.parent;
					newScreen.x = -newScreen.width;
					newScreen.y = 0;
					new CoverTween(newScreen, navigator.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					navigator = oldScreen is IScreen ? IScreen(oldScreen).owner : oldScreen.parent;
					new CoverTween(oldScreen, navigator.width, 0, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		public static function createCoverUpTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				var navigator:DisplayObjectContainer;
				if(newScreen)
				{
					navigator = newScreen is IScreen ? IScreen(newScreen).owner : newScreen.parent;
					newScreen.x = 0;
					newScreen.y = navigator.height;
					new CoverTween(newScreen, 0, -navigator.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					navigator = oldScreen is IScreen ? IScreen(oldScreen).owner : oldScreen.parent;
					new CoverTween(oldScreen, 0, -navigator.height, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		public static function createCoverDownTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				var navigator:DisplayObjectContainer;
				if(newScreen)
				{
					navigator = newScreen is IScreen ? IScreen(newScreen).owner : newScreen.parent;
					newScreen.x = 0;
					newScreen.y = -newScreen.height;
					new CoverTween(newScreen, 0, navigator.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					navigator = oldScreen is IScreen ? IScreen(oldScreen).owner : oldScreen.parent;
					new CoverTween(oldScreen, 0, navigator.height, duration, ease, onComplete, tweenProperties);
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
				var activeTween:CoverTween = CoverTween.SCREEN_TO_TWEEN[oldScreen] as CoverTween;
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

class CoverTween extends Tween
{
	internal static const SCREEN_TO_TWEEN:Dictionary = new Dictionary(true);

	public function CoverTween(target:DisplayObject, xOffset:Number, yOffset:Number,
			duration:Number, ease:Object, onCompleteCallback:Function,
			tweenProperties:Object)
	{
		super(target, duration, ease);
		SCREEN_TO_TWEEN[target] = this;
		if(xOffset != 0)
		{
			this.animate("x", target.x + xOffset);
		}
		if(yOffset != 0)
		{
			this.animate("y", target.y + yOffset);
		}
		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
		Starling.juggler.add(this);
	}

	private var _onCompleteCallback:Function;

	private function cleanupTween():void
	{
		delete SCREEN_TO_TWEEN[this.target];
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}
}