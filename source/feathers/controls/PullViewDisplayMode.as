/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Constants that define how pull views are displayed in a container.
	 *
	 * @productversion Feathers 3.2.0
	 */
	public class PullViewDisplayMode
	{
		/**
		 * The pull view is fixed to the edge of the the scroller's view port.
		 * If <code>hasElasticEdges</code> is <code>true</code>, the pull view
		 * will be revealed under the scroller's content. If
		 * <code>hasElasticEdges</code> is <code>false</code>, the pull view
		 * will fade in above the scroller's content.
		 *
		 * @productversion Feathers 3.2.0
		 */
		public static const FIXED:String = "fixed";

		/**
		 * The pull view may be dragged with the scroller's content. If
		 * <code>hasElasticEdges</code> is <code>false</code>, and the scroll
		 * position reaches the minimum or maximum, the pull view may be dragged
		 * while the content remains fixed.
		 *
		 * @productversion Feathers 3.2.0
		 */
		public static const DRAG:String = "drag";
	}
}
