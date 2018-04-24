/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

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
		[Deprecated(replacement="feathers.layout.Direction.HORIZONTAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.HORIZONTAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		[Deprecated(replacement="feathers.layout.Direction.VERTICAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.VERTICAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		[Deprecated(replacement="feathers.controls.TrackLayoutMode.SINGLE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackLayoutMode.SINGLE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";

		[Deprecated(replacement="feathers.controls.TrackLayoutMode.SPLIT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackLayoutMode.SPLIT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_LAYOUT_MODE_MIN_MAX:String = "minMax";

		[Deprecated(replacement="feathers.controls.TrackScaleMode.EXACT_FIT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackScaleMode.EXACT_FIT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_SCALE_MODE_EXACT_FIT:String = "exactFit";

		[Deprecated(replacement="feathers.controls.TrackScaleMode.DIRECTIONAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackScaleMode.DIRECTIONAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_SCALE_MODE_DIRECTIONAL:String = "directional";

		[Deprecated(replacement="feathers.controls.TrackInteractionMode.TO_VALUE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackInteractionMode.TO_VALUE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_INTERACTION_MODE_TO_VALUE:String = "toValue";

		[Deprecated(replacement="feathers.controls.TrackInteractionMode.BY_PAGE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackInteractionMode.BY_PAGE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_INTERACTION_MODE_BY_PAGE:String = "byPage";

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
