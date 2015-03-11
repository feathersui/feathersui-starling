/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.Slider;

	import flash.media.SoundTransform;

	import starling.events.Event;

	public class VolumeSlider extends Slider implements IMediaPlayerControl
	{
		/**
		 * Constructor.
		 */
		public function VolumeSlider()
		{
			this.minimum = 0;
			this.maximum = 1;
			this.addEventListener(Event.CHANGE, volumeSlider_changeHandler);
		}

		/**
		 * @private
		 */
		protected var _mediaPlayer:IAudioPlayer;

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
			this._mediaPlayer = value as IAudioPlayer;
			if(this._mediaPlayer)
			{
				this.value = this._mediaPlayer.soundTransform.volume;
			}
			else
			{
				this.value = 0;
			}
		}

		/**
		 * @private
		 */
		protected function volumeSlider_changeHandler(event:Event):void
		{
			if(!this._mediaPlayer)
			{
				return;
			}
			var soundTransform:SoundTransform = this._mediaPlayer.soundTransform;
			soundTransform.volume = this._value;
			this._mediaPlayer.soundTransform = soundTransform;
		}
	}
}
