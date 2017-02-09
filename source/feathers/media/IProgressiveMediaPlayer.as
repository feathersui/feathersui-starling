/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	/**
	 * Dispatched periodically when a media player's content is loading to
	 * indicate the current progress. The <code>bytesLoaded</code> and
	 * <code>bytesTotal</code> properties may be accessed to determine the
	 * exact number of bytes loaded.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>A numeric value between <code>0</code>
	 *   and <code>1</code> that indicates how much of the media has loaded so far.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see #bytesLoaded
	 * @see #bytesTotal
	 * 
	 * @eventType feathers.events.MediaPlayerEventType.LOAD_PROGRESS
	 */
	[Event(name="loadProgress",type="starling.events.Event")]

	/**
	 * A media player that loads its content progressively.
	 *
	 * @productversion Feathers 2.3.0
	 */
	public interface IProgressiveMediaPlayer extends IMediaPlayer
	{
		/**
		 * The number of bytes loaded for the current media.
		 * 
		 * @see #bytesTotal
		 * @see #event:loadProgress feathers.events.MediaPlayerEventType.LOAD_PROGRESS
		 */
		function get bytesLoaded():uint;

		/**
		 * The total number of bytes to load for the current media.
		 * 
		 * @see #bytesLoaded
		 * @see #event:loadProgress feathers.events.MediaPlayerEventType.LOAD_PROGRESS
		 */
		function get bytesTotal():uint;
	}
}
