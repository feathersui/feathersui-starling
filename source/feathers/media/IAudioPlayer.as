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
	 * Dispatched when the media player's sound transform changes.
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
	 * @see #soundTransform
	 *
	 * @eventType feathers.events.MediaPlayerEventType.SOUND_TRANSFORM_CHANGE
	 */
	[Event(name="soundTransformChange",type="starling.events.Event")]

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
		 * @see #event:soundTransformChange feathers.events.MediaPlayerEventType.SOUND_TRANSFORM_CHANGE
		 */
		function get soundTransform():SoundTransform;

		/**
		 * @private
		 */
		function set soundTransform(value:SoundTransform):void;
	}
}
