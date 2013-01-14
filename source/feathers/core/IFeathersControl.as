/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

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
	public interface IFeathersControl
	{
		/**
		 * @private
		 */
		function get x():Number;

		/**
		 * @private
		 */
		function set x(value:Number):void;

		/**
		 * @private
		 */
		function get y():Number;

		/**
		 * @private
		 */
		function set y(value:Number):void;

		/**
		 * @private
		 */
		function get width():Number;

		/**
		 * @private
		 */
		function set width(value:Number):void;

		/**
		 * @private
		 */
		function get height():Number;

		/**
		 * @private
		 */
		function set height(value:Number):void;

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
		 * @private
		 */
		function get name():String;

		/**
		 * @private
		 */
		function set name(value:String):void;

		/**
		 * @copy feathers.core.FeathersControl#nameList
		 */
		function get nameList():TokenList;

		/**
		 * @private
		 */
		function get touchable():Boolean;

		/**
		 * @private
		 */
		function set touchable(value:Boolean):void;

		/**
		 * @private
		 */
		function get visible():Boolean;

		/**
		 * @private
		 */
		function set visible(value:Boolean):void;

		/**
		 * @private
		 */
		function get alpha():Number;

		/**
		 * @private
		 */
		function set alpha(value:Number):void;

		/**
		 * @private
		 */
		function get rotation():Number;

		/**
		 * @private
		 */
		function set rotation(value:Number):void;

		/**
		 * @private
		 */
		function get parent():DisplayObjectContainer;

		/**
		 * @private
		 */
		function addEventListener(type:String, listener:Function):void;

		/**
		 * @private
		 */
		function removeEventListener(type:String, listener:Function):void;

		/**
		 * @private
		 */
		function removeEventListeners(type:String = null):void;

		/**
		 * @private
		 */
		function dispatchEvent(event:Event):void;

		/**
		 * @private
		 */
		function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void;

		/**
		 * @private
		 */
		function hasEventListener(type:String):Boolean;

		/**
		 * @copy feathers.core.FeathersControl#setSize()
		 */
		function setSize(width:Number, height:Number):void;

		/**
		 * @copy feathers.core.FeathersControl#validate()
		 */
		function validate():void;

		/**
		 * @private
		 */
		function dispose():void;
	}
}
