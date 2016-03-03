/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	/**
	 * Dispatched when the original, native width or height of the video content
	 * is calculated.
	 * 
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 * 
	 * @see #nativeWidth
	 * @see #nativeHeight
	 *
	 * @eventType feathers.events.MediaPlayerEventType.DIMENSIONS_CHANGE
	 */
	[Event(name="dimensionsChange",type="starling.events.Event")]

	/**
	 * An interface media players that play video content.
	 */
	public interface IVideoPlayer extends IAudioPlayer
	{
		/**
		 * The original, native width of the loaded video.
		 * 
		 * @see #event:dimensionsChange feathers.events.MediaPlayerEventType.DIMENSIONS_CHANGE
		 */
		function get nativeWidth():Number;
		
		/**
		 * The original, native height of the loaded video.
		 *
		 * @see #event:dimensionsChange feathers.events.MediaPlayerEventType.DIMENSIONS_CHANGE
		 */
		function get nativeHeight():Number;
	}
}
