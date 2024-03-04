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

	/**
	 * Creates animated transitions for screen navigators that position display
	 * objects in 3D space is if they are printed on opposite sides of a
	 * postcard. A display object may appear on the front or back side, and the
	 * card rotates around its center to reveal the other side. The card may
	 * rotate up or down around the x-axis, or they may rotate left or right
	 * around the y-axis.
	 *
	 * <p>Warning: <code>Flip</code> and other transitions with 3D effects may
	 * not be compatible with masks.</p>
	 *
	 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
	 *
	 * @productversion Feathers 2.1.0
	 */
	public class Flip
	{
		/**
		 * @private
		 */
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		/**
		 * Creates a transition function for a screen navigator that positions
		 * the screens in 3D space is if they are printed on opposite sides of a
		 * postcard, and the card rotates left, around its y-axis, to reveal the
		 * new screen on the back side.
		 *
		 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createFlipLeftTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				var tween:FlipTween = new FlipTween(newScreen, oldScreen, Math.PI, 0, duration, ease, onComplete, tweenProperties);
				if(managed)
				{
					return new TweenEffectContext(null, tween);
				}
				Starling.juggler.add(tween);
				return null;
			};
		}

		/**
		 * Creates a transition function for a screen navigator that positions
		 * the screens in 3D space is if they are printed on opposite sides of a
		 * postcard, and the card rotates right, around its y-axis, to reveal
		 * the new screen on the back side.
		 *
		 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createFlipRightTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				var tween:FlipTween = new FlipTween(newScreen, oldScreen, -Math.PI, 0, duration, ease, onComplete, tweenProperties);
				if(managed)
				{
					return new TweenEffectContext(null, tween);
				}
				Starling.juggler.add(tween);
				return null;
			};
		}

		/**
		 * Creates a transition function for a screen navigator that positions
		 * the screens in 3D space is if they are printed on opposite sides of a
		 * postcard, and the card rotates up, around its x-axis, to reveal the
		 * new screen on the back side.
		 *
		 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createFlipUpTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				var tween:FlipTween = new FlipTween(newScreen, oldScreen, 0, -Math.PI, duration, ease, onComplete, tweenProperties);
				if(managed)
				{
					return new TweenEffectContext(null, tween);
				}
				Starling.juggler.add(tween);
				return null;
			};
		}

		/**
		 * Creates a transition function for a screen navigator that positions
		 * the screens in 3D space is if they are printed on opposite sides of a
		 * postcard, and the card rotates down, around its x-axis, to reveal the
		 * new screen on the back side.
		 *
		 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createFlipDownTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function, managed:Boolean = false):IEffectContext
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				var tween:FlipTween = new FlipTween(newScreen, oldScreen, 0, Math.PI, duration, ease, onComplete, tweenProperties);
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

import feathers.display.RenderDelegate;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite3D;

class FlipTween extends Tween
{
	public function FlipTween(newScreen:DisplayObject, oldScreen:DisplayObject,
		rotationYOffset:Number, rotationXOffset:Number,
		duration:Number, ease:Object, onCompleteCallback:Function,
		tweenProperties:Object)
	{

		if(newScreen)
		{
			this._navigator = newScreen.parent;
			var newScreenParent:Sprite3D = new Sprite3D();
			var delegate:RenderDelegate = new RenderDelegate(newScreen);
			delegate.alpha = newScreen.alpha;
			delegate.blendMode = newScreen.blendMode;
			delegate.rotation = newScreen.rotation;
			delegate.scaleX = newScreen.scaleX;
			delegate.scaleY = newScreen.scaleY;
			if(rotationYOffset != 0)
			{
				delegate.x = -newScreen.width / 2;
				newScreenParent.x = newScreen.width / 2;
				newScreenParent.rotationY = -rotationYOffset;
			}
			if(rotationXOffset != 0)
			{
				delegate.y = -newScreen.height / 2;
				newScreenParent.y = newScreen.height / 2;
				newScreenParent.rotationX = -rotationXOffset;
			}
			this._navigator.addChild(newScreenParent);
			newScreenParent.addChild(delegate);
			newScreen.visible = false;
			this._savedNewScreen = newScreen;
			targetParent = newScreenParent;
		}
		if(oldScreen)
		{
			var oldScreenParent:Sprite3D = new Sprite3D();
			delegate = new RenderDelegate(oldScreen);
			delegate.alpha = oldScreen.alpha;
			delegate.blendMode = oldScreen.blendMode;
			delegate.rotation = oldScreen.rotation;
			delegate.scaleX = oldScreen.scaleX;
			delegate.scaleY = oldScreen.scaleY;
			if(rotationYOffset != 0)
			{
				delegate.x = -oldScreen.width / 2;
				oldScreenParent.x = oldScreen.width / 2;
			}
			if(rotationXOffset != 0)
			{
				delegate.y = -oldScreen.height / 2;
				oldScreenParent.y = oldScreen.height / 2;
			}
			oldScreenParent.rotationY = 0;
			oldScreenParent.rotationX = 0;
			if(!targetParent)
			{
				this._navigator = oldScreen.parent;
				duration = duration / 2;
				targetParent = oldScreenParent;
			}
			else
			{
				newScreenParent.visible = false;
				this._otherTarget = oldScreenParent;
			}
			this._navigator.addChild(oldScreenParent);
			oldScreenParent.addChild(delegate);
			oldScreen.visible = false;
			this._savedOldScreen = oldScreen;
		}
		else
		{
			newScreenParent.rotationY /= 2;
			newScreenParent.rotationX /= 2;
			duration = duration / 2;
		}

		super(targetParent, duration, ease);

		var targetParent:Sprite3D;
		if(newScreenParent)
		{
			if(rotationYOffset != 0)
			{
				this.animate("rotationY", 0);
			}
			if(rotationXOffset != 0)
			{
				this.animate("rotationX", 0);
			}
		}
		else //we only have the old screen
		{
			if(rotationYOffset != 0)
			{
				this.animate("rotationY", rotationYOffset / 2);
			}
			if(rotationXOffset != 0)
			{
				this.animate("rotationX", rotationXOffset / 2);
			}
		}
		this._rotationYOffset = rotationYOffset;
		this._rotationXOffset = rotationXOffset;
		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}

		if(this._otherTarget)
		{
			this.onUpdate = this.updateOtherTarget;
		}
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
	}

	private var _navigator:DisplayObjectContainer;
	private var _otherTarget:Sprite3D;
	private var _onCompleteCallback:Function;
	private var _rotationYOffset:Number = 0;
	private var _rotationXOffset:Number = 0;
	private var _savedNewScreen:DisplayObject;
	private var _savedOldScreen:DisplayObject;

	private function updateOtherTarget():void
	{
		var targetParent:Sprite3D = Sprite3D(this.target);
		if(this.progress >= 0.5 && this._otherTarget.visible)
		{
			targetParent.visible = true;
			this._otherTarget.visible = false;
		}
		else if(this.progress < 0.5 && !this._otherTarget.visible)
		{
			targetParent.visible = false;
			this._otherTarget.visible = true;
		}
		if(this._rotationYOffset < 0)
		{
			this._otherTarget.rotationY = targetParent.rotationY + Math.PI;
		}
		else if(this._rotationYOffset > 0)
		{
			this._otherTarget.rotationY = targetParent.rotationY - Math.PI;
		}
		if(this._rotationXOffset < 0)
		{
			this._otherTarget.rotationX = targetParent.rotationX + Math.PI;
		}
		else if(this._rotationXOffset > 0)
		{
			this._otherTarget.rotationX = targetParent.rotationX - Math.PI;
		}
	}

	private function cleanupTween():void
	{
		var targetParent:Sprite3D = Sprite3D(this.target);
		targetParent.removeFromParent(true);
		if(this._otherTarget)
		{
			this._otherTarget.removeFromParent(true);
		}
		if(this._savedNewScreen)
		{
			this._savedNewScreen.visible = true;
			this._savedNewScreen = null;
		}
		if(this._savedOldScreen)
		{
			this._savedOldScreen.visible = true;
			this._savedOldScreen = null;
		}
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}
}