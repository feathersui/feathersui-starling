/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

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

	[Exclude(name="createBlackFadeToBlackTransition",kind="method")]

	/**
	 * Creates animated transitions for screen navigators that fade a display
	 * object to a solid color.
	 *
	 * @see ../../../help/transitions.html#colorfade Transitions for Feathers screen navigators: ColorFade
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class ColorFade
	{
		/**
		 * @private
		 */
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		/**
		 * @private
		 * This was accidentally named wrong. It is included for temporary
		 * backward compatibility.
		 */
		public static function createBlackFadeToBlackTransition(duration:Number = 0.75, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return createBlackFadeTransition(duration, ease, tweenProperties);
		}

		/**
		 * Creates a transition function for a screen navigator that hides the
		 * old screen as a solid black color fades in over it. Then, the solid
		 * black color fades back out to show that the new screen has replaced
		 * the old screen.
		 *
		 * @see ../../../help/transitions.html#colorfade Transitions for Feathers screen navigators: ColorFade
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createBlackFadeTransition(duration:Number = 0.75, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return createColorFadeTransition(0x000000, duration, ease, tweenProperties);
		}

		/**
		 * Creates a transition function for a screen navigator that hides the old screen as a solid
		 * white color fades in over it. Then, the solid white color fades back
		 * out to show that the new screen has replaced the old screen.
		 *
		 * @see ../../../help/transitions.html#colorfade Transitions for Feathers screen navigators: ColorFade
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createWhiteFadeTransition(duration:Number = 0.75, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return createColorFadeTransition(0xffffff, duration, ease, tweenProperties);
		}

		/**
		 * Creates a transition function for a screen navigator that hides the
		 * old screen as a customizable solid color fades in over it. Then, the
		 * solid color fades back out to show that the new screen has replaced
		 * the old screen.
		 *
		 * @see ../../../help/transitions.html#colorfade Transitions for Feathers screen navigators: ColorFade
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createColorFadeTransition(color:uint, duration:Number = 0.75, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
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
					var tween:ColorFadeTween = new ColorFadeTween(newScreen, oldScreen, color, duration, ease, onComplete, tweenProperties);
				}
				else //we only have the old screen
				{
					oldScreen.alpha = 1;
					tween = new ColorFadeTween(oldScreen, null, color, duration, ease, onComplete, tweenProperties);
				}
				if(managed)
				{
					return new TweenEffectContext(null, tween);
				}
				Starling.juggler.add(tween);
				return null;
			};
		}
	}
}

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;

class ColorFadeTween extends Tween
{
	public function ColorFadeTween(target:DisplayObject, otherTarget:DisplayObject,
		color:uint, duration:Number, ease:Object, onCompleteCallback:Function,
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
			target.visible = false;
		}
		this.onUpdate = this.updateOverlay;
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;

		var navigator:DisplayObjectContainer = target.parent;
		this._overlay = new Quad(1, 1, color);
		this._overlay.width = navigator.width;
		this._overlay.height = navigator.height;
		this._overlay.alpha = 0;
		this._overlay.touchable = false;
		navigator.addChild(this._overlay);
	}

	private var _otherTarget:DisplayObject;
	private var _overlay:Quad;
	private var _onCompleteCallback:Function;

	private function updateOverlay():void
	{
		var progress:Number = this.progress;
		if(progress < 0.5)
		{
			target.visible = false;
			if(this._otherTarget)
			{
				this._otherTarget.visible = true;
			}
			this._overlay.alpha = progress * 2;
		}
		else
		{
			target.visible = true;
			if(this._otherTarget)
			{
				this._otherTarget.visible = false;
			}
			this._overlay.alpha = (1 - progress) * 2;
		}
	}

	private function cleanupTween():void
	{
		this._overlay.removeFromParent(true);
		this.target.visible = true;
		if(this._otherTarget)
		{
			this._otherTarget.visible = true;
		}
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}
}