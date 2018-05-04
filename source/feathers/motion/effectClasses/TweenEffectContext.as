/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.effectClasses
{
	import feathers.core.IFeathersControl;
	import feathers.motion.EffectInterruptBehavior;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.display.DisplayObject;

	/**
	 * An effect context for a <code>starling.animation.Tween</code>.
	 * 
	 * @see ../../../help/effects.html Effects and animation for Feathers components
	 * @see http://doc.starling-framework.org/core/starling/animation/Tween.html starling.animation.Tween
	 * 
	 * @productversion Feathers 3.5.0
	 */
	public class TweenEffectContext extends BaseEffectContext implements IEffectContext
	{
		/**
		 * Constructor.
		 */
		public function TweenEffectContext(tween:Tween, interruptBehavior:String = EffectInterruptBehavior.END)
		{
			this._tween = tween;
			this._interruptBehavior = interruptBehavior;
			var linearTransitionFunc:Function = Transitions.getTransition(Transitions.LINEAR);
			var transitionFunc:Function = this._tween.transitionFunc;
			//we want setting the position property to be linear, but when
			//play() or playReverse() is called, we'll use the saved transition
			this._tween.transitionFunc = linearTransitionFunc;

			//we'll take over for onStart and onComplete because we don't them
			//being called by the Tween, since we're taking over control
			this._onStart = this._tween.onStart;
			this._onComplete = this._tween.onComplete;
			this._tween.onStart = null;
			this._tween.onComplete = null;

			super(DisplayObject(this._tween.target), this._tween.totalTime, transitionFunc);
		}

		/**
		 * @private
		 */
		protected var _tween:Tween = null;

		/**
		 * The tween that is controlled by the effect.
		 */
		public function get tween():Tween
		{
			return this._tween;
		}

		/**
		 * @private
		 */
		protected var _interruptBehavior:String = null;

		[Inspectable(type="String",enumeration="end,stop")]
		/**
		 * Indicates how the effect behaves when it is interrupted. Interrupted
		 * effects can either advance directly to the end or stop at the current
		 * position.
		 *
		 * @default feathers.motion.EffectInterruptBehavior.END
		 *
		 * @see feathers.motion.EffectInterruptBehavior#END
		 * @see feathers.motion.EffectInterruptBehavior#STOP
		 * @see #interrupt()
		 */
		public function get interruptBehavior():String
		{
			return this._interruptBehavior;
		}

		/**
		 * @private
		 */
		public function set interruptBehavior(value:String):void
		{
			this._interruptBehavior = value;
		}

		/**
		 * @private
		 */
		protected var _onStart:Function = null;

		/**
		 * @private
		 */
		protected var _onComplete:Function = null;

		/**
		 * @private
		 * 
		 * @see #interruptBehavior
		 */
		override public function interrupt():void
		{
			if(this._interruptBehavior === EffectInterruptBehavior.STOP)
			{
				this.stop();
				return;
			}
			this.toEnd();
		}

		/**
		 * @private
		 */
		override protected function prepareEffect():void
		{
			if(this._onStart !== null)
			{
				this._onStart.apply(null, this._tween.onStartArgs);
			}
		}

		/**
		 * @private
		 */
		override protected function updateEffect():void
		{
			if(this._target is IFeathersControl)
			{
				IFeathersControl(this._target).suspendEffects();
			}
			var newCurrentTime:Number = this._position * this._tween.totalTime;
			this._tween.advanceTime(newCurrentTime - this._tween.currentTime);
			if(this._target is IFeathersControl)
			{
				IFeathersControl(this._target).resumeEffects();
			}
		}

		/**
		 * @private
		 */
		override protected function cleanupEffect():void
		{
			if(this._onComplete !== null)
			{
				this._onComplete.apply(null, this._tween.onCompleteArgs)
			}
		}
	}	
}