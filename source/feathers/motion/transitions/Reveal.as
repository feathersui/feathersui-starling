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

	public class Reveal
	{
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		public static function createRevealLeftTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
				}
				var navigator:DisplayObjectContainer;
				if(oldScreen)
				{
					navigator = oldScreen is IScreen ? IScreen(oldScreen).owner : oldScreen.parent;
					oldScreen.x = 0;
					oldScreen.y = 0;
					new RevealTween(oldScreen, -navigator.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					if(onComplete !== null)
					{
						onComplete();
					}
				}
			}
		}

		public static function createRevealRightTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
				}
				var navigator:DisplayObjectContainer;
				if(oldScreen)
				{
					navigator = oldScreen is IScreen ? IScreen(oldScreen).owner : oldScreen.parent;
					oldScreen.x = 0;
					oldScreen.y = 0;
					new RevealTween(oldScreen, navigator.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					if(onComplete !== null)
					{
						onComplete();
					}
				}
			}
		}

		public static function createRevealUpTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
				}
				var navigator:DisplayObjectContainer;
				if(oldScreen)
				{
					navigator = oldScreen is IScreen ? IScreen(oldScreen).owner : oldScreen.parent;
					oldScreen.x = 0;
					oldScreen.y = 0;
					new RevealTween(oldScreen, 0, -navigator.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					if(onComplete !== null)
					{
						onComplete();
					}
				}
			}
		}

		public static function createRevealDownTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
				}
				var navigator:DisplayObjectContainer;
				if(oldScreen)
				{
					navigator = oldScreen is IScreen ? IScreen(oldScreen).owner : oldScreen.parent;
					oldScreen.x = 0;
					oldScreen.y = 0;
					new RevealTween(oldScreen, 0, navigator.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					if(onComplete !== null)
					{
						onComplete();
					}
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
				var activeTween:RevealTween = RevealTween.SCREEN_TO_TWEEN[oldScreen] as RevealTween;
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
import starling.display.DisplayObjectContainer;

class RevealTween extends Tween
{
	internal static const SCREEN_TO_TWEEN:Dictionary = new Dictionary(true);

	public function RevealTween(target:DisplayObject, xOffset:Number, yOffset:Number,
			duration:Number, ease:Object, onCompleteCallback:Function,
			tweenProperties:Object)
	{
		super(target, duration, ease);
		var parent:DisplayObjectContainer = target.parent;
		parent.setChildIndex(target, parent.numChildren - 1);
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