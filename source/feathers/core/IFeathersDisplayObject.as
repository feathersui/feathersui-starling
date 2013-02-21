/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

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
	 * <p>Never cast an object to this type. Cast to <code>DisplayObject</code>
	 * instead. This interface exists only to support easier code hinting.</p>
	 *
	 * @see starling.display.DisplayObject
	 */
	public interface IFeathersDisplayObject extends IFeathersEventDispatcher
	{
		/**
		 * @see starling.display.DisplayObject#x
		 */
		function get x():Number;

		/**
		 * @private
		 */
		function set x(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#y
		 */
		function get y():Number;

		/**
		 * @private
		 */
		function set y(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#width
		 */
		function get width():Number;

		/**
		 * @private
		 */
		function set width(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#height
		 */
		function get height():Number;

		/**
		 * @private
		 */
		function set height(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#pivotX
		 */
		function get pivotX():Number;

		/**
		 * @private
		 */
		function set pivotX(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#pivotY
		 */
		function get pivotY():Number;

		/**
		 * @private
		 */
		function set pivotY(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#scaleX
		 */
		function get scaleX():Number;

		/**
		 * @private
		 */
		function set scaleX(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#scaleY
		 */
		function get scaleY():Number;

		/**
		 * @private
		 */
		function set scaleY(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#skewX
		 */
		function get skewX():Number;

		/**
		 * @private
		 */
		function set skewX(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#skewY
		 */
		function get skewY():Number;

		/**
		 * @private
		 */
		function set skewY(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#blendMode
		 */
		function get blendMode():String;

		/**
		 * @private
		 */
		function set blendMode(value:String):void;

		/**
		 * @see starling.display.DisplayObject#name
		 */
		function get name():String;

		/**
		 * @private
		 */
		function set name(value:String):void;

		/**
		 * @see starling.display.DisplayObject#touchable
		 */
		function get touchable():Boolean;

		/**
		 * @private
		 */
		function set touchable(value:Boolean):void;

		/**
		 * @see starling.display.DisplayObject#visible
		 */
		function get visible():Boolean;

		/**
		 * @private
		 */
		function set visible(value:Boolean):void;

		/**
		 * @see starling.display.DisplayObject#alpha
		 */
		function get alpha():Number;

		/**
		 * @private
		 */
		function set alpha(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#rotation
		 */
		function get rotation():Number;

		/**
		 * @private
		 */
		function set rotation(value:Number):void;

		/**
		 * @see starling.display.DisplayObject#parent
		 */
		function get parent():DisplayObjectContainer;

		/**
		 * @see starling.display.DisplayObject#base
		 */
		function get base():DisplayObject;

		/**
		 * @see starling.display.DisplayObject#root
		 */
		function get root():DisplayObject;

		/**
		 * @see starling.display.DisplayObject#stage
		 */
		function get stage():Stage;

		/**
		 * @see starling.display.DisplayObject#hasVisibleArea
		 */
		function get hasVisibleArea():Boolean;

		/**
		 * @see starling.display.DisplayObject#transformationMatrix
		 */
		function get transformationMatrix():Matrix;

		/**
		 * @see starling.display.DisplayObject#useHandCursor
		 */
		function get useHandCursor():Boolean;

		/**
		 * @private
		 */
		function set useHandCursor(value:Boolean):void;

		/**
		 * @see starling.display.DisplayObject#bounds
		 */
		function get bounds():Rectangle;

		/**
		 * @see starling.display.DisplayObject#filter
		 */
		function get filter():FragmentFilter;

		/**
		 * @private
		 */
		function set filter(value:FragmentFilter):void;

		/**
		 * @see starling.display.DisplayObject#removeFromParent()
		 */
		function removeFromParent(dispose:Boolean = false):void;

		/**
		 * @see starling.display.DisplayObject#hitTest()
		 */
		function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject;

		/**
		 * @see starling.display.DisplayObject#localToGlobal()
		 */
		function localToGlobal(localPoint:Point, resultPoint:Point=null):Point;

		/**
		 * @see starling.display.DisplayObject#globalToLocal()
		 */
		function globalToLocal(globalPoint:Point, resultPoint:Point=null):Point;

		/**
		 * @see starling.display.DisplayObject#getTransformationMatrix()
		 */
		function getTransformationMatrix(targetSpace:DisplayObject, resultMatrix:Matrix = null):Matrix;

		/**
		 * @see starling.display.DisplayObject#getBounds()
		 */
		function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle;

		/**
		 * @see starling.display.DisplayObject#render()
		 */
		function render(support:RenderSupport, parentAlpha:Number):void;

		/**
		 * @see starling.display.DisplayObject#dispose()
		 */
		function dispose():void;
	}
}
