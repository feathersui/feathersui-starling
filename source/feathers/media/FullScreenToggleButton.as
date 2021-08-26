/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

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
	 * displayed normally or in full-screen mode.
	 * 
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class FullScreenToggleButton extends ToggleButton implements IMediaPlayerControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>FullScreenToggleButton</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function FullScreenToggleButton()
		{
			super();
			//we don't actually want this to toggle automatically. instead,
			//we'll update isSelected based on events dispatched by the media
			//player
			this.isToggle = false;
			this.addEventListener(Event.TRIGGERED, fullScreenButton_triggeredHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return FullScreenToggleButton.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _mediaPlayer:VideoPlayer;

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
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.DISPLAY_STATE_CHANGE, mediaPlayer_displayStageChangeHandler);
			}
			this._mediaPlayer = value as VideoPlayer;
			if(this._mediaPlayer)
			{
				this.isSelected = this._mediaPlayer.isFullScreen;
				this._mediaPlayer.addEventListener(MediaPlayerEventType.DISPLAY_STATE_CHANGE, mediaPlayer_displayStageChangeHandler);
			}
		}
		
		/**
		 * @private
		 */
		protected function fullScreenButton_triggeredHandler(event:Event):void
		{
			this._mediaPlayer.toggleFullScreen();
		}
		
		/**
		 * @private
		 */
		protected function mediaPlayer_displayStageChangeHandler(event:Event):void
		{
			this.isSelected = this._mediaPlayer.isFullScreen;
		}
	}
}
