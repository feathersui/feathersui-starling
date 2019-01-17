/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.events.MediaPlayerEventType;

	import starling.errors.AbstractClassError;

	/**
	 * Dispatched when the media player's total playhead time changes.
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
	 * @see #totalTime
	 *
	 * @eventType feathers.events.MediaPlayerEventType.TOTAL_TIME_CHANGE
	 */
	[Event(name="totalTimeChange",type="starling.events.Event")]

	/**
	 * Dispatched when the media player's current playhead time changes.
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
	 * @see #currentTime
	 *
	 * @eventType feathers.events.MediaPlayerEventType.CURRENT_TIME_CHANGE
	 */
	[Event(name="currentTimeChange",type="starling.events.Event")]

	/**
	 * Dispatched when the media player's playback state changes, such as when
	 * it begins playing or is paused.
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
	 * @see #isPlaying
	 *
	 * @eventType feathers.events.MediaPlayerEventType.PLAYBACK_STATE_CHANGE
	 */
	[Event(name="playbackStateChange",type="starling.events.Event")]

	/**
	 * Dispatched when the media completes playback because the current time has
	 * reached the total time.
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
	 * An abstract superclass for media players that should implement the
	 * <code>feathers.media.ITimedMediaPlayer</code> interface.
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class BaseTimedMediaPlayer extends BaseMediaPlayer implements ITimedMediaPlayer
	{
		/**
		 * Constructor.
		 */
		public function BaseTimedMediaPlayer()
		{
			super();
			if(Object(this).constructor === BaseTimedMediaPlayer)
			{
				throw new AbstractClassError();
			}
		}

		/**
		 * @private
		 */
		protected var _isPlaying:Boolean = false;

		/**
		 * @inheritDoc
		 *
		 * @see #event:playbackStateChange feathers.events.MediaPlayerEventType.PLAYBACK_STATE_CHANGE
		 */
		public function get isPlaying():Boolean
		{
			return this._isPlaying;
		}

		/**
		 * @private
		 */
		protected var _currentTime:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @see #event:currentTimeChange feathers.events.MediaPlayerEventType.CURRENT_TIME_CHANGE
		 */
		public function get currentTime():Number
		{
			return this._currentTime;
		}

		/**
		 * @private
		 */
		protected var _totalTime:Number = 0;

		/**
		 * @inheritDoc
		 *
		 * @see #event:totalTimeChange feathers.events.MediaPlayerEventType.TOTAL_TIME_CHANGE
		 */
		public function get totalTime():Number
		{
			return this._totalTime;
		}

		/**
		 * @inheritDoc
		 *
		 * @see #isPlaying
		 * @see #play()
		 * @see #pause()
		 */
		public function togglePlayPause():void
		{
			if(this._isPlaying)
			{
				this.pause();
			}
			else
			{
				this.play();
			}
		}

		/**
		 * @inheritDoc
		 *
		 * @see #isPlaying
		 * @see #pause()
		 * @see #stop()
		 */
		public function play():void
		{
			if(this._isPlaying)
			{
				return;
			}
			this.playMedia();
			this._isPlaying = true;
			this.dispatchEventWith(MediaPlayerEventType.PLAYBACK_STATE_CHANGE);
		}

		/**
		 * @inheritDoc
		 *
		 * @see #isPlaying
		 * @see #play()
		 */
		public function pause():void
		{
			if(!this._isPlaying)
			{
				return;
			}
			this.pauseMedia();
			this._isPlaying = false;
			this.dispatchEventWith(MediaPlayerEventType.PLAYBACK_STATE_CHANGE);
		}

		/**
		 * @inheritDoc
		 *
		 * @see #isPlaying
		 * @see #play()
		 * @see #pause()
		 */
		public function stop():void
		{
			this.pause();
			this.seek(0);
		}

		/**
		 * @inheritDoc
		 */
		public function seek(seconds:Number):void
		{
			this.seekMedia(seconds);
			this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
		}

		/**
		 * Internal function that starts playing the media content. Subclasses
		 * are expected override this function with a custom implementation for
		 * their specific type of media content.
		 */
		protected function playMedia():void
		{
			
		}

		/**
		 * Internal function that pauses the media content. Subclasses are
		 * expected override this function with a custom implementation for
		 * their specific type of media content.
		 */
		protected function pauseMedia():void
		{

		}

		/**
		 * Internal function that seeks the media content to a specific playhead
		 * time, in seconds. Subclasses are expected override this function with
		 * a custom implementation for their specific type of media content.
		 */
		protected function seekMedia(seconds:Number):void
		{

		}
	}
}
