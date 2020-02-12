/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Interaction modes for components with a track.
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class TrackInteractionMode
	{
		/**
		 * When the track is touched, the slider's thumb jumps directly to the
		 * touch position, and the slider's <code>value</code> property is
		 * updated to match as if the thumb were dragged to that position, and
		 * the thumb may continue to be dragged until the touch ends.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const TO_VALUE:String = "toValue";

		/**
		 * When the track is touched, the <code>value</code> is increased or
		 * decreased (depending on the location of the touch) by the value of
		 * the <code>page</code> property.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const BY_PAGE:String = "byPage";
	}
}
