/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	[Event(name="totalTimeChange",type="starling.events.Event")]
	[Event(name="currentTimeChange",type="starling.events.Event")]
	[Event(name="playbackStageChange",type="starling.events.Event")]

	public interface ITimedMediaPlayer extends IMediaPlayer
	{
		function get currentTime():Number;
		function get totalTime():Number;
		function get isPlaying():Boolean;
		function togglePlayPause():void;
		function play():void;
		function pause():void;
		function stop():void;
		function seek(seconds:Number):void;
	}
}
