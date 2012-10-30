/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.core
{
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	[Event(name="resize",type="starling.events.ResizeEvent")]
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
	}
}
