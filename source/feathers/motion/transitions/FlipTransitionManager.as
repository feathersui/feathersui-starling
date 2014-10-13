/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions
{
	import feathers.controls.ScreenNavigator;
	import feathers.layout.ILayout;
	import feathers.layout.LayoutBoundsResult;
	import feathers.layout.ViewPortBounds;

	import flash.geom.Point;

	import starling.animation.Transitions;

	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObject;

	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.display.Sprite3D;
	import starling.events.EventDispatcher;

	/**
	 * A transition for <code>ScreenNavigator</code> that flips the old and new
	 * screens by modifying <code>rotationY</code> on a <code>Sprite3D</code>.
	 *
	 * <p>Warning: This transition is not compatible with Starling's
	 * <code>clipRect</code> property. You must disable clipping on screens
	 * while this transition is in progress.</p>
	 *
	 * @see feathers.controls.ScreenNavigator
	 */
	public class FlipTransitionManager
	{
		/**
		 * Constructor.
		 * @param navigator
		 */
		public function FlipTransitionManager(navigator:ScreenNavigator)
		{
			if(!navigator)
			{
				throw new ArgumentError("ScreenNavigator cannot be null.");
			}
			this.navigator = navigator;
			this.navigator.transition = this.onTransition;
		}

		/**
		 * The <code>ScreenNavigator</code> being managed.
		 */
		protected var navigator:ScreenNavigator;

		/**
		 * @private
		 */
		protected var _activeTransition:Tween;

		/**
		 * @private
		 */
		protected var _savedOtherTarget:Sprite3D;

		/**
		 * @private
		 */
		protected var _savedCompleteHandler:Function;

		/**
		 * The duration of the transition, measured in seconds.
		 *
		 * @default 0.5
		 */
		public var duration:Number = 0.5;

		/**
		 * A delay before the transition starts, measured in seconds. This may
		 * be required on low-end systems that will slow down for a short time
		 * after heavy texture uploads.
		 *
		 * @default 0.1
		 */
		public var delay:Number = 0.1;

		/**
		 * The easing function to use.
		 *
		 * @default starling.animation.Transitions.EASE_OUT
		 */
		public var ease:Object = Transitions.EASE_OUT;

		/**
		 * Determines if the next transition should be skipped. After the
		 * transition, this value returns to <code>false</code>.
		 *
		 * @default false
		 */
		public var skipNextTransition:Boolean = false;

		/**
		 * The function passed to the <code>transition</code> property of the
		 * <code>ScreenNavigator</code>.
		 */
		protected function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
		{
			if(!oldScreen && !newScreen)
			{
				throw new ArgumentError("Cannot transition if both old screen and new screen are null.");
			}

			if(this._activeTransition)
			{
				this._activeTransition.advanceTime(this._activeTransition.totalTime);
				if(this._activeTransition)
				{
					this._activeTransition.advanceTime(this._activeTransition.totalTime);
				}
			}

			if(this.skipNextTransition)
			{
				this.skipNextTransition = false;
				this._savedCompleteHandler = null;
				if(onComplete != null)
				{
					onComplete();
				}
				return;
			}

			this._savedCompleteHandler = onComplete;

			if(newScreen)
			{
				var newScreenParent:Sprite3D = new Sprite3D();
				this.navigator.addChild(newScreenParent);
				newScreenParent.addChild(newScreen);
				newScreen.x = -newScreen.width / 2;
				newScreenParent.x = newScreen.width / 2;
			}
			if(oldScreen)
			{
				var oldScreenParent:Sprite3D = new Sprite3D();
				this.navigator.addChild(oldScreenParent);
				oldScreenParent.addChild(oldScreen);
				oldScreen.x = -oldScreen.width / 2;
				oldScreenParent.x = oldScreen.width / 2;
			}

			if(newScreenParent)
			{
				if(oldScreenParent) //oldScreenParent can be null, that's okay
				{
					newScreenParent.visible = false;
					newScreenParent.rotationY = -Math.PI;
					oldScreenParent.rotationY = 0;
					this._savedOtherTarget = oldScreenParent;
					this._activeTransition = new Tween(newScreenParent, this.duration, this.ease);
					this._activeTransition.animate("rotationY", 0);
					this._activeTransition.onUpdate = activeTransition_onUpdate;
				}
				else
				{
					newScreenParent.rotationY = -Math.PI / 2;
					this._activeTransition = new Tween(newScreenParent, this.duration / 2, this.ease);
					this._activeTransition.animate("rotationY", 0);
				}
			}
			else //we only have the old screen
			{
				oldScreenParent.rotationY = 0;
				this._activeTransition = new Tween(oldScreenParent, this.duration / 2, this.ease);
				this._activeTransition.animate("rotationY", Math.PI / 2);
			}
			this._activeTransition.delay = this.delay;
			this._activeTransition.onComplete = activeTransition_onComplete;
			Starling.juggler.add(this._activeTransition);
		}

		/**
		 * @private
		 */
		protected function activeTransition_onUpdate():void
		{
			var newScreenParent:Sprite3D = Sprite3D(this._activeTransition.target);
			if(this._activeTransition.progress >= 0.5 && this._savedOtherTarget.visible)
			{
				newScreenParent.visible = true;
				this._savedOtherTarget.visible = false;
			}
			this._savedOtherTarget.rotationY = newScreenParent.rotationY + Math.PI;
		}

		/**
		 * @private
		 */
		protected function activeTransition_onComplete():void
		{
			var targetParent:Sprite3D = Sprite3D(this._activeTransition.target);
			this.navigator.removeChild(targetParent);
			var screen:DisplayObject = targetParent.getChildAt(0);
			screen.x = 0;
			this.navigator.addChild(screen);
			if(this._savedOtherTarget)
			{
				this.navigator.removeChild(this._savedOtherTarget);
				screen = this._savedOtherTarget.getChildAt(0);
				screen.x = 0;
				this.navigator.addChild(screen);
			}
			this._savedOtherTarget = null;
			this._activeTransition = null;
			if(this._savedCompleteHandler != null)
			{
				this._savedCompleteHandler();
			}
		}
	}
}
