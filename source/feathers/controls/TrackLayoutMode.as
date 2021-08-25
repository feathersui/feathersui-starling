/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Layout modes for components with a thumb that is dragged along a track.
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class TrackLayoutMode
	{
		/**
		 * The component has only one track, that fills its full length.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const SINGLE:String = "single";

		/**
		 * The component has multiple tracks, meeting in the middle of the thumb
		 * and filling the available space on each side. The tracks will be
		 * resized as the thumb moves.
		 * 
		 * <p>This track layout mode is designed for components where the track
		 * on different sides of the thumb may be colored differently to show
		 * the value "filling up" as the thumb is dragged.</p>
		 *
		 * <p>Since the tracks will be resized when the thumb is dragged,
		 * consider using a display object that is capable of resizing without
		 * distortion, such as an <code>Image</code> with a
		 * <code>scale9Grid</code> or a <code>tileGrid</code>.</p>
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const SPLIT:String = "split";
	}
}
