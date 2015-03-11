/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	public class BaseTimedMediaPlayer extends BaseMediaPlayer implements ITimedMediaPlayer
	{
		public function BaseTimedMediaPlayer()
		{
		}

		/**
		 * @private
		 */
		protected var _isPlaying:Boolean = false;

		/**
		 * Indicates if the video is currently playing or not.
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
		 * The position of the video, in seconds.
		 *
		 * @see #totalTime
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
		 * The total play time of the video, measured in seconds.
		 *
		 * @see #currentTime
		 */
		public function get totalTime():Number
		{
			return this._totalTime;
		}

		/**
		 * Toggles whether the video is playing or paused.
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
		 * Plays the video.
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
		 * Pauses the video.
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
		 * Stops the video.
		 */
		public function stop():void
		{
			this.pause();
			this.seek(0);
		}

		/**
		 * Seeks the video to a specific position, in seconds.
		 */
		public function seek(seconds:Number):void
		{
			this.seekMedia(seconds);
			this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
		}
		
		protected function playMedia():void
		{
			
		}

		protected function pauseMedia():void
		{

		}

		protected function seekMedia(seconds:Number):void
		{

		}
	}
}
