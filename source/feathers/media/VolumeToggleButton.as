/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.ToggleButton;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.media.SoundTransform;

	import starling.events.Event;

	/**
	 * A specialized toggle button that controls whether a media player's volume
	 * is muted or not.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 */
	public class VolumeToggleButton extends ToggleButton implements IMediaPlayerControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>VolumeToggleButton</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function VolumeToggleButton()
		{
			super();
			this.addEventListener(Event.CHANGE, volumeButton_changeHandler);
		}

		/**
		 * @private
		 */
		protected var slider:VolumeSlider;

		/**
		 * @private
		 */
		protected var oldVolume:Number;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return VolumeToggleButton.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _mediaPlayer:IAudioPlayer;

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
			this._mediaPlayer = value as IAudioPlayer;
			if(this._mediaPlayer)
			{
				this.isSelected = this._mediaPlayer.soundTransform.volume == 0;
			}
			else
			{
				this.isSelected = false;
			}
		}

		/**
		 * @private
		 */
		protected function volumeButton_changeHandler(event:Event):void
		{
			var soundTransform:SoundTransform = this._mediaPlayer.soundTransform;
			if(this._isSelected)
			{
				var currentVolume:Number = soundTransform.volume;
				if(currentVolume == 0)
				{
					//volume was already zero, so we should fall back to some
					//default value
					currentVolume = 1;
				}
				this.oldVolume = currentVolume;
				soundTransform.volume = 0;
				this._mediaPlayer.soundTransform = soundTransform;
			}
			else
			{
				soundTransform.volume = this.oldVolume;
				this._mediaPlayer.soundTransform = soundTransform;
			}
		}
	}
}
