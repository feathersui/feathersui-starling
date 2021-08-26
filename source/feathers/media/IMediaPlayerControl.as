/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	/**
	 * An interface for sub-components added to a media player.
	 * 
	 * @see feathers.media.IMediaPlayer
	 * @see feathers.media.IAudioPlayer
	 * @see feathers.media.IVideoPlayer
	 *
	 * @productversion Feathers 2.2.0
	 */
	public interface IMediaPlayerControl
	{
		/**
		 * The media player that this component controls.
		 */
		function get mediaPlayer():IMediaPlayer;

		/**
		 * @private
		 */
		function set mediaPlayer(value:IMediaPlayer):void;
	}
}
