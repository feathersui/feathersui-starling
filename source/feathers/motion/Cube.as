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
	 * positions a display object in 3D space as if it is on a side of a cube,
	 * and the cube may rotate up or down around the x-axis, or it may rotate
	 * left or right around the y-axis..
	 *
	 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
	 */
	public class Cube
	{
		/**
		 * @private
		 */
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		/**
		 * Creates a transition function for a screen navigator that positions
		 * the screens in 3D space as if they are on two adjacent sides of a
		 * cube, and the cube rotates left around the y-axis.
		 *
		 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createCubeLeftTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new CubeTween(newScreen, oldScreen, Math.PI / 2, 0, duration, ease, onComplete, tweenProperties);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that positions
		 * the screens in 3D space as if they are on two adjacent sides of a
		 * cube, and the cube rotates right around the y-axis.
		 *
		 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createCubeRightTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new CubeTween(newScreen, oldScreen, -Math.PI / 2, 0, duration, ease, onComplete, tweenProperties);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that positions
		 * the screens in 3D space as if they are on two adjacent sides of a
		 * cube, and the cube rotates up around the x-axis.
		 *
		 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createCubeUpTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new CubeTween(newScreen, oldScreen, 0, -Math.PI / 2, duration, ease, onComplete, tweenProperties);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that positions
		 * the screens in 3D space as if they are on two adjacent sides of a
		 * cube, and the cube rotates down around the y-axis.
		 *
		 * @see ../../../help/transitions.html#cube Transitions for Feathers screen navigators: Cube
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createCubeDownTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new CubeTween(newScreen, oldScreen, 0, Math.PI / 2, duration, ease, onComplete, tweenProperties);
			}
		}
	}
}

import flash.display3D.Context3DTriangleFace;

import starling.animation.Tween;
import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite3D;

class CubeTween extends Tween
{
	public function CubeTween(newScreen:DisplayObject, oldScreen:DisplayObject,
			rotationYOffset:Number, rotationXOffset:Number,
			duration:Number, ease:Object, onCompleteCallback:Function,
			tweenProperties:Object)
	{
		var cube:CulledSprite3D = new CulledSprite3D();
		if(newScreen)
		{
			this._navigator = newScreen.parent;
			this._newScreenParent = new Sprite3D();
			if(rotationYOffset < 0)
			{
				this._newScreenParent.z = this._navigator.width;
				this._newScreenParent.rotationY = rotationYOffset + Math.PI;
			}
			else if(rotationYOffset > 0)
			{
				this._newScreenParent.x = this._navigator.width;
				this._newScreenParent.rotationY = -rotationYOffset;
			}
			if(rotationXOffset < 0)
			{
				this._newScreenParent.y = this._navigator.height;
				this._newScreenParent.rotationX = rotationXOffset + Math.PI;
			}
			else if(rotationXOffset > 0)
			{
				this._newScreenParent.z = this._navigator.height;
				this._newScreenParent.rotationX = -rotationXOffset;
			}
			this._newScreenParent.addChild(newScreen);
			cube.addChild(this._newScreenParent);
		}
		if(oldScreen)
		{
			if(!this._navigator)
			{
				this._navigator = oldScreen.parent;
			}
			cube.addChildAt(oldScreen, 0);
		}
		this._navigator.addChild(cube);

		super(cube, duration, ease);

		if(rotationYOffset < 0)
		{
			this.animate("x", this._navigator.width);
			this.animate("rotationY", rotationYOffset);
		}
		else if(rotationYOffset > 0)
		{
			this.animate("z", this._navigator.width);
			this.animate("rotationY", rotationYOffset);
		}
		if(rotationXOffset < 0)
		{
			this.animate("z", this._navigator.height);
			this.animate("rotationX", rotationXOffset);
		}
		else if(rotationXOffset > 0)
		{
			this.animate("y", this._navigator.height);
			this.animate("rotationX", rotationXOffset);
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

	private var _navigator:DisplayObjectContainer;
	private var _newScreenParent:Sprite3D;
	private var _onCompleteCallback:Function;

	private function cleanupTween():void
	{
		var cube:Sprite3D = Sprite3D(this.target);
		if(this._newScreenParent)
		{
			var newScreen:DisplayObject = this._newScreenParent.getChildAt(0);
			this._navigator.addChild(newScreen);
			cube.removeChild(this._newScreenParent, true);
		}
		if(cube.numChildren > 0)
		{
			var oldScreen:DisplayObject = cube.removeChildAt(0);
			this._navigator.addChild(oldScreen);
		}
		this._navigator.removeChild(cube, true);
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}
}

class CulledSprite3D extends Sprite3D
{
	override public function render(support:RenderSupport, parentAlpha:Number):void
	{
		Starling.current.context.setCulling(Context3DTriangleFace.BACK);
		super.render(support, parentAlpha);
		Starling.current.context.setCulling(Context3DTriangleFace.NONE);
	}
}