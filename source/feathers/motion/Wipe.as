/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import starling.animation.Transitions;
	import starling.display.DisplayObject;

	/**
	 * Creates animated effects, like transitions for screen navigators, that
	 * wipes a display object out of view, revealing another display object
	 * under the first. Both display objects remain stationary while the
	 * effect animates clipping rectangles.
	 *
	 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class Wipe
	{
		/**
		 * @private
		 */
		protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

		/**
		 * Creates a transition function for a screen navigator that wipes the
		 * old screen out of view to the left, animating the <code>width</code>
		 * property of a <code>clipRect</code>, to reveal the new screen under
		 * it. The new screen remains stationary.
		 *
		 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createWipeLeftTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				var xOffset:Number = oldScreen ? -oldScreen.width : -newScreen.width;
				new WipeTween(newScreen, oldScreen, xOffset, 0, duration, ease, onComplete, tweenProperties);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that wipes the
		 * old screen out of view to the right, animating the <code>x</code>
		 * and <code>width</code> properties of a <code>clipRect</code>, to
		 * reveal the new screen under it. The new screen remains stationary.
		 *
		 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createWipeRightTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				var xOffset:Number = oldScreen ? oldScreen.width : newScreen.width;
				new WipeTween(newScreen, oldScreen, xOffset, 0, duration, ease, onComplete, tweenProperties);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that wipes the
		 * old screen up, animating the <code>height</code> property of a
		 * <code>clipRect</code>, to reveal the new screen under it. The new
		 * screen remains stationary.
		 *
		 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createWipeUpTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				var yOffset:Number = oldScreen ? -oldScreen.height : -newScreen.height;
				new WipeTween(newScreen, oldScreen, 0, yOffset, duration, ease, onComplete, tweenProperties);
			}
		}

		/**
		 * Creates a transition function for a screen navigator that wipes the
		 * old screen down, animating the <code>y</code> and <code>height</code>
		 * properties of a <code>clipRect</code>, to reveal the new screen under
		 * it. The new screen remains stationary.
		 *
		 * @see ../../../help/transitions.html#wipe Transitions for Feathers screen navigators: Wipe
		 * @see feathers.controls.StackScreenNavigator#pushTransition
		 * @see feathers.controls.StackScreenNavigator#popTransition
		 * @see feathers.controls.ScreenNavigator#transition
		 */
		public static function createWipeDownTransition(duration:Number = 0.5, ease:Object = Transitions.EASE_OUT, tweenProperties:Object = null):Function
		{
			return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
			{
				if(!oldScreen && !newScreen)
				{
					throw new ArgumentError(SCREEN_REQUIRED_ERROR);
				}
				var yOffset:Number = oldScreen ? oldScreen.height : newScreen.height;
				new WipeTween(newScreen, oldScreen, 0, yOffset, duration, ease, onComplete, tweenProperties);
			}
		}
	}
}

import feathers.display.RenderDelegate;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;

