/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.Label;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import starling.events.Event;

	/**
	 * A specialized label that displays the current playhead time and total 
	 * running time of a media player that plays timed content.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 */
	public class TimeLabel extends Label implements IMediaPlayerControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>TimeLabel</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function TimeLabel()
		{
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			if(TimeLabel.globalStyleProvider)
			{
				return TimeLabel.globalStyleProvider;
			}
			return Label.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _mediaPlayer:ITimedMediaPlayer;

		/**
		 * @inheritDoc
		 */
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
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.CURRENT_TIME_CHANGE, mediaPlayer_currentTimeChangeHandler);
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.TOTAL_TIME_CHANGE, mediaPlayer_totalTimeChangeHandler);
			}
			this._mediaPlayer = value as ITimedMediaPlayer;
			if(this._mediaPlayer)
			{
				this._mediaPlayer.addEventListener(MediaPlayerEventType.CURRENT_TIME_CHANGE, mediaPlayer_currentTimeChangeHandler);
				this._mediaPlayer.addEventListener(MediaPlayerEventType.TOTAL_TIME_CHANGE, mediaPlayer_totalTimeChangeHandler);
			}
			this.updateText();
		}

		/**
		 * @private
		 */
		protected function updateText():void
		{
			var currentTime:Number = this._mediaPlayer ? this._mediaPlayer.currentTime : 0;
			var totalTime:Number = this._mediaPlayer ? this._mediaPlayer.totalTime : 0;
			this.text = this.secondsToTimeString(currentTime) + " / " + this.secondsToTimeString(totalTime);
		}

		/**
		 * @private
		 */
		protected function secondsToTimeString(seconds:Number):String
		{
			var hours:int = int(seconds / 3600);
			var minutes:int = int(seconds / 60);
			seconds = int(seconds - (hours * 3600) - (minutes * 60));
			var time:String = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
			if(hours > 0)
			{
				if(minutes < 10)
				{
					time = "0" + time;
				}
				time = hours + ":" + time;
			}
			return time;
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_currentTimeChangeHandler(event:Event):void
		{
			this.updateText();
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_totalTimeChangeHandler(event:Event):void
		{
			this.updateText();
		}
	}
}
