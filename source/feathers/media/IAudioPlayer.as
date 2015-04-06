/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import flash.media.SoundTransform;

	/**
	 * An interface for media players that play audio content.
	 */
	public interface IAudioPlayer extends ITimedMediaPlayer
	{
		/**
		 * Controls properties of the currently playing audio, like volume and
		 * panning.
		 * 
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/SoundTransform.html flash.media.SoundTransform
		 */
		function get soundTransform():SoundTransform;

		/**
		 * @private
		 */
		function set soundTransform(value:SoundTransform):void;
	}
}
