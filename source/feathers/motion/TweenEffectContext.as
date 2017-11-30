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

	/**
	 * 
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * An effect context for a <code>starling.animation.Tween</code>.
	 * 
	 * @see http://doc.starling-framework.org/core/starling/animation/Tween.html starling.animation.Tween
	 */
	public class TweenEffectContext extends EventDispatcher implements IEffectContext
	{
		/**
		 * @private
		 */
		private static const MAX_POSITION:Number = 0.99999;

		/**
		 * Constructor.
		 */
		public function TweenEffectContext(tween:Tween)
		{
			this._tween = tween;
			this._linearTransitionFunc = Transitions.getTransition(Transitions.LINEAR);
			this._transitionFunc = this._tween.transitionFunc;
			if(this._transitionFunc === null)
			{
				this._transitionFunc = this._linearTransitionFunc;
			}
			//we need to set onComplete in play(), so save the old value,
			//and we'll call it in our replacement
			this._onComplete = this._tween.onComplete;
			//also remove the old value because we don't want it triggering
			//anything if the position property is set to a value >= 1
			this._tween.onComplete = null;
		}

		/**
		 * @private
		 */
		protected var _playing:Boolean = false;

		/**
		 * @private
		 */
		protected var _reversed:Boolean = false;

		/**
		 * @private
		 */
		protected var _linearTransitionFunc:Function = null;

		/**
		 * @private
		 */
		protected var _transitionFunc:Function = null;

		/**
		 * @private
		 */
		protected var _onComplete:Function = null;

		/**
		 * @private
		 */
		protected var _tween:Tween = null;

		public function get tween():Tween
		{
			return this._tween;
		}

		/**
		 * @private
		 */
		protected var _juggler:Juggler = null;

		public function get juggler():Juggler
		{
			return this._juggler;
		}

		/**
		 * @private
		 */
		public function set juggler(value:Juggler):void
		{
			if(this._juggler === value)
			{
				return;
			}
			var oldJuggler:Juggler = this._juggler;
			if(oldJuggler === null)
			{
				oldJuggler = Starling.juggler;
			}
			this._juggler = value;
			if(this._playing && this._juggler !== oldJuggler)
			{
				oldJuggler.remove(this._tween);
				if(this._juggler !== null)
				{
					this._juggler.add(this._tween);
				}
				else
				{
					this._playing = false;
				}
			}
		}

		/**
		 * @private
		 */
		protected var _easeEnabled:Boolean = true;

		public function get easeEnabled():Boolean
		{
			return this._easeEnabled;
		}

		/**
		 * @private
		 */
		public function set easeEnabled(value:Boolean):void
		{
			if(this._easeEnabled === value)
			{
				return;
			}
			this._easeEnabled = value;
			this.resetTransitionFunction();
		}

		/**
		 * Sets the position of the tween using a value between <code>0</code> and <code>1</code>.
		 */
		public function get position():Number
		{
			return this._tween.currentTime / this._tween.totalTime;
		}

		/**
		 * @private
		 */
		public function set position(value:Number):void
		{
			if(value > MAX_POSITION)
			{
				value = MAX_POSITION;
			}
			var newCurrentTime:Number = value * this._tween.totalTime;
			this._tween.advanceTime(newCurrentTime - this._tween.currentTime);
		}

		public function play():void
		{
			if(this._playing)
			{
				if(this._reversed)
				{
					this._reversed = false;
					this.resetTransitionFunction();
				}
				return;
			}
			this._playing = true;
			this._reversed = false;
			this._tween.onComplete = tween_onComplete;
			var juggler:Juggler = this._juggler;
			if(juggler === null)
			{
				juggler = Starling.juggler;
			}
			juggler.add(this._tween);
		}

		public function playReverse():void
		{
			if(this._playing)
			{
				if(!this._reversed)
				{
					this._reversed = true;
					this.resetTransitionFunction();
				}
				return;
			}
			this._playing = true;
			this._reversed = true;
			this._tween.transitionFunc = this.reverseEase;
			this._tween.onComplete = tween_onComplete;
			this.position = 1 - this.position;
			var juggler:Juggler = this._juggler;
			if(juggler === null)
			{
				juggler = Starling.juggler;
			}
			juggler.add(this._tween);
		}

		public function pause():void
		{
			if(!this._playing)
			{
				return;
			}
			this._playing = false;
			this._tween.removeEventListener(Event.COMPLETE, tween_onComplete);
			var juggler:Juggler = this._juggler;
			if(juggler === null)
			{
				juggler = Starling.juggler;
			}
			juggler.remove(this._tween);
		}

		/**
		 * @private
		 */
		protected function resetTransitionFunction():void
		{
			if(this._reversed)
			{
				this._tween.transitionFunc = this.reverseEase;
			}
			else if(this._easeEnabled)
			{
				this._tween.transitionFunc = this._transitionFunc;
			}
			else
			{
				this._tween.transitionFunc = this._linearTransitionFunc;
			}
		}

		/**
		 * @private
		 */
		protected function reverseEase(ratio:Number):Number
		{
			if(this._easeEnabled)
			{
				return this._transitionFunc(1 - ratio);
			}
			return this._linearTransitionFunc(1 - ratio);
		}

		/**
		 * @private
		 */
		protected function tween_onComplete(...rest:Array):void
		{
			if(this._onComplete !== null)
			{
				this._onComplete.apply(this._tween, this._tween.onCompleteArgs);
			}
			this.dispatchEventWith(Event.COMPLETE);
		}
	}	
}