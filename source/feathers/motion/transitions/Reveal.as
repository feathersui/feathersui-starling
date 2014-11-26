/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObject;

	public class Reveal
	{
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		public static function createRevealLeftTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new RevealTween(oldScreen, -oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					new RevealClipTween(newScreen, -newScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		public static function createRevealRightTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new RevealTween(oldScreen, oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					new RevealClipTween(newScreen, newScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		public static function createRevealUpTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new RevealTween(oldScreen, 0, -oldScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					new RevealClipTween(newScreen, 0, -newScreen.height, duration, ease, onComplete, tweenProperties);
				}
			}
		}

		public static function createRevealDownTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new RevealTween(oldScreen, 0, oldScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					new RevealClipTween(newScreen, 0, newScreen.height, duration, ease, onComplete, tweenProperties);
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
				var activeTween:Tween = RevealTween.SCREEN_TO_TWEEN[oldScreen] as Tween;
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

import flash.geom.Rectangle;
import flash.utils.Dictionary;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;

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
		this.target.x = 0;
		this.target.y = 0;
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}
}

class RevealClipTween extends Tween
{
	public function RevealClipTween(target:DisplayObject, xOffset:Number, yOffset:Number,
			duration:Number, ease:Object, onCompleteCallback:Function,
			tweenProperties:Object)
	{
		var clipRect:Rectangle = new Rectangle();
		if(xOffset === 0)
		{
			clipRect.width = target.width;
		}
		else if(xOffset < 0)
		{
			clipRect.x = -xOffset;
		}
		if(yOffset === 0)
		{
			clipRect.height = target.height;
		}
		else if(yOffset < 0)
		{
			clipRect.y = -yOffset;
		}
		this._temporaryParent = new Sprite();
		this._temporaryParent.clipRect = clipRect;
		target.parent.addChild(this._temporaryParent);
		this._temporaryParent.addChild(target);

		super(this._temporaryParent.clipRect, duration, ease);

		if(xOffset < 0)
		{
			this.animate("x", clipRect.x + xOffset);
			this.animate("width", -xOffset);
		}
		else if(xOffset > 0)
		{
			this.animate("width", xOffset);
		}
		if(yOffset < 0)
		{
			this.animate("y", clipRect.y + yOffset);
			this.animate("height", -yOffset);
		}
		else if(yOffset > 0)
		{
			this.animate("height", yOffset);
		}

		RevealTween.SCREEN_TO_TWEEN[target] = this;
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

	private var _temporaryParent:Sprite;
	private var _onCompleteCallback:Function;

	private function cleanupTween():void
	{
		var target:DisplayObject = this._temporaryParent.removeChildAt(0);
		this._temporaryParent.parent.addChild(target);
		this._temporaryParent.removeFromParent(true);
		delete RevealTween.SCREEN_TO_TWEEN[target];
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}

}

