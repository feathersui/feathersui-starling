/*
 Feathers
 Copyright (c) 2012 Josh Tynjala. All Rights Reserved.

 This program is free software. You can redistribute and/or modify it in
 accordance with the terms of the accompanying license agreement.
 */
package feathers.core
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	import starling.filters.FragmentFilter;

	/**
	 * Public properties and functions from <code>starling.display.DisplayObject</code>
	 * in helpful interface form.
	 *
	 * @see starling.display.DisplayObject
	 */
	public interface IFeathersDisplayObject extends IFeathersEventDispatcher
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
		 * @private
		 */
		function get pivotX():Number;

		/**
		 * @private
		 */
		function set pivotX(value:Number):void;

		/**
		 * @private
		 */
		function get pivotY():Number;

		/**
		 * @private
		 */
		function set pivotY(value:Number):void;

		/**
		 * @private
		 */
		function get scaleX():Number;

		/**
		 * @private
		 */
		function set scaleX(value:Number):void;

		/**
		 * @private
		 */
		function get scaleY():Number;

		/**
		 * @private
		 */
		function set scaleY(value:Number):void;

		/**
		 * @private
		 */
		function get skewX():Number;

		/**
		 * @private
		 */
		function set skewX(value:Number):void;

		/**
		 * @private
		 */
		function get skewY():Number;

		/**
		 * @private
		 */
		function set skewY(value:Number):void;

		/**
		 * @private
		 */
		function get blendMode():String;

		/**
		 * @private
		 */
		function set blendMode(value:String):void;

		/**
		 * @private
		 */
		function get name():String;

		/**
		 * @private
		 */
		function set name(value:String):void;

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
		function get base():DisplayObject;

		/**
		 * @private
		 */
		function get root():DisplayObject;

		/**
		 * @private
		 */
		function get stage():Stage;

		/**
		 * @private
		 */
		function get hasVisibleArea():Boolean;

		/**
		 * @private
		 */
		function get transformationMatrix():Matrix;

		/**
		 * @private
		 */
		function get useHandCursor():Boolean;

		/**
		 * @private
		 */
		function set useHandCursor(value:Boolean):void;

		/**
		 * @private
		 */
		function get bounds():Rectangle;

		/**
		 * @private
		 */
		function get filter():FragmentFilter;

		/**
		 * @private
		 */
		function set filter(value:FragmentFilter):void;

		/**
		 * @private
		 */
		function removeFromParent(dispose:Boolean = false):void;

		/**
		 * @private
		 */
		function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject;

		/**
		 * @private
		 */
		function localToGlobal(localPoint:Point, resultPoint:Point=null):Point;

		/**
		 * @private
		 */
		function globalToLocal(globalPoint:Point, resultPoint:Point=null):Point;

		/**
		 * @private
		 */
		function getTransformationMatrix(targetSpace:DisplayObject, resultMatrix:Matrix = null):Matrix;

		/**
		 * @private
		 */
		function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle;

		/**
		 * @private
		 */
		function render(support:RenderSupport, parentAlpha:Number):void;

		/**
		 * @private
		 */
		function dispose():void;
	}
}
