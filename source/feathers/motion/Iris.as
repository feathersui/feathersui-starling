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
	 * shows or hides a display object masked by a growing or shrinking circle.
	 * In a transition, both display objects remain stationary while the effect
	 * animates a stencil mask.
	 * 
	 * <p>Note: This effect is not supported with display objects that have
	 * transparent backgrounds due to limitations in stencil masks. Display
	 * objects should be fully opaque.</p>
	 *
	 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
	 */
	public class Iris
	{
		/**
		 * @private
		 */
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		/**
		 * Creates a transition function for a screen navigator that shows a
		 * screen by masking it with a growing circle in the center.
		 *
		 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createIrisOpenTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(oldScreen)
				{
					var originX:Number = oldScreen.width / 2;
					var originY:Number = oldScreen.height / 2;
				}
				else
				{
					originX = newScreen.width / 2;
					originY = newScreen.height / 2;
				}
				new IrisTween(newScreen, oldScreen, originX, originY, true, duration, ease, onComplete, tweenProperties);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that shows a
		 * screen by masking it with a growing circle at a specific position.
		 *
		 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createIrisOpenTransitionAt(x:Number, y:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new IrisTween(newScreen, oldScreen, x, y, true, duration, ease, onComplete, tweenProperties);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that hides a
		 * screen by masking it with a shrinking circle in the center.
		 *
		 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createIrisCloseTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				if(oldScreen)
				{
					var originX:Number = oldScreen.width / 2;
					var originY:Number = oldScreen.height / 2;
				}
				else
				{
					originX = newScreen.width / 2;
					originY = newScreen.height / 2;
				}
				new IrisTween(newScreen, oldScreen, originX, originY, false, duration, ease, onComplete, tweenProperties);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that hides a
		 * screen by masking it with a shrinking circle at a specific position.
		 *
		 * @see ../../../help/transitions.html#iris Transitions for Feathers screen navigators: Iris
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createIrisCloseTransitionAt(x:Number, y:Number, duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				new IrisTween(newScreen, oldScreen, x, y, false, duration, ease, onComplete, tweenProperties);
			}
		}
	}
}

import feathers.display.RenderDelegate;

import flash.geom.Point;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Canvas;
import starling.display.DisplayObject;

class IrisTween extends Tween
{
	public function IrisTween(newScreen:DisplayObject, oldScreen:DisplayObject,
		originX:Number, originY:Number, openIris:Boolean, duration:Number, ease:Object,
		onCompleteCallback:Function, tweenProperties:Object)
	{
		if(newScreen)
		{
			var width:Number = newScreen.width;
			var height:Number = newScreen.height;
		}
		else
		{
			width = oldScreen.width;
			height = oldScreen.height;
		}
		var halfWidth:Number = width / 2;
		var halfHeight:Number = height / 2;
		var p1:Point = new Point(halfWidth, halfHeight);
		var p2:Point = new Point(originX, originY);
		var radiusFromCenter:Number = p1.length;
		if(p1.equals(p2))
		{
			var radius:Number = radiusFromCenter;
		}
		else
		{
			var distanceFromCenterToOrigin:Number = Point.distance(p1, p2);
			radius = radiusFromCenter + distanceFromCenterToOrigin;
		}
		var maskTarget:Canvas;
		if(newScreen && openIris)
		{
			this._newScreenDelegate = new RenderDelegate(newScreen);
			this._newScreenDelegate.alpha = newScreen.alpha;
			this._newScreenDelegate.blendMode = newScreen.blendMode;
			this._newScreenDelegate.rotation = newScreen.rotation;
			this._newScreenDelegate.scaleX = newScreen.scaleX;
			this._newScreenDelegate.scaleY = newScreen.scaleY;
			newScreen.parent.addChild(this._newScreenDelegate);
			newScreen.visible = false;
			this._savedNewScreen = newScreen;

			var mask:Canvas = new Canvas();
			mask.x = originX;
			mask.y = originY;
			mask.beginFill(0xff00ff);
			mask.drawCircle(0, 0, radius);
			mask.endFill();
			if(openIris)
			{
				mask.scaleX = 0;
				mask.scaleY = 0;
			}
			if(openIris)
			{
				this._newScreenDelegate.mask = mask;
			}
			newScreen.parent.addChild(mask);
			maskTarget = mask;
		}
		if(oldScreen && !openIris)
		{
			this._oldScreenDelegate = new RenderDelegate(oldScreen);
			this._oldScreenDelegate.alpha = oldScreen.alpha;
			this._oldScreenDelegate.blendMode = oldScreen.blendMode;
			this._oldScreenDelegate.rotation = oldScreen.rotation;
			this._oldScreenDelegate.scaleX = oldScreen.scaleX;
			this._oldScreenDelegate.scaleY = oldScreen.scaleY;
			oldScreen.parent.addChild(this._oldScreenDelegate);
			oldScreen.visible = false;
			this._savedOldScreen = oldScreen;

			mask = new Canvas();
			mask.x = originX;
			mask.y = originY;
			mask.beginFill(0xff00ff);
			mask.drawCircle(0, 0, radius);
			mask.endFill();
			if(!openIris)
			{
				this._oldScreenDelegate.mask = mask;
			}
			oldScreen.parent.addChild(mask);
			maskTarget = mask;
		}

		super(maskTarget, duration, ease);

		if(openIris)
		{
			this.animate("scaleX", 1);
			this.animate("scaleY", 1);
		}
		else
		{
			this.animate("scaleX", 0);
			this.animate("scaleY", 0);
		}

		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}
		this._savedWidth = width;
		this._savedHeight = height;
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
		Starling.juggler.add(this);
	}

	private var _newScreenDelegate:RenderDelegate;
	private var _oldScreenDelegate:RenderDelegate;
	private var _savedOldScreen:DisplayObject;
	private var _savedNewScreen:DisplayObject;
	private var _onCompleteCallback:Function;
	private var _savedWidth:Number;
	private var _savedHeight:Number;

	private function cleanupTween():void
	{
		if(this._newScreenDelegate)
		{
			this._newScreenDelegate.mask.removeFromParent(true);
			this._newScreenDelegate.removeFromParent(true);
			this._newScreenDelegate = null;
		}
		if(this._oldScreenDelegate)
		{
			this._oldScreenDelegate.mask.removeFromParent(true);
			this._oldScreenDelegate.removeFromParent(true);
			this._oldScreenDelegate = null;
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