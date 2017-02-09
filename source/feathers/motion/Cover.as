/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	/**
	 * Creates animated effects, like transitions for screen navigators, that
	 * slide a display object into view, animating the `x` or `y` property, to
	 * cover the content below it.
	 *
	 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class Cover
	{
		/**
		 * @private
		 */
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		/**
		 * Creates a transition function for a screen navigator that slides the
		 * new screen into view to the left, animating the `x` property, to
		 * cover up the old screen, which remains stationary.
		 *
		 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createCoverLeftTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.x = newScreen.width;
					newScreen.y = 0;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new CoverTween(newScreen, oldScreen, -oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
				}
			}
		}

		/**
		 * Creates a transition function for a screen navigator that slides the
		 * new screen into view to the right, animating the `x` property, to
		 * cover up the old screen, which remains stationary.
		 *
		 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createCoverRightTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.x = -newScreen.width;
					newScreen.y = 0;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new CoverTween(newScreen, oldScreen, oldScreen.width, 0, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
				}
			}
		}

		/**
		 * Creates a transition function for a screen navigator that slides the
		 * new screen up into view, animating the `y` property, to cover up the
		 * old screen, which remains stationary.
		 *
		 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createCoverUpTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = newScreen.height;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new CoverTween(newScreen, oldScreen, 0, -oldScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
				}
			}
		}

		/**
		 * Creates a transition function for a screen navigator that slides the
		 * new screen down into view, animating the `y` property, to cover up the
		 * old screen, which remains stationary.
		 *
		 * @see ../../../help/transitions.html#cover Transitions for Feathers screen navigators: Cover
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createCoverDownTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = -newScreen.height;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
					new CoverTween(newScreen, oldScreen, 0, oldScreen.height, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the new screen
				{
					slideInNewScreen(newScreen, duration, ease, tweenProperties, onComplete);
				}
			}
		}

		/**
		 * @private
		 */
		private static function slideInNewScreen(newScreen:DisplayObject,
			duration:Number, ease:Object, tweenProperties:Object, onComplete:Function):void
		{
			var tween:Tween = new Tween(newScreen, duration, ease);
			if(newScreen.x != 0)
			{
				tween.animate("x", 0);
			}
			if(newScreen.y !== 0)
			{
				tween.animate("y", 0);
			}
			if(tweenProperties)
			{
				for(var propertyName:String in tweenProperties)
				{
					tween[propertyName] = tweenProperties[propertyName];
				}
			}
			tween.onComplete = onComplete;
			Starling.juggler.add(tween);
		}
	}
}

import feathers.display.RenderDelegate;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;

class CoverTween extends Tween
{
	public function CoverTween(newScreen:DisplayObject, oldScreen:DisplayObject,
		xOffset:Number, yOffset:Number, duration:Number, ease:Object, onCompleteCallback:Function,
		tweenProperties:Object)
	{
		var mask:Quad = new Quad(1, 1, 0xff00ff);
		//the initial dimensions cannot be 0 or there's a runtime error,
		//and these values might be 0
		mask.width = oldScreen.width;
		mask.height = oldScreen.height;
		this._temporaryParent = new Sprite();
		this._temporaryParent.mask = mask;
		oldScreen.parent.addChild(this._temporaryParent);
		var delegate:RenderDelegate = new RenderDelegate(oldScreen);
		delegate.alpha = oldScreen.alpha;
		delegate.blendMode = oldScreen.blendMode;
		delegate.rotation = oldScreen.rotation;
		delegate.scaleX = oldScreen.scaleX;
		delegate.scaleY = oldScreen.scaleY;
		this._temporaryParent.addChild(delegate);
		oldScreen.visible = false;
		this._savedOldScreen = oldScreen;

		super(this._temporaryParent.mask, duration, ease);

		if(xOffset < 0)
		{
			this.animate("width", 0);
		}
		else if(xOffset > 0)
		{
			this.animate("x", xOffset);
			this.animate("width", 0);
		}
		if(yOffset < 0)
		{
			this.animate("height", 0);
		}
		else if(yOffset > 0)
		{
			this.animate("y", yOffset);
			this.animate("height", 0);
		}
		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}
		this._onCompleteCallback = onCompleteCallback;
		if(newScreen)
		{
			this._savedNewScreen = newScreen;
			this._savedXOffset = xOffset;
			this._savedYOffset = yOffset;
			this.onUpdate = this.updateNewScreen;
		}
		this.onComplete = this.cleanupTween;
		Starling.juggler.add(this);
	}

	private var _savedXOffset:Number;
	private var _savedYOffset:Number;
	private var _savedOldScreen:DisplayObject;
	private var _savedNewScreen:DisplayObject;
	private var _temporaryParent:Sprite;
	private var _onCompleteCallback:Function;

	private function updateNewScreen():void
	{
		var mask:Quad = Quad(this._temporaryParent.mask);
		if(this._savedXOffset < 0)
		{
			this._savedNewScreen.x = mask.width;
		}
		else if(this._savedXOffset > 0)
		{
			this._savedNewScreen.x = -mask.width;
		}
		if(this._savedYOffset < 0)
		{
			this._savedNewScreen.y = mask.height;
		}
		else if(this._savedYOffset > 0)
		{
			this._savedNewScreen.y = -mask.height;
		}
	}

	private function cleanupTween():void
	{
		this._temporaryParent.removeFromParent(true);
		this._temporaryParent = null;
		this._savedOldScreen.visible = true;
		this._savedNewScreen = null;
		this._savedOldScreen = null;
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}

}

