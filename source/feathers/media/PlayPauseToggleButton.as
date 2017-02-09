/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.ToggleButton;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import starling.events.Event;

	/**
	 * A specialized toggle button that controls whether a media player is
	 * playing or paused.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class PlayPauseToggleButton extends ToggleButton implements IMediaPlayerControl
	{
		/**
		 * An alternate style name to use with
		 * <code>PlayPauseToggleButton</code> to allow a theme to give it an
		 * appearance of an overlay above video. If a theme does not provide a
		 * style for an overlay play/pause button, the theme will automatically
		 * fall back to using the default play/pause button style.
		 *
		 * <p>An alternate style name should always be added to a component's
		 * <code>styleNameList</code> before the component is initialized. If
		 * the style name is added later, it will be ignored.</p>
		 *
		 * <p>In the following example, the overlay play/pause style is applied
		 * to a button:</p>
		 *
		 * <listing version="3.0">
		 * var overlayButton:PlayPauseButton = new PlayPauseButton();
		 * overlayButton.styleNameList.add( PlayPauseButton.ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON );
		 * player.addChild( overlayButton );</listing>
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const ALTERNATE_STYLE_NAME_OVERLAY_PLAY_PAUSE_TOGGLE_BUTTON:String = "feathers-overlay-play-pause-toggle-button";
		
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>PlayPauseToggleButton</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function PlayPauseToggleButton()
		{
			super();
			//we don't actually want this to toggle automatically. instead,
			//we'll update isSelected based on events dispatched by the media
			//player
			this.isToggle = false;
			this.addEventListener(Event.TRIGGERED, playPlayButton_triggeredHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return PlayPauseToggleButton.globalStyleProvider;
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
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChangeHandler);
			}
			this._mediaPlayer = value as ITimedMediaPlayer;
			this.refreshState();
			if(this._mediaPlayer)
			{
				this._mediaPlayer.addEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChangeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _touchableWhenPlaying:Boolean = true;

		/**
		 * Determines if the button may be touched when the media player is
		 * playing its content. In other words, this button will only work when
		 * the content is paused.
		 * 
		 * @default true
		 */
		public function get touchableWhenPlaying():Boolean
		{
			return this._touchableWhenPlaying;
		}

		/**
		 * @private
		 */
		public function set touchableWhenPlaying(value:Boolean):void
		{
			if(this._touchableWhenPlaying == value)
			{
				return;
			}
			this._touchableWhenPlaying = value;
		}

		/**
		 * @private
		 */
		protected function refreshState():void
		{
			if(!this._mediaPlayer)
			{
				this.isSelected = false;
				return;
			}
			this.isSelected = this._mediaPlayer.isPlaying;
			this.touchable = !this._isSelected || this._touchableWhenPlaying;
		}

		/**
		 * @private
		 */
		protected function playPlayButton_triggeredHandler(event:Event):void
		{
			this._mediaPlayer.togglePlayPause();
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_playbackStateChangeHandler(event:Event):void
		{
			this.refreshState();
		}
	}
}
