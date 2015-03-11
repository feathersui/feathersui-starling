/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	[Event(name="dimensionsChange",type="starling.events.Event")]
	
	public interface IVideoPlayer extends IAudioPlayer
	{
		function get nativeWidth():Number;
		function get nativeHeight():Number;
	}
}
