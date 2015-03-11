/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.ToggleButton;
	import feathers.core.ToggleGroup;

	import flash.display.Stage;

	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;

	import starling.core.Starling;
	import starling.events.Event;

	public class FullScreenToggleButton extends ToggleButton implements IMediaPlayerControl
	{
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
		protected var _mediaPlayer:VideoPlayer;

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
