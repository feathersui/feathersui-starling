/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.events
{
	/**
	 * Event <code>type</code> constants for Feathers media player controls.
	 * This class is not a subclass of <code>starling.events.Event</code>
	 * because these constants are meant to be used with
	 * <code>dispatchEventWith()</code> and take advantage of the Starling's
	 * event object pooling. The object passed to an event listener will be of
	 * type <code>starling.events.Event</code>.
	 * 
	 * <listing version="3.0">
	 * function listener( event:Event ):void
	 * {
	 *     trace( mediaPlayer.currentTime );
	 * }
	 * mediaPlayer.addEventListener( MediaPlayerEventType.CURRENT_TIME_CHANGE, listener );</listing>
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class MediaPlayerEventType
	{
		/**
		 * Dispatched when a media player changes to the full-screen display mode
		 * or back to the normal display mode.
		 */
		public static const DISPLAY_STATE_CHANGE:String = "displayStageChange";

		/**
		 * Dispatched when a media player's playback state changes, such as when
		 * it begins playing or is paused.
		 */
		public static const PLAYBACK_STATE_CHANGE:String = "playbackStageChange";
		
		/**
		 * Dispatched when a media player's total playhead time changes.
		 */
		public static const TOTAL_TIME_CHANGE:String = "totalTimeChange";
		
		/**
		 * Dispatched when a media player's current playhead time changes.
		 */
		public static const CURRENT_TIME_CHANGE:String = "currentTimeChange";

		/**
		 * Dispatched when the original, native width or height of a video
		 * player's content is calculated.
		 */
		public static const DIMENSIONS_CHANGE:String = "dimensionsChange";

		/**
		 * Dispatched when a media player's sound transform is changed.
		 */
		public static const SOUND_TRANSFORM_CHANGE:String = "soundTransformChange";

		/**
		 * Dispatched when the media's metadata becomes available.
		 */
		public static const METADATA_RECEIVED:String = "metadataReceived";

		/**
		 * Dispatched when the media's cue point is reached.
		 */
		public static const CUE_POINT:String = "cuePoint";

		/**
		 * Dispatched when the media's XMP data is read.
		 */
		public static const XMP_DATA:String = "xmpData";

		/**
		 * Dispatched periodically when a media player's content is loading to
		 * indicate the current progress.
		 */
		public static const LOAD_PROGRESS:String = "loadProgress";

		/**
		 * Dispatched when a media player's content is fully loaded and it
		 * may be played to completion without buffering.
		 */
		public static const LOAD_COMPLETE:String = "loadComplete";
	}
}
