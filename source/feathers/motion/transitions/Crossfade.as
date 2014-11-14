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

	public class Crossfade
	{
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		public static function createCrossfadeTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}

				if(oldScreen)
				{
					var activeTween:CrossfadeTween = CrossfadeTween.SCREEN_TO_TWEEN[oldScreen] as CrossfadeTween;
					if(activeTween)
					{
						//force the existing tween to finish so that the
						//properties of the old screen end up in a good state.
						activeTween.advanceTime(activeTween.totalTime);
					}
				}

				if(newScreen)
				{
					newScreen.alpha = 0;
					if(oldScreen) //oldScreen can be null, that's okay
					{
						oldScreen.alpha = 1;
					}
					new CrossfadeTween(newScreen, oldScreen, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.alpha = 1;
					new CrossfadeTween(oldScreen, null, duration, ease, onComplete, tweenProperties);
				}
			}
		}
	}
}

import flash.utils.Dictionary;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

class CrossfadeTween extends Tween
{
	internal static const SCREEN_TO_TWEEN:Dictionary = new Dictionary(true);

	public function CrossfadeTween(target:DisplayObject, otherTarget:DisplayObject,
		duration:Number, ease:Object, onCompleteCallback:Function,
		tweenProperties:Object)
	{
		super(target, duration, ease);
		SCREEN_TO_TWEEN[target] = this;
		if(target.alpha == 0)
		{
			this.fadeTo(1);
		}
		else
		{
			this.fadeTo(0);
		}
		if(otherTarget)
		{
			this._otherTarget = otherTarget;
			this.onUpdate = this.updateOtherTarget;
		}
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}
		Starling.juggler.add(this);
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
		delete SCREEN_TO_TWEEN[this.target];
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}
}