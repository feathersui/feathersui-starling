/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.effectClasses
{
	import starling.events.EventDispatcher;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.animation.Tween;
	import starling.events.Event;
	import starling.errors.AbstractClassError;
	import starling.animation.Transitions;

	/**
	 * Dispatched when the effect is complete.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.COMPLETE
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * An effect context for a <code>starling.animation.Tween</code>.
	 * 
	 * @see http://doc.starling-framework.org/core/starling/animation/Tween.html starling.animation.Tween
	 */
	public class BaseEffectContext extends EventDispatcher implements IEffectContext
	{
		/**
		 * @private
		 */
		private static const MAX_POSITION:Number = 0.99999;

		/**
		 * Constructor.
		 */
		public function BaseEffectContext(duration:Number, transition:Object = null)
		{
			super();
			if(Object(this).constructor === BaseEffectContext)
			{
				throw new AbstractClassError();
			}
			this._duration = duration;
			if(transition === null)
			{
				transition = Transitions.LINEAR;
			}
			this._transition = transition;
			this.prepareEffect();
		}

		/**
		 * @private
		 */
		protected var _playTween:Tween = null;

		/**
		 * @private
		 */
		protected var _duration:Number;

		/**
		 * The duration of the effect, in seconds.
		 */
		public function get duration():Number
		{
			return this._duration;
		}

		/**
		 * @private
		 */
		protected var _transition:Object = null;

		/**
		 * The transition used for the effect.
		 * 
		 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
		 */
		public function get transition():Object
		{
			return this._transition;
		}

		/**
		 * @private
		 */
		protected var _position:Number = 0;

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
		protected var _juggler:Juggler = null;

		/**
		 * The <code>Juggler</code> used to update the effect when it is
		 * playing.
		 * 
		 * @see http://doc.starling-framework.org/core/starling/animation/Juggler.html starling.animation.Juggler
		 */
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
				oldJuggler.remove(this._playTween);
				if(this._juggler !== null)
				{
					this._juggler.add(this._playTween);
				}
				else
				{
					this._playing = false;
				}
			}
		}

		/**
		 * Sets the position of the tween using a value between <code>0</code>
		 * and <code>1</code>.
		 * 
		 * @see #duration
		 */
		public function get position():Number
		{
			return this._position;
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
			this._position = value;
			this.updateEffect();
		}

		/**
		 * @inheritDoc
		 */
		public function play():void
		{
			if(this._playing && !this._reversed)
			{
				//already playing in the correct direction
				return;
			}
			if(this._playTween !== null)
			{
				this._playTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
				this._playTween = null;
			}
			this._playing = true;
			this._reversed = false;

			var duration:Number = this._duration * (1 - this._position);
			this._playTween = new Tween(this, duration, this._transition);
			this._playTween.animate("position", 1);
			this._playTween.onComplete = this.playTween_onComplete;

			var juggler:Juggler = this._juggler;
			if(juggler === null)
			{
				juggler = Starling.juggler;
			}
			juggler.add(this._playTween);
		}

		/**
		 * @inheritDoc
		 */
		public function playReverse():void
		{
			if(this._playing && this._reversed)
			{
				//already playing in the correct direction
				return;
			}
			if(this._playTween !== null)
			{
				this._playTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
				this._playTween = null;
			}
			this._playing = true;
			this._reversed = true;

			var duration:Number = this._duration * this._position;
			this._playTween = new Tween(this, duration, this._transition);
			this._playTween.animate("position", 0);
			this._playTween.onComplete = this.playTween_onComplete;

			var juggler:Juggler = this._juggler;
			if(juggler === null)
			{
				juggler = Starling.juggler;
			}
			juggler.add(this._playTween);
		}

		/**
		 * @inheritDoc
		 */
		public function pause():void
		{
			if(!this._playing)
			{
				return;
			}
			if(this._playTween !== null)
			{
				this._playTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
				this._playTween = null;
			}
			this._playing = false;
		}

		/**
		 * @inheritDoc
		 */
		public function stop():void
		{
			this.pause();
			this.cleanupEffect();
			this.dispatchEventWith(Event.COMPLETE);
		}

		/**
		 * @inheritDoc
		 */
		public function toEnd():void
		{
			if(this._playing)
			{
				this._position = 1;
				this._playTween.advanceTime(this._playTween.totalTime);
				return;
			}
			this.position = 1;
			this.cleanupEffect();
			this.dispatchEventWith(Event.COMPLETE);
		}

		/**
		 * Called when the effect is initialized. Subclasses may
		 * override this method to customize the effect's behavior.
		 */
		protected function prepareEffect():void
		{

		}

		/**
		 * Called when the effect's position is updated. Subclasses may
		 * override this method to customize the effect's behavior.
		 */
		protected function updateEffect():void
		{

		}

		/**
		 * Called when the effect completes. Subclasses may
		 * override this method to customize the effect's behavior.
		 */
		protected function cleanupEffect():void
		{

		}

		/**
		 * @private
		 */
		protected function playTween_onComplete():void
		{
			this._playTween = null;
			this.cleanupEffect();
			this.dispatchEventWith(Event.COMPLETE);
		}

	}
}