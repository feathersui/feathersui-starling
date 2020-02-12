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
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;

	/**
	 * Creates animated transitions for screen navigators that slide a display
	 * object out of view, by animating the <code>x</code> or <code>y</code>
	 * property, while revealing an existing display object that
	 * remains stationary below. The display object may slide up, right,
	 * down, or left.
	 *
	 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class Reveal
	{
		/**
		 * @private
		 */
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		/**
		 * Creates a transition function for a screen navigator that slides the
		 * old screen out of view to the left, animating the <code>x</code>
		 * property, to reveal the new screen under it. The new screen remains
		 * stationary.
		 *
		 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createRevealLeftTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
					var tween:RevealTween = new RevealTween(oldScreen, newScreen, -newScreen.width, 0, duration, ease, onComplete, tweenProperties);
					if(managed)
					{
						return new TweenEffectContext(null, tween);
					}
					Starling.juggler.add(tween);
					return null;
				}
				//we only have the old screen
				return slideOutOldScreen(oldScreen, -oldScreen.width, 0, duration, ease, tweenProperties, onComplete, managed);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that slides the
		 * old screen out of view to the right, animating the <code>x</code>
		 * property, to reveal the new screen under it. The new screen remains
		 * stationary.
		 *
		 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createRevealRightTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
					var tween:RevealTween = new RevealTween(oldScreen, newScreen, newScreen.width, 0, duration, ease, onComplete, tweenProperties);
					if(managed)
					{
						return new TweenEffectContext(null, tween);
					}
					Starling.juggler.add(tween);
					return null;
				}
				//we only have the old screen
				return slideOutOldScreen(oldScreen, oldScreen.width, 0, duration, ease, tweenProperties, onComplete, managed);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that slides the
		 * old screen up out of view, animating the <code>y</code> property, to
		 * reveal the new screen under it. The new screen remains stationary.
		 *
		 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createRevealUpTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
					var tween:RevealTween = new RevealTween(oldScreen, newScreen, 0, -newScreen.height, duration, ease, onComplete, tweenProperties);
					if(managed)
					{
						return new TweenEffectContext(null, tween);
					}
					Starling.juggler.add(tween);
					return null;
				}
				//we only have the old screen
				return slideOutOldScreen(oldScreen, 0, -oldScreen.height, duration, ease, tweenProperties, onComplete, managed);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that slides the
		 * old screen down out of view, animating the <code>y</code> property,
		 * to reveal the new screen under it. The new screen remains stationary.
		 *
		 * @see ../../../help/transitions.html#reveal Transitions for Feathers screen navigators: Reveal
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createRevealDownTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
				if(newScreen)
				{
					newScreen.x = 0;
					newScreen.y = 0;
					var tween:RevealTween = new RevealTween(oldScreen, newScreen, 0, newScreen.height, duration, ease, onComplete, tweenProperties);
					if(managed)
					{
						return new TweenEffectContext(null, tween);
					}
					Starling.juggler.add(tween);
					return null;
				}
				//we only have the old screen
				return slideOutOldScreen(oldScreen, 0, oldScreen.height, duration, ease, tweenProperties, onComplete, managed);
			}
		}

		/**
		 * @private
		 */
		private static function slideOutOldScreen(oldScreen:DisplayObject,
			xOffset:Number, yOffset:Number, duration:Number, ease:Object,
			tweenProperties:Object, onComplete:Function, managed:Boolean):IEffectContext
		{
			var tween:Tween = new Tween(oldScreen, duration, ease);
			if(xOffset != 0)
			{
				tween.animate("x", xOffset);
			}
			if(yOffset != 0)
			{
				tween.animate("y", yOffset);
			}
			if(tweenProperties)
			{
				for(var propertyName:String in tweenProperties)
				{
					tween[propertyName] = tweenProperties[propertyName];
				}
			}
			tween.onComplete = onComplete;
			if(managed)
			{
				return new TweenEffectContext(null, tween);
			}
			Starling.juggler.add(tween);
			return null;
		}
	}
}

import feathers.display.RenderDelegate;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;

class RevealTween extends Tween
{
	public function RevealTween(oldScreen:DisplayObject, newScreen:DisplayObject,
		xOffset:Number, yOffset:Number, duration:Number, ease:Object, onCompleteCallback:Function,
		tweenProperties:Object)
	{
		var mask:Quad = new Quad(1, 1, 0xff00ff);
		//the initial dimensions cannot be 0 or there's a runtime error
		mask.width = oldScreen.width;
		mask.height = oldScreen.height;
		mask.width = 0;
		mask.height = 0;
		if(xOffset == 0)
		{
			mask.width = newScreen.width;
		}
		else if(xOffset < 0)
		{
			mask.x = -xOffset;
		}
		if(yOffset == 0)
		{
			mask.height = newScreen.height;
		}
		else if(yOffset < 0)
		{
			mask.y = -yOffset;
		}
		this._temporaryParent = new Sprite();
		this._temporaryParent.mask = mask;
		newScreen.parent.addChild(this._temporaryParent);
		var delegate:RenderDelegate = new RenderDelegate(newScreen);
		delegate.alpha = newScreen.alpha;
		delegate.blendMode = newScreen.blendMode;
		delegate.rotation = newScreen.rotation;
		delegate.scaleX = newScreen.scaleX;
		delegate.scaleY = newScreen.scaleY;
		this._temporaryParent.addChild(delegate);
		newScreen.visible = false;
		this._savedNewScreen = newScreen;

		super(this._temporaryParent.mask, duration, ease);

		if(xOffset < 0)
		{
			this.animate("x", mask.x + xOffset);
			this.animate("width", -xOffset);
		}
		else if(xOffset > 0)
		{
			this.animate("width", xOffset);
		}
		if(yOffset < 0)
		{
			this.animate("y", mask.y + yOffset);
			this.animate("height", -yOffset);
		}
		else if(yOffset > 0)
		{
			this.animate("height", yOffset);
		}

		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}
		this._onCompleteCallback = onCompleteCallback;
		if(oldScreen)
		{
			this._savedOldScreen = oldScreen;
			this._savedXOffset = xOffset;
			this._savedYOffset = yOffset;
			this.onUpdate = this.updateOldScreen;
		}
		this.onComplete = this.cleanupTween;
	}

	private var _savedXOffset:Number;
	private var _savedYOffset:Number;
	private var _savedNewScreen:DisplayObject;
	private var _savedOldScreen:DisplayObject;
	private var _temporaryParent:Sprite;
	private var _onCompleteCallback:Function;

	private function updateOldScreen():void
	{
		var mask:Quad = Quad(this.target);
		if(this._savedXOffset < 0)
		{
			this._savedOldScreen.x = -mask.width;
		}
		else if(this._savedXOffset > 0)
		{
			this._savedOldScreen.x = mask.width;
		}
		if(this._savedYOffset < 0)
		{
			this._savedOldScreen.y = -mask.height;
		}
		else if(this._savedYOffset > 0)
		{
			this._savedOldScreen.y = mask.height;
		}
	}

	private function cleanupTween():void
	{
		this._temporaryParent.removeFromParent(true);
		this._temporaryParent = null;
		this._savedNewScreen.visible = true;
		this._savedNewScreen = null;
		if(this._savedOldScreen)
		{
			this._savedOldScreen.x = 0;
			this._savedOldScreen.y = 0;
			this._savedOldScreen = null;
		}
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}

}