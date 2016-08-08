/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * A display object with extra measurement properties.
	 */
	public interface IMeasureDisplayObject extends IFeathersDisplayObject
	{
		/**
		 * @copy feathers.core.FeathersControl#explicitWidth
		 */
		function get explicitWidth():Number;

		/**
		 * @copy feathers.core.FeathersControl#explicitMinWidth
		 */
		function get explicitMinWidth():Number;

		/**
		 * @copy feathers.core.FeathersControl#minWidth
		 */
		function get minWidth():Number;

		/**
		 * @private
		 */
		function set minWidth(value:Number):void;

		/**
		 * @copy feathers.core.FeathersControl#explicitMaxWidth
		 */
		function get explicitMaxWidth():Number;

		/**
		 * @copy feathers.core.FeathersControl#maxWidth
		 */
		function get maxWidth():Number;

		/**
		 * @private
		 */
		function set maxWidth(value:Number):void;

		/**
		 * @copy feathers.core.FeathersControl#explicitHeight
		 */
		function get explicitHeight():Number;

		/**
		 * @copy feathers.core.FeathersControl#explicitMinHeight
		 */
		function get explicitMinHeight():Number;

		/**
		 * @copy feathers.core.FeathersControl#minHeight
		 */
		function get minHeight():Number;

		/**
		 * @private
		 */
		function set minHeight(value:Number):void;

		/**
		 * @copy feathers.core.FeathersControl#explicitMaxHeight
		 */
		function get explicitMaxHeight():Number;

		/**
		 * @copy feathers.core.FeathersControl#maxHeight
		 */
		function get maxHeight():Number;

		/**
		 * @private
		 */
		function set maxHeight(value:Number):void;
	}
}
