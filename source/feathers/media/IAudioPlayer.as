/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import flash.media.SoundTransform;

	public interface IAudioPlayer extends ITimedMediaPlayer
	{
		function get soundTransform():SoundTransform;
		function set soundTransform(value:SoundTransform):void;
	}
}
