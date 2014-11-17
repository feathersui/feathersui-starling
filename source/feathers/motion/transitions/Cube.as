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

	public class Cube
	{
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		public static function createCubeLeftTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				new CubeTween(newScreen, oldScreen, Math.PI / 2, 0, duration, ease, onComplete, tweenProperties);
			}
		}

		public static function createCubeRightTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				new CubeTween(newScreen, oldScreen, -Math.PI / 2, 0, duration, ease, onComplete, tweenProperties);
			}
		}

		public static function createCubeUpTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				new CubeTween(newScreen, oldScreen, 0, -Math.PI / 2, duration, ease, onComplete, tweenProperties);
			}
		}

		public static function createCubeDownTransition(duration:Number = 0.25, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				validateAndCleanup(oldScreen, newScreen);
				new CubeTween(newScreen, oldScreen, 0, Math.PI / 2, duration, ease, onComplete, tweenProperties);
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
				var activeTween:CubeTween = CubeTween.SCREEN_TO_TWEEN[oldScreen] as CubeTween;
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

import feathers.controls.IScreen;

import flash.display3D.Context3DTriangleFace;

import flash.utils.Dictionary;

import starling.animation.Tween;
import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite3D;

class CubeTween extends Tween
{
	internal static const SCREEN_TO_TWEEN:Dictionary = new Dictionary(true);

	public function CubeTween(newScreen:DisplayObject, oldScreen:DisplayObject,
			rotationYOffset:Number, rotationXOffset:Number,
			duration:Number, ease:Object, onCompleteCallback:Function,
			tweenProperties:Object)
	{
		var cube:CulledSprite3D = new CulledSprite3D();
		if(newScreen)
		{
			this._navigator = newScreen is IScreen ? IScreen(newScreen).owner : newScreen.parent;
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
				this._navigator = newScreen is IScreen ? IScreen(newScreen).owner : newScreen.parent;
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
		delete SCREEN_TO_TWEEN[this.target];
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