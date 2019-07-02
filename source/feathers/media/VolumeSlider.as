/*
Feathers
Copyright 2012-2019 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.Slider;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.media.SoundTransform;

	import starling.events.Event;

	/**
	 * A specialized slider that controls the volume of a media player that
	 * plays audio content.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class VolumeSlider extends Slider implements IMediaPlayerControl
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * minimum track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-volume-slider-minimum-track";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * maximum track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-volume-slider-maximum-track";

		/**
		 * The default value added to the <code>styleNameList</code> of the thumb.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-volume-slider-thumb";
		
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>VolumeSlider</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function VolumeSlider()
		{
			super();
			this.thumbStyleName = VolumeSlider.DEFAULT_CHILD_STYLE_NAME_THUMB;
			this.minimumTrackStyleName = VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK;
			this.maximumTrackStyleName = VolumeSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK;
			this.minimum = 0;
			this.maximum = 1;
			this.addEventListener(Event.CHANGE, volumeSlider_changeHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return VolumeSlider.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _ignoreChanges:Boolean = false;

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
			this.refreshVolumeFromMediaPlayer();
			if(this._mediaPlayer)
			{
				this._mediaPlayer.addEventListener(MediaPlayerEventType.SOUND_TRANSFORM_CHANGE, mediaPlayer_soundTransformChangeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function refreshVolumeFromMediaPlayer():void
		{
			var oldIgnoreChanges:Boolean = this._ignoreChanges;
			this._ignoreChanges = true;
			if(this._mediaPlayer)
			{
				this.value = this._mediaPlayer.soundTransform.volume;
			}
			else
			{
				this.value = 0;
			}
			this._ignoreChanges = oldIgnoreChanges;
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_soundTransformChangeHandler(event:Event):void
		{
			this.refreshVolumeFromMediaPlayer();
		}

		/**
		 * @private
		 */
		protected function volumeSlider_changeHandler(event:Event):void
		{
			if(!this._mediaPlayer || this._ignoreChanges)
			{
				return;
			}
			var soundTransform:SoundTransform = this._mediaPlayer.soundTransform;
			soundTransform.volume = this._value;
			this._mediaPlayer.soundTransform = soundTransform;
		}
	}
}
