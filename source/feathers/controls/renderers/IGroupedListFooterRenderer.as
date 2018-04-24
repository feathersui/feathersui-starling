/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.renderers
{
	import feathers.controls.GroupedList;
	import feathers.core.IFeathersControl;

	/**
	 * Interface to implement a renderer for a grouped list footer.
	 *
	 * @see feathers.controls.GroupedList
	 *
	 * @productversion Feathers 2.3.0
	 */
	public interface IGroupedListFooterRenderer extends IFeathersControl
	{
		/**
		 * Data for a footer renderer from the grouped list's data provider.
		 * A footer renderer should be designed with the assumption that its
		 * <code>data</code> will change as the list scrolls.
		 *
		 * <p>This property is set automatically by the list, and it should not
		 * be set manually.</p>
		 */
		function get data():Object;

		/**
		 * @private
		 */
		function set data(value:Object):void;

		/**
		 * The index of the group within the data provider of the grouped list.
		 *
		 * <p>This property is set automatically by the list, and it should not
		 * be set manually.</p>
		 */
		function get groupIndex():int;

		/**
		 * @private
		 */
		function set groupIndex(value:int):void;

		/**
		 * The index of this display object within the layout.
		 *
		 * <p>This property is set automatically by the list, and it should not
		 * be set manually.</p>
		 */
		function get layoutIndex():int;

		/**
		 * @private
		 */
		function set layoutIndex(value:int):void;

		/**
		 * The grouped list that contains this footer renderer.
		 *
		 * <p>This property is set automatically by the list, and it should not
		 * be set manually.</p>
		 */
		function get owner():GroupedList;

		/**
		 * @private
		 */
		function set owner(value:GroupedList):void;

		/**
		 * The ID of the factory used to create this footer renderer.
		 *
		 * <p>This property is set by the list, and should not be set manually.</p>
		 */
		function get factoryID():String;

		/**
		 * @private
		 */
		function set factoryID(value:String):void;
	}
}
