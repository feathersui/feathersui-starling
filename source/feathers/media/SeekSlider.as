/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.Slider;

	import starling.events.Event;

	public class SeekSlider extends Slider implements IMediaPlayerControl
	{
		/**
		 * Constructor.
		 */
		public function SeekSlider()
		{
			this.addEventListener(Event.CHANGE, seekSlider_changeHandler);
		}

		/**
		 * @private
		 */
		protected var _mediaPlayer:ITimedMediaPlayer;

		public function get mediaPlayer():IMediaPlayer
		{
			return this._mediaPlayer;
		}

		/**
		 * @private
		 */
		public function set mediaPlayer(value:IMediaPlayer):void
		{
			if(this._mediaPlayer == value)
			{
				return;
			}
			if(this._mediaPlayer)
			{
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChangeHandler);
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.CURRENT_TIME_CHANGE, mediaPlayer_currentTimeChangeHandler);
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.TOTAL_TIME_CHANGE, mediaPlayer_totalTimeChangeHandler);
			}
			this._mediaPlayer = value as ITimedMediaPlayer;
			if(this._mediaPlayer)
			{
				this._mediaPlayer.addEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChangeHandler);
				this._mediaPlayer.addEventListener(MediaPlayerEventType.CURRENT_TIME_CHANGE, mediaPlayer_currentTimeChangeHandler);
				this._mediaPlayer.addEventListener(MediaPlayerEventType.TOTAL_TIME_CHANGE, mediaPlayer_totalTimeChangeHandler);
				this.minimum = 0;
				this.maximum = this._mediaPlayer.totalTime;
				this.value = this._mediaPlayer.currentTime;
			}
			else
			{
				this.minimum = 0;
				this.maximum = 0;
				this.value = 0;
			}
		}

		/**
		 * @private
		 */
		protected function seekSlider_changeHandler(event:Event):void
		{
			if(!this._mediaPlayer)
			{
				return;
			}
			this._mediaPlayer.seek(this._value);
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_playbackStateChangeHandler(event:Event):void
		{
			if(!this._mediaPlayer.isPlaying)
			{
				this._touchPointID = -1;
			}
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_currentTimeChangeHandler(event:Event):void
		{
			if(this.isDragging)
			{
				//if we're currently dragging, ignore changes by the player
				return;
			}
			this._value = this._mediaPlayer.currentTime;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_totalTimeChangeHandler(event:Event):void
		{
			this.maximum = this._mediaPlayer.totalTime;
		}
		
	}
}
