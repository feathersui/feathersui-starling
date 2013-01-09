/*
 Feathers
 Copyright (c) 2012 Josh Tynjala. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it in
 accordance with the terms of the accompanying license agreement.
 */
package feathers.layout
{
	import feathers.core.IFeathersDisplayObject;

	/**
	 * A display object that may be associated with extra data for use with
	 * advanced layouts.
	 */
	public interface ILayoutObject extends IFeathersDisplayObject
	{
		/**
		 * Extra parameters associated with this display object that will be
		 * used by the layout algorithm.
		 */
		function get layoutData():Object;

		/**
		 * @private
		 */
		function set layoutData(value:Object):void;
	}
}
