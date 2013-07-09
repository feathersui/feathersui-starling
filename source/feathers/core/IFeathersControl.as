/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.geom.Rectangle;

	/**
	 * Dispatched after the control has been initialized, but before it has
	 * drawn for the first time. Typically, the component's children will have
	 * been created by this point.
	 *
	 * @eventType feathers.events.FeathersEventType.INITIALIZE
	 */
	[Event(name="initialize",type="starling.events.Event")]

	/**
	 * Dispatched when the width or height of the control changes.
	 *
	 * @eventType feathers.events.FeathersEventType.RESIZE
	 */
	[Event(name="resize",type="starling.events.Event")]

	/**
	 * Basic interface for Feathers UI controls. A Feathers control must also
	 * be a Starling display object.
	 */
	public interface IFeathersControl extends IFeathersDisplayObject
	{
		/**
		 * @copy feathers.core.FeathersControl#minWidth
		 */
		function get minWidth():Number;

		/**
		 * @private
		 */
		function set minWidth(value:Number):void;

		/**
		 * @copy feathers.core.FeathersControl#minHeight
		 */
		function get minHeight():Number;

		/**
		 * @private
		 */
		function set minHeight(value:Number):void;

		/**
		 * @copy feathers.core.FeathersControl#maxWidth
		 */
		function get maxWidth():Number;

		/**
		 * @private
		 */
		function set maxWidth(value:Number):void;

		/**
		 * @copy feathers.core.FeathersControl#maxHeight
		 */
		function get maxHeight():Number;

		/**
		 * @private
		 */
		function set maxHeight(value:Number):void;

		/**
		 * @private
		 */
		function get clipRect():Rectangle;

		/**
		 * @private
		 */
		function set clipRect(value:Rectangle):void;

		/**
		 * @copy feathers.core.FeathersControl#isEnabled
		 */
		function get isEnabled():Boolean;

		/**
		 * @private
		 */
		function set isEnabled(value:Boolean):void;

		/**
		 * @copy feathers.core.FeathersControl#isInitialized
		 */
		function get isInitialized():Boolean;

		/**
		 * @copy feathers.core.FeathersControl#nameList
		 */
		function get nameList():TokenList;

		/**
		 * @copy feathers.core.FeathersControl#setSize()
		 */
		function setSize(width:Number, height:Number):void;

		/**
		 * @copy feathers.core.FeathersControl#validate()
		 */
		function validate():void;
	}
}
