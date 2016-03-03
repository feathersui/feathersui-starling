/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.transitions
{
	import feathers.controls.IScreen;
	import feathers.controls.ScreenNavigator;
	import feathers.motion.Slide;

	import flash.utils.getQualifiedClassName;

	import starling.animation.Transitions;
	import starling.display.DisplayObject;

	/**
	 * A transition for <code>ScreenNavigator</code> that slides out the old
	 * screen and slides in the new screen at the same time. The slide starts
	 * from the right or left, depending on if the manager determines that the
	 * transition is a push or a pop.
	 *
	 * <p>Whether a screen change is supposed to be a push or a pop is
	 * determined automatically. The manager generates an identifier from the
	 * fully-qualified class name of the screen, and if present, the
	 * <code>screenID</code> defined by <code>IScreen</code> instances. If the
	 * generated identifier is present on the stack, a screen change is
	 * considered a pop. If the token is not present, it's a push. Screen IDs
	 * should be tailored to this behavior to avoid false positives.</p>
	 *
	 * <p>If your navigation structure requires explicit pushing and popping, a
	 * custom transition manager is probably better.</p>
	 *
	 * @see feathers.controls.ScreenNavigator
	 */
	public class ScreenSlidingStackTransitionManager
	{
		/**
		 * Constructor.
		 */
		public function ScreenSlidingStackTransitionManager(navigator:ScreenNavigator, quickStackScreenClass:Class = null, quickStackScreenID:String = null)
		{
			if(!navigator)
			{
				throw new ArgumentError("ScreenNavigator cannot be null.");
			}
			this.navigator = navigator;
			var quickStack:String;
			if(quickStackScreenClass)
			{
				quickStack = getQualifiedClassName(quickStackScreenClass);
			}
			if(quickStack && quickStackScreenID)
			{
				quickStack += "~" + quickStackScreenID;
			}
			if(quickStack)
			{
				this._stack.push(quickStack);
			}
			this.navigator.transition = this.onTransition;
		}

		/**
		 * The <code>ScreenNavigator</code> being managed.
		 */
		protected var navigator:ScreenNavigator;

		/**
		 * @private
		 */
		protected var _stack:Vector.<String> = new <String>[];

		/**
		 * @private
		 */
		protected var _pushTransition:Function;

		/**
		 * @private
		 */
		protected var _popTransition:Function;

		/**
		 * @private
		 */
		protected var _duration:Number = 0.25;

		/**
		 * The duration of the transition, measured in seconds.
		 *
		 * @default 0.25
		 */
		public function get duration():Number
		{
			return this._duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:Number):void
		{
			if(this._duration == value)
			{
				return;
			}
			this._duration = value;
			this._pushTransition = null;
			this._popTransition = null;
		}

		/**
		 * @private
		 */
		protected var _delay:Number = 0.1;

		/**
		 * A delay before the transition starts, measured in seconds. This may
		 * be required on low-end systems that will slow down for a short time
		 * after heavy texture uploads.
		 *
		 * @default 0.1
		 */
		public function get delay():Number
		{
			return this._delay;
		}

		/**
		 * @private
		 */
		public function set delay(value:Number):void
		{
			if(this._delay == value)
			{
				return;
			}
			this._delay = value;
			this._pushTransition = null;
			this._popTransition = null;
		}

		/**
		 * @private
		 */
		protected var _ease:Object = Transitions.EASE_OUT;

		/**
		 * The easing function to use.
		 *
		 * @default starling.animation.Transitions.EASE_OUT
		 */
		public function get ease():Object
		{
			return this._ease;
		}

		/**
		 * @private
		 */
		public function set ease(value:Object):void
		{
			if(this._ease == value)
			{
				return;
			}
			this._ease = value;
			this._pushTransition = null;
			this._popTransition = null;
		}

		/**
		 * Determines if the next transition should be skipped. After the
		 * transition, this value returns to <code>false</code>.
		 *
		 * @default false
		 */
		public var skipNextTransition:Boolean = false;
		
		/**
		 * Removes all saved classes from the stack that are used to determine
		 * which side of the <code>ScreenNavigator</code> the new screen will
		 * slide in from.
		 */
		public function clearStack():void
		{
			this._stack.length = 0;
		}

		/**
		 * The function passed to the <code>transition</code> property of the
		 * <code>ScreenNavigator</code>.
		 */
		protected function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
		{
			if(this.skipNextTransition)
			{
				this.skipNextTransition = false;
				if(newScreen)
				{
					newScreen.x = 0;
				}
				if(oldScreen)
				{
					oldScreen.x = 0;
				}
				if(onComplete != null)
				{
					onComplete();
				}
				return;
			}

			var newScreenClassAndID:String = getQualifiedClassName(newScreen);
			if(newScreen is IScreen)
			{
				newScreenClassAndID += "~" + IScreen(newScreen).screenID;
			}
			var stackIndex:int = this._stack.indexOf(newScreenClassAndID);
			if(stackIndex < 0) //push
			{
				var oldScreenClassAndID:String = getQualifiedClassName(oldScreen);
				if(oldScreen is IScreen)
				{
					oldScreenClassAndID += "~" + IScreen(oldScreen).screenID;
				}
				this._stack.push(oldScreenClassAndID);

				if(this._pushTransition === null)
				{
					this._pushTransition = Slide.createSlideLeftTransition(this._duration, this._ease, {delay: this._delay});
				}
				this._pushTransition(oldScreen, newScreen, onComplete);
			}
			else //pop
			{
				this._stack.length = stackIndex;

				if(this._popTransition === null)
				{
					this._popTransition = Slide.createSlideRightTransition(this._duration, this._ease, {delay: this._delay});
				}
				this._popTransition(oldScreen, newScreen, onComplete);
			}
		}
	}
}