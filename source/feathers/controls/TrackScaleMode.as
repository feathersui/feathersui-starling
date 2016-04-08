/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * How the track is sized perpendicular to the direction it is dragged.
	 */
	public class TrackScaleMode
	{
		/**
		 * The track dimensions fill the full width and height of the component.
		 */
		public static const EXACT_FIT:String = "exactFit";

		/**
		 * If the component's direction is horizontal, the width of the track
		 * will fill the full width of the component, and if the component's
		 * direction is vertical, the height of the track will fill the full
		 * height of the component. The other edge will not be scaled, and its
		 * preferred size will be used instead.
		 */
		public static const DIRECTIONAL:String = "directional";
	}
}
