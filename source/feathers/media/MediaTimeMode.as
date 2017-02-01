/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	/**
	 * Formats for media playback time.
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class MediaTimeMode
	{
		/**
		 * The label displays only the current time of the media content.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const CURRENT_TIME:String = "currentTime";

		/**
		 * The label displays only the total time of the media content.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const TOTAL_TIME:String = "totalTime";

		/**
		 * The label displays only the remaining time of the media content. In
		 * other words, the total time minus the current time.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const REMAINING_TIME:String = "remainingTime";

		/**
		 * The label displays the current time of the media content, followed by
		 * the total time of the media content.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const CURRENT_AND_TOTAL_TIMES:String = "currentAndTotalTimes";
	}
}
