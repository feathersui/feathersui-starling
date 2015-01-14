/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import starling.animation.Transitions;
	import starling.display.DisplayObject;

	/**
	 * Creates animated effects, like transitions for screen navigators, that
	 * positions display objects in 3D space is if they are printed on opposite
	 * sides of a postcard. A display object may appear on the front or back
	 * side, and the card rotates around its center to reveal the other side.
	 * The card may rotate up or down around the x-axis, or they may rotate left
	 * or right around the y-axis.
	 *
	 * @see ../../../help/transitions.html#flip Transitions for Feathers screen navigators: Flip
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
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new FlipTween(newScreen, oldScreen, Math.PI, 0, duration, ease, onComplete, tweenProperties);
			}
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
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new FlipTween(newScreen, oldScreen, -Math.PI, 0, duration, ease, onComplete, tweenProperties);
			}
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
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new FlipTween(newScreen, oldScreen, 0, -Math.PI, duration, ease, onComplete, tweenProperties);
			}
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
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new FlipTween(newScreen, oldScreen, 0, Math.PI, duration, ease, onComplete, tweenProperties);
			}
		}
	}
}

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
			if(rotationYOffset != 0)
			{
				newScreen.x = -newScreen.width / 2;
				newScreenParent.x = newScreen.width / 2;
				newScreenParent.rotationY = -rotationYOffset;
			}
			if(rotationXOffset != 0)
			{
				newScreen.y = -newScreen.height / 2;
				newScreenParent.y = newScreen.height / 2;
				newScreenParent.rotationX = -rotationXOffset;
			}
			this._navigator.addChild(newScreenParent);
			newScreenParent.addChild(newScreen);
			targetParent = newScreenParent;
		}
		if(oldScreen)
		{
			var oldScreenParent:Sprite3D = new Sprite3D();
			if(rotationYOffset != 0)
			{
				oldScreen.x = -oldScreen.width / 2;
				oldScreenParent.x = oldScreen.width / 2;
			}
			if(rotationXOffset != 0)
			{
				oldScreen.y = -oldScreen.height / 2;
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
			oldScreenParent.addChild(oldScreen);
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
		Starling.juggler.add(this);
	}

	private var _navigator:DisplayObjectContainer;
	private var _otherTarget:Sprite3D;
	private var _onCompleteCallback:Function;
	private var _rotationYOffset:Number = 0;
	private var _rotationXOffset:Number = 0;

	private function updateOtherTarget():void
	{
		var targetParent:Sprite3D = Sprite3D(this.target);
		if(this.progress >= 0.5 && this._otherTarget.visible)
		{
			targetParent.visible = true;
			this._otherTarget.visible = false;
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
		this._navigator.removeChild(targetParent);
		var screen:DisplayObject = targetParent.getChildAt(0);
		screen.x = 0;
		screen.y = 0;
		this._navigator.addChild(screen);
		if(this._otherTarget)
		{
			this._navigator.removeChild(this._otherTarget);
			screen = this._otherTarget.getChildAt(0);
			screen.x = 0;
			screen.y = 0;
			this._navigator.addChild(screen);
		}
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}
}