class WipeTween extends Tween
{
	public function WipeTween(newScreen:DisplayObject, oldScreen:DisplayObject,
		xOffset:Number, yOffset:Number, duration:Number, ease:Object, onCompleteCallback:Function,
		tweenProperties:Object)
	{
		var mask:Quad;
		if(newScreen)
		{
			mask = new Quad(1, 1, 0xff00ff);
			//the initial dimensions cannot be 0 or there's a runtime error,
			mask.width = 0;
			mask.height = 0;
			if(xOffset !== 0)
			{
				if(xOffset < 0)
				{
					mask.x = newScreen.width;
				}
				mask.height = newScreen.height;
			}
			if(yOffset !== 0)
			{
				if(yOffset < 0)
				{
					mask.y = newScreen.height;
				}
				mask.width = newScreen.width;
			}
			this._newScreenDelegate = new RenderDelegate(newScreen);
			this._newScreenDelegate.alpha = newScreen.alpha;
			this._newScreenDelegate.blendMode = newScreen.blendMode;
			this._newScreenDelegate.rotation = newScreen.rotation;
			this._newScreenDelegate.scaleX = newScreen.scaleX;
			this._newScreenDelegate.scaleY = newScreen.scaleY;
			this._newScreenDelegate.mask = mask;
			this._newScreenClipRect = mask;
			newScreen.parent.addChild(this._newScreenDelegate);
			newScreen.parent.addChild(mask);
			newScreen.visible = false;
			this._savedNewScreen = newScreen;
		}
		if(oldScreen)
		{
			mask = new Quad(1, 1, 0xff00ff);
			//the initial dimensions cannot be 0 or there's a runtime error,
			//and these values might be 0
			mask.width = oldScreen.width;
			mask.height = oldScreen.height;
			this._oldScreenDelegate = new RenderDelegate(oldScreen);
			this._oldScreenDelegate.alpha = oldScreen.alpha;
			this._oldScreenDelegate.blendMode = oldScreen.blendMode;
			this._oldScreenDelegate.rotation = oldScreen.rotation;
			this._oldScreenDelegate.scaleX = oldScreen.scaleX;
			this._oldScreenDelegate.scaleY = oldScreen.scaleY;
			this._oldScreenDelegate.mask = mask;
			oldScreen.parent.addChild(this._oldScreenDelegate);
			oldScreen.parent.addChild(mask);
			oldScreen.visible = false;
			this._savedOldScreen = oldScreen;
		}

		super(mask, duration, ease);
		
		if(oldScreen)
		{
			if(xOffset < 0)
			{
				this.animate("width", oldScreen.width + xOffset);
			}
			else if(xOffset > 0)
			{
				this.animate("x", xOffset);
				this.animate("width", oldScreen.width - xOffset);
			}
			if(yOffset < 0)
			{
				this.animate("height", oldScreen.height + yOffset);
			}
			else if(yOffset > 0)
			{
				this.animate("y", yOffset);
				this.animate("height", oldScreen.height - yOffset);
			}
			if(this._newScreenDelegate)
			{
				this.onUpdate = this.updateNewScreen;
			}
		}
		else //new screen only
		{
			if(xOffset < 0)
			{
				this.animate("x", newScreen.width + xOffset);
				this.animate("width", -xOffset);
			}
			else if(xOffset > 0)
			{
				this.animate("width", xOffset);
			}
			if(yOffset < 0)
			{
				this.animate("y", newScreen.height + yOffset);
				this.animate("height", -yOffset);
			}
			else if(yOffset > 0)
			{
				this.animate("height", yOffset);
			}
		}
		if(tweenProperties)
		{
			for(var propertyName:String in tweenProperties)
			{
				this[propertyName] = tweenProperties[propertyName];
			}
		}
		this._savedXOffset = xOffset;
		this._savedYOffset = yOffset;
		this._onCompleteCallback = onCompleteCallback;
		this.onComplete = this.cleanupTween;
		Starling.juggler.add(this);
	}

	private var _oldScreenDelegate:RenderDelegate;
	private var _newScreenDelegate:RenderDelegate;
	private var _newScreenClipRect:Quad;
	private var _savedOldScreen:DisplayObject;
	private var _savedNewScreen:DisplayObject;
	private var _savedXOffset:Number;
	private var _savedYOffset:Number;
	private var _onCompleteCallback:Function;

	private function updateNewScreen():void
	{
		var oldScreenClipRect:Quad = Quad(this.target);
		if(this._savedXOffset < 0)
		{
			this._newScreenClipRect.x = oldScreenClipRect.width;
			this._newScreenClipRect.width = this._savedNewScreen.width - this._newScreenClipRect.x;
		}
		else if(this._savedXOffset > 0)
		{
			this._newScreenClipRect.width = oldScreenClipRect.x;
		}
		if(this._savedYOffset < 0)
		{
			this._newScreenClipRect.y = oldScreenClipRect.height;
			this._newScreenClipRect.height = this._savedNewScreen.height - this._newScreenClipRect.y;
		}
		else if(this._savedYOffset > 0)
		{
			this._newScreenClipRect.height = oldScreenClipRect.y;
		}
	}

	private function cleanupTween():void
	{
		if(this._oldScreenDelegate)
		{
			Quad(this.target).removeFromParent(true);
			this._oldScreenDelegate.removeFromParent(true);
			this._oldScreenDelegate = null;
		}
		if(this._newScreenDelegate)
		{
			this._newScreenClipRect.removeFromParent(true);
			this._newScreenClipRect = null;
			this._newScreenDelegate.removeFromParent(true);
			this._newScreenDelegate = null;
		}
		if(this._savedOldScreen)
		{
			this._savedOldScreen.visible = true;
			this._savedOldScreen = null;
		}
		if(this._savedNewScreen)
		{
			this._savedNewScreen.visible = true;
			this._savedNewScreen = null;
		}
		if(this._onCompleteCallback !== null)
		{
			this._onCompleteCallback();
		}
	}

}

