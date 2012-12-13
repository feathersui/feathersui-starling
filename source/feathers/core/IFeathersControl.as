/*
Feathers
Copyright (c) 2012 Josh Tynjala. All Rights Reserved.

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
	 * Basic interface for Feathers UI controls.
	 */
	public interface IFeathersControl
	{
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
		function get minWidth():Number;
		function set minWidth(value:Number):void;
		function get minHeight():Number;
		function set minHeight(value:Number):void;
		function get maxWidth():Number;
		function set maxWidth(value:Number):void;
		function get maxHeight():Number;
		function set maxHeight(value:Number):void;

		function get isEnabled():Boolean;
		function set isEnabled(value:Boolean):void;

		function get isInitialized():Boolean;

		function get name():String;
		function set name(value:String):void;
		function get nameList():TokenList;

		function get touchable():Boolean;
		function set touchable(value:Boolean):void;
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		function get alpha():Number;
		function set alpha(value:Number):void;
		function get rotation():Number;
		function set rotation(value:Number):void;
		function get parent():DisplayObjectContainer;

		function addEventListener(type:String, listener:Function):void;
		function removeEventListener(type:String, listener:Function):void;
		function removeEventListeners(type:String = null):void;
		function dispatchEvent(event:Event):void;
		function dispatchEventWith(type:String, bubbles:Boolean = false, data:Object = null):void;
		function hasEventListener(type:String):Boolean;
		function setSize(width:Number, height:Number):void;
		function validate():void;
		function dispose():void;
	}
}
