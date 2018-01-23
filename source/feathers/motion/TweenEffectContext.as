/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.display.DisplayObject;
	import feathers.core.IFeathersControl;

	/**
	 * An effect context for a <code>starling.animation.Tween</code>.
	 * 
	 * @see http://doc.starling-framework.org/core/starling/animation/Tween.html starling.animation.Tween
	 * 
	 * @productversion Feathers 3.5.0
	 */
	public class TweenEffectContext extends BaseEffectContext implements IEffectContext
	{
		/**
		 * Constructor.
		 */
		public function TweenEffectContext(tween:Tween)
		{
			this._tween = tween;
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

			super(this._tween.totalTime, transitionFunc);
		}

		/**
		 * @private
		 */
		protected var _tween:Tween = null;

		/**
		 * The tween to control as an effect.
		 */
		public function get tween():Tween
		{
			return this._tween;
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
			var target:Object = this._tween.target;
			if(target is IFeathersControl)
			{
				IFeathersControl(target).suspendEffects();
			}
			var newCurrentTime:Number = this._position * this._tween.totalTime;
			this._tween.advanceTime(newCurrentTime - this._tween.currentTime);
			if(target is IFeathersControl)
			{
				IFeathersControl(target).resumeEffects();
